Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8E532D191
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Mar 2021 12:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239435AbhCDLGH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 4 Mar 2021 06:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbhCDLFu (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 4 Mar 2021 06:05:50 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5E2C061574
        for <kvm-ppc@vger.kernel.org>; Thu,  4 Mar 2021 03:05:10 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id jx13so6338164pjb.1
        for <kvm-ppc@vger.kernel.org>; Thu, 04 Mar 2021 03:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=Tq2nq7WrALsOgtkcDYwaRGhknpqw7Hbjv0+Mq9NsCng=;
        b=szfEARUZejT+shgrVSVvd6pBUSxxHx7/REhP11TUEa6AC2x7sBnpLRGUqanKgxx85F
         gHTwVa795ejaXFLLsO8EsGGmseyZpBV8ru0FdE4/LULB5SGnLVmWxKl7ZIdJ7LUf75aK
         3DL1oH9zyoaZBGzn8QK1aC4ga2k2B42iPr4g0Mj0JOUTSdt2h18wzs/ZVm+Om9k0E/FX
         N4nluylMMKPLRLlneKbLE7TdmiQ4HiZ2YMeYHu17nUs2njYPeNU5Yq1XWaI2DW87OiJf
         csnJlC5cfmYNfSdQVVKTDg9ypOcrllxnQmpLjNsfRY2BrPbLl8hwHJ/xLSKjbGkyBARj
         mpuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=Tq2nq7WrALsOgtkcDYwaRGhknpqw7Hbjv0+Mq9NsCng=;
        b=FkQpw/31Zt6CC6/mWHdQSTHHq+lwYXcjdWnrKguR2H2JyToDDMuIsC5la2kdyOzsTQ
         +k3SLG+MNRGtjHpIh5PnNzQq/GsVQKKErkaSqgHefV69z75YN/AZrd7lRDTWJpvhTofd
         kpAafLiSOVxW69qV8SR5lRq0oEDhzXs04JBOo+G4d5wlBTeqR/DMCDg5wqTqzGH4twMZ
         wXaHzMFYYtie1JRgJ2mq4rG4d2t2GdcTYm/D9q/Mv9+WQBiUY0qz4bq1XcwttSWHNIJT
         ARp8GMWA9WUhuqOpnMHsI82rpXJZPnrEnoKLgSIf9k13mYKrYBwL4LjkeZ7XNZxWA6rS
         dIog==
X-Gm-Message-State: AOAM531oIptIKROn1r7llf8K+cY0TR6GiSXPfJ7MnBCWP6VIsknlzx0U
        uYo/dRJqRyCd/AoXE3MkcdMsUx5oHc8=
X-Google-Smtp-Source: ABdhPJz7R/zAv9IuKrAibwPptRDk0skfxZZiu6GdApirC10BIf+S9eDHJuPinNR+OK2g/oY9BGYPZQ==
X-Received: by 2002:a17:902:ac82:b029:e3:bca2:cca7 with SMTP id h2-20020a170902ac82b02900e3bca2cca7mr3280153plr.43.1614855910247;
        Thu, 04 Mar 2021 03:05:10 -0800 (PST)
Received: from localhost (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id mm12sm9363213pjb.49.2021.03.04.03.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 03:05:09 -0800 (PST)
Date:   Thu, 04 Mar 2021 21:05:02 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 34/37] KVM: PPC: Book3S HV: add virtual mode handlers
 for HPT hcalls and page faults
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210225134652.2127648-1-npiggin@gmail.com>
        <20210225134652.2127648-35-npiggin@gmail.com> <87im68vw16.fsf@linux.ibm.com>
In-Reply-To: <87im68vw16.fsf@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1614855872.kftnn1redt.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of March 4, 2021 6:09 am:
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
>> In order to support hash guests in the P9 path (which does not do real
>> mode hcalls or page fault handling), these real-mode hash specific
>> interrupts need to be implemented in virt mode.
>>
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>>  arch/powerpc/kvm/book3s_hv.c | 118 +++++++++++++++++++++++++++++++++--
>>  1 file changed, 113 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index 9d2fa21201c1..1bbc46f2cfbf 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -935,6 +935,52 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
>>  		return RESUME_HOST;
>>
>>  	switch (req) {
>> +	case H_REMOVE:
>> +		ret =3D kvmppc_h_remove(vcpu, kvmppc_get_gpr(vcpu, 4),
>> +					kvmppc_get_gpr(vcpu, 5),
>> +					kvmppc_get_gpr(vcpu, 6));
>> +		if (ret =3D=3D H_TOO_HARD)
>> +			return RESUME_HOST;
>> +		break;
>> +	case H_ENTER:
>> +		ret =3D kvmppc_h_enter(vcpu, kvmppc_get_gpr(vcpu, 4),
>> +					kvmppc_get_gpr(vcpu, 5),
>> +					kvmppc_get_gpr(vcpu, 6),
>> +					kvmppc_get_gpr(vcpu, 7));
>> +		if (ret =3D=3D H_TOO_HARD)
>> +			return RESUME_HOST;
>> +		break;
>> +	case H_READ:
>> +		ret =3D kvmppc_h_read(vcpu, kvmppc_get_gpr(vcpu, 4),
>> +					kvmppc_get_gpr(vcpu, 5));
>> +		if (ret =3D=3D H_TOO_HARD)
>> +			return RESUME_HOST;
>> +		break;
>> +	case H_CLEAR_MOD:
>> +		ret =3D kvmppc_h_clear_mod(vcpu, kvmppc_get_gpr(vcpu, 4),
>> +					kvmppc_get_gpr(vcpu, 5));
>> +		if (ret =3D=3D H_TOO_HARD)
>> +			return RESUME_HOST;
>> +		break;
>> +	case H_CLEAR_REF:
>> +		ret =3D kvmppc_h_clear_ref(vcpu, kvmppc_get_gpr(vcpu, 4),
>> +					kvmppc_get_gpr(vcpu, 5));
>> +		if (ret =3D=3D H_TOO_HARD)
>> +			return RESUME_HOST;
>> +		break;
>> +	case H_PROTECT:
>> +		ret =3D kvmppc_h_protect(vcpu, kvmppc_get_gpr(vcpu, 4),
>> +					kvmppc_get_gpr(vcpu, 5),
>> +					kvmppc_get_gpr(vcpu, 6));
>> +		if (ret =3D=3D H_TOO_HARD)
>> +			return RESUME_HOST;
>> +		break;
>> +	case H_BULK_REMOVE:
>> +		ret =3D kvmppc_h_bulk_remove(vcpu);
>> +		if (ret =3D=3D H_TOO_HARD)
>> +			return RESUME_HOST;
>> +		break;
>> +
>=20
> Some of these symbols need to be exported.
>=20
> ERROR: modpost: "kvmppc_h_bulk_remove" [arch/powerpc/kvm/kvm-hv.ko] undef=
ined!
> ERROR: modpost: "kvmppc_h_clear_mod" [arch/powerpc/kvm/kvm-hv.ko] undefin=
ed!
> ERROR: modpost: "kvmppc_xive_xics_hcall" [arch/powerpc/kvm/kvm-hv.ko] und=
efined!
> ERROR: modpost: "kvmppc_h_remove" [arch/powerpc/kvm/kvm-hv.ko] undefined!
> ERROR: modpost: "decrementers_next_tb" [arch/powerpc/kvm/kvm-hv.ko] undef=
ined!
> ERROR: modpost: "kvmppc_hpte_hv_fault" [arch/powerpc/kvm/kvm-hv.ko] undef=
ined!
> ERROR: modpost: "kvmppc_h_protect" [arch/powerpc/kvm/kvm-hv.ko] undefined=
!
> ERROR: modpost: "kvmppc_h_enter" [arch/powerpc/kvm/kvm-hv.ko] undefined!
> ERROR: modpost: "kvmppc_h_clear_ref" [arch/powerpc/kvm/kvm-hv.ko] undefin=
ed!
> ERROR: modpost: "kvmppc_h_read" [arch/powerpc/kvm/kvm-hv.ko] undefined!

Yeah sorry about that there's a few issues there, I'll try polish that=20
up a bit before the next post.

Thanks,
Nick
