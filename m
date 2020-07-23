Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D76922B731
	for <lists+kvm-ppc@lfdr.de>; Thu, 23 Jul 2020 22:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbgGWUIQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 23 Jul 2020 16:08:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10816 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbgGWUIQ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 23 Jul 2020 16:08:16 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06NK1cmj097424;
        Thu, 23 Jul 2020 16:08:04 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32faj6vhx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 16:08:04 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06NJpwLw009126;
        Thu, 23 Jul 2020 20:08:02 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 32brbh6ed9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 20:08:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06NK7x5x63045800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jul 2020 20:07:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68B9A4C040;
        Thu, 23 Jul 2020 20:07:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E0C84C044;
        Thu, 23 Jul 2020 20:07:56 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.211.150.76])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 23 Jul 2020 20:07:55 +0000 (GMT)
From:   Ram Pai <linuxram@us.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        bharata@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, ldufour@linux.ibm.com,
        bauerman@linux.ibm.com, david@gibson.dropbear.id.au,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sathnaga@linux.vnet.ibm.com
Subject: [PATCH v5 5/7] KVM: PPC: Book3S HV: migrate hot plugged memory
Date:   Thu, 23 Jul 2020 13:07:22 -0700
Message-Id: <1595534844-16188-6-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595534844-16188-1-git-send-email-linuxram@us.ibm.com>
References: <1595534844-16188-1-git-send-email-linuxram@us.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_09:2020-07-23,2020-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 spamscore=0 malwarescore=0 impostorscore=0 mlxlogscore=999
 suspectscore=2 bulkscore=0 adultscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007230142
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Laurent Dufour <ldufour@linux.ibm.com>

When a memory slot is hot plugged to a SVM, PFNs associated with the
GFNs in that slot must be migrated to the secure-PFNs, aka device-PFNs.

Call kvmppc_uv_migrate_mem_slot() to accomplish this.
Disable page-merge for all pages in the memory slot.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
[rearranged the code, and modified the commit log]
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
---
 arch/powerpc/include/asm/kvm_book3s_uvmem.h | 14 ++++++++++++++
 arch/powerpc/kvm/book3s_hv.c                | 10 ++--------
 arch/powerpc/kvm/book3s_hv_uvmem.c          | 23 +++++++++++++++++++----
 3 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s_uvmem.h b/arch/powerpc/include/asm/kvm_book3s_uvmem.h
index f229ab5..59c17ca 100644
--- a/arch/powerpc/include/asm/kvm_book3s_uvmem.h
+++ b/arch/powerpc/include/asm/kvm_book3s_uvmem.h
@@ -25,6 +25,10 @@ void kvmppc_uvmem_drop_pages(const struct kvm_memory_slot *free,
 			     struct kvm *kvm, bool skip_page_out);
 int kvmppc_uv_migrate_mem_slot(struct kvm *kvm,
 			const struct kvm_memory_slot *memslot);
+int kvmppc_uvmem_memslot_create(struct kvm *kvm,
+		const struct kvm_memory_slot *new);
+void kvmppc_uvmem_memslot_delete(struct kvm *kvm,
+		const struct kvm_memory_slot *old);
 #else
 static inline int kvmppc_uvmem_init(void)
 {
@@ -84,5 +88,15 @@ static inline int kvmppc_send_page_to_uv(struct kvm *kvm, unsigned long gfn)
 static inline void
 kvmppc_uvmem_drop_pages(const struct kvm_memory_slot *free,
 			struct kvm *kvm, bool skip_page_out) { }
+
+static inline int  kvmppc_uvmem_memslot_create(struct kvm *kvm,
+		const struct kvm_memory_slot *new)
+{
+	return H_UNSUPPORTED;
+}
+
+static inline void  kvmppc_uvmem_memslot_delete(struct kvm *kvm,
+		const struct kvm_memory_slot *old) { }
+
 #endif /* CONFIG_PPC_UV */
 #endif /* __ASM_KVM_BOOK3S_UVMEM_H__ */
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index d331b46..b1485ca 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4515,16 +4515,10 @@ static void kvmppc_core_commit_memory_region_hv(struct kvm *kvm,
 
 	switch (change) {
 	case KVM_MR_CREATE:
-		if (kvmppc_uvmem_slot_init(kvm, new))
-			return;
-		uv_register_mem_slot(kvm->arch.lpid,
-				     new->base_gfn << PAGE_SHIFT,
-				     new->npages * PAGE_SIZE,
-				     0, new->id);
+		kvmppc_uvmem_memslot_create(kvm, new);
 		break;
 	case KVM_MR_DELETE:
-		uv_unregister_mem_slot(kvm->arch.lpid, old->id);
-		kvmppc_uvmem_slot_free(kvm, old);
+		kvmppc_uvmem_memslot_delete(kvm, old);
 		break;
 	default:
 		/* TODO: Handle KVM_MR_MOVE */
diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 43b3566..fd9ff6e 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -418,7 +418,7 @@ static int kvmppc_memslot_page_merge(struct kvm *kvm,
 	return ret;
 }
 
-static void kvmppc_uvmem_memslot_delete(struct kvm *kvm,
+static void __kvmppc_uvmem_memslot_delete(struct kvm *kvm,
 		const struct kvm_memory_slot *memslot)
 {
 	uv_unregister_mem_slot(kvm->arch.lpid, memslot->id);
@@ -426,7 +426,7 @@ static void kvmppc_uvmem_memslot_delete(struct kvm *kvm,
 	kvmppc_memslot_page_merge(kvm, memslot, true);
 }
 
-static int kvmppc_uvmem_memslot_create(struct kvm *kvm,
+static int __kvmppc_uvmem_memslot_create(struct kvm *kvm,
 		const struct kvm_memory_slot *memslot)
 {
 	int ret = H_PARAMETER;
@@ -478,7 +478,7 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
 	/* register the memslot */
 	slots = kvm_memslots(kvm);
 	kvm_for_each_memslot(memslot, slots) {
-		ret = kvmppc_uvmem_memslot_create(kvm, memslot);
+		ret = __kvmppc_uvmem_memslot_create(kvm, memslot);
 		if (ret)
 			break;
 	}
@@ -488,7 +488,7 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
 		kvm_for_each_memslot(m, slots) {
 			if (m == memslot)
 				break;
-			kvmppc_uvmem_memslot_delete(kvm, memslot);
+			__kvmppc_uvmem_memslot_delete(kvm, memslot);
 		}
 	}
 
@@ -1057,6 +1057,21 @@ int kvmppc_send_page_to_uv(struct kvm *kvm, unsigned long gfn)
 	return (ret == U_SUCCESS) ? RESUME_GUEST : -EFAULT;
 }
 
+int kvmppc_uvmem_memslot_create(struct kvm *kvm, const struct kvm_memory_slot *new)
+{
+	int ret = __kvmppc_uvmem_memslot_create(kvm, new);
+
+	if (!ret)
+		ret = kvmppc_uv_migrate_mem_slot(kvm, new);
+
+	return ret;
+}
+
+void kvmppc_uvmem_memslot_delete(struct kvm *kvm, const struct kvm_memory_slot *old)
+{
+	__kvmppc_uvmem_memslot_delete(kvm, old);
+}
+
 static u64 kvmppc_get_secmem_size(void)
 {
 	struct device_node *np;
-- 
1.8.3.1

