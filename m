Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5563C5DF5
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Jul 2021 16:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbhGLOKc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 12 Jul 2021 10:10:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49056 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229644AbhGLOKb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 12 Jul 2021 10:10:31 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16CE3iU0144002;
        Mon, 12 Jul 2021 10:07:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=pp1;
 bh=dRntATiYhXnEaLdwzmewjaMPOlMt18rJpskriL5gN98=;
 b=DSjtaMi/ZHNdB9J37yNo2gEKSfwAYLKatwd0mi+sHyUOy6uRtU2kEe7hu6ORlnOXTPzP
 G2zXIyBejCs3L7ppkGN2fq49WGsPKRgBo4EkdEJq4YL5SxIJqPQVL+pRIJIa2BUQMOSV
 KXC9ZqsfN+ihkdXCLpbI3p990P+DDdPuw6oUpCR4+vQywbm/lkiCbLK9PcuEMvTF5RWc
 tlGnY898aMwiQdDysEgtM4XFIIjPmN+euO6kG5iyhxqbeg/cQSzJrhTSfRQJtUqbxzda
 c/VMYocGOgg5iXaDeU7w9qK/sMqsMhJjd6FFGu2JXgWKPKdgs712KWCULzo/u5xU7Lom Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39qs10k4ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Jul 2021 10:07:38 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16CE4VBE150957;
        Mon, 12 Jul 2021 10:07:37 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39qs10k4sm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Jul 2021 10:07:37 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16CE204h019290;
        Mon, 12 Jul 2021 14:07:36 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 39q3688tpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Jul 2021 14:07:36 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16CE7Xim33685972
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Jul 2021 14:07:33 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8289A52050;
        Mon, 12 Jul 2021 14:07:33 +0000 (GMT)
Received: from [9.195.45.30] (unknown [9.195.45.30])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 8C48B52051;
        Mon, 12 Jul 2021 14:07:32 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.6\))
Subject: Re: [RFC PATCH 11/43] KVM: PPC: Book3S HV P9: Implement PMU
 save/restore in C
From:   Athira Rajeev <atrajeev@linux.vnet.ibm.com>
In-Reply-To: <1626057686.aeolnlaqjr.astroid@bobo.none>
Date:   Mon, 12 Jul 2021 19:37:29 +0530
Cc:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        kvm-ppc@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E89DCB35-8672-4BD2-B1F9-36BE0F0B95AD@linux.vnet.ibm.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
 <20210622105736.633352-12-npiggin@gmail.com>
 <A647F37A-F32C-46B7-8A2E-C4D7CDB012E3@linux.vnet.ibm.com>
 <1626057686.aeolnlaqjr.astroid@bobo.none>
To:     Nicholas Piggin <npiggin@gmail.com>
X-Mailer: Apple Mail (2.3608.120.23.2.6)
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: krs-l5-ZG5cO5HVUS4_UoOq4ld0r12Jo
X-Proofpoint-ORIG-GUID: peF15S2ncmaJ0SAYoflxaFNS9-FTSDkH
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-12_08:2021-07-12,2021-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107120111
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



> On 12-Jul-2021, at 8:19 AM, Nicholas Piggin <npiggin@gmail.com> wrote:
>=20
> Excerpts from Athira Rajeev's message of July 10, 2021 12:47 pm:
>>=20
>>=20
>>> On 22-Jun-2021, at 4:27 PM, Nicholas Piggin <npiggin@gmail.com> =
wrote:
>>>=20
>>> Implement the P9 path PMU save/restore code in C, and remove the
>>> POWER9/10 code from the P7/8 path assembly.
>>>=20
>>> -449 cycles (8533) POWER9 virt-mode NULL hcall
>>>=20
>>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>>> ---
>>> arch/powerpc/include/asm/asm-prototypes.h |   5 -
>>> arch/powerpc/kvm/book3s_hv.c              | 205 =
++++++++++++++++++++--
>>> arch/powerpc/kvm/book3s_hv_interrupts.S   |  13 +-
>>> arch/powerpc/kvm/book3s_hv_rmhandlers.S   |  43 +----
>>> 4 files changed, 200 insertions(+), 66 deletions(-)
>>>=20
>>> diff --git a/arch/powerpc/include/asm/asm-prototypes.h =
b/arch/powerpc/include/asm/asm-prototypes.h
>>> index 02ee6f5ac9fe..928db8ef9a5a 100644
>>> --- a/arch/powerpc/include/asm/asm-prototypes.h
>>> +++ b/arch/powerpc/include/asm/asm-prototypes.h
>>> @@ -136,11 +136,6 @@ static inline void kvmppc_restore_tm_hv(struct =
kvm_vcpu *vcpu, u64 msr,
>>> 					bool preserve_nv) { }
>>> #endif /* CONFIG_PPC_TRANSACTIONAL_MEM */
>>>=20
>>> -void kvmhv_save_host_pmu(void);
>>> -void kvmhv_load_host_pmu(void);
>>> -void kvmhv_save_guest_pmu(struct kvm_vcpu *vcpu, bool pmu_in_use);
>>> -void kvmhv_load_guest_pmu(struct kvm_vcpu *vcpu);
>>> -
>>> void kvmppc_p9_enter_guest(struct kvm_vcpu *vcpu);
>>>=20
>>> long kvmppc_h_set_dabr(struct kvm_vcpu *vcpu, unsigned long dabr);
>>> diff --git a/arch/powerpc/kvm/book3s_hv.c =
b/arch/powerpc/kvm/book3s_hv.c
>>> index f7349d150828..b1b94b3563b7 100644
>>> --- a/arch/powerpc/kvm/book3s_hv.c
>>> +++ b/arch/powerpc/kvm/book3s_hv.c
>>> @@ -3635,6 +3635,188 @@ static noinline void kvmppc_run_core(struct =
kvmppc_vcore *vc)
>>> 	trace_kvmppc_run_core(vc, 1);
>>> }
>>>=20
>>> +/*
>>> + * Privileged (non-hypervisor) host registers to save.
>>> + */
>>> +struct p9_host_os_sprs {
>>> +	unsigned long dscr;
>>> +	unsigned long tidr;
>>> +	unsigned long iamr;
>>> +	unsigned long amr;
>>> +	unsigned long fscr;
>>> +
>>> +	unsigned int pmc1;
>>> +	unsigned int pmc2;
>>> +	unsigned int pmc3;
>>> +	unsigned int pmc4;
>>> +	unsigned int pmc5;
>>> +	unsigned int pmc6;
>>> +	unsigned long mmcr0;
>>> +	unsigned long mmcr1;
>>> +	unsigned long mmcr2;
>>> +	unsigned long mmcr3;
>>> +	unsigned long mmcra;
>>> +	unsigned long siar;
>>> +	unsigned long sier1;
>>> +	unsigned long sier2;
>>> +	unsigned long sier3;
>>> +	unsigned long sdar;
>>> +};
>>> +
>>> +static void freeze_pmu(unsigned long mmcr0, unsigned long mmcra)
>>> +{
>>> +	if (!(mmcr0 & MMCR0_FC))
>>> +		goto do_freeze;
>>> +	if (mmcra & MMCRA_SAMPLE_ENABLE)
>>> +		goto do_freeze;
>>> +	if (cpu_has_feature(CPU_FTR_ARCH_31)) {
>>> +		if (!(mmcr0 & MMCR0_PMCCEXT))
>>> +			goto do_freeze;
>>> +		if (!(mmcra & MMCRA_BHRB_DISABLE))
>>> +			goto do_freeze;
>>> +	}
>>> +	return;
>>=20
>>=20
>> Hi Nick
>>=20
>> When freezing the PMU, do we need to also set pmcregs_in_use to zero =
?
>=20
> Not immediately, we still need to save out the values of the PMU=20
> registers. If we clear pmcregs_in_use, then our hypervisor can discard=20=

> the contents of those registers at any time.
>=20
>> Also, why we need these above conditions like MMCRA_SAMPLE_ENABLE,  =
MMCR0_PMCCEXT checks also before freezing ?
>=20
> Basically just because that's the condition we wnat to set the PMU to=20=

> before entering the guest if the guest does not have its own PMU=20
> registers in use.
>=20
> I'm not entirely sure this is correct / optimal for perf though, so we
> should double check that. I think some of this stuff should be wrapped=20=

> up and put into perf/ subdirectory as I've said before. KVM shouldn't=20=

> need to know about exactly how PMU is to be set up and managed by
> perf, we should just be able to ask perf to save/restore/switch state.

Hi Nick,

Agree to your point. It makes sense that some of these perf code should =
be moved under perf/ directory.

Athira
>=20
> Thanks,
> Nick

