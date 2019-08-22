Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5D70989FB
	for <lists+kvm-ppc@lfdr.de>; Thu, 22 Aug 2019 05:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730646AbfHVDtH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 21 Aug 2019 23:49:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53750 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730638AbfHVDtH (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 21 Aug 2019 23:49:07 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7M3kekn039089;
        Wed, 21 Aug 2019 23:49:04 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uhg8gn8ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Aug 2019 23:49:03 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7M3iToW025670;
        Thu, 22 Aug 2019 03:49:02 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 2ue9770m60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Aug 2019 03:49:02 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7M3n1QT45089066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 03:49:01 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3FCAC6055;
        Thu, 22 Aug 2019 03:49:00 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A109C6057;
        Thu, 22 Aug 2019 03:48:57 +0000 (GMT)
Received: from rino.ibm.com (unknown [9.80.203.17])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 22 Aug 2019 03:48:57 +0000 (GMT)
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
Subject: [PATCH v6 4/7] powerpc/mm: Use UV_WRITE_PATE ucall to register a PATE
Date:   Thu, 22 Aug 2019 00:48:35 -0300
Message-Id: <20190822034838.27876-5-cclaudio@linux.ibm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822034838.27876-1-cclaudio@linux.ibm.com>
References: <20190822034838.27876-1-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-22_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908220037
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Michael Anderson <andmike@linux.ibm.com>

When Ultravisor (UV) is enabled, the partition table is stored in secure
memory and can only be accessed via the UV. The Hypervisor (HV) however
maintains a copy of the partition table in normal memory to allow Nest MMU
translations to occur (for normal VMs). The HV copy includes partition
table entries (PATE)s for secure VMs which would currently be unused
(Nest MMU translations cannot access secure memory) but they would be
needed as we add functionality.

This patch adds the UV_WRITE_PATE ucall which is used to update the PATE
for a VM (both normal and secure) when Ultravisor is enabled.

Signed-off-by: Michael Anderson <andmike@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
[ cclaudio: Write the PATE in HV's table before doing that in UV's ]
Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
Reviewed-by: Ryan Grimm <grimm@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/ultravisor-api.h |  5 +++
 arch/powerpc/include/asm/ultravisor.h     |  8 ++++
 arch/powerpc/mm/book3s64/pgtable.c        | 50 +++++++++++++++++------
 3 files changed, 50 insertions(+), 13 deletions(-)

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
index 7d0e0d0d22c4..4173f6931009 100644
--- a/arch/powerpc/mm/book3s64/pgtable.c
+++ b/arch/powerpc/mm/book3s64/pgtable.c
@@ -12,6 +12,8 @@
 #include <asm/tlb.h>
 #include <asm/trace.h>
 #include <asm/powernv.h>
+#include <asm/firmware.h>
+#include <asm/ultravisor.h>
 
 #include <mm/mmu_decl.h>
 #include <trace/events/thp.h>
@@ -209,21 +211,10 @@ void __init mmu_partition_table_init(void)
 	powernv_set_nmmu_ptcr(ptcr);
 }
 
-void mmu_partition_table_set_entry(unsigned int lpid, unsigned long dw0,
-				   unsigned long dw1)
+static void flush_partition(unsigned int lpid, bool radix)
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
+	if (radix) {
 		asm volatile(PPC_TLBIE_5(%0,%1,2,0,1) : :
 			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
 		asm volatile(PPC_TLBIE_5(%0,%1,2,1,1) : :
@@ -237,6 +228,39 @@ void mmu_partition_table_set_entry(unsigned int lpid, unsigned long dw0,
 	/* do we need fixup here ?*/
 	asm volatile("eieio; tlbsync; ptesync" : : : "memory");
 }
+
+void mmu_partition_table_set_entry(unsigned int lpid, unsigned long dw0,
+				  unsigned long dw1)
+{
+	unsigned long old = be64_to_cpu(partition_tb[lpid].patb0);
+
+	/*
+	 * When ultravisor is enabled, the partition table is stored in secure
+	 * memory and can only be accessed doing an ultravisor call. However, we
+	 * maintain a copy of the partition table in normal memory to allow Nest
+	 * MMU translations to occur (for normal VMs).
+	 *
+	 * Therefore, here we always update partition_tb, regardless of whether
+	 * we are running under an ultravisor or not.
+	 */
+	partition_tb[lpid].patb0 = cpu_to_be64(dw0);
+	partition_tb[lpid].patb1 = cpu_to_be64(dw1);
+
+	/*
+	 * If ultravisor is enabled, we do an ultravisor call to register the
+	 * partition table entry (PATE), which also do a global flush of TLBs
+	 * and partition table caches for the lpid. Otherwise, just do the
+	 * flush. The type of flush (hash or radix) depends on what the previous
+	 * use of the partition ID was, not the new use.
+	 */
+	if (firmware_has_feature(FW_FEATURE_ULTRAVISOR)) {
+		uv_register_pate(lpid, dw0, dw1);
+		pr_info("PATE registered by ultravisor: dw0 = 0x%lx, dw1 = 0x%lx\n",
+			dw0, dw1);
+	} else {
+		flush_partition(lpid, (old & PATB_HR));
+	}
+}
 EXPORT_SYMBOL_GPL(mmu_partition_table_set_entry);
 
 static pmd_t *get_pmd_from_cache(struct mm_struct *mm)
-- 
2.20.1

