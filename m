Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93576223AC
	for <lists+kvm-ppc@lfdr.de>; Sat, 18 May 2019 16:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729594AbfERO0B (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 18 May 2019 10:26:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49332 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727594AbfERO0B (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 18 May 2019 10:26:01 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4IEGeHP039402
        for <kvm-ppc@vger.kernel.org>; Sat, 18 May 2019 10:26:00 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sje2791b5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Sat, 18 May 2019 10:26:00 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <cclaudio@linux.ibm.com>;
        Sat, 18 May 2019 15:25:59 +0100
Received: from b03cxnp08026.gho.boulder.ibm.com (9.17.130.18)
        by e31.co.us.ibm.com (192.168.1.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 18 May 2019 15:25:56 +0100
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4IEPsHL000426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 May 2019 14:25:55 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8FB67805F;
        Sat, 18 May 2019 14:25:54 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18AC57805C;
        Sat, 18 May 2019 14:25:52 +0000 (GMT)
Received: from rino.ibm.com (unknown [9.85.168.40])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 18 May 2019 14:25:51 +0000 (GMT)
From:   Claudio Carvalho <cclaudio@linux.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Cc:     Ram Pai <linuxram@us.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: [RFC PATCH v2 08/10] KVM: PPC: Ultravisor: Return to UV for hcalls from SVM
Date:   Sat, 18 May 2019 11:25:22 -0300
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190518142524.28528-1-cclaudio@linux.ibm.com>
References: <20190518142524.28528-1-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19051814-8235-0000-0000-00000E9900B0
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011118; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01205121; UDB=6.00632701; IPR=6.00986061;
 MB=3.00026948; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-18 14:25:58
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051814-8236-0000-0000-0000459E0506
Message-Id: <20190518142524.28528-9-cclaudio@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-18_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905180103
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

All hcalls from a secure VM go to the ultravisor from where they are
reflected into the HV. When we (HV) complete processing such hcalls,
we should return to the UV rather than to the guest kernel.

Have fast_guest_return check the kvm_arch.secure_guest field so that
even a new CPU will enter UV when started (in response to a RTAS
start-cpu call).

Thanks to input from Paul Mackerras, Ram Pai and Mike Anderson.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
[Fix UV_RETURN token number and arch.secure_guest check]
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
---
 arch/powerpc/include/asm/kvm_host.h       |  1 +
 arch/powerpc/include/asm/ultravisor-api.h |  1 +
 arch/powerpc/kernel/asm-offsets.c         |  1 +
 arch/powerpc/kvm/book3s_hv_rmhandlers.S   | 30 ++++++++++++++++++++---
 4 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index e6b5bb012ccb..ba7dd35cb916 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -290,6 +290,7 @@ struct kvm_arch {
 	cpumask_t cpu_in_guest;
 	u8 radix;
 	u8 fwnmi_enabled;
+	u8 secure_guest;
 	bool threads_indep;
 	bool nested_enable;
 	pgd_t *pgtable;
diff --git a/arch/powerpc/include/asm/ultravisor-api.h b/arch/powerpc/include/asm/ultravisor-api.h
index 24bfb4c1737e..15e6ce77a131 100644
--- a/arch/powerpc/include/asm/ultravisor-api.h
+++ b/arch/powerpc/include/asm/ultravisor-api.h
@@ -19,5 +19,6 @@
 
 /* opcodes */
 #define UV_WRITE_PATE			0xF104
+#define UV_RETURN			0xF11C
 
 #endif /* _ASM_POWERPC_ULTRAVISOR_API_H */
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 8e02444e9d3d..44742724513e 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -508,6 +508,7 @@ int main(void)
 	OFFSET(KVM_VRMA_SLB_V, kvm, arch.vrma_slb_v);
 	OFFSET(KVM_RADIX, kvm, arch.radix);
 	OFFSET(KVM_FWNMI, kvm, arch.fwnmi_enabled);
+	OFFSET(KVM_SECURE_GUEST, kvm, arch.secure_guest);
 	OFFSET(VCPU_DSISR, kvm_vcpu, arch.shregs.dsisr);
 	OFFSET(VCPU_DAR, kvm_vcpu, arch.shregs.dar);
 	OFFSET(VCPU_VPA, kvm_vcpu, arch.vpa.pinned_addr);
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 938cfa5dceed..d89efa0783a2 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -36,6 +36,7 @@
 #include <asm/asm-compat.h>
 #include <asm/feature-fixups.h>
 #include <asm/cpuidle.h>
+#include <asm/ultravisor-api.h>
 
 /* Sign-extend HDEC if not on POWER9 */
 #define EXTEND_HDEC(reg)			\
@@ -1112,16 +1113,12 @@ BEGIN_FTR_SECTION
 END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 
 	ld	r5, VCPU_LR(r4)
-	ld	r6, VCPU_CR(r4)
 	mtlr	r5
-	mtcr	r6
 
 	ld	r1, VCPU_GPR(R1)(r4)
 	ld	r2, VCPU_GPR(R2)(r4)
 	ld	r3, VCPU_GPR(R3)(r4)
 	ld	r5, VCPU_GPR(R5)(r4)
-	ld	r6, VCPU_GPR(R6)(r4)
-	ld	r7, VCPU_GPR(R7)(r4)
 	ld	r8, VCPU_GPR(R8)(r4)
 	ld	r9, VCPU_GPR(R9)(r4)
 	ld	r10, VCPU_GPR(R10)(r4)
@@ -1139,10 +1136,35 @@ BEGIN_FTR_SECTION
 	mtspr	SPRN_HDSISR, r0
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 
+	ld	r6, VCPU_KVM(r4)
+	lbz	r7, KVM_SECURE_GUEST(r6)
+	cmpdi	r7, 0
+	bne	ret_to_ultra
+
+	lwz	r6, VCPU_CR(r4)
+	mtcr	r6
+
+	ld	r7, VCPU_GPR(R7)(r4)
+	ld	r6, VCPU_GPR(R6)(r4)
 	ld	r0, VCPU_GPR(R0)(r4)
 	ld	r4, VCPU_GPR(R4)(r4)
 	HRFI_TO_GUEST
 	b	.
+/*
+ * The hcall we just completed was from Ultravisor. Use UV_RETURN
+ * ultra call to return to the Ultravisor. Results from the hcall
+ * are already in the appropriate registers (r3:12), except for
+ * R6,7 which we used as temporary registers above. Restore them,
+ * and set R0 to the ucall number (UV_RETURN).
+ */
+ret_to_ultra:
+	lwz	r6, VCPU_CR(r4)
+	mtcr	r6
+	LOAD_REG_IMMEDIATE(r0, UV_RETURN)
+	ld	r7, VCPU_GPR(R7)(r4)
+	ld	r6, VCPU_GPR(R6)(r4)
+	ld	r4, VCPU_GPR(R4)(r4)
+	sc	2
 
 /*
  * Enter the guest on a P9 or later system where we have exactly
-- 
2.20.1

