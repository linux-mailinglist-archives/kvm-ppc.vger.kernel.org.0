Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162CB3D6801
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 22:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhGZThD (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 26 Jul 2021 15:37:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38520 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232481AbhGZThB (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 26 Jul 2021 15:37:01 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16QKFNDG155796;
        Mon, 26 Jul 2021 16:17:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WczDBqmZsW+H2ECGxbP4Uj/CS6QXAzMnAoYwBXTdaqs=;
 b=Cqxdyb4K7NKbM2YUnEtfg/qU6kXafGBJXfl3TctzuyHTR0Y7gMAalICMj5UITCXmp9ri
 BE8RcGG/z2699hkil05o860U9GNnJrlm9C7Q2yRFRtL93/I3rokdiMs1xAnptmZpwCin
 kt1HP+GUlzdHlc78Dg45GPgHEi34+0Z0h0ZK3kyQvmNaKyKXV90CRM1yjZYSP0NIQTpQ
 z3up9GrLDUZ+9r9qNFd+MtGkhHGhynxkOHl3MSN9wtJF4zPxOMVPX7UcmMnjSm6vjkgk
 dTXXMnIVscQRcC0wiKBIc4knnQJmmWFr36v4UjSHQyuDc2um0AjUWmB5Jhj7War8i77U hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a23wx01at-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jul 2021 16:17:22 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16QKHMDs169207;
        Mon, 26 Jul 2021 16:17:22 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a23wx01ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jul 2021 16:17:21 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16QKCX0q028150;
        Mon, 26 Jul 2021 20:17:21 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 3a235n1rng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jul 2021 20:17:21 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16QKHJJP17826226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 20:17:19 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDC81BE059;
        Mon, 26 Jul 2021 20:17:19 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A8A6BE069;
        Mon, 26 Jul 2021 20:17:18 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.211.57.103])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 26 Jul 2021 20:17:17 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com
Subject: [PATCH v5 2/2] KVM: PPC: Book3S HV: Stop forwarding all HFUs to L1
Date:   Mon, 26 Jul 2021 17:17:10 -0300
Message-Id: <20210726201710.2432874-3-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210726201710.2432874-1-farosas@linux.ibm.com>
References: <20210726201710.2432874-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AqDTonbs20RB7PtcB_PMqliRVVubhwJS
X-Proofpoint-GUID: 8IMJxTQB-AwTnRKew8IOFX3PWRRqvXT4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-26_14:2021-07-26,2021-07-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxscore=0 adultscore=0 mlxlogscore=749 lowpriorityscore=0
 suspectscore=0 clxscore=1015 impostorscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107260118
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

If the nested hypervisor has no access to a facility because it has
been disabled by the host, it should also not be able to see the
Hypervisor Facility Unavailable that arises from one of its guests
trying to access the facility.

This patch turns a HFU that happened in L2 into a Hypervisor Emulation
Assistance interrupt and forwards it to L1 for handling. The ones that
happened because L1 explicitly disabled the facility for L2 are still
let through, along with the corresponding Cause bits in the HFSCR.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_nested.c | 32 +++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 8215dbd4be9a..d544b092b49a 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -99,7 +99,7 @@ static void byteswap_hv_regs(struct hv_guest_state *hr)
 	hr->dawrx1 = swab64(hr->dawrx1);
 }
 
-static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
+static void save_hv_return_state(struct kvm_vcpu *vcpu,
 				 struct hv_guest_state *hr)
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
@@ -118,7 +118,7 @@ static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
 	hr->pidr = vcpu->arch.pid;
 	hr->cfar = vcpu->arch.cfar;
 	hr->ppr = vcpu->arch.ppr;
-	switch (trap) {
+	switch (vcpu->arch.trap) {
 	case BOOK3S_INTERRUPT_H_DATA_STORAGE:
 		hr->hdar = vcpu->arch.fault_dar;
 		hr->hdsisr = vcpu->arch.fault_dsisr;
@@ -128,9 +128,29 @@ static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
 		hr->asdr = vcpu->arch.fault_gpa;
 		break;
 	case BOOK3S_INTERRUPT_H_FAC_UNAVAIL:
-		hr->hfscr = ((~HFSCR_INTR_CAUSE & hr->hfscr) |
-			     (HFSCR_INTR_CAUSE & vcpu->arch.hfscr));
-		break;
+	{
+		u8 cause = vcpu->arch.hfscr >> 56;
+
+		WARN_ON_ONCE(cause >= BITS_PER_LONG);
+
+		if (!(hr->hfscr & (1UL << cause))) {
+			hr->hfscr = ((~HFSCR_INTR_CAUSE & hr->hfscr) |
+				     (HFSCR_INTR_CAUSE & vcpu->arch.hfscr));
+			break;
+		}
+
+		/*
+		 * We have disabled this facility, so it does not
+		 * exist from L1's perspective. Turn it into a HEAI.
+		 */
+		vcpu->arch.trap = BOOK3S_INTERRUPT_H_EMUL_ASSIST;
+		kvmppc_load_last_inst(vcpu, INST_GENERIC, &vcpu->arch.emul_inst);
+
+		/* Don't leak the cause field */
+		hr->hfscr &= ~HFSCR_INTR_CAUSE;
+
+		fallthrough;
+	}
 	case BOOK3S_INTERRUPT_H_EMUL_ASSIST:
 		hr->heir = vcpu->arch.emul_inst;
 		break;
@@ -368,7 +388,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	delta_spurr = vcpu->arch.spurr - l2_hv.spurr;
 	delta_ic = vcpu->arch.ic - l2_hv.ic;
 	delta_vtb = vc->vtb - l2_hv.vtb;
-	save_hv_return_state(vcpu, vcpu->arch.trap, &l2_hv);
+	save_hv_return_state(vcpu, &l2_hv);
 
 	/* restore L1 state */
 	vcpu->arch.nested = NULL;
-- 
2.29.2

