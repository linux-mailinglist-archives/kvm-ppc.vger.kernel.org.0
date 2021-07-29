Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B78B3D9C66
	for <lists+kvm-ppc@lfdr.de>; Thu, 29 Jul 2021 05:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbhG2Dw7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 28 Jul 2021 23:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233485AbhG2Dw7 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 28 Jul 2021 23:52:59 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDF9C061757
        for <kvm-ppc@vger.kernel.org>; Wed, 28 Jul 2021 20:52:55 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d1so5358115pll.1
        for <kvm-ppc@vger.kernel.org>; Wed, 28 Jul 2021 20:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=raQOQdpU8K2UcVzsPkwxSrz9lH1X2bF4EYfiRD2nT6s=;
        b=Cx8+UoRrPb/UJrxJCmiaervR89VoYhb4pKbdaDCzptlzQsuXGXkWA7jLxsvjRZGGje
         UYhR4hEUGsRc2/QK0LjZnTMlHyMnE/pJ+kC8u6N/4qbZ6f4cA78SnjZM4aQacipq3x1x
         u9foYMtYwoR7d3eBHRo7pRRqQGTPOaa1MSansAJiL1r2bddS2JzCxsxUoBxJvfIcJUNL
         Fp7fVpTVxUL/Ut/oNUXWf3aIhyINM0Ey2Qw1SyYgbW/GbcKh3WggEzXDzRlhvNwifFfC
         7OjkYUwsBWqRRahPzv8zMtG2cBD3gjEwVHU9QuJ8UDjmaUSav5srdXfOAmYJp/UFIaqz
         3MnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=raQOQdpU8K2UcVzsPkwxSrz9lH1X2bF4EYfiRD2nT6s=;
        b=avrNsoujDRT3Yuluv2UWQYU030Towa7iM6OU+rSKC1q/N+9ZskK743ODA6+KZtdEBr
         PGoIzAjnwVnd1tsm4cWshV/9nB2oks/7c0tFdJkQ0uvF+MJ1BfoKMlvJQpJwLdBx9BV3
         oQ/xK3toNnKE+/gy3i87HRDe5xYWku2oNHcDRwTuYbBapJQhCGVY3ja1l+K3oa09Rbv0
         NPjwKRCVY7yE3r63Qdl/NGD9qgLYXemnSa2ce8USc37haPkxh1xq1LSO8PgYyKOERtb+
         jFzjKokL08myqbDIgFYEW2lL+KkGrjow+0TSDwk/lKSkFiMyc5uCc/LdAT+3f7tyBJy6
         FILg==
X-Gm-Message-State: AOAM533MZzxDs9xpV2/IypIYCd9vmvmQRmpAWMYoG/EfmHrurKaDxIa4
        Psp5DQLc7lLigt93QImVr3fPuZalcHU=
X-Google-Smtp-Source: ABdhPJxDweUZAz5Tfmv1Rf7bAzdB4obsZEjB0XbY1Qi5y8V6zbn6f2uuSW2cEv0m7m4f6U9rM4CFig==
X-Received: by 2002:a17:902:8c83:b029:129:17e5:a1cc with SMTP id t3-20020a1709028c83b029012917e5a1ccmr2696576plo.49.1627530775419;
        Wed, 28 Jul 2021 20:52:55 -0700 (PDT)
Received: from localhost (60-242-181-102.static.tpgi.com.au. [60.242.181.102])
        by smtp.gmail.com with ESMTPSA id a23sm1525283pff.43.2021.07.28.20.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 20:52:54 -0700 (PDT)
Date:   Thu, 29 Jul 2021 13:52:49 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v5 2/2] KVM: PPC: Book3S HV: Stop forwarding all HFUs to
 L1
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20210726201710.2432874-1-farosas@linux.ibm.com>
        <20210726201710.2432874-3-farosas@linux.ibm.com>
        <1627355201.gqa4czyyxy.astroid@bobo.none> <87o8anddsr.fsf@linux.ibm.com>
In-Reply-To: <87o8anddsr.fsf@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1627530625.zza0qspyp2.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of July 28, 2021 12:36 am:
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
>> Excerpts from Fabiano Rosas's message of July 27, 2021 6:17 am:
>>> If the nested hypervisor has no access to a facility because it has
>>> been disabled by the host, it should also not be able to see the
>>> Hypervisor Facility Unavailable that arises from one of its guests
>>> trying to access the facility.
>>>=20
>>> This patch turns a HFU that happened in L2 into a Hypervisor Emulation
>>> Assistance interrupt and forwards it to L1 for handling. The ones that
>>> happened because L1 explicitly disabled the facility for L2 are still
>>> let through, along with the corresponding Cause bits in the HFSCR.
>>>=20
>>> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
>>> Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
>>> ---
>>>  arch/powerpc/kvm/book3s_hv_nested.c | 32 +++++++++++++++++++++++------
>>>  1 file changed, 26 insertions(+), 6 deletions(-)
>>>=20
>>> diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/boo=
k3s_hv_nested.c
>>> index 8215dbd4be9a..d544b092b49a 100644
>>> --- a/arch/powerpc/kvm/book3s_hv_nested.c
>>> +++ b/arch/powerpc/kvm/book3s_hv_nested.c
>>> @@ -99,7 +99,7 @@ static void byteswap_hv_regs(struct hv_guest_state *h=
r)
>>>  	hr->dawrx1 =3D swab64(hr->dawrx1);
>>>  }
>>> =20
>>> -static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
>>> +static void save_hv_return_state(struct kvm_vcpu *vcpu,
>>>  				 struct hv_guest_state *hr)
>>>  {
>>>  	struct kvmppc_vcore *vc =3D vcpu->arch.vcore;
>>> @@ -118,7 +118,7 @@ static void save_hv_return_state(struct kvm_vcpu *v=
cpu, int trap,
>>>  	hr->pidr =3D vcpu->arch.pid;
>>>  	hr->cfar =3D vcpu->arch.cfar;
>>>  	hr->ppr =3D vcpu->arch.ppr;
>>> -	switch (trap) {
>>> +	switch (vcpu->arch.trap) {
>>>  	case BOOK3S_INTERRUPT_H_DATA_STORAGE:
>>>  		hr->hdar =3D vcpu->arch.fault_dar;
>>>  		hr->hdsisr =3D vcpu->arch.fault_dsisr;
>>> @@ -128,9 +128,29 @@ static void save_hv_return_state(struct kvm_vcpu *=
vcpu, int trap,
>>>  		hr->asdr =3D vcpu->arch.fault_gpa;
>>>  		break;
>>>  	case BOOK3S_INTERRUPT_H_FAC_UNAVAIL:
>>> -		hr->hfscr =3D ((~HFSCR_INTR_CAUSE & hr->hfscr) |
>>> -			     (HFSCR_INTR_CAUSE & vcpu->arch.hfscr));
>>> -		break;
>>> +	{
>>> +		u8 cause =3D vcpu->arch.hfscr >> 56;
>>
>> Can this be u64 just to help gcc?
>>
>=20
> Yes.
>=20
>>> +
>>> +		WARN_ON_ONCE(cause >=3D BITS_PER_LONG);
>>> +
>>> +		if (!(hr->hfscr & (1UL << cause))) {
>>> +			hr->hfscr =3D ((~HFSCR_INTR_CAUSE & hr->hfscr) |
>>> +				     (HFSCR_INTR_CAUSE & vcpu->arch.hfscr));
>>> +			break;
>>> +		}
>>> +
>>> +		/*
>>> +		 * We have disabled this facility, so it does not
>>> +		 * exist from L1's perspective. Turn it into a HEAI.
>>> +		 */
>>> +		vcpu->arch.trap =3D BOOK3S_INTERRUPT_H_EMUL_ASSIST;
>>> +		kvmppc_load_last_inst(vcpu, INST_GENERIC, &vcpu->arch.emul_inst);
>>
>> Hmm, this doesn't handle kvmpc_load_last_inst failure. Other code tends=20
>> to just resume guest and retry in this case. Can we do that here?
>>
>=20
> Not at this point. The other code does that inside
> kvmppc_handle_exit_hv, which is called from kvmhv_run_single_vcpu. And
> since we're changing the interrupt, I cannot load the last instruction
> at kvmppc_handle_nested_exit because at that point this is still an HFU.
>=20
> Unless I do it anyway at the HFU handler and put a comment explaining
> the situation.

Yeah I think it would be better to move this logic to the nested exit=20
handler.

Thanks,
Nick
