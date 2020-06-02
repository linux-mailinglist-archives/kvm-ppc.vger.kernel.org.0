Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835F61EB5C6
	for <lists+kvm-ppc@lfdr.de>; Tue,  2 Jun 2020 08:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbgFBG0Q (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 2 Jun 2020 02:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgFBG0Q (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 2 Jun 2020 02:26:16 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C299C061A0E
        for <kvm-ppc@vger.kernel.org>; Mon,  1 Jun 2020 23:26:16 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id v13so3244495otp.4
        for <kvm-ppc@vger.kernel.org>; Mon, 01 Jun 2020 23:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RmMIqc5cke45a5Qr22iA05nvgiFpVERb+wjHqaLOWS4=;
        b=f9F/7sicUsscj/Rtu2eJka5s47NWAEYHkny+GJ57RnSOcrplxhdLGv7CxpQ+/8jxy8
         KFcZNZRA6Rjpe+VeSkfuYUJnwtFX0B4atncirqabAm6eXhgzyea2uhmnnjbijh6edUmc
         tQNviprjwQcaoxQ2Sfg52sih6ADGGlSVO1M6UN3dUo6QKvsTPg5X/eE9O45B+u8aYY86
         Dhmmu4BDiQrXc7so4+aPb/1v+Ff/c/UWvnCazkjtLIfjQumUYUzD06CVMHU9MRhHgLK8
         l3F4Ho4nk7CqeiYljIWVPBIGLhWhE6HHYSsTa3eGjE3lYLEst3Ng0DOveD6ql7BGnsez
         k7cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RmMIqc5cke45a5Qr22iA05nvgiFpVERb+wjHqaLOWS4=;
        b=QXuyOCDjsgNMAXKqi4A1ZponVl2+geDGAGuIcEmdHV9kQbp/JGiAu+1TlBh2dQhR5S
         qKxP00yBjSM3yVqRXUzum6I119n0n0Wi+1Me8gNLguwTM8EZf8RCLfKLLffn8m/aVg1N
         lnjm8BA/BVIaqekxiVf/V0Vjp6G/r7am4BBn8yoZO/4now7dcLiD8IWZcW+eCtz/ZkUv
         gThUSuyjisgjFmZJuB5mJ6korYs9fuYo2a8/gd9vH9TzANZe/tSEmvtqqKor+WDf6GSj
         ik4I9VJsVJuBHUYH5gKxa0hz6wCzO7gFNUmEGZrdLZ2uOjQWg26m5+W7VtJCVDQj7a+U
         kN2A==
X-Gm-Message-State: AOAM531oHtAQPBpmXOINoBShy79lALkJnkfJRU50DHfFOovrbjWj06uj
        8bUaQLCTeJmQ6n+x3+mWBpc+ly/6rs7I79Fj0Ho=
X-Google-Smtp-Source: ABdhPJwLfN+rTeFBH3QN5TVTEDbOh42l01S5Bcsq2qaoyfsZOc+3zSbodmzScIgSorVB97tEgUXj42UorMECv+uIaoI=
X-Received: by 2002:a9d:2046:: with SMTP id n64mr18892998ota.51.1591079175154;
 Mon, 01 Jun 2020 23:26:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200602055325.6102-1-alistair@popple.id.au>
In-Reply-To: <20200602055325.6102-1-alistair@popple.id.au>
From:   Jordan Niethe <jniethe5@gmail.com>
Date:   Tue, 2 Jun 2020 16:26:03 +1000
Message-ID: <CACzsE9proNZDwZMHLRouajYJo6f7Y_obm5pfNniSvvLXRLZsPQ@mail.gmail.com>
Subject: Re: [PATCH] powerpc/kvm: Enable support for ISA v3.1 guests
To:     Alistair Popple <alistair@popple.id.au>
Cc:     linuxppc-dev@lists.ozlabs.org, ravi.bangoria@linux.ibm.com,
        mikey@neuling.org, kvm-ppc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Jun 2, 2020 at 3:55 PM Alistair Popple <alistair@popple.id.au> wrote:
>
> Adds support for emulating ISAv3.1 guests by adding the appropriate PCR
> and FSCR bits.
>
> Signed-off-by: Alistair Popple <alistair@popple.id.au>
> ---
>  arch/powerpc/include/asm/reg.h |  1 +
>  arch/powerpc/kvm/book3s_hv.c   | 11 ++++++++---
>  2 files changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
> index 773f76402392..d77040d0588a 100644
> --- a/arch/powerpc/include/asm/reg.h
> +++ b/arch/powerpc/include/asm/reg.h
> @@ -1348,6 +1348,7 @@
>  #define PVR_ARCH_206p  0x0f100003
>  #define PVR_ARCH_207   0x0f000004
>  #define PVR_ARCH_300   0x0f000005
> +#define PVR_ARCH_31    0x0f000006
>
>  /* Macros for setting and retrieving special purpose registers */
>  #ifndef __ASSEMBLY__
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 93493f0cbfe8..359bb2ed43e1 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -345,7 +345,7 @@ static void kvmppc_set_pvr_hv(struct kvm_vcpu *vcpu, u32 pvr)
>  }
>
>  /* Dummy value used in computing PCR value below */
> -#define PCR_ARCH_300   (PCR_ARCH_207 << 1)
> +#define PCR_ARCH_31    (PCR_ARCH_300 << 1)
>
>  static int kvmppc_set_arch_compat(struct kvm_vcpu *vcpu, u32 arch_compat)
>  {
> @@ -353,7 +353,9 @@ static int kvmppc_set_arch_compat(struct kvm_vcpu *vcpu, u32 arch_compat)
>         struct kvmppc_vcore *vc = vcpu->arch.vcore;
>
>         /* We can (emulate) our own architecture version and anything older */
> -       if (cpu_has_feature(CPU_FTR_ARCH_300))
> +       if (cpu_has_feature(CPU_FTR_ARCH_31))
> +               host_pcr_bit = PCR_ARCH_31;
> +       else if (cpu_has_feature(CPU_FTR_ARCH_300))
>                 host_pcr_bit = PCR_ARCH_300;
>         else if (cpu_has_feature(CPU_FTR_ARCH_207S))
>                 host_pcr_bit = PCR_ARCH_207;
> @@ -379,6 +381,9 @@ static int kvmppc_set_arch_compat(struct kvm_vcpu *vcpu, u32 arch_compat)
>                 case PVR_ARCH_300:
>                         guest_pcr_bit = PCR_ARCH_300;
>                         break;
> +               case PVR_ARCH_31:
> +                       guest_pcr_bit = PCR_ARCH_31;
> +                       break;
>                 default:
>                         return -EINVAL;
>                 }
> @@ -2318,7 +2323,7 @@ static int kvmppc_core_vcpu_create_hv(struct kvm_vcpu *vcpu)
>          * to trap and then we emulate them.
>          */
The comment above this:
"...
     * Set the default HFSCR for the guest from the host value.
     * This value is only used on POWER9..."
would need to be updated.
>         vcpu->arch.hfscr = HFSCR_TAR | HFSCR_EBB | HFSCR_PM | HFSCR_BHRB |
> -               HFSCR_DSCR | HFSCR_VECVSX | HFSCR_FP;
> +               HFSCR_DSCR | HFSCR_VECVSX | HFSCR_FP | HFSCR_PREFIX;
>         if (cpu_has_feature(CPU_FTR_HVMODE)) {
>                 vcpu->arch.hfscr &= mfspr(SPRN_HFSCR);
>                 if (cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
> --
> 2.20.1
>
