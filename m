Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13730156A2E
	for <lists+kvm-ppc@lfdr.de>; Sun,  9 Feb 2020 13:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbgBIM4W (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 9 Feb 2020 07:56:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:44616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727514AbgBIM4W (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 9 Feb 2020 07:56:22 -0500
Received: from localhost (unknown [38.98.37.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6F9720733;
        Sun,  9 Feb 2020 12:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581252981;
        bh=wEuQkILbzCrkndaHaGMt/QtlgcEM66cBemstNp3v6fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q0pvgGxmXPCg+rjYkFKJt2HyuXWgGZhiT7YOmln8fKJBzYM12o/J5X1vbWBzh0oeF
         Lq/3rIDWIZgfAtdZxifVETZ/neuldW0mlzsYEYkBkP6uqbgHtUa1VwGzmeUklx18du
         uCFghsuR0sqpWrr+L2oCz8XA374intx0hYUB0BqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org
Subject: [PATCH 2/6] powerpc: kvm: no need to check return value of debugfs_create functions
Date:   Sun,  9 Feb 2020 11:58:57 +0100
Message-Id: <20200209105901.1620958-2-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200209105901.1620958-1-gregkh@linuxfoundation.org>
References: <20200209105901.1620958-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Because of this cleanup, we get to remove a few fields in struct
kvm_arch that are now unused.

Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: kvm-ppc@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/kvm_host.h    |  3 ---
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  5 ++---
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  5 ++---
 arch/powerpc/kvm/book3s_hv.c           |  9 ++-------
 arch/powerpc/kvm/timing.c              | 13 +++----------
 5 files changed, 9 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 6e8b8ffd06ad..877f8aa2bc1e 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -308,8 +308,6 @@ struct kvm_arch {
 	pgd_t *pgtable;
 	u64 process_table;
 	struct dentry *debugfs_dir;
-	struct dentry *htab_dentry;
-	struct dentry *radix_dentry;
 	struct kvm_resize_hpt *resize_hpt; /* protected by kvm->lock */
 #endif /* CONFIG_KVM_BOOK3S_HV_POSSIBLE */
 #ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
@@ -830,7 +828,6 @@ struct kvm_vcpu_arch {
 	struct kvmhv_tb_accumulator cede_time;	/* time napping inside guest */
 
 	struct dentry *debugfs_dir;
-	struct dentry *debugfs_timings;
 #endif /* CONFIG_KVM_BOOK3S_HV_EXIT_TIMING */
 };
 
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 6c372f5c61b6..8b4eac0c9dcd 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -2138,9 +2138,8 @@ static const struct file_operations debugfs_htab_fops = {
 
 void kvmppc_mmu_debugfs_init(struct kvm *kvm)
 {
-	kvm->arch.htab_dentry = debugfs_create_file("htab", 0400,
-						    kvm->arch.debugfs_dir, kvm,
-						    &debugfs_htab_fops);
+	debugfs_create_file("htab", 0400, kvm->arch.debugfs_dir, kvm,
+			    &debugfs_htab_fops);
 }
 
 void kvmppc_mmu_book3s_hv_init(struct kvm_vcpu *vcpu)
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 803940d79b73..1d75ed684b53 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -1376,9 +1376,8 @@ static const struct file_operations debugfs_radix_fops = {
 
 void kvmhv_radix_debugfs_init(struct kvm *kvm)
 {
-	kvm->arch.radix_dentry = debugfs_create_file("radix", 0400,
-						     kvm->arch.debugfs_dir, kvm,
-						     &debugfs_radix_fops);
+	debugfs_create_file("radix", 0400, kvm->arch.debugfs_dir, kvm,
+			    &debugfs_radix_fops);
 }
 
 int kvmppc_radix_init(void)
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 2cefd071b848..33be4d93248a 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2258,14 +2258,9 @@ static void debugfs_vcpu_init(struct kvm_vcpu *vcpu, unsigned int id)
 	struct kvm *kvm = vcpu->kvm;
 
 	snprintf(buf, sizeof(buf), "vcpu%u", id);
-	if (IS_ERR_OR_NULL(kvm->arch.debugfs_dir))
-		return;
 	vcpu->arch.debugfs_dir = debugfs_create_dir(buf, kvm->arch.debugfs_dir);
-	if (IS_ERR_OR_NULL(vcpu->arch.debugfs_dir))
-		return;
-	vcpu->arch.debugfs_timings =
-		debugfs_create_file("timings", 0444, vcpu->arch.debugfs_dir,
-				    vcpu, &debugfs_timings_ops);
+	debugfs_create_file("timings", 0444, vcpu->arch.debugfs_dir, vcpu,
+			    &debugfs_timings_ops);
 }
 
 #else /* CONFIG_KVM_BOOK3S_HV_EXIT_TIMING */
diff --git a/arch/powerpc/kvm/timing.c b/arch/powerpc/kvm/timing.c
index bfe4f106cffc..8e4791c6f2af 100644
--- a/arch/powerpc/kvm/timing.c
+++ b/arch/powerpc/kvm/timing.c
@@ -207,19 +207,12 @@ static const struct file_operations kvmppc_exit_timing_fops = {
 void kvmppc_create_vcpu_debugfs(struct kvm_vcpu *vcpu, unsigned int id)
 {
 	static char dbg_fname[50];
-	struct dentry *debugfs_file;
 
 	snprintf(dbg_fname, sizeof(dbg_fname), "vm%u_vcpu%u_timing",
 		 current->pid, id);
-	debugfs_file = debugfs_create_file(dbg_fname, 0666,
-					kvm_debugfs_dir, vcpu,
-					&kvmppc_exit_timing_fops);
-
-	if (!debugfs_file) {
-		printk(KERN_ERR"%s: error creating debugfs file %s\n",
-			__func__, dbg_fname);
-		return;
-	}
+	debugfs_create_file(dbg_fname, 0666, kvm_debugfs_dir, vcpu,
+			    &kvmppc_exit_timing_fops);
+
 
 	vcpu->arch.debugfs_exit_timing = debugfs_file;
 }
-- 
2.25.0

