Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707731B0B7C
	for <lists+kvm-ppc@lfdr.de>; Mon, 20 Apr 2020 14:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgDTM4I (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 20 Apr 2020 08:56:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64396 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727831AbgDTMpP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 20 Apr 2020 08:45:15 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03KCXvcG037545;
        Mon, 20 Apr 2020 08:45:03 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gmuxe3sq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 08:45:03 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03KCYfEK040498;
        Mon, 20 Apr 2020 08:45:02 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gmuxe3rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 08:45:02 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03KChbLI025816;
        Mon, 20 Apr 2020 12:45:01 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03wdc.us.ibm.com with ESMTP id 30fs660jxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 12:45:01 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03KCj0aW52298124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 12:45:00 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FB2F136059;
        Mon, 20 Apr 2020 12:45:00 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52D3D136055;
        Mon, 20 Apr 2020 12:44:56 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.199.51.43])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 20 Apr 2020 12:44:55 +0000 (GMT)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc:     npiggin@gmail.com, paulus@ozlabs.org, leonardo@linux.ibm.com,
        kirill@shutemov.name,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v3 03/22] powerpc/mm/hash64: use _PAGE_PTE when checking for pte_present
Date:   Mon, 20 Apr 2020 18:14:15 +0530
Message-Id: <20200420124434.47330-4-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420124434.47330-1-aneesh.kumar@linux.ibm.com>
References: <20200420124434.47330-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-20_04:2020-04-20,2020-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 adultscore=0 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200110
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This makes the pte_present check stricter by checking for additional _PAGE_PTE
bit. A level 1 pte pointer (THP pte) can be switched to a pointer to level 0 pte
page table page by following two operations.

1) THP split.
2) madvise(MADV_DONTNEED) in parallel to page fault.

A lockless page table walk need to make sure we can handle such changes
gracefully.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 arch/powerpc/include/asm/book3s/64/pgtable.h | 15 ++++++++++-----
 arch/powerpc/mm/book3s64/hash_utils.c        | 11 +++++++++--
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index 368b136517e0..03521a8b0292 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -553,6 +553,12 @@ static inline pte_t pte_clear_savedwrite(pte_t pte)
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
+static inline bool pte_hw_valid(pte_t pte)
+{
+	return (pte_raw(pte) & cpu_to_be64(_PAGE_PRESENT | _PAGE_PTE)) ==
+		cpu_to_be64(_PAGE_PRESENT | _PAGE_PTE);
+}
+
 static inline int pte_present(pte_t pte)
 {
 	/*
@@ -561,12 +567,11 @@ static inline int pte_present(pte_t pte)
 	 * invalid during ptep_set_access_flags. Hence we look for _PAGE_INVALID
 	 * if we find _PAGE_PRESENT cleared.
 	 */
-	return !!(pte_raw(pte) & cpu_to_be64(_PAGE_PRESENT | _PAGE_INVALID));
-}
 
-static inline bool pte_hw_valid(pte_t pte)
-{
-	return !!(pte_raw(pte) & cpu_to_be64(_PAGE_PRESENT));
+	if (pte_hw_valid(pte))
+		return true;
+	return (pte_raw(pte) & cpu_to_be64(_PAGE_INVALID | _PAGE_PTE)) ==
+		cpu_to_be64(_PAGE_INVALID | _PAGE_PTE);
 }
 
 #ifdef CONFIG_PPC_MEM_KEYS
diff --git a/arch/powerpc/mm/book3s64/hash_utils.c b/arch/powerpc/mm/book3s64/hash_utils.c
index e951e87a974d..525eac4ee2c2 100644
--- a/arch/powerpc/mm/book3s64/hash_utils.c
+++ b/arch/powerpc/mm/book3s64/hash_utils.c
@@ -1350,8 +1350,15 @@ int hash_page_mm(struct mm_struct *mm, unsigned long ea,
 		goto bail;
 	}
 
-	/* Add _PAGE_PRESENT to the required access perm */
-	access |= _PAGE_PRESENT;
+	/*
+	 * Add _PAGE_PRESENT to the required access perm. If there are parallel
+	 * updates to the pte that can possibly clear _PAGE_PTE, catch that too.
+	 *
+	 * We can safely use the return pte address in rest of the function
+	 * because we do set H_PAGE_BUSY which prevents further updates to pte
+	 * from generic code.
+	 */
+	access |= _PAGE_PRESENT | _PAGE_PTE;
 
 	/*
 	 * Pre-check access permissions (will be re-checked atomically
-- 
2.25.3

