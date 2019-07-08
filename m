Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70F3C62A9C
	for <lists+kvm-ppc@lfdr.de>; Mon,  8 Jul 2019 22:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405059AbfGHUwy (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 8 Jul 2019 16:52:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31642 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732038AbfGHUwy (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 8 Jul 2019 16:52:54 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x68Kq2KE113505
        for <kvm-ppc@vger.kernel.org>; Mon, 8 Jul 2019 16:52:53 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tmbtrtka7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Mon, 08 Jul 2019 16:52:52 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <cclaudio@linux.ibm.com>;
        Mon, 8 Jul 2019 21:52:52 +0100
Received: from b03cxnp07029.gho.boulder.ibm.com (9.17.130.16)
        by e35.co.us.ibm.com (192.168.1.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 8 Jul 2019 21:52:50 +0100
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x68KqmIC62194022
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jul 2019 20:52:48 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E5E1C605F;
        Mon,  8 Jul 2019 20:52:48 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F3E0C6055;
        Mon,  8 Jul 2019 20:52:45 +0000 (GMT)
Received: from [9.80.216.78] (unknown [9.80.216.78])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  8 Jul 2019 20:52:45 +0000 (GMT)
Subject: Re: [PATCH v4 7/8] KVM: PPC: Ultravisor: Enter a secure guest
To:     janani@linux.ibm.com
Cc:     Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>, kvm-ppc@vger.kernel.org,
        Bharata B Rao <bharata@linux.ibm.com>,
        linuxppc-dev@ozlabs.org, Ryan Grimm <grimm@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com>
 <20190628200825.31049-8-cclaudio@linux.ibm.com>
 <fa038e6849738d21707bde46616d84ff@linux.vnet.ibm.com>
From:   Claudio Carvalho <cclaudio@linux.ibm.com>
Date:   Mon, 8 Jul 2019 17:52:44 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <fa038e6849738d21707bde46616d84ff@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19070820-0012-0000-0000-0000174D9E10
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011397; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01229367; UDB=6.00647446; IPR=6.01010626;
 MB=3.00027640; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-08 20:52:51
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070820-0013-0000-0000-000057FD42BE
Message-Id: <97525c73-841b-8399-cfdb-8d4b0f115d8b@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-08_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907080261
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


On 7/8/19 5:53 PM, janani wrote:
> On 2019-06-28 15:08, Claudio Carvalho wrote:
>> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
>>
>> To enter a secure guest, we have to go through the ultravisor, therefore
>> we do a ucall when we are entering a secure guest.
>>
>> This change is needed for any sort of entry to the secure guest from the
>> hypervisor, whether it is a return from an hcall, a return from a
>> hypervisor interrupt, or the first time that a secure guest vCPU is run.
>>
>> If we are returning from an hcall, the results are already in the
>> appropriate registers R3:12, except for R3, R6 and R7. R3 has the status
>> of the reflected hcall, therefore we move it to R0 for the ultravisor and
>> set R3 to the UV_RETURN ucall number. R6,7 were used as temporary
>> registers, hence we restore them.
>>
>> Have fast_guest_return check the kvm_arch.secure_guest field so that a
>> new CPU enters UV when started (in response to a RTAS start-cpu call).
>>
>> Thanks to input from Paul Mackerras, Ram Pai and Mike Anderson.
>>
>> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
>> [ Pass SRR1 in r11 for UV_RETURN, fix kvmppc_msr_interrupt to preserve
>>   the MSR_S bit ]
>> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
>> [ Fix UV_RETURN ucall number and arch.secure_guest check ]
>> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
>> [ Save the actual R3 in R0 for the ultravisor and use R3 for the
>>   UV_RETURN ucall number. Update commit message and ret_to_ultra comment ]
>> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
>  Reviewed-by: Janani Janakiraman <janani@linux.ibm.com>


Thanks Janani for reviewing the patchset.

Claudio


>> ---
>>  arch/powerpc/include/asm/kvm_host.h       |  1 +
>>  arch/powerpc/include/asm/ultravisor-api.h |  1 +
>>  arch/powerpc/kernel/asm-offsets.c         |  1 +
>>  arch/powerpc/kvm/book3s_hv_rmhandlers.S   | 40 +++++++++++++++++++----
>>  4 files changed, 37 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/powerpc/include/asm/kvm_host.h
>> b/arch/powerpc/include/asm/kvm_host.h
>> index 013c76a0a03e..184becb62ea4 100644
>> --- a/arch/powerpc/include/asm/kvm_host.h
>> +++ b/arch/powerpc/include/asm/kvm_host.h
>> @@ -294,6 +294,7 @@ struct kvm_arch {
>>      cpumask_t cpu_in_guest;
>>      u8 radix;
>>      u8 fwnmi_enabled;
>> +    u8 secure_guest;
>>      bool threads_indep;
>>      bool nested_enable;
>>      pgd_t *pgtable;
>> diff --git a/arch/powerpc/include/asm/ultravisor-api.h
>> b/arch/powerpc/include/asm/ultravisor-api.h
>> index 141940771add..7c4d0b4ced12 100644
>> --- a/arch/powerpc/include/asm/ultravisor-api.h
>> +++ b/arch/powerpc/include/asm/ultravisor-api.h
>> @@ -19,5 +19,6 @@
>>
>>  /* opcodes */
>>  #define UV_WRITE_PATE            0xF104
>> +#define UV_RETURN            0xF11C
>>
>>  #endif /* _ASM_POWERPC_ULTRAVISOR_API_H */
>> diff --git a/arch/powerpc/kernel/asm-offsets.c
>> b/arch/powerpc/kernel/asm-offsets.c
>> index 8e02444e9d3d..44742724513e 100644
>> --- a/arch/powerpc/kernel/asm-offsets.c
>> +++ b/arch/powerpc/kernel/asm-offsets.c
>> @@ -508,6 +508,7 @@ int main(void)
>>      OFFSET(KVM_VRMA_SLB_V, kvm, arch.vrma_slb_v);
>>      OFFSET(KVM_RADIX, kvm, arch.radix);
>>      OFFSET(KVM_FWNMI, kvm, arch.fwnmi_enabled);
>> +    OFFSET(KVM_SECURE_GUEST, kvm, arch.secure_guest);
>>      OFFSET(VCPU_DSISR, kvm_vcpu, arch.shregs.dsisr);
>>      OFFSET(VCPU_DAR, kvm_vcpu, arch.shregs.dar);
>>      OFFSET(VCPU_VPA, kvm_vcpu, arch.vpa.pinned_addr);
>> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>> b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>> index cffb365d9d02..89813ca987c2 100644
>> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>> @@ -36,6 +36,7 @@
>>  #include <asm/asm-compat.h>
>>  #include <asm/feature-fixups.h>
>>  #include <asm/cpuidle.h>
>> +#include <asm/ultravisor-api.h>
>>
>>  /* Sign-extend HDEC if not on POWER9 */
>>  #define EXTEND_HDEC(reg)            \
>> @@ -1092,16 +1093,12 @@ BEGIN_FTR_SECTION
>>  END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
>>
>>      ld    r5, VCPU_LR(r4)
>> -    ld    r6, VCPU_CR(r4)
>>      mtlr    r5
>> -    mtcr    r6
>>
>>      ld    r1, VCPU_GPR(R1)(r4)
>>      ld    r2, VCPU_GPR(R2)(r4)
>>      ld    r3, VCPU_GPR(R3)(r4)
>>      ld    r5, VCPU_GPR(R5)(r4)
>> -    ld    r6, VCPU_GPR(R6)(r4)
>> -    ld    r7, VCPU_GPR(R7)(r4)
>>      ld    r8, VCPU_GPR(R8)(r4)
>>      ld    r9, VCPU_GPR(R9)(r4)
>>      ld    r10, VCPU_GPR(R10)(r4)
>> @@ -1119,10 +1116,38 @@ BEGIN_FTR_SECTION
>>      mtspr    SPRN_HDSISR, r0
>>  END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
>>
>> +    ld    r6, VCPU_KVM(r4)
>> +    lbz    r7, KVM_SECURE_GUEST(r6)
>> +    cmpdi    r7, 0
>> +    bne    ret_to_ultra
>> +
>> +    lwz    r6, VCPU_CR(r4)
>> +    mtcr    r6
>> +
>> +    ld    r7, VCPU_GPR(R7)(r4)
>> +    ld    r6, VCPU_GPR(R6)(r4)
>>      ld    r0, VCPU_GPR(R0)(r4)
>>      ld    r4, VCPU_GPR(R4)(r4)
>>      HRFI_TO_GUEST
>>      b    .
>> +/*
>> + * We are entering a secure guest, so we have to invoke the ultravisor
>> to do
>> + * that. If we are returning from a hcall, the results are already in the
>> + * appropriate registers R3:12, except for R3, R6 and R7. R3 has the
>> status of
>> + * the reflected hcall, therefore we move it to R0 for the ultravisor
>> and set
>> + * R3 to the UV_RETURN ucall number. R6,7 were used as temporary registers
>> + * above, hence we restore them.
>> + */
>> +ret_to_ultra:
>> +    lwz    r6, VCPU_CR(r4)
>> +    mtcr    r6
>> +    mfspr    r11, SPRN_SRR1
>> +    mr    r0, r3
>> +    LOAD_REG_IMMEDIATE(r3, UV_RETURN)
>> +    ld    r7, VCPU_GPR(R7)(r4)
>> +    ld    r6, VCPU_GPR(R6)(r4)
>> +    ld    r4, VCPU_GPR(R4)(r4)
>> +    sc    2
>>
>>  /*
>>   * Enter the guest on a P9 or later system where we have exactly
>> @@ -3318,13 +3343,16 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_TYPE_RADIX)
>>   *   r0 is used as a scratch register
>>   */
>>  kvmppc_msr_interrupt:
>> +    andis.    r0, r11, MSR_S@h
>>      rldicl    r0, r11, 64 - MSR_TS_S_LG, 62
>> -    cmpwi    r0, 2 /* Check if we are in transactional state..  */
>> +    cmpwi    cr1, r0, 2 /* Check if we are in transactional state..  */
>>      ld    r11, VCPU_INTR_MSR(r9)
>> -    bne    1f
>> +    bne    cr1, 1f
>>      /* ... if transactional, change to suspended */
>>      li    r0, 1
>>  1:    rldimi    r11, r0, MSR_TS_S_LG, 63 - MSR_TS_T_LG
>> +    beqlr
>> +    oris    r11, r11, MSR_S@h        /* preserve MSR_S bit setting */
>>      blr
>>
>>  /*
>

