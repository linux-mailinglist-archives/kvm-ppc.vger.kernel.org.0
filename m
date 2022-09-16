Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CFB5BA63E
	for <lists+kvm-ppc@lfdr.de>; Fri, 16 Sep 2022 07:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiIPFIJ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 16 Sep 2022 01:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiIPFII (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 16 Sep 2022 01:08:08 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807894E872
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Sep 2022 22:08:06 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id a9so10824063ilh.1
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Sep 2022 22:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=yP5XHXLcK+UX9e2N5YzbTl9a4h8ihKkfwEUan36DPrg=;
        b=yAWumhzewMa3eEP3CnaMNUvAKmgC8eanQ3L4jWiwdGCcIzPkhFrQzQw0wwV9+O9C/s
         pWA8px3RR32jSQRkZ724RUliMw1N1pJV7uypHBZtXw/s45KvAkUFFBkjDay0fezO6Q1H
         n/OjWEaMaEvHTgl1WjFIQhvNgjxtHZeYZXfVlqejl77Y0na9OV31a8qO4TRydLDh9b1J
         NF1Fubd/swhKTWFgEXpw3HK96R4pCPPNOYmiQOe7Bp9RLaM6/LZ/umsF8xY1IvG5Kb40
         CBEv7FTQftTVcumiWuAZRwOn7ym/68hjz6J2lRqkwYLZ2FbLbPgjYRH/Tm0ZHhOzbqfn
         INxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=yP5XHXLcK+UX9e2N5YzbTl9a4h8ihKkfwEUan36DPrg=;
        b=i5whmoh69oqcYPAwwTJzUUfiuRx/InVyh41rq/MWgDvjvhNNofBLah9PFuYIeGD+xI
         NXiX16KBLPmdPci6X1/iCcJsHZBPle2uQtNN0tyDLK+gxoGw30GqspqoMGeHuoUWE/6I
         qJH9hNC8h88p9TQj3y3L3G8jWzrroE0gNvxoi+knedLiK+sB4Ltkb3mP1Uls082sUaPO
         vUEVDfdEsMfQ1Q/ZLj0n9+VCZ1IhSZ6h73pOeEkrfVSB/NJqmn1FWh/JLulSsEbUiCsJ
         0NKrqpyW76PM9F8irvDPQMabSEdLr1S4ggLf156H91At78EWy1MROD6vtunPUwzpiSyW
         dT+Q==
X-Gm-Message-State: ACrzQf2wFVzUGdd/PxDvj33pzHtuK/eqCT2DbyTDCtm6orawwjCBnTrz
        lzLowmbFjrgh6p/ic6LT/HrALHpLF6s1p0M/54zycg==
X-Google-Smtp-Source: AMsMyM5GqgO04FmX/wur2Jt+8ypcoEU8eotcYd1jKm89jw9hQAj1ZhLfSUj5pD6zTUMTtw3xNbjyMSejcFd/JFYW8jo=
X-Received: by 2002:a05:6e02:164d:b0:2f1:869c:c45b with SMTP id
 v13-20020a056e02164d00b002f1869cc45bmr1488365ilu.212.1663304885797; Thu, 15
 Sep 2022 22:08:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220504074807.3616813-1-aik@ozlabs.ru>
In-Reply-To: <20220504074807.3616813-1-aik@ozlabs.ru>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 16 Sep 2022 10:37:53 +0530
Message-ID: <CAAhSdy0hxHjQkVj8TLPh4j=vBrX1QoZcJXNeRBPtf5ozdjQaTQ@mail.gmail.com>
Subject: Re: [PATCH kernel] KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE platform dependent
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     kvm-ppc@vger.kernel.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fabiano Rosas <farosas@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, May 4, 2022 at 1:18 PM Alexey Kardashevskiy <aik@ozlabs.ru> wrote:
>
> When introduced, IRQFD resampling worked on POWER8 with XICS. However
> KVM on POWER9 has never implemented it - the compatibility mode code
> ("XICS-on-XIVE") misses the kvm_notify_acked_irq() call and the native
> XIVE mode does not handle INTx in KVM at all.
>
> This moved the capability support advertising to platforms and stops
> advertising it on XIVE, i.e. POWER9 and later.
>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
>
>
> Or I could move this one together with KVM_CAP_IRQFD. Thoughts?

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Thanks,
Anup

>
> ---
>  arch/arm64/kvm/arm.c       | 3 +++
>  arch/mips/kvm/mips.c       | 3 +++
>  arch/powerpc/kvm/powerpc.c | 6 ++++++
>  arch/riscv/kvm/vm.c        | 3 +++
>  arch/s390/kvm/kvm-s390.c   | 3 +++
>  arch/x86/kvm/x86.c         | 3 +++
>  virt/kvm/kvm_main.c        | 1 -
>  7 files changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 523bc934fe2f..092f0614bae3 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -210,6 +210,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>         case KVM_CAP_SET_GUEST_DEBUG:
>         case KVM_CAP_VCPU_ATTRIBUTES:
>         case KVM_CAP_PTP_KVM:
> +#ifdef CONFIG_HAVE_KVM_IRQFD
> +       case KVM_CAP_IRQFD_RESAMPLE:
> +#endif
>                 r = 1;
>                 break;
>         case KVM_CAP_SET_GUEST_DEBUG2:
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index a25e0b73ee70..0f3de470a73e 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -1071,6 +1071,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>         case KVM_CAP_READONLY_MEM:
>         case KVM_CAP_SYNC_MMU:
>         case KVM_CAP_IMMEDIATE_EXIT:
> +#ifdef CONFIG_HAVE_KVM_IRQFD
> +       case KVM_CAP_IRQFD_RESAMPLE:
> +#endif
>                 r = 1;
>                 break;
>         case KVM_CAP_NR_VCPUS:
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 875c30c12db0..87698ffef3be 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -591,6 +591,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>                 break;
>  #endif
>
> +#ifdef CONFIG_HAVE_KVM_IRQFD
> +       case KVM_CAP_IRQFD_RESAMPLE:
> +               r = !xive_enabled();
> +               break;
> +#endif
> +
>         case KVM_CAP_PPC_ALLOC_HTAB:
>                 r = hv_enabled;
>                 break;
> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> index c768f75279ef..b58579b386bb 100644
> --- a/arch/riscv/kvm/vm.c
> +++ b/arch/riscv/kvm/vm.c
> @@ -63,6 +63,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>         case KVM_CAP_READONLY_MEM:
>         case KVM_CAP_MP_STATE:
>         case KVM_CAP_IMMEDIATE_EXIT:
> +#ifdef CONFIG_HAVE_KVM_IRQFD
> +       case KVM_CAP_IRQFD_RESAMPLE:
> +#endif
>                 r = 1;
>                 break;
>         case KVM_CAP_NR_VCPUS:
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 156d1c25a3c1..85e093fc8d13 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -564,6 +564,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>         case KVM_CAP_SET_GUEST_DEBUG:
>         case KVM_CAP_S390_DIAG318:
>         case KVM_CAP_S390_MEM_OP_EXTENSION:
> +#ifdef CONFIG_HAVE_KVM_IRQFD
> +       case KVM_CAP_IRQFD_RESAMPLE:
> +#endif
>                 r = 1;
>                 break;
>         case KVM_CAP_SET_GUEST_DEBUG2:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0c0ca599a353..a0a7b769483d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4273,6 +4273,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>         case KVM_CAP_SYS_ATTRIBUTES:
>         case KVM_CAP_VAPIC:
>         case KVM_CAP_ENABLE_CAP:
> +#ifdef CONFIG_HAVE_KVM_IRQFD
> +       case KVM_CAP_IRQFD_RESAMPLE:
> +#endif
>                 r = 1;
>                 break;
>         case KVM_CAP_EXIT_HYPERCALL:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 70e05af5ebea..885e72e668a5 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4293,7 +4293,6 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  #endif
>  #ifdef CONFIG_HAVE_KVM_IRQFD
>         case KVM_CAP_IRQFD:
> -       case KVM_CAP_IRQFD_RESAMPLE:
>  #endif
>         case KVM_CAP_IOEVENTFD_ANY_LENGTH:
>         case KVM_CAP_CHECK_EXTENSION_VM:
> --
> 2.30.2
>
