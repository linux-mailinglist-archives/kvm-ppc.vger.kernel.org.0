Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F863C8490
	for <lists+kvm-ppc@lfdr.de>; Wed, 14 Jul 2021 14:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbhGNMmK (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 14 Jul 2021 08:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbhGNMmK (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 14 Jul 2021 08:42:10 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B68C06175F
        for <kvm-ppc@vger.kernel.org>; Wed, 14 Jul 2021 05:39:18 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 21so1928281pfp.3
        for <kvm-ppc@vger.kernel.org>; Wed, 14 Jul 2021 05:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=CcE+Luj/vv/V9B2PLHGUjgVkPHIzTSDrQQ8UogdtXTQ=;
        b=p5dD5XXDZHRJk9wNY1G2FJHL1zK8j6XM9IyZklLNPZrOKmeVrSSwqHIffMU/yUYcFY
         mPPlLuWRYiBQXQvI9VsB2yENJE2gyvccBNJVSkVa/EhYTtPbJU1RyqQwZkNQ2XIDvRbV
         R4fq1hfz9MC1IGUNdABnQLdIPtfm/FURcVTyOXGcsCXAnSxC9LjfHunatiifHCKBL9hL
         CD8NgQ3fLZWV/fw2WH898c9tmyZAo9ulyJ4KPoKUaaBhgdsMv8WJIBdS0lLQZl5dVzg5
         95w2fWbxUfrjHg0pA17xuC2/RAQQ7Gy4Dt+kTP9D7GQf/rTCuY3yQVADK4ORkh65hOsx
         ZD/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=CcE+Luj/vv/V9B2PLHGUjgVkPHIzTSDrQQ8UogdtXTQ=;
        b=b0oZ8MjjYEXSQIqCpUarPS7gqWgB1gXQbF7lUiLI6Vz1kMZMv7Ht6T0+Kg20HKGpZ+
         iwh9u1yq0G8JGqNFi79xYWawXUr76sYVWN3fTgDFffyrC0CM8s8gI/zCSHGPCkB3L7rt
         z97nZKEtzkWvZm64I0e1ZQYfPgPWrUbCV/53Ehy3BbsHdsDbatNMRdzE+KoUmv0QbHb6
         0JiPWUrpJlctkBXz8RYrEwhU7qfWfWRX0TA1jWi4y1fDQWCtq25K1Y0g8Il3Uv7FPLUL
         ogEbsX4zfuUs/Js+coKawL1Bav563VNuxJK8rCg9TGU6OrcJemwKK5AGpqhabZKGS7ig
         vyfw==
X-Gm-Message-State: AOAM530fyM2Jlh1u3x9HxSQ00kbYVjd+SuPwvQzcQzQ8FY06jB4EbEk9
        2HB5aP5Nz74u/JzAdyQng+Y=
X-Google-Smtp-Source: ABdhPJxv6MQHKHvwgfoIYB8aLfts4eY7yrOWP+bvZXtUWdqEnXg9lYfZUPgLWChgov+mcoBv7EeHvQ==
X-Received: by 2002:a63:4415:: with SMTP id r21mr9475016pga.296.1626266357721;
        Wed, 14 Jul 2021 05:39:17 -0700 (PDT)
Received: from localhost (203-219-181-43.static.tpgi.com.au. [203.219.181.43])
        by smtp.gmail.com with ESMTPSA id c11sm2932977pfp.0.2021.07.14.05.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 05:39:17 -0700 (PDT)
Date:   Wed, 14 Jul 2021 22:39:11 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [RFC PATCH 10/43] powerpc/64s: Always set PMU control registers
 to frozen/disabled when not in use
To:     Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20210622105736.633352-1-npiggin@gmail.com>
        <20210622105736.633352-11-npiggin@gmail.com>
        <C58A063A-3B5D-4188-80E2-4C19802785BF@linux.vnet.ibm.com>
        <1626057462.8m12ralsd6.astroid@bobo.none>
In-Reply-To: <1626057462.8m12ralsd6.astroid@bobo.none>
MIME-Version: 1.0
Message-Id: <1626265929.asca0gyunh.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Nicholas Piggin's message of July 12, 2021 12:41 pm:
> Excerpts from Athira Rajeev's message of July 10, 2021 12:50 pm:
>>=20
>>=20
>>> On 22-Jun-2021, at 4:27 PM, Nicholas Piggin <npiggin@gmail.com> wrote:
>>>=20
>>> KVM PMU management code looks for particular frozen/disabled bits in
>>> the PMU registers so it knows whether it must clear them when coming
>>> out of a guest or not. Setting this up helps KVM make these optimisatio=
ns
>>> without getting confused. Longer term the better approach might be to
>>> move guest/host PMU switching to the perf subsystem.
>>>=20
>>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>>> ---
>>> arch/powerpc/kernel/cpu_setup_power.c | 4 ++--
>>> arch/powerpc/kernel/dt_cpu_ftrs.c     | 6 +++---
>>> arch/powerpc/kvm/book3s_hv.c          | 5 +++++
>>> arch/powerpc/perf/core-book3s.c       | 7 +++++++
>>> 4 files changed, 17 insertions(+), 5 deletions(-)
>>>=20
>>> diff --git a/arch/powerpc/kernel/cpu_setup_power.c b/arch/powerpc/kerne=
l/cpu_setup_power.c
>>> index a29dc8326622..3dc61e203f37 100644
>>> --- a/arch/powerpc/kernel/cpu_setup_power.c
>>> +++ b/arch/powerpc/kernel/cpu_setup_power.c
>>> @@ -109,7 +109,7 @@ static void init_PMU_HV_ISA207(void)
>>> static void init_PMU(void)
>>> {
>>> 	mtspr(SPRN_MMCRA, 0);
>>> -	mtspr(SPRN_MMCR0, 0);
>>> +	mtspr(SPRN_MMCR0, MMCR0_FC);
>>> 	mtspr(SPRN_MMCR1, 0);
>>> 	mtspr(SPRN_MMCR2, 0);
>>> }
>>> @@ -123,7 +123,7 @@ static void init_PMU_ISA31(void)
>>> {
>>> 	mtspr(SPRN_MMCR3, 0);
>>> 	mtspr(SPRN_MMCRA, MMCRA_BHRB_DISABLE);
>>> -	mtspr(SPRN_MMCR0, MMCR0_PMCCEXT);
>>> +	mtspr(SPRN_MMCR0, MMCR0_FC | MMCR0_PMCCEXT);
>>> }
>>>=20
>>> /*
>>> diff --git a/arch/powerpc/kernel/dt_cpu_ftrs.c b/arch/powerpc/kernel/dt=
_cpu_ftrs.c
>>> index 0a6b36b4bda8..06a089fbeaa7 100644
>>> --- a/arch/powerpc/kernel/dt_cpu_ftrs.c
>>> +++ b/arch/powerpc/kernel/dt_cpu_ftrs.c
>>> @@ -353,7 +353,7 @@ static void init_pmu_power8(void)
>>> 	}
>>>=20
>>> 	mtspr(SPRN_MMCRA, 0);
>>> -	mtspr(SPRN_MMCR0, 0);
>>> +	mtspr(SPRN_MMCR0, MMCR0_FC);
>>> 	mtspr(SPRN_MMCR1, 0);
>>> 	mtspr(SPRN_MMCR2, 0);
>>> 	mtspr(SPRN_MMCRS, 0);
>>> @@ -392,7 +392,7 @@ static void init_pmu_power9(void)
>>> 		mtspr(SPRN_MMCRC, 0);
>>>=20
>>> 	mtspr(SPRN_MMCRA, 0);
>>> -	mtspr(SPRN_MMCR0, 0);
>>> +	mtspr(SPRN_MMCR0, MMCR0_FC);
>>> 	mtspr(SPRN_MMCR1, 0);
>>> 	mtspr(SPRN_MMCR2, 0);
>>> }
>>> @@ -428,7 +428,7 @@ static void init_pmu_power10(void)
>>>=20
>>> 	mtspr(SPRN_MMCR3, 0);
>>> 	mtspr(SPRN_MMCRA, MMCRA_BHRB_DISABLE);
>>> -	mtspr(SPRN_MMCR0, MMCR0_PMCCEXT);
>>> +	mtspr(SPRN_MMCR0, MMCR0_FC | MMCR0_PMCCEXT);
>>> }
>>>=20
>>> static int __init feat_enable_pmu_power10(struct dt_cpu_feature *f)
>>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.=
c
>>> index 1f30f98b09d1..f7349d150828 100644
>>> --- a/arch/powerpc/kvm/book3s_hv.c
>>> +++ b/arch/powerpc/kvm/book3s_hv.c
>>> @@ -2593,6 +2593,11 @@ static int kvmppc_core_vcpu_create_hv(struct kvm=
_vcpu *vcpu)
>>> #endif
>>> #endif
>>> 	vcpu->arch.mmcr[0] =3D MMCR0_FC;
>>> +	if (cpu_has_feature(CPU_FTR_ARCH_31)) {
>>> +		vcpu->arch.mmcr[0] |=3D MMCR0_PMCCEXT;
>>> +		vcpu->arch.mmcra =3D MMCRA_BHRB_DISABLE;
>>> +	}
>>> +
>>> 	vcpu->arch.ctrl =3D CTRL_RUNLATCH;
>>> 	/* default to host PVR, since we can't spoof it */
>>> 	kvmppc_set_pvr_hv(vcpu, mfspr(SPRN_PVR));
>>> diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-b=
ook3s.c
>>> index 51622411a7cc..e33b29ec1a65 100644
>>> --- a/arch/powerpc/perf/core-book3s.c
>>> +++ b/arch/powerpc/perf/core-book3s.c
>>> @@ -1361,6 +1361,13 @@ static void power_pmu_enable(struct pmu *pmu)
>>> 		goto out;
>>>=20
>>> 	if (cpuhw->n_events =3D=3D 0) {
>>> +		if (cpu_has_feature(CPU_FTR_ARCH_31)) {
>>> +			mtspr(SPRN_MMCRA, MMCRA_BHRB_DISABLE);
>>> +			mtspr(SPRN_MMCR0, MMCR0_FC | MMCR0_PMCCEXT);
>>> +		} else {
>>> +			mtspr(SPRN_MMCRA, 0);
>>> +			mtspr(SPRN_MMCR0, MMCR0_FC);
>>> +		}
>>=20
>>=20
>> Hi Nick,
>>=20
>> We are setting these bits in =E2=80=9Cpower_pmu_disable=E2=80=9D functio=
n. And disable will be called before any event gets deleted/stopped. Can yo=
u please help to understand why this is needed in power_pmu_enable path als=
o ?
>=20
> I'll have to go back and check what I needed it for.

Okay, MMCRA is getting MMCRA_SDAR_MODE_DCACHE set on POWER9, by the looks.

That's not necessarily a problem, but KVM sets MMCRA to 0 to disable
SDAR updates. So KVM and perf don't agree on what the "correct" value
for disabled is. Which could be a problem with POWER10 not setting BHRB
disable before my series.

I'll get rid of this hunk for now, I expect things won't be exactly clean
or consistent until the KVM host PMU code is moved into perf/ though.

Thanks,
Nick
