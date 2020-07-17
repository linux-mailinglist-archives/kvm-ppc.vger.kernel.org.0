Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128DF22366D
	for <lists+kvm-ppc@lfdr.de>; Fri, 17 Jul 2020 10:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgGQIBX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 17 Jul 2020 04:01:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30300 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728091AbgGQIBX (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 17 Jul 2020 04:01:23 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06H7WfTw020717;
        Fri, 17 Jul 2020 04:01:04 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32ax78p5m5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 04:01:04 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06H7fhxj025999;
        Fri, 17 Jul 2020 08:01:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3274pgx8m7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 08:01:02 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06H80x7W44171500
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jul 2020 08:00:59 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63609A4053;
        Fri, 17 Jul 2020 08:00:59 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CE41A407E;
        Fri, 17 Jul 2020 08:00:56 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.163.39.1])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Jul 2020 08:00:55 +0000 (GMT)
From:   Ram Pai <linuxram@us.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        bharata@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, ldufour@linux.ibm.com,
        bauerman@linux.ibm.com, david@gibson.dropbear.id.au,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sathnaga@linux.vnet.ibm.com
Subject: [v4 5/5] KVM: PPC: Book3S HV: migrate hot plugged memory
Date:   Fri, 17 Jul 2020 01:00:27 -0700
Message-Id: <1594972827-13928-6-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594972827-13928-1-git-send-email-linuxram@us.ibm.com>
References: <1594972827-13928-1-git-send-email-linuxram@us.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-17_04:2020-07-16,2020-07-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 suspectscore=2
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007170054
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Laurent Dufour <ldufour@linux.ibm.com>

When a memory slot is hot plugged to a SVM, PFNs associated with the
GFNs in that slot must be migrated to secure-PFNs, aka device-PFNs.

Call kvmppc_uv_migrate_mem_slot() to accomplish this.
Disable page-merge for all pages in the memory slot.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
[rearranged the code, and modified the commit log]
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
---
 arch/powerpc/include/asm/kvm_book3s_uvmem.h | 10 ++++++++++
 arch/powerpc/kvm/book3s_hv.c                | 10 ++--------
 arch/powerpc/kvm/book3s_hv_uvmem.c          | 22 ++++++++++++++++++++++
 3 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s_uvmem.h b/arch/powerpc/include/asm/kvm_book3s_uvmem.h
index f229ab5..6f7da00 100644
--- a/arch/powerpc/include/asm/kvm_book3s_uvmem.h
+++ b/arch/powerpc/include/asm/kvm_book3s_uvmem.h
@@ -25,6 +25,9 @@ void kvmppc_uvmem_drop_pages(const struct kvm_memory_slot *free,
 			     struct kvm *kvm, bool skip_page_out);
 int kvmppc_uv_migrate_mem_slot(struct kvm *kvm,
 			const struct kvm_memory_slot *memslot);
+void kvmppc_memslot_create(struct kvm *kvm, const struct kvm_memory_slot *new);
+void kvmppc_memslot_delete(struct kvm *kvm, const struct kvm_memory_slot *old);
+
 #else
 static inline int kvmppc_uvmem_init(void)
 {
@@ -84,5 +87,12 @@ static inline int kvmppc_send_page_to_uv(struct kvm *kvm, unsigned long gfn)
 static inline void
 kvmppc_uvmem_drop_pages(const struct kvm_memory_slot *free,
 			struct kvm *kvm, bool skip_page_out) { }
+
+static inline void  kvmppc_memslot_create(struct kvm *kvm,
+		const struct kvm_memory_slot *new) { }
+
+static inline void  kvmppc_memslot_delete(struct kvm *kvm,
+		const struct kvm_memory_slot *old) { }
+
 #endif /* CONFIG_PPC_UV */
 #endif /* __ASM_KVM_BOOK3S_UVMEM_H__ */
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index d331b46..bf3be3b 100644
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
+		kvmppc_memslot_create(kvm, new);
 		break;
 	case KVM_MR_DELETE:
-		uv_unregister_mem_slot(kvm->arch.lpid, old->id);
-		kvmppc_uvmem_slot_free(kvm, old);
+		kvmppc_memslot_delete(kvm, old);
 		break;
 	default:
 		/* TODO: Handle KVM_MR_MOVE */
diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index a206984..a2b4d25 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -1089,6 +1089,28 @@ int kvmppc_send_page_to_uv(struct kvm *kvm, unsigned long gfn)
 	return (ret == U_SUCCESS) ? RESUME_GUEST : -EFAULT;
 }
 
+void kvmppc_memslot_create(struct kvm *kvm, const struct kvm_memory_slot *new)
+{
+	if (kvmppc_uvmem_slot_init(kvm, new))
+		return;
+
+	if (kvmppc_memslot_page_merge(kvm, new, false))
+		return;
+
+	if (uv_register_mem_slot(kvm->arch.lpid, new->base_gfn << PAGE_SHIFT,
+			new->npages * PAGE_SIZE, 0, new->id))
+		return;
+
+	kvmppc_uv_migrate_mem_slot(kvm, new);
+}
+
+void kvmppc_memslot_delete(struct kvm *kvm, const struct kvm_memory_slot *old)
+{
+	uv_unregister_mem_slot(kvm->arch.lpid, old->id);
+	kvmppc_memslot_page_merge(kvm, old, true);
+	kvmppc_uvmem_slot_free(kvm, old);
+}
+
 static u64 kvmppc_get_secmem_size(void)
 {
 	struct device_node *np;
-- 
1.8.3.1

