Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEE11E94FB
	for <lists+kvm-ppc@lfdr.de>; Sun, 31 May 2020 04:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbgEaC2m (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 30 May 2020 22:28:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7028 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729376AbgEaC2m (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 30 May 2020 22:28:42 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04V22Kch058736;
        Sat, 30 May 2020 22:28:28 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31bkmf0wmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 30 May 2020 22:28:28 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04V2R7IZ010552;
        Sun, 31 May 2020 02:28:27 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 31bf478m63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 May 2020 02:28:26 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04V2SNfe57082134
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 31 May 2020 02:28:24 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D00C0AE045;
        Sun, 31 May 2020 02:28:23 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDA85AE04D;
        Sun, 31 May 2020 02:28:20 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.211.70.118])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 31 May 2020 02:28:20 +0000 (GMT)
From:   Ram Pai <linuxram@us.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        bharata@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, ldufour@linux.ibm.com,
        bauerman@linux.ibm.com, david@gibson.dropbear.id.au,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com
Subject: [PATCH v1 1/4] KVM: PPC: Book3S HV: Fix function definition in book3s_hv_uvmem.c
Date:   Sat, 30 May 2020 19:27:48 -0700
Message-Id: <1590892071-25549-2-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590892071-25549-1-git-send-email-linuxram@us.ibm.com>
References: <1590892071-25549-1-git-send-email-linuxram@us.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-30_21:2020-05-28,2020-05-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 cotscore=-2147483648 bulkscore=0 spamscore=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005310010
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Without this fix, GIT gets confused. It generates incorrect
function context for code changes.  Weird, but true.

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
index 79b1202..ea4a1f1 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -368,8 +368,7 @@ static struct page *kvmppc_uvmem_get_page(unsigned long gpa, struct kvm *kvm)
  * Alloc a PFN from private device memory pool and copy page from normal
  * memory to secure memory using UV_PAGE_IN uvcall.
  */
-static int
-kvmppc_svm_page_in(struct vm_area_struct *vma, unsigned long start,
+static int kvmppc_svm_page_in(struct vm_area_struct *vma, unsigned long start,
 		   unsigned long end, unsigned long gpa, struct kvm *kvm,
 		   unsigned long page_shift, bool *downgrade)
 {
@@ -436,8 +435,8 @@ static struct page *kvmppc_uvmem_get_page(unsigned long gpa, struct kvm *kvm)
  * In the former case, uses dev_pagemap_ops.migrate_to_ram handler
  * to unmap the device page from QEMU's page tables.
  */
-static unsigned long
-kvmppc_share_page(struct kvm *kvm, unsigned long gpa, unsigned long page_shift)
+static unsigned long kvmppc_share_page(struct kvm *kvm, unsigned long gpa,
+		unsigned long page_shift)
 {
 
 	int ret = H_PARAMETER;
@@ -486,9 +485,9 @@ static struct page *kvmppc_uvmem_get_page(unsigned long gpa, struct kvm *kvm)
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
@@ -545,10 +544,10 @@ static struct page *kvmppc_uvmem_get_page(unsigned long gpa, struct kvm *kvm)
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

