Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E231B15CEAC
	for <lists+kvm-ppc@lfdr.de>; Fri, 14 Feb 2020 00:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbgBMXcB (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 13 Feb 2020 18:32:01 -0500
Received: from gate.crashing.org ([63.228.1.57]:51499 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727594AbgBMXcB (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 13 Feb 2020 18:32:01 -0500
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 01DNVn6L015172;
        Thu, 13 Feb 2020 17:31:49 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 01DNVmdM015171;
        Thu, 13 Feb 2020 17:31:48 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Thu, 13 Feb 2020 17:31:48 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Gustavo Romero <gromero@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Treat unrecognized TM instructions as illegal
Message-ID: <20200213233148.GK22482@gate.crashing.org>
References: <20200213151532.12559-1-gromero@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213151532.12559-1-gromero@linux.ibm.com>
User-Agent: Mutt/1.4.2.3i
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Feb 13, 2020 at 10:15:32AM -0500, Gustavo Romero wrote:
> On P9 DD2.2 due to a CPU defect some TM instructions need to be emulated by
> KVM. This is handled at first by the hardware raising a softpatch interrupt
> when certain TM instructions that need KVM assistance are executed in the
> guest. Some TM instructions, although not defined in the Power ISA, might
> raise a softpatch interrupt. For instance, 'tresume.' instruction as
> defined in the ISA must have bit 31 set (1), but an instruction that
> matches 'tresume.' OP and XO opcodes but has bit 31 not set (0), like
> 0x7cfe9ddc, also raises a softpatch interrupt, for example, if a code
> like the following is executed in the guest it will raise a softpatch
> interrupt just like a 'tresume.' when the TM facility is enabled:
> 
> int main() { asm("tabort. 0; .long 0x7cfe9ddc;"); }
> 
> Currently in such a case KVM throws a complete trace like the following:

[snip]

> and then treats the executed instruction as 'nop' whilst it should actually
> be treated as an illegal instruction since it's not defined by the ISA.
> 
> This commit changes the handling of the case above by treating the
> unrecognized TM instructions that can raise a softpatch but are not
> defined in the ISA as illegal ones instead of as 'nop' and by gently
> reporting it to the host instead of throwing a trace.
> 
> Signed-off-by: Gustavo Romero <gromero@linux.ibm.com>

Reviewed-by: Segher Boessenkool <segher@kernel.crashing.org>

> ---
>  arch/powerpc/kvm/book3s_hv_tm.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv_tm.c b/arch/powerpc/kvm/book3s_hv_tm.c
> index 0db937497169..d342a9e11298 100644
> --- a/arch/powerpc/kvm/book3s_hv_tm.c
> +++ b/arch/powerpc/kvm/book3s_hv_tm.c
> @@ -3,6 +3,8 @@
>   * Copyright 2017 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/kvm_host.h>
>  
>  #include <asm/kvm_ppc.h>
> @@ -208,6 +210,8 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
>  	}
>  
>  	/* What should we do here? We didn't recognize the instruction */
> -	WARN_ON_ONCE(1);
> +	kvmppc_core_queue_program(vcpu, SRR1_PROGILL);
> +	pr_warn_ratelimited("Unrecognized TM-related instruction %#x for emulation", instr);
> +
>  	return RESUME_GUEST;
>  }

Do we actually know it is TM-related here?  Otherwise, looks good to me :-)


Segher
