Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B413A49BE0F
	for <lists+kvm-ppc@lfdr.de>; Tue, 25 Jan 2022 22:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbiAYV5Z (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 25 Jan 2022 16:57:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61940 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233434AbiAYV5X (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 25 Jan 2022 16:57:23 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PLkFXe039009;
        Tue, 25 Jan 2022 21:57:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=U0cPWWJNpFIJypCaOD6v+Ogc3Kjy2zfQFqPDyje+iF8=;
 b=dkwBNpxR6Q91w6CJazFC4KPA3ilpAoUpBc0ATnjuYRq7zprHfnl80jAijFrlkrqpwoWu
 oYTcngEwNRfwbeLTg9LhHqS/qtq1Kbn02oA0k0XIVuzzOQDNhquDXq3oXHtOT2EMnFKL
 ZlvW18YXCaXXj7rohNPy6iewgfGveIqZJLUpYi3nBO3xp7NoHnWFcfINdikE5P8MIWHH
 jddOMX+ezbk9aFXWT1jzyItSb2Xqv9S7aWzoEJCwTgsj24NB87ujeu7OWU9zeq6MAmyp
 byNVpxUWbwb6RnclP/z9I4UvYdKE0WeKm/19cMPz6EtNRIlAmXb5rRuigR2pFx9TjA+I 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtsdr85an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 21:57:14 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20PLuO2m037867;
        Tue, 25 Jan 2022 21:57:14 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtsdr85ad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 21:57:14 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20PLrnK6013292;
        Tue, 25 Jan 2022 21:57:13 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma05wdc.us.ibm.com with ESMTP id 3dtbch823v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 21:57:13 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20PLvC0P14156188
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 21:57:12 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5D50C605D;
        Tue, 25 Jan 2022 21:57:12 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4836C605A;
        Tue, 25 Jan 2022 21:57:10 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.163.21.20])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jan 2022 21:57:10 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v5 5/5] KVM: PPC: Book3s: mmio: Deliver DSI after emulation failure
Date:   Tue, 25 Jan 2022 18:56:55 -0300
Message-Id: <20220125215655.1026224-6-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125215655.1026224-1-farosas@linux.ibm.com>
References: <20220125215655.1026224-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hf5tG2aOuFMHR2Ib1rt_f1AAq5GP8R49
X-Proofpoint-GUID: yFyYxtQwl1LI_VWr6-4lawBgd751DvN0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_05,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0 clxscore=1015
 mlxlogscore=927 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250128
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

MMIO emulation can fail if the guest uses an instruction that we are
not prepared to emulate. Since these instructions can be and most
likely are valid ones, this is (slightly) closer to an access fault
than to an illegal instruction, so deliver a Data Storage interrupt
instead of a Program interrupt.

BookE ignores bad faults, so it will keep using a Program interrupt
because a DSI would cause a fault loop in the guest.

Suggested-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/emulate_loadstore.c | 10 +++-------
 arch/powerpc/kvm/powerpc.c           | 22 ++++++++++++++++++++++
 2 files changed, 25 insertions(+), 7 deletions(-)

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
index acb0d2a4bdb9..82d889db2b6b 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -309,6 +309,28 @@ int kvmppc_emulate_mmio(struct kvm_vcpu *vcpu)
 		kvmppc_get_last_inst(vcpu, INST_GENERIC, &last_inst);
 		kvm_debug_ratelimited("Guest access to device memory using unsupported instruction (opcode: %#08x)\n",
 				      last_inst);
+
+		/*
+		 * Injecting a Data Storage here is a bit more
+		 * accurate since the instruction that caused the
+		 * access could still be a valid one.
+		 */
+		if (!IS_ENABLED(CONFIG_BOOKE)) {
+			ulong dsisr = DSISR_BADACCESS;
+
+			if (vcpu->mmio_is_write)
+				dsisr |= DSISR_ISSTORE;
+
+			kvmppc_core_queue_data_storage(vcpu, vcpu->arch.vaddr_accessed, dsisr);
+		} else {
+			/*
+			 * BookE does not send a SIGBUS on a bad
+			 * fault, so use a Program interrupt instead
+			 * to avoid a fault loop.
+			 */
+			kvmppc_core_queue_program(vcpu, 0);
+		}
+
 		r = RESUME_GUEST;
 		break;
 	}
-- 
2.34.1

