Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54FC9127002
	for <lists+kvm-ppc@lfdr.de>; Thu, 19 Dec 2019 22:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfLSVv5 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 19 Dec 2019 16:51:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52824 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726959AbfLSVv5 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 19 Dec 2019 16:51:57 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJLlb0J158898;
        Thu, 19 Dec 2019 16:51:49 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2x0efrpfqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 16:51:48 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xBJLls5Q023576;
        Thu, 19 Dec 2019 21:51:47 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma05wdc.us.ibm.com with ESMTP id 2wvqc6sv10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 21:51:47 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBJLplDb43909420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 21:51:47 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44EC9112062;
        Thu, 19 Dec 2019 21:51:47 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9BD95112061;
        Thu, 19 Dec 2019 21:51:46 +0000 (GMT)
Received: from suka-w540.usor.ibm.com (unknown [9.70.94.45])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 19 Dec 2019 21:51:46 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>, linuxram@us.ibm.com
Cc:     bharata@linux.ibm.com, linuxppc-dev@ozlabs.org,
        kvm-ppc@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v4 1/2] KVM: PPC: Add skip_page_out parameter
Date:   Thu, 19 Dec 2019 13:51:45 -0800
Message-Id: <20191219215146.27278-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.17.2
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-19_07:2019-12-17,2019-12-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 suspectscore=2 mlxlogscore=921 priorityscore=1501
 clxscore=1011 spamscore=0 phishscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912190162
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Add 'skip_page_out' parameter to kvmppc_uvmem_drop_pages() so the
callers can specify whetheter or not to skip paging out pages. This
will be needed in a follow-on patch that implements H_SVM_INIT_ABORT
hcall

Reviewed-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 arch/powerpc/include/asm/kvm_book3s_uvmem.h | 4 ++--
 arch/powerpc/kvm/book3s_64_mmu_radix.c      | 2 +-
 arch/powerpc/kvm/book3s_hv.c                | 2 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c          | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s_uvmem.h b/arch/powerpc/include/asm/kvm_book3s_uvmem.h
index 50204e228f16..3cf8425b9838 100644
--- a/arch/powerpc/include/asm/kvm_book3s_uvmem.h
+++ b/arch/powerpc/include/asm/kvm_book3s_uvmem.h
@@ -20,7 +20,7 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm);
 unsigned long kvmppc_h_svm_init_done(struct kvm *kvm);
 int kvmppc_send_page_to_uv(struct kvm *kvm, unsigned long gfn);
 void kvmppc_uvmem_drop_pages(const struct kvm_memory_slot *free,
-			     struct kvm *kvm);
+			     struct kvm *kvm, bool skip_page_out);
 #else
 static inline int kvmppc_uvmem_init(void)
 {
@@ -69,6 +69,6 @@ static inline int kvmppc_send_page_to_uv(struct kvm *kvm, unsigned long gfn)
 
 static inline void
 kvmppc_uvmem_drop_pages(const struct kvm_memory_slot *free,
-			struct kvm *kvm) { }
+			struct kvm *kvm, bool skip_page_out) { }
 #endif /* CONFIG_PPC_UV */
 #endif /* __ASM_KVM_BOOK3S_UVMEM_H__ */
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index da857c8ba6e4..744dba98e5d1 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -1102,7 +1102,7 @@ void kvmppc_radix_flush_memslot(struct kvm *kvm,
 	unsigned int shift;
 
 	if (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_START)
-		kvmppc_uvmem_drop_pages(memslot, kvm);
+		kvmppc_uvmem_drop_pages(memslot, kvm, true);
 
 	if (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE)
 		return;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 597f4bfecf0e..66d5312be16b 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5493,7 +5493,7 @@ static int kvmhv_svm_off(struct kvm *kvm)
 			continue;
 
 		kvm_for_each_memslot(memslot, slots) {
-			kvmppc_uvmem_drop_pages(memslot, kvm);
+			kvmppc_uvmem_drop_pages(memslot, kvm, true);
 			uv_unregister_mem_slot(kvm->arch.lpid, memslot->id);
 		}
 	}
diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index f24ac3cfb34c..9a5bbad7d87e 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -259,7 +259,7 @@ unsigned long kvmppc_h_svm_init_done(struct kvm *kvm)
  * QEMU page table with normal PTEs from newly allocated pages.
  */
 void kvmppc_uvmem_drop_pages(const struct kvm_memory_slot *free,
-			     struct kvm *kvm)
+			     struct kvm *kvm, bool skip_page_out)
 {
 	int i;
 	struct kvmppc_uvmem_page_pvt *pvt;
@@ -277,7 +277,7 @@ void kvmppc_uvmem_drop_pages(const struct kvm_memory_slot *free,
 
 		uvmem_page = pfn_to_page(uvmem_pfn);
 		pvt = uvmem_page->zone_device_data;
-		pvt->skip_page_out = true;
+		pvt->skip_page_out = skip_page_out;
 		mutex_unlock(&kvm->arch.uvmem_lock);
 
 		pfn = gfn_to_pfn(kvm, gfn);
-- 
2.17.2

