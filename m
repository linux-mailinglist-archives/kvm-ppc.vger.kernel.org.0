Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF1C3E28CD
	for <lists+kvm-ppc@lfdr.de>; Fri,  6 Aug 2021 12:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245182AbhHFKmb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 6 Aug 2021 06:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245205AbhHFKm2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 6 Aug 2021 06:42:28 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A9CC061798
        for <kvm-ppc@vger.kernel.org>; Fri,  6 Aug 2021 03:42:12 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so18904166pji.5
        for <kvm-ppc@vger.kernel.org>; Fri, 06 Aug 2021 03:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=Su2FoZvTjNyFhkcrb74DU+6Bxyms7h8hsH5cbKjVj9o=;
        b=AiQpKcUofWPjal7idSoXYMhZBjuvZ91WMiJKSkjiBXVCAwRJ3ykp6Tjo6QCZElb/M4
         82T1e3AZdfC3S6LIrSSHQPNyPMuim3oPRqkOGJP56HgCmBTaFB9/DdadrwpjjdbhV8MP
         JSxWDPydeFIdEYPPL19yy05fVCl/xFqnv84TZC63EIyEJYyN/xDssR0iM3MRgMVV8UzH
         K1GMs4pVExSGVE6M3Dw4ofBgYq81AI2Omm6F7vkRUvuO6ZwhBOujll43YxGxLwWmXxpN
         dTfl0LfKwaofFSGZvIxnP0uWCS3DyRc6oLefW1tZFsfLjsV12HZapFYV5O3dQbNllVXJ
         4M7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=Su2FoZvTjNyFhkcrb74DU+6Bxyms7h8hsH5cbKjVj9o=;
        b=jRDUWbQaBJxZA/ZhTGQes5eKurhodg9BHQQmcXHZcCsr0AQFc59nVJUH/W8kt9+MAP
         wMTI501FiiA8B2UR5NVlbZ+RGPKJHFZy6ZnMZRHRJwL7I4p1i5AJs7MXefd2J/+w5C4T
         oH+Qtq1NUHM1j72Y/mzYsTXydyOOhz1FWpKVLxgsjJfYvKv2El7PDR8FbC30UkXTPSaC
         RLp0hXTLf0C1x+Bz1SIpJCRsnAmlJ+U25PI804IO2gfvy22q5mFGAgGklau/XX91/YJJ
         pKUHuyywG3+J2zyqyj4rhQSWCYMJIb5fvooyZHjk35e2LSMboRhN+vEYXj0bvnhbCKPi
         5baQ==
X-Gm-Message-State: AOAM5314GTbgNBM3LvGUMAdjLtandyqV+PZMl+DdbCDm9cUTgl0zU2oF
        63RUBiv5bMtglelzCEDOZxE=
X-Google-Smtp-Source: ABdhPJwZU/bMN6BSDX4xilu9nYoVTIqvp65jLo6kG++82gUwVg/0kjpixs5OG1+b4dfj8Cd9bzaRCA==
X-Received: by 2002:a63:bd41:: with SMTP id d1mr706338pgp.306.1628246531946;
        Fri, 06 Aug 2021 03:42:11 -0700 (PDT)
Received: from localhost ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id g22sm666973pfo.164.2021.08.06.03.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 03:42:11 -0700 (PDT)
Date:   Fri, 06 Aug 2021 20:42:06 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v1 16/55] powerpc/64s: Implement PMU override command line
 option
To:     Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20210726035036.739609-1-npiggin@gmail.com>
        <20210726035036.739609-17-npiggin@gmail.com>
        <4600EC62-5505-4856-AE23-939ED62287B3@linux.vnet.ibm.com>
In-Reply-To: <4600EC62-5505-4856-AE23-939ED62287B3@linux.vnet.ibm.com>
MIME-Version: 1.0
Message-Id: <1628246339.762vtrxskz.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Athira Rajeev's message of August 6, 2021 7:28 pm:
>=20
>=20
>> On 26-Jul-2021, at 9:19 AM, Nicholas Piggin <npiggin@gmail.com> wrote:
>>=20
>> It can be useful in simulators (with very constrained environments)
>> to allow some PMCs to run from boot so they can be sampled directly
>> by a test harness, rather than having to run perf.
>>=20
>> A previous change freezes counters at boot by default, so provide
>> a boot time option to un-freeze (plus a bit more flexibility).
>>=20
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>> .../admin-guide/kernel-parameters.txt         |  7 ++++
>> arch/powerpc/perf/core-book3s.c               | 35 +++++++++++++++++++
>> 2 files changed, 42 insertions(+)
>>=20
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documenta=
tion/admin-guide/kernel-parameters.txt
>> index bdb22006f713..96b7d0ebaa40 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -4089,6 +4089,13 @@
>> 			Override pmtimer IOPort with a hex value.
>> 			e.g. pmtmr=3D0x508
>>=20
>> +	pmu=3D		[PPC] Manually enable the PMU.
>> +			Enable the PMU by setting MMCR0 to 0 (clear FC bit).
>> +			This option is implemented for Book3S processors.
>> +			If a number is given, then MMCR1 is set to that number,
>> +			otherwise (e.g., 'pmu=3Don'), it is left 0. The perf
>> +			subsystem is disabled if this option is used.
>> +
>> 	pm_debug_messages	[SUSPEND,KNL]
>> 			Enable suspend/resume debug messages during boot up.
>>=20
>> diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-bo=
ok3s.c
>> index 65795cadb475..e7cef4fe17d7 100644
>> --- a/arch/powerpc/perf/core-book3s.c
>> +++ b/arch/powerpc/perf/core-book3s.c
>> @@ -2428,8 +2428,24 @@ int register_power_pmu(struct power_pmu *pmu)
>> }
>>=20
>> #ifdef CONFIG_PPC64
>> +static bool pmu_override =3D false;
>> +static unsigned long pmu_override_val;
>> +static void do_pmu_override(void *data)
>> +{
>> +	ppc_set_pmu_inuse(1);
>> +	if (pmu_override_val)
>> +		mtspr(SPRN_MMCR1, pmu_override_val);
>> +	mtspr(SPRN_MMCR0, mfspr(SPRN_MMCR0) & ~MMCR0_FC);
>=20
> Hi Nick
>=20
> Here, we are not doing any validity check for the value used to set MMCR1=
.=20
> For advanced users, the option to pass value for MMCR1 is fine. But other=
 cases, it could result in
> invalid event getting used. Do we need to restrict this boot time option =
for only PMC5/6 ?

Depends what would be useful. We don't have to prevent the admin shooting=20
themselves in the foot with options like this, but if we can make it=20
safer without making it less useful then that's always a good option.

Thanks,
Nick
