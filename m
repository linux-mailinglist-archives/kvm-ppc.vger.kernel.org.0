Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2623CFAFE
	for <lists+kvm-ppc@lfdr.de>; Tue, 20 Jul 2021 15:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238456AbhGTNFA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm-ppc@lfdr.de>); Tue, 20 Jul 2021 09:05:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12338 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238729AbhGTNCp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 20 Jul 2021 09:02:45 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16KDY4oB180675;
        Tue, 20 Jul 2021 09:42:30 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39wuugq17b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 09:42:29 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16KDZ0LP184974;
        Tue, 20 Jul 2021 09:42:29 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39wuugq16g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 09:42:29 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16KDRsxO006092;
        Tue, 20 Jul 2021 13:42:27 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 39upu88s95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 13:42:26 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16KDgOHU24183246
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jul 2021 13:42:24 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E3DE5205F;
        Tue, 20 Jul 2021 13:42:24 +0000 (GMT)
Received: from smtp.tlslab.ibm.com (unknown [9.101.4.1])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 35BBF52051;
        Tue, 20 Jul 2021 13:42:24 +0000 (GMT)
Received: from yukon.ibmuc.com (unknown [9.171.24.171])
        by smtp.tlslab.ibm.com (Postfix) with ESMTP id 62809220144;
        Tue, 20 Jul 2021 15:42:23 +0200 (CEST)
From:   =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH 2/2] KVM: PPC: Book3S HV: XIVE: Add support for automatic save-restore
Date:   Tue, 20 Jul 2021 15:42:09 +0200
Message-Id: <20210720134209.256133-3-clg@kaod.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210720134209.256133-1-clg@kaod.org>
References: <20210720134209.256133-1-clg@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Oia6weSBTRp8R-M36wYy5YEFxvDp_bs4
X-Proofpoint-GUID: XbKkrAQpGQv3zqvClSNZOOxEp07tbdlm
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-20_07:2021-07-19,2021-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 clxscore=1034 bulkscore=0 suspectscore=0 spamscore=0
 impostorscore=0 phishscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107200087
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On P10, the feature doing an automatic "save & restore" of a VCPU
interrupt context is set by default in OPAL. When a VP context is
pulled out, the state of the interrupt registers are saved by the XIVE
interrupt controller under the internal NVP structure representing the
VP. This saves a costly store/load in guest entries and exits.

If OPAL advertises the "save & restore" feature in the device tree,
it should also have set the 'H' bit in the CAM line. Check that when
vCPUs are connected to their ICP in KVM before going any further.

Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Cédric Le Goater <clg@kaod.org>
---
 arch/powerpc/include/asm/xive-regs.h  |  3 +++
 arch/powerpc/include/asm/xive.h       |  1 +
 arch/powerpc/kvm/book3s_xive.h        |  2 ++
 arch/powerpc/kvm/book3s_xive.c        | 34 +++++++++++++++++++++++++--
 arch/powerpc/kvm/book3s_xive_native.c |  9 +++++++
 arch/powerpc/sysdev/xive/native.c     | 10 ++++++++
 6 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/xive-regs.h b/arch/powerpc/include/asm/xive-regs.h
index 8b211faa0e42..cf8bb6ac4463 100644
--- a/arch/powerpc/include/asm/xive-regs.h
+++ b/arch/powerpc/include/asm/xive-regs.h
@@ -80,10 +80,13 @@
 #define   TM_QW0W2_VU		PPC_BIT32(0)
 #define   TM_QW0W2_LOGIC_SERV	PPC_BITMASK32(1,31) // XX 2,31 ?
 #define   TM_QW1W2_VO		PPC_BIT32(0)
+#define   TM_QW1W2_HO           PPC_BIT32(1) /* P10 XIVE2 */
 #define   TM_QW1W2_OS_CAM	PPC_BITMASK32(8,31)
 #define   TM_QW2W2_VP		PPC_BIT32(0)
+#define   TM_QW2W2_HP           PPC_BIT32(1) /* P10 XIVE2 */
 #define   TM_QW2W2_POOL_CAM	PPC_BITMASK32(8,31)
 #define   TM_QW3W2_VT		PPC_BIT32(0)
+#define   TM_QW3W2_HT           PPC_BIT32(1) /* P10 XIVE2 */
 #define   TM_QW3W2_LP		PPC_BIT32(6)
 #define   TM_QW3W2_LE		PPC_BIT32(7)
 #define   TM_QW3W2_T		PPC_BIT32(31)
diff --git a/arch/powerpc/include/asm/xive.h b/arch/powerpc/include/asm/xive.h
index aa094a8655b0..efb0f5effcc6 100644
--- a/arch/powerpc/include/asm/xive.h
+++ b/arch/powerpc/include/asm/xive.h
@@ -125,6 +125,7 @@ int xive_native_enable_vp(u32 vp_id, bool single_escalation);
 int xive_native_disable_vp(u32 vp_id);
 int xive_native_get_vp_info(u32 vp_id, u32 *out_cam_id, u32 *out_chip_id);
 bool xive_native_has_single_escalation(void);
+bool xive_native_has_save_restore(void);
 
 int xive_native_get_queue_info(u32 vp_id, uint32_t prio,
 			       u64 *out_qpage,
diff --git a/arch/powerpc/kvm/book3s_xive.h b/arch/powerpc/kvm/book3s_xive.h
index 73c3cd25093c..e6a9651c6f1e 100644
--- a/arch/powerpc/kvm/book3s_xive.h
+++ b/arch/powerpc/kvm/book3s_xive.h
@@ -98,6 +98,7 @@ struct kvmppc_xive_ops {
 };
 
 #define KVMPPC_XIVE_FLAG_SINGLE_ESCALATION 0x1
+#define KVMPPC_XIVE_FLAG_SAVE_RESTORE 0x2
 
 struct kvmppc_xive {
 	struct kvm *kvm;
@@ -309,6 +310,7 @@ void xive_cleanup_single_escalation(struct kvm_vcpu *vcpu,
 				    struct kvmppc_xive_vcpu *xc, int irq);
 int kvmppc_xive_compute_vp_id(struct kvmppc_xive *xive, u32 cpu, u32 *vp);
 int kvmppc_xive_set_nr_servers(struct kvmppc_xive *xive, u64 addr);
+bool kvmppc_xive_check_save_restore(struct kvm_vcpu *vcpu);
 
 static inline bool kvmppc_xive_has_single_escalation(struct kvmppc_xive *xive)
 {
diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index 12f101d74b48..cc5bee49bd63 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -59,6 +59,25 @@
  */
 #define XIVE_Q_GAP	2
 
+static bool kvmppc_xive_vcpu_has_save_restore(struct kvm_vcpu *vcpu)
+{
+	struct kvmppc_xive_vcpu *xc = vcpu->arch.xive_vcpu;
+
+	/* Check enablement at VP level */
+	return xc->vp_cam & TM_QW1W2_HO;
+}
+
+bool kvmppc_xive_check_save_restore(struct kvm_vcpu *vcpu)
+{
+	struct kvmppc_xive_vcpu *xc = vcpu->arch.xive_vcpu;
+	struct kvmppc_xive *xive = xc->xive;
+
+	if (xive->flags & KVMPPC_XIVE_FLAG_SAVE_RESTORE)
+		return kvmppc_xive_vcpu_has_save_restore(vcpu);
+
+	return true;
+}
+
 /*
  * Push a vcpu's context to the XIVE on guest entry.
  * This assumes we are in virtual mode (MMU on)
@@ -77,7 +96,8 @@ void kvmppc_xive_push_vcpu(struct kvm_vcpu *vcpu)
 		return;
 
 	eieio();
-	__raw_writeq(vcpu->arch.xive_saved_state.w01, tima + TM_QW1_OS);
+	if (!kvmppc_xive_vcpu_has_save_restore(vcpu))
+		__raw_writeq(vcpu->arch.xive_saved_state.w01, tima + TM_QW1_OS);
 	__raw_writel(vcpu->arch.xive_cam_word, tima + TM_QW1_OS + TM_WORD2);
 	vcpu->arch.xive_pushed = 1;
 	eieio();
@@ -149,7 +169,8 @@ void kvmppc_xive_pull_vcpu(struct kvm_vcpu *vcpu)
 	/* First load to pull the context, we ignore the value */
 	__raw_readl(tima + TM_SPC_PULL_OS_CTX);
 	/* Second load to recover the context state (Words 0 and 1) */
-	vcpu->arch.xive_saved_state.w01 = __raw_readq(tima + TM_QW1_OS);
+	if (!kvmppc_xive_vcpu_has_save_restore(vcpu))
+		vcpu->arch.xive_saved_state.w01 = __raw_readq(tima + TM_QW1_OS);
 
 	/* Fixup some of the state for the next load */
 	vcpu->arch.xive_saved_state.lsmfb = 0;
@@ -1319,6 +1340,12 @@ int kvmppc_xive_connect_vcpu(struct kvm_device *dev,
 	if (r)
 		goto bail;
 
+	if (!kvmppc_xive_check_save_restore(vcpu)) {
+		pr_err("inconsistent save-restore setup for VCPU %d\n", cpu);
+		r = -EIO;
+		goto bail;
+	}
+
 	/* Configure VCPU fields for use by assembly push/pull */
 	vcpu->arch.xive_saved_state.w01 = cpu_to_be64(0xff000000);
 	vcpu->arch.xive_cam_word = cpu_to_be32(xc->vp_cam | TM_QW1W2_VO);
@@ -2138,6 +2165,9 @@ static int kvmppc_xive_create(struct kvm_device *dev, u32 type)
 	if (xive_native_has_single_escalation())
 		xive->flags |= KVMPPC_XIVE_FLAG_SINGLE_ESCALATION;
 
+	if (xive_native_has_save_restore())
+		xive->flags |= KVMPPC_XIVE_FLAG_SAVE_RESTORE;
+
 	kvm->arch.xive = xive;
 	return 0;
 }
diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index 2abb1358a268..af65ea21bde7 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -168,6 +168,12 @@ int kvmppc_xive_native_connect_vcpu(struct kvm_device *dev,
 		goto bail;
 	}
 
+	if (!kvmppc_xive_check_save_restore(vcpu)) {
+		pr_err("inconsistent save-restore setup for VCPU %d\n", server_num);
+		rc = -EIO;
+		goto bail;
+	}
+
 	/*
 	 * Enable the VP first as the single escalation mode will
 	 * affect escalation interrupts numbering
@@ -1114,6 +1120,9 @@ static int kvmppc_xive_native_create(struct kvm_device *dev, u32 type)
 	if (xive_native_has_single_escalation())
 		xive->flags |= KVMPPC_XIVE_FLAG_SINGLE_ESCALATION;
 
+	if (xive_native_has_save_restore())
+		xive->flags |= KVMPPC_XIVE_FLAG_SAVE_RESTORE;
+
 	xive->ops = &kvmppc_xive_native_ops;
 
 	kvm->arch.xive = xive;
diff --git a/arch/powerpc/sysdev/xive/native.c b/arch/powerpc/sysdev/xive/native.c
index fb15cecfe67c..b7ed436049f7 100644
--- a/arch/powerpc/sysdev/xive/native.c
+++ b/arch/powerpc/sysdev/xive/native.c
@@ -41,6 +41,7 @@ static u32 xive_queue_shift;
 static u32 xive_pool_vps = XIVE_INVALID_VP;
 static struct kmem_cache *xive_provision_cache;
 static bool xive_has_single_esc;
+static bool xive_has_save_restore;
 
 int xive_native_populate_irq_data(u32 hw_irq, struct xive_irq_data *data)
 {
@@ -592,6 +593,9 @@ bool __init xive_native_init(void)
 	if (of_get_property(np, "single-escalation-support", NULL) != NULL)
 		xive_has_single_esc = true;
 
+	if (of_get_property(np, "vp-save-restore", NULL))
+		xive_has_save_restore = true;
+
 	/* Configure Thread Management areas for KVM */
 	for_each_possible_cpu(cpu)
 		kvmppc_set_xive_tima(cpu, r.start, tima);
@@ -758,6 +762,12 @@ bool xive_native_has_single_escalation(void)
 }
 EXPORT_SYMBOL_GPL(xive_native_has_single_escalation);
 
+bool xive_native_has_save_restore(void)
+{
+	return xive_has_save_restore;
+}
+EXPORT_SYMBOL_GPL(xive_native_has_save_restore);
+
 int xive_native_get_queue_info(u32 vp_id, u32 prio,
 			       u64 *out_qpage,
 			       u64 *out_qsize,
-- 
2.31.1

