Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9A33BFA8B
	for <lists+kvm-ppc@lfdr.de>; Thu,  8 Jul 2021 14:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhGHMsj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 8 Jul 2021 08:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbhGHMsj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 8 Jul 2021 08:48:39 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA42C061574
        for <kvm-ppc@vger.kernel.org>; Thu,  8 Jul 2021 05:45:56 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id d12so5808383pgd.9
        for <kvm-ppc@vger.kernel.org>; Thu, 08 Jul 2021 05:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=V9F9nU6MbirMGKo2lzCFkdt6YjO4+T9M0GAqL4st5Zw=;
        b=YlSg5KTLns4/Qz5wajNfrxRNcTtoQ5Jl7jDZZ8dCrtRuMoAi+WhE9NMrncKXJtZU7U
         MN3ekSTUvnqBT+gbt+YEWbvvO+XaytYyI9CruRDbPyACkiFatEFAQSsqXMj1WP8aI31K
         EY6zjek/+/cHVdY+N6IetLxdW+WUTyvC6QxuuvHG+YaYX43i1IwXwlIJMI7RjLoyO0fR
         Rxxb0RPJ76EwXRHGiNEgE1MChDTYw2mXVqZc1wbCMZI7inE2v9TXuUHzri1L7ktyn77g
         1f3jA13z+V/BcjrMosHdmkfzmNqO8bfFYN7Q0hXjRdnkmxOf80840wjVraLeCQYMcBXi
         5hjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=V9F9nU6MbirMGKo2lzCFkdt6YjO4+T9M0GAqL4st5Zw=;
        b=knQNiJ40nsLucx9kfj8UKHx8MCm5to/4iCVFzMBewLsUavVWvkQW+YUOIuryUeYRCO
         xlpm7htYFIbSg/O9KSLOgObelWrwef0d9ctfarYdpUvtSUGRGg9lSLMiUuMEPwCucx/i
         5uRtdVnOjbRmwbchi9bhSghHLlJ/qh5+QNJqKxuQhL9QtoI0+dmMIqW6prn0UpcOCenH
         7n9U29DlK4vU7Bbw3R2MPC0g5RuCTZTMN+vHjKrEf8KNl/1X/jEItAOrupMtSlmTzHBM
         NXZu0PiTGudwcnsTAiqZhXrgJhp9VL8T80iSHUvklJ+06l8awXKUVbb8UwYZ/ySHOvth
         optQ==
X-Gm-Message-State: AOAM5334odbqr0XfBD73IzJAyMvvu4BN5DlFi/+mHo7pZTiKsDpXtvC4
        5AJP6lKywYeQyq0cvul3Z8BQAMJ7fts=
X-Google-Smtp-Source: ABdhPJxzzRZ518bBwLsflS/TK5EJCPaRfOj6cR9e7GiPVRZuLq8P25e3BS1Wypre4supFoO/8GwObA==
X-Received: by 2002:a05:6a00:1a0b:b029:31a:25cf:3dbd with SMTP id g11-20020a056a001a0bb029031a25cf3dbdmr28132323pfv.57.1625748355755;
        Thu, 08 Jul 2021 05:45:55 -0700 (PDT)
Received: from localhost (14-203-186-173.tpgi.com.au. [14.203.186.173])
        by smtp.gmail.com with ESMTPSA id e4sm3519813pgi.94.2021.07.08.05.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 05:45:55 -0700 (PDT)
Date:   Thu, 08 Jul 2021 22:45:49 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [RFC PATCH 10/43] powerpc/64s: Always set PMU control registers
 to frozen/disabled when not in use
To:     kvm-ppc@vger.kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210622105736.633352-1-npiggin@gmail.com>
        <20210622105736.633352-11-npiggin@gmail.com>
        <c607e40c-5334-e8b1-11ac-c1464332e01a@linux.ibm.com>
        <1625185125.n8jy7yqojr.astroid@bobo.none>
In-Reply-To: <1625185125.n8jy7yqojr.astroid@bobo.none>
MIME-Version: 1.0
Message-Id: <1625745913.qxusux97eo.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Nicholas Piggin's message of July 2, 2021 10:27 am:
> Excerpts from Madhavan Srinivasan's message of July 1, 2021 11:17 pm:
>>=20
>> On 6/22/21 4:27 PM, Nicholas Piggin wrote:
>>> KVM PMU management code looks for particular frozen/disabled bits in
>>> the PMU registers so it knows whether it must clear them when coming
>>> out of a guest or not. Setting this up helps KVM make these optimisatio=
ns
>>> without getting confused. Longer term the better approach might be to
>>> move guest/host PMU switching to the perf subsystem.
>>>
>>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>>> ---
>>>   arch/powerpc/kernel/cpu_setup_power.c | 4 ++--
>>>   arch/powerpc/kernel/dt_cpu_ftrs.c     | 6 +++---
>>>   arch/powerpc/kvm/book3s_hv.c          | 5 +++++
>>>   arch/powerpc/perf/core-book3s.c       | 7 +++++++
>>>   4 files changed, 17 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/powerpc/kernel/cpu_setup_power.c b/arch/powerpc/kerne=
l/cpu_setup_power.c
>>> index a29dc8326622..3dc61e203f37 100644
>>> --- a/arch/powerpc/kernel/cpu_setup_power.c
>>> +++ b/arch/powerpc/kernel/cpu_setup_power.c
>>> @@ -109,7 +109,7 @@ static void init_PMU_HV_ISA207(void)
>>>   static void init_PMU(void)
>>>   {
>>>   	mtspr(SPRN_MMCRA, 0);
>>> -	mtspr(SPRN_MMCR0, 0);
>>> +	mtspr(SPRN_MMCR0, MMCR0_FC);
>>=20
>> Sticky point here is, currently if not frozen, pmc5/6 will
>> keep countering. And not freezing them at boot is quiet useful
>> sometime, like say when running in a simulation where we could calculate
>> approx CPIs for micro benchmarks without perf subsystem.
>=20
> You even can't use the sysfs files in this sim environment? In that case
> what if we added a boot option that could set some things up? In that=20
> case possibly you could even gather some more types of events too.

What if we added this to allow sim environments to run PMC5/6 and=20
additionally specify MMCR1 without userspace involvement?

Thanks,
Nick

---
diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3=
s.c
index af8a4981c6f6..454771243529 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -2425,8 +2425,24 @@ int register_power_pmu(struct power_pmu *pmu)
 }
=20
 #ifdef CONFIG_PPC64
+static bool pmu_override =3D false;
+static unsigned long pmu_override_val;
+static void do_pmu_override(void *data)
+{
+	ppc_set_pmu_inuse(1);
+	if (pmu_override_val)
+		mtspr(SPRN_MMCR1, pmu_override_val);
+	mtspr(SPRN_MMCR0, mfspr(SPRN_MMCR0) & ~MMCR0_FC);
+}
+
 static int __init init_ppc64_pmu(void)
 {
+	if (cpu_has_feature(CPU_FTR_HVMODE) && pmu_override) {
+		printk(KERN_WARNING "perf: disabling perf due to pmu=3D command line opt=
ion.\n");
+		on_each_cpu(do_pmu_override, NULL, 1);
+		return 0;
+	}
+
 	/* run through all the pmu drivers one at a time */
 	if (!init_power5_pmu())
 		return 0;
@@ -2448,4 +2464,23 @@ static int __init init_ppc64_pmu(void)
 		return init_generic_compat_pmu();
 }
 early_initcall(init_ppc64_pmu);
+
+static int __init pmu_setup(char *str)
+{
+	unsigned long val;
+
+	if (!early_cpu_has_feature(CPU_FTR_HVMODE))
+		return 0;
+
+	pmu_override =3D true;
+
+	if (kstrtoul(str, 0, &val))
+		val =3D 0;
+
+	pmu_override_val =3D val;
+
+	return 1;
+}
+__setup("pmu=3D", pmu_setup);
+
 #endif
