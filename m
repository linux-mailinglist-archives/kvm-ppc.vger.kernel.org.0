Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31EF6FBA8A
	for <lists+kvm-ppc@lfdr.de>; Wed, 13 Nov 2019 22:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfKMVSa (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 13 Nov 2019 16:18:30 -0500
Received: from ozlabs.org ([203.11.71.1]:58321 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbfKMVSa (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 13 Nov 2019 16:18:30 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 47CyC674r9z9sPJ; Thu, 14 Nov 2019 08:18:26 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1573679907; bh=lnQ6Uf+6ekcXWBx2OakgOJXk04mhFVIPE8vTPN8XAkY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C/8+1pW8cTZWDdvOfW1204W3C5r+j3f93aHOwPELvEGE1CePKcdfrUkx2Fd8jB4D+
         7j7Q5jrpTXh5fRYalc4Fk8JIJejcr1b/+uN44CdqbuZlMUevmWuQd17Eg8IqBuR8CX
         PfEEaSqCc8nr2JlK3OK6LWhs3/1PRRxcwqmgsCCafuBLzV3UlFtzpfP8XMNm6YkBY8
         JiE94jykz1v+g+J+jXlG/ZEsNY6vaJTPNMAlgt17cxAARGcLlqfogWY/D9yRYGT2gb
         hK/ytDiOa/PdAdMk6B6Hq8O7Ons6GAVxgRLQM9an+Acgws3mJ78VNaQt/15MB7BjSL
         VMcW2I6spK3iQ==
Date:   Thu, 14 Nov 2019 08:18:24 +1100
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
Message-ID: <20191113211824.GA20535@blackberry>
References: <20191104041800.24527-1-bharata@linux.ibm.com>
 <20191104041800.24527-8-bharata@linux.ibm.com>
 <20191111041924.GA4017@oak.ozlabs.ibm.com>
 <20191112010158.GB5159@oc0525413822.ibm.com>
 <20191112053836.GB10885@oak.ozlabs.ibm.com>
 <20191112075215.GD5159@oc0525413822.ibm.com>
 <20191112113204.GA10178@blackberry>
 <20191112144555.GE5159@oc0525413822.ibm.com>
 <20191113001427.GA17829@oak.ozlabs.ibm.com>
 <20191113063233.GF5159@oc0525413822.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113063233.GF5159@oc0525413822.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Nov 12, 2019 at 10:32:33PM -0800, Ram Pai wrote:
> On Wed, Nov 13, 2019 at 11:14:27AM +1100, Paul Mackerras wrote:
> > On Tue, Nov 12, 2019 at 06:45:55AM -0800, Ram Pai wrote:
> > > On Tue, Nov 12, 2019 at 10:32:04PM +1100, Paul Mackerras wrote:
> > > > On Mon, Nov 11, 2019 at 11:52:15PM -0800, Ram Pai wrote:
> > > > > There is subtle problem removing that code from the assembly.
> > > > > 
> > > > > If the H_SVM_INIT_ABORT hcall returns to the ultravisor without clearing
> > > > > kvm->arch.secure_guest, the hypervisor will continue to think that the
> > > > > VM is a secure VM.   However the primary reason the H_SVM_INIT_ABORT
> > > > > hcall was invoked, was to inform the Hypervisor that it should no longer
> > > > > consider the VM as a Secure VM. So there is a inconsistency there.
> > > > 
> > > > Most of the checks that look at whether a VM is a secure VM use code
> > > > like "if (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE)".  Now
> > > > since KVMPPC_SECURE_INIT_ABORT is 4, an if statement such as that will
> > > > take the false branch once we have set kvm->arch.secure_guest to
> > > > KVMPPC_SECURE_INIT_ABORT in kvmppc_h_svm_init_abort.  So in fact in
> > > > most places we will treat the VM as a normal VM from then on.  If
> > > > there are any places where we still need to treat the VM as a secure
> > > > VM while we are processing the abort we can easily do that too.
> > > 
> > > Is the suggestion --  KVMPPC_SECURE_INIT_ABORT should never return back
> > > to the Ultravisor?   Because removing that assembly code will NOT lead the
> > 
> > No.  The suggestion is that vcpu->arch.secure_guest stays set to
> > KVMPPC_SECURE_INIT_ABORT until userspace calls KVM_PPC_SVM_OFF.
> 
> In the fast_guest_return path, if it finds 
> (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_ABORT) is true, should it return to
> UV or not?
> 
> Ideally it should return back to the ultravisor the first time
> KVMPPC_SECURE_INIT_ABORT is set, and not than onwards.

What is ideal about that behavior?  Why would that be a particularly
good thing to do?

Paul.
