Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D26120AD3F
	for <lists+kvm-ppc@lfdr.de>; Fri, 26 Jun 2020 09:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgFZHel (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 26 Jun 2020 03:34:41 -0400
Received: from 2.mo5.mail-out.ovh.net ([178.33.109.111]:38863 "EHLO
        2.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgFZHel (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 26 Jun 2020 03:34:41 -0400
X-Greylist: delayed 1037 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jun 2020 03:34:41 EDT
Received: from player756.ha.ovh.net (unknown [10.110.171.212])
        by mo5.mail-out.ovh.net (Postfix) with ESMTP id 79856289EA8
        for <kvm-ppc@vger.kernel.org>; Fri, 26 Jun 2020 09:17:22 +0200 (CEST)
Received: from kaod.org (lfbn-tou-1-921-245.w86-210.abo.wanadoo.fr [86.210.152.245])
        (Authenticated sender: clg@kaod.org)
        by player756.ha.ovh.net (Postfix) with ESMTPSA id 0027712EEB1AF;
        Fri, 26 Jun 2020 07:17:15 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-96R001f0536dcc-a957-40ab-ace5-65216a80c849,
                    4AA08B4753365576F5C892DCFEC488B61DD07F5F) smtp.auth=clg@kaod.org
Subject: Re: [PATCH] powerpc/pseries: Use doorbells even if XIVE is available
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     Anton Blanchard <anton@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
References: <20200624134724.2343007-1-npiggin@gmail.com>
 <87r1u4aqzm.fsf@mpe.ellerman.id.au>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <af42c250-cf4b-0815-c91c-9363445383e7@kaod.org>
Date:   Fri, 26 Jun 2020 09:17:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <87r1u4aqzm.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 11601835593903410150
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrudeltddguddujecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefuvfhfhffkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpeevrogurhhitggpnfgvpgfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhephfffgeelfeejudevuedvvdeigeduteetveffhfffudeggfegleeljeeuieefuedvnecukfhppedtrddtrddtrddtpdekiedrvddutddrudehvddrvdegheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejheeirdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhrtghpthhtohepkhhvmhdqphhptgesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Adding David, 

On 6/25/20 3:11 AM, Michael Ellerman wrote:
> Nicholas Piggin <npiggin@gmail.com> writes:
>> KVM supports msgsndp in guests by trapping and emulating the
>> instruction, so it was decided to always use XIVE for IPIs if it is
>> available. However on PowerVM systems, msgsndp can be used and gives
>> better performance. On large systems, high XIVE interrupt rates can
>> have sub-linear scaling, and using msgsndp can reduce the load on
>> the interrupt controller.
>>
>> So switch to using core local doorbells even if XIVE is available.
>> This reduces performance for KVM guests with an SMT topology by
>> about 50% for ping-pong context switching between SMT vCPUs.
> 
> You have to take explicit steps to configure KVM in that way with qemu.
> eg. "qemu .. -smp 8" will give you 8 SMT1 CPUs by default.
> 
>> An option vector (or dt-cpu-ftrs) could be defined to disable msgsndp
>> to get KVM performance back.

An option vector would require a PAPR change. Unless the architecture 
reserves some bits for the implementation, but I don't think so. Same
for CAS.

> Qemu/KVM populates /proc/device-tree/hypervisor, so we *could* look at
> that. Though adding PowerVM/KVM specific hacks is obviously a very
> slippery slope.

QEMU could advertise a property "emulated-msgsndp", or something similar, 
which would be interpreted by Linux as a CPU feature and taken into account 
when doing the IPIs.

The CPU setup for XIVE needs a cleanup also. There is no need to allocate
interrupts for IPIs anymore in that case.

Thanks,

C. 


> 
>> diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
>> index 6891710833be..a737a2f87c67 100644
>> --- a/arch/powerpc/platforms/pseries/smp.c
>> +++ b/arch/powerpc/platforms/pseries/smp.c
>> @@ -188,13 +188,14 @@ static int pseries_smp_prepare_cpu(int cpu)
>>  	return 0;
>>  }
>>  
>> +static void  (*cause_ipi_offcore)(int cpu) __ro_after_init;
>> +
>>  static void smp_pseries_cause_ipi(int cpu)
> 
> This is static so the name could be more descriptive, it doesn't need
> the "smp_pseries" prefix.
> 
>>  {
>> -	/* POWER9 should not use this handler */
>>  	if (doorbell_try_core_ipi(cpu))
>>  		return;
> 
> Seems like it would be worth making that static inline so we can avoid
> the function call overhead.
> 
>> -	icp_ops->cause_ipi(cpu);
>> +	cause_ipi_offcore(cpu);
>>  }
>>  
>>  static int pseries_cause_nmi_ipi(int cpu)
>> @@ -222,10 +223,7 @@ static __init void pSeries_smp_probe_xics(void)
>>  {
>>  	xics_smp_probe();
>>  
>> -	if (cpu_has_feature(CPU_FTR_DBELL) && !is_secure_guest())
>> -		smp_ops->cause_ipi = smp_pseries_cause_ipi;
>> -	else
>> -		smp_ops->cause_ipi = icp_ops->cause_ipi;
>> +	smp_ops->cause_ipi = icp_ops->cause_ipi;
>>  }
>>  
>>  static __init void pSeries_smp_probe(void)
>> @@ -238,6 +236,18 @@ static __init void pSeries_smp_probe(void)
> 
> The comment just above here says:
> 
> 		/*
> 		 * Don't use P9 doorbells when XIVE is enabled. IPIs
> 		 * using MMIOs should be faster
> 		 */
>>  		xive_smp_probe();
> 
> Which is no longer true.
> 
>>  	else
>>  		pSeries_smp_probe_xics();
> 
> I think you should just fold this in, it would make the logic slightly
> easier to follow.
> 
>> +	/*
>> +	 * KVM emulates doorbells by reading the instruction, which
>> +	 * can't be done if the guest is secure. If a secure guest
>> +	 * runs under PowerVM, it could use msgsndp but would need a
>> +	 * way to distinguish.
>> +	 */
> 
> It's not clear what it needs to distinguish: That it's running under
> PowerVM and therefore *can* use msgsndp even though it's secure.
> 
> Also the comment just talks about the is_secure_guest() test, which is
> not obvious on first reading.
> 
>> +	if (cpu_has_feature(CPU_FTR_DBELL) &&
>> +	    cpu_has_feature(CPU_FTR_SMT) && !is_secure_guest()) {
>> +		cause_ipi_offcore = smp_ops->cause_ipi;
>> +		smp_ops->cause_ipi = smp_pseries_cause_ipi;
>> +	}
> 
> Because we're at the tail of the function I think this would be clearer
> if it used early returns, eg:
> 
> 	// If the CPU doesn't have doorbells then we must use xics/xive
> 	if (!cpu_has_feature(CPU_FTR_DBELL))
>         	return;
> 
> 	// If the CPU doesn't have SMT then doorbells don't help us
> 	if (!cpu_has_feature(CPU_FTR_SMT))
>         	return;
> 
> 	// Secure guests can't use doorbells because ...
> 	if (!is_secure_guest()
>         	return;
> 
> 	/*
>          * Otherwise we want to use doorbells for sibling threads and
>          * xics/xive for IPIs off the core, because it performs better
>          * on large systems ...
>          */
>         cause_ipi_offcore = smp_ops->cause_ipi;
> 	smp_ops->cause_ipi = smp_pseries_cause_ipi;
> }
> 
> 
> cheers
> 

