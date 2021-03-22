Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0017343754
	for <lists+kvm-ppc@lfdr.de>; Mon, 22 Mar 2021 04:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhCVDSx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 21 Mar 2021 23:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhCVDSZ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 21 Mar 2021 23:18:25 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6136BC061574
        for <kvm-ppc@vger.kernel.org>; Sun, 21 Mar 2021 20:18:22 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id h25so7709227pgm.3
        for <kvm-ppc@vger.kernel.org>; Sun, 21 Mar 2021 20:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=2r0iVRr6v7y/H+eGodBK0e6KBH/Q8fDpFMrbGtG/Ww8=;
        b=SPyud3BEhBQyDDx6eq3AGbtBkkGiw2QFaQUUGr0Rjn5zbG7cl6e/o6MYaUqU4aTbW8
         nia6PsNjon7654elO42HgW4yvkLhefFpyvmGyDE8uGsOXigW8nCmgwwo9E6wiQIdWK6G
         dLQi68djy8/rtEf1TJsorpsFpm68q/DHGMQiLzRtolp4ClNJJO4p+J4AVgDRgKyrO0OP
         T8iGgQ9Q1If2kHQVu2ynXqAMxelzBg4ILRu9/LidZaJ7vqNrj3g1PsZUAoMMTOS8tXcf
         ov3MDW5dCLl9O51dJ/FpjQtxKfyD+mlnW17I5FyemeSr6i0ge2+1/8WV+2MzE5mHRMUp
         S9Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=2r0iVRr6v7y/H+eGodBK0e6KBH/Q8fDpFMrbGtG/Ww8=;
        b=awtlSq2ouuUFt6Y2M0bnbdOq1LkbtlVmw0G0o0vVOHVmGUq34MRVX9QmYkjfyu4CZu
         tWcnd0I/6IJN54NqU9ua+UonsgJ7FxQ7WY1BiKHVaPIhtRvwXqoN/vsbFd9AAj3GugbM
         4Cj/dq04WX786HbJmSatuzSpCnak+uh2rRqlx+2RltnBy/NeS5HbvCUp21d/T2n+2KRV
         Cdt/Q9Qi9v3GiIxkkAIRT9Ikbdl11i1ny68Q3HmLNmcu9rg6D6gkz0J16dFLY00SnF5u
         53jluXxgu5XwvSozpv+PXqa+QwrDdVu12skwjU3ijx2k9e41eVrd4hqkjTUrqahWL6ST
         BBZw==
X-Gm-Message-State: AOAM530TxFmIpzX8zTt0TdxNnJkx7lzIFGXCUEcZeEFIRPX34sKirTlx
        4w0mXNtMVKJFLtkfiIAr26M=
X-Google-Smtp-Source: ABdhPJxOq/hnYUCP8u0PcQELXswZ67ZO8DHEH9pkAbuS0s0apzr0FiHvv1lKvBE0fKLW7G1SB5bgyA==
X-Received: by 2002:a62:d414:0:b029:217:24b8:a5b9 with SMTP id a20-20020a62d4140000b029021724b8a5b9mr5672244pfh.41.1616383101838;
        Sun, 21 Mar 2021 20:18:21 -0700 (PDT)
Received: from localhost ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e20sm10899493pgm.1.2021.03.21.20.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 20:18:21 -0700 (PDT)
Date:   Mon, 22 Mar 2021 13:18:16 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 14/41] KVM: PPC: Book3S 64: move bad_host_intr check to
 HV handler
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210305150638.2675513-1-npiggin@gmail.com>
        <20210305150638.2675513-15-npiggin@gmail.com>
        <1f68b37c-7167-30d7-ee19-f6ebc69bd4a6@ozlabs.ru>
In-Reply-To: <1f68b37c-7167-30d7-ee19-f6ebc69bd4a6@ozlabs.ru>
MIME-Version: 1.0
Message-Id: <1616382597.zt86t19345.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Alexey Kardashevskiy's message of March 20, 2021 7:07 pm:
>=20
>=20
> On 06/03/2021 02:06, Nicholas Piggin wrote:
>> This is not used by PR KVM.
>>=20
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>=20
>=20
> Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>=20
> a small tote - it probably makes sense to move this before 09/41 as this=20
> one removes what 09/41 added to book3s_64_entry.S. Thanks,

Thanks.

I do realise there's a bit of shuffling around in this part of the=20
series, I'm trying to see if that can be improved a bit. But 9/41
is just moving the code without change which I prefer to do first.
This one changes the calling convention for PR which I think is
better to do after we have the entry point in a common file.

Thanks,
Nick


>=20
>=20
>> ---
>>   arch/powerpc/kvm/book3s_64_entry.S      | 3 ---
>>   arch/powerpc/kvm/book3s_hv_rmhandlers.S | 4 +++-
>>   arch/powerpc/kvm/book3s_segment.S       | 7 +++++++
>>   3 files changed, 10 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3=
s_64_entry.S
>> index d06e81842368..7a6b060ceed8 100644
>> --- a/arch/powerpc/kvm/book3s_64_entry.S
>> +++ b/arch/powerpc/kvm/book3s_64_entry.S
>> @@ -78,11 +78,8 @@ do_kvm_interrupt:
>>   	beq-	.Lmaybe_skip
>>   .Lno_skip:
>>   #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
>> -	cmpwi	r9,KVM_GUEST_MODE_HOST_HV
>> -	beq	kvmppc_bad_host_intr
>>   #ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
>>   	cmpwi	r9,KVM_GUEST_MODE_GUEST
>> -	ld	r9,HSTATE_SCRATCH2(r13)
>>   	beq	kvmppc_interrupt_pr
>>   #endif
>>   	b	kvmppc_interrupt_hv
>> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/=
book3s_hv_rmhandlers.S
>> index f976efb7e4a9..75405ef53238 100644
>> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>> @@ -1265,6 +1265,7 @@ hdec_soon:
>>   kvmppc_interrupt_hv:
>>   	/*
>>   	 * Register contents:
>> +	 * R9		=3D HSTATE_IN_GUEST
>>   	 * R12		=3D (guest CR << 32) | interrupt vector
>>   	 * R13		=3D PACA
>>   	 * guest R12 saved in shadow VCPU SCRATCH0
>> @@ -1272,6 +1273,8 @@ kvmppc_interrupt_hv:
>>   	 * guest R9 saved in HSTATE_SCRATCH2
>>   	 */
>>   	/* We're now back in the host but in guest MMU context */
>> +	cmpwi	r9,KVM_GUEST_MODE_HOST_HV
>> +	beq	kvmppc_bad_host_intr
>>   	li	r9, KVM_GUEST_MODE_HOST_HV
>>   	stb	r9, HSTATE_IN_GUEST(r13)
>>  =20
>> @@ -3272,7 +3275,6 @@ END_FTR_SECTION_IFCLR(CPU_FTR_P9_TM_HV_ASSIST)
>>    * cfar is saved in HSTATE_CFAR(r13)
>>    * ppr is saved in HSTATE_PPR(r13)
>>    */
>> -.global kvmppc_bad_host_intr
>>   kvmppc_bad_host_intr:
>>   	/*
>>   	 * Switch to the emergency stack, but start half-way down in
>> diff --git a/arch/powerpc/kvm/book3s_segment.S b/arch/powerpc/kvm/book3s=
_segment.S
>> index 1f492aa4c8d6..ef1d88b869bf 100644
>> --- a/arch/powerpc/kvm/book3s_segment.S
>> +++ b/arch/powerpc/kvm/book3s_segment.S
>> @@ -167,8 +167,15 @@ kvmppc_interrupt_pr:
>>   	 * R12             =3D (guest CR << 32) | exit handler id
>>   	 * R13             =3D PACA
>>   	 * HSTATE.SCRATCH0 =3D guest R12
>> +	 *
>> +	 * If HV is possible, additionally:
>> +	 * R9              =3D HSTATE_IN_GUEST
>> +	 * HSTATE.SCRATCH2 =3D guest R9
>>   	 */
>>   #ifdef CONFIG_PPC64
>> +#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
>> +	ld	r9,HSTATE_SCRATCH2(r13)
>> +#endif
>>   	/* Match 32-bit entry */
>>   	rotldi	r12, r12, 32		  /* Flip R12 halves for stw */
>>   	stw	r12, HSTATE_SCRATCH1(r13) /* CR is now in the low half */
>>=20
>=20
> --=20
> Alexey
>=20
