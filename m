Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9E0336DFA
	for <lists+kvm-ppc@lfdr.de>; Thu, 11 Mar 2021 09:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhCKIkN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 11 Mar 2021 03:40:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55786 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231394AbhCKIkN (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 11 Mar 2021 03:40:13 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12B8XTXN113440;
        Thu, 11 Mar 2021 03:40:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=IAB5cHQIHTZ9T+HsNpvuMHgls6VRZjanwMK8HpeUQGo=;
 b=frx640jnEli6RyvUSq6xTFK1F+NKlQqZzUyTAhZ7j3h7904EJGH0sXGwYh0FvrNqO9x/
 pQMx2uOJ8yX0sAI3E+hzXeIqrdZxUJWTar71fNmA/uF5XMxzHcBHLS9HIU/ihAMWtM3J
 vwochkCd9IqzgU+YEk6NBN6XpsVekak+DvfhRkpYItp2wOrd6pwKzGbOgamZyN72yU3J
 mBEsuE5NXTNa+Gh8sMDkMTLUUpHvIRZXc2pHow/Aut8xaofJ/ZXSdVQ7tQ3oin8Vp/Yk
 DGNMgVZ7YlGoDX8x+SniNJ0RFyQp2Ib+el5TN3JVkBOjqwuOSO4T8w2xdF1cd/R7z2ht yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3774m0yu3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 03:40:04 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12B8ZNfZ118411;
        Thu, 11 Mar 2021 03:40:04 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3774m0yu1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 03:40:04 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12B8ZWk8008645;
        Thu, 11 Mar 2021 08:40:02 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 376aqsruxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 08:40:02 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12B8dx4B58392888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Mar 2021 08:39:59 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F91452051;
        Thu, 11 Mar 2021 08:39:59 +0000 (GMT)
Received: from bharata.ibmuc.com (unknown [9.77.205.2])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6048952069;
        Thu, 11 Mar 2021 08:39:57 +0000 (GMT)
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     aneesh.kumar@linux.ibm.com, npiggin@gmail.com, paulus@ozlabs.org,
        mpe@ellerman.id.au, david@gibson.dropbear.id.au,
        farosas@linux.ibm.com, Bharata B Rao <bharata@linux.ibm.com>
Subject: [PATCH v6 6/6] KVM: PPC: Book3S HV: Use H_RPT_INVALIDATE in nested KVM
Date:   Thu, 11 Mar 2021 14:09:39 +0530
Message-Id: <20210311083939.595568-7-bharata@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210311083939.595568-1-bharata@linux.ibm.com>
References: <20210311083939.595568-1-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-11_02:2021-03-10,2021-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 clxscore=1015 suspectscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103110047
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

In the nested KVM case, replace H_TLB_INVALIDATE by the new hcall
H_RPT_INVALIDATE if available. The availability of this hcall
is determined from "hcall-rpt-invalidate" string in ibm,hypertas-functions
DT property.

Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 27 +++++++++++++++++++++-----
 arch/powerpc/kvm/book3s_hv_nested.c    | 12 ++++++++++--
 2 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index e603de7ade52..1e1e55fd0ee5 100644
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
index adcc8e26ef22..5601b7eb9b89 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -19,6 +19,7 @@
 #include <asm/pgalloc.h>
 #include <asm/pte-walk.h>
 #include <asm/reg.h>
+#include <asm/plpar_wrappers.h>
 
 static struct patb_entry *pseries_partition_tb;
 
@@ -444,8 +445,15 @@ static void kvmhv_flush_lpid(unsigned int lpid)
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

