Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E932D7F642
	for <lists+kvm-ppc@lfdr.de>; Fri,  2 Aug 2019 13:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392468AbfHBL4x (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 2 Aug 2019 07:56:53 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:42699 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731531AbfHBL4w (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 2 Aug 2019 07:56:52 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 460Qcf1lx4z9s7T;
        Fri,  2 Aug 2019 21:56:50 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>, linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Claudio Carvalho <cclaudio@linux.ibm.com>
Subject: Re: [RFC PATCH] powerpc: Add the ppc_capabilities ELF note
In-Reply-To: <20190701140948.26775-1-cclaudio@linux.ibm.com>
References: <20190701140948.26775-1-cclaudio@linux.ibm.com>
Date:   Fri, 02 Aug 2019 21:56:48 +1000
Message-ID: <874l2zlr0f.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Claudio,

Claudio Carvalho <cclaudio@linux.ibm.com> writes:
> Add the ppc_capabilities ELF note to the powerpc kernel binary. It is a
> bitmap that can be used to advertise kernel capabilities to userland.
>
> This patch also defines PPCCAP_ULTRAVISOR_BIT as being the bit zero.

Apologies for the slow review.

I think we should use the "PowerPC" name space for the note. There is
precedent for that in that we already create a note with that name in
our zImage.pseries. See arch/powerpc/boot/addnote.c

That code uses a note type of 1275 (from IEEE 1275).

For this capabilities note I think we should probably just use a note
type of 1, just in case note type 0 confuses something. The note types
Linux defines in include/uapi/linux/elf.h also start at 1.

So we should have a powerpc uapi header, elfnote.h I guess, which
documents we're using the "PowerPC" namespace and defines note type 1 as
the "Capabilities" type.

I'd also like something more like a specification document, that can go
in Documentation/powerpc and describes the capabilities bits in general
and then what the specific ultravisor bit means. Something we could
point other operating systems at if they want to implement similar
support.

Also none of this is any use unless petitboot is taught to look for the
note. I imagine with Sam having left we don't have anyone signed up to
do that work?

Also when you send v2 do you mind Cc'ing linux kernel and linux-arch,
thanks.

> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
> index 0ea6c4aa3a20..4ec36fe4325b 100644
> --- a/arch/powerpc/kernel/Makefile
> +++ b/arch/powerpc/kernel/Makefile
> @@ -49,7 +49,7 @@ obj-y				:= cputable.o ptrace.o syscalls.o \
>  				   signal.o sysfs.o cacheinfo.o time.o \
>  				   prom.o traps.o setup-common.o \
>  				   udbg.o misc.o io.o misc_$(BITS).o \
> -				   of_platform.o prom_parse.o
> +				   of_platform.o prom_parse.o note.o

I think for now we should make this 64-bit Book3S only, as there are no
plans for it to be used on any other platforms. A boot loader can
interpret the absence of the note entirely as a set of capabilities
that are all zero.


>  obj-$(CONFIG_PPC64)		+= setup_64.o sys_ppc32.o \
>  				   signal_64.o ptrace32.o \
>  				   paca.o nvram_64.o firmware.o

cheers


> diff --git a/arch/powerpc/kernel/note.S b/arch/powerpc/kernel/note.S
> new file mode 100644
> index 000000000000..721bf8ce9eb7
> --- /dev/null
> +++ b/arch/powerpc/kernel/note.S
> @@ -0,0 +1,36 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * PowerPC ELF notes.
> + *
> + * Copyright 2019, IBM Corporation
> + */
> +#include <linux/elfnote.h>
> +
> +/*
> + * Ultravisor-capable bit (PowerNV only).
> + *
> + * Indicate that the powerpc kernel binary knows how to run in an
> + * ultravisor-enabled system.
> + *
> + * In an ultravisor-enabled system, some machine resources are now controlled
> + * by the ultravisor. If the kernel is not ultravisor-capable, but it ends up
> + * being run on a machine with ultravisor, the kernel will probably crash
> + * trying to access ultravisor resources. For instance, it may crash in early
> + * boot trying to set the partition table entry 0.
> + *
> + * In an ultravisor-enabled system, petitboot can warn the user or prevent the
> + * kernel from being run if the ppc_capabilities doesn't exist or the
> + * Ultravisor-capable bit is not set.
> + */
> +#if defined(CONFIG_PPC_POWERNV)
> +#define PPCCAP_ULTRAVISOR_BIT		(1 << 0)
> +#else
> +#define PPCCAP_ULTRAVISOR_BIT		0
> +#endif
> +
> +/*
> + * Add the ppc_capabilities ELF note to the powerpc kernel binary. It is a
> + * bitmap that can be used to advertise kernel capabilities to userland.
> + */
> +ELFNOTE(ppc_capabilities, 3,
> +	.long PPCCAP_ULTRAVISOR_BIT)
> -- 
> 2.20.1
