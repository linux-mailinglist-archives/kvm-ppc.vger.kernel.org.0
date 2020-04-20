Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86B41B0B62
	for <lists+kvm-ppc@lfdr.de>; Mon, 20 Apr 2020 14:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgDTMzn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 20 Apr 2020 08:55:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32808 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728756AbgDTMp3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 20 Apr 2020 08:45:29 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03KCV6Vo029466;
        Mon, 20 Apr 2020 08:45:17 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30ghu5ru3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 08:45:17 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03KCXPwY039011;
        Mon, 20 Apr 2020 08:45:17 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30ghu5ru2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 08:45:17 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03KCj3gE027386;
        Mon, 20 Apr 2020 12:45:15 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 30fs660k16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 12:45:15 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03KCjEaM46661992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 12:45:14 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35FF713604F;
        Mon, 20 Apr 2020 12:45:14 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40F53136063;
        Mon, 20 Apr 2020 12:45:10 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.199.51.43])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 20 Apr 2020 12:45:09 +0000 (GMT)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc:     npiggin@gmail.com, paulus@ozlabs.org, leonardo@linux.ibm.com,
        kirill@shutemov.name,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Subject: [PATCH v3 06/22] powerpc/mce: Don't reload pte val in addr_to_pfn
Date:   Mon, 20 Apr 2020 18:14:18 +0530
Message-Id: <20200420124434.47330-7-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420124434.47330-1-aneesh.kumar@linux.ibm.com>
References: <20200420124434.47330-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-20_03:2020-04-20,2020-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=860
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 adultscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200107
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

A lockless page table walk should be safe against parallel THP collapse, THP
split and madvise(MADV_DONTNEED)/parallel fault. This patch makes sure kernel
won't reload the pteval when checking for different conditions. The patch also added
a check for pte_present to make sure the kernel is indeed operating
on a PTE and not a pointer to level 0 table page.

The pfn value we find here can be different from the actual pfn on which
machine check happened. This can happen if we raced with a parallel update
of the page table. In such a scenario we end up isolating a wrong pfn. But that
doesn't have any other side effect.

Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 arch/powerpc/kernel/mce_power.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/mce_power.c b/arch/powerpc/kernel/mce_power.c
index 067b094bfeff..1d18991f3854 100644
--- a/arch/powerpc/kernel/mce_power.c
+++ b/arch/powerpc/kernel/mce_power.c
@@ -27,7 +27,7 @@
  */
 unsigned long addr_to_pfn(struct pt_regs *regs, unsigned long addr)
 {
-	pte_t *ptep;
+	pte_t *ptep, pte;
 	unsigned int shift;
 	unsigned long pfn, flags;
 	struct mm_struct *mm;
@@ -39,19 +39,23 @@ unsigned long addr_to_pfn(struct pt_regs *regs, unsigned long addr)
 
 	local_irq_save(flags);
 	ptep = __find_linux_pte(mm->pgd, addr, NULL, &shift);
+	if (!ptep) {
+		pfn = ULONG_MAX;
+		goto out;
+	}
+	pte = READ_ONCE(*ptep);
 
-	if (!ptep || pte_special(*ptep)) {
+	if (!pte_present(pte) || pte_special(pte)) {
 		pfn = ULONG_MAX;
 		goto out;
 	}
 
 	if (shift <= PAGE_SHIFT)
-		pfn = pte_pfn(*ptep);
+		pfn = pte_pfn(pte);
 	else {
 		unsigned long rpnmask = (1ul << shift) - PAGE_SIZE;
-		pfn = pte_pfn(__pte(pte_val(*ptep) | (addr & rpnmask)));
+		pfn = pte_pfn(__pte(pte_val(pte) | (addr & rpnmask)));
 	}
-
 out:
 	local_irq_restore(flags);
 	return pfn;
-- 
2.25.3

