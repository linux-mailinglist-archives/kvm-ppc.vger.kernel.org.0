Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E523445A3
	for <lists+kvm-ppc@lfdr.de>; Mon, 22 Mar 2021 14:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbhCVNYh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 09:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbhCVNYL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 09:24:11 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD468C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 06:24:10 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t20so6564335plr.13
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 06:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=Nu+NVbKpPKRL1OVq1SN53YDC13FQgrm7Fd6Q7r4UNgs=;
        b=kHtWm9t/l5O+7jXsszv5sj0MbD++/S9Qq8W5la7GyVVuBSb3ZUkwX8CinQI4ze8EsB
         6qw11GF5sAHOs2uNI+tyzrwTeA4zaK8IUhGFuIr2F4Th1jPbcbSsMni/2naDu9OA7tKv
         H78Gqi2fdoLxHCJ2xT9ILYLi32ryN9dE6PDf0fE3GqZtLSNJzbjZF6jVcnXVq92KCaEu
         VayFooqslPOWnWOjuFHdQYxjZvOYG7l8KlGPYOvf2kJhqsvrASHLwDNXTAzH0FJsAaG/
         mp29g9cAruTiYZ/aUwi7CMzSMhGFLwK7xPXGf1JhcMs3hmnYMZEaVPUieZ/Zvtv+xfz1
         ncNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=Nu+NVbKpPKRL1OVq1SN53YDC13FQgrm7Fd6Q7r4UNgs=;
        b=QNFXpE0tFGvIM9lcGJcoTeDF2QJQ+txIkBUw5ykGqfl4cq/0fZJncAe9n9nXT0oGi3
         0OAVRnomwgF0P4Nj1tGS8e//wdJv8BK/egNfIq7Wo5aKFelC8at5MKqFtseL7S89Q2d8
         Xw42al8Job53OgBiqub8DGb/KTNwISfv4vKQ5ljtCJorhOZE2ch1dDXSIXVt1eWOVShj
         zbD/ZBLJcVoqvPtdF9zdBdAU1/qExPXx4122iIJxxHwGPiT97XcxOjIhUcrnYExm4o89
         IsHO+YlYXrP/GzRMCYCZj4zrTMsvkrk0SLgY1852dZSBdQ66VdLfEGM8nEgGLWvL0om/
         ZIbw==
X-Gm-Message-State: AOAM531LHjGQXMq4thkDCHOJ+RzUTveelq72aPtYUq3JAu2xS11Y3eKK
        w56FCTLoYULoC+yR6VrzyFBhxcCUucY=
X-Google-Smtp-Source: ABdhPJxuwC3VK3puFXyX8g82bXnNKGDImeSMTVymEd0/pJiQnE0njHHZC9isB8Wq5myU+QACk+4STA==
X-Received: by 2002:a17:902:850b:b029:e6:bb9f:4bd9 with SMTP id bj11-20020a170902850bb02900e6bb9f4bd9mr27597143plb.41.1616419450370;
        Mon, 22 Mar 2021 06:24:10 -0700 (PDT)
Received: from localhost ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id 4sm14601675pjl.51.2021.03.22.06.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 06:24:09 -0700 (PDT)
Date:   Mon, 22 Mar 2021 23:24:03 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 20/41] KVM: PPC: Book3S HV P9: Move setting HDEC after
 switching to guest LPCR
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210305150638.2675513-1-npiggin@gmail.com>
        <20210305150638.2675513-21-npiggin@gmail.com>
        <21be26e7-d8c9-6681-d89d-4ffdf46d23f7@ozlabs.ru>
In-Reply-To: <21be26e7-d8c9-6681-d89d-4ffdf46d23f7@ozlabs.ru>
MIME-Version: 1.0
Message-Id: <1616418940.ifn8pbued8.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Alexey Kardashevskiy's message of March 22, 2021 6:39 pm:
>=20
>=20
> On 06/03/2021 02:06, Nicholas Piggin wrote:
>> LPCR[HDICE]=3D0 suppresses hypervisor decrementer exceptions on some
>> processors, so it must be enabled before HDEC is set.
>=20
> Educating myself - is not it a processor bug when it does not suppress=20
> hdec exceptions with HDICE=3D0?

It seems to be contrary to the architecture if it does suppress them.
The HDEC exception is supposed to come into existence when the top bit
of HDEC SPR, regardless of HDICE AFAIKS.

Interrupt being taken in response to an exception existing is different.
The interrupt is suppressed when HDICE=3D0, which is also a requirement
of the architecture.

> Also, why do we want to enable interrupts before writing HDEC? Enabling=20
> it may cause an interrupt right away a

HDICE does not enable HDEC interrupts when HV=3D1 unless EE is 1.

In other words, HDEC interrupts are masked with EE just like DEC=20
interrupts when you are the hypervisor, but they ignore EE when the=20
guest is running (so guest can't delay them).

>=20
> Anyway whatever the answers are, this is not changed by this patch and=20
> the change makes sense so
>=20
> Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Thanks,
Nick

>=20
>=20
>> Rather than set it in the host LPCR then setting HDEC, move the HDEC
>> update to after the guest MMU context (including LPCR) is loaded.
>> There shouldn't be much concern with delaying HDEC by some 10s or 100s
>> of nanoseconds by setting it a bit later.
>>=20
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>>   arch/powerpc/kvm/book3s_hv.c | 19 +++++++------------
>>   1 file changed, 7 insertions(+), 12 deletions(-)
>>=20
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index 1f2ba8955c6a..ffde1917ab68 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -3505,20 +3505,9 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_v=
cpu *vcpu, u64 time_limit,
>>   		host_dawrx1 =3D mfspr(SPRN_DAWRX1);
>>   	}
>>  =20
>> -	/*
>> -	 * P8 and P9 suppress the HDEC exception when LPCR[HDICE] =3D 0,
>> -	 * so set HDICE before writing HDEC.
>> -	 */
>> -	mtspr(SPRN_LPCR, kvm->arch.host_lpcr | LPCR_HDICE);
>> -	isync();
>> -
>>   	hdec =3D time_limit - mftb();
>> -	if (hdec < 0) {
>> -		mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
>> -		isync();
>> +	if (hdec < 0)
>>   		return BOOK3S_INTERRUPT_HV_DECREMENTER;
>> -	}
>> -	mtspr(SPRN_HDEC, hdec);
>>  =20
>>   	if (vc->tb_offset) {
>>   		u64 new_tb =3D mftb() + vc->tb_offset;
>> @@ -3564,6 +3553,12 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_v=
cpu *vcpu, u64 time_limit,
>>  =20
>>   	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
>>  =20
>> +	/*
>> +	 * P9 suppresses the HDEC exception when LPCR[HDICE] =3D 0,
>> +	 * so set guest LPCR (with HDICE) before writing HDEC.
>> +	 */
>> +	mtspr(SPRN_HDEC, hdec);
>> +
>>   	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
>>   	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
>>  =20
>>=20
>=20
> --=20
> Alexey
>=20
