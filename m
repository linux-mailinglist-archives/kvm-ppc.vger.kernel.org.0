Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECA9D3AEA
	for <lists+kvm-ppc@lfdr.de>; Fri, 11 Oct 2019 10:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfJKIWP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 11 Oct 2019 04:22:15 -0400
Received: from ozlabs.org ([203.11.71.1]:59013 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727379AbfJKIWP (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 11 Oct 2019 04:22:15 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 46qLXg19TWz9sPk; Fri, 11 Oct 2019 19:22:10 +1100 (AEDT)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 7fe4e1176dfe47a243d8edd98d26abd11f91b042
In-Reply-To: <20191004025317.19340-1-jniethe5@gmail.com>
To:     Jordan Niethe <jniethe5@gmail.com>, linuxppc-dev@lists.ozlabs.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     aik@ozlabs.ru, alistair@popple.id.au,
        patch-notifications@ellerman.id.au, kvm-ppc@vger.kernel.org,
        Jordan Niethe <jniethe5@gmail.com>
Subject: Re: [PATCH] powerpc/kvm: Fix kvmppc_vcore->in_guest value in kvmhv_switch_to_host
Message-Id: <46qLXg19TWz9sPk@ozlabs.org>
Date:   Fri, 11 Oct 2019 19:22:10 +1100 (AEDT)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, 2019-10-04 at 02:53:17 UTC, Jordan Niethe wrote:
> kvmhv_switch_to_host() in arch/powerpc/kvm/book3s_hv_rmhandlers.S needs
> to set kvmppc_vcore->in_guest to 0 to signal secondary CPUs to continue.
> This happens after resetting the PCR. Before commit 13c7bb3c57dc
> ("powerpc/64s: Set reserved PCR bits"), r0 would always be 0 before it
> was stored to kvmppc_vcore->in_guest. However because of this change in
> the commit:
> 
>         /* Reset PCR */
>         ld      r0, VCORE_PCR(r5)
> -       cmpdi   r0, 0
> +       LOAD_REG_IMMEDIATE(r6, PCR_MASK)
> +       cmpld   r0, r6
>         beq     18f
> -       li      r0, 0
> -       mtspr   SPRN_PCR, r0
> +       mtspr   SPRN_PCR, r6
>  18:
>         /* Signal secondary CPUs to continue */
>         stb     r0,VCORE_IN_GUEST(r5)
> 
> We are no longer comparing r0 against 0 and loading it with 0 if it
> contains something else. Hence when we store r0 to
> kvmppc_vcore->in_guest, it might not be 0.  This means that secondary
> CPUs will not be signalled to continue. Those CPUs get stuck and errors
> like the following are logged:
> 
>     KVM: CPU 1 seems to be stuck
>     KVM: CPU 2 seems to be stuck
>     KVM: CPU 3 seems to be stuck
>     KVM: CPU 4 seems to be stuck
>     KVM: CPU 5 seems to be stuck
>     KVM: CPU 6 seems to be stuck
>     KVM: CPU 7 seems to be stuck
> 
> This can be reproduced with:
>     $ for i in `seq 1 7` ; do chcpu -d $i ; done ;
>     $ taskset -c 0 qemu-system-ppc64 -smp 8,threads=8 \
>        -M pseries,accel=kvm,kvm-type=HV -m 1G -nographic -vga none \
>        -kernel vmlinux -initrd initrd.cpio.xz
> 
> Fix by making sure r0 is 0 before storing it to kvmppc_vcore->in_guest.
> 
> Fixes: 13c7bb3c57dc ("powerpc/64s: Set reserved PCR bits")
> Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> Signed-off-by: Jordan Niethe <jniethe5@gmail.com>

Applied to powerpc fixes, thanks.

https://git.kernel.org/powerpc/c/7fe4e1176dfe47a243d8edd98d26abd11f91b042

cheers
