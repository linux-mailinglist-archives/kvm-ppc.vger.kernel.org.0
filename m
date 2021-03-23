Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCECD345C07
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 11:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhCWKhY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 23 Mar 2021 06:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbhCWKgw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 23 Mar 2021 06:36:52 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA36FC061574
        for <kvm-ppc@vger.kernel.org>; Tue, 23 Mar 2021 03:36:51 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id il9-20020a17090b1649b0290114bcb0d6c2so4702150pjb.0
        for <kvm-ppc@vger.kernel.org>; Tue, 23 Mar 2021 03:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=Zy4Lsebf4U9tDEG2NTT8UKOvjnIFpxNqf841zIhhRxs=;
        b=J0EXEIMGFMlRPQ2VNtjXkh7O71Y4v+eWToFpaAZ8q5ZQ0uaCwdL7BIDk8NMZtuBmXV
         kp1bi6rMGobTw5eyp2sn9yKGMBUJ19EGSaCg7D9SD/yZH45D2KeG62tsKNf2KSdiOa60
         yAWQCQEOTokTSBCm9sQPA+wRNH5JBdP0XqVIZiHY2eP5zvnFOoVwLGMpoFgLwv8XF9qH
         TIc4hhUS9/hWTx9IQvlz+Bs4ff9ViRzQH5JJJpdMYFrlY24umOYCeO4fOl9ymawNdyXH
         XLMFhLGSUEehJlm6GB/2UAEFmk5BRmODsqzhbKI8gGaJeL9R7AegBW+zxd9ROXZULVLf
         Gang==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=Zy4Lsebf4U9tDEG2NTT8UKOvjnIFpxNqf841zIhhRxs=;
        b=YrCvW7CZXSjTMEjfZzgrMj6R+Q7TakmstM3ZSS4p+Tn3iUPHpGZbePdP83iKJh1zbN
         mIS7LKqIGgrnwUPuGZCA3s5ZHB7JUbDSW8SAfhAd6Bkg4ECRVgj5VWhINyMAvm5y6gwp
         aFPTUSGmuJ5AMUCznvx61foMCK1U7ymzVRakvMVt9EmxGDrqonAk6xQ4T8c54ikQYgQg
         w3oq5ECp5jh1zhm4u6bTLV9oTFO8fkRNHCQ0BWfmrKSOwgITjiIdG70490d3pRBwcx0m
         2r2Vn+ZNexgx03CCfCAcuTdSvNqHFWkPFf7Rrt9Ik3zsoGVI96YzUnX5ggR4mtXGZ3cw
         yNIg==
X-Gm-Message-State: AOAM531WuDplfLM/zT8mJs51Ja6uEonrQWWOC2HuZcqKGWZYV46W9mVY
        GeK3y/X73kn5jCbb7NPawiz2datda9Q=
X-Google-Smtp-Source: ABdhPJyENyyZjqyChHgnp5OQUD4sJWDRB5LVETYT8qYS1zyh363VbQ7c9ouAgbrVV+ngn4SVE3z7Sg==
X-Received: by 2002:a17:90a:fd0a:: with SMTP id cv10mr3756762pjb.167.1616495811395;
        Tue, 23 Mar 2021 03:36:51 -0700 (PDT)
Received: from localhost ([1.132.171.141])
        by smtp.gmail.com with ESMTPSA id v27sm16536610pfi.89.2021.03.23.03.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 03:36:50 -0700 (PDT)
Date:   Tue, 23 Mar 2021 20:36:44 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 28/46] KVM: PPC: Book3S HV P9: Reduce irq_work vs guest
 decrementer races
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210323010305.1045293-1-npiggin@gmail.com>
        <20210323010305.1045293-29-npiggin@gmail.com>
        <3ca0e504-70df-2a25-12af-a1addac842b6@ozlabs.ru>
In-Reply-To: <3ca0e504-70df-2a25-12af-a1addac842b6@ozlabs.ru>
MIME-Version: 1.0
Message-Id: <1616495617.6070udmp89.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Alexey Kardashevskiy's message of March 23, 2021 8:13 pm:
>=20
>=20
> On 23/03/2021 12:02, Nicholas Piggin wrote:
>> irq_work's use of the DEC SPR is racy with guest<->host switch and guest
>> entry which flips the DEC interrupt to guest, which could lose a host
>> work interrupt.
>>=20
>> This patch closes one race, and attempts to comment another class of
>> races.
>>=20
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>>   arch/powerpc/kvm/book3s_hv.c | 15 ++++++++++++++-
>>   1 file changed, 14 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index 1f38a0abc611..989a1ff5ad11 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -3745,6 +3745,18 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *=
vcpu, u64 time_limit,
>>   	if (!(vcpu->arch.ctrl & 1))
>>   		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
>>  =20
>> +	/*
>> +	 * When setting DEC, we must always deal with irq_work_raise via NMI v=
s
>> +	 * setting DEC. The problem occurs right as we switch into guest mode
>> +	 * if a NMI hits and sets pending work and sets DEC, then that will
>> +	 * apply to the guest and not bring us back to the host.
>> +	 *
>> +	 * irq_work_raise could check a flag (or possibly LPCR[HDICE] for
>> +	 * example) and set HDEC to 1? That wouldn't solve the nested hv
>> +	 * case which needs to abort the hcall or zero the time limit.
>> +	 *
>> +	 * XXX: Another day's problem.
>> +	 */
>>   	mtspr(SPRN_DEC, vcpu->arch.dec_expires - tb);
>>  =20
>>   	if (kvmhv_on_pseries()) {
>> @@ -3879,7 +3891,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *v=
cpu, u64 time_limit,
>>   	vc->entry_exit_map =3D 0x101;
>>   	vc->in_guest =3D 0;
>>  =20
>> -	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - tb);
>> +	set_dec_or_work(local_paca->kvm_hstate.dec_expires - tb);
>=20
>=20
> set_dec_or_work() will write local_paca->kvm_hstate.dec_expires - tb - 1=20
> to SPRN_DEC which is not exactly the same, is this still alright?
>=20
> I asked in v3 but it is probably lost :)

Oh I did see that then forgot.

It will write dec_expires - tb, then it will write 1 if it found irq_work
was pending.

The change is intentional to fixes one of the lost irq_work races.

Thanks,
Nick
