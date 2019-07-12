Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE8166353
	for <lists+kvm-ppc@lfdr.de>; Fri, 12 Jul 2019 03:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbfGLBVL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 11 Jul 2019 21:21:11 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46839 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbfGLBVL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 11 Jul 2019 21:21:11 -0400
Received: by mail-pl1-f194.google.com with SMTP id c2so3910660plz.13
        for <kvm-ppc@vger.kernel.org>; Thu, 11 Jul 2019 18:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :user-agent:message-id:content-transfer-encoding;
        bh=3j/AVIUvR2v+mpYnU0BsTGl5FJsU/0jz0GYmQkZbjog=;
        b=o9/GHKbKtLNSdNvzLND9O3fHfFacKVa9g7mGOC0aRdZRJO0msibZ17trXaAYh0Ks/x
         HmXWkAF9OreWLvLRxVs4wPXChIU+UwXwLBjyiRteFQ7B2Cah84QekopzlQNK/jjybGco
         CKhAmeBX2UqPzHTOq9a8zX1gdz9GMko0BPb/Q+/UIEA19/qI1tB3QuzjCcRRbVgLlkiy
         xbrbeYMRO0ADZQ1RUAEj6PoGU2CX4Zpqx85Lw6ZoDNOCWd8XWPO5mQo1TZ9Iv8v4xCy1
         1e4ps5EyqMJmZGId9bElgugNl5owC4Pb4hhoEJkdaTB9WgsM7znK78QEfDc2st/qtpus
         BEvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:user-agent:message-id:content-transfer-encoding;
        bh=3j/AVIUvR2v+mpYnU0BsTGl5FJsU/0jz0GYmQkZbjog=;
        b=MbfvS5JCZnY8ajjrTMPWE2DjRbRUAzfRARKwUxnWdA9hXMsxfd5SnlUClJcTYz5s7Y
         DueJoY4JQwNdl+U7yXklEqGUFPcRY+mLDmoFqJvoGecKZ3XxBj20HizxXw7ITntSp2SH
         ddcTqgY1GU/P9by0oVpKgudm63AiZFyyM30mZfSK8Z6ktW3kYxYmD3Bjx1fK+1WmiFZO
         S5vxYl7yE/aNMYI1+r+b0oc2seL0bHslTVbIbJYlJwVX9faGfoSMSAQ/Jj379i3wfGjz
         +jwfzngK10YiHjUKyBSpKgh1AeIG6djVDYi7o9zhWFL+yeNV9BYfkvfQpDkCasoGazNS
         SsqA==
X-Gm-Message-State: APjAAAWL176wmckuLVAAWsP8SQ3urFbzCZ4SKMqoq5pR5dMZ92FocggI
        v5j7khJBkfCm/PY/U3LDRoQ=
X-Google-Smtp-Source: APXvYqxkmrTfx5MDsHmqoR/hBNaqVN1LCz4GaVMUdLNgjg0l3Dnfq8wBuHbsLGSRWTp44Mcl97l1tA==
X-Received: by 2002:a17:902:6ac6:: with SMTP id i6mr8057956plt.233.1562894470035;
        Thu, 11 Jul 2019 18:21:10 -0700 (PDT)
Received: from localhost ([220.240.228.224])
        by smtp.gmail.com with ESMTPSA id z68sm6418485pgz.88.2019.07.11.18.21.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 18:21:09 -0700 (PDT)
Date:   Fri, 12 Jul 2019 11:18:00 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 3/8] KVM: PPC: Ultravisor: Add generic ultravisor call
 handler
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
        <20190628200825.31049-4-cclaudio@linux.ibm.com>
In-Reply-To: <20190628200825.31049-4-cclaudio@linux.ibm.com>
MIME-Version: 1.0
User-Agent: astroid/0.14.0 (https://github.com/astroidmail/astroid)
Message-Id: <1562893632.8au1xo907s.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Claudio Carvalho's on June 29, 2019 6:08 am:
> From: Ram Pai <linuxram@us.ibm.com>
>=20
> Add the ucall() function, which can be used to make ultravisor calls
> with varied number of in and out arguments. Ultravisor calls can be made
> from the host or guests.
>=20
> This copies the implementation of plpar_hcall().
>=20
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> [ Change ucall.S to not save CR, rename and move headers, build ucall.S
>   if CONFIG_PPC_POWERNV set, use R3 for the ucall number and add some
>   comments in the code ]
> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/ultravisor-api.h | 20 +++++++++++++++
>  arch/powerpc/include/asm/ultravisor.h     | 20 +++++++++++++++
>  arch/powerpc/kernel/Makefile              |  2 +-
>  arch/powerpc/kernel/ucall.S               | 30 +++++++++++++++++++++++
>  arch/powerpc/kernel/ultravisor.c          |  4 +++
>  5 files changed, 75 insertions(+), 1 deletion(-)
>  create mode 100644 arch/powerpc/include/asm/ultravisor-api.h
>  create mode 100644 arch/powerpc/kernel/ucall.S
>=20
> diff --git a/arch/powerpc/include/asm/ultravisor-api.h b/arch/powerpc/inc=
lude/asm/ultravisor-api.h
> new file mode 100644
> index 000000000000..49e766adabc7
> --- /dev/null
> +++ b/arch/powerpc/include/asm/ultravisor-api.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Ultravisor API.
> + *
> + * Copyright 2019, IBM Corporation.
> + *
> + */
> +#ifndef _ASM_POWERPC_ULTRAVISOR_API_H
> +#define _ASM_POWERPC_ULTRAVISOR_API_H
> +
> +#include <asm/hvcall.h>
> +
> +/* Return codes */
> +#define U_NOT_AVAILABLE		H_NOT_AVAILABLE
> +#define U_SUCCESS		H_SUCCESS
> +#define U_FUNCTION		H_FUNCTION
> +#define U_PARAMETER		H_PARAMETER
> +
> +#endif /* _ASM_POWERPC_ULTRAVISOR_API_H */
> +
> diff --git a/arch/powerpc/include/asm/ultravisor.h b/arch/powerpc/include=
/asm/ultravisor.h
> index e5009b0d84ea..a78a2dacfd0b 100644
> --- a/arch/powerpc/include/asm/ultravisor.h
> +++ b/arch/powerpc/include/asm/ultravisor.h
> @@ -8,8 +8,28 @@
>  #ifndef _ASM_POWERPC_ULTRAVISOR_H
>  #define _ASM_POWERPC_ULTRAVISOR_H
> =20
> +#include <asm/ultravisor-api.h>
> +
> +#if !defined(__ASSEMBLY__)
> +
>  /* Internal functions */
>  extern int early_init_dt_scan_ultravisor(unsigned long node, const char =
*uname,
>  					 int depth, void *data);
> =20
> +/* API functions */
> +#define UCALL_BUFSIZE 4
> +/**
> + * ucall: Make a powerpc ultravisor call.
> + * @opcode: The ultravisor call to make.
> + * @retbuf: Buffer to store up to 4 return arguments in.
> + *
> + * This call supports up to 6 arguments and 4 return arguments. Use
> + * UCALL_BUFSIZE to size the return argument buffer.
> + */
> +#if defined(CONFIG_PPC_POWERNV)
> +long ucall(unsigned long opcode, unsigned long *retbuf, ...);
> +#endif
> +
> +#endif /* !__ASSEMBLY__ */
> +
>  #endif	/* _ASM_POWERPC_ULTRAVISOR_H */
> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
> index f0caa302c8c0..f28baccc0a79 100644
> --- a/arch/powerpc/kernel/Makefile
> +++ b/arch/powerpc/kernel/Makefile
> @@ -154,7 +154,7 @@ endif
> =20
>  obj-$(CONFIG_EPAPR_PARAVIRT)	+=3D epapr_paravirt.o epapr_hcalls.o
>  obj-$(CONFIG_KVM_GUEST)		+=3D kvm.o kvm_emul.o
> -obj-$(CONFIG_PPC_POWERNV)	+=3D ultravisor.o
> +obj-$(CONFIG_PPC_POWERNV)	+=3D ultravisor.o ucall.o
> =20
>  # Disable GCOV, KCOV & sanitizers in odd or sensitive code
>  GCOV_PROFILE_prom_init.o :=3D n
> diff --git a/arch/powerpc/kernel/ucall.S b/arch/powerpc/kernel/ucall.S
> new file mode 100644
> index 000000000000..1678f6eb7230
> --- /dev/null
> +++ b/arch/powerpc/kernel/ucall.S
> @@ -0,0 +1,30 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Generic code to perform an ultravisor call.
> + *
> + * Copyright 2019, IBM Corporation.
> + *
> + */
> +#include <asm/ppc_asm.h>
> +
> +/*
> + * This function is based on the plpar_hcall()

A better comment might be to specify calling convention.

> + */
> +_GLOBAL_TOC(ucall)
> +	std	r4,STK_PARAM(R4)(r1)	/* Save ret buffer */
> +	mr	r4,r5
> +	mr	r5,r6
> +	mr	r6,r7
> +	mr	r7,r8
> +	mr	r8,r9
> +	mr	r9,r10

I guess this is fine, is there any particular reason that you made
the call convention this way rather than leaving regs in place and
r4 is a scratch?

> +
> +	sc 2				/* Invoke the ultravisor */
> +
> +	ld	r12,STK_PARAM(R4)(r1)
> +	std	r4,  0(r12)
> +	std	r5,  8(r12)
> +	std	r6, 16(r12)
> +	std	r7, 24(r12)
> +

=
