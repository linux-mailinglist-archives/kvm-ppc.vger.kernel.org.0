Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8929118AB5D
	for <lists+kvm-ppc@lfdr.de>; Thu, 19 Mar 2020 04:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgCSD46 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 18 Mar 2020 23:56:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16512 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727129AbgCSD46 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 18 Mar 2020 23:56:58 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02J3XgQw061829;
        Wed, 18 Mar 2020 23:56:48 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yu8hwa1ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Mar 2020 23:56:48 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02J3Xk1U062261;
        Wed, 18 Mar 2020 23:56:47 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yu8hwa1u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Mar 2020 23:56:47 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02J3jrKt017584;
        Thu, 19 Mar 2020 03:56:47 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 2yrpw6y66v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Mar 2020 03:56:47 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02J3ukvq47710474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Mar 2020 03:56:46 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AEC0112069;
        Thu, 19 Mar 2020 03:56:46 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAE88112063;
        Thu, 19 Mar 2020 03:56:42 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.199.34.213])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 19 Mar 2020 03:56:42 +0000 (GMT)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc:     npiggin@gmail.com, paulus@ozlabs.org, leonardo@linux.ibm.com,
        kirill@shutemov.name,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v2 07/22] powerpc/perf/callchain: Use __get_user_pages_fast in read_user_stack_slow
Date:   Thu, 19 Mar 2020 09:25:54 +0530
Message-Id: <20200319035609.158654-8-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319035609.158654-1-aneesh.kumar@linux.ibm.com>
References: <20200319035609.158654-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_10:2020-03-18,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 phishscore=0 clxscore=1015 adultscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003190013
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

read_user_stack_slow is called with interrupts soft disabled and it copies contents
from the page which we find mapped to a specific address. To convert
userspace address to pfn, the kernel now uses lockless page table walk.

The kernel needs to make sure the pfn value read remains stable and is not released
and reused for another process while the contents are read from the page. This
can only be achieved by holding a page reference.

One of the first approaches I tried was to check the pte value after the kernel
copies the contents from the page. But as shown below we can still get it wrong

CPU0                           CPU1
pte = READ_ONCE(*ptep);
                               pte_clear(pte);
                               put_page(page);
                               page = alloc_page();
                               memcpy(page_address(page), "secret password", nr);
memcpy(buf, kaddr + offset, nb);
                               put_page(page);
                               handle_mm_fault()
                               page = alloc_page();
                               set_pte(pte, page);
if (pte_val(pte) != pte_val(*ptep))

Hence switch to __get_user_pages_fast.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 arch/powerpc/perf/callchain.c | 53 ++++++++++++++---------------------
 1 file changed, 21 insertions(+), 32 deletions(-)

diff --git a/arch/powerpc/perf/callchain.c b/arch/powerpc/perf/callchain.c
index cbc251981209..7b7b3ff53180 100644
--- a/arch/powerpc/perf/callchain.c
+++ b/arch/powerpc/perf/callchain.c
@@ -107,46 +107,35 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
  * On 64-bit we don't want to invoke hash_page on user addresses from
  * interrupt context, so if the access faults, we read the page tables
  * to find which page (if any) is mapped and access it directly.
+
+ * This should get called only if the PMU interrupt occurred while
+ * interrupts are soft-disabled, and there is no MMU hash table entry
+ * for the page . In this case we will get an -EFAULT return from
+ * __get_user_inatomic even if there is a valid Linux PTE for the page,
+ * since hash_page isn't reentrant.  Thus we have code here to read the
+ * Linux PTE and access the page via the kernel linear mapping.
  */
 static int read_user_stack_slow(void __user *ptr, void *buf, int nb)
 {
-	int ret = -EFAULT;
-	pgd_t *pgdir;
-	pte_t *ptep, pte;
-	unsigned shift;
+
 	unsigned long addr = (unsigned long) ptr;
 	unsigned long offset;
-	unsigned long pfn, flags;
+	struct page *page;
+	int nrpages;
 	void *kaddr;
 
-	pgdir = current->mm->pgd;
-	if (!pgdir)
-		return -EFAULT;
+	nrpages = __get_user_pages_fast(addr, 1, 1, &page);
+	if (nrpages == 1) {
+		kaddr = page_address(page);
 
-	local_irq_save(flags);
-	ptep = find_current_mm_pte(pgdir, addr, NULL, &shift);
-	if (!ptep)
-		goto err_out;
-	if (!shift)
-		shift = PAGE_SHIFT;
-
-	/* align address to page boundary */
-	offset = addr & ((1UL << shift) - 1);
-
-	pte = READ_ONCE(*ptep);
-	if (!pte_present(pte) || !pte_user(pte))
-		goto err_out;
-	pfn = pte_pfn(pte);
-	if (!page_is_ram(pfn))
-		goto err_out;
-
-	/* no highmem to worry about here */
-	kaddr = pfn_to_kaddr(pfn);
-	memcpy(buf, kaddr + offset, nb);
-	ret = 0;
-err_out:
-	local_irq_restore(flags);
-	return ret;
+		/* align address to page boundary */
+		offset = addr & ~PAGE_MASK;
+
+		memcpy(buf, kaddr + offset, nb);
+		put_page(page);
+		return 0;
+	}
+	return -EFAULT;
 }
 
 static int read_user_stack_64(unsigned long __user *ptr, unsigned long *ret)
-- 
2.24.1

