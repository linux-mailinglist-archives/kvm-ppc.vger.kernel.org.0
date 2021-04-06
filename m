Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D244D355E21
	for <lists+kvm-ppc@lfdr.de>; Tue,  6 Apr 2021 23:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242947AbhDFVrM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 6 Apr 2021 17:47:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1896 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242246AbhDFVrL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 6 Apr 2021 17:47:11 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 136LWfxM106686;
        Tue, 6 Apr 2021 17:46:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=mGktAcrLcOpEP+nsaANmuUZjME08s/ZgNGfFlHOKbb4=;
 b=DjQ097fZM5nVBjE9PZI/dEi475enolde4ctxV2OTYFnjgVrQY2+AHLgVZWjjOMGcF5g7
 CcQsKpSn60mt1/IcUlgawsY4BumdvjjnO9Hzru/8rqIgJM6D0WdF1SPLgu+Z3eaqQKbA
 X4iHbnHyFyBwlEBXCAbF9SASMM2hLaCDOp+3MjchBy3KZdQaqcast6/GFrUrdvSt0IOi
 Er6BkG2ZjhgawpGq/jEPY3I2OkEumnW7bt3Hp1iEmuvgWZCdbafg+UbsaeUp3bcxDgGl
 JUn3UHsJe5ul5vIuFwBvgrnBG8MqovAtaWfRTzOQoLsZQ9aJCaPwIF/2bXoOoYxJ5wIk Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rvmewg5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 17:46:53 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 136LXjFh109310;
        Tue, 6 Apr 2021 17:46:52 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rvmewg5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 17:46:52 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 136LbFgH010657;
        Tue, 6 Apr 2021 21:46:52 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 37rvs11a6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 21:46:51 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 136LkpSO26411420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 21:46:51 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B912AC05B;
        Tue,  6 Apr 2021 21:46:51 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87C4EAC059;
        Tue,  6 Apr 2021 21:46:49 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.211.132.106])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 21:46:49 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com
Subject: [PATCH v2] KVM: PPC: Book3S HV: Sanitise vcpu registers in nested path
Date:   Tue,  6 Apr 2021 18:46:45 -0300
Message-Id: <20210406214645.3315819-1-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0MmRAJqkltXuiq_ICfivqNeMcmaxnquu
X-Proofpoint-ORIG-GUID: CrNUWjlEo1Mo662JQjgJMEoKGyAnkfBb
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_07:2021-04-06,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 mlxscore=0 adultscore=0
 phishscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104060145
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

As one of the arguments of the H_ENTER_NESTED hypercall, the nested
hypervisor (L1) prepares a structure containing the values of various
hypervisor-privileged registers with which it wants the nested guest
(L2) to run. Since the nested HV runs in supervisor mode it needs the
host to write to these registers.

To stop a nested HV manipulating this mechanism and using a nested
guest as a proxy to access a facility that has been made unavailable
to it, we have a routine that sanitises the values of the HV registers
before copying them into the nested guest's vcpu struct.

However, when coming out of the guest the values are copied as they
were back into L1 memory, which means that any sanitisation we did
during guest entry will be exposed to L1 after H_ENTER_NESTED returns.

This patch alters this sanitisation to have effect on the vcpu->arch
registers directly before entering and after exiting the guest,
leaving the structure that is copied back into L1 unchanged (except
when we really want L1 to access the value, e.g the Cause bits of
HFSCR).

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
I'm taking another shot at fixing this locally without resorting to
more complex things such as error handling and feature
advertisement/negotiation.

Changes since v1:

- made the change more generic, not only applies to hfscr anymore;
- sanitisation is now done directly on the vcpu struct, l2_hv is left unchanged;

v1:

https://lkml.kernel.org/r/20210305231055.2913892-1-farosas@linux.ibm.com
---
 arch/powerpc/kvm/book3s_hv_nested.c | 33 +++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 0cd0e7aad588..a60fccb2c4f2 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -132,21 +132,37 @@ static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
 	}
 }
 
-static void sanitise_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
+static void sanitise_vcpu_entry_state(struct kvm_vcpu *vcpu,
+				      const struct hv_guest_state *l2_hv,
+				      const struct hv_guest_state *l1_hv)
 {
 	/*
 	 * Don't let L1 enable features for L2 which we've disabled for L1,
 	 * but preserve the interrupt cause field.
 	 */
-	hr->hfscr &= (HFSCR_INTR_CAUSE | vcpu->arch.hfscr);
+	vcpu->arch.hfscr = l2_hv->hfscr & (HFSCR_INTR_CAUSE | l1_hv->hfscr);
 
 	/* Don't let data address watchpoint match in hypervisor state */
-	hr->dawrx0 &= ~DAWRX_HYP;
-	hr->dawrx1 &= ~DAWRX_HYP;
+	vcpu->arch.dawrx0 = l2_hv->dawrx0 & ~DAWRX_HYP;
+	vcpu->arch.dawrx1 = l2_hv->dawrx1 & ~DAWRX_HYP;
 
 	/* Don't let completed instruction address breakpt match in HV state */
-	if ((hr->ciabr & CIABR_PRIV) == CIABR_PRIV_HYPER)
-		hr->ciabr &= ~CIABR_PRIV;
+	if ((l2_hv->ciabr & CIABR_PRIV) == CIABR_PRIV_HYPER)
+		vcpu->arch.ciabr = l2_hv->ciabr & ~CIABR_PRIV;
+}
+
+
+/*
+ * During sanitise_vcpu_entry_state() we might have used bits from L1
+ * state to restrict what the L2 state is allowed to be. Since L1 is
+ * not allowed to read the HV registers, do not include these
+ * modifications in the return state.
+ */
+static void sanitise_vcpu_return_state(struct kvm_vcpu *vcpu,
+				       const struct hv_guest_state *l2_hv)
+{
+	vcpu->arch.hfscr = ((~HFSCR_INTR_CAUSE & l2_hv->hfscr) |
+			(HFSCR_INTR_CAUSE & vcpu->arch.hfscr));
 }
 
 static void restore_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
@@ -324,9 +340,10 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	mask = LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_AIL | LPCR_LD |
 		LPCR_LPES | LPCR_MER;
 	lpcr = (vc->lpcr & ~mask) | (l2_hv.lpcr & mask);
-	sanitise_hv_regs(vcpu, &l2_hv);
 	restore_hv_regs(vcpu, &l2_hv);
 
+	sanitise_vcpu_entry_state(vcpu, &l2_hv, &saved_l1_hv);
+
 	vcpu->arch.ret = RESUME_GUEST;
 	vcpu->arch.trap = 0;
 	do {
@@ -338,6 +355,8 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 		r = kvmhv_run_single_vcpu(vcpu, hdec_exp, lpcr);
 	} while (is_kvmppc_resume_guest(r));
 
+	sanitise_vcpu_return_state(vcpu, &l2_hv);
+
 	/* save L2 state for return */
 	l2_regs = vcpu->arch.regs;
 	l2_regs.msr = vcpu->arch.shregs.msr;
-- 
2.29.2

