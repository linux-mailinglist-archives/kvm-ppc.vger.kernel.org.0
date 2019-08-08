Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6643D858E1
	for <lists+kvm-ppc@lfdr.de>; Thu,  8 Aug 2019 06:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbfHHEGd (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 8 Aug 2019 00:06:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53352 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725270AbfHHEGd (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 8 Aug 2019 00:06:33 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7842HL1069025;
        Thu, 8 Aug 2019 00:06:29 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2u8a54ck3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 00:06:29 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7844aqC021409;
        Thu, 8 Aug 2019 04:06:28 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 2u51w74hvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 04:06:28 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7846Qwi34144536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Aug 2019 04:06:27 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D609CC6057;
        Thu,  8 Aug 2019 04:06:26 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38F75C6055;
        Thu,  8 Aug 2019 04:06:23 +0000 (GMT)
Received: from rino.ibm.com (unknown [9.85.135.60])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  8 Aug 2019 04:06:22 +0000 (GMT)
From:   Claudio Carvalho <cclaudio@linux.ibm.com>
To:     linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>,
        Guerney Hunt <gdhh@linux.ibm.com>
Subject: [PATCH v5 5/7] powerpc/mm: Write to PTCR only if ultravisor disabled
Date:   Thu,  8 Aug 2019 01:05:53 -0300
Message-Id: <20190808040555.2371-6-cclaudio@linux.ibm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808040555.2371-1-cclaudio@linux.ibm.com>
References: <20190808040555.2371-1-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=944 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080042
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

In ultravisor enabled systems, PTCR becomes ultravisor privileged only
for writing and an attempt to write to it will cause a Hypervisor
Emulation Assitance interrupt.

This patch adds the try_set_ptcr(val) macro as an accessor to
mtspr(SPRN_PTCR, val), which will be executed only if ultravisor
disabled.

Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
---
 arch/powerpc/include/asm/reg.h           | 13 +++++++++++++
 arch/powerpc/mm/book3s64/hash_utils.c    |  4 ++--
 arch/powerpc/mm/book3s64/pgtable.c       |  2 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c |  6 +++---
 4 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index 10caa145f98b..14139b1ebdb8 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -15,6 +15,7 @@
 #include <asm/cputable.h>
 #include <asm/asm-const.h>
 #include <asm/feature-fixups.h>
+#include <asm/firmware.h>
 
 /* Pickup Book E specific registers. */
 #if defined(CONFIG_BOOKE) || defined(CONFIG_40x)
@@ -1452,6 +1453,18 @@ static inline void update_power8_hid0(unsigned long hid0)
 	 */
 	asm volatile("sync; mtspr %0,%1; isync":: "i"(SPRN_HID0), "r"(hid0));
 }
+
+/*
+ * In ultravisor enabled systems, PTCR becomes ultravisor privileged only for
+ * writing and an attempt to write to it will cause a Hypervisor Emulation
+ * Assistance interrupt.
+ */
+#define try_set_ptcr(val)						\
+	do {								\
+		if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))	\
+			mtspr(SPRN_PTCR, val);				\
+	} while (0)
+
 #endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_REG_H */
diff --git a/arch/powerpc/mm/book3s64/hash_utils.c b/arch/powerpc/mm/book3s64/hash_utils.c
index 25a2cf32d544..048b7f58deae 100644
--- a/arch/powerpc/mm/book3s64/hash_utils.c
+++ b/arch/powerpc/mm/book3s64/hash_utils.c
@@ -1079,8 +1079,8 @@ void hash__early_init_mmu_secondary(void)
 		if (!cpu_has_feature(CPU_FTR_ARCH_300))
 			mtspr(SPRN_SDR1, _SDR1);
 		else
-			mtspr(SPRN_PTCR,
-			      __pa(partition_tb) | (PATB_SIZE_SHIFT - 12));
+			try_set_ptcr(__pa(partition_tb) |
+				     (PATB_SIZE_SHIFT - 12));
 	}
 	/* Initialize SLB */
 	slb_initialize();
diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
index 033731f5dbaa..016c6ccb5b81 100644
--- a/arch/powerpc/mm/book3s64/pgtable.c
+++ b/arch/powerpc/mm/book3s64/pgtable.c
@@ -219,7 +219,7 @@ void __init mmu_partition_table_init(void)
 	 * 64 K size.
 	 */
 	ptcr = __pa(partition_tb) | (PATB_SIZE_SHIFT - 12);
-	mtspr(SPRN_PTCR, ptcr);
+	try_set_ptcr(ptcr);
 	powernv_set_nmmu_ptcr(ptcr);
 }
 
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index e92c6472a20c..246b32550eab 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -654,8 +654,8 @@ void radix__early_init_mmu_secondary(void)
 		lpcr = mfspr(SPRN_LPCR);
 		mtspr(SPRN_LPCR, lpcr | LPCR_UPRT | LPCR_HR);
 
-		mtspr(SPRN_PTCR,
-		      __pa(partition_tb) | (PATB_SIZE_SHIFT - 12));
+		try_set_ptcr(__pa(partition_tb) | (PATB_SIZE_SHIFT - 12));
+
 		radix_init_amor();
 	}
 
@@ -671,7 +671,7 @@ void radix__mmu_cleanup_all(void)
 	if (!firmware_has_feature(FW_FEATURE_LPAR)) {
 		lpcr = mfspr(SPRN_LPCR);
 		mtspr(SPRN_LPCR, lpcr & ~LPCR_UPRT);
-		mtspr(SPRN_PTCR, 0);
+		try_set_ptcr(0);
 		powernv_set_nmmu_ptcr(0);
 		radix__flush_tlb_all();
 	}
-- 
2.20.1

