Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43EFE22B72D
	for <lists+kvm-ppc@lfdr.de>; Thu, 23 Jul 2020 22:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgGWUH7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 23 Jul 2020 16:07:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60210 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725894AbgGWUH6 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 23 Jul 2020 16:07:58 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06NK3Spo007314;
        Thu, 23 Jul 2020 16:07:50 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32facecub1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 16:07:50 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06NJo6mh025453;
        Thu, 23 Jul 2020 20:07:47 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 32brq7ws3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 20:07:47 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06NK7juJ39911540
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jul 2020 20:07:45 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F39094C04E;
        Thu, 23 Jul 2020 20:07:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C07A84C044;
        Thu, 23 Jul 2020 20:07:41 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.211.150.76])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 23 Jul 2020 20:07:41 +0000 (GMT)
From:   Ram Pai <linuxram@us.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        bharata@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, ldufour@linux.ibm.com,
        bauerman@linux.ibm.com, david@gibson.dropbear.id.au,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sathnaga@linux.vnet.ibm.com
Subject: [PATCH v5 1/7] KVM: PPC: Book3S HV: Fix function definition in book3s_hv_uvmem.c
Date:   Thu, 23 Jul 2020 13:07:18 -0700
Message-Id: <1595534844-16188-2-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595534844-16188-1-git-send-email-linuxram@us.ibm.com>
References: <1595534844-16188-1-git-send-email-linuxram@us.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_09:2020-07-23,2020-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007230144
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Without this fix, git is confused. It generates wrong
function context for code changes in subsequent patches.
Weird, but true.

Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Claudio Carvalho <cclaudio@linux.ibm.com>
Cc: kvm-ppc@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 09d8119..e6f76bc 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -382,8 +382,7 @@ static struct page *kvmppc_uvmem_get_page(unsigned long gpa, struct kvm *kvm)
  * Alloc a PFN from private device memory pool and copy page from normal
  * memory to secure memory using UV_PAGE_IN uvcall.
  */
-static int
-kvmppc_svm_page_in(struct vm_area_struct *vma, unsigned long start,
+static int kvmppc_svm_page_in(struct vm_area_struct *vma, unsigned long start,
 		   unsigned long end, unsigned long gpa, struct kvm *kvm,
 		   unsigned long page_shift, bool *downgrade)
 {
@@ -450,8 +449,8 @@ static struct page *kvmppc_uvmem_get_page(unsigned long gpa, struct kvm *kvm)
  * In the former case, uses dev_pagemap_ops.migrate_to_ram handler
  * to unmap the device page from QEMU's page tables.
  */
-static unsigned long
-kvmppc_share_page(struct kvm *kvm, unsigned long gpa, unsigned long page_shift)
+static unsigned long kvmppc_share_page(struct kvm *kvm, unsigned long gpa,
+		unsigned long page_shift)
 {
 
 	int ret = H_PARAMETER;
@@ -500,9 +499,9 @@ static struct page *kvmppc_uvmem_get_page(unsigned long gpa, struct kvm *kvm)
  * H_PAGE_IN_SHARED flag makes the page shared which means that the same
  * memory in is visible from both UV and HV.
  */
-unsigned long
-kvmppc_h_svm_page_in(struct kvm *kvm, unsigned long gpa,
-		     unsigned long flags, unsigned long page_shift)
+unsigned long kvmppc_h_svm_page_in(struct kvm *kvm, unsigned long gpa,
+		unsigned long flags,
+		unsigned long page_shift)
 {
 	bool downgrade = false;
 	unsigned long start, end;
@@ -559,10 +558,10 @@ static struct page *kvmppc_uvmem_get_page(unsigned long gpa, struct kvm *kvm)
  * Provision a new page on HV side and copy over the contents
  * from secure memory using UV_PAGE_OUT uvcall.
  */
-static int
-kvmppc_svm_page_out(struct vm_area_struct *vma, unsigned long start,
-		    unsigned long end, unsigned long page_shift,
-		    struct kvm *kvm, unsigned long gpa)
+static int kvmppc_svm_page_out(struct vm_area_struct *vma,
+		unsigned long start,
+		unsigned long end, unsigned long page_shift,
+		struct kvm *kvm, unsigned long gpa)
 {
 	unsigned long src_pfn, dst_pfn = 0;
 	struct migrate_vma mig;
-- 
1.8.3.1

