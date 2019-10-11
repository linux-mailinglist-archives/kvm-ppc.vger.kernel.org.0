Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87B5DD4661
	for <lists+kvm-ppc@lfdr.de>; Fri, 11 Oct 2019 19:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbfJKRPd (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 11 Oct 2019 13:15:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18563 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727984AbfJKRPc (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 11 Oct 2019 13:15:32 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4B7475AFDE
        for <kvm-ppc@vger.kernel.org>; Fri, 11 Oct 2019 17:15:32 +0000 (UTC)
Received: from donizetti.redhat.com (unknown [10.36.112.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63C505D6C8;
        Fri, 11 Oct 2019 17:15:31 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     cinco-list@redhat.com
Cc:     kvm-ppc@vger.kernel.org
Subject: [EMBARGOED RHEL8.1 PATCH v5 01/14] kvm: x86, powerpc: do not allow clearing largepages debugfs entry
Date:   Fri, 11 Oct 2019 19:15:13 +0200
Message-Id: <20191011171526.365-2-pbonzini@redhat.com>
In-Reply-To: <20191011171526.365-1-pbonzini@redhat.com>
References: <20191011171526.365-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 11 Oct 2019 17:15:32 +0000 (UTC)
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
---
 arch/powerpc/kvm/book3s.c |  8 ++++----
 arch/x86/kvm/x86.c        |  6 +++---
 include/linux/kvm_host.h  |  2 ++
 virt/kvm/kvm_main.c       | 10 +++++++---
 4 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index a66561db4cd3..1988332842fb 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -40,8 +40,8 @@
 #include "book3s.h"
 #include "trace.h"
 
-#define VM_STAT(x) offsetof(struct kvm, stat.x), KVM_STAT_VM
-#define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU
+#define VM_STAT(x, ...) offsetof(struct kvm, stat.x), KVM_STAT_VM, ## __VA_ARGS__
+#define VCPU_STAT(x, ...) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU, ## __VA_ARGS__
 
 /* #define EXIT_DEBUG */
 
@@ -73,8 +73,8 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "pthru_all",       VCPU_STAT(pthru_all) },
 	{ "pthru_host",      VCPU_STAT(pthru_host) },
 	{ "pthru_bad_aff",   VCPU_STAT(pthru_bad_aff) },
-	{ "largepages_2M",    VM_STAT(num_2M_pages) },
-	{ "largepages_1G",    VM_STAT(num_1G_pages) },
+	{ "largepages_2M",    VM_STAT(num_2M_pages, .mode = 0444) },
+	{ "largepages_1G",    VM_STAT(num_1G_pages, .mode = 0444) },
 	{ NULL }
 };
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 571313a87665..d6a66bb45ba7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -93,8 +93,8 @@ u64 __read_mostly efer_reserved_bits = ~((u64)(EFER_SCE | EFER_LME | EFER_LMA));
 static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 #endif
 
-#define VM_STAT(x) offsetof(struct kvm, stat.x), KVM_STAT_VM
-#define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU
+#define VM_STAT(x, ...) offsetof(struct kvm, stat.x), KVM_STAT_VM, ## __VA_ARGS__
+#define VCPU_STAT(x, ...) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU, ## __VA_ARGS__
 
 #define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | \
                                     KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
@@ -210,7 +210,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "mmu_cache_miss", VM_STAT(mmu_cache_miss) },
 	{ "mmu_unsync", VM_STAT(mmu_unsync) },
 	{ "remote_tlb_flush", VM_STAT(remote_tlb_flush) },
-	{ "largepages", VM_STAT(lpages) },
+	{ "largepages", VM_STAT(lpages, .mode = 0444) },
 	{ "max_mmu_page_hash_collisions",
 		VM_STAT(max_mmu_page_hash_collisions) },
 	{ NULL }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b8575e523f9d..6afd003294a7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1061,6 +1061,7 @@ enum kvm_stat_kind {
 
 struct kvm_stat_data {
 	int offset;
+	int mode;
 	struct kvm *kvm;
 };
 
@@ -1068,6 +1069,7 @@ struct kvm_stats_debugfs_item {
 	const char *name;
 	int offset;
 	enum kvm_stat_kind kind;
+	int mode;
 };
 extern struct kvm_stats_debugfs_item debugfs_entries[];
 extern struct dentry *kvm_debugfs_dir;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5cb1099e62c3..cf5026d4bc60 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -617,8 +617,9 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 
 		stat_data->kvm = kvm;
 		stat_data->offset = p->offset;
+		stat_data->mode = p->mode ? p->mode : 0644;
 		kvm->debugfs_stat_data[p - debugfs_entries] = stat_data;
-		debugfs_create_file(p->name, 0644, kvm->debugfs_dentry,
+		debugfs_create_file(p->name, stat_data->mode, kvm->debugfs_dentry,
 				    stat_data, stat_fops_per_vm[p->kind]);
 	}
 	return 0;
@@ -3849,7 +3850,9 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
 	if (!refcount_inc_not_zero(&stat_data->kvm->users_count))
 		return -ENOENT;
 
-	if (simple_attr_open(inode, file, get, set, fmt)) {
+	if (simple_attr_open(inode, file, get,
+			     stat_data->mode & S_IWUGO ? set : NULL,
+			     fmt)) {
 		kvm_put_kvm(stat_data->kvm);
 		return -ENOMEM;
 	}
@@ -4097,7 +4100,8 @@ static void kvm_init_debug(void)
 
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


