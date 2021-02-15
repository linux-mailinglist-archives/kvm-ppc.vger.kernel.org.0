Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD9931B56A
	for <lists+kvm-ppc@lfdr.de>; Mon, 15 Feb 2021 07:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhBOGgq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 15 Feb 2021 01:36:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41550 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229747AbhBOGgp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 15 Feb 2021 01:36:45 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11F6XSEe139088;
        Mon, 15 Feb 2021 01:36:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=iCBk1NOd0a6lSSN3rCtEoXo9dkSEZTWs7wG7GgD1Wek=;
 b=a/5wFow/6268UdBOa99nQD7j/unHpLLW1EeWKXynXTMMADzWzKrHboxVIppdHaAw5RtP
 Inr6R0fIF1r1pQGx38803g1JmSkqqZgFi0AVmi+5roCbBfRr5DxT07qb52C9guUPQaAy
 RIMeUQqvacbl3G9DIE1NPvFvidku0dweX9HAAyZkTTDDb0QeQOO5H6WmvLvQlcI7TRKE
 SsrcEZjdPoZXV0aAhdPMOUjfUuR0AvANGjqWzW9JMKfWI59Ijj9LUtTfjC+eJp9eFJvQ
 RRJmYP8ezEpkpxnYqSMkYXIoRMwTehQXQe70CI0vnowE7GDiljPG/KIDuW/6jFGflRt0 Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36qk3g116u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 01:36:00 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11F6XbSH139941;
        Mon, 15 Feb 2021 01:35:59 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36qk3g115r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 01:35:59 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11F6RVP9021136;
        Mon, 15 Feb 2021 06:35:57 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 36p6d8gsjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 06:35:57 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11F6ZsjJ38797618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Feb 2021 06:35:54 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA1B442052;
        Mon, 15 Feb 2021 06:35:53 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 390EC4204C;
        Mon, 15 Feb 2021 06:35:52 +0000 (GMT)
Received: from bharata.ibmuc.com (unknown [9.85.74.227])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Feb 2021 06:35:52 +0000 (GMT)
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     aneesh.kumar@linux.ibm.com, npiggin@gmail.com, paulus@ozlabs.org,
        mpe@ellerman.id.au, david@gibson.dropbear.id.au,
        farosas@linux.ibm.com, Bharata B Rao <bharata@linux.ibm.com>
Subject: [PATCH v4 3/3] KVM: PPC: Book3S HV: Use H_RPT_INVALIDATE in nested KVM
Date:   Mon, 15 Feb 2021 12:05:42 +0530
Message-Id: <20210215063542.3642366-4-bharata@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210215063542.3642366-1-bharata@linux.ibm.com>
References: <20210215063542.3642366-1-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-15_02:2021-02-12,2021-02-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102150056
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
index bb35490400e9..7ea5459022cb 100644
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
index 40ed4eb80adb..0ebddb615684 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -19,6 +19,7 @@
 #include <asm/pgalloc.h>
 #include <asm/pte-walk.h>
 #include <asm/reg.h>
+#include <asm/plpar_wrappers.h>
 
 static struct patb_entry *pseries_partition_tb;
 
@@ -402,8 +403,15 @@ static void kvmhv_flush_lpid(unsigned int lpid)
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

