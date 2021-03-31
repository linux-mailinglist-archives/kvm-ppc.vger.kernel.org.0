Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD75534F809
	for <lists+kvm-ppc@lfdr.de>; Wed, 31 Mar 2021 06:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhCaEfF (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 31 Mar 2021 00:35:05 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:40339 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233591AbhCaEes (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 31 Mar 2021 00:34:48 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4F9D4R57SWz9sWK; Wed, 31 Mar 2021 15:34:47 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1617165287; bh=M8wBblT1g1uK1hduyoudLisyaXN7+YXCuqNzj9Dhb/g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=viee5o80vBg3ho5ACESOQ+9T1l4UA7qgWjYMS0IsH7WLxihifZO9EDgZvp7iCQn/P
         kLO5oM+SJTWXpP2NVSm/sTLQ2xf9OPFgwRDxmafsp0Qac7esRneKzqeVjCZSDBqvhZ
         UyTqydirhtL3ttvod6DUf2DNgFWHu/g98O7R2obc5rSGsxWJgvPs17Vnifv5IRmf00
         yKfEH/czMg/zX50H2q8wR39y5n/ZcChWuXjGsK2Wp0CJBKaRARxplrKUBivpIP2UuP
         HrDSuYsKHtkNhtqsCU1Vd/x8/+pyaXP0tsMxPXh/lV4QWdMy7UJ9c6Gy0g9AJOasS1
         pJKsrFc8TPsYg==
Date:   Wed, 31 Mar 2021 15:34:41 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v4 04/46] KVM: PPC: Book3S HV: Prevent radix guests from
 setting LPCR[TC]
Message-ID: <YGP74QVmx5yyE8Rc@thinks.paulus.ozlabs.org>
References: <20210323010305.1045293-1-npiggin@gmail.com>
 <20210323010305.1045293-5-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323010305.1045293-5-npiggin@gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 23, 2021 at 11:02:23AM +1000, Nicholas Piggin wrote:
> This bit only applies to hash partitions.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c        | 6 ++++++
>  arch/powerpc/kvm/book3s_hv_nested.c | 3 +--
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index c5de7e3f22b6..1ffb0902e779 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -1645,6 +1645,12 @@ static int kvm_arch_vcpu_ioctl_set_sregs_hv(struct kvm_vcpu *vcpu,
>   */
>  unsigned long kvmppc_filter_lpcr_hv(struct kvmppc_vcore *vc, unsigned long lpcr)
>  {
> +	struct kvm *kvm = vc->kvm;
> +
> +	/* LPCR_TC only applies to HPT guests */
> +	if (kvm_is_radix(kvm))
> +		lpcr &= ~LPCR_TC;

I'm not sure I see any benefit from this, and it is a little extra
complexity.

>  	/* On POWER8 and above, userspace can modify AIL */
>  	if (!cpu_has_feature(CPU_FTR_ARCH_207S))
>  		lpcr &= ~LPCR_AIL;
> diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
> index f7b441b3eb17..851e3f527eb2 100644
> --- a/arch/powerpc/kvm/book3s_hv_nested.c
> +++ b/arch/powerpc/kvm/book3s_hv_nested.c
> @@ -140,8 +140,7 @@ static void sanitise_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
>  	/*
>  	 * Don't let L1 change LPCR bits for the L2 except these:
>  	 */
> -	mask = LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_AIL | LPCR_LD |
> -		LPCR_LPES | LPCR_MER;
> +	mask = LPCR_DPFD | LPCR_ILE | LPCR_AIL | LPCR_LD | LPCR_LPES | LPCR_MER;

Doesn't this make it completely impossible to set TC for any guest?

Paul.
