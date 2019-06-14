Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A84B46C3D
	for <lists+kvm-ppc@lfdr.de>; Sat, 15 Jun 2019 00:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbfFNWOp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 14 Jun 2019 18:14:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36826 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725809AbfFNWOp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 14 Jun 2019 18:14:45 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5EMBdAq008779;
        Fri, 14 Jun 2019 18:14:36 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t4g9hsy5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jun 2019 18:14:35 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x5ELJEKf029107;
        Fri, 14 Jun 2019 21:23:05 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01dal.us.ibm.com with ESMTP id 2t1x6t7981-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jun 2019 21:23:05 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5EMEYwm37224856
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jun 2019 22:14:34 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4164E112074;
        Fri, 14 Jun 2019 22:14:34 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F24F112075;
        Fri, 14 Jun 2019 22:14:33 +0000 (GMT)
Received: from localhost (unknown [9.85.186.160])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTPS;
        Fri, 14 Jun 2019 22:14:32 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        kvm-ppc@vger.kernel.org, paulus@ozlabs.org
Subject: Re: [PATCH] KVM: PPC: Book3S PR: fix software breakpoints
In-Reply-To: <20190614185745.6863-1-mark.cave-ayland@ilande.co.uk>
References: <20190614185745.6863-1-mark.cave-ayland@ilande.co.uk>
Date:   Fri, 14 Jun 2019 19:14:31 -0300
Message-ID: <871rzv4xx4.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-14_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=635 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906140174
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk> writes:

> QEMU's kvm_handle_debug() function identifies software breakpoints by checking
> for a value of 0 in kvm_debug_exit_arch's status field. Since this field isn't

LGTM, but let me start a discussion:

In arch/powerpc/include/uapi/asm/kvm.h I see the following:


/*
 * Defines for h/w breakpoint, watchpoint (read, write or both) and
 * software breakpoint.
 * These are used as "type" in KVM_SET_GUEST_DEBUG ioctl and "status"
 * for KVM_DEBUG_EXIT.
 */
#define KVMPPC_DEBUG_NONE		0x0
#define KVMPPC_DEBUG_BREAKPOINT		(1UL << 1)
#define KVMPPC_DEBUG_WATCH_WRITE	(1UL << 2)
#define KVMPPC_DEBUG_WATCH_READ		(1UL << 3)


this seems to be biased towards the BookE implementation which uses
KVMPPC_DEBUG_BREAKPOINT to indicate a "hardware breakpoint" (i.e. Instruction
Address Compare - ISA v2 Book III-E, section 10.4.1), and then
KVMPPC_DEBUG_NONE ends up implicitly meaning "software breakpoint" for
Book3s PR/HV.

> explicitly set to 0 when the software breakpoint instruction is detected, any
> previous non-zero value present causes a hang in QEMU as it tries to process
> the breakpoint instruction incorrectly as a hardware breakpoint.

What QEMU does (again biased towards BookE) is to check the 'status'
field and treat both h/w breakpoints and watchpoints as hardware
breakpoints (which is correct in a sense) and then proceed to look for
s/w breakpoints:

    if (arch_info->status) {
        return kvm_handle_hw_breakpoint(cs, arch_info);
    }

    if (kvm_find_sw_breakpoint(cs, arch_info->address)) {
        return kvm_handle_sw_breakpoint(cs, arch_info->address);
    }

So I wonder if it would not be beneficial for future developers if we
drew the line and made a clear distinction between:

 software breakpoints - triggered by a KVMPPC_INST_SW_BREAKPOINT execution
 hardware breakpoints - triggered by some register match

Maybe by turning the first two defines into:

#define KVMPPC_DEBUG_SW_BREAKPOINT 0x0
#define KVMPPC_DEBUG_HW_BREAKPOINT (1UL << 1)

> Ensure that the kvm_debug_exit_arch status field is set to 0 when the software
> breakpoint instruction is detected (similar to the existing logic in booke.c
> and e500_emulate.c) to restore software breakpoint functionality under Book3S
> PR.
>
> Signed-off-by: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
> ---

Anyway, the proposed patch fixes the issue.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>

>  arch/powerpc/kvm/emulate.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
> index bb4d09c1ad56..6fca38ca791f 100644
> --- a/arch/powerpc/kvm/emulate.c
> +++ b/arch/powerpc/kvm/emulate.c
> @@ -271,6 +271,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
>  		 */
>  		if (inst == KVMPPC_INST_SW_BREAKPOINT) {
>  			run->exit_reason = KVM_EXIT_DEBUG;
> +			run->debug.arch.status = 0;
>  			run->debug.arch.address = kvmppc_get_pc(vcpu);
>  			emulated = EMULATE_EXIT_USER;
>  			advance = 0;
