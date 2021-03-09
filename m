Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747B3331C2A
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Mar 2021 02:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbhCIBOu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 8 Mar 2021 20:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhCIBO1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 8 Mar 2021 20:14:27 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7CCC06174A
        for <kvm-ppc@vger.kernel.org>; Mon,  8 Mar 2021 17:14:16 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id jx13so694279pjb.1
        for <kvm-ppc@vger.kernel.org>; Mon, 08 Mar 2021 17:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=Wc0SoZywmjWAT/jdH96VBXqz2eHZ3d2LDSWvCfsp7KI=;
        b=lVlZGRiDtrreiTrpulUlFzHDBD44hlOS5m7kKSj1EOBxt4YwtgB8egJRoulC2O/GWt
         L8H3kVHTbdsQakgLEcLyQRwznd3fLm8iYGY7yjy9C1h14PZF/v1FJN4+LicVM2x8qRQ5
         NnZ3YH0wtPlw9g0EcZtWwtyAEx2sWMW63s5ZXAfK0j9F/HtAGXUpBwUVasV329+N7UJD
         IXDttzjxLz+i3OIDcDRn0KAqE2PvsckAkIOlsrTjv0BfNIV/GnrYKmXtg2m6Im3/1UXh
         GKcuHHxL1ElwmEuyv/CBoVMLuuHg/YvJJTg7YRXQ38kmcd+oq/P+9TenanI+CFgszm6r
         IPHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=Wc0SoZywmjWAT/jdH96VBXqz2eHZ3d2LDSWvCfsp7KI=;
        b=tfKXstl8qyXTIIwWNQYpgKK+jWNpA3InBuAOo/GD7/ETFZOn2H7i5Vbnw5umZC+m/U
         GMNolgiLPdGRrD7bRuZirK4K9FnMpY7sRE7XM9/LmhBawdpLMWAQyVLcjLHeL9de77q1
         9JnNyBlZUcwWRf64XhCztoyxU+wBcD295RS5UsinkT98CpYhrl8VxV0Sz6IQX/PP6zoG
         QLmUJUk0w9pVe0t+37guuRfejkAQj8hp12VyUVaHhIoczmtuJ5TCraEXHFk8zbS7XPPt
         +HqdUIwMXQ4l1ecS9jJUEUwNwXXknl3nsity6jKOIKWLE/7655fanbwDca2DcPZC+aAt
         avtQ==
X-Gm-Message-State: AOAM5329SEWasYeN5oiSID3HNDGSoYuEWWgpNgboFGmHkl15G5oQrcOX
        kTB6PfARae7IJybE4Ycr3bI=
X-Google-Smtp-Source: ABdhPJyNGwWrJqaWLl7md/K1BaW8e6HFy1xr9TJcgKTn4BDYGt5KtcYs/8Jo4eenqJx6NHtzo+kxRQ==
X-Received: by 2002:a17:90a:ae14:: with SMTP id t20mr1799958pjq.90.1615252456120;
        Mon, 08 Mar 2021 17:14:16 -0800 (PST)
Received: from localhost (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id jt21sm497062pjb.51.2021.03.08.17.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 17:14:15 -0800 (PST)
Date:   Tue, 09 Mar 2021 11:14:10 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 02/41] KVM: PPC: Book3S HV: Prevent radix guests from
 setting LPCR[TC]
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210305150638.2675513-1-npiggin@gmail.com>
        <20210305150638.2675513-3-npiggin@gmail.com> <878s6xmyv4.fsf@linux.ibm.com>
In-Reply-To: <878s6xmyv4.fsf@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1615252361.wjh446wma8.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of March 9, 2021 1:47 am:
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
>> This bit only applies to hash partitions.
>>
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>>  arch/powerpc/kvm/book3s_hv.c        | 6 ++++--
>>  arch/powerpc/kvm/book3s_hv_nested.c | 2 +-
>>  2 files changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index c40eeb20be39..2e29b96ef775 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -1666,10 +1666,12 @@ static void kvmppc_set_lpcr(struct kvm_vcpu *vcp=
u, u64 new_lpcr,
>>
>>  	/*
>>  	 * Userspace can only modify DPFD (default prefetch depth),
>> -	 * ILE (interrupt little-endian) and TC (translation control).
>> +	 * ILE (interrupt little-endian) and TC (translation control) if HPT.
>>  	 * On POWER8 and POWER9 userspace can also modify AIL (alt. interrupt =
loc.).
>>  	 */
>> -	mask =3D LPCR_DPFD | LPCR_ILE | LPCR_TC;
>> +	mask =3D LPCR_DPFD | LPCR_ILE;
>> +	if (!kvm_is_radix(kvm))
>> +		mask |=3D LPCR_TC;
>=20
> I think in theory there is a possibility that userspace sets the LPCR
> while we running Radix and then calls the KVM_PPC_CONFIGURE_V3_MMU ioctl
> right after to switch to HPT. I'm not sure if that would make sense but
> maybe it's something to consider...

Oh actually it is an issue for the later AIL patch I think.

So LPCR will have to be filtered again when switching MMU mode.

Good catch, I'll add something for that.

Thanks,
Nick

>=20
>>  	if (cpu_has_feature(CPU_FTR_ARCH_207S)) {
>>  		mask |=3D LPCR_AIL;
>>  		/* LPCR[AIL]=3D1/2 is disallowed */
>> diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book=
3s_hv_nested.c
>> index b496079e02f7..0e6cf650cbfe 100644
>> --- a/arch/powerpc/kvm/book3s_hv_nested.c
>> +++ b/arch/powerpc/kvm/book3s_hv_nested.c
>> @@ -141,7 +141,7 @@ static void sanitise_hv_regs(struct kvm_vcpu *vcpu, =
struct hv_guest_state *hr)
>>  	 * Don't let L1 change LPCR bits for the L2 except these:
>>  	 * Keep this in sync with kvmppc_set_lpcr.
>>  	 */
>> -	mask =3D LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_LD | LPCR_LPES | LPCR_M=
ER;
>> +	mask =3D LPCR_DPFD | LPCR_ILE | LPCR_LD | LPCR_LPES | LPCR_MER;
>>  	/* LPCR[AIL]=3D1/2 is disallowed */
>>  	if ((hr->lpcr & LPCR_AIL) && (hr->lpcr & LPCR_AIL) !=3D LPCR_AIL_3)
>>  		hr->lpcr &=3D ~LPCR_AIL;
>=20
