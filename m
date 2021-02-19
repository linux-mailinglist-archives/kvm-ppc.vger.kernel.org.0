Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1585131F524
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Feb 2021 07:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhBSGhV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Feb 2021 01:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbhBSGhU (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 Feb 2021 01:37:20 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7898CC0617A9
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:36:22 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id o63so3049620pgo.6
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MRLaAUqP62oNAp3IL0JYotqpIWSAbZqrdTjD8x9i/WU=;
        b=S3LXCLtV23W9BmjyUQvkEJ992YDR9vejPEYYr8RZ179ldn3VPCOw6DcDatTQeSGxmd
         zQOfrNmJD0Q05lHq94/BVbLIGP+xN6Oj33U8Igib2NEGC0wxdvJaBX3UbyxU1HBW7eKr
         Xv7nCEyH+/KsA6ACJIVIkrN67lj52OjUsmsdtxaF2MYmT+e4PTX/MqKzg2skvZbYADE+
         eVnm0uWzS+tlN+LyIXw4fe3q11BkPqDse6EZu5ElT2073PClZuiu5T7ANCY5hrvSh2wL
         OmTdod1N1gd5hybrzD6emak073NaI2GXwPZWQ+TEi81UoQKBgU44CFpVg8jAC4iUn/Ow
         okGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MRLaAUqP62oNAp3IL0JYotqpIWSAbZqrdTjD8x9i/WU=;
        b=LD8jNlUQxGSDIJPKv8vqOoCjIPKznr2Pnn10KfL0Sgroim6JalMQ19thC/eAKmq+2n
         I5jqmvEey70tBhOzOuGn9zhTrsqqxJhJXVoRhcSkHX1BpoeYUEj+hGkU1NOG2dcsUQqQ
         y3vUtfQKlH47/9R33ZXjBGG4SAdudjUf7AUhOxPgTnapr3RkhscCAJCeri5uOsKZu9nT
         FSzGCVPShGyzOxLGgPIkhxEx6lL5Bxo3O39UTwBjZdXTMsG3DWFelQl9ENdK6m3jUge4
         2A5l32tgzjEbYFHLpPNEVxrBIKGfounmTQgRNydkcWHFWZgsenYA2PiUVXoJTFEqlr23
         ExQw==
X-Gm-Message-State: AOAM532vnLNdJV2nW946zBencLecKA0k/vevmpIJeVWww/Er2T7aHG4I
        lGugkPMlzB8ETWxhHKaURm0/qJTeoAQ=
X-Google-Smtp-Source: ABdhPJzC/UozbW+wyw/TBtVO+Flw+x75PPVk2S6gvuJ725hXmQdGdMgIRcuMta44oDMqVeMI7j6F/Q==
X-Received: by 2002:a63:789:: with SMTP id 131mr2886390pgh.182.1613716581645;
        Thu, 18 Feb 2021 22:36:21 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (14-201-150-91.tpgi.com.au. [14.201.150.91])
        by smtp.gmail.com with ESMTPSA id v16sm7813099pfu.76.2021.02.18.22.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 22:36:21 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 11/13] KVM: PPC: Book3S HV: Minimise hcall handler calling convention differences
Date:   Fri, 19 Feb 2021 16:35:40 +1000
Message-Id: <20210219063542.1425130-12-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210219063542.1425130-1-npiggin@gmail.com>
References: <20210219063542.1425130-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This sets up the same calling convention from interrupt entry to
KVM interrupt handler for system calls as exists for other interrupt
types.

This is a better API, it uses a save area rather than SPR, and it has
more registers free to use. Using a single common API helps maintain
it, and it becomes easier to use in C in a later patch.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/exceptions-64s.S | 16 +++++++++++++++-
 arch/powerpc/kvm/book3s_64_entry.S   | 22 +++-------------------
 2 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 4878f05b5325..6f086ee922e0 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1923,8 +1923,22 @@ EXC_VIRT_END(system_call, 0x4c00, 0x100)
 
 #ifdef CONFIG_KVM_BOOK3S_64_HANDLER
 TRAMP_REAL_BEGIN(kvm_hcall)
+	std	r9,PACA_EXGEN+EX_R9(r13)
+	std	r11,PACA_EXGEN+EX_R11(r13)
+	std	r12,PACA_EXGEN+EX_R12(r13)
+	mfcr	r9
 	mfctr	r10
-	SET_SCRATCH0(r10) /* Save r13 in SCRATCH0 */
+	std	r10,PACA_EXGEN+EX_R13(r13)
+	li	r10,0
+	std	r10,PACA_EXGEN+EX_CFAR(r13)
+	std	r10,PACA_EXGEN+EX_CTR(r13)
+BEGIN_FTR_SECTION
+	mfspr	r10,SPRN_PPR
+	std	r10,PACA_EXGEN+EX_PPR(r13)
+END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
+
+	HMT_MEDIUM
+
 #ifdef CONFIG_RELOCATABLE
 	/*
 	 * Requires __LOAD_FAR_HANDLER beause kvmppc_hcall lives
diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
index 6b2fda5dee38..6f06b58b1bdd 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -13,24 +13,9 @@
 .global	kvmppc_hcall
 .balign IFETCH_ALIGN_BYTES
 kvmppc_hcall:
-	/*
-	 * This is a hcall, so register convention is as
-	 * Documentation/powerpc/papr_hcalls.rst, with these additions:
-	 * R13		= PACA
-	 * guest R13 saved in SPRN_SCRATCH0
-	 * R10		= free
-	 */
-BEGIN_FTR_SECTION
-	mfspr	r10,SPRN_PPR
-	std	r10,HSTATE_PPR(r13)
-END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
-	HMT_MEDIUM
-	mfcr	r10
-	std	r12,HSTATE_SCRATCH0(r13)
-	sldi	r12,r10,32
-	ori	r12,r12,0xc00
-	ld	r10,PACA_EXGEN+EX_R10(r13)
-	b	do_kvm_interrupt
+	ld	r10,PACA_EXGEN+EX_R13(r13)
+	SET_SCRATCH0(r10)
+	li	r10,0xc00
 
 .global	kvmppc_interrupt
 .balign IFETCH_ALIGN_BYTES
@@ -61,7 +46,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	ld	r10,EX_R10(r11)
 	ld	r11,EX_R11(r11)
 
-do_kvm_interrupt:
 	/*
 	 * Hcalls and other interrupts come here after normalising register
 	 * contents and save locations:
-- 
2.23.0

