Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5BB3B9A0D
	for <lists+kvm-ppc@lfdr.de>; Fri,  2 Jul 2021 02:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbhGBA3k (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Jul 2021 20:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234384AbhGBA3j (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Jul 2021 20:29:39 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDA2C061762
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Jul 2021 17:27:07 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id a7so7911796pga.1
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Jul 2021 17:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=Mv2l8L9qkZyjNEBQ/qaLZr9TMbL0H/dYxh7Xq2ikV4I=;
        b=tnj7SZolgjHrF03LW2p20NAscL2YLSslrU/PDl8j/LGHIQxp89B2qr5u81/+T2vWbE
         AVJfQKK0xDionU9F9aTmYL0XKAJbAToDmCB6ZYK1lGcOKRvt5H1aV1FTLpBu+6ya8eIh
         gYUXnImdWv1np1JkUf7/MiaWmCo6LQlfdrg6+63sJjr9yBuE8biNApQtWqRikNmEHWuA
         0UCQ+v9TLZlrLQAvcbpb9BxM+hFFyJQRzR2nl6LlyhJOPRPG+Y7s0bPF24umkXXgCPEf
         1ldOJ0B0ricQbGVK3GQfiiXeArDaauPUb7btMOImLlkE2kXp2rpJC5QWlsanrCWYajpq
         VDqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=Mv2l8L9qkZyjNEBQ/qaLZr9TMbL0H/dYxh7Xq2ikV4I=;
        b=bV1fd5mtOuO3CdyVdmU9tOcxMMumbljhd1E1YuXPnWyGm4H0wmLx+FcbAQyXq0ze+6
         1KFNjrJgVT8Se40wgFe3zzDyprl7308aWgG0UtGimohKgFnS1IQmcMD2hNGH1becxXaF
         Dg1y9XZIoPHA230xQ42NEADuFeJoaYO4imEmyN+Lc2dH1/g483FnpcPARfPZT+BTsWWR
         7QTAMO19tS9XlcglKdf9fcLuTl8lJo7tWWCH8uYb814/YFIbeRDinTm5bgAr1WSoSymV
         /qy2EyqPvGYehRpKbABpJuXyOJp55+mIfwyPtE2h/rQ0bEx2AYguknWJmteF5hL98U9m
         6i6A==
X-Gm-Message-State: AOAM531slnNWPxx/hnB+yz+OGSHynOk8lw9SIlizmrPLLq78owHhcMo1
        oYcDvPmm5zHL3hb5XSnx9G7XUSnQas0=
X-Google-Smtp-Source: ABdhPJwfBAENLTeGErOioItJ3alfV6XsGGlY06CXfjBAosOWpL3uSEtCn3lFSAygVYBPaupaFafn/w==
X-Received: by 2002:a63:450e:: with SMTP id s14mr2232004pga.312.1625185627158;
        Thu, 01 Jul 2021 17:27:07 -0700 (PDT)
Received: from localhost ([118.209.250.144])
        by smtp.gmail.com with ESMTPSA id e1sm1228899pfd.16.2021.07.01.17.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 17:27:06 -0700 (PDT)
Date:   Fri, 02 Jul 2021 10:27:01 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [RFC PATCH 10/43] powerpc/64s: Always set PMU control registers
 to frozen/disabled when not in use
To:     kvm-ppc@vger.kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210622105736.633352-1-npiggin@gmail.com>
        <20210622105736.633352-11-npiggin@gmail.com>
        <c607e40c-5334-e8b1-11ac-c1464332e01a@linux.ibm.com>
In-Reply-To: <c607e40c-5334-e8b1-11ac-c1464332e01a@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1625185125.n8jy7yqojr.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Madhavan Srinivasan's message of July 1, 2021 11:17 pm:
>=20
> On 6/22/21 4:27 PM, Nicholas Piggin wrote:
>> KVM PMU management code looks for particular frozen/disabled bits in
>> the PMU registers so it knows whether it must clear them when coming
>> out of a guest or not. Setting this up helps KVM make these optimisation=
s
>> without getting confused. Longer term the better approach might be to
>> move guest/host PMU switching to the perf subsystem.
>>
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>>   arch/powerpc/kernel/cpu_setup_power.c | 4 ++--
>>   arch/powerpc/kernel/dt_cpu_ftrs.c     | 6 +++---
>>   arch/powerpc/kvm/book3s_hv.c          | 5 +++++
>>   arch/powerpc/perf/core-book3s.c       | 7 +++++++
>>   4 files changed, 17 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/powerpc/kernel/cpu_setup_power.c b/arch/powerpc/kernel=
/cpu_setup_power.c
>> index a29dc8326622..3dc61e203f37 100644
>> --- a/arch/powerpc/kernel/cpu_setup_power.c
>> +++ b/arch/powerpc/kernel/cpu_setup_power.c
>> @@ -109,7 +109,7 @@ static void init_PMU_HV_ISA207(void)
>>   static void init_PMU(void)
>>   {
>>   	mtspr(SPRN_MMCRA, 0);
>> -	mtspr(SPRN_MMCR0, 0);
>> +	mtspr(SPRN_MMCR0, MMCR0_FC);
>=20
> Sticky point here is, currently if not frozen, pmc5/6 will
> keep countering. And not freezing them at boot is quiet useful
> sometime, like say when running in a simulation where we could calculate
> approx CPIs for micro benchmarks without perf subsystem.

You even can't use the sysfs files in this sim environment? In that case
what if we added a boot option that could set some things up? In that=20
case possibly you could even gather some more types of events too.

Thanks,
Nick
