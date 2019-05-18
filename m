Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A8F223AD
	for <lists+kvm-ppc@lfdr.de>; Sat, 18 May 2019 16:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbfERO0D (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 18 May 2019 10:26:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36892 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729603AbfERO0D (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 18 May 2019 10:26:03 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4IEGXfJ076897
        for <kvm-ppc@vger.kernel.org>; Sat, 18 May 2019 10:26:02 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sjk6u8vxn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Sat, 18 May 2019 10:26:02 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <cclaudio@linux.ibm.com>;
        Sat, 18 May 2019 15:26:01 +0100
Received: from b03cxnp07029.gho.boulder.ibm.com (9.17.130.16)
        by e31.co.us.ibm.com (192.168.1.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 18 May 2019 15:25:59 +0100
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4IEPw4d64684096
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 May 2019 14:25:58 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17ECF7805E;
        Sat, 18 May 2019 14:25:58 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E42C7805C;
        Sat, 18 May 2019 14:25:55 +0000 (GMT)
Received: from rino.ibm.com (unknown [9.85.168.40])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 18 May 2019 14:25:55 +0000 (GMT)
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
Subject: [RFC PATCH v2 09/10] KVM: PPC: Book3S HV: Fixed for running secure guests
Date:   Sat, 18 May 2019 11:25:23 -0300
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190518142524.28528-1-cclaudio@linux.ibm.com>
References: <20190518142524.28528-1-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19051814-8235-0000-0000-00000E9900B1
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011118; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01205121; UDB=6.00632701; IPR=6.00986061;
 MB=3.00026948; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-18 14:26:01
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051814-8236-0000-0000-0000459E050A
Message-Id: <20190518142524.28528-10-cclaudio@linux.ibm.com>
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

From: Paul Mackerras <paulus@ozlabs.org>

- Pass SRR1 in r11 for UV_RETURN because SRR0 and SRR1 get set by
  the sc 2 instruction. (Note r3 - r10 potentially have hcall return
  values in them.)

- Fix kvmppc_msr_interrupt to preserve the MSR_S bit.

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index d89efa0783a2..1b44c85956b9 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -1160,6 +1160,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 ret_to_ultra:
 	lwz	r6, VCPU_CR(r4)
 	mtcr	r6
+	mfspr	r11, SPRN_SRR1
 	LOAD_REG_IMMEDIATE(r0, UV_RETURN)
 	ld	r7, VCPU_GPR(R7)(r4)
 	ld	r6, VCPU_GPR(R6)(r4)
@@ -3360,13 +3361,16 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_TYPE_RADIX)
  *   r0 is used as a scratch register
  */
 kvmppc_msr_interrupt:
+	andis.	r0, r11, MSR_S@h
 	rldicl	r0, r11, 64 - MSR_TS_S_LG, 62
-	cmpwi	r0, 2 /* Check if we are in transactional state..  */
+	cmpwi	cr1, r0, 2 /* Check if we are in transactional state..  */
 	ld	r11, VCPU_INTR_MSR(r9)
-	bne	1f
+	bne	cr1, 1f
 	/* ... if transactional, change to suspended */
 	li	r0, 1
 1:	rldimi	r11, r0, MSR_TS_S_LG, 63 - MSR_TS_T_LG
+	beqlr
+	oris	r11, r11, MSR_S@h		/* preserve MSR_S bit setting */
 	blr
 
 /*
-- 
2.20.1

