Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0CDA858E0
	for <lists+kvm-ppc@lfdr.de>; Thu,  8 Aug 2019 06:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbfHHEG2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 8 Aug 2019 00:06:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27938 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725270AbfHHEG2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 8 Aug 2019 00:06:28 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7842HEV082007
        for <kvm-ppc@vger.kernel.org>; Thu, 8 Aug 2019 00:06:27 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2u89wu52d5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Thu, 08 Aug 2019 00:06:26 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <cclaudio@linux.ibm.com>;
        Thu, 8 Aug 2019 05:06:26 +0100
Received: from b03cxnp08028.gho.boulder.ibm.com (9.17.130.20)
        by e34.co.us.ibm.com (192.168.1.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 8 Aug 2019 05:06:23 +0100
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7846MKP65339692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Aug 2019 04:06:22 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73870C6055;
        Thu,  8 Aug 2019 04:06:22 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF198C6059;
        Thu,  8 Aug 2019 04:06:17 +0000 (GMT)
Received: from rino.ibm.com (unknown [9.85.135.60])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  8 Aug 2019 04:06:17 +0000 (GMT)
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
        Guerney Hunt <gdhh@linux.ibm.com>,
        Ryan Grimm <grimm@linux.vnet.ibm.com>
Subject: [PATCH v5 4/7] powerpc/mm: Use UV_WRITE_PATE ucall to register a PATE
Date:   Thu,  8 Aug 2019 01:05:52 -0300
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808040555.2371-1-cclaudio@linux.ibm.com>
References: <20190808040555.2371-1-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19080804-0016-0000-0000-000009D8BE26
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011569; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000287; SDB=6.01243672; UDB=6.00656084; IPR=6.01025145;
 MB=3.00028087; MTD=3.00000008; XFM=3.00000015; UTC=2019-08-08 04:06:25
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19080804-0017-0000-0000-00004457E931
Message-Id: <20190808040555.2371-5-cclaudio@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080042
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Michael Anderson <andmike@linux.ibm.com>

In ultravisor enabled systems, the ultravisor creates and maintains the
partition table in secure memory where the hypervisor cannot access, and
therefore, the hypervisor have to do the UV_WRITE_PATE ucall whenever it
wants to set a partition table entry (PATE).

This patch adds the UV_WRITE_PATE ucall and uses it to set a PATE if
ultravisor is enabled. Additionally, this also also keeps a copy of the
partition table because the nestMMU does not have access to secure
memory. Such copy has entries for nonsecure and hypervisor partition.

Signed-off-by: Michael Anderson <andmike@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
[ cclaudio: Write the PATE in HV's table before doing that in UV's ]
Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
Reviewed-by: Ryan Grimm <grimm@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/ultravisor-api.h |  5 ++
 arch/powerpc/include/asm/ultravisor.h     |  8 +++
 arch/powerpc/mm/book3s64/pgtable.c        | 60 ++++++++++++++++-------
 3 files changed, 56 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/include/asm/ultravisor-api.h b/arch/powerpc/include/asm/ultravisor-api.h
index 88ffa78f9d61..8cd49abff4f3 100644
--- a/arch/powerpc/include/asm/ultravisor-api.h
+++ b/arch/powerpc/include/asm/ultravisor-api.h
@@ -11,6 +11,7 @@
 #include <asm/hvcall.h>
 
 /* Return codes */
+#define U_BUSY			H_BUSY
 #define U_FUNCTION		H_FUNCTION
 #define U_NOT_AVAILABLE		H_NOT_AVAILABLE
 #define U_P2			H_P2
@@ -18,6 +19,10 @@
 #define U_P4			H_P4
 #define U_P5			H_P5
 #define U_PARAMETER		H_PARAMETER
+#define U_PERMISSION		H_PERMISSION
 #define U_SUCCESS		H_SUCCESS
 
+/* opcodes */
+#define UV_WRITE_PATE			0xF104
+
 #endif /* _ASM_POWERPC_ULTRAVISOR_API_H */
diff --git a/arch/powerpc/include/asm/ultravisor.h b/arch/powerpc/include/asm/ultravisor.h
index dc6e1ea198f2..6fe1f365dec8 100644
--- a/arch/powerpc/include/asm/ultravisor.h
+++ b/arch/powerpc/include/asm/ultravisor.h
@@ -8,7 +8,15 @@
 #ifndef _ASM_POWERPC_ULTRAVISOR_H
 #define _ASM_POWERPC_ULTRAVISOR_H
 
+#include <asm/asm-prototypes.h>
+#include <asm/ultravisor-api.h>
+
 int early_init_dt_scan_ultravisor(unsigned long node, const char *uname,
 				  int depth, void *data);
 
+static inline int uv_register_pate(u64 lpid, u64 dw0, u64 dw1)
+{
+	return ucall_norets(UV_WRITE_PATE, lpid, dw0, dw1);
+}
+
 #endif	/* _ASM_POWERPC_ULTRAVISOR_H */
diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
index 85bc81abd286..033731f5dbaa 100644
--- a/arch/powerpc/mm/book3s64/pgtable.c
+++ b/arch/powerpc/mm/book3s64/pgtable.c
@@ -16,6 +16,8 @@
 #include <asm/tlb.h>
 #include <asm/trace.h>
 #include <asm/powernv.h>
+#include <asm/firmware.h>
+#include <asm/ultravisor.h>
 
 #include <mm/mmu_decl.h>
 #include <trace/events/thp.h>
@@ -198,7 +200,15 @@ void __init mmu_partition_table_init(void)
 	unsigned long ptcr;
 
 	BUILD_BUG_ON_MSG((PATB_SIZE_SHIFT > 36), "Partition table size too large.");
-	/* Initialize the Partition Table with no entries */
+	/*
+	 * Initialize the Partition Table with no entries, even in the presence
+	 * of an ultravisor firmware.
+	 *
+	 * In ultravisor enabled systems, the ultravisor creates and maintains
+	 * the partition table in secure memory. However, we keep a copy of the
+	 * partition table because nestMMU cannot access secure memory. Our copy
+	 * contains entries for nonsecure and hypervisor partition.
+	 */
 	partition_tb = memblock_alloc(patb_size, patb_size);
 	if (!partition_tb)
 		panic("%s: Failed to allocate %lu bytes align=0x%lx\n",
@@ -213,34 +223,50 @@ void __init mmu_partition_table_init(void)
 	powernv_set_nmmu_ptcr(ptcr);
 }
 
-void mmu_partition_table_set_entry(unsigned int lpid, unsigned long dw0,
-				   unsigned long dw1)
+/*
+ * Global flush of TLBs and partition table caches for this lpid. The type of
+ * flush (hash or radix) depends on what the previous use of this partition ID
+ * was, not the new use.
+ */
+static void flush_partition(unsigned int lpid, unsigned long old_patb0)
 {
-	unsigned long old = be64_to_cpu(partition_tb[lpid].patb0);
-
-	partition_tb[lpid].patb0 = cpu_to_be64(dw0);
-	partition_tb[lpid].patb1 = cpu_to_be64(dw1);
-
-	/*
-	 * Global flush of TLBs and partition table caches for this lpid.
-	 * The type of flush (hash or radix) depends on what the previous
-	 * use of this partition ID was, not the new use.
-	 */
 	asm volatile("ptesync" : : : "memory");
-	if (old & PATB_HR) {
-		asm volatile(PPC_TLBIE_5(%0,%1,2,0,1) : :
+	if (old_patb0 & PATB_HR) {
+		asm volatile(PPC_TLBIE_5(%0, %1, 2, 0, 1) : :
 			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
-		asm volatile(PPC_TLBIE_5(%0,%1,2,1,1) : :
+		asm volatile(PPC_TLBIE_5(%0, %1, 2, 1, 1) : :
 			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
 		trace_tlbie(lpid, 0, TLBIEL_INVAL_SET_LPID, lpid, 2, 0, 1);
 	} else {
-		asm volatile(PPC_TLBIE_5(%0,%1,2,0,0) : :
+		asm volatile(PPC_TLBIE_5(%0, %1, 2, 0, 0) : :
 			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
 		trace_tlbie(lpid, 0, TLBIEL_INVAL_SET_LPID, lpid, 2, 0, 0);
 	}
 	/* do we need fixup here ?*/
 	asm volatile("eieio; tlbsync; ptesync" : : : "memory");
 }
+
+void mmu_partition_table_set_entry(unsigned int lpid, unsigned long dw0,
+				  unsigned long dw1)
+{
+	unsigned long old = be64_to_cpu(partition_tb[lpid].patb0);
+
+	partition_tb[lpid].patb0 = cpu_to_be64(dw0);
+	partition_tb[lpid].patb1 = cpu_to_be64(dw1);
+
+	/*
+	 * In ultravisor enabled systems, the ultravisor maintains the partition
+	 * table in secure memory where we don't have access, therefore, we have
+	 * to do a ucall to set an entry.
+	 */
+	if (firmware_has_feature(FW_FEATURE_ULTRAVISOR)) {
+		uv_register_pate(lpid, dw0, dw1);
+		pr_info("PATE registered by ultravisor: dw0 = 0x%lx, dw1 = 0x%lx\n",
+			dw0, dw1);
+	} else {
+		flush_partition(lpid, old);
+	}
+}
 EXPORT_SYMBOL_GPL(mmu_partition_table_set_entry);
 
 static pmd_t *get_pmd_from_cache(struct mm_struct *mm)
-- 
2.20.1

