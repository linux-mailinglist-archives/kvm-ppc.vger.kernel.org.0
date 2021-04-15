Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66F53615D8
	for <lists+kvm-ppc@lfdr.de>; Fri, 16 Apr 2021 01:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbhDOXKi (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 15 Apr 2021 19:10:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20280 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236351AbhDOXKe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 15 Apr 2021 19:10:34 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13FN3tOb112873;
        Thu, 15 Apr 2021 19:10:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wkgpCgw9r5JacrDF539TwlrUElD6UMurSaMCEc08CAY=;
 b=LuyppWQD68a3x5dlLS70RJaR3BuoiNns0vnTPoZsIJ7ecuhEL/LG3puTgLzYHbIZWTN/
 GiBGtG7RgQn3Uz7OPNDlNb8flMXf3mu799lr1QUNn9M3stUS4Mn83WVKWqL73lM2hyiA
 4QWoeTdQPsBvx5EOIbNZyqu+Qd3OwvP/Q8hQzB7EDKYhXiSXCfOXORx00+UrWXr1yRVI
 mvjnc4ak84qjmWIGUVx65t6KlYAiEtXKs5ZHa475R1horErc4fTsNoacYlNq0xVfMQRT
 SAwpvH6KmvlDNrnfofFqYePxiocxUF2qjzml4Q2SCFneksZ37OkWvee9YcYVzsNeb33L IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37xtq9p8v6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 19:10:03 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13FN8asr131002;
        Thu, 15 Apr 2021 19:10:02 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37xtq9p8uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 19:10:02 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13FN79vm006236;
        Thu, 15 Apr 2021 23:10:02 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01wdc.us.ibm.com with ESMTP id 37u3n9w6ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 23:10:02 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13FNA14J30736736
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 23:10:01 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C4F411206E;
        Thu, 15 Apr 2021 23:10:01 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A839112063;
        Thu, 15 Apr 2021 23:09:59 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.211.84.45])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 15 Apr 2021 23:09:59 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com
Subject: [PATCH v3 2/2] KVM: PPC: Book3S HV: Stop forwarding all HFSCR cause bits to L1
Date:   Thu, 15 Apr 2021 20:09:48 -0300
Message-Id: <20210415230948.3563415-3-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210415230948.3563415-1-farosas@linux.ibm.com>
References: <20210415230948.3563415-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hFyaHsjNUp8Nxs_DPmBrZf17ocvkgU-M
X-Proofpoint-ORIG-GUID: v2SqktxZPeX_4ruGhls6sJuwX0sP6b8q
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-15_10:2021-04-15,2021-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 bulkscore=0
 adultscore=0 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104150142
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Since commit 73937deb4b2d ("KVM: PPC: Book3S HV: Sanitise hv_regs on
nested guest entry") we have been disabling for the nested guest the
hypervisor facility bits that its nested hypervisor don't have access
to.

If the nested guest tries to use one of those facilities, the hardware
will cause a Hypervisor Facility Unavailable interrupt. The HFSCR
register is modified by the hardware to contain information about the
cause of the interrupt.

We have been returning the cause bits to the nested hypervisor but
since commit 549e29b458c5 ("KVM: PPC: Book3S HV: Sanitise vcpu
registers in nested path") we are reducing the amount of information
exposed to L1, so it seems like a good idea to restrict some of the
cause bits as well.

With this patch the L1 guest will be allowed to handle only the
interrupts caused by facilities it has disabled for L2. The interrupts
caused by facilities that L0 denied will cause a Program Interrupt in
L1.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv_nested.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 270552dd42c5..912a2bcdf7b0 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -138,6 +138,23 @@ static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
 	case BOOK3S_INTERRUPT_H_EMUL_ASSIST:
 		hr->heir = vcpu->arch.emul_inst;
 		break;
+	case BOOK3S_INTERRUPT_H_FAC_UNAVAIL:
+	{
+		u8 cause = vcpu->arch.hfscr >> 56;
+
+		WARN_ON_ONCE(cause >= BITS_PER_LONG);
+
+		if (hr->hfscr & (1UL << cause)) {
+			hr->hfscr &= ~HFSCR_INTR_CAUSE;
+			/*
+			 * We have not restored L1 state yet, so queue
+			 * this interrupt instead of delivering it
+			 * immediately.
+			 */
+			kvmppc_book3s_queue_irqprio(vcpu, BOOK3S_INTERRUPT_PROGRAM);
+		}
+		break;
+	}
 	}
 }
 
-- 
2.29.2

