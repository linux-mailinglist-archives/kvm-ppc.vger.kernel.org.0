Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3318326A83
	for <lists+kvm-ppc@lfdr.de>; Sat, 27 Feb 2021 00:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhBZXu5 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 26 Feb 2021 18:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhBZXu4 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 26 Feb 2021 18:50:56 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5AFC061574
        for <kvm-ppc@vger.kernel.org>; Fri, 26 Feb 2021 15:50:16 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id w18so6105750plc.12
        for <kvm-ppc@vger.kernel.org>; Fri, 26 Feb 2021 15:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=ZgDG+DAFXWS90lnwRgCLnPtPK1bMSB9QU23qIicCGtM=;
        b=Z8yq0c7khU84dYB+4wYJ+0RCMVyZ1ebXnB5WK2DAvqhnCJWpFKe+mH4CB/mrrkW7mk
         +mkUj2pMe2B4c/wqmGsFdwrZihKTKvfSE7lEv5siCVaKJTqD3gan4PXM2DGtrJsnXQK/
         cmI/mwUgHLzB1/OAZabpEKik1vHRH7JG1RjmMCHOnYroE6ixcQtk3NHNDiDsd/D09joD
         C0fVKalcsnFzWPS4qfl185r8e20QgpJaPWgCh7KxqB1YPtvPBs1n6YmzXNUB/zmYpfIE
         DVdS2pE6AxxNgr3BUMk59aDfpzMZyvTN/HIHvRGsNjVGZExpUZ5EGx1Xn+xXFDURPiX+
         HvYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=ZgDG+DAFXWS90lnwRgCLnPtPK1bMSB9QU23qIicCGtM=;
        b=bVGKyRBZDdI0NY1CfXC7RsttbRzzKJMtKOI/EB7MiSYvUDNiqiYUoggbFqA5v7bFsk
         GDi2e9uv+983x/3GA9RoDs7XuymLrE0arEZuqJeUIpmkK0LiBfZU7bTj65wkbfXarXq6
         E06Yq1lj9LVSFptLr1eS0+z+Lpams+UaZyL/bqs6X2IKymC4t8jvYbR4wb56ZoW0KmTA
         7IgDfs0+/tSe1gIjo4klKpo7j8qphA8DWG1j2t/9IGywRYyHvRNkBy5veg9hnVD9L6iQ
         T2bUUwXxh3uTcn1LQW8xC8VM0bDqKPsbIvRYlO6KfXDDYfA3cN9gX/PaLA5klHDjSsB6
         TiwA==
X-Gm-Message-State: AOAM532z5vw1vB+uva6ZtJun7nmsDEnAnMQuineMSR02f6C+3Nd4Iizs
        oEZqTJif5hzL6L0hEnsqx6nqhIbt2zg=
X-Google-Smtp-Source: ABdhPJwFc17Ja+0MIdiQQAo2vQTSyBJLLloXneUgYT1RCrhB5fu6fYZ0ON+O+v+tv9TGTT8kMN5rbw==
X-Received: by 2002:a17:90a:6a04:: with SMTP id t4mr5646719pjj.125.1614383416009;
        Fri, 26 Feb 2021 15:50:16 -0800 (PST)
Received: from localhost (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id r123sm10652023pfc.211.2021.02.26.15.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 15:50:15 -0800 (PST)
Date:   Sat, 27 Feb 2021 09:50:09 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 01/37] KVM: PPC: Book3S 64: remove unused
 kvmppc_h_protect argument
To:     Daniel Axtens <dja@axtens.net>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210225134652.2127648-1-npiggin@gmail.com>
        <20210225134652.2127648-2-npiggin@gmail.com>
        <878s7ba0cm.fsf@linkitivity.dja.id.au>
In-Reply-To: <878s7ba0cm.fsf@linkitivity.dja.id.au>
MIME-Version: 1.0
Message-Id: <1614383256.cikqwycx8o.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Daniel Axtens's message of February 26, 2021 3:01 pm:
> Hi Nick,
>=20
>> The va argument is not used in the function or set by its asm caller,
>> so remove it to be safe.
>=20
> Huh, so it isn't. I tracked the original implementation down to commit
> a8606e20e41a ("KVM: PPC: Handle some PAPR hcalls in the kernel") where
> paulus first added the ability to handle it in the kernel - there it
> takes a va argument but even then doesn't do anything with it.
>=20
> ajd also pointed out that we don't pass a va when linux is running as a
> guest, and LoPAR does not mention va as an argument.

Yeah interesting, maybe it was from a pre-release version of PAPR? Who
knows.

> One small nit: checkpatch is complaining about spaces vs tabs:
> ERROR: code indent should use tabs where possible
> #25: FILE: arch/powerpc/include/asm/kvm_ppc.h:770:
> +                      unsigned long pte_index, unsigned long avpn);$
>=20
> WARNING: please, no spaces at the start of a line
> #25: FILE: arch/powerpc/include/asm/kvm_ppc.h:770:
> +                      unsigned long pte_index, unsigned long avpn);$

All the declarations are using the same style in this file so I think
I'll leave it for someone to do a cleanup patch on. Okay?

>=20
> Once that is resolved,
>   Reviewed-by: Daniel Axtens <dja@axtens.net>

Thanks,
Nick

>=20
> Kind regards,
> Daniel Axtens
>=20
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>>  arch/powerpc/include/asm/kvm_ppc.h  | 3 +--
>>  arch/powerpc/kvm/book3s_hv_rm_mmu.c | 3 +--
>>  2 files changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/a=
sm/kvm_ppc.h
>> index 8aacd76bb702..9531b1c1b190 100644
>> --- a/arch/powerpc/include/asm/kvm_ppc.h
>> +++ b/arch/powerpc/include/asm/kvm_ppc.h
>> @@ -767,8 +767,7 @@ long kvmppc_h_remove(struct kvm_vcpu *vcpu, unsigned=
 long flags,
>>                       unsigned long pte_index, unsigned long avpn);
>>  long kvmppc_h_bulk_remove(struct kvm_vcpu *vcpu);
>>  long kvmppc_h_protect(struct kvm_vcpu *vcpu, unsigned long flags,
>> -                      unsigned long pte_index, unsigned long avpn,
>> -                      unsigned long va);
>> +                      unsigned long pte_index, unsigned long avpn);
>>  long kvmppc_h_read(struct kvm_vcpu *vcpu, unsigned long flags,
>>                     unsigned long pte_index);
>>  long kvmppc_h_clear_ref(struct kvm_vcpu *vcpu, unsigned long flags,
>> diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book=
3s_hv_rm_mmu.c
>> index 88da2764c1bb..7af7c70f1468 100644
>> --- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
>> +++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
>> @@ -673,8 +673,7 @@ long kvmppc_h_bulk_remove(struct kvm_vcpu *vcpu)
>>  }
>> =20
>>  long kvmppc_h_protect(struct kvm_vcpu *vcpu, unsigned long flags,
>> -		      unsigned long pte_index, unsigned long avpn,
>> -		      unsigned long va)
>> +		      unsigned long pte_index, unsigned long avpn)
>>  {
>>  	struct kvm *kvm =3D vcpu->kvm;
>>  	__be64 *hpte;
>> --=20
>> 2.23.0
>=20
