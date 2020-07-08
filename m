Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD7021860F
	for <lists+kvm-ppc@lfdr.de>; Wed,  8 Jul 2020 13:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgGHLZ7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 8 Jul 2020 07:25:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27150 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728666AbgGHLZ7 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 8 Jul 2020 07:25:59 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 068B20DW094805;
        Wed, 8 Jul 2020 07:25:41 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3251mva5hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 07:25:41 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 068BAkuR015452;
        Wed, 8 Jul 2020 11:25:39 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 322h1h4d4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 11:25:39 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 068BOFMb60424510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jul 2020 11:24:15 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 752655204E;
        Wed,  8 Jul 2020 11:25:36 +0000 (GMT)
Received: from in.ibm.com (unknown [9.85.75.251])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 5857052051;
        Wed,  8 Jul 2020 11:25:34 +0000 (GMT)
Date:   Wed, 8 Jul 2020 16:55:31 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@samba.org, bauerman@linux.ibm.com, sukadev@linux.ibm.com,
        sathnaga@linux.vnet.ibm.com, Ram Pai <linuxram@us.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>
Subject: Re: [PATCH 2/2] KVM: PPC: Book3S HV: rework secure mem slot dropping
Message-ID: <20200708112531.GA7902@in.ibm.com>
Reply-To: bharata@linux.ibm.com
References: <20200703155914.40262-1-ldufour@linux.ibm.com>
 <20200703155914.40262-3-ldufour@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200703155914.40262-3-ldufour@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-08_07:2020-07-08,2020-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 mlxscore=0 malwarescore=0 adultscore=0 suspectscore=5 cotscore=-2147483648
 lowpriorityscore=0 bulkscore=0 mlxlogscore=886 priorityscore=1501
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007080075
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Jul 03, 2020 at 05:59:14PM +0200, Laurent Dufour wrote:
> When a secure memslot is dropped, all the pages backed in the secure device
> (aka really backed by secure memory by the Ultravisor) should be paged out
> to a normal page. Previously, this was achieved by triggering the page
> fault mechanism which is calling kvmppc_svm_page_out() on each pages.
> 
> This can't work when hot unplugging a memory slot because the memory slot
> is flagged as invalid and gfn_to_pfn() is then not trying to access the
> page, so the page fault mechanism is not triggered.
> 
> Since the final goal is to make a call to kvmppc_svm_page_out() it seems
> simpler to directly calling it instead of triggering such a mechanism. This
> way kvmppc_uvmem_drop_pages() can be called even when hot unplugging a
> memslot.

Yes, this appears much simpler.

> 
> Since kvmppc_uvmem_drop_pages() is already holding kvm->arch.uvmem_lock,
> the call to __kvmppc_svm_page_out() is made.
> As __kvmppc_svm_page_out needs the vma pointer to migrate the pages, the
> VMA is fetched in a lazy way, to not trigger find_vma() all the time. In
> addition, the mmap_sem is help in read mode during that time, not in write
> mode since the virual memory layout is not impacted, and
> kvm->arch.uvmem_lock prevents concurrent operation on the secure device.
> 
> Cc: Ram Pai <linuxram@us.ibm.com>
> Cc: Bharata B Rao <bharata@linux.ibm.com>
> Cc: Paul Mackerras <paulus@ozlabs.org>
> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_hv_uvmem.c | 54 ++++++++++++++++++++----------
>  1 file changed, 37 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
> index 852cc9ae6a0b..479ddf16d18c 100644
> --- a/arch/powerpc/kvm/book3s_hv_uvmem.c
> +++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
> @@ -533,35 +533,55 @@ static inline int kvmppc_svm_page_out(struct vm_area_struct *vma,
>   * fault on them, do fault time migration to replace the device PTEs in
>   * QEMU page table with normal PTEs from newly allocated pages.
>   */
> -void kvmppc_uvmem_drop_pages(const struct kvm_memory_slot *free,
> +void kvmppc_uvmem_drop_pages(const struct kvm_memory_slot *slot,
>  			     struct kvm *kvm, bool skip_page_out)
>  {
>  	int i;
>  	struct kvmppc_uvmem_page_pvt *pvt;
> -	unsigned long pfn, uvmem_pfn;
> -	unsigned long gfn = free->base_gfn;
> +	struct page *uvmem_page;
> +	struct vm_area_struct *vma = NULL;
> +	unsigned long uvmem_pfn, gfn;
> +	unsigned long addr, end;
> +
> +	down_read(&kvm->mm->mmap_sem);

You should be using mmap_read_lock(kvm->mm) with recent kernels.

> +
> +	addr = slot->userspace_addr;
> +	end = addr + (slot->npages * PAGE_SIZE);
>  
> -	for (i = free->npages; i; --i, ++gfn) {
> -		struct page *uvmem_page;
> +	gfn = slot->base_gfn;
> +	for (i = slot->npages; i; --i, ++gfn, addr += PAGE_SIZE) {
> +
> +		/* Fetch the VMA if addr is not in the latest fetched one */
> +		if (!vma || (addr < vma->vm_start || addr >= vma->vm_end)) {
> +			vma = find_vma_intersection(kvm->mm, addr, end);
> +			if (!vma ||
> +			    vma->vm_start > addr || vma->vm_end < end) {
> +				pr_err("Can't find VMA for gfn:0x%lx\n", gfn);
> +				break;
> +			}
> +		}

The first find_vma_intersection() was called for the range spanning the
entire memslot, but you have code to check if vma remains valid for the
new addr in each iteration. Guess you wanted to get vma for one page at
a time and use it for subsequent pages until it covers the range?

Regards,
Bharata.
