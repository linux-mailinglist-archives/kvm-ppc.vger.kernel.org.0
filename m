Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42C30F9F1E
	for <lists+kvm-ppc@lfdr.de>; Wed, 13 Nov 2019 01:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKMAOf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 12 Nov 2019 19:14:35 -0500
Received: from ozlabs.org ([203.11.71.1]:43651 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726923AbfKMAOf (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 12 Nov 2019 19:14:35 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 47CQ8n24p7z9sQp; Wed, 13 Nov 2019 11:14:33 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1573604073; bh=eaKlwgdIJsn3cYx0pG4CKYUAolYzy7bggI3IJ4S28AA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tHOIFJ1aAXXPXE/f6Js+XN05su1cvwOOR8xTEilo5y6hTG2AXO/heOo4+hDJXY5Ad
         Eir1KR4sScjbJRiF0dXzzck5iNHTv7hkB9TQwygDVpsYd7IsvyOOx0J/7S9iFrc02T
         6iurluDgA9EI2/Whftfdvn8mlCBb8YfF2eezroDsREjyct5/Obv4SCDKWmODQlwp57
         U5cIHsJyt5czMWTLjsEH8ulgxo6zAtyxWedJYvBjs8DhIQ2YURxk8uCbZvkq4Mg+ds
         kKuuWN3HECgYTsAdNx4vbRijYZYf986wgAUJwJ686x8nf69Xc+rdrIH0PjZFUlaGOV
         Ts5qUlizrz5mQ==
Date:   Wed, 13 Nov 2019 11:14:27 +1100
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
Message-ID: <20191113001427.GA17829@oak.ozlabs.ibm.com>
References: <20191104041800.24527-1-bharata@linux.ibm.com>
 <20191104041800.24527-8-bharata@linux.ibm.com>
 <20191111041924.GA4017@oak.ozlabs.ibm.com>
 <20191112010158.GB5159@oc0525413822.ibm.com>
 <20191112053836.GB10885@oak.ozlabs.ibm.com>
 <20191112075215.GD5159@oc0525413822.ibm.com>
 <20191112113204.GA10178@blackberry>
 <20191112144555.GE5159@oc0525413822.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112144555.GE5159@oc0525413822.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Nov 12, 2019 at 06:45:55AM -0800, Ram Pai wrote:
> On Tue, Nov 12, 2019 at 10:32:04PM +1100, Paul Mackerras wrote:
> > On Mon, Nov 11, 2019 at 11:52:15PM -0800, Ram Pai wrote:
> > > There is subtle problem removing that code from the assembly.
> > > 
> > > If the H_SVM_INIT_ABORT hcall returns to the ultravisor without clearing
> > > kvm->arch.secure_guest, the hypervisor will continue to think that the
> > > VM is a secure VM.   However the primary reason the H_SVM_INIT_ABORT
> > > hcall was invoked, was to inform the Hypervisor that it should no longer
> > > consider the VM as a Secure VM. So there is a inconsistency there.
> > 
> > Most of the checks that look at whether a VM is a secure VM use code
> > like "if (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE)".  Now
> > since KVMPPC_SECURE_INIT_ABORT is 4, an if statement such as that will
> > take the false branch once we have set kvm->arch.secure_guest to
> > KVMPPC_SECURE_INIT_ABORT in kvmppc_h_svm_init_abort.  So in fact in
> > most places we will treat the VM as a normal VM from then on.  If
> > there are any places where we still need to treat the VM as a secure
> > VM while we are processing the abort we can easily do that too.
> 
> Is the suggestion --  KVMPPC_SECURE_INIT_ABORT should never return back
> to the Ultravisor?   Because removing that assembly code will NOT lead the

No.  The suggestion is that vcpu->arch.secure_guest stays set to
KVMPPC_SECURE_INIT_ABORT until userspace calls KVM_PPC_SVM_OFF.

> Hypervisor back into the Ultravisor.  This is fine with the
> ultravisor. But then the hypervisor will not know where to return to.
> If it wants to return directly to the VM, it wont know to
> which address. It will be in a limbo.
> 
> > 
> > > This is fine, as long as the VM does not invoke any hcall or does not
> > > receive any hypervisor-exceptions.  The moment either of those happen,
> > > the control goes into the hypervisor, the hypervisor services
> > > the exception/hcall and while returning, it will see that the
> > > kvm->arch.secure_guest flag is set and **incorrectly** return
> > > to the ultravisor through a UV_RETURN ucall.  Ultravisor will
> > > not know what to do with it, because it does not consider that
> > > VM as a Secure VM.  Bad things happen.
> > 
> > If bad things happen in the ultravisor because the hypervisor did
> > something it shouldn't, then it's game over, you just lost, thanks for
> > playing.  The ultravisor MUST be able to cope with bogus UV_RETURN
> > calls for a VM that it doesn't consider to be a secure VM.  You need
> > to work out how to handle such calls safely and implement that in the
> > ultravisor.
> 
> Actually we do handle this gracefully in the ultravisor :). 
> We just retun back to the hypervisor saying "sorry dont know what
> to do with it, please handle it yourself".
> 
> However hypervisor would not know what to do with that return, and bad
> things happen in the hypervisor.

Right.  We need something after the "sc 2" to handle the case where
the ultravisor returns with an error from the UV_RETURN.

Paul.
