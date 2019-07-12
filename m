Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90D65663A7
	for <lists+kvm-ppc@lfdr.de>; Fri, 12 Jul 2019 04:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbfGLCGd (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 11 Jul 2019 22:06:33 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46812 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728853AbfGLCGc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 11 Jul 2019 22:06:32 -0400
Received: by mail-pf1-f194.google.com with SMTP id c73so3577839pfb.13
        for <kvm-ppc@vger.kernel.org>; Thu, 11 Jul 2019 19:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :user-agent:message-id:content-transfer-encoding;
        bh=vNBK+QFEu9QF3vJMr4t5WoVDGfRfBpi0TNU2yGl9SjI=;
        b=TbWOHkpN20FVB/gP83fCmS0O16ZeYOYsJlfW6VMM1QI4itZUMQqqc/TfjvScp0eG5p
         VEQZ6dmYn32sKtxLoQVDSU6usIpHCG8GghWdfNRix3gyjcJjUsKPCTnNvhG+mza4Q9Hd
         H7wixInwzkVYJX+S2PrYUgKwPsxXwGUFgdQJTyKlvACRIAOuk8nZ1mIOxI5GieRFzQfS
         r3wiHdE1KvjukuJcWXngrmrsehzNLfSi9eaGNty6K55JJaS9akLOkLgMi3/AsqLNEsDZ
         dySo4AtxTPzYZJyM8Ha44Nez6TnNxChLGgvgPUZO9lEYDp2kwu5H9DO+FsevTjbsvZTT
         jzmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:user-agent:message-id:content-transfer-encoding;
        bh=vNBK+QFEu9QF3vJMr4t5WoVDGfRfBpi0TNU2yGl9SjI=;
        b=Jk1RWMlbbFWLQdUWxk0G2CoLk7GcOXB9QnW8Da3AHWeIUedn9a9YG8LsyriqPq7Xxg
         wtkwR1nFHjU7gPuU15mB0ryd0CbWHk3zc0dfKKo907d7qHkrsV822FhydJtI7H5k8o/v
         VVaauoLbOpM/tYvLX7IEtgoVy7teE1lhLLSMS27pFMiLUIq52pxA5eaZG02RdbW0//w7
         E6gTyIVVu+RZ4OJPK8X4CTtNUbt85hRwu4hdFc7eYnOz2ed33ybN5VeYlQLVU9zAg1yj
         wCWM+oYiqW9OIcqJu4Cni8eeW7ivx8Fzl8cwSGqJAPLHruQoAyKvC/Zy16tYvnCq7AGg
         bgsA==
X-Gm-Message-State: APjAAAXRbIvoNe55xj/GXAqPVtI4dPx33uUSuxSD56kdcvEIG3Hw8dFA
        PBak/kP0fIolkQ9Glaf13fU=
X-Google-Smtp-Source: APXvYqx5HEYOOKj17WOjpHfej7IR0stg4M9N33BijqyltbIcvvGw/fAGwTaDYmBqCJtH+96hGBCUwQ==
X-Received: by 2002:a63:f941:: with SMTP id q1mr7855384pgk.350.1562897191764;
        Thu, 11 Jul 2019 19:06:31 -0700 (PDT)
Received: from localhost ([220.240.228.224])
        by smtp.gmail.com with ESMTPSA id f12sm6336662pgo.85.2019.07.11.19.06.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 19:06:30 -0700 (PDT)
Date:   Fri, 12 Jul 2019 12:03:21 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 7/8] KVM: PPC: Ultravisor: Enter a secure guest
To:     Claudio Carvalho <cclaudio@linux.ibm.com>, linuxppc-dev@ozlabs.org
Cc:     Michael Anderson <andmike@linux.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        kvm-ppc@vger.kernel.org, Ram Pai <linuxram@us.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com>
        <20190628200825.31049-8-cclaudio@linux.ibm.com>
In-Reply-To: <20190628200825.31049-8-cclaudio@linux.ibm.com>
MIME-Version: 1.0
User-Agent: astroid/0.14.0 (https://github.com/astroidmail/astroid)
Message-Id: <1562896723.n2w6yyxx6b.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Claudio Carvalho's on June 29, 2019 6:08 am:
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
>=20
> To enter a secure guest, we have to go through the ultravisor, therefore
> we do a ucall when we are entering a secure guest.
>=20
> This change is needed for any sort of entry to the secure guest from the
> hypervisor, whether it is a return from an hcall, a return from a
> hypervisor interrupt, or the first time that a secure guest vCPU is run.
>=20
> If we are returning from an hcall, the results are already in the
> appropriate registers R3:12, except for R3, R6 and R7. R3 has the status
> of the reflected hcall, therefore we move it to R0 for the ultravisor and
> set R3 to the UV_RETURN ucall number. R6,7 were used as temporary
> registers, hence we restore them.
>=20
> Have fast_guest_return check the kvm_arch.secure_guest field so that a
> new CPU enters UV when started (in response to a RTAS start-cpu call).
>=20
> Thanks to input from Paul Mackerras, Ram Pai and Mike Anderson.
>=20
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> [ Pass SRR1 in r11 for UV_RETURN, fix kvmppc_msr_interrupt to preserve
>   the MSR_S bit ]
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
> [ Fix UV_RETURN ucall number and arch.secure_guest check ]
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> [ Save the actual R3 in R0 for the ultravisor and use R3 for the
>   UV_RETURN ucall number. Update commit message and ret_to_ultra comment =
]
> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/kvm_host.h       |  1 +
>  arch/powerpc/include/asm/ultravisor-api.h |  1 +
>  arch/powerpc/kernel/asm-offsets.c         |  1 +
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S   | 40 +++++++++++++++++++----
>  4 files changed, 37 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/a=
sm/kvm_host.h
> index 013c76a0a03e..184becb62ea4 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -294,6 +294,7 @@ struct kvm_arch {
>  	cpumask_t cpu_in_guest;
>  	u8 radix;
>  	u8 fwnmi_enabled;
> +	u8 secure_guest;
>  	bool threads_indep;
>  	bool nested_enable;
>  	pgd_t *pgtable;
> diff --git a/arch/powerpc/include/asm/ultravisor-api.h b/arch/powerpc/inc=
lude/asm/ultravisor-api.h
> index 141940771add..7c4d0b4ced12 100644
> --- a/arch/powerpc/include/asm/ultravisor-api.h
> +++ b/arch/powerpc/include/asm/ultravisor-api.h
> @@ -19,5 +19,6 @@
> =20
>  /* opcodes */
>  #define UV_WRITE_PATE			0xF104
> +#define UV_RETURN			0xF11C
> =20
>  #endif /* _ASM_POWERPC_ULTRAVISOR_API_H */
> diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-=
offsets.c
> index 8e02444e9d3d..44742724513e 100644
> --- a/arch/powerpc/kernel/asm-offsets.c
> +++ b/arch/powerpc/kernel/asm-offsets.c
> @@ -508,6 +508,7 @@ int main(void)
>  	OFFSET(KVM_VRMA_SLB_V, kvm, arch.vrma_slb_v);
>  	OFFSET(KVM_RADIX, kvm, arch.radix);
>  	OFFSET(KVM_FWNMI, kvm, arch.fwnmi_enabled);
> +	OFFSET(KVM_SECURE_GUEST, kvm, arch.secure_guest);
>  	OFFSET(VCPU_DSISR, kvm_vcpu, arch.shregs.dsisr);
>  	OFFSET(VCPU_DAR, kvm_vcpu, arch.shregs.dar);
>  	OFFSET(VCPU_VPA, kvm_vcpu, arch.vpa.pinned_addr);
> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/b=
ook3s_hv_rmhandlers.S
> index cffb365d9d02..89813ca987c2 100644
> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> @@ -36,6 +36,7 @@
>  #include <asm/asm-compat.h>
>  #include <asm/feature-fixups.h>
>  #include <asm/cpuidle.h>
> +#include <asm/ultravisor-api.h>
> =20
>  /* Sign-extend HDEC if not on POWER9 */
>  #define EXTEND_HDEC(reg)			\
> @@ -1092,16 +1093,12 @@ BEGIN_FTR_SECTION
>  END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
> =20
>  	ld	r5, VCPU_LR(r4)
> -	ld	r6, VCPU_CR(r4)
>  	mtlr	r5
> -	mtcr	r6
> =20
>  	ld	r1, VCPU_GPR(R1)(r4)
>  	ld	r2, VCPU_GPR(R2)(r4)
>  	ld	r3, VCPU_GPR(R3)(r4)
>  	ld	r5, VCPU_GPR(R5)(r4)
> -	ld	r6, VCPU_GPR(R6)(r4)
> -	ld	r7, VCPU_GPR(R7)(r4)
>  	ld	r8, VCPU_GPR(R8)(r4)
>  	ld	r9, VCPU_GPR(R9)(r4)
>  	ld	r10, VCPU_GPR(R10)(r4)

Just to try to be less arbitrary about things, could you use regs
adjacent to r4? Generally good because then it has a chance to get
our loads paired up (which may not help some CPUs).

Thanks,
Nick
=
