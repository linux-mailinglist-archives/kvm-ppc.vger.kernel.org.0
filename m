Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15963BDCA4
	for <lists+kvm-ppc@lfdr.de>; Tue,  6 Jul 2021 20:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhGFSGf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 6 Jul 2021 14:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbhGFSGe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 6 Jul 2021 14:06:34 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0468FC061574
        for <kvm-ppc@vger.kernel.org>; Tue,  6 Jul 2021 11:03:56 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id y5-20020a37af050000b02903a9c3f8b89fso17255525qke.2
        for <kvm-ppc@vger.kernel.org>; Tue, 06 Jul 2021 11:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fF6j8POF8iWLCA43O7ZfDObsMW0wQoLTlF29knN9tKg=;
        b=hHRyc03OBksoyXSj89AptvKZOBbuf2SKJOosv8ggpviRQetpsOy+KEw+8j+vfumO/R
         9MyNqJHkYMvOvVGWUMgdHCpgBK8yr9gBxRn4UVcr3rfKTjMb4NLHzQ8zy4nJK+33X166
         IdV39ReiPwMxnsjweT1I9eTRG9RiFTP3OTUpm+5+Q+jN79OA6pkctVb+BHK+E+ACWbhM
         SknIzUxswsNUUgjGnMIyCEpKP52ldnNYlipLVdjS/2/lJUEu4yO8xkTZBa0bWMxSkY3K
         49taI/LuZGDj+gSQqk4qUqq/oeoO29AW9cHM4IMIT/XmVniR6pBDv4hjVgl7jHG3aeQM
         0Sug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fF6j8POF8iWLCA43O7ZfDObsMW0wQoLTlF29knN9tKg=;
        b=iR9CCT2qymRRrm+wicWCB8rWgayvOFbwkHphsxU1FMnGm12MEx0kXSMbmVKvWIvog/
         HrBNN/5/tWcYwZ+hTqV8RjP6KbCh3s7QoiYvgcgHNg5c4z4GxqE5d06piJYbDHb7wU9m
         mcQXkYn6nU4fze2B15rZr6cvSyFAc6B6DJxQl0YPFmcbZhDq3busaOsmkUFMLk67qaY2
         b+Gx3gMbr3yMyEKIWOLUfcX+BxHKv7Q473qKlh8McL9Rz+19jCpuwBlGsW95SEWwQ9C/
         9M5GjL3xZepqO0y7C7B0Y3zbEDlzQxclrY0wFPCQDhDeru5Ju3tQVNFKUCuIy0H8OBvI
         B2pQ==
X-Gm-Message-State: AOAM5319yJn1oO9T2zsaCGvU7sAcJ/YLq7ffFxnCX9JmXvfU1mOoHv7M
        vVk49nUcNodQSASWY29byw6UR14cMMK7B3fMGA==
X-Google-Smtp-Source: ABdhPJzwzjtXd/x2FeBGe16SmcPRnxkwEm8GQ2lTaxo9PvBJj/UVzE1g3b2RBv7jkQA1GUzwRU8OgpCoFkuYFpF3nQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6214:8ec:: with SMTP id
 dr12mr20074756qvb.12.1625594635091; Tue, 06 Jul 2021 11:03:55 -0700 (PDT)
Date:   Tue,  6 Jul 2021 18:03:47 +0000
In-Reply-To: <20210706180350.2838127-1-jingzhangos@google.com>
Message-Id: <20210706180350.2838127-2-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210706180350.2838127-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v1 1/4] KVM: stats: Support linear and logarithmic histogram statistics
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
 include/linux/kvm_host.h  | 53 ++++++++++++++++++++++++++++-----------
 include/linux/kvm_types.h | 16 ++++++++++++
 include/uapi/linux/kvm.h  | 11 +++++---
 virt/kvm/binary_stats.c   | 36 ++++++++++++++++++++++++++
 10 files changed, 98 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 1512a8007a78..cb44d8756fa7 100644
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
index 1695f0ced5ba..7610d33d319b 100644
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
 	STATS_DESC_COUNTER(VCPU, diagnose_other),
 	STATS_DESC_COUNTER(VCPU, pfault_sync)
 };
-static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
-		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8166ad113fb2..b94a80ad5b8d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -239,8 +239,6 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_ICOUNTER(VM, nx_lpage_splits),
 	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions)
 };
-static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
-		sizeof(struct kvm_vm_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vm_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
@@ -280,8 +278,6 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, directed_yield_successful),
 	STATS_DESC_ICOUNTER(VCPU, guest_mode)
 };
-static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
-		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ae7735b490b4..356af173114d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1273,56 +1273,66 @@ struct _kvm_stats_desc {
 	char name[KVM_STATS_NAME_SIZE];
 };
 
-#define STATS_DESC_COMMON(type, unit, base, exp)			       \
+#define STATS_DESC_COMMON(type, unit, base, exp, sz, param)		       \
 	.flags = type | unit | base |					       \
 		 BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |	       \
 		 BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |	       \
 		 BUILD_BUG_ON_ZERO(base & ~KVM_STATS_BASE_MASK),	       \
 	.exponent = exp,						       \
-	.size = 1
+	.size = sz,							       \
+	.hist_param = param
 
-#define VM_GENERIC_STATS_DESC(stat, type, unit, base, exp)		       \
+#define VM_GENERIC_STATS_DESC(stat, type, unit, base, exp, sz, param)	       \
 	{								       \
 		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp),	       \
+			STATS_DESC_COMMON(type, unit, base, exp, sz, param),   \
 			.offset = offsetof(struct kvm_vm_stat, generic.stat)   \
 		},							       \
 		.name = #stat,						       \
 	}
-#define VCPU_GENERIC_STATS_DESC(stat, type, unit, base, exp)		       \
+#define VCPU_GENERIC_STATS_DESC(stat, type, unit, base, exp, sz, param)	       \
 	{								       \
 		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp),	       \
+			STATS_DESC_COMMON(type, unit, base, exp, sz, param),   \
 			.offset = offsetof(struct kvm_vcpu_stat, generic.stat) \
 		},							       \
 		.name = #stat,						       \
 	}
-#define VM_STATS_DESC(stat, type, unit, base, exp)			       \
+#define VM_STATS_DESC(stat, type, unit, base, exp, sz, param)		       \
 	{								       \
 		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp),	       \
+			STATS_DESC_COMMON(type, unit, base, exp, sz, param),   \
 			.offset = offsetof(struct kvm_vm_stat, stat)	       \
 		},							       \
 		.name = #stat,						       \
 	}
-#define VCPU_STATS_DESC(stat, type, unit, base, exp)			       \
+#define VCPU_STATS_DESC(stat, type, unit, base, exp, sz, param)		       \
 	{								       \
 		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp),	       \
+			STATS_DESC_COMMON(type, unit, base, exp, sz, param),   \
 			.offset = offsetof(struct kvm_vcpu_stat, stat)	       \
 		},							       \
 		.name = #stat,						       \
 	}
 /* SCOPE: VM, VM_GENERIC, VCPU, VCPU_GENERIC */
-#define STATS_DESC(SCOPE, stat, type, unit, base, exp)			       \
-	SCOPE##_STATS_DESC(stat, type, unit, base, exp)
+#define STATS_DESC(SCOPE, stat, type, unit, base, exp, sz, param)	       \
+	SCOPE##_STATS_DESC(stat, type, unit, base, exp, sz, param)
 
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
+#define STATS_DESC_LINEAR_HIST(SCOPE, name, unit, base, exponent, sz, param)   \
+	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_LINEAR_HIST,		       \
+		unit, base, exponent, sz, param)
+#define STATS_DESC_LOG_HIST(SCOPE, name, unit, base, exponent, sz, param)      \
+	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_LOG_HIST,		       \
+		unit, base, exponent, sz, param)
 
 /* Cumulative counter, read/write */
 #define STATS_DESC_COUNTER(SCOPE, name)					       \
@@ -1341,6 +1351,14 @@ struct _kvm_stats_desc {
 #define STATS_DESC_TIME_NSEC(SCOPE, name)				       \
 	STATS_DESC_CUMULATIVE(SCOPE, name, KVM_STATS_UNIT_SECONDS,	       \
 		KVM_STATS_BASE_POW10, -9)
+/* Linear histogram for time in nanosecond */
+#define STATS_DESC_LINHIST_TIME_NSEC(SCOPE, name, sz, bucket_size)	       \
+	STATS_DESC_LINEAR_HIST(SCOPE, name, KVM_STATS_UNIT_SECONDS,	       \
+		KVM_STATS_BASE_POW10, -9, sz, bucket_size)
+/* Logarithmic histogram for time in nanosecond */
+#define STATS_DESC_LOGHIST_TIME_NSEC(SCOPE, name, sz)			       \
+	STATS_DESC_LOG_HIST(SCOPE, name, KVM_STATS_UNIT_SECONDS,	       \
+		KVM_STATS_BASE_POW10, -9, sz, LOGHIST_BASE_2)
 
 #define KVM_GENERIC_VM_STATS()						       \
 	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush)
@@ -1354,10 +1372,15 @@ struct _kvm_stats_desc {
 	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_ns)
 
 extern struct dentry *kvm_debugfs_dir;
+
 ssize_t kvm_stats_read(char *id, const struct kvm_stats_header *header,
 		       const struct _kvm_stats_desc *desc,
 		       void *stats, size_t size_stats,
 		       char __user *user_buffer, size_t size, loff_t *offset);
+void kvm_stats_linear_hist_update(u64 *data, size_t size,
+				  u64 value, size_t bucket_size);
+void kvm_stats_log_hist_update(u64 *data, size_t size, u64 value);
+
 extern const struct kvm_stats_header kvm_vm_stats_header;
 extern const struct _kvm_stats_desc kvm_vm_stats_desc[];
 extern const struct kvm_stats_header kvm_vcpu_stats_header;
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index ed6a985c5680..cc88cd676775 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -76,6 +76,22 @@ struct kvm_mmu_memory_cache {
 };
 #endif
 
+/* Constants used for histogram stats */
+#define LINHIST_SIZE_SMALL		10
+#define LINHIST_SIZE_MEDIUM		20
+#define LINHIST_SIZE_LARGE		50
+#define LINHIST_SIZE_XLARGE		100
+#define LINHIST_BUCKET_SIZE_SMALL	10
+#define LINHIST_BUCKET_SIZE_MEDIUM	100
+#define LINHIST_BUCKET_SIZE_LARGE	1000
+#define LINHIST_BUCKET_SIZE_XLARGE	10000
+
+#define LOGHIST_SIZE_SMALL		8
+#define LOGHIST_SIZE_MEDIUM		16
+#define LOGHIST_SIZE_LARGE		32
+#define LOGHIST_SIZE_XLARGE		64
+#define LOGHIST_BASE_2			2
+
 struct kvm_vm_stat_generic {
 	u64 remote_tlb_flush;
 };
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 68c9e6d8bbda..ff34a471d9ef 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1963,7 +1963,9 @@ struct kvm_stats_header {
 #define KVM_STATS_TYPE_CUMULATIVE	(0x0 << KVM_STATS_TYPE_SHIFT)
 #define KVM_STATS_TYPE_INSTANT		(0x1 << KVM_STATS_TYPE_SHIFT)
 #define KVM_STATS_TYPE_PEAK		(0x2 << KVM_STATS_TYPE_SHIFT)
-#define KVM_STATS_TYPE_MAX		KVM_STATS_TYPE_PEAK
+#define KVM_STATS_TYPE_LINEAR_HIST	(0x3 << KVM_STATS_TYPE_SHIFT)
+#define KVM_STATS_TYPE_LOG_HIST		(0x4 << KVM_STATS_TYPE_SHIFT)
+#define KVM_STATS_TYPE_MAX		KVM_STATS_TYPE_LOG_HIST
 
 #define KVM_STATS_UNIT_SHIFT		4
 #define KVM_STATS_UNIT_MASK		(0xF << KVM_STATS_UNIT_SHIFT)
@@ -1987,7 +1989,10 @@ struct kvm_stats_header {
  *        Every data item is of type __u64.
  * @offset: The offset of the stats to the start of stat structure in
  *          struture kvm or kvm_vcpu.
- * @unused: Unused field for future usage. Always 0 for now.
+ * @hist_param: A parameter value used for histogram stats. For linear
+ *              histogram stats, it indicates the size of the bucket;
+ *              For logarithmic histogram stats, it indicates the base
+ *              of the logarithm. Only base of 2 is supported.
  * @name: The name string for the stats. Its size is indicated by the
  *        &kvm_stats_header->name_size.
  */
@@ -1996,7 +2001,7 @@ struct kvm_stats_desc {
 	__s16 exponent;
 	__u16 size;
 	__u32 offset;
-	__u32 unused;
+	__u32 hist_param;
 	char name[];
 };
 
diff --git a/virt/kvm/binary_stats.c b/virt/kvm/binary_stats.c
index e609d428811a..6eead6979a7f 100644
--- a/virt/kvm/binary_stats.c
+++ b/virt/kvm/binary_stats.c
@@ -144,3 +144,39 @@ ssize_t kvm_stats_read(char *id, const struct kvm_stats_header *header,
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
+void kvm_stats_linear_hist_update(u64 *data, size_t size,
+				  u64 value, size_t bucket_size)
+{
+	size_t index = value / bucket_size;
+
+	if (index >= size)
+		index = size - 1;
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
+void kvm_stats_log_hist_update(u64 *data, size_t size, u64 value)
+{
+	size_t index = fls64(value);
+
+	if (index >= size)
+		index = size - 1;
+	++data[index];
+}
-- 
2.32.0.93.g670b81a890-goog

