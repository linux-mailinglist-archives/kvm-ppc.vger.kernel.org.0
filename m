Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6FDB2D6FC2
	for <lists+kvm-ppc@lfdr.de>; Fri, 11 Dec 2020 06:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391561AbgLKF3J (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 11 Dec 2020 00:29:09 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:53349 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391490AbgLKF2b (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 11 Dec 2020 00:28:31 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4CsfSQ1c52z9sWS; Fri, 11 Dec 2020 16:27:49 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1607664470; bh=KCtiru4Zi8d+YqJORQKk8XMRhcLRedA9e5sZ52eDqd4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xkrq96BDhTklQ0K8ESjMBS/H2JDLfSb6lCg9u5s6yVFA7aWoUsHktu+P2KmAFEIwL
         4ttkjA+dqz8LuIDBIDLK2pIzqL8MYluoU+romI05TdvWFUuZ/PnnRv3wyc0aAUgzRu
         1r9m0lEvvQsI/iX7OHps3Cj7zrGJVltUQOXeUhM2oYQX7MKXxD/paAJkFga/fyvDQU
         hAGWr7xpEPcWhmmUUy+T2F25KCVA4ok0sgd/Ob8irX8W8cEtDCAQ4u1kyoNyy4kGkE
         Nt3PghgUf2qkq0ctk/aPt8EswcTe8OL+YCA4WsdAuSxSZ3SbMDMdwU9XIEJtEIOQCB
         9YdUqOMfUP/Ww==
Date:   Fri, 11 Dec 2020 16:27:44 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Bharata B Rao <bharata@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, aneesh.kumar@linux.ibm.com,
        npiggin@gmail.com, mpe@ellerman.id.au
Subject: Re: [PATCH v1 1/2] KVM: PPC: Book3S HV: Add support for
 H_RPT_INVALIDATE (nested case only)
Message-ID: <20201211052744.GB69862@thinks.paulus.ozlabs.org>
References: <20201019112642.53016-1-bharata@linux.ibm.com>
 <20201019112642.53016-2-bharata@linux.ibm.com>
 <20201209041542.GA29825@thinks.paulus.ozlabs.org>
 <20201210042418.GA775394@in.ibm.com>
 <20201211011639.GD4874@yekko.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211011639.GD4874@yekko.fritz.box>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Dec 11, 2020 at 12:16:39PM +1100, David Gibson wrote:
> On Thu, Dec 10, 2020 at 09:54:18AM +0530, Bharata B Rao wrote:
> > On Wed, Dec 09, 2020 at 03:15:42PM +1100, Paul Mackerras wrote:
> > > On Mon, Oct 19, 2020 at 04:56:41PM +0530, Bharata B Rao wrote:
> > > > Implements H_RPT_INVALIDATE hcall and supports only nested case
> > > > currently.
> > > > 
> > > > A KVM capability KVM_CAP_RPT_INVALIDATE is added to indicate the
> > > > support for this hcall.
> > > 
> > > I have a couple of questions about this patch:
> > > 
> > > 1. Is this something that is useful today, or is it something that may
> > > become useful in the future depending on future product plans? In
> > > other words, what advantage is there to forcing L2 guests to use this
> > > hcall instead of doing tlbie themselves?
> > 
> > H_RPT_INVALIDATE will replace the use of the existing H_TLB_INVALIDATE
> > for nested partition scoped invalidations. Implementations that want to
> > off-load invalidations to the host (when GTSE=0) would have to bother
> > about only one hcall (H_RPT_INVALIDATE)
> > 
> > > 
> > > 2. Why does it need to be added to the default-enabled hcall list?
> > > 
> > > There is a concern that if this is enabled by default we could get the
> > > situation where a guest using it gets migrated to a host that doesn't
> > > support it, which would be bad.  That is the reason that all new
> > > things like this are disabled by default and only enabled by userspace
> > > (i.e. QEMU) in situations where we can enforce that it is available on
> > > all hosts to which the VM might be migrated.
> > 
> > As you suggested privately, I am thinking of falling back to
> > H_TLB_INVALIDATE in case where this new hcall fails due to not being
> > present. That should address the migration case that you mention
> > above. With that and leaving the new hcall enabled by default
> > is good okay?
> 
> No.  Assuming that guests will have some fallback is not how the qemu
> migration compatibility model works.  If we specify an old machine
> type, we need to provide the same environment that the older host
> would have.

I misunderstood what this patchset is about when I first looked at
it.  H_RPT_INVALIDATE has two separate functions; one is to do
process-scoped invalidations for a guest when LPCR[GTSE] = 0 (i.e.,
when the guest is not permitted to do tlbie itself), and the other is
to do partition-scoped invalidations that an L1 hypervisor needs to do
on behalf of an L2 guest.  The second function is a replacement and
standardization of the existing H_TLB_INVALIDATE which was introduced
with the nested virtualization code (using a hypercall number from the
platform-specific range).

This patchset only implements the second function, not the first.  The
first function remains unimplemented in KVM at present.

Given that QEMU will need changes for a guest to be able to exploit
H_RPT_INVALIDATE (at a minimum, adding a device tree property), it
doesn't seem onerous for QEMU to have to enable the hcall with
KVM_CAP_PPC_ENABLE_HCALL.  I think that the control on whether the
hcall is handled in KVM along with the control on nested hypervisor
function provides adequate control for QEMU without needing a writable
capability.  The read-only capability to say whether the hcall exists
does seem useful.

Given all that, I'm veering towards taking Bharata's patchset pretty
much as-is, minus the addition of H_RPT_INVALIDATE to the
default-enabled set.

Paul.
