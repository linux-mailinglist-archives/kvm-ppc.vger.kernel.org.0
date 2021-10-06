Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6926D423BA5
	for <lists+kvm-ppc@lfdr.de>; Wed,  6 Oct 2021 12:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238136AbhJFKoI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm-ppc@lfdr.de>); Wed, 6 Oct 2021 06:44:08 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:48976 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229824AbhJFKoI (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 6 Oct 2021 06:44:08 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-i2d87W4iMU-K3Gz0empo0Q-1; Wed, 06 Oct 2021 06:42:11 -0400
X-MC-Unique: i2d87W4iMU-K3Gz0empo0Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 737C5835DE5;
        Wed,  6 Oct 2021 10:42:09 +0000 (UTC)
Received: from bahia.huguette (unknown [10.39.192.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E46560854;
        Wed,  6 Oct 2021 10:42:06 +0000 (UTC)
Date:   Wed, 6 Oct 2021 12:42:04 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Laurent Vivier <lvivier@redhat.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>
Subject: Re: [PATCH] KVM: PPC: Defer vtime accounting 'til after IRQ
 handling
Message-ID: <20211006124204.4741bb5c@bahia.huguette>
In-Reply-To: <20211006073745.82109-1-lvivier@redhat.com>
References: <20211006073745.82109-1-lvivier@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kaod.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed,  6 Oct 2021 09:37:45 +0200
Laurent Vivier <lvivier@redhat.com> wrote:

> Commit 61bd0f66ff92 has moved guest_enter() out of the interrupt
> protected area to be able to have updated tick counters, but
> commit 112665286d08 moved back to this area to avoid wrong
> context warning (or worse).
> 
> None of them are correct, to fix the problem port to POWER
> the x86 fix 160457140187 ("KVM: x86: Defer vtime accounting 'til
> after IRQ handling"):
> 
> "Defer the call to account guest time until after servicing any IRQ(s)
>  that happened in the guest or immediately after VM-Exit.  Tick-based
>  accounting of vCPU time relies on PF_VCPU being set when the tick IRQ
>  handler runs, and IRQs are blocked throughout the main sequence of
>  vcpu_enter_guest(), including the call into vendor code to actually
>  enter and exit the guest."
> 
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=2009312
> Fixes: 61bd0f66ff92 ("KVM: PPC: Book3S HV: Fix guest time accounting with VIRT_CPU_ACCOUNTING_GEN")

This patch was merged in linux 4.16 and thus is on the 4.16.y
stable branch and it was backported to stable 4.14.y. It would
make sense to Cc: stable # v4.14 also, but...

> Fixes: 112665286d08 ("KVM: PPC: Book3S HV: Context tracking exit guest context before enabling irqs")

... this one, which was merged in linux 5.12, was never backported
anywhere because it wasn't considered as a fix, as commented here:

https://lore.kernel.org/linuxppc-dev/1610793296.fjhomer31g.astroid@bobo.none/

AFAICT commit 61bd0f66ff92 was never mentioned anywhere in a bug. The
first Fixes: tag thus looks a bit misleading. I'd personally drop it
and Cc: stable # v5.12.

> Cc: npiggin@gmail.com
> 
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 2acb1c96cfaf..43e1ce853785 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3695,6 +3695,8 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
>  
>  	srcu_read_unlock(&vc->kvm->srcu, srcu_idx);
>  
> +	context_tracking_guest_exit();
> +
>  	set_irq_happened(trap);
>  
>  	spin_lock(&vc->lock);
> @@ -3726,9 +3728,8 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
>  
>  	kvmppc_set_host_core(pcpu);
>  
> -	guest_exit_irqoff();
> -


Change looks ok but it might be a bit confusing for the
occasional reader that guest_enter_irqoff() isn't matched
by a guest_exit_irqoff().

>  	local_irq_enable();
> +	vtime_account_guest_exit();
>  

Maybe add a comment like in x86 ?

>  	/* Let secondaries go back to the offline loop */
>  	for (i = 0; i < controlled_threads; ++i) {
> @@ -4506,13 +4507,14 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
>  
>  	srcu_read_unlock(&kvm->srcu, srcu_idx);
>  
> +	context_tracking_guest_exit();
> +
>  	set_irq_happened(trap);
>  
>  	kvmppc_set_host_core(pcpu);
>  
> -	guest_exit_irqoff();
> -
>  	local_irq_enable();
> +	vtime_account_guest_exit();
>  
>  	cpumask_clear_cpu(pcpu, &kvm->arch.cpu_in_guest);
>  

Same remarks. FWIW a followup was immediately added to x86 to
encapsulate the enter/exit logic in common helpers :

ommit bc908e091b3264672889162733020048901021fb
Author: Sean Christopherson <seanjc@google.com>
Date:   Tue May 4 17:27:35 2021 -0700

    KVM: x86: Consolidate guest enter/exit logic to common helpers

This makes the code nicer. Maybe do something similar for POWER ?

Cheers,

--
Greg

