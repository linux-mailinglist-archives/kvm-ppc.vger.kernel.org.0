Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBC5144B6F
	for <lists+kvm-ppc@lfdr.de>; Wed, 22 Jan 2020 06:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgAVFvD (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 22 Jan 2020 00:51:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27912 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725796AbgAVFvD (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 22 Jan 2020 00:51:03 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00M5lRnF149464;
        Wed, 22 Jan 2020 00:50:57 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xkwq8ktyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jan 2020 00:50:57 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 00M5lPZ0006575;
        Wed, 22 Jan 2020 05:50:56 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02dal.us.ibm.com with ESMTP id 2xksn72wv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jan 2020 05:50:56 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00M5otAL11338328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jan 2020 05:50:55 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C31CFAE060;
        Wed, 22 Jan 2020 05:50:55 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34509AE05C;
        Wed, 22 Jan 2020 05:50:55 +0000 (GMT)
Received: from suka-w540.usor.ibm.com (unknown [9.70.94.45])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 22 Jan 2020 05:50:55 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>, linuxram@us.ibm.com,
        maddy@linux.ibm.com
Cc:     linuxppc-dev@ozlabs.org, kvm-ppc@vger.kernel.org
Subject: [PATCH v4 1/2] powerpc/pseries/svm: Use FW_FEATURE to detect SVM
Date:   Tue, 21 Jan 2020 21:50:53 -0800
Message-Id: <20200122055054.6482-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.17.2
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_05:2020-01-16,2020-01-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001220051
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Use FW_FEATURE_SVM to detect a secure guest (SVM). This would be
more efficient than calling mfmsr() frequently.

Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 arch/powerpc/include/asm/firmware.h       | 3 ++-
 arch/powerpc/include/asm/svm.h            | 6 +++++-
 arch/powerpc/kernel/paca.c                | 6 +++++-
 arch/powerpc/platforms/pseries/firmware.c | 3 +++
 4 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/firmware.h b/arch/powerpc/include/asm/firmware.h
index b3e214a97f3a..23cffcec8a55 100644
--- a/arch/powerpc/include/asm/firmware.h
+++ b/arch/powerpc/include/asm/firmware.h
@@ -51,6 +51,7 @@
 #define FW_FEATURE_BLOCK_REMOVE ASM_CONST(0x0000001000000000)
 #define FW_FEATURE_PAPR_SCM 	ASM_CONST(0x0000002000000000)
 #define FW_FEATURE_ULTRAVISOR	ASM_CONST(0x0000004000000000)
+#define FW_FEATURE_SVM		ASM_CONST(0x0000008000000000)
 
 #ifndef __ASSEMBLY__
 
@@ -69,7 +70,7 @@ enum {
 		FW_FEATURE_TYPE1_AFFINITY | FW_FEATURE_PRRN |
 		FW_FEATURE_HPT_RESIZE | FW_FEATURE_DRMEM_V2 |
 		FW_FEATURE_DRC_INFO | FW_FEATURE_BLOCK_REMOVE |
-		FW_FEATURE_PAPR_SCM | FW_FEATURE_ULTRAVISOR,
+		FW_FEATURE_PAPR_SCM | FW_FEATURE_ULTRAVISOR | FW_FEATURE_SVM,
 	FW_FEATURE_PSERIES_ALWAYS = 0,
 	FW_FEATURE_POWERNV_POSSIBLE = FW_FEATURE_OPAL | FW_FEATURE_ULTRAVISOR,
 	FW_FEATURE_POWERNV_ALWAYS = 0,
diff --git a/arch/powerpc/include/asm/svm.h b/arch/powerpc/include/asm/svm.h
index 85580b30aba4..1d056c70fa87 100644
--- a/arch/powerpc/include/asm/svm.h
+++ b/arch/powerpc/include/asm/svm.h
@@ -10,9 +10,13 @@
 
 #ifdef CONFIG_PPC_SVM
 
+/*
+ * Note that this is not usable in early boot - before FW
+ * features were probed
+ */
 static inline bool is_secure_guest(void)
 {
-	return mfmsr() & MSR_S;
+	return firmware_has_feature(FW_FEATURE_SVM);
 }
 
 void dtl_cache_ctor(void *addr);
diff --git a/arch/powerpc/kernel/paca.c b/arch/powerpc/kernel/paca.c
index 949eceb254d8..3cba33a99549 100644
--- a/arch/powerpc/kernel/paca.c
+++ b/arch/powerpc/kernel/paca.c
@@ -120,7 +120,11 @@ static struct lppaca * __init new_lppaca(int cpu, unsigned long limit)
 	if (early_cpu_has_feature(CPU_FTR_HVMODE))
 		return NULL;
 
-	if (is_secure_guest())
+	/*
+	 * Firmware features may not have been probed yet, so check
+	 * MSR rather than FW_FEATURE_SVM in is_secure_guest().
+	 */
+	if (mfmsr() & MSR_S)
 		lp = alloc_shared_lppaca(LPPACA_SIZE, 0x400, limit, cpu);
 	else
 		lp = alloc_paca_data(LPPACA_SIZE, 0x400, limit, cpu);
diff --git a/arch/powerpc/platforms/pseries/firmware.c b/arch/powerpc/platforms/pseries/firmware.c
index d4a8f1702417..c98527fb4937 100644
--- a/arch/powerpc/platforms/pseries/firmware.c
+++ b/arch/powerpc/platforms/pseries/firmware.c
@@ -175,4 +175,7 @@ static int __init probe_fw_features(unsigned long node, const char *uname, int
 void __init pseries_probe_fw_features(void)
 {
 	of_scan_flat_dt(probe_fw_features, NULL);
+
+	if (mfmsr() & MSR_S)
+		powerpc_firmware_features |= FW_FEATURE_SVM;
 }
-- 
2.17.2

