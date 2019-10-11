Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 562A5D465B
	for <lists+kvm-ppc@lfdr.de>; Fri, 11 Oct 2019 19:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbfJKRPN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 11 Oct 2019 13:15:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60926 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727984AbfJKRPN (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 11 Oct 2019 13:15:13 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3DFBC46671
        for <kvm-ppc@vger.kernel.org>; Fri, 11 Oct 2019 17:15:13 +0000 (UTC)
Received: from donizetti.redhat.com (unknown [10.36.112.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CE485DA2C;
        Fri, 11 Oct 2019 17:15:12 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     cinco-list@redhat.com
Cc:     kvm-ppc@vger.kernel.org
Subject: [EMBARGOED RHEL8.0 PATCH v5 01/11] kvm: x86, powerpc: do not allow clearing largepages debugfs entry
Date:   Fri, 11 Oct 2019 19:14:53 +0200
Message-Id: <20191011171503.32717-2-pbonzini@redhat.com>
In-Reply-To: <20191011171503.32717-1-pbonzini@redhat.com>
References: <20191011171503.32717-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 11 Oct 2019 17:15:13 +0000 (UTC)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The largepages debugfs entry is incremented/decremented as shadow
pages are created or destroyed.  Clearing it will result in an
underflow, which is harmless to KVM but ugly (and could be
misinterpreted by tools that use debugfs information), so make
this particular statistic read-only.

Cc: kvm-ppc@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
(cherry picked from commit 833b45de69a6016c4b0cebe6765d526a31a81580)

RHEL: powerpc part does not apply to RHEL-8.0
---
 arch/x86/kvm/x86.c       |  6 +++---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 10 +++++++---
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4fa858b5ad67..ee50571ceee7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -92,8 +92,8 @@ u64 __read_mostly efer_reserved_bits = ~((u64)(EFER_SCE | EFER_LME | EFER_LMA));
 static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 #endif
 
-#define VM_STAT(x) offsetof(struct kvm, stat.x), KVM_STAT_VM
-#define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU
+#define VM_STAT(x, ...) offsetof(struct kvm, stat.x), KVM_STAT_VM, ## __VA_ARGS__
+#define VCPU_STAT(x, ...) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU, ## __VA_ARGS__
 
 #define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | \
                                     KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
@@ -205,7 +205,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "mmu_cache_miss", VM_STAT(mmu_cache_miss) },
 	{ "mmu_unsync", VM_STAT(mmu_unsync) },
 	{ "remote_tlb_flush", VM_STAT(remote_tlb_flush) },
-	{ "largepages", VM_STAT(lpages) },
+	{ "largepages", VM_STAT(lpages, .mode = 0444) },
 	{ "max_mmu_page_hash_collisions",
 		VM_STAT(max_mmu_page_hash_collisions) },
 	{ NULL }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 56bea61eab03..d07a744c4c89 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1031,6 +1031,7 @@ enum kvm_stat_kind {
 
 struct kvm_stat_data {
 	int offset;
+	int mode;
 	struct kvm *kvm;
 };
 
@@ -1038,6 +1039,7 @@ struct kvm_stats_debugfs_item {
 	const char *name;
 	int offset;
 	enum kvm_stat_kind kind;
+	int mode;
 };
 extern struct kvm_stats_debugfs_item debugfs_entries[];
 extern struct dentry *kvm_debugfs_dir;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 859bfadd2454..d655d72ec8a2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -611,8 +611,9 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 
 		stat_data->kvm = kvm;
 		stat_data->offset = p->offset;
+		stat_data->mode = p->mode ? p->mode : 0644;
 		kvm->debugfs_stat_data[p - debugfs_entries] = stat_data;
-		debugfs_create_file(p->name, 0644, kvm->debugfs_dentry,
+		debugfs_create_file(p->name, stat_data->mode, kvm->debugfs_dentry,
 				    stat_data, stat_fops_per_vm[p->kind]);
 	}
 	return 0;
@@ -3681,7 +3682,9 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
 	if (!refcount_inc_not_zero(&stat_data->kvm->users_count))
 		return -ENOENT;
 
-	if (simple_attr_open(inode, file, get, set, fmt)) {
+	if (simple_attr_open(inode, file, get,
+			     stat_data->mode & S_IWUGO ? set : NULL,
+			     fmt)) {
 		kvm_put_kvm(stat_data->kvm);
 		return -ENOMEM;
 	}
@@ -3929,7 +3932,8 @@ static void kvm_init_debug(void)
 
 	kvm_debugfs_num_entries = 0;
 	for (p = debugfs_entries; p->name; ++p, kvm_debugfs_num_entries++) {
-		debugfs_create_file(p->name, 0644, kvm_debugfs_dir,
+		int mode = p->mode ? p->mode : 0644;
+		debugfs_create_file(p->name, mode, kvm_debugfs_dir,
 				    (void *)(long)p->offset,
 				    stat_fops[p->kind]);
 	}
-- 
2.21.0


