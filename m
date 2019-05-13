Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7C71BD1F
	for <lists+kvm-ppc@lfdr.de>; Mon, 13 May 2019 20:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfEMSW3 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 13 May 2019 14:22:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57254 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726370AbfEMSW3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 13 May 2019 14:22:29 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4DI84SJ086053;
        Mon, 13 May 2019 14:22:20 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sfbwd4rv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 May 2019 14:22:20 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x4DC8uPC023789;
        Mon, 13 May 2019 12:26:39 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 2sdp14g5kv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 May 2019 12:26:39 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4DIMFfP12321182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 18:22:15 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D312C6059;
        Mon, 13 May 2019 18:22:15 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D908AC6063;
        Mon, 13 May 2019 18:22:14 +0000 (GMT)
Received: from localhost (unknown [9.85.195.195])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Mon, 13 May 2019 18:22:14 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org
Subject: Re: KVM: Book3S PR: unbreaking software breakpoints
In-Reply-To: <6911b0f0-76d4-4f19-0205-d6bf70b30586@ilande.co.uk>
References: <e84fd80c-d6a6-8f19-a4e1-ed309fa68aa9@ilande.co.uk> <55e6cabb-bf11-13ae-d499-d9f636a9a096@ozlabs.ru> <6911b0f0-76d4-4f19-0205-d6bf70b30586@ilande.co.uk>
Date:   Mon, 13 May 2019 15:22:11 -0300
Message-ID: <87woiu1agc.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-13_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=44 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905130124
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk> writes:

> On 13/05/2019 07:01, Alexey Kardashevskiy wrote:
>
>> On 12/05/2019 00:08, Mark Cave-Ayland wrote:
>>> Hi all,
>>>
>>> Whilst trying to investigate some issues with MacOS under KVM PR I noticed that when
>>> setting software breakpoints the KVM VCPU would stop as requested, but QEMU's gdbstub
>>> would hang indefinitely.
>> 
>> What are you trying to do exactly? Just breakpoints or single stepping?
>> Anyway, I am cc-ing Fabiano who is fixing single stepping and knows this
>> code well.
>
> I'm currently investigating why MacOS 9 fails to start up on KVM using a G4 Mac Mini,
> and my starting point is to do a side-by-side comparison with TCG which can boot MacOS 9.
>
> I discovered this issue setting a software breakpoint using QEMU's gdbstub and
> finding that whilst execution of the vCPU paused as expected, QEMU would hang because
> with run->debug.arch.status != 0 the gdbstub tries to handle it as a hardware
> breakpoint instead of a software breakpoint causing confusion.
>
> I've also tried using single-stepping which mostly works, however during OS startup
> as soon as I step over a mtsrr1 instruction, I lose the single-stepping and vCPU runs
> as normal. My suspicion here is that something in the emulation code is losing the
> MSR_SE bit, but I need to dig a bit deeper here.

I would expect that a mtsrr1 followed by rfid would cause this sort of
behavior since MSR_SE is set/cleared at each guest entry/exit
(kvmppc_setup_debug and kvmppc_clear_debug functions) and whatever was
copied into SRR1 might not have MSR_SE set.

>>> I eventually traced it down to this code in QEMU's target/ppc/kvm.c:
>>>
>>>
>>> static int kvm_handle_debug(PowerPCCPU *cpu, struct kvm_run *run)
>>> {
>>>     CPUState *cs = CPU(cpu);
>>>     CPUPPCState *env = &cpu->env;
>>>     struct kvm_debug_exit_arch *arch_info = &run->debug.arch;
>>>
>>>     if (cs->singlestep_enabled) {
>>>         return kvm_handle_singlestep();
>>>     }
>>>
>>>     if (arch_info->status) {
>>>         return kvm_handle_hw_breakpoint(cs, arch_info);
>>>     }
>>>
>>>     if (kvm_find_sw_breakpoint(cs, arch_info->address)) {
>>>         return kvm_handle_sw_breakpoint();
>>>     }
>>>
>>>
>>> The problem here is that with Book3S PR on my Mac hardware, run->debug.arch.status !=
>>> 0 which causes QEMU to think that this is a hardware breakpoint and so the software
>>> breakpoint doesn't get handled correctly.
>>>
>>> For comparison both booke.c and e500_emulate.c set debug.arch.status = 0 for software
>>> breakpoints, whereas both book3s_hv.c and book3s_pr.c do not. Given that emulate.c
>>> contains shared code for handling software breakpoints, would the following simple
>>> patch suffice?
>>>
>>>
>>> diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
>>> index 9f5b8c01c4e1..e77becaad5dd 100644
>>> --- a/arch/powerpc/kvm/emulate.c
>>> +++ b/arch/powerpc/kvm/emulate.c
>>> @@ -282,6 +282,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct
>>> kvm_vcpu *vcpu)
>>>                  */
>>>                 if (inst == KVMPPC_INST_SW_BREAKPOINT) {
>>>                         run->exit_reason = KVM_EXIT_DEBUG;
>>> +                       run->debug.arch.status = 0;
>>>                         run->debug.arch.address = kvmppc_get_pc(vcpu);
>>>                         emulated = EMULATE_EXIT_USER;
>>>                         advance = 0;
>
>
> ATB,
>
> Mark.
