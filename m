Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A6131497E
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Feb 2021 08:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhBIH1P (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Feb 2021 02:27:15 -0500
Received: from ozlabs.org ([203.11.71.1]:43923 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229562AbhBIH1J (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 9 Feb 2021 02:27:09 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4DZZFZ1sBHz9sS8; Tue,  9 Feb 2021 18:26:26 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1612855586; bh=ooMoj9oV77aCJP2MASjEYiKGbTQ0EUU3YxqJH4eVEPM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T1EBIiy+TmPbGWUeuhD34fUrMkfa2mhlXWwJKw1jym5Hpth4X/h8oNRytw52DQfaD
         bXRidz+wVyHMmcu4Rd5Uds0Jx9EuDVnwnouLyqvXah8GFhpm5g3t18hpmf1uVsbuTO
         agAH/gZxGQJ6VZX7jrLCyZZCgtAAkHAs9VOQUnAbT4Q9Hqp9yoMOCMTXLaf9Xnmn12
         t6NUHqq3oRrTKwl8J3Gx0Gl9xPAW+O84faHOd9cd8nIIAz2Pq/2Guj8aSNJUF2dIFY
         Dz9uHXR0nL0nCl3s/xNnFZa4vLpv6irTA5pT3mUn7PwiWtopWiP0JrtaHQcWm66U2J
         tcBaolgw3pF9w==
Date:   Tue, 9 Feb 2021 18:26:02 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: PPC: Book3S HV: Optimise TLB flushing when a
 vcpu moves between threads in a core
Message-ID: <20210209072602.GC2841126@thinks.paulus.ozlabs.org>
References: <20210118122609.1447366-1-npiggin@gmail.com>
 <20210118122609.1447366-2-npiggin@gmail.com>
 <87sg6x5kfo.fsf@linux.ibm.com>
 <1611101698.8m2ih5f8sn.astroid@bobo.none>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611101698.8m2ih5f8sn.astroid@bobo.none>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Jan 20, 2021 at 10:26:51AM +1000, Nicholas Piggin wrote:
> Excerpts from Aneesh Kumar K.V's message of January 19, 2021 7:45 pm:
> > Nicholas Piggin <npiggin@gmail.com> writes:
> > 
> >> As explained in the comment, there is no need to flush TLBs on all
> >> threads in a core when a vcpu moves between threads in the same core.
> >>
> >> Thread migrations can be a significant proportion of vcpu migrations,
> >> so this can help reduce the TLB flushing and IPI traffic.
> >>
> >> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> >> ---
> >> I believe we can do this and have the TLB coherency correct as per
> >> the architecture, but would appreciate someone else verifying my
> >> thinking.
> >>
> >> Thanks,
> >> Nick
> >>
> >>  arch/powerpc/kvm/book3s_hv.c | 28 ++++++++++++++++++++++++++--
> >>  1 file changed, 26 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> >> index 752daf43f780..53d0cbfe5933 100644
> >> --- a/arch/powerpc/kvm/book3s_hv.c
> >> +++ b/arch/powerpc/kvm/book3s_hv.c
> >> @@ -2584,7 +2584,7 @@ static void kvmppc_release_hwthread(int cpu)
> >>  	tpaca->kvm_hstate.kvm_split_mode = NULL;
> >>  }
> >>  
> >> -static void radix_flush_cpu(struct kvm *kvm, int cpu, struct kvm_vcpu *vcpu)
> >> +static void radix_flush_cpu(struct kvm *kvm, int cpu, bool core, struct kvm_vcpu *vcpu)
> >>  {
> > 
> > Can we rename 'core' to something like 'core_sched'  or 'within_core' 
> > 
> >>  	struct kvm_nested_guest *nested = vcpu->arch.nested;
> >>  	cpumask_t *cpu_in_guest;
> >> @@ -2599,6 +2599,14 @@ static void radix_flush_cpu(struct kvm *kvm, int cpu, struct kvm_vcpu *vcpu)
> >>  		cpu_in_guest = &kvm->arch.cpu_in_guest;
> >>  	}
> >>
> > 
> > and do
> >       if (core_sched) {
> 
> This function is called to flush guest TLBs on this cpu / all threads on 
> this cpu core. I don't think it helps to bring any "why" logic into it
> because the caller has already dealt with that.

I agree with Aneesh that the name "core" doesn't really help the
reader to know what the parameter means.  Either it needs a comment or
a more descriptive name.

Paul.
