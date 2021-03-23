Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4103458A6
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 08:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbhCWH10 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 23 Mar 2021 03:27:26 -0400
Received: from smtpout1.mo529.mail-out.ovh.net ([178.32.125.2]:49337 "EHLO
        smtpout1.mo529.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229452AbhCWH0z (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 23 Mar 2021 03:26:55 -0400
Received: from mxplan5.mail.ovh.net (unknown [10.109.156.102])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id C947693CC5D1;
        Tue, 23 Mar 2021 08:26:31 +0100 (CET)
Received: from kaod.org (37.59.142.100) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Tue, 23 Mar
 2021 08:26:30 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-100R003d932da59-8f62-453a-9723-a91eb2f9e31b,
                    3463118FEE79F4041422E427733B80787D17A221) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Subject: Re: [PATCH v3 19/41] KVM: PPC: Book3S HV P9: Stop handling hcalls in
 real-mode in the P9 path
To:     Nicholas Piggin <npiggin@gmail.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, <kvm-ppc@vger.kernel.org>
CC:     <linuxppc-dev@lists.ozlabs.org>
References: <20210305150638.2675513-1-npiggin@gmail.com>
 <20210305150638.2675513-20-npiggin@gmail.com>
 <b06ebe14-a714-c882-8bdf-ac41de9a8523@ozlabs.ru>
 <1616417941.ksskhyvg3t.astroid@bobo.none>
 <cc1660a7-e81e-b7b3-a841-35fb77fb571b@kaod.org>
 <1616436906.owrt3o4wh1.astroid@bobo.none>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <a8453296-717e-5186-38f9-38f0962e2e17@kaod.org>
Date:   Tue, 23 Mar 2021 08:26:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1616436906.owrt3o4wh1.astroid@bobo.none>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.100]
X-ClientProxiedBy: DAG1EX2.mxp5.local (172.16.2.2) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: d7ca665f-a7c6-43b6-a0c3-6ab51d795ff4
X-Ovh-Tracer-Id: 10963731819251862496
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrudeghedguddtjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefuvfhfhffkffgfgggjtgfgihesthekredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeejkeduueduveelgeduueegkeelffevledujeetffeivdelvdfgkeeufeduheehfeenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddruddttdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhrtghpthhtohepnhhpihhgghhinhesghhmrghilhdrtghomh
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 3/22/21 7:22 PM, Nicholas Piggin wrote:
> Excerpts from Cédric Le Goater's message of March 23, 2021 2:01 am:
>> On 3/22/21 2:15 PM, Nicholas Piggin wrote:
>>> Excerpts from Alexey Kardashevskiy's message of March 22, 2021 5:30 pm:
>>>>
>>>>
>>>> On 06/03/2021 02:06, Nicholas Piggin wrote:
>>>>> In the interest of minimising the amount of code that is run in>>> "real-mode", don't handle hcalls in real mode in the P9 path.
>>>>>
>>>>> POWER8 and earlier are much more expensive to exit from HV real mode
>>>>> and switch to host mode, because on those processors HV interrupts get
>>>>> to the hypervisor with the MMU off, and the other threads in the core
>>>>> need to be pulled out of the guest, and SLBs all need to be saved,
>>>>> ERATs invalidated, and host SLB reloaded before the MMU is re-enabled
>>>>> in host mode. Hash guests also require a lot of hcalls to run. The
>>>>> XICS interrupt controller requires hcalls to run.
>>>>>
>>>>> By contrast, POWER9 has independent thread switching, and in radix mode
>>>>> the hypervisor is already in a host virtual memory mode when the HV
>>>>> interrupt is taken. Radix + xive guests don't need hcalls to handle
>>>>> interrupts or manage translations.
>>
>> Do we need to handle the host-is-a-P9-without-xive case ?
> 
> I'm not sure really. Is there an intention for OPAL to be able to 
> provide a fallback layer in the worst case?

yes. OPAL has a XICS-on-XIVE emulation for P9, implemented for bringup,
and it still boots, XICS guest can run. P10 doesn't have it though.

> Maybe microwatt grows HV capability before XIVE?

I don't know if we should develop the same XIVE logic for microwatt. 
It's awfully complex and we have the XICS interface which works already. 

>>>>> So it's much less important to handle hcalls in real mode in P9.
>>>>
>>>> So acde25726bc6034b (which added if(kvm_is_radix(vcpu->kvm))return 
>>>> H_TOO_HARD) can be reverted, pretty much?
>>>
>>> Yes. Although that calls attention to the fact I missed doing
>>> a P9 h_random handler in this patch. I'll fix that, then I think
>>> acde2572 could be reverted entirely.
>>>
>>> [...]
>>>
>>>>>   	} else {
>>>>>   		kvmppc_xive_push_vcpu(vcpu);
>>>>>   		trap = kvmhv_load_hv_regs_and_go(vcpu, time_limit, lpcr);
>>>>> -		kvmppc_xive_pull_vcpu(vcpu);
>>>>> +		/* H_CEDE has to be handled now, not later */
>>>>> +		/* XICS hcalls must be handled before xive is pulled */
>>>>> +		if (trap == BOOK3S_INTERRUPT_SYSCALL &&
>>>>> +		    !(vcpu->arch.shregs.msr & MSR_PR)) {
>>>>> +			unsigned long req = kvmppc_get_gpr(vcpu, 3);
>>>>>   
>>>>> +			if (req == H_CEDE) {
>>>>> +				kvmppc_cede(vcpu);
>>>>> +				kvmppc_xive_cede_vcpu(vcpu); /* may un-cede */
>>>>> +				kvmppc_set_gpr(vcpu, 3, 0);
>>>>> +				trap = 0;
>>>>> +			}
>>>>> +			if (req == H_EOI || req == H_CPPR ||
>>>>
>>>> else if (req == H_EOI ... ?
>>>
>>> Hummm, sure.
>>
>> you could integrate the H_CEDE in the switch statement below.
> 
> Below is in a different file just for the emulation calls.
> 
>>>
>>> [...]
>>>
>>>>> +void kvmppc_xive_cede_vcpu(struct kvm_vcpu *vcpu)
>>>>> +{
>>>>> +	void __iomem *esc_vaddr = (void __iomem *)vcpu->arch.xive_esc_vaddr;
>>>>> +
>>>>> +	if (!esc_vaddr)
>>>>> +		return;
>>>>> +
>>>>> +	/* we are using XIVE with single escalation */
>>>>> +
>>>>> +	if (vcpu->arch.xive_esc_on) {
>>>>> +		/*
>>>>> +		 * If we still have a pending escalation, abort the cede,
>>>>> +		 * and we must set PQ to 10 rather than 00 so that we don't
>>>>> +		 * potentially end up with two entries for the escalation
>>>>> +		 * interrupt in the XIVE interrupt queue.  In that case
>>>>> +		 * we also don't want to set xive_esc_on to 1 here in
>>>>> +		 * case we race with xive_esc_irq().
>>>>> +		 */
>>>>> +		vcpu->arch.ceded = 0;
>>>>> +		/*
>>>>> +		 * The escalation interrupts are special as we don't EOI them.
>>>>> +		 * There is no need to use the load-after-store ordering offset
>>>>> +		 * to set PQ to 10 as we won't use StoreEOI.
>>>>> +		 */
>>>>> +		__raw_readq(esc_vaddr + XIVE_ESB_SET_PQ_10);
>>>>> +	} else {
>>>>> +		vcpu->arch.xive_esc_on = true;
>>>>> +		mb();
>>>>> +		__raw_readq(esc_vaddr + XIVE_ESB_SET_PQ_00);
>>>>> +	}
>>>>> +	mb();
>>>>
>>>>
>>>> Uff. Thanks for cut-n-pasting the comments, helped a lot to match this c 
>>>> to that asm!
>>>
>>> Glad it helped.
>>>>> +}
>>
>> I had to do the PowerNV models in QEMU to start understanding that stuff ... 
>>
>>>>> +EXPORT_SYMBOL_GPL(kvmppc_xive_cede_vcpu);
>>>>> +
>>>>>   /*
>>>>>    * This is a simple trigger for a generic XIVE IRQ. This must
>>>>>    * only be called for interrupts that support a trigger page
>>>>> @@ -2106,6 +2140,32 @@ static int kvmppc_xive_create(struct kvm_device *dev, u32 type)
>>>>>   	return 0;
>>>>>   }
>>>>>   
>>>>> +int kvmppc_xive_xics_hcall(struct kvm_vcpu *vcpu, u32 req)
>>>>> +{
>>>>> +	struct kvmppc_vcore *vc = vcpu->arch.vcore;
>>>>
>>>>
>>>> Can a XIVE enabled guest issue these hcalls? Don't we want if 
>>>> (!kvmppc_xics_enabled(vcpu)) and
>>>>   if (xics_on_xive()) here, as kvmppc_rm_h_xirr() have? Some of these 
>>>> hcalls do write to XIVE registers but some seem to change 
>>>> kvmppc_xive_vcpu. Thanks,
>>>
>>> Yes I think you're right, good catch. I'm not completely sure about all 
>>> the xive and xics modes but a guest certainly can make any kind of hcall 
>>> it likes and we have to sanity check it.
>>
>> Yes. 
>>
>>> We want to take the hcall here (in replacement of the real mode hcalls)
>>> with the same condition. So it would be:
>>>
>>>         if (!kvmppc_xics_enabled(vcpu))
>>>                 return H_TOO_HARD;
>>
>> Yes.
>>
>> This test covers the case in which a vCPU does XICS hcalls without QEMU 
>> having connected the vCPU to a XICS ICP. The ICP is the KVM XICS device 
>> on P8 or XICS-on-XIVE on P9. It catches QEMU errors when the interrupt 
>> mode is negotiated, we don't want the OS to do XICS hcalls after having 
>> negotiated the XIVE interrupt mode. 
> 
> Okay.
> 
>> It's different for the XIVE hcalls (when running under XICS) because they 
>> are all handled in QEMU. 
> 
> XIVE guest hcalls running on XICS host?

What I meant is that in anycase, XICS or XIVE host, the XIVE hcalls are 
trapped in KVM but always handled in QEMU. So We don't need to check 
anything in KVM, as QEMU will take care of it. 

( It also make the implementation cleaner since the hcall frontend is in
one place. )

C.

>>>         if (!xics_on_xive())
>>> 		return H_TOO_HARD;
>>
>> I understand that this code is only called on P9 and with translation on.
> 
> Yes.
> 
>> On P9, we could have xics_on_xive() == 0 if XIVE is disabled at compile 
>> time or with "xive=off" at boot time. But guests should be supported. 
>> I don't see a reason to restrict the support even if these scenarios 
>> are rather unusual if not very rare.
>>
>> on P10, it's the same but since we don't have the XICS emulation layer 
>> in OPAL, the host will be pretty useless. We don't care.
>>
>> Since we are trying to handle hcalls, this is L0 and it can not be called 
>> for nested guests, which would be another case of xics_on_xive() == 0. 
>> We don't care either.
> 
> Okay so no xics_on_xive() test. I'll change that.
>
> 
> Thanks,
> Nick
> 

