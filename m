Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFB73E2848
	for <lists+kvm-ppc@lfdr.de>; Fri,  6 Aug 2021 12:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244908AbhHFKLG (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 6 Aug 2021 06:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244874AbhHFKLG (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 6 Aug 2021 06:11:06 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F84C061798
        for <kvm-ppc@vger.kernel.org>; Fri,  6 Aug 2021 03:10:50 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id j3so6429986plx.4
        for <kvm-ppc@vger.kernel.org>; Fri, 06 Aug 2021 03:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=xl+toVo+Zrg478hZAS7J1S1eAiWULAkYqgfigtj4ZV8=;
        b=gQeGe6L4ibmD0WCrfE7fNyfnq8gokIDvjPbGL0eMVtI3oPq2oDd4GYFcPFMCWObQuT
         LAvVKUuM99ymXmB+ppQV/3jHYe8joyuwhupgngzFrm/v0ei+eMFi+uH27o3zNXuQrj3q
         R1YMITRi/tQ3ezSktH+nDFe3uVjX96/092rnhGbJEDxKI73KyFpImeD3VRsRYZgLmaZR
         dLpD7bMbJpkZnWfn5oUoeO07sU+/ECeBjUoyrIPiLeaPxLM09vuaV8q0l41/rYM5lJjz
         pX9CIwkD0GjH0Hg86nchrl4XwGHPalBG2Uzz1wluVmXfWNtw/XYzj4BBp6rFK9hm0Qnh
         K1oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=xl+toVo+Zrg478hZAS7J1S1eAiWULAkYqgfigtj4ZV8=;
        b=G9axsqNqHH3DziuhwHpInVDOeCRCs1V0bEcHhXeXeN2oWh4FlQ6xHEPwO4SgFrAxAQ
         WR6XT3I/2wG7L2EVU7m5CDD/GzcmGzvYnFdptNwnctIbyBUqH5fOQElZMGzUy2F84bFE
         mf07jjgn+VUfvi1efBP6IPUK8h6g/HYLWRA2WQbEbBp03aZkimUmlxTWP7XhV3Lex2Tn
         ZHgu12LHA3ZY9v+ORxXjg+f45ZZ+90id8yO9v3EwMkhkJnnmpL3pYRiPN1lj8843OHu2
         4B9g1rxxwHaCCfzV0D25xv0fQZLMGC8f9VKoM/64k5t2iSXoeSVvnrnEQVboUN5Fcpv1
         8xUQ==
X-Gm-Message-State: AOAM531GJofJpaLjG0IjHqoxFiS/N0ddW/MU2U3aMjoUZ/L5ckv6PmWe
        o2adc/sr48Q3PAS0O8vsPqY=
X-Google-Smtp-Source: ABdhPJz4dsC4ghXRVNq0gDux6WP/xtTCO/fOTsURJhwjROT+I4DAL//Gs+cnx9EVYCYPV9ATy+ialQ==
X-Received: by 2002:a17:90a:a087:: with SMTP id r7mr20369035pjp.84.1628244650107;
        Fri, 06 Aug 2021 03:10:50 -0700 (PDT)
Received: from localhost ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id v7sm9473426pfu.39.2021.08.06.03.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 03:10:49 -0700 (PDT)
Date:   Fri, 06 Aug 2021 20:10:44 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: PPC: Book3S HV: Add sanity check to
 copy_tofrom_guest
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     christophe.leroy@c-s.fr, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, paulus@ozlabs.org
References: <20210805212616.2641017-1-farosas@linux.ibm.com>
        <20210805212616.2641017-3-farosas@linux.ibm.com>
In-Reply-To: <20210805212616.2641017-3-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1628244579.t79ynn05df.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of August 6, 2021 7:26 am:
> Both paths into __kvmhv_copy_tofrom_guest_radix ensure that we arrive
> with an effective address that is smaller than our total addressable
> space and addresses quadrant 0.
>=20
> - The H_COPY_TOFROM_GUEST hypercall path rejects the call with
> H_PARAMETER if the effective address has any of the twelve most
> significant bits set.
>=20
> - The kvmhv_copy_tofrom_guest_radix path clears the top twelve bits
> before calling the internal function.
>=20
> Although the callers make sure that the effective address is sane, any
> future use of the function is exposed to a programming error, so add a
> sanity check.

We possibly should put these into #defines in radix pgtable headers=20
somewhere but KVM already open codes them so this is good for now.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

>=20
> Suggested-by: Nicholas Piggin <npiggin@gmail.com>
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_64_mmu_radix.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/bo=
ok3s_64_mmu_radix.c
> index 44eb7b1ef289..1b1c9e9e539b 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> @@ -44,6 +44,9 @@ unsigned long __kvmhv_copy_tofrom_guest_radix(int lpid,=
 int pid,
>  					  (to !=3D NULL) ? __pa(to): 0,
>  					  (from !=3D NULL) ? __pa(from): 0, n);
> =20
> +	if (eaddr & (0xFFFUL << 52))
> +		return ret;
> +
>  	quadrant =3D 1;
>  	if (!pid)
>  		quadrant =3D 2;
> --=20
> 2.29.2
>=20
>=20
