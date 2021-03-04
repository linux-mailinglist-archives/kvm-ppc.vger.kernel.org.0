Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E882C32D18F
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Mar 2021 12:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239444AbhCDLFf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 4 Mar 2021 06:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239435AbhCDLFH (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 4 Mar 2021 06:05:07 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5866C061574
        for <kvm-ppc@vger.kernel.org>; Thu,  4 Mar 2021 03:04:27 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id m6so18684404pfk.1
        for <kvm-ppc@vger.kernel.org>; Thu, 04 Mar 2021 03:04:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=XCyHkCIKclR0Z1S9ufGldSQduqOpwvCwqtLN206dFsY=;
        b=jPGpa4ByAGp91jlMnb0siOIuP8aiPlVHUEjEGjb+RRPiGDmD6XFjsKovBAe3epfH0I
         mh/PftsT9APuw3MuRFBy/AyxFf3fmN6vjICdvD8s9yyJJ5Rpe+HYNW+a6G48Mlp47RY1
         W1H/VF2SwCB69V8t/NeKnsgMY1Hjov5DyG7VAM1U8oj/gf2f8snkByDWKJNNX193QBYx
         mlEEGsp5bY7Uc8aLrZz2buNCKVEg2VtUPg4+Gcg3lDjCEWfCMQHeMgg7zayTvxnSgHpR
         DIVUVGGb4FHr276TWId7muBGHgnwVh4H8PqS77g0UyWY6mJOly5MWuEOQ6MQuEydu2ge
         abCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=XCyHkCIKclR0Z1S9ufGldSQduqOpwvCwqtLN206dFsY=;
        b=AhFBXeIA5Ti+bu0qqxYuMTPumpYnf+NhJWltN/1G2pwCMLhV4Ii54+cJ9yGBNZBOrH
         YanIXxJVSP6inBQYAEmUrlPgK040Ke9pdqN/+ZW6BiH3uBoEDSTGuMj5BUHX3FK+sTJ5
         FJXe3Xgcc9XazuPtBegCiJ58AhArWdIlQGSA0t+egPk2GFTNwX2wIcZFHK3l/c+/dXN+
         NtEeg8PbXdkjM6tH+1ao33ZWa12B/VX3SIolJljROphJmU4mjEfWPHcEIIO8q6d/Ig+o
         RP4ti0yVXgbdVM5cgtBId320Af/PCKnSpRJyYA7eo04O0MCE7f914Yi2QSC6SCzQXTJq
         Agfw==
X-Gm-Message-State: AOAM531X/IL4FAERPVV11VVqTV9PoREn5dt09RdHdQTf1b7LkXUE5SqY
        jI/SuR+JxTXPDiKmE9D/1mI=
X-Google-Smtp-Source: ABdhPJwVZUk/r07+KSgmxz4OpeIPwTSH3aQg6ZrkLxdGG93/BryIfJsycsasPuYW4aBdr02kUX1Hlg==
X-Received: by 2002:aa7:97a2:0:b029:1ee:b006:f1a1 with SMTP id d2-20020aa797a20000b02901eeb006f1a1mr3625936pfq.8.1614855867199;
        Thu, 04 Mar 2021 03:04:27 -0800 (PST)
Received: from localhost (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id b15sm26048577pgj.84.2021.03.04.03.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 03:04:26 -0800 (PST)
Date:   Thu, 04 Mar 2021 21:04:20 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 30/37] KVM: PPC: Book3S HV: Implement radix prefetch
 workaround by disabling MMU
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210225134652.2127648-1-npiggin@gmail.com>
        <20210225134652.2127648-31-npiggin@gmail.com> <87lfb5w8t2.fsf@linux.ibm.com>
In-Reply-To: <87lfb5w8t2.fsf@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1614855773.k7it9unvzd.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of March 3, 2021 7:21 am:
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
>> Rather than partition the guest PID space and catch and flush a rogue
>> guest, instead work around this issue by ensuring the MMU is always
>> disabled in HV mode while the guest MMU context is switched in.
>>
>> This may be a bit less efficient, but it is a lot less complicated and
>> allows the P9 path to trivally implement the workaround too. Newer CPUs
>> are not subject to this issue.
>>
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>>  arch/powerpc/include/asm/mmu_context.h   |  6 ----
>>  arch/powerpc/kvm/book3s_hv.c             | 10 ++++--
>>  arch/powerpc/kvm/book3s_hv_interrupt.c   | 14 ++++++--
>>  arch/powerpc/kvm/book3s_hv_rmhandlers.S  | 34 ------------------
>>  arch/powerpc/mm/book3s64/radix_pgtable.c | 27 +++++---------
>>  arch/powerpc/mm/book3s64/radix_tlb.c     | 46 ------------------------
>>  arch/powerpc/mm/mmu_context.c            |  4 +--
>>  7 files changed, 28 insertions(+), 113 deletions(-)
>>
>> diff --git a/arch/powerpc/include/asm/mmu_context.h b/arch/powerpc/inclu=
de/asm/mmu_context.h
>> index 652ce85f9410..bb5c7e5e142e 100644
>> --- a/arch/powerpc/include/asm/mmu_context.h
>> +++ b/arch/powerpc/include/asm/mmu_context.h
>> @@ -122,12 +122,6 @@ static inline bool need_extra_context(struct mm_str=
uct *mm, unsigned long ea)
>>  }
>>  #endif
>>
>> -#if defined(CONFIG_KVM_BOOK3S_HV_POSSIBLE) && defined(CONFIG_PPC_RADIX_=
MMU)
>> -extern void radix_kvm_prefetch_workaround(struct mm_struct *mm);
>> -#else
>> -static inline void radix_kvm_prefetch_workaround(struct mm_struct *mm) =
{ }
>> -#endif
>> -
>>  extern void switch_cop(struct mm_struct *next);
>>  extern int use_cop(unsigned long acop, struct mm_struct *mm);
>>  extern void drop_cop(unsigned long acop, struct mm_struct *mm);
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index ad16331c3370..c3064075f1d7 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -806,6 +806,10 @@ static int kvmppc_h_set_mode(struct kvm_vcpu *vcpu,=
 unsigned long mflags,
>>  		/* KVM does not support mflags=3D2 (AIL=3D2) */
>>  		if (mflags !=3D 0 && mflags !=3D 3)
>>  			return H_UNSUPPORTED_FLAG_START;
>> +		/* Prefetch bug */
>> +		if (cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG) &&
>> +				kvmhv_vcpu_is_radix(vcpu) && mflags =3D=3D 3)
>> +			return H_UNSUPPORTED_FLAG_START;
>=20
> So does this mean that if the host has the prefetch bug, all of its
> guests will run with AIL=3D0 all the time?

All radix guests will, yes.

> And what we're avoiding here is
> a guest setting AIL=3D3 which would (since there's no HAIL) cause
> hypervisor interrupts to be taken with MMU on, is that it?

Yes that's right.

> Do we need to add this verification to kvmppc_set_lpcr as well? QEMU
> could in theory call the KVM_SET_ONE_REG ioctl and set AIL to any value.

Yeah I guess so. We don't restrict other AIL values there by the looks
but maybe we should.

Thanks,
Nick
