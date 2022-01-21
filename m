Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7404967D8
	for <lists+kvm-ppc@lfdr.de>; Fri, 21 Jan 2022 23:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbiAUW1D (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 21 Jan 2022 17:27:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43272 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233409AbiAUW1C (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 21 Jan 2022 17:27:02 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20LLHslh015901;
        Fri, 21 Jan 2022 22:26:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=FXnabRKiYJvt+Mb69UUs+trtlt9U5nJGlpUDByRn20o=;
 b=Wi6/TA5vcgWoWNdqgk5OWVzrzeXvX5+rjarNmmmlIOz+kNzDMNg8S0U1bOKTHKB8cYTA
 llGEDmY76RhBtk2P/J71d1oxXJjtsmCvuwbldZIrDjIacKxwbSGAjpwRYa7blY36NZq3
 sYOnDBaonbXLda9SIGTUnUKMfkPWyuz/SBJncjdTWSppaebqykwwfGbY1L6Bb3ClpUAC
 pxyMJhYmJVpfR9Jk8lffFliyZUjNHPqCxo0DI2J46QrKbAUg+U6Ins9Jrt98u98A6Wht
 bpt8NaFz2lz5P54FRFrtsQtfW4+sRzg+QREpkRMu7wt2HoiysXsSQmWfwb1vVABOyMZ7 ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dr4me0yst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 22:26:54 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20LMQrVM021136;
        Fri, 21 Jan 2022 22:26:53 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dr4me0ysb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 22:26:53 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20LMMSK7018976;
        Fri, 21 Jan 2022 22:26:52 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma05wdc.us.ibm.com with ESMTP id 3dqj3f4c4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 22:26:52 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20LMQp5f36831506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 22:26:51 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59030AE05C;
        Fri, 21 Jan 2022 22:26:51 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBC34AE060;
        Fri, 21 Jan 2022 22:26:48 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.211.81.234])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jan 2022 22:26:48 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v4 5/5] KVM: PPC: mmio: Deliver DSI after emulation failure
Date:   Fri, 21 Jan 2022 19:26:26 -0300
Message-Id: <20220121222626.972495-6-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220121222626.972495-1-farosas@linux.ibm.com>
References: <20220121222626.972495-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Gp9YHsE2VzQr14U5SlZnmetxEmirXgTJ
X-Proofpoint-ORIG-GUID: 9mezfzYUpVNy4IFr_t42RMzC0K_JcQ47
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_10,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 spamscore=0 mlxscore=0 mlxlogscore=822 priorityscore=1501 impostorscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210140
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

MMIO emulation can fail if the guest uses an instruction that we are
not prepared to emulate. Since these instructions can be and most
likely are valid ones, this is (slightly) closer to an access fault
than to an illegal instruction, so deliver a Data Storage interrupt
instead of a Program interrupt.

Suggested-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/emulate_loadstore.c | 10 +++-------
 arch/powerpc/kvm/powerpc.c           | 12 ++++++++++++
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kvm/emulate_loadstore.c b/arch/powerpc/kvm/emulate_loadstore.c
index 48272a9b9c30..cfc9114b87d0 100644
--- a/arch/powerpc/kvm/emulate_loadstore.c
+++ b/arch/powerpc/kvm/emulate_loadstore.c
@@ -73,7 +73,6 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
 {
 	u32 inst;
 	enum emulation_result emulated = EMULATE_FAIL;
-	int advance = 1;
 	struct instruction_op op;
 
 	/* this default type might be overwritten by subcategories */
@@ -98,6 +97,8 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
 		int type = op.type & INSTR_TYPE_MASK;
 		int size = GETSIZE(op.type);
 
+		vcpu->mmio_is_write = OP_IS_STORE(type);
+
 		switch (type) {
 		case LOAD:  {
 			int instr_byte_swap = op.type & BYTEREV;
@@ -355,15 +356,10 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	if (emulated == EMULATE_FAIL) {
-		advance = 0;
-		kvmppc_core_queue_program(vcpu, 0);
-	}
-
 	trace_kvm_ppc_instr(inst, kvmppc_get_pc(vcpu), emulated);
 
 	/* Advance past emulated instruction. */
-	if (advance)
+	if (emulated != EMULATE_FAIL)
 		kvmppc_set_pc(vcpu, kvmppc_get_pc(vcpu) + 4);
 
 	return emulated;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 214602c58f13..9befb121dddb 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -305,10 +305,22 @@ int kvmppc_emulate_mmio(struct kvm_vcpu *vcpu)
 	case EMULATE_FAIL:
 	{
 		u32 last_inst;
+		ulong store_bit = DSISR_ISSTORE;
+		ulong cause = DSISR_BADACCESS;
 
+#ifdef CONFIG_BOOKE
+		store_bit = ESR_ST;
+		cause = 0;
+#endif
 		kvmppc_get_last_inst(vcpu, INST_GENERIC, &last_inst);
 		pr_info_ratelimited("KVM: guest access to device memory using unsupported instruction (PID: %d opcode: %#08x)\n",
 				    current->pid, last_inst);
+
+		if (vcpu->mmio_is_write)
+			cause |= store_bit;
+
+		kvmppc_core_queue_data_storage(vcpu, vcpu->arch.vaddr_accessed,
+					       cause);
 		r = RESUME_GUEST;
 		break;
 	}
-- 
2.34.1

