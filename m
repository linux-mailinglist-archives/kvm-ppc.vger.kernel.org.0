Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1C7AFBFD
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Sep 2019 13:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfIKL6L (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Sep 2019 07:58:11 -0400
Received: from ozlabs.org ([203.11.71.1]:47535 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726657AbfIKL6L (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 11 Sep 2019 07:58:11 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 46T0lh334jz9sNF; Wed, 11 Sep 2019 21:58:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1568203088;
        bh=Vy4hxNy5H4nXpVB0J5OJPxiPAovkXT8uIkQnZC3sc9c=;
        h=From:To:Cc:Subject:Date:From;
        b=Afq08k54qKNb3dYYn3ekDL9Oi35/MkC4hlktWPf0jLTQdGvyAPScXBvyLEBRf3jB7
         uHAUMdFdXSJi+4wgfcA+vgqz1oQ0mjfL0olKkpDw9jNgZ+Kta0xYDqpmAtya000XIk
         epo543XYn/LIFIYz2CdR4VbS9ZL7QNOnZ55MD3gM2M6PTCY01HpKFS2kEpbbogkBZF
         vvuv612HFPm5/VTptOHtslnvNmZDMr8OCMB8w/8XLfvJOYgUR3m6Hm32ZUE60s2amg
         Ak5p67p4H4cmR45RfgKrgmUt6JGX/S0bd+cEmI5sDEaqXquIw9SC63sm96oSkCDdwF
         BWK5TtEo1ndmQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     linuxppc-dev@ozlabs.org
Cc:     cai@lca.pw, kvm-ppc@vger.kernel.org
Subject: [PATCH 1/4] powerpc/kvm: Move kvm_tmp into .text, shrink to 64K
Date:   Wed, 11 Sep 2019 21:57:43 +1000
Message-Id: <20190911115746.12433-1-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

In some configurations of KVM, guests binary patch themselves to
avoid/reduce trapping into the hypervisor. For some instructions this
requires replacing one instruction with a sequence of instructions.

For those cases we need to write the sequence of instructions
somewhere and then patch the location of the original instruction to
branch to the sequence. That requires that the location of the
sequence be within 32MB of the original instruction.

The current solution for this is that we create a 1MB array in BSS,
write sequences into there, and then free the remainder of the array.

This has a few problems:
 - it confuses kmemleak.
 - it confuses lockdep.
 - it requires mapping kvm_tmp executable, which can cause adjacent
   areas to also be mapped executable if we're using 16M pages for the
   linear mapping.
 - the 32MB limit can be exceeded if the kernel is big enough,
   especially with STRICT_KERNEL_RWX enabled, which then prevents the
   patching from working at all.

We can fix all those problems by making kvm_tmp just a region of
regular .text. However currently it's 1MB in size, and we don't want
to waste 1MB of text. In practice however I only see ~30KB of kvm_tmp
being used even for an allyes_config. So shrink kvm_tmp to 64K, which
ought to be enough for everyone, and move it into .text.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/kernel/kvm.c      | 24 +++++-------------------
 arch/powerpc/kernel/kvm_emul.S |  8 ++++++++
 2 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/kernel/kvm.c b/arch/powerpc/kernel/kvm.c
index b7b3a5e4e224..e3b5aa583319 100644
--- a/arch/powerpc/kernel/kvm.c
+++ b/arch/powerpc/kernel/kvm.c
@@ -64,7 +64,8 @@
 #define KVM_INST_MTSRIN		0x7c0001e4
 
 static bool kvm_patching_worked = true;
-char kvm_tmp[1024 * 1024];
+extern char kvm_tmp[];
+extern char kvm_tmp_end[];
 static int kvm_tmp_index;
 
 static inline void kvm_patch_ins(u32 *inst, u32 new_inst)
@@ -132,7 +133,7 @@ static u32 *kvm_alloc(int len)
 {
 	u32 *p;
 
-	if ((kvm_tmp_index + len) > ARRAY_SIZE(kvm_tmp)) {
+	if ((kvm_tmp_index + len) > (kvm_tmp_end - kvm_tmp)) {
 		printk(KERN_ERR "KVM: No more space (%d + %d)\n",
 				kvm_tmp_index, len);
 		kvm_patching_worked = false;
@@ -699,25 +700,13 @@ static void kvm_use_magic_page(void)
 			 kvm_patching_worked ? "worked" : "failed");
 }
 
-static __init void kvm_free_tmp(void)
-{
-	/*
-	 * Inform kmemleak about the hole in the .bss section since the
-	 * corresponding pages will be unmapped with DEBUG_PAGEALLOC=y.
-	 */
-	kmemleak_free_part(&kvm_tmp[kvm_tmp_index],
-			   ARRAY_SIZE(kvm_tmp) - kvm_tmp_index);
-	free_reserved_area(&kvm_tmp[kvm_tmp_index],
-			   &kvm_tmp[ARRAY_SIZE(kvm_tmp)], -1, NULL);
-}
-
 static int __init kvm_guest_init(void)
 {
 	if (!kvm_para_available())
-		goto free_tmp;
+		return 0;
 
 	if (!epapr_paravirt_enabled)
-		goto free_tmp;
+		return 0;
 
 	if (kvm_para_has_feature(KVM_FEATURE_MAGIC_PAGE))
 		kvm_use_magic_page();
@@ -727,9 +716,6 @@ static int __init kvm_guest_init(void)
 	powersave_nap = 1;
 #endif
 
-free_tmp:
-	kvm_free_tmp();
-
 	return 0;
 }
 
diff --git a/arch/powerpc/kernel/kvm_emul.S b/arch/powerpc/kernel/kvm_emul.S
index eb2568f583ae..9dd17dce10a1 100644
--- a/arch/powerpc/kernel/kvm_emul.S
+++ b/arch/powerpc/kernel/kvm_emul.S
@@ -334,5 +334,13 @@
 kvm_emulate_mtsrin_len:
 	.long (kvm_emulate_mtsrin_end - kvm_emulate_mtsrin) / 4
 
+	.balign 4
+	.global kvm_tmp
+kvm_tmp:
+	.space	(64 * 1024)
+
+.global kvm_tmp_end
+kvm_tmp_end:
+
 .global kvm_template_end
 kvm_template_end:
-- 
2.21.0

