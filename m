Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6EB1F354F
	for <lists+kvm-ppc@lfdr.de>; Thu,  7 Nov 2019 18:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389538AbfKGRDb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 7 Nov 2019 12:03:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50198 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730639AbfKGRDa (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 7 Nov 2019 12:03:30 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA7GsGSI072358;
        Thu, 7 Nov 2019 12:03:15 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w4np3d4yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 12:03:14 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xA7H2Vhv002177;
        Thu, 7 Nov 2019 17:03:09 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03dal.us.ibm.com with ESMTP id 2w41ukcqr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 17:03:09 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA7H38Tl41550332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Nov 2019 17:03:08 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48B22AE062;
        Thu,  7 Nov 2019 17:03:08 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1079FAE05C;
        Thu,  7 Nov 2019 17:03:07 +0000 (GMT)
Received: from LeoBras.br.ibm.com (unknown [9.18.235.40])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu,  7 Nov 2019 17:03:06 +0000 (GMT)
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc:     Leonardo Bras <leonardo@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH v2 4/4] powerpc/kvm/e500: Replace current->mm by kvm->mm
Date:   Thu,  7 Nov 2019 14:02:58 -0300
Message-Id: <20191107170258.36379-5-leonardo@linux.ibm.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191107170258.36379-1-leonardo@linux.ibm.com>
References: <20191107170258.36379-1-leonardo@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-07_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=834 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911070159
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Given that in kvm_create_vm() there is:
kvm->mm = current->mm;

And that on every kvm_*_ioctl we have:
if (kvm->mm != current->mm)
        return -EIO;

I see no reason to keep using current->mm instead of kvm->mm.

By doing so, we would reduce the use of 'global' variables on code, relying
more in the contents of kvm struct.

Signed-off-by: Leonardo Bras <leonardo@linux.ibm.com>
---
 arch/powerpc/kvm/e500_mmu_host.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index 321db0fdb9db..425d13806645 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -355,9 +355,9 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 
 	if (tlbsel == 1) {
 		struct vm_area_struct *vma;
-		down_read(&current->mm->mmap_sem);
+		down_read(&kvm->mm->mmap_sem);
 
-		vma = find_vma(current->mm, hva);
+		vma = find_vma(kvm->mm, hva);
 		if (vma && hva >= vma->vm_start &&
 		    (vma->vm_flags & VM_PFNMAP)) {
 			/*
@@ -441,7 +441,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 			tsize = max(BOOK3E_PAGESZ_4K, tsize & ~1);
 		}
 
-		up_read(&current->mm->mmap_sem);
+		up_read(&kvm->mm->mmap_sem);
 	}
 
 	if (likely(!pfnmap)) {
-- 
2.23.0

