Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401DE373EDC
	for <lists+kvm-ppc@lfdr.de>; Wed,  5 May 2021 17:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbhEEPsM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 5 May 2021 11:48:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19340 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232410AbhEEPsM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 5 May 2021 11:48:12 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 145FYAA1039387;
        Wed, 5 May 2021 11:47:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=z9Vh5oqfjNcaQ4+yibQumCzEi+6NffoQB0vFEodl8U4=;
 b=Q2KiSjxES6Cpfxozqu+gXZLFJQLUEG4Bkq8MnXcqwRitEX7SZy5lF3nzzhNehodL5sze
 0qgyv+u2+8vSzJXuTiDvHPGPYbfmFHIcYCXmuEUuUZ5Cuj7PmwGnvub4FeJCJ1Kc8f8h
 FSzckN6r8bkx3hO6/b+I/1cHTZxBDp9xQ90puOQzxlc5FDayQL8/wM+/dVRQEH8S+I1v
 zHmJqPGzwIggrJfhz2yI8RR/mmHwituMK0iCUApwyHmc70Tv8t5KunKE9XzVViqod+f3
 ypAh0fH2fNf2OfVauT3NP5w+tLPU2vIC9+HfTWbQQZfEIdVX6sKxct2nIAGATifQ2Yvv vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38bum4wnb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 11:47:06 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 145FYILf040297;
        Wed, 5 May 2021 11:47:05 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38bum4wnap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 11:47:05 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 145FcdYu020416;
        Wed, 5 May 2021 15:47:04 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 38bee2g7ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 15:47:03 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 145Fl0O351511732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 May 2021 15:47:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC695AE04D;
        Wed,  5 May 2021 15:47:00 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10D7CAE045;
        Wed,  5 May 2021 15:46:59 +0000 (GMT)
Received: from bharata.ibmuc.com (unknown [9.85.85.70])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 May 2021 15:46:58 +0000 (GMT)
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     aneesh.kumar@linux.ibm.com, npiggin@gmail.com, paulus@ozlabs.org,
        mpe@ellerman.id.au, david@gibson.dropbear.id.au,
        farosas@linux.ibm.com, Bharata B Rao <bharata@linux.ibm.com>
Subject: [PATCH v7 6/6] KVM: PPC: Book3S HV: Use H_RPT_INVALIDATE in nested KVM
Date:   Wed,  5 May 2021 21:16:42 +0530
Message-Id: <20210505154642.178702-7-bharata@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210505154642.178702-1-bharata@linux.ibm.com>
References: <20210505154642.178702-1-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kWb9nHgEba737jpB4RTFJUrDbfm_Y1Db
X-Proofpoint-GUID: iVOE45iPYzmJyD2EU5C1NXc7HAIm2dbp
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-05_09:2021-05-05,2021-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050112
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

In the nested KVM case, replace H_TLB_INVALIDATE by the new hcall
H_RPT_INVALIDATE if available. The availability of this hcall
is determined from "hcall-rpt-invalidate" string in ibm,hypertas-functions
DT property.

Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Reviewed-by: David Gibson <david@gibson.dropbear.id.au>
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 27 +++++++++++++++++++++-----
 arch/powerpc/kvm/book3s_hv_nested.c    | 12 ++++++++++--
 2 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index ec4f58fa9f5a..6980f8ef08f9 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -21,6 +21,7 @@
 #include <asm/pte-walk.h>
 #include <asm/ultravisor.h>
 #include <asm/kvm_book3s_uvmem.h>
+#include <asm/plpar_wrappers.h>
 
 /*
  * Supported radix tree geometry.
@@ -318,9 +319,19 @@ void kvmppc_radix_tlbie_page(struct kvm *kvm, unsigned long addr,
 	}
 
 	psi = shift_to_mmu_psize(pshift);
-	rb = addr | (mmu_get_ap(psi) << PPC_BITLSHIFT(58));
-	rc = plpar_hcall_norets(H_TLB_INVALIDATE, H_TLBIE_P1_ENC(0, 0, 1),
-				lpid, rb);
+
+	if (!firmware_has_feature(FW_FEATURE_RPT_INVALIDATE)) {
+		rb = addr | (mmu_get_ap(psi) << PPC_BITLSHIFT(58));
+		rc = plpar_hcall_norets(H_TLB_INVALIDATE, H_TLBIE_P1_ENC(0, 0, 1),
+					lpid, rb);
+	} else {
+		rc = pseries_rpt_invalidate(lpid, H_RPTI_TARGET_CMMU,
+					    H_RPTI_TYPE_NESTED |
+					    H_RPTI_TYPE_TLB,
+					    psize_to_rpti_pgsize(psi),
+					    addr, addr + psize);
+	}
+
 	if (rc)
 		pr_err("KVM: TLB page invalidation hcall failed, rc=%ld\n", rc);
 }
@@ -334,8 +345,14 @@ static void kvmppc_radix_flush_pwc(struct kvm *kvm, unsigned int lpid)
 		return;
 	}
 
-	rc = plpar_hcall_norets(H_TLB_INVALIDATE, H_TLBIE_P1_ENC(1, 0, 1),
-				lpid, TLBIEL_INVAL_SET_LPID);
+	if (!firmware_has_feature(FW_FEATURE_RPT_INVALIDATE))
+		rc = plpar_hcall_norets(H_TLB_INVALIDATE, H_TLBIE_P1_ENC(1, 0, 1),
+					lpid, TLBIEL_INVAL_SET_LPID);
+	else
+		rc = pseries_rpt_invalidate(lpid, H_RPTI_TARGET_CMMU,
+					    H_RPTI_TYPE_NESTED |
+					    H_RPTI_TYPE_PWC, H_RPTI_PAGE_ALL,
+					    0, -1UL);
 	if (rc)
 		pr_err("KVM: TLB PWC invalidation hcall failed, rc=%ld\n", rc);
 }
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 91f10290130d..d1529251b078 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -19,6 +19,7 @@
 #include <asm/pgalloc.h>
 #include <asm/pte-walk.h>
 #include <asm/reg.h>
+#include <asm/plpar_wrappers.h>
 
 static struct patb_entry *pseries_partition_tb;
 
@@ -467,8 +468,15 @@ static void kvmhv_flush_lpid(unsigned int lpid)
 		return;
 	}
 
-	rc = plpar_hcall_norets(H_TLB_INVALIDATE, H_TLBIE_P1_ENC(2, 0, 1),
-				lpid, TLBIEL_INVAL_SET_LPID);
+	if (!firmware_has_feature(FW_FEATURE_RPT_INVALIDATE))
+		rc = plpar_hcall_norets(H_TLB_INVALIDATE, H_TLBIE_P1_ENC(2, 0, 1),
+					lpid, TLBIEL_INVAL_SET_LPID);
+	else
+		rc = pseries_rpt_invalidate(lpid, H_RPTI_TARGET_CMMU,
+					    H_RPTI_TYPE_NESTED |
+					    H_RPTI_TYPE_TLB | H_RPTI_TYPE_PWC |
+					    H_RPTI_TYPE_PAT,
+					    H_RPTI_PAGE_ALL, 0, -1UL);
 	if (rc)
 		pr_err("KVM: TLB LPID invalidation hcall failed, rc=%ld\n", rc);
 }
-- 
2.26.2

