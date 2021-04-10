Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB3535A994
	for <lists+kvm-ppc@lfdr.de>; Sat, 10 Apr 2021 02:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235248AbhDJAjc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 9 Apr 2021 20:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235215AbhDJAjc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 9 Apr 2021 20:39:32 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4CAC061762
        for <kvm-ppc@vger.kernel.org>; Fri,  9 Apr 2021 17:39:18 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id s11so5320013pfm.1
        for <kvm-ppc@vger.kernel.org>; Fri, 09 Apr 2021 17:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=4rF03JidtM+D0LnBUikUiJ0mld3+dGK6ar3jXocIBiA=;
        b=XsMNRpQLYJ+8Wu8fetCzXqJzN0OWdo5qVCC8X2SemRkRe+ALPE2riz2x8f+BJXE2FP
         dVkP7AU69POvoqeKYeSIG3RmF3RNw0oozIemVhaQpRxrQNwL6lyn58InNjYElTg/OwaZ
         kvQ0Z6qdSMa2R385JtculaqAvyKerXvP2P0/CEu3VatMVMvoTepoThkr6cTkrPRyoozq
         VnbtQm+e/ns1ilL37Yf0LqVTWB5gsKG1wuabqHcTp9zbJoTPIbGJhQDnfNpLfghUxFj0
         mMltKh8l3r7ql/1Y1lSx9dwMbBNu/h7K7kDI8+6pHARN0f3VJ9k+aPRzr9kFpmCujZHQ
         PvqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=4rF03JidtM+D0LnBUikUiJ0mld3+dGK6ar3jXocIBiA=;
        b=QPGlQW6yNDvoyvh4ti2VRJVEtcfnUu+VuE0HBuzOAGyTiDSZQvs0NJ9l+DyUL+kNjF
         v7Pzx41VtwOQTct5h/c0nuKLvtJBjv/BeltV4tJG3K9iIUoGcm/x7llN3iisSAr9vjZt
         S5KNCNfWa7sl+6eBRK0dxJf/wBqGpNSGjBtAPh2R53F4vVyyEGZzFBV9VkZRgwN7iu8a
         DawmFn8EjSbyh5pV2silULGdqvDn8wgt0Hp7Bg7Elp7AHjdJ2xvf9G+Z71AjR9eOVWt7
         xZtCA7Yt9FEXdF5PS65dhzpXyN3JKPa9SYzmSe70hcfy/5fASiveQEf8V0BPZnWK8thE
         8oHQ==
X-Gm-Message-State: AOAM5325UcO7mrTD4vtA1P++Nd7zP3GwvlZEVRjbNnKjlaJyEg/hNQwM
        wRSk3nohqX6Z5v9e+ajDGgDZubTnMCk=
X-Google-Smtp-Source: ABdhPJxlv0OYddF1cEBY9fRh9xHL4V/uqYEv98fk64mKs6/pQ3r1vFgJOesAaxLNxtETIDm6Xv0ovg==
X-Received: by 2002:a05:6a00:174a:b029:1fc:d9ba:da96 with SMTP id j10-20020a056a00174ab02901fcd9bada96mr14948542pfc.40.1618015157623;
        Fri, 09 Apr 2021 17:39:17 -0700 (PDT)
Received: from localhost (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id w134sm3320603pfd.173.2021.04.09.17.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 17:39:17 -0700 (PDT)
Date:   Sat, 10 Apr 2021 10:39:12 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v6 32/48] KVM: PPC: Book3S HV P9: Read machine check
 registers while MSR[RI] is 0
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210405011948.675354-1-npiggin@gmail.com>
        <20210405011948.675354-33-npiggin@gmail.com>
        <0adc89d0-c765-d11b-ffe4-cbbf2f8f9c49@ozlabs.ru>
In-Reply-To: <0adc89d0-c765-d11b-ffe4-cbbf2f8f9c49@ozlabs.ru>
MIME-Version: 1.0
Message-Id: <1618015061.uwukywc8lr.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Alexey Kardashevskiy's message of April 9, 2021 6:55 pm:
>=20
>=20
> On 05/04/2021 11:19, Nicholas Piggin wrote:
>> SRR0/1, DAR, DSISR must all be protected from machine check which can
>> clobber them. Ensure MSR[RI] is clear while they are live.
>>=20
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>>   arch/powerpc/kvm/book3s_hv.c           | 11 +++++++--
>>   arch/powerpc/kvm/book3s_hv_interrupt.c | 33 +++++++++++++++++++++++---
>>   arch/powerpc/kvm/book3s_hv_ras.c       |  2 ++
>>   3 files changed, 41 insertions(+), 5 deletions(-)
>>=20
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index d6eecedaa5a5..5f0ac6567a06 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -3567,11 +3567,16 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu =
*vcpu, u64 time_limit,
>>   	mtspr(SPRN_BESCR, vcpu->arch.bescr);
>>   	mtspr(SPRN_WORT, vcpu->arch.wort);
>>   	mtspr(SPRN_TIDR, vcpu->arch.tid);
>> -	mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
>> -	mtspr(SPRN_DSISR, vcpu->arch.shregs.dsisr);
>>   	mtspr(SPRN_AMR, vcpu->arch.amr);
>>   	mtspr(SPRN_UAMOR, vcpu->arch.uamor);
>>  =20
>> +	/*
>> +	 * DAR, DSISR, and for nested HV, SPRGs must be set with MSR[RI]
>> +	 * clear (or hstate set appropriately to catch those registers
>> +	 * being clobbered if we take a MCE or SRESET), so those are done
>> +	 * later.
>> +	 */
>> +
>>   	if (!(vcpu->arch.ctrl & 1))
>>   		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
>>  =20
>> @@ -3614,6 +3619,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *v=
cpu, u64 time_limit,
>>   			hvregs.vcpu_token =3D vcpu->vcpu_id;
>>   		}
>>   		hvregs.hdec_expiry =3D time_limit;
>> +		mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
>> +		mtspr(SPRN_DSISR, vcpu->arch.shregs.dsisr);
>>   		trap =3D plpar_hcall_norets(H_ENTER_NESTED, __pa(&hvregs),
>>   					  __pa(&vcpu->arch.regs));
>>   		kvmhv_restore_hv_return_state(vcpu, &hvregs);
>> diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/b=
ook3s_hv_interrupt.c
>> index 6fdd93936e16..e93d2a6456ff 100644
>> --- a/arch/powerpc/kvm/book3s_hv_interrupt.c
>> +++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
>> @@ -132,6 +132,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 t=
ime_limit, unsigned long lpc
>>   	s64 hdec;
>>   	u64 tb, purr, spurr;
>>   	u64 *exsave;
>> +	bool ri_set;
>>   	unsigned long msr =3D mfmsr();
>>   	int trap;
>>   	unsigned long host_hfscr =3D mfspr(SPRN_HFSCR);
>> @@ -203,9 +204,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 t=
ime_limit, unsigned long lpc
>>   	 */
>>   	mtspr(SPRN_HDEC, hdec);
>>  =20
>> -	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
>> -	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
>> -
>>   	start_timing(vcpu, &vcpu->arch.rm_entry);
>>  =20
>>   	vcpu->arch.ceded =3D 0;
>> @@ -231,6 +229,13 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 =
time_limit, unsigned long lpc
>>   	 */
>>   	mtspr(SPRN_HDSISR, HDSISR_CANARY);
>>  =20
>> +	__mtmsrd(0, 1); /* clear RI */
>> +
>> +	mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
>> +	mtspr(SPRN_DSISR, vcpu->arch.shregs.dsisr);
>> +	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
>> +	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
>> +
>>   	accumulate_time(vcpu, &vcpu->arch.guest_time);
>>  =20
>>   	local_paca->kvm_hstate.in_guest =3D KVM_GUEST_MODE_GUEST_HV_FAST;
>> @@ -248,7 +253,13 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 =
time_limit, unsigned long lpc
>>  =20
>>   	/* 0x2 bit for HSRR is only used by PR and P7/8 HV paths, clear it */
>>   	trap =3D local_paca->kvm_hstate.scratch0 & ~0x2;
>> +
>> +	/* HSRR interrupts leave MSR[RI] unchanged, SRR interrupts clear it. *=
/
>> +	ri_set =3D false;
>>   	if (likely(trap > BOOK3S_INTERRUPT_MACHINE_CHECK)) {
>> +		if (trap !=3D BOOK3S_INTERRUPT_SYSCALL &&
>> +				(vcpu->arch.shregs.msr & MSR_RI))
>> +			ri_set =3D true;
>>   		exsave =3D local_paca->exgen;
>>   	} else if (trap =3D=3D BOOK3S_INTERRUPT_SYSTEM_RESET) {
>>   		exsave =3D local_paca->exnmi;
>> @@ -258,6 +269,22 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 =
time_limit, unsigned long lpc
>>  =20
>>   	vcpu->arch.regs.gpr[1] =3D local_paca->kvm_hstate.scratch1;
>>   	vcpu->arch.regs.gpr[3] =3D local_paca->kvm_hstate.scratch2;
>> +
>> +	/*
>> +	 * Only set RI after reading machine check regs (DAR, DSISR, SRR0/1)
>> +	 * and hstate scratch (which we need to move into exsave to make
>> +	 * re-entrant vs SRESET/MCE)
>> +	 */
>> +	if (ri_set) {
>> +		if (unlikely(!(mfmsr() & MSR_RI))) {
>> +			__mtmsrd(MSR_RI, 1);
>> +			WARN_ON_ONCE(1);
>> +		}
>> +	} else {
>> +		WARN_ON_ONCE(mfmsr() & MSR_RI);
>> +		__mtmsrd(MSR_RI, 1);
>> +	}
>> +
>>   	vcpu->arch.regs.gpr[9] =3D exsave[EX_R9/sizeof(u64)];
>>   	vcpu->arch.regs.gpr[10] =3D exsave[EX_R10/sizeof(u64)];
>>   	vcpu->arch.regs.gpr[11] =3D exsave[EX_R11/sizeof(u64)];
>> diff --git a/arch/powerpc/kvm/book3s_hv_ras.c b/arch/powerpc/kvm/book3s_=
hv_ras.c
>> index d4bca93b79f6..8d8a4d5f0b55 100644
>> --- a/arch/powerpc/kvm/book3s_hv_ras.c
>> +++ b/arch/powerpc/kvm/book3s_hv_ras.c
>> @@ -199,6 +199,8 @@ static void kvmppc_tb_resync_done(void)
>>    * know about the exact state of the TB value. Resync TB call will
>>    * restore TB to host timebase.
>>    *
>> + * This could use the new OPAL_HANDLE_HMI2 to avoid resyncing TB every =
time.
>=20
>=20
> Educating myself - is it because OPAL_HANDLE_HMI2 tells if it is TB/TOD=20
> which is the problem so we can avoid calling opal_resync_timebase() if=20
> it is not TB?

Yes.

> OPAL_HANDLE_HMI2 does not seem to resync TB itself. The=20
> comment just does not seem related to the rest of the patch.

Yeah it's not related, I'll take it out.

>=20
> Otherwise, looks good.
>=20
> Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Thanks,
Nick
