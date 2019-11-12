Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D152F881C
	for <lists+kvm-ppc@lfdr.de>; Tue, 12 Nov 2019 06:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725283AbfKLFin (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 12 Nov 2019 00:38:43 -0500
Received: from ozlabs.org ([203.11.71.1]:41807 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfKLFin (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 12 Nov 2019 00:38:43 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 47BxPD2xJtz9sP3; Tue, 12 Nov 2019 16:38:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1573537120; bh=SZoRRTRm9ztAOpkmJzAzQX6odqFqiF8GoxUebpLCgpc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hQVWmXDmoBI0+5xEt5CjywarL2yoySowzmAqTVwVg1xkSnDUgP/aU/UML3IcaW4O1
         0JC0EzBb7RM+zH9EvbepmZRmTR/OJaFv7mn9NDOpFncCFKJha5Ur6FigHCBoIxbIt2
         +l6CjnPsLU7W2Cmsgm5Ix3Hx20pHhHAMqRqxmBjU1TaxhW/UdZxiJuYSvRe1EZNNpa
         51XwLhASGKTEueiKLuNJElxxNM5Ye28r+nyJCqBju1dcp3PUuYi4Ne4aIE5HKFJ9KR
         rH1nu1co4WZywoaXY/Rx+ww2ZHRGl8nCb0OIVp/AQYJMVKrExItkOArcA7oQS+heg4
         wnpzJJGUtPlJg==
Date:   Tue, 12 Nov 2019 16:38:36 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     Bharata B Rao <bharata@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        cclaudio@linux.ibm.com, sukadev@linux.vnet.ibm.com, hch@lst.de,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Ram Pai <linuxram@linux.ibm.com>
Subject: Re: [PATCH v10 7/8] KVM: PPC: Implement H_SVM_INIT_ABORT hcall
Message-ID: <20191112053836.GB10885@oak.ozlabs.ibm.com>
References: <20191104041800.24527-1-bharata@linux.ibm.com>
 <20191104041800.24527-8-bharata@linux.ibm.com>
 <20191111041924.GA4017@oak.ozlabs.ibm.com>
 <20191112010158.GB5159@oc0525413822.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112010158.GB5159@oc0525413822.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Nov 11, 2019 at 05:01:58PM -0800, Ram Pai wrote:
> On Mon, Nov 11, 2019 at 03:19:24PM +1100, Paul Mackerras wrote:
> > On Mon, Nov 04, 2019 at 09:47:59AM +0530, Bharata B Rao wrote:
> > > From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> > > 
> > > Implement the H_SVM_INIT_ABORT hcall which the Ultravisor can use to
> > > abort an SVM after it has issued the H_SVM_INIT_START and before the
> > > H_SVM_INIT_DONE hcalls. This hcall could be used when Ultravisor
> > > encounters security violations or other errors when starting an SVM.
> > > 
> > > Note that this hcall is different from UV_SVM_TERMINATE ucall which
> > > is used by HV to terminate/cleanup an SVM.
> > > 
> > > In case of H_SVM_INIT_ABORT, we should page-out all the pages back to
> > > HV (i.e., we should not skip the page-out). Otherwise the VM's pages,
> > > possibly including its text/data would be stuck in secure memory.
> > > Since the SVM did not go secure, its MSR_S bit will be clear and the
> > > VM wont be able to access its pages even to do a clean exit.
> > 
> > It seems fragile to me to have one more transfer back into the
> > ultravisor after this call.  Why does the UV need to do this call and
> > then get control back again one more time?  
> > Why can't the UV defer
> > doing this call until it can do it without expecting to see a return
> > from the hcall?  
> 
> Sure. But, what if the hypervisor calls back into the UV through a
> ucall, asking for some page to be paged-out?  If the ultravisor has
> cleaned up the state associated with the SVM, it wont be able to service
> that request.
> 
> H_SVM_INIT_ABORT is invoked to tell the hypervisor that the
> secure-state-transition for the VM cannot be continued any further.
> Hypervisor can than choose to do whatever with that information. It can
> cleanup its state, and/or make ucalls to get some information from the
> ultravisor.  It can also choose not to return control back to the ultravisor.
> 
> 
> > And if it does need to see a return from the hcall,
> > what would happen if a malicious hypervisor doesn't do the return?
> 
> That is fine.  At most it will be a denail-of-service attack.
> 
> RP
> 
> > 
> > Paul.
> 
> 
> 
> 
> 
> If the ultravisor cleans up the SVM's state on its side and then informs
> the Hypervisor to abort the SVM, the hypervisor will not be able to
> cleanly terminate the VM.  Because to terminate the SVM, the hypervisor
> still needs the services of the Ultravisor. For example: to get the
> pages back into the hypervisor if needed. Another example is, the
> hypervisor can call UV_SVM_TERMINATE.  Regardless of which ucall
> gets called, the ultravisor has to hold on to enough state of the
> SVM to service that request.

OK, that's a good reason.  That should be explained in the commit
message.

> The current design assumes that the hypervisor explicitly informs the
> ultravisor, that it is done with the SVM, through the UV_SVM_TERMINATE
> ucall. Till that point the Ultravisor must to be ready to service any
> ucalls made by the hypervisor on the SVM's behalf.

I see that UV_SVM_TERMINATE is done when the VM is being destroyed (at
which point kvm->arch.secure_guest doesn't matter any more), and in
kvmhv_svm_off(), where kvm->arch.secure_guest gets cleared
explicitly.  Hence I don't see any need for clearing it in the
assembly code on the next secure guest entry.  I think the change to
book3s_hv_rmhandlers.S can just be dropped.

Paul.
