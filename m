Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC564C994
	for <lists+kvm-ppc@lfdr.de>; Thu, 20 Jun 2019 10:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbfFTIg5 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 20 Jun 2019 04:36:57 -0400
Received: from 6.mo2.mail-out.ovh.net ([87.98.165.38]:57374 "EHLO
        6.mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfFTIgw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 20 Jun 2019 04:36:52 -0400
X-Greylist: delayed 1017 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Jun 2019 04:36:51 EDT
Received: from player758.ha.ovh.net (unknown [10.109.160.39])
        by mo2.mail-out.ovh.net (Postfix) with ESMTP id 1D2981A0040
        for <kvm-ppc@vger.kernel.org>; Thu, 20 Jun 2019 10:19:53 +0200 (CEST)
Received: from kaod.org (lfbn-1-2240-157.w90-76.abo.wanadoo.fr [90.76.60.157])
        (Authenticated sender: clg@kaod.org)
        by player758.ha.ovh.net (Postfix) with ESMTPSA id 50490713A45D;
        Thu, 20 Jun 2019 08:19:49 +0000 (UTC)
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S HV: Clear pending decr exceptions on
 nested guest entry
To:     Laurent Vivier <lvivier@redhat.com>,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org
References: <20190620014651.7645-1-sjitindarsingh@gmail.com>
 <20190620014651.7645-3-sjitindarsingh@gmail.com>
 <30c02f09-8376-3dd0-e463-94d396df0240@redhat.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <31d62ffd-2d29-f314-dcff-0cc27919c58a@kaod.org>
Date:   Thu, 20 Jun 2019 10:19:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <30c02f09-8376-3dd0-e463-94d396df0240@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 4731031409092824023
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduvddrtdeggddtvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 20/06/2019 09:57, Laurent Vivier wrote:
> On 20/06/2019 03:46, Suraj Jitindar Singh wrote:
>> If we enter an L1 guest with a pending decrementer exception then this
>> is cleared on guest exit if the guest has writtien a positive value into
>> the decrementer (indicating that it handled the decrementer exception)
>> since there is no other way to detect that the guest has handled the
>> pending exception and that it should be dequeued. In the event that the
>> L1 guest tries to run a nested (L2) guest immediately after this and the
>> L2 guest decrementer is negative (which is loaded by L1 before making
>> the H_ENTER_NESTED hcall), then the pending decrementer exception
>> isn't cleared and the L2 entry is blocked since L1 has a pending
>> exception, even though L1 may have already handled the exception and
>> written a positive value for it's decrementer. This results in a loop of
>> L1 trying to enter the L2 guest and L0 blocking the entry since L1 has
>> an interrupt pending with the outcome being that L2 never gets to run
>> and hangs.
>>
>> Fix this by clearing any pending decrementer exceptions when L1 makes
>> the H_ENTER_NESTED hcall since it won't do this if it's decrementer has
>> gone negative, and anyway it's decrementer has been communicated to L0
>> in the hdec_expires field and L0 will return control to L1 when this
>> goes negative by delivering an H_DECREMENTER exception.
>>
>> Fixes: 95a6432ce903 "KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests"
>>
>> Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
>> ---
>>  arch/powerpc/kvm/book3s_hv.c | 11 +++++++++--
>>  1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index 719fd2529eec..4a5eb29b952f 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -4128,8 +4128,15 @@ int kvmhv_run_single_vcpu(struct kvm_run *kvm_run,
>>  
>>  	preempt_enable();
>>  
>> -	/* cancel pending decrementer exception if DEC is now positive */
>> -	if (get_tb() < vcpu->arch.dec_expires && kvmppc_core_pending_dec(vcpu))
>> +	/*
>> +	 * cancel pending decrementer exception if DEC is now positive, or if
>> +	 * entering a nested guest in which case the decrementer is now owned
>> +	 * by L2 and the L1 decrementer is provided in hdec_expires
>> +	 */
>> +	if (kvmppc_core_pending_dec(vcpu) &&
>> +			((get_tb() < vcpu->arch.dec_expires) ||
>> +			 (trap == BOOK3S_INTERRUPT_SYSCALL &&
>> +			  kvmppc_get_gpr(vcpu, 3) == H_ENTER_NESTED)))
>>  		kvmppc_core_dequeue_dec(vcpu);
>>  
>>  	trace_kvm_guest_exit(vcpu);
>>
> 
> Patches 2 and 3: tested I can boot and run an L2 nested guest with qemu
> v4.0.0 and caps-large-decr=on in the case we have had a hang previously.
> 
> Tested-by: Laurent Vivier <lvivier@redhat.com>

You beat me to it. All works fine on L0, L1, L2.

  Tested-by: Cédric Le Goater <clg@kaod.org>

With a QEMU-4.1. In this configuration, L2 runs with the XIVE (emulated) 
interrupt mode by default now (kernel_irqchip=allowed, ic-mode=dual).

Thanks,

C.


