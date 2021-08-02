Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328293DDE15
	for <lists+kvm-ppc@lfdr.de>; Mon,  2 Aug 2021 18:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhHBQ4t (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 2 Aug 2021 12:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbhHBQ4t (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 2 Aug 2021 12:56:49 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44F5C06175F
        for <kvm-ppc@vger.kernel.org>; Mon,  2 Aug 2021 09:56:38 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id n16-20020a170902d2d0b029012c52457579so14107308plc.8
        for <kvm-ppc@vger.kernel.org>; Mon, 02 Aug 2021 09:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=geLfL3RFrvWGzEu404aUIFgMJax7XU5NfnL8d2BNpsI=;
        b=ttLIfdb96//+IEo871vCgJguveTA8wHBXpn3PbjTdfc3lFerJlgvxjm9KjOHK0Olre
         v0wTc1B7VfL3Ko2begkEwBiJWWMzHnIX/Y89bMWYvhpSNoyTLyiGoiNQrIw5AfyAou5n
         BckDBuufobfNijIxHpN46n4YrpdWo/6qg4FlikPqSSgEmtmslDNDErX3Jw8ZRCiMpj+3
         +zI0XRcJlVk912s6SDeNlh1s8vIy51Ntla5VELzEyNn5YPANaYoJzG1yh6EifUQDLW0k
         nVCMSiL12hONyVF15pFJeUhmrQavmrhJgD6RBdxsOVxl8QHRMrYoLCZfwzeebqosu4qH
         o9xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=geLfL3RFrvWGzEu404aUIFgMJax7XU5NfnL8d2BNpsI=;
        b=SwDLeX2W8eGOZuJ9GvsLBr0DT2Qqzg0TQiqIbH+0jlLaQzRVywxQNXNdixD99Azfsj
         bh+xpjO9kDtGDGA8BKwYsPtEuA4Gcm55OGWF1Y6Sj/7gAjqCLQxcNYZNfdsSxpG8syvx
         7rvJgN0/EcVavkpAjp5DgRFi3Yh9VgqXa9yLVwsfpxXxVGuiDlTNVQmP1D0rXb9S+SJw
         IymdHOt5t9Wabq+AvhJh5ghZkABh+x1OvioL+1oSWA2ibiF61OYXz3/RMZCW7t9C92fk
         uTXB8RFBZoD5DGoJYIh1+V7xgTr5+cKUAxcNJLA1f0U9bg5Lr8GLxsBNJyjjz8gv8MJb
         ACRw==
X-Gm-Message-State: AOAM532UYyXN9Et4RMtRAiAF9DedGgMmAMyby8FXJQ3wGRjWBG9GAjPK
        NTpcJfpoocrRmQ9sEhQG53nZ16S88a2zMbYv6Q==
X-Google-Smtp-Source: ABdhPJz/QFAdCsCmtgNrXYDv4ELMJHAv9AH21OTKML2fHJ6HxmWuulMDkGAyu/vA6yFoqhCf6GYoEDVq1lOarguKhA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90b:3754:: with SMTP id
 ne20mr18403243pjb.74.1627923398268; Mon, 02 Aug 2021 09:56:38 -0700 (PDT)
Date:   Mon,  2 Aug 2021 16:56:29 +0000
In-Reply-To: <20210802165633.1866976-1-jingzhangos@google.com>
Message-Id: <20210802165633.1866976-2-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210802165633.1866976-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v3 1/5] KVM: stats: Support linear and logarithmic histogram statistics
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Add new types of KVM stats, linear and logarithmic histogram.
Histogram are very useful for observing the value distribution
of time or size related stats.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/guest.c    |  4 ---
 arch/mips/kvm/mips.c      |  4 ---
 arch/powerpc/kvm/book3s.c |  4 ---
 arch/powerpc/kvm/booke.c  |  4 ---
 arch/s390/kvm/kvm-s390.c  |  4 ---
 arch/x86/kvm/x86.c        |  4 ---
 include/linux/kvm_host.h  | 58 +++++++++++++++++++++++++++++----------
 include/uapi/linux/kvm.h  | 11 +++++---
 virt/kvm/binary_stats.c   | 34 +++++++++++++++++++++++
 9 files changed, 84 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 1dfb83578277..5188184d25d0 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -31,8 +31,6 @@
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS()
 };
-static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
-		sizeof(struct kvm_vm_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vm_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
@@ -52,8 +50,6 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, mmio_exit_kernel),
 	STATS_DESC_COUNTER(VCPU, exits)
 };
-static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
-		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index af9dd029a4e1..75c6f264c626 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -41,8 +41,6 @@
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS()
 };
-static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
-		sizeof(struct kvm_vm_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vm_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
@@ -85,8 +83,6 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, vz_cpucfg_exits),
 #endif
 };
-static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
-		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 79833f78d1da..5cc6e90095b0 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -43,8 +43,6 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_ICOUNTER(VM, num_2M_pages),
 	STATS_DESC_ICOUNTER(VM, num_1G_pages)
 };
-static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
-		sizeof(struct kvm_vm_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vm_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
@@ -88,8 +86,6 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, pthru_host),
 	STATS_DESC_COUNTER(VCPU, pthru_bad_aff)
 };
-static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
-		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 551b30d84aee..5ed6c235e059 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -41,8 +41,6 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_ICOUNTER(VM, num_2M_pages),
 	STATS_DESC_ICOUNTER(VM, num_1G_pages)
 };
-static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
-		sizeof(struct kvm_vm_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vm_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
@@ -79,8 +77,6 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, pthru_host),
 	STATS_DESC_COUNTER(VCPU, pthru_bad_aff)
 };
-static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
-		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 4527ac7b5961..7789eb37bed3 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -66,8 +66,6 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_COUNTER(VM, inject_service_signal),
 	STATS_DESC_COUNTER(VM, inject_virtio)
 };
-static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
-		sizeof(struct kvm_vm_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vm_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
@@ -174,8 +172,6 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, instruction_diagnose_other),
 	STATS_DESC_COUNTER(VCPU, pfault_sync)
 };
-static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
-		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 916c976e99ab..19c0d0b8f98a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -238,8 +238,6 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_PCOUNTER(VM, max_mmu_rmap_size),
 	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions)
 };
-static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
-		sizeof(struct kvm_vm_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vm_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
@@ -279,8 +277,6 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, directed_yield_successful),
 	STATS_DESC_ICOUNTER(VCPU, guest_mode)
 };
-static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
-		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9d6b4ad407b8..b90c9cb8ddbb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1306,56 +1306,66 @@ struct _kvm_stats_desc {
 	char name[KVM_STATS_NAME_SIZE];
 };
 
-#define STATS_DESC_COMMON(type, unit, base, exp)			       \
+#define STATS_DESC_COMMON(type, unit, base, exp, sz, bsz)		       \
 	.flags = type | unit | base |					       \
 		 BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |	       \
 		 BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |	       \
 		 BUILD_BUG_ON_ZERO(base & ~KVM_STATS_BASE_MASK),	       \
 	.exponent = exp,						       \
-	.size = 1
+	.size = sz,							       \
+	.bucket_size = bsz
 
-#define VM_GENERIC_STATS_DESC(stat, type, unit, base, exp)		       \
+#define VM_GENERIC_STATS_DESC(stat, type, unit, base, exp, sz, bsz)	       \
 	{								       \
 		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp),	       \
+			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
 			.offset = offsetof(struct kvm_vm_stat, generic.stat)   \
 		},							       \
 		.name = #stat,						       \
 	}
-#define VCPU_GENERIC_STATS_DESC(stat, type, unit, base, exp)		       \
+#define VCPU_GENERIC_STATS_DESC(stat, type, unit, base, exp, sz, bsz)	       \
 	{								       \
 		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp),	       \
+			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
 			.offset = offsetof(struct kvm_vcpu_stat, generic.stat) \
 		},							       \
 		.name = #stat,						       \
 	}
-#define VM_STATS_DESC(stat, type, unit, base, exp)			       \
+#define VM_STATS_DESC(stat, type, unit, base, exp, sz, bsz)		       \
 	{								       \
 		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp),	       \
+			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
 			.offset = offsetof(struct kvm_vm_stat, stat)	       \
 		},							       \
 		.name = #stat,						       \
 	}
-#define VCPU_STATS_DESC(stat, type, unit, base, exp)			       \
+#define VCPU_STATS_DESC(stat, type, unit, base, exp, sz, bsz)		       \
 	{								       \
 		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp),	       \
+			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
 			.offset = offsetof(struct kvm_vcpu_stat, stat)	       \
 		},							       \
 		.name = #stat,						       \
 	}
 /* SCOPE: VM, VM_GENERIC, VCPU, VCPU_GENERIC */
-#define STATS_DESC(SCOPE, stat, type, unit, base, exp)			       \
-	SCOPE##_STATS_DESC(stat, type, unit, base, exp)
+#define STATS_DESC(SCOPE, stat, type, unit, base, exp, sz, bsz)		       \
+	SCOPE##_STATS_DESC(stat, type, unit, base, exp, sz, bsz)
 
 #define STATS_DESC_CUMULATIVE(SCOPE, name, unit, base, exponent)	       \
-	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_CUMULATIVE, unit, base, exponent)
+	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_CUMULATIVE,		       \
+		unit, base, exponent, 1, 0)
 #define STATS_DESC_INSTANT(SCOPE, name, unit, base, exponent)		       \
-	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_INSTANT, unit, base, exponent)
+	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_INSTANT,			       \
+		unit, base, exponent, 1, 0)
 #define STATS_DESC_PEAK(SCOPE, name, unit, base, exponent)		       \
-	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_PEAK, unit, base, exponent)
+	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_PEAK,			       \
+		unit, base, exponent, 1, 0)
+#define STATS_DESC_LINEAR_HIST(SCOPE, name, unit, base, exponent, sz, bsz)     \
+	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_LINEAR_HIST,		       \
+		unit, base, exponent, sz, bsz)
+#define STATS_DESC_LOG_HIST(SCOPE, name, unit, base, exponent, sz)	       \
+	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_LOG_HIST,		       \
+		unit, base, exponent, sz, 0)
 
 /* Cumulative counter, read/write */
 #define STATS_DESC_COUNTER(SCOPE, name)					       \
@@ -1374,6 +1384,14 @@ struct _kvm_stats_desc {
 #define STATS_DESC_TIME_NSEC(SCOPE, name)				       \
 	STATS_DESC_CUMULATIVE(SCOPE, name, KVM_STATS_UNIT_SECONDS,	       \
 		KVM_STATS_BASE_POW10, -9)
+/* Linear histogram for time in nanosecond */
+#define STATS_DESC_LINHIST_TIME_NSEC(SCOPE, name, sz, bsz)		       \
+	STATS_DESC_LINEAR_HIST(SCOPE, name, KVM_STATS_UNIT_SECONDS,	       \
+		KVM_STATS_BASE_POW10, -9, sz, bsz)
+/* Logarithmic histogram for time in nanosecond */
+#define STATS_DESC_LOGHIST_TIME_NSEC(SCOPE, name, sz)			       \
+	STATS_DESC_LOG_HIST(SCOPE, name, KVM_STATS_UNIT_SECONDS,	       \
+		KVM_STATS_BASE_POW10, -9, sz)
 
 #define KVM_GENERIC_VM_STATS()						       \
 	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush)
@@ -1387,10 +1405,20 @@ struct _kvm_stats_desc {
 	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_ns)
 
 extern struct dentry *kvm_debugfs_dir;
+
 ssize_t kvm_stats_read(char *id, const struct kvm_stats_header *header,
 		       const struct _kvm_stats_desc *desc,
 		       void *stats, size_t size_stats,
 		       char __user *user_buffer, size_t size, loff_t *offset);
+inline void kvm_stats_linear_hist_update(u64 *data, size_t size,
+				  u64 value, size_t bucket_size);
+inline void kvm_stats_log_hist_update(u64 *data, size_t size, u64 value);
+#define KVM_STATS_LINEAR_HIST_UPDATE(array, value, bsize)		       \
+	kvm_stats_linear_hist_update(array, ARRAY_SIZE(array), value, bsize)
+#define KVM_STATS_LOG_HIST_UPDATE(array, value)				       \
+	kvm_stats_log_hist_update(array, ARRAY_SIZE(array), value)
+
+
 extern const struct kvm_stats_header kvm_vm_stats_header;
 extern const struct _kvm_stats_desc kvm_vm_stats_desc[];
 extern const struct kvm_stats_header kvm_vcpu_stats_header;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d9e4aabcb31a..a067410ebea5 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1965,7 +1965,9 @@ struct kvm_stats_header {
 #define KVM_STATS_TYPE_CUMULATIVE	(0x0 << KVM_STATS_TYPE_SHIFT)
 #define KVM_STATS_TYPE_INSTANT		(0x1 << KVM_STATS_TYPE_SHIFT)
 #define KVM_STATS_TYPE_PEAK		(0x2 << KVM_STATS_TYPE_SHIFT)
-#define KVM_STATS_TYPE_MAX		KVM_STATS_TYPE_PEAK
+#define KVM_STATS_TYPE_LINEAR_HIST	(0x3 << KVM_STATS_TYPE_SHIFT)
+#define KVM_STATS_TYPE_LOG_HIST		(0x4 << KVM_STATS_TYPE_SHIFT)
+#define KVM_STATS_TYPE_MAX		KVM_STATS_TYPE_LOG_HIST
 
 #define KVM_STATS_UNIT_SHIFT		4
 #define KVM_STATS_UNIT_MASK		(0xF << KVM_STATS_UNIT_SHIFT)
@@ -1988,8 +1990,9 @@ struct kvm_stats_header {
  * @size: The number of data items for this stats.
  *        Every data item is of type __u64.
  * @offset: The offset of the stats to the start of stat structure in
- *          struture kvm or kvm_vcpu.
- * @unused: Unused field for future usage. Always 0 for now.
+ *          structure kvm or kvm_vcpu.
+ * @bucket_size: A parameter value used for histogram stats. It is only used
+ *		for linear histogram stats, specifying the size of the bucket;
  * @name: The name string for the stats. Its size is indicated by the
  *        &kvm_stats_header->name_size.
  */
@@ -1998,7 +2001,7 @@ struct kvm_stats_desc {
 	__s16 exponent;
 	__u16 size;
 	__u32 offset;
-	__u32 unused;
+	__u32 bucket_size;
 	char name[];
 };
 
diff --git a/virt/kvm/binary_stats.c b/virt/kvm/binary_stats.c
index e609d428811a..b6267e747934 100644
--- a/virt/kvm/binary_stats.c
+++ b/virt/kvm/binary_stats.c
@@ -144,3 +144,37 @@ ssize_t kvm_stats_read(char *id, const struct kvm_stats_header *header,
 	*offset = pos;
 	return len;
 }
+
+/**
+ * kvm_stats_linear_hist_update() - Update bucket value for linear histogram
+ * statistics data.
+ *
+ * @data: start address of the stats data
+ * @size: the number of bucket of the stats data
+ * @value: the new value used to update the linear histogram's bucket
+ * @bucket_size: the size (width) of a bucket
+ */
+inline void kvm_stats_linear_hist_update(u64 *data, size_t size,
+				  u64 value, size_t bucket_size)
+{
+	size_t index = div64_u64(value, bucket_size);
+
+	index = array_index_nospec(index, size);
+	++data[index];
+}
+
+/**
+ * kvm_stats_log_hist_update() - Update bucket value for logarithmic histogram
+ * statistics data.
+ *
+ * @data: start address of the stats data
+ * @size: the number of bucket of the stats data
+ * @value: the new value used to update the logarithmic histogram's bucket
+ */
+inline void kvm_stats_log_hist_update(u64 *data, size_t size, u64 value)
+{
+	size_t index = fls64(value);
+
+	index = array_index_nospec(index, size);
+	++data[index];
+}
-- 
2.32.0.554.ge1b32706d8-goog

