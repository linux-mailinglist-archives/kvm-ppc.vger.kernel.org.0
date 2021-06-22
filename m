Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4AE3AFFB7
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 10:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhFVJAC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 05:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbhFVJAC (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 05:00:02 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BAAC06175F;
        Tue, 22 Jun 2021 01:57:46 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so1854137pjo.3;
        Tue, 22 Jun 2021 01:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=HNevKIrxlPVGEQdCRLTX5YK2dWZlzRumxTolSmIBotY=;
        b=mVukyLLVXguaQPXelB9Gk8SACercFpcp6X9VdvmRFsB32rSR6ApbqtXRHKw67UuObq
         ioIs8Kej4wuAl4ChIcCr08wMnYMsMBcVRdetOlVT1b8afKF4MckZiU1pQpoZd4YRzedX
         3NcvmaMn92eCbz8tV+0mnCHw3pdy6g3dZx4piWH9PBvdghL3yE+KoMfKqyfqLyWTDs8O
         otzEL4rAxky05RpEd5fGDLutCnrpY++kvN5Pf01mSA3FV3YpuCsUmXKGlA5AqAFKqdt1
         vg9QIbEaAWoM8Wu7KdEUPmPqZ36bWjeeiOdr0gVcvYGcNgnz7SADAdmCKf8qlzNGFdP4
         GrLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=HNevKIrxlPVGEQdCRLTX5YK2dWZlzRumxTolSmIBotY=;
        b=O1nfqoQ3KWOqUFZMdNI+6xH5Hsn48Fn8gft4jx6pLo6xaRuw5O4yuozplIZmgZsIKy
         T0uzmnO2wdEshYmllkDvuB5g/0VXkqgcilpw4X6bg0zH/tyqzNqq1FiqmjVMyy6NWviL
         7pcqzZB37635GYRSgaI12DiX2zkfwiaZzM1J/hCEw24XQ4NzyxJNKYD7uUSO0C/ZZB2X
         omj/DK4xAuqHc7T1aQmXpJxgRf0ezK2pDDN6exiNzdKgaocnt4EQljqbbNsnBqOnt19s
         1Kzii3ExuWITr4EZpcd78Ho3DBRThS/YREmJXeA0BAAFCpcXTyBbSfHGjaa4H0Cs6eaG
         7TDw==
X-Gm-Message-State: AOAM530HkwvS2MbIj1GhHJ5RMKS50AwLjQPIDjIq/6/3ErvDQ8XM6q7Q
        /iy4BV45gC2VRgfUIrjMVPo=
X-Google-Smtp-Source: ABdhPJyJwExst2s08JaWvoFk8cDPoMa9LLjDx3IKUeSrohb2NQpnydI+1m+kxqw3yA64dmOaKml5Kg==
X-Received: by 2002:a17:90b:2282:: with SMTP id kx2mr2673071pjb.60.1624352265702;
        Tue, 22 Jun 2021 01:57:45 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id n5sm15609389pgf.35.2021.06.22.01.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 01:57:45 -0700 (PDT)
Date:   Tue, 22 Jun 2021 18:57:39 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Workaround high stack usage with
 clang
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Nathan Chancellor <nathan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        clang-built-linux@googlegroups.com, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kernel test robot <lkp@intel.com>,
        Nick Desaulniers <ndesaulniers@google.com>
References: <YNDUEoanTqvayZ5P@archlinux-ax161>
        <20210621182440.990242-1-nathan@kernel.org>
In-Reply-To: <20210621182440.990242-1-nathan@kernel.org>
MIME-Version: 1.0
Message-Id: <1624352117.tss3fnkwt4.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Nathan Chancellor's message of June 22, 2021 4:24 am:
> LLVM does not emit optimal byteswap assembly, which results in high
> stack usage in kvmhv_enter_nested_guest() due to the inlining of
> byteswap_pt_regs(). With LLVM 12.0.0:
>=20
> arch/powerpc/kvm/book3s_hv_nested.c:289:6: error: stack frame size of
> 2512 bytes in function 'kvmhv_enter_nested_guest' [-Werror,-Wframe-larger=
-than=3D]
> long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
>      ^
> 1 error generated.
>=20
> While this gets fixed in LLVM, mark byteswap_pt_regs() as
> noinline_for_stack so that it does not get inlined and break the build
> due to -Werror by default in arch/powerpc/. Not inlining saves
> approximately 800 bytes with LLVM 12.0.0:
>=20
> arch/powerpc/kvm/book3s_hv_nested.c:290:6: warning: stack frame size of
> 1728 bytes in function 'kvmhv_enter_nested_guest' [-Wframe-larger-than=3D=
]
> long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
>      ^
> 1 warning generated.
>=20
> Link: https://github.com/ClangBuiltLinux/linux/issues/1292
> Link: https://bugs.llvm.org/show_bug.cgi?id=3D49610
> Link: https://lore.kernel.org/r/202104031853.vDT0Qjqj-lkp@intel.com/
> Link: https://gist.github.com/ba710e3703bf45043a31e2806c843ffd
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Seems okay to me. If it was something where performance might be=20
signficiant I guess you could ifdef on CC_IS_CLANG, but for this
it shouldn't matter.

Acked-by: Nicholas Piggin <npiggin@gmail.com>

Thanks,
Nick

> ---
>  arch/powerpc/kvm/book3s_hv_nested.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3=
s_hv_nested.c
> index 60724f674421..1b3ff0af1264 100644
> --- a/arch/powerpc/kvm/book3s_hv_nested.c
> +++ b/arch/powerpc/kvm/book3s_hv_nested.c
> @@ -53,7 +53,8 @@ void kvmhv_save_hv_regs(struct kvm_vcpu *vcpu, struct h=
v_guest_state *hr)
>  	hr->dawrx1 =3D vcpu->arch.dawrx1;
>  }
> =20
> -static void byteswap_pt_regs(struct pt_regs *regs)
> +/* Use noinline_for_stack due to https://bugs.llvm.org/show_bug.cgi?id=
=3D49610 */
> +static noinline_for_stack void byteswap_pt_regs(struct pt_regs *regs)
>  {
>  	unsigned long *addr =3D (unsigned long *) regs;
> =20
>=20
> base-commit: 4a21192e2796c3338c4b0083b494a84a61311aaf
> --=20
> 2.32.0.93.g670b81a890
>=20
>=20
