Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6F62C721F
	for <lists+kvm-ppc@lfdr.de>; Sat, 28 Nov 2020 23:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389945AbgK1Vu0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 28 Nov 2020 16:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733066AbgK1TFP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 28 Nov 2020 14:05:15 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF81C094250
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Nov 2020 23:07:43 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id w4so5987744pgg.13
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Nov 2020 23:07:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N80fuMiX7GnX39J9dqIjia2qgdYXbL88FKJN1E8uzH8=;
        b=mTwFjmAFugrRYVxcBlxl1OjIndZly89Ec35Hea6qqRiCQI+pDVbK67kxd5TqwNA3Z4
         egTkS84pdfDtWaYW7KLmCG255Yk+nHIdsf7IkA9FQJutI8D/w+FQe9F7JDAY5lokzNUJ
         ZcsoB4mF38WfLauEnFDh7cW1mPxrqrmmVYotFBUW6FtRnMgFjeegQxkjGXwY/ma544Ez
         0sugmF4ctpi5DlUbQQDorligceSniIbDySvbt5UxHKglUFDt37z+wSWkJIY+EnDzdoWd
         8ngqf9qJcYIRup2VzYINyXyyMJgakStmPruPiQLyLBRCQo1dX/eVGPkHrg9E2cwMFyMa
         628Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N80fuMiX7GnX39J9dqIjia2qgdYXbL88FKJN1E8uzH8=;
        b=hnkNDeOgrjesEknehecz0Wf15Ipaj6EwdDxRkPCS2W9yYW0QZb5p/6Wee9D6wqp/OH
         ThifQAAo/C4FbTyVEC4EudJGq25rEvRxiKIugmTcD0IXw2Y3L5j5C8mDChUJFaq0qED+
         TZcCy9mrdBkHMNRro7OWGEZCVdchcrVp6VNbu1I/KkFgoM4m9ZRRLgAxpphSidfcTTEZ
         pJBY2KTo9ABG7yI0j5q3/cJBLtcJvVSakKWp8tQI/3eHbiOLuXMdjopGBpy+EjTSAmeL
         pACv4V2tFddmQJf2MaGz/nUPUxtHvFUlZ2XyJieIQaVUQTcWrN/ZjhqRG8SBHYMQjCKg
         4jCQ==
X-Gm-Message-State: AOAM533ZnkXOLLPt9+8JL53IXiDzStW9D5Ai4K6gDCC0A8YafsRf5eQJ
        Vr2J2+MgyqsAq1/UfYu/PL0=
X-Google-Smtp-Source: ABdhPJw4tj75B+xa9a6wn+TUlX51xdcUPbY3nt4XL+aeRC38ohFU2qOg6vqNj7fwjhBw8adhlgjFNg==
X-Received: by 2002:a17:90a:9d8a:: with SMTP id k10mr14046861pjp.60.1606547262731;
        Fri, 27 Nov 2020 23:07:42 -0800 (PST)
Received: from bobo.ibm.com (193-116-103-132.tpgi.com.au. [193.116.103.132])
        by smtp.gmail.com with ESMTPSA id e31sm9087329pgb.16.2020.11.27.23.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 23:07:42 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org,
        Mahesh Salgaonkar <mahesh@linux.ibm.com>
Subject: [PATCH 2/8] powerpc/64s/powernv: Allow KVM to handle guest machine check details
Date:   Sat, 28 Nov 2020 17:07:22 +1000
Message-Id: <20201128070728.825934-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201128070728.825934-1-npiggin@gmail.com>
References: <20201128070728.825934-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

KVM has strategies to perform machine check recovery. If a MCE hits
in a guest, have the low level handler just decode and save the MCE
but not try to recover anything, so KVM can deal with it.

The host does not own SLBs and does not need to report the SLB state
in case of a multi-hit for example, or know about the virtual memory
map of the guest.

UE and memory poisoning of guest pages in the host is one thing that
is possibly not completely robust at the moment, but this too needs
to go via KVM (possibly via the guest and back out to host via hcall)
rather than being handled at a low level in the host handler.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/mce.c       |  2 +-
 arch/powerpc/kernel/mce_power.c | 96 ++++++++++++++++++---------------
 2 files changed, 55 insertions(+), 43 deletions(-)

diff --git a/arch/powerpc/kernel/mce.c b/arch/powerpc/kernel/mce.c
index 63702c0badb9..8afe8d37b983 100644
--- a/arch/powerpc/kernel/mce.c
+++ b/arch/powerpc/kernel/mce.c
@@ -577,7 +577,7 @@ void machine_check_print_event_info(struct machine_check_event *evt,
 
 #ifdef CONFIG_PPC_BOOK3S_64
 	/* Display faulty slb contents for SLB errors. */
-	if (evt->error_type == MCE_ERROR_TYPE_SLB)
+	if (evt->error_type == MCE_ERROR_TYPE_SLB && !in_guest)
 		slb_dump_contents(local_paca->mce_faulty_slbs);
 #endif
 }
diff --git a/arch/powerpc/kernel/mce_power.c b/arch/powerpc/kernel/mce_power.c
index b7e173754a2e..1372ce3f7bdd 100644
--- a/arch/powerpc/kernel/mce_power.c
+++ b/arch/powerpc/kernel/mce_power.c
@@ -62,6 +62,20 @@ unsigned long addr_to_pfn(struct pt_regs *regs, unsigned long addr)
 	return pfn;
 }
 
+static bool mce_in_guest(void)
+{
+#ifdef CONFIG_KVM_BOOK3S_HANDLER
+	/*
+	 * If machine check is hit when in guest context or low level KVM
+	 * code, avoid looking up any translations or making any attempts
+	 * to recover, just record the event and pass to KVM.
+	 */
+	if (get_paca()->kvm_hstate.in_guest)
+		return true;
+#endif
+	return false;
+}
+
 /* flush SLBs and reload */
 #ifdef CONFIG_PPC_BOOK3S_64
 void flush_and_reload_slb(void)
@@ -69,14 +83,6 @@ void flush_and_reload_slb(void)
 	/* Invalidate all SLBs */
 	slb_flush_all_realmode();
 
-#ifdef CONFIG_KVM_BOOK3S_HANDLER
-	/*
-	 * If machine check is hit when in guest or in transition, we will
-	 * only flush the SLBs and continue.
-	 */
-	if (get_paca()->kvm_hstate.in_guest)
-		return;
-#endif
 	if (early_radix_enabled())
 		return;
 
@@ -490,19 +496,21 @@ static int mce_handle_ierror(struct pt_regs *regs,
 		if ((srr1 & table[i].srr1_mask) != table[i].srr1_value)
 			continue;
 
-		/* attempt to correct the error */
-		switch (table[i].error_type) {
-		case MCE_ERROR_TYPE_SLB:
-			if (local_paca->in_mce == 1)
-				slb_save_contents(local_paca->mce_faulty_slbs);
-			handled = mce_flush(MCE_FLUSH_SLB);
-			break;
-		case MCE_ERROR_TYPE_ERAT:
-			handled = mce_flush(MCE_FLUSH_ERAT);
-			break;
-		case MCE_ERROR_TYPE_TLB:
-			handled = mce_flush(MCE_FLUSH_TLB);
-			break;
+		if (!mce_in_guest()) {
+			/* attempt to correct the error */
+			switch (table[i].error_type) {
+			case MCE_ERROR_TYPE_SLB:
+				if (local_paca->in_mce == 1)
+					slb_save_contents(local_paca->mce_faulty_slbs);
+				handled = mce_flush(MCE_FLUSH_SLB);
+				break;
+			case MCE_ERROR_TYPE_ERAT:
+				handled = mce_flush(MCE_FLUSH_ERAT);
+				break;
+			case MCE_ERROR_TYPE_TLB:
+				handled = mce_flush(MCE_FLUSH_TLB);
+				break;
+			}
 		}
 
 		/* now fill in mce_error_info */
@@ -534,7 +542,7 @@ static int mce_handle_ierror(struct pt_regs *regs,
 		mce_err->sync_error = table[i].sync_error;
 		mce_err->severity = table[i].severity;
 		mce_err->initiator = table[i].initiator;
-		if (table[i].nip_valid) {
+		if (table[i].nip_valid && !mce_in_guest()) {
 			*addr = regs->nip;
 			if (mce_err->sync_error &&
 				table[i].error_type == MCE_ERROR_TYPE_UE) {
@@ -577,22 +585,24 @@ static int mce_handle_derror(struct pt_regs *regs,
 		if (!(dsisr & table[i].dsisr_value))
 			continue;
 
-		/* attempt to correct the error */
-		switch (table[i].error_type) {
-		case MCE_ERROR_TYPE_SLB:
-			if (local_paca->in_mce == 1)
-				slb_save_contents(local_paca->mce_faulty_slbs);
-			if (mce_flush(MCE_FLUSH_SLB))
-				handled = 1;
-			break;
-		case MCE_ERROR_TYPE_ERAT:
-			if (mce_flush(MCE_FLUSH_ERAT))
-				handled = 1;
-			break;
-		case MCE_ERROR_TYPE_TLB:
-			if (mce_flush(MCE_FLUSH_TLB))
-				handled = 1;
-			break;
+		if (!mce_in_guest()) {
+			/* attempt to correct the error */
+			switch (table[i].error_type) {
+			case MCE_ERROR_TYPE_SLB:
+				if (local_paca->in_mce == 1)
+					slb_save_contents(local_paca->mce_faulty_slbs);
+				if (mce_flush(MCE_FLUSH_SLB))
+					handled = 1;
+				break;
+			case MCE_ERROR_TYPE_ERAT:
+				if (mce_flush(MCE_FLUSH_ERAT))
+					handled = 1;
+				break;
+			case MCE_ERROR_TYPE_TLB:
+				if (mce_flush(MCE_FLUSH_TLB))
+					handled = 1;
+				break;
+			}
 		}
 
 		/*
@@ -634,7 +644,7 @@ static int mce_handle_derror(struct pt_regs *regs,
 		mce_err->initiator = table[i].initiator;
 		if (table[i].dar_valid)
 			*addr = regs->dar;
-		else if (mce_err->sync_error &&
+		else if (mce_err->sync_error && !mce_in_guest() &&
 				table[i].error_type == MCE_ERROR_TYPE_UE) {
 			/*
 			 * We do a maximum of 4 nested MCE calls, see
@@ -662,7 +672,8 @@ static int mce_handle_derror(struct pt_regs *regs,
 static long mce_handle_ue_error(struct pt_regs *regs,
 				struct mce_error_info *mce_err)
 {
-	long handled = 0;
+	if (mce_in_guest())
+		return 0;
 
 	mce_common_process_ue(regs, mce_err);
 	if (mce_err->ignore_event)
@@ -677,9 +688,10 @@ static long mce_handle_ue_error(struct pt_regs *regs,
 
 	if (ppc_md.mce_check_early_recovery) {
 		if (ppc_md.mce_check_early_recovery(regs))
-			handled = 1;
+			return 1;
 	}
-	return handled;
+
+	return 0;
 }
 
 static long mce_handle_error(struct pt_regs *regs,
-- 
2.23.0

