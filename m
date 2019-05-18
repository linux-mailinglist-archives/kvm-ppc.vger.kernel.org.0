Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 201D4223A9
	for <lists+kvm-ppc@lfdr.de>; Sat, 18 May 2019 16:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729569AbfEROZv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 18 May 2019 10:25:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60214 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727594AbfEROZv (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 18 May 2019 10:25:51 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4IEGZRG114724
        for <kvm-ppc@vger.kernel.org>; Sat, 18 May 2019 10:25:50 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sje4k8qm8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Sat, 18 May 2019 10:25:50 -0400
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <cclaudio@linux.ibm.com>;
        Sat, 18 May 2019 15:25:49 +0100
Received: from b03cxnp07028.gho.boulder.ibm.com (9.17.130.15)
        by e32.co.us.ibm.com (192.168.1.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 18 May 2019 15:25:46 +0100
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4IEPj0p5570858
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 May 2019 14:25:45 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35D2B7805C;
        Sat, 18 May 2019 14:25:45 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 349467805E;
        Sat, 18 May 2019 14:25:42 +0000 (GMT)
Received: from rino.ibm.com (unknown [9.85.168.40])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 18 May 2019 14:25:41 +0000 (GMT)
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
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Ryan Grimm <grimm@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 05/10] KVM: PPC: Ultravisor: Use UV_WRITE_PATE ucall to register a PATE
Date:   Sat, 18 May 2019 11:25:19 -0300
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190518142524.28528-1-cclaudio@linux.ibm.com>
References: <20190518142524.28528-1-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19051814-0004-0000-0000-000015106A49
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011118; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01205121; UDB=6.00632701; IPR=6.00986061;
 MB=3.00026949; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-18 14:25:48
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051814-0005-0000-0000-00008BB5D2F4
Message-Id: <20190518142524.28528-6-cclaudio@linux.ibm.com>
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

From: Michael Anderson <andmike@linux.ibm.com>

When running under an ultravisor, the ultravisor controls the real
partition table and has it in secure memory where the hypervisor can't
access it, and therefore we (the HV) have to do a ucall whenever we want
to update an entry.

The HV still keeps a copy of its view of the partition table in normal
memory so that the nest MMU can access it.

Both partition tables will have PATE entries for HV and normal virtual
machines.

Suggested-by: Ryan Grimm <grimm@linux.vnet.ibm.com>
Signed-off-by: Michael Anderson <andmike@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
[Write the pate in HV's table before doing that in UV's]
Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
---
 arch/powerpc/include/asm/ultravisor-api.h |  5 +++-
 arch/powerpc/include/asm/ultravisor.h     |  9 ++++++
 arch/powerpc/mm/book3s64/hash_utils.c     |  3 +-
 arch/powerpc/mm/book3s64/pgtable.c        | 34 +++++++++++++++++++++--
 arch/powerpc/mm/book3s64/radix_pgtable.c  |  9 ++++--
 5 files changed, 52 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/ultravisor-api.h b/arch/powerpc/include/asm/ultravisor-api.h
index 5f538f33c704..24bfb4c1737e 100644
--- a/arch/powerpc/include/asm/ultravisor-api.h
+++ b/arch/powerpc/include/asm/ultravisor-api.h
@@ -15,6 +15,9 @@
 #define U_SUCCESS		H_SUCCESS
 #define U_FUNCTION		H_FUNCTION
 #define U_PARAMETER		H_PARAMETER
+#define U_PERMISSION		H_PERMISSION
 
-#endif /* _ASM_POWERPC_ULTRAVISOR_API_H */
+/* opcodes */
+#define UV_WRITE_PATE			0xF104
 
+#endif /* _ASM_POWERPC_ULTRAVISOR_API_H */
diff --git a/arch/powerpc/include/asm/ultravisor.h b/arch/powerpc/include/asm/ultravisor.h
index e8abc1bbc194..4ffec7a36acd 100644
--- a/arch/powerpc/include/asm/ultravisor.h
+++ b/arch/powerpc/include/asm/ultravisor.h
@@ -12,6 +12,8 @@
 
 #if !defined(__ASSEMBLY__)
 
+#include <linux/types.h>
+
 /* Internal functions */
 extern int early_init_dt_scan_ultravisor(unsigned long node, const char *uname,
 					 int depth, void *data);
@@ -35,6 +37,13 @@ static long ucall(unsigned long opcode, unsigned long *retbuf, ...)
 }
 #endif
 
+static inline int uv_register_pate(u64 lpid, u64 dw0, u64 dw1)
+{
+	unsigned long retbuf[UCALL_BUFSIZE];
+
+	return ucall(UV_WRITE_PATE, retbuf, lpid, dw0, dw1);
+}
+
 #endif /* !__ASSEMBLY__ */
 
 #endif	/* _ASM_POWERPC_ULTRAVISOR_H */
diff --git a/arch/powerpc/mm/book3s64/hash_utils.c b/arch/powerpc/mm/book3s64/hash_utils.c
index 919a861a8ec0..8419e665fab0 100644
--- a/arch/powerpc/mm/book3s64/hash_utils.c
+++ b/arch/powerpc/mm/book3s64/hash_utils.c
@@ -1080,9 +1080,10 @@ void hash__early_init_mmu_secondary(void)
 
 		if (!cpu_has_feature(CPU_FTR_ARCH_300))
 			mtspr(SPRN_SDR1, _SDR1);
-		else
+		else if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
 			mtspr(SPRN_PTCR,
 			      __pa(partition_tb) | (PATB_SIZE_SHIFT - 12));
+
 	}
 	/* Initialize SLB */
 	slb_initialize();
diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
index 16bda049187a..40a9fc8b139f 100644
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
@@ -206,12 +208,25 @@ void __init mmu_partition_table_init(void)
 	 * 64 K size.
 	 */
 	ptcr = __pa(partition_tb) | (PATB_SIZE_SHIFT - 12);
-	mtspr(SPRN_PTCR, ptcr);
+	/*
+	 * If ultravisor is available, it is responsible for creating and
+	 * managing partition table
+	 */
+	if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
+		mtspr(SPRN_PTCR, ptcr);
+
+	/*
+	 * Since nestMMU cannot access secure memory. Create
+	 * and manage our own partition table. This table
+	 * contains entries for nonsecure and hypervisor
+	 * partition.
+	 */
 	powernv_set_nmmu_ptcr(ptcr);
 }
 
-void mmu_partition_table_set_entry(unsigned int lpid, unsigned long dw0,
-				   unsigned long dw1)
+static void __mmu_partition_table_set_entry(unsigned int lpid,
+					    unsigned long dw0,
+					    unsigned long dw1)
 {
 	unsigned long old = be64_to_cpu(partition_tb[lpid].patb0);
 
@@ -238,6 +253,19 @@ void mmu_partition_table_set_entry(unsigned int lpid, unsigned long dw0,
 	/* do we need fixup here ?*/
 	asm volatile("eieio; tlbsync; ptesync" : : : "memory");
 }
+
+void mmu_partition_table_set_entry(unsigned int lpid, unsigned long dw0,
+				  unsigned long dw1)
+{
+	__mmu_partition_table_set_entry(lpid, dw0, dw1);
+
+	if (firmware_has_feature(FW_FEATURE_ULTRAVISOR)) {
+		uv_register_pate(lpid, dw0, dw1);
+		pr_info("PATE registered by ultravisor: dw0 = 0x%lx, dw1 = 0x%lx\n",
+			dw0, dw1);
+	}
+}
+
 EXPORT_SYMBOL_GPL(mmu_partition_table_set_entry);
 
 static pmd_t *get_pmd_from_cache(struct mm_struct *mm)
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index c9bcf428dd2b..0472cab84df8 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -655,8 +655,10 @@ void radix__early_init_mmu_secondary(void)
 		lpcr = mfspr(SPRN_LPCR);
 		mtspr(SPRN_LPCR, lpcr | LPCR_UPRT | LPCR_HR);
 
-		mtspr(SPRN_PTCR,
-		      __pa(partition_tb) | (PATB_SIZE_SHIFT - 12));
+		if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
+			mtspr(SPRN_PTCR, __pa(partition_tb) |
+			      (PATB_SIZE_SHIFT - 12));
+
 		radix_init_amor();
 	}
 
@@ -672,7 +674,8 @@ void radix__mmu_cleanup_all(void)
 	if (!firmware_has_feature(FW_FEATURE_LPAR)) {
 		lpcr = mfspr(SPRN_LPCR);
 		mtspr(SPRN_LPCR, lpcr & ~LPCR_UPRT);
-		mtspr(SPRN_PTCR, 0);
+		if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
+			mtspr(SPRN_PTCR, 0);
 		powernv_set_nmmu_ptcr(0);
 		radix__flush_tlb_all();
 	}
-- 
2.20.1

