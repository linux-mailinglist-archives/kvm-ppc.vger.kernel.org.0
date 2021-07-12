Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDC43C4142
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Jul 2021 04:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhGLCoC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 11 Jul 2021 22:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhGLCoB (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 11 Jul 2021 22:44:01 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E853BC0613DD
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Jul 2021 19:41:12 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id b12so14972329pfv.6
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Jul 2021 19:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=W4wjdueyKU7tUJT7diUT2o0ACfWlpKnLEzMxeOyAcnU=;
        b=ep4r/2jKBnuz3OEvZAH1a16RYlqRfoLhg1UaNsdzQaPqtxs9rEUaR6YtnJb7UACztf
         vCb61seYmzh2tU2/fjHZcZsxl1F7mfDDAXo/33dMr2miJQp8psmpgF+Aam+I+/Z7izQX
         oXnK7ZNaJQyCNUURBGV+giqXdZNHXprqUzmbMpDqnDrp5S/lnwGqzH9ajXNfdfOWZAyR
         UPGYdST/KHzBmD03gpie642EESRB/qggMbF0pPB1yiHlHHuH3UcSKl7Mrec8vBLoLhS9
         nlQ0PajOMPjlVCDu16C26l4nwg+m2RdZtfPV4Mi1jFG6mNT1XaIjtWQTYYytGAOFX1H4
         ZOdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=W4wjdueyKU7tUJT7diUT2o0ACfWlpKnLEzMxeOyAcnU=;
        b=uaC0j18mTEzZj6MdbNcxyWPCuRNYMHyc4tKhOFc/Or0Rw6LFYYDR7YjauOn6B//DFk
         HP0VHDMiMEixMPXXZN9twG2F0YCXOuD/aMn5iwszEd3X6slFkDZtwRCX+z3Tbzt/AGdw
         VNxxF6NzZ7EDQNo+7Md7mCRFAmbxz4bvFgwLMDBXBtDTn3/sqHdqAse4dODqIsSdImDF
         jiub7nV5VNpEU3vGYTAOo8Ru0nSihWqSoIZDp2ivwa5Q/zJIV8R2BMNGnz6Xmhw3rc2h
         XYyrtXjcIDc2hM0ltwDofUbrpEEJ4qgyWy/jp7uAWjHIPD6rK6RvdGxozDipbz9/Erei
         0YFQ==
X-Gm-Message-State: AOAM5322dAo1utOHezncFtUD2y5aRu7o6AHnPUB7BFr2B6XDOryka/cM
        loYY0/NCnKB5GkmixvivLl4=
X-Google-Smtp-Source: ABdhPJyNIBffjh0JPLtHrANnvn4X3lUBfJ6nSwEefvuOqPvwRXK5s2KBNEfAGY5r+Q645WyoGaDzmA==
X-Received: by 2002:a63:f306:: with SMTP id l6mr51847102pgh.46.1626057672315;
        Sun, 11 Jul 2021 19:41:12 -0700 (PDT)
Received: from localhost (203-219-181-43.static.tpgi.com.au. [203.219.181.43])
        by smtp.gmail.com with ESMTPSA id e18sm13453836pfc.85.2021.07.11.19.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 19:41:11 -0700 (PDT)
Date:   Mon, 12 Jul 2021 12:41:07 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [RFC PATCH 10/43] powerpc/64s: Always set PMU control registers
 to frozen/disabled when not in use
To:     Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20210622105736.633352-1-npiggin@gmail.com>
        <20210622105736.633352-11-npiggin@gmail.com>
        <C58A063A-3B5D-4188-80E2-4C19802785BF@linux.vnet.ibm.com>
In-Reply-To: <C58A063A-3B5D-4188-80E2-4C19802785BF@linux.vnet.ibm.com>
MIME-Version: 1.0
Message-Id: <1626057462.8m12ralsd6.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Athira Rajeev's message of July 10, 2021 12:50 pm:
>=20
>=20
>> On 22-Jun-2021, at 4:27 PM, Nicholas Piggin <npiggin@gmail.com> wrote:
>>=20
>> KVM PMU management code looks for particular frozen/disabled bits in
>> the PMU registers so it knows whether it must clear them when coming
>> out of a guest or not. Setting this up helps KVM make these optimisation=
s
>> without getting confused. Longer term the better approach might be to
>> move guest/host PMU switching to the perf subsystem.
>>=20
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>> arch/powerpc/kernel/cpu_setup_power.c | 4 ++--
>> arch/powerpc/kernel/dt_cpu_ftrs.c     | 6 +++---
>> arch/powerpc/kvm/book3s_hv.c          | 5 +++++
>> arch/powerpc/perf/core-book3s.c       | 7 +++++++
>> 4 files changed, 17 insertions(+), 5 deletions(-)
>>=20
>> diff --git a/arch/powerpc/kernel/cpu_setup_power.c b/arch/powerpc/kernel=
/cpu_setup_power.c
>> index a29dc8326622..3dc61e203f37 100644
>> --- a/arch/powerpc/kernel/cpu_setup_power.c
>> +++ b/arch/powerpc/kernel/cpu_setup_power.c
>> @@ -109,7 +109,7 @@ static void init_PMU_HV_ISA207(void)
>> static void init_PMU(void)
>> {
>> 	mtspr(SPRN_MMCRA, 0);
>> -	mtspr(SPRN_MMCR0, 0);
>> +	mtspr(SPRN_MMCR0, MMCR0_FC);
>> 	mtspr(SPRN_MMCR1, 0);
>> 	mtspr(SPRN_MMCR2, 0);
>> }
>> @@ -123,7 +123,7 @@ static void init_PMU_ISA31(void)
>> {
>> 	mtspr(SPRN_MMCR3, 0);
>> 	mtspr(SPRN_MMCRA, MMCRA_BHRB_DISABLE);
>> -	mtspr(SPRN_MMCR0, MMCR0_PMCCEXT);
>> +	mtspr(SPRN_MMCR0, MMCR0_FC | MMCR0_PMCCEXT);
>> }
>>=20
>> /*
>> diff --git a/arch/powerpc/kernel/dt_cpu_ftrs.c b/arch/powerpc/kernel/dt_=
cpu_ftrs.c
>> index 0a6b36b4bda8..06a089fbeaa7 100644
>> --- a/arch/powerpc/kernel/dt_cpu_ftrs.c
>> +++ b/arch/powerpc/kernel/dt_cpu_ftrs.c
>> @@ -353,7 +353,7 @@ static void init_pmu_power8(void)
>> 	}
>>=20
>> 	mtspr(SPRN_MMCRA, 0);
>> -	mtspr(SPRN_MMCR0, 0);
>> +	mtspr(SPRN_MMCR0, MMCR0_FC);
>> 	mtspr(SPRN_MMCR1, 0);
>> 	mtspr(SPRN_MMCR2, 0);
>> 	mtspr(SPRN_MMCRS, 0);
>> @@ -392,7 +392,7 @@ static void init_pmu_power9(void)
>> 		mtspr(SPRN_MMCRC, 0);
>>=20
>> 	mtspr(SPRN_MMCRA, 0);
>> -	mtspr(SPRN_MMCR0, 0);
>> +	mtspr(SPRN_MMCR0, MMCR0_FC);
>> 	mtspr(SPRN_MMCR1, 0);
>> 	mtspr(SPRN_MMCR2, 0);
>> }
>> @@ -428,7 +428,7 @@ static void init_pmu_power10(void)
>>=20
>> 	mtspr(SPRN_MMCR3, 0);
>> 	mtspr(SPRN_MMCRA, MMCRA_BHRB_DISABLE);
>> -	mtspr(SPRN_MMCR0, MMCR0_PMCCEXT);
>> +	mtspr(SPRN_MMCR0, MMCR0_FC | MMCR0_PMCCEXT);
>> }
>>=20
>> static int __init feat_enable_pmu_power10(struct dt_cpu_feature *f)
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index 1f30f98b09d1..f7349d150828 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -2593,6 +2593,11 @@ static int kvmppc_core_vcpu_create_hv(struct kvm_=
vcpu *vcpu)
>> #endif
>> #endif
>> 	vcpu->arch.mmcr[0] =3D MMCR0_FC;
>> +	if (cpu_has_feature(CPU_FTR_ARCH_31)) {
>> +		vcpu->arch.mmcr[0] |=3D MMCR0_PMCCEXT;
>> +		vcpu->arch.mmcra =3D MMCRA_BHRB_DISABLE;
>> +	}
>> +
>> 	vcpu->arch.ctrl =3D CTRL_RUNLATCH;
>> 	/* default to host PVR, since we can't spoof it */
>> 	kvmppc_set_pvr_hv(vcpu, mfspr(SPRN_PVR));
>> diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-bo=
ok3s.c
>> index 51622411a7cc..e33b29ec1a65 100644
>> --- a/arch/powerpc/perf/core-book3s.c
>> +++ b/arch/powerpc/perf/core-book3s.c
>> @@ -1361,6 +1361,13 @@ static void power_pmu_enable(struct pmu *pmu)
>> 		goto out;
>>=20
>> 	if (cpuhw->n_events =3D=3D 0) {
>> +		if (cpu_has_feature(CPU_FTR_ARCH_31)) {
>> +			mtspr(SPRN_MMCRA, MMCRA_BHRB_DISABLE);
>> +			mtspr(SPRN_MMCR0, MMCR0_FC | MMCR0_PMCCEXT);
>> +		} else {
>> +			mtspr(SPRN_MMCRA, 0);
>> +			mtspr(SPRN_MMCR0, MMCR0_FC);
>> +		}
>=20
>=20
> Hi Nick,
>=20
> We are setting these bits in =E2=80=9Cpower_pmu_disable=E2=80=9D function=
. And disable will be called before any event gets deleted/stopped. Can you=
 please help to understand why this is needed in power_pmu_enable path also=
 ?

I'll have to go back and check what I needed it for.

Basically what I'm trying to achieve is that when the guest and host=20
are not running perf, then the registers should match. This way the host=20
can test them with mfspr but does not need to fix them with mtspr.

It's not too important for performance after TM facility demand faulting
and the nested guest PMU fix means you can usually just skip that=20
entirely, but I think it's cleaner. I'll double check my perf/ changes
it's possible that part should be split out or is unnecessary.

Thanks,
Nick
