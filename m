Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8DB3C4154
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Jul 2021 04:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhGLCxc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 11 Jul 2021 22:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhGLCxb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 11 Jul 2021 22:53:31 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BB5C0613DD
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Jul 2021 19:50:43 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g24so9270201pji.4
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Jul 2021 19:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=w2r4qfv5vAYJ00NUqIGFvURWuXmn7VNm7e5xDqKTB40=;
        b=peHg2NZYicXl7JUKveOTepsa2bfhyjmB2JQE0hW9wkOmsUl933a9C0q2v7O6jLtBbE
         V/hTspmlE9CvELtFH2zhZPBQxafCjsu3yjh7G2YL/ikow9cuUl+NiwMjpdELfGhjb1Lt
         1pvNKDa2evs8wYVWo+FA/4p7yLhI60nZjAcYf8G3MudWU4XciPBWUnV+EXC6eGg02f9p
         NMM1eR4X7ihRox92tW8AveGdHUq5OPFaU+80UNZ32B65kysP3ANu600CtC2S7qY4aa3M
         V2sDwWadsl6ORLOuDfKxdydFmKur6d3x8UWTCdVmGttwli3k55fo6PuiZ1Odq0Ci7kuI
         1hwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=w2r4qfv5vAYJ00NUqIGFvURWuXmn7VNm7e5xDqKTB40=;
        b=YXMKv7uy5+E/1ArRRIMJ7GmTXspXzOC/qnrSfV3o6QTR5tf9DULlrl/2rSbp4DW0Y/
         OLc/D9WQ8kbAMIDD48DJu9UaU+RqqM5FyuyOe/n3wyfdUkp+JvCOJ1JBM0SUEglDDZOx
         q+PJEeY2T9pmtqUP96vvXTvF64ZPI8LzCPMW/9tSyIQuyY8aa8pqjchr953/JGXtHtKS
         akgpDG8H1KjZ6ha5V+9p+JoOwRbTuhgz9wZy2TM5k8U53R/KcDNgWG8XWp3ny098iPlT
         yKGYeSHEoJStTNuNwiEQJx5KynjSONLBA+KcZqUlbS+vYxH69vFzsqYFijdpklAbpcFD
         lL0g==
X-Gm-Message-State: AOAM532THb4+/KOZdLweOFUauX0YGivsPRTgj1NVSQt/UV21lFK3AwMA
        bic69NZfdpSps0NMXADqKys=
X-Google-Smtp-Source: ABdhPJx8vYHuMpqABVE2A8PY2LXzGVCyvJikwfxTgN5gLhmU21scm0Rou6G7ltnJo7pMYtthEp3pXg==
X-Received: by 2002:a17:90b:384f:: with SMTP id nl15mr51537121pjb.88.1626058243048;
        Sun, 11 Jul 2021 19:50:43 -0700 (PDT)
Received: from localhost (203-219-181-43.static.tpgi.com.au. [203.219.181.43])
        by smtp.gmail.com with ESMTPSA id t1sm11565859pjo.33.2021.07.11.19.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 19:50:42 -0700 (PDT)
Date:   Mon, 12 Jul 2021 12:50:37 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [RFC PATCH 27/43] KVM: PPC: Book3S HV P9: Move host OS
 save/restore functions to built-in
To:     Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20210622105736.633352-1-npiggin@gmail.com>
        <20210622105736.633352-28-npiggin@gmail.com>
        <983C1FE6-79CB-4DBD-BD00-8CFDA3685FEB@linux.vnet.ibm.com>
In-Reply-To: <983C1FE6-79CB-4DBD-BD00-8CFDA3685FEB@linux.vnet.ibm.com>
MIME-Version: 1.0
Message-Id: <1626058210.6twtrgfync.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Athira Rajeev's message of July 8, 2021 3:32 pm:
>=20
>=20
>> On 22-Jun-2021, at 4:27 PM, Nicholas Piggin <npiggin@gmail.com> wrote:
>>=20
>> Move the P9 guest/host register switching functions to the built-in
>> P9 entry code, and export it for nested to use as well.
>>=20
>> This allows more flexibility in scheduling these supervisor privileged
>> SPR accesses with the HV privileged and PR SPR accesses in the low level
>> entry code.
>>=20
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>> arch/powerpc/kvm/book3s_hv.c          | 351 +-------------------------
>> arch/powerpc/kvm/book3s_hv.h          |  39 +++
>> arch/powerpc/kvm/book3s_hv_p9_entry.c | 332 ++++++++++++++++++++++++
>> 3 files changed, 372 insertions(+), 350 deletions(-)
>> create mode 100644 arch/powerpc/kvm/book3s_hv.h
>>=20
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index 35749b0b663f..a7660af22161 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -79,6 +79,7 @@
>> #include <asm/dtl.h>
>>=20
>> #include "book3s.h"
>> +#include "book3s_hv.h"
>>=20
>> #define CREATE_TRACE_POINTS
>> #include "trace_hv.h"
>> @@ -3675,356 +3676,6 @@ static noinline void kvmppc_run_core(struct kvmp=
pc_vcore *vc)
>> 	trace_kvmppc_run_core(vc, 1);
>> }
>>=20
>> -/*
>> - * Privileged (non-hypervisor) host registers to save.
>> - */
>> -struct p9_host_os_sprs {
>> -	unsigned long dscr;
>> -	unsigned long tidr;
>> -	unsigned long iamr;
>> -	unsigned long amr;
>> -	unsigned long fscr;
>> -
>> -	unsigned int pmc1;
>> -	unsigned int pmc2;
>> -	unsigned int pmc3;
>> -	unsigned int pmc4;
>> -	unsigned int pmc5;
>> -	unsigned int pmc6;
>> -	unsigned long mmcr0;
>> -	unsigned long mmcr1;
>> -	unsigned long mmcr2;
>> -	unsigned long mmcr3;
>> -	unsigned long mmcra;
>> -	unsigned long siar;
>> -	unsigned long sier1;
>> -	unsigned long sier2;
>> -	unsigned long sier3;
>> -	unsigned long sdar;
>> -};
>> -
>> -static void freeze_pmu(unsigned long mmcr0, unsigned long mmcra)
>> -{
>> -	if (!(mmcr0 & MMCR0_FC))
>> -		goto do_freeze;
>> -	if (mmcra & MMCRA_SAMPLE_ENABLE)
>> -		goto do_freeze;
>> -	if (cpu_has_feature(CPU_FTR_ARCH_31)) {
>> -		if (!(mmcr0 & MMCR0_PMCCEXT))
>> -			goto do_freeze;
>> -		if (!(mmcra & MMCRA_BHRB_DISABLE))
>> -			goto do_freeze;
>> -	}
>> -	return;
>> -
>> -do_freeze:
>> -	mmcr0 =3D MMCR0_FC;
>> -	mmcra =3D 0;
>> -	if (cpu_has_feature(CPU_FTR_ARCH_31)) {
>> -		mmcr0 |=3D MMCR0_PMCCEXT;
>> -		mmcra =3D MMCRA_BHRB_DISABLE;
>> -	}
>> -
>> -	mtspr(SPRN_MMCR0, mmcr0);
>> -	mtspr(SPRN_MMCRA, mmcra);
>> -	isync();
>> -}
>> -
>> -static void switch_pmu_to_guest(struct kvm_vcpu *vcpu,
>> -				struct p9_host_os_sprs *host_os_sprs)
>> -{
>> -	struct lppaca *lp;
>> -	int load_pmu =3D 1;
>> -
>> -	lp =3D vcpu->arch.vpa.pinned_addr;
>> -	if (lp)
>> -		load_pmu =3D lp->pmcregs_in_use;
>> -
>> -	if (load_pmu)
>> -	      vcpu->arch.hfscr |=3D HFSCR_PM;
>> -
>> -	/* Save host */
>> -	if (ppc_get_pmu_inuse()) {
>> -		/*
>> -		 * It might be better to put PMU handling (at least for the
>> -		 * host) in the perf subsystem because it knows more about what
>> -		 * is being used.
>> -		 */
>> -
>> -		/* POWER9, POWER10 do not implement HPMC or SPMC */
>> -
>> -		host_os_sprs->mmcr0 =3D mfspr(SPRN_MMCR0);
>> -		host_os_sprs->mmcra =3D mfspr(SPRN_MMCRA);
>> -
>> -		freeze_pmu(host_os_sprs->mmcr0, host_os_sprs->mmcra);
>> -
>> -		host_os_sprs->pmc1 =3D mfspr(SPRN_PMC1);
>> -		host_os_sprs->pmc2 =3D mfspr(SPRN_PMC2);
>> -		host_os_sprs->pmc3 =3D mfspr(SPRN_PMC3);
>> -		host_os_sprs->pmc4 =3D mfspr(SPRN_PMC4);
>> -		host_os_sprs->pmc5 =3D mfspr(SPRN_PMC5);
>> -		host_os_sprs->pmc6 =3D mfspr(SPRN_PMC6);
>> -		host_os_sprs->mmcr1 =3D mfspr(SPRN_MMCR1);
>> -		host_os_sprs->mmcr2 =3D mfspr(SPRN_MMCR2);
>> -		host_os_sprs->sdar =3D mfspr(SPRN_SDAR);
>> -		host_os_sprs->siar =3D mfspr(SPRN_SIAR);
>> -		host_os_sprs->sier1 =3D mfspr(SPRN_SIER);
>> -
>> -		if (cpu_has_feature(CPU_FTR_ARCH_31)) {
>> -			host_os_sprs->mmcr3 =3D mfspr(SPRN_MMCR3);
>> -			host_os_sprs->sier2 =3D mfspr(SPRN_SIER2);
>> -			host_os_sprs->sier3 =3D mfspr(SPRN_SIER3);
>> -		}
>> -	}
>> -
>> -#ifdef CONFIG_PPC_PSERIES
>> -	if (kvmhv_on_pseries()) {
>> -		if (vcpu->arch.vpa.pinned_addr) {
>> -			struct lppaca *lp =3D vcpu->arch.vpa.pinned_addr;
>> -			get_lppaca()->pmcregs_in_use =3D lp->pmcregs_in_use;
>> -		} else {
>> -			get_lppaca()->pmcregs_in_use =3D 1;
>> -		}
>> -	}
>> -#endif
>> -
>> -	/* Load guest */
>> -	if (vcpu->arch.hfscr & HFSCR_PM) {
>> -		mtspr(SPRN_PMC1, vcpu->arch.pmc[0]);
>> -		mtspr(SPRN_PMC2, vcpu->arch.pmc[1]);
>> -		mtspr(SPRN_PMC3, vcpu->arch.pmc[2]);
>> -		mtspr(SPRN_PMC4, vcpu->arch.pmc[3]);
>> -		mtspr(SPRN_PMC5, vcpu->arch.pmc[4]);
>> -		mtspr(SPRN_PMC6, vcpu->arch.pmc[5]);
>> -		mtspr(SPRN_MMCR1, vcpu->arch.mmcr[1]);
>> -		mtspr(SPRN_MMCR2, vcpu->arch.mmcr[2]);
>> -		mtspr(SPRN_SDAR, vcpu->arch.sdar);
>> -		mtspr(SPRN_SIAR, vcpu->arch.siar);
>> -		mtspr(SPRN_SIER, vcpu->arch.sier[0]);
>> -
>> -		if (cpu_has_feature(CPU_FTR_ARCH_31)) {
>> -			mtspr(SPRN_MMCR3, vcpu->arch.mmcr[4]);
>=20
>=20
> Hi Nick,
>=20
> Have a doubt here..
> For MMCR3, it is  vcpu->arch.mmcr[3) ?

Hey, yea it is you're right. Good catch.

Thanks,
Nick

