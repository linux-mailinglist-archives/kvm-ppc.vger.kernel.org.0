Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9AF1B0A2E
	for <lists+kvm-ppc@lfdr.de>; Mon, 20 Apr 2020 14:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgDTMph (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 20 Apr 2020 08:45:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30348 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728060AbgDTMpg (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 20 Apr 2020 08:45:36 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03KCV5ug029385;
        Mon, 20 Apr 2020 08:45:21 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30ghu5ru6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 08:45:21 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03KCXPwb039011;
        Mon, 20 Apr 2020 08:45:20 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30ghu5ru5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 08:45:20 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03KCduam005955;
        Mon, 20 Apr 2020 12:45:20 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01wdc.us.ibm.com with ESMTP id 30fs65rj0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 12:45:20 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03KCjIw559245006
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 12:45:18 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A31DB136055;
        Mon, 20 Apr 2020 12:45:18 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D522D136053;
        Mon, 20 Apr 2020 12:45:14 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.199.51.43])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 20 Apr 2020 12:45:14 +0000 (GMT)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc:     npiggin@gmail.com, paulus@ozlabs.org, leonardo@linux.ibm.com,
        kirill@shutemov.name,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v3 07/22] powerpc/perf/callchain: Use __get_user_pages_fast in read_user_stack_slow
Date:   Mon, 20 Apr 2020 18:14:19 +0530
Message-Id: <20200420124434.47330-8-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420124434.47330-1-aneesh.kumar@linux.ibm.com>
References: <20200420124434.47330-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-20_03:2020-04-20,2020-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 adultscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200107
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
 arch/powerpc/perf/callchain_64.c | 46 ++++++++++----------------------
 1 file changed, 14 insertions(+), 32 deletions(-)

diff --git a/arch/powerpc/perf/callchain_64.c b/arch/powerpc/perf/callchain_64.c
index df1ffd8b20f2..b63086b663ef 100644
--- a/arch/powerpc/perf/callchain_64.c
+++ b/arch/powerpc/perf/callchain_64.c
@@ -26,43 +26,25 @@
  */
 int read_user_stack_slow(void __user *ptr, void *buf, int nb)
 {
-	int ret = -EFAULT;
-	pgd_t *pgdir;
-	pte_t *ptep, pte;
-	unsigned int shift;
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
+
+		/* align address to page boundary */
+		offset = addr & ~PAGE_MASK;
 
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
+		memcpy(buf, kaddr + offset, nb);
+		put_page(page);
+		return 0;
+	}
+	return -EFAULT;
 }
 
 static int read_user_stack_64(unsigned long __user *ptr, unsigned long *ret)
-- 
2.25.3

