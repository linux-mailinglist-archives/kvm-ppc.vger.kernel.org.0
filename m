Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B47B42135D
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236243AbhJDQDd (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236129AbhJDQDc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:03:32 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE599C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:01:43 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 66so16566340pgc.9
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KTcpw9sCjqvIJZJ39IDi/BwDIrqeO0Am9Hi11LMRpIU=;
        b=Ntq5DylHcg5DlRpyldG4xAcjuJIlDVF1Ee+2DZJp92VuDmm4ydDvc6DkvWFc+TBuL9
         6SuHdZSSoaU11Ob5tuVFkzcibGwpxFZRNmPFQcKCINGxSWTzANzbETfUEX4zT1jgFyoT
         YLryASnuZPkz65d25nI+QtIs8+FpL50pBAha28vDZDhr8VHN3LTnSYRwY6QYjQZHa4a8
         NKbcjzhY1SjWiE/HtWdy3zNmtAYEXXmt5Ci9RkEU6MFy860mZ/57EX1d89E33uRS4Rv0
         F923zdLFAFkGlcz/wBvF9s7XoBRSgQt30eSSzO4qk2fZb+1XncYwrHKuecxMeHGjHSVS
         ioyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KTcpw9sCjqvIJZJ39IDi/BwDIrqeO0Am9Hi11LMRpIU=;
        b=UtzB/e2eT8OIXs1gTAoZRzJLGzVV7QuKfCPqNbUMFemdC2v4Dm975Q4b0ZcjizXUoi
         TQktCUX7BBvHDP+fCbrET8sUdCNGXx04Fg7Xe0vvvB9Rvnbc37nLK9wjHNfJso1MMwTh
         5Tx6zpyOlJl9v8hvtHCPvpYj+yo25Ew77v5J27o1wzaBHQnuPFCCq/R0GeoJ9jaeiyvV
         Whmb0iYKnOu1FhWy27thCcwioVcw07ylr8vetCon/nrPIkiNiBV4Ph07r7avSzKp2mbX
         bk8Uuy7NJpyGv9T0oMNjefbG2sPCqfhRmFrqWGj9ui892K+duhbWSMSo7AriBWVLWnyQ
         lcDg==
X-Gm-Message-State: AOAM533BpNf/4AHZtm8231kxM2CLjoiBapHd225rEQOrwG8L/o31c9H0
        MB2TTK+xwRRiXm/wWW8JCSYvJjypK1w=
X-Google-Smtp-Source: ABdhPJy5P8mVVOCVTJhMsvahaySzsxEMfCsHGzIlWkVh73FNZIVY7qjPB2jWzkLNOLqin0wQFCn2Qw==
X-Received: by 2002:a63:200a:: with SMTP id g10mr11298425pgg.242.1633363303366;
        Mon, 04 Oct 2021 09:01:43 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:01:43 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 17/52] KVM: PPC: Book3S HV: CTRL SPR does not require read-modify-write
Date:   Tue,  5 Oct 2021 02:00:14 +1000
Message-Id: <20211004160049.1338837-18-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Processors that support KVM HV do not require read-modify-write of
the CTRL SPR to set/clear their thread's runlatch. Just write 1 or 0
to it.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c            |  2 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 15 ++++++---------
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index f0ad3fb2eabd..1c5b81bd02c1 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4058,7 +4058,7 @@ static void load_spr_state(struct kvm_vcpu *vcpu)
 	 */
 
 	if (!(vcpu->arch.ctrl & 1))
-		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
+		mtspr(SPRN_CTRLT, 0);
 }
 
 static void store_spr_state(struct kvm_vcpu *vcpu)
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 7fa0df632f89..070e228b3c20 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -775,12 +775,11 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_207S)
 	mtspr	SPRN_AMR,r5
 	mtspr	SPRN_UAMOR,r6
 
-	/* Restore state of CTRL run bit; assume 1 on entry */
+	/* Restore state of CTRL run bit; the host currently has it set to 1 */
 	lwz	r5,VCPU_CTRL(r4)
 	andi.	r5,r5,1
 	bne	4f
-	mfspr	r6,SPRN_CTRLF
-	clrrdi	r6,r6,1
+	li	r6,0
 	mtspr	SPRN_CTRLT,r6
 4:
 	/* Secondary threads wait for primary to have done partition switch */
@@ -1203,12 +1202,12 @@ guest_bypass:
 	stw	r0, VCPU_CPU(r9)
 	stw	r0, VCPU_THREAD_CPU(r9)
 
-	/* Save guest CTRL register, set runlatch to 1 */
+	/* Save guest CTRL register, set runlatch to 1 if it was clear */
 	mfspr	r6,SPRN_CTRLF
 	stw	r6,VCPU_CTRL(r9)
 	andi.	r0,r6,1
 	bne	4f
-	ori	r6,r6,1
+	li	r6,1
 	mtspr	SPRN_CTRLT,r6
 4:
 	/*
@@ -2178,8 +2177,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_TM)
 	 * Also clear the runlatch bit before napping.
 	 */
 kvm_do_nap:
-	mfspr	r0, SPRN_CTRLF
-	clrrdi	r0, r0, 1
+	li	r0,0
 	mtspr	SPRN_CTRLT, r0
 
 	li	r0,1
@@ -2198,8 +2196,7 @@ kvm_nap_sequence:		/* desired LPCR value in r5 */
 
 	bl	isa206_idle_insn_mayloss
 
-	mfspr	r0, SPRN_CTRLF
-	ori	r0, r0, 1
+	li	r0,1
 	mtspr	SPRN_CTRLT, r0
 
 	mtspr	SPRN_SRR1, r3
-- 
2.23.0

