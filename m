Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64A2345C98
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 12:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhCWLPx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 23 Mar 2021 07:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbhCWLPo (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 23 Mar 2021 07:15:44 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459AAC061574
        for <kvm-ppc@vger.kernel.org>; Tue, 23 Mar 2021 04:15:44 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id bt4so9917712pjb.5
        for <kvm-ppc@vger.kernel.org>; Tue, 23 Mar 2021 04:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=GgQoeoHoEyQVXeMsOEtdzhILOLPPs2n8xM2G4PNbRaU=;
        b=gFxZgRsreXCCkpMVFGxFpJC+nIVxbCX/eB/eaqev6jbq6Tg+UHe6uZBP07LowwB8hH
         94kzmaf/k7W4mw1QY6PZH1/jt84G5AhHpG5XKOZ0+iGl8rc68D4E3MoRDU/HQAnUqATd
         I2jOEFOGUz9cNPX9Zwj0QlnymRwtEXAch0mLQIr8Uapr8a2WNfPgxSQzcN0iMrQpHA2u
         ATgx4SkXqbySovRGOVz15ymRGB/IahikiHV0vKVTT3HbAMGxUgTXi6vL2HNlFQcmY4Cx
         x2bRaTMkSfQSS8viSzhMJ3VPiywmiXqZYNm4QbOBmYN56DM006pCdTWRXaABLwXL+glN
         tp8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=GgQoeoHoEyQVXeMsOEtdzhILOLPPs2n8xM2G4PNbRaU=;
        b=adWbGchG9NNSVGJ5HNTPwblwSMdq1AHQLBBzq06MQp7i2jdZ0OI96gIqBc37K3SQGe
         5f4EuPDoWnGVAaKSgH0PhdbmfBMeQ7IHctWFjsFRgQIkliUHN2oBpNQU9neXmSsQoLye
         aTzYvMeWn+Qx6be8Mn3EJPfiyHx3069fAmHsBxjt0vKd7FhKS0n2cQ7OsIDPLEF+MKU7
         wD/BBmvmERXU+t9erytIgYdofJzdmphZQh1HJGJ8K9otgnfMG7BDTUjlNHVOI0/KzRbx
         7REQoshkoD97SqHmed6yHGTyXkqiliibKjlvuBRTqhNfEaSJ4hS87iuklcKqXUANaRWD
         sARA==
X-Gm-Message-State: AOAM5326Ye70m2WpLycfJBtbziScgh6etFq7OBR6+wFyOvnbJWIKnWd5
        Ko0mOhdfQA2925OGFTI0shY=
X-Google-Smtp-Source: ABdhPJwYynjFSJjcc/BXLF46oyC36MTKii0rBTq3D8w1ufe+IszT332tCrztJEZM1MDtCXPYETL85w==
X-Received: by 2002:a17:90a:bd92:: with SMTP id z18mr4024787pjr.114.1616498143850;
        Tue, 23 Mar 2021 04:15:43 -0700 (PDT)
Received: from localhost ([1.132.171.72])
        by smtp.gmail.com with ESMTPSA id p25sm16959460pfe.100.2021.03.23.04.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 04:15:43 -0700 (PDT)
Date:   Tue, 23 Mar 2021 21:15:36 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 28/46] KVM: PPC: Book3S HV P9: Reduce irq_work vs guest
 decrementer races
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210323010305.1045293-1-npiggin@gmail.com>
        <20210323010305.1045293-29-npiggin@gmail.com>
        <3ca0e504-70df-2a25-12af-a1addac842b6@ozlabs.ru>
        <1616495617.6070udmp89.astroid@bobo.none>
In-Reply-To: <1616495617.6070udmp89.astroid@bobo.none>
MIME-Version: 1.0
Message-Id: <1616497884.p8em2a52ue.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Nicholas Piggin's message of March 23, 2021 8:36 pm:
> Excerpts from Alexey Kardashevskiy's message of March 23, 2021 8:13 pm:
>>=20
>>=20
>> On 23/03/2021 12:02, Nicholas Piggin wrote:
>>> irq_work's use of the DEC SPR is racy with guest<->host switch and gues=
t
>>> entry which flips the DEC interrupt to guest, which could lose a host
>>> work interrupt.
>>>=20
>>> This patch closes one race, and attempts to comment another class of
>>> races.
>>>=20
>>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>>> ---
>>>   arch/powerpc/kvm/book3s_hv.c | 15 ++++++++++++++-
>>>   1 file changed, 14 insertions(+), 1 deletion(-)
>>>=20
>>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.=
c
>>> index 1f38a0abc611..989a1ff5ad11 100644
>>> --- a/arch/powerpc/kvm/book3s_hv.c
>>> +++ b/arch/powerpc/kvm/book3s_hv.c
>>> @@ -3745,6 +3745,18 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu =
*vcpu, u64 time_limit,
>>>   	if (!(vcpu->arch.ctrl & 1))
>>>   		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
>>>  =20
>>> +	/*
>>> +	 * When setting DEC, we must always deal with irq_work_raise via NMI =
vs
>>> +	 * setting DEC. The problem occurs right as we switch into guest mode
>>> +	 * if a NMI hits and sets pending work and sets DEC, then that will
>>> +	 * apply to the guest and not bring us back to the host.
>>> +	 *
>>> +	 * irq_work_raise could check a flag (or possibly LPCR[HDICE] for
>>> +	 * example) and set HDEC to 1? That wouldn't solve the nested hv
>>> +	 * case which needs to abort the hcall or zero the time limit.
>>> +	 *
>>> +	 * XXX: Another day's problem.
>>> +	 */
>>>   	mtspr(SPRN_DEC, vcpu->arch.dec_expires - tb);
>>>  =20
>>>   	if (kvmhv_on_pseries()) {
>>> @@ -3879,7 +3891,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *=
vcpu, u64 time_limit,
>>>   	vc->entry_exit_map =3D 0x101;
>>>   	vc->in_guest =3D 0;
>>>  =20
>>> -	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - tb);
>>> +	set_dec_or_work(local_paca->kvm_hstate.dec_expires - tb);
>>=20
>>=20
>> set_dec_or_work() will write local_paca->kvm_hstate.dec_expires - tb - 1=
=20
>> to SPRN_DEC which is not exactly the same, is this still alright?
>>=20
>> I asked in v3 but it is probably lost :)
>=20
> Oh I did see that then forgot.
>=20
> It will write dec_expires - tb, then it will write 1 if it found irq_work
> was pending.

Ah you were actually asking about set_dec writing val - 1. I totally=20
missed that.

Yes that was an unintentional change. This is the way timer.c code works=20
with respect to the decrementers_next_tb value, so it's probably better=20
to make them so it seems like it should be okay (and better to bring the=20
KVM code up to match timer code rather than be different or the other
way around). The difference should be noted in the changelog though.

Thanks,
Nick
