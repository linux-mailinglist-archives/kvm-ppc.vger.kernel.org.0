Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E2F22784B
	for <lists+kvm-ppc@lfdr.de>; Tue, 21 Jul 2020 07:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgGUFqP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 21 Jul 2020 01:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgGUFqP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 21 Jul 2020 01:46:15 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4ADC061794;
        Mon, 20 Jul 2020 22:46:14 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4B9ndd2kFkz9sRW; Tue, 21 Jul 2020 15:46:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1595310373; bh=h5v/z0N4MGFxoJg1GsHzJ0zVrgcj/eMAzSW3netP+R4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bsdq3RgUQRm3imvD5OnpTg6IhTu+jJ3xjYGQIl1HU9x1bXRs1vF0znu25iSME054t
         kgBNrbyAJd80vhvitaJIyJo082/z0WyZXg3ug8ICzN+m5wlJD9AgGO2uC3STqZfsw3
         vlSPwiGL1mXsSEhB6mFQefmbrZEwzF2kF8SvjxsSJecY9SpZo87vJDZ/kQ9lwyZU4+
         pgu/igX098brmF/Dv7vpkeJ/Hl3Y3RST9TybB2Ds2Tqu4YSQyZRnxNfnBhP2ro2Pai
         NAXJRgsFjD36F8rKRfwJUxkaoWOaINJMey7cIFpL7jmKHVj7x9mx6FJ4pxE1OOjVAY
         MMZJMdokBBUiw==
Date:   Tue, 21 Jul 2020 15:46:09 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     bharata@linux.ibm.com, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, bauerman@linux.ibm.com, sukadev@linux.ibm.com,
        sathnaga@linux.vnet.ibm.com, Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH 2/2] KVM: PPC: Book3S HV: rework secure mem slot dropping
Message-ID: <20200721054609.GB3878639@thinks.paulus.ozlabs.org>
References: <20200703155914.40262-1-ldufour@linux.ibm.com>
 <20200703155914.40262-3-ldufour@linux.ibm.com>
 <20200708112531.GA7902@in.ibm.com>
 <0588d16a-8548-0f55-1132-400807a390a1@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0588d16a-8548-0f55-1132-400807a390a1@linux.ibm.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Jul 08, 2020 at 02:16:36PM +0200, Laurent Dufour wrote:
> Le 08/07/2020 à 13:25, Bharata B Rao a écrit :
> > On Fri, Jul 03, 2020 at 05:59:14PM +0200, Laurent Dufour wrote:
> > > When a secure memslot is dropped, all the pages backed in the secure device
> > > (aka really backed by secure memory by the Ultravisor) should be paged out
> > > to a normal page. Previously, this was achieved by triggering the page
> > > fault mechanism which is calling kvmppc_svm_page_out() on each pages.
> > > 
> > > This can't work when hot unplugging a memory slot because the memory slot
> > > is flagged as invalid and gfn_to_pfn() is then not trying to access the
> > > page, so the page fault mechanism is not triggered.
> > > 
> > > Since the final goal is to make a call to kvmppc_svm_page_out() it seems
> > > simpler to directly calling it instead of triggering such a mechanism. This
> > > way kvmppc_uvmem_drop_pages() can be called even when hot unplugging a
> > > memslot.
> > 
> > Yes, this appears much simpler.
> 
> Thanks Bharata for reviewing this.
> 
> > 
> > > 
> > > Since kvmppc_uvmem_drop_pages() is already holding kvm->arch.uvmem_lock,
> > > the call to __kvmppc_svm_page_out() is made.
> > > As __kvmppc_svm_page_out needs the vma pointer to migrate the pages, the
> > > VMA is fetched in a lazy way, to not trigger find_vma() all the time. In
> > > addition, the mmap_sem is help in read mode during that time, not in write
> > > mode since the virual memory layout is not impacted, and
> > > kvm->arch.uvmem_lock prevents concurrent operation on the secure device.
> > > 
> > > Cc: Ram Pai <linuxram@us.ibm.com>
> > > Cc: Bharata B Rao <bharata@linux.ibm.com>
> > > Cc: Paul Mackerras <paulus@ozlabs.org>
> > > Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
> > > ---
> > >   arch/powerpc/kvm/book3s_hv_uvmem.c | 54 ++++++++++++++++++++----------
> > >   1 file changed, 37 insertions(+), 17 deletions(-)
> > > 
> > > diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
> > > index 852cc9ae6a0b..479ddf16d18c 100644
> > > --- a/arch/powerpc/kvm/book3s_hv_uvmem.c
> > > +++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
> > > @@ -533,35 +533,55 @@ static inline int kvmppc_svm_page_out(struct vm_area_struct *vma,
> > >    * fault on them, do fault time migration to replace the device PTEs in
> > >    * QEMU page table with normal PTEs from newly allocated pages.
> > >    */
> > > -void kvmppc_uvmem_drop_pages(const struct kvm_memory_slot *free,
> > > +void kvmppc_uvmem_drop_pages(const struct kvm_memory_slot *slot,
> > >   			     struct kvm *kvm, bool skip_page_out)
> > >   {
> > >   	int i;
> > >   	struct kvmppc_uvmem_page_pvt *pvt;
> > > -	unsigned long pfn, uvmem_pfn;
> > > -	unsigned long gfn = free->base_gfn;
> > > +	struct page *uvmem_page;
> > > +	struct vm_area_struct *vma = NULL;
> > > +	unsigned long uvmem_pfn, gfn;
> > > +	unsigned long addr, end;
> > > +
> > > +	down_read(&kvm->mm->mmap_sem);
> > 
> > You should be using mmap_read_lock(kvm->mm) with recent kernels.
> 
> Absolutely, shame on me, I reviewed Michel's series about that!
> 
> Paul, Michael, could you fix that when pulling this patch or should I sent a
> whole new series?

Given that Ram has reworked his series, I think it would be best if
you rebase on top of his new series and re-send your series.

Thanks,
Paul.
