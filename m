Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329793B0215
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhFVLBf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhFVLBf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:01:35 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFB7C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:19 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id h16so11865353pjv.2
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sjJ6gtRdyxRcyqiP66xfDplG8GxPfdcasnzetK08EXA=;
        b=i+VoZyWXU37kNu3GFi7TezY37eiOclg9NimufDnms2SeS/CYASp0HvwPVTXbPCuw/1
         TlJ72ElMPZLAbUbir/nMDMrLT8FmljjtqbgAz+wtEZEfCeLYadDkuPY5acerdIF4O3zc
         m0hcaLGFqnvTEGQOYdqRagGLcdqXIiARE0LTg6IpRf++fHPu4JKjjZNiUdq7cK60CDZ0
         KIIPCJvKjqsjYc+hf5Y4Fup7R7Q1pmoTpk0l6CnU9Qk4CTdoZobIbT9Fqip/AIQegc+V
         xFpVRLvVdN3zeNZn7yP0geAakkDNyyyEPk3s+PCHkRoK45/3Wdv/bE7yXTYFKlM3J/1Z
         4bKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sjJ6gtRdyxRcyqiP66xfDplG8GxPfdcasnzetK08EXA=;
        b=ow3zRuGTpVTZ2n0EBFx6UDqlFY6kZTUvbSfSx42QaMyTZuvkMOqZdjoDWKeGZMm6bn
         KIGUxPoCnDHofymUltPN5KAJy4PYdgzvL5NUrwW1NZ2M9R89Zvdsx5hDuzwmNCiFfTxb
         wmgJF47LyI7E/ySERTDWBp5Zg66AtsVSttWLoEiXMU8EPT+42llX9WnxBv351/XtNhbg
         1NjmqiqRSXIeX4BMI6WRHxyi6+kjEXP5swllMmsDJPPGPoRaPufMEq5nF8gqV+6vHi0l
         SocJPzsrT4M22dSI5jNfG1FcvuQvrEN+nayoA4UuNZEHoY/MhIMbTs9bg/wb3rHgfrJO
         7hgg==
X-Gm-Message-State: AOAM533rVpvq8vP/uyA+CAKGTSOulyJr0/S95KmJ7xaVi+sLW9d5Qm63
        U7n6PR6DJfdAbxNgTCTn4KVzKKBAL7U=
X-Google-Smtp-Source: ABdhPJxxP13F9ohQsbaJoDUX5Hy/e2xbMO9+ITeaskHh68iR1aZdZXU6Ru5UJPDFOtUMSXDOrYHpvg==
X-Received: by 2002:a17:90a:901:: with SMTP id n1mr3407544pjn.44.1624359558575;
        Tue, 22 Jun 2021 03:59:18 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:59:18 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 34/43] KVM: PPC: Book3S HV P9: Demand fault EBB facility registers
Date:   Tue, 22 Jun 2021 20:57:27 +1000
Message-Id: <20210622105736.633352-35-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Use HFSCR facility disabling to implement demand faulting for EBB, with
a hysteresis counter similar to the load_fp etc counters in context
switching that implement the equivalent demand faulting for userspace
facilities.

This speeds up guest entry/exit by avoiding the register save/restore
when a guest is not frequently using them. When a guest does use them
often, there will be some additional demand fault overhead, but these
are not commonly used facilities.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_host.h   |  1 +
 arch/powerpc/kvm/book3s_hv.c          | 11 +++++++++++
 arch/powerpc/kvm/book3s_hv_nested.c   |  3 ++-
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 26 ++++++++++++++++++++------
 4 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 118b388ea887..bee95106c1f2 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -585,6 +585,7 @@ struct kvm_vcpu_arch {
 	ulong cfar;
 	ulong ppr;
 	u32 pspb;
+	u8 load_ebb;
 	ulong fscr;
 	ulong shadow_fscr;
 	ulong ebbhr;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index ae528eb37792..99e9da078e7d 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1366,6 +1366,13 @@ static int kvmppc_pmu_unavailable(struct kvm_vcpu *vcpu)
 	return RESUME_GUEST;
 }
 
+static int kvmppc_ebb_unavailable(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hfscr |= HFSCR_EBB;
+
+	return RESUME_GUEST;
+}
+
 static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 				 struct task_struct *tsk)
 {
@@ -1645,6 +1652,8 @@ XXX benchmark guest exits
 				r = kvmppc_emulate_doorbell_instr(vcpu);
 			if (cause == FSCR_PM_LG)
 				r = kvmppc_pmu_unavailable(vcpu);
+			if (cause == FSCR_EBB_LG)
+				r = kvmppc_ebb_unavailable(vcpu);
 		}
 		if (r == EMULATE_FAIL) {
 			kvmppc_core_queue_program(vcpu, SRR1_PROGILL);
@@ -1764,6 +1773,8 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
 		r = EMULATE_FAIL;
 		if (cause == FSCR_PM_LG && (vcpu->arch.nested_hfscr & HFSCR_PM))
 			r = kvmppc_pmu_unavailable(vcpu);
+		if (cause == FSCR_EBB_LG && (vcpu->arch.nested_hfscr & HFSCR_EBB))
+			r = kvmppc_ebb_unavailable(vcpu);
 
 		if (r == EMULATE_FAIL)
 			r = RESUME_HOST;
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 024b0ce5b702..ee8668f056f9 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -168,7 +168,8 @@ static void sanitise_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
 	 * but preserve the interrupt cause field and facilities that might
 	 * be disabled for demand faulting in the L1.
 	 */
-	hr->hfscr &= (HFSCR_INTR_CAUSE | HFSCR_PM | vcpu->arch.hfscr);
+	hr->hfscr &= (HFSCR_INTR_CAUSE | HFSCR_PM | HFSCR_EBB |
+			vcpu->arch.hfscr);
 
 	/* Don't let data address watchpoint match in hypervisor state */
 	hr->dawrx0 &= ~DAWRX_HYP;
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 4d1a2d1ff4c1..cf41261daa97 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -218,9 +218,12 @@ static void load_spr_state(struct kvm_vcpu *vcpu,
 				struct p9_host_os_sprs *host_os_sprs)
 {
 	mtspr(SPRN_TAR, vcpu->arch.tar);
-	mtspr(SPRN_EBBHR, vcpu->arch.ebbhr);
-	mtspr(SPRN_EBBRR, vcpu->arch.ebbrr);
-	mtspr(SPRN_BESCR, vcpu->arch.bescr);
+
+	if (vcpu->arch.hfscr & HFSCR_EBB) {
+		mtspr(SPRN_EBBHR, vcpu->arch.ebbhr);
+		mtspr(SPRN_EBBRR, vcpu->arch.ebbrr);
+		mtspr(SPRN_BESCR, vcpu->arch.bescr);
+	}
 
 	if (!cpu_has_feature(CPU_FTR_ARCH_31))
 		mtspr(SPRN_TIDR, vcpu->arch.tid);
@@ -251,9 +254,20 @@ static void load_spr_state(struct kvm_vcpu *vcpu,
 static void store_spr_state(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.tar = mfspr(SPRN_TAR);
-	vcpu->arch.ebbhr = mfspr(SPRN_EBBHR);
-	vcpu->arch.ebbrr = mfspr(SPRN_EBBRR);
-	vcpu->arch.bescr = mfspr(SPRN_BESCR);
+
+	if (vcpu->arch.hfscr & HFSCR_EBB) {
+		vcpu->arch.ebbhr = mfspr(SPRN_EBBHR);
+		vcpu->arch.ebbrr = mfspr(SPRN_EBBRR);
+		vcpu->arch.bescr = mfspr(SPRN_BESCR);
+		/*
+		 * This is like load_fp in context switching, turn off the
+		 * facility after it wraps the u8 to try avoiding saving
+		 * and restoring the registers each partition switch.
+		 */
+		vcpu->arch.load_ebb++;
+		if (!vcpu->arch.load_ebb)
+			vcpu->arch.hfscr &= ~HFSCR_EBB;
+	}
 
 	if (!cpu_has_feature(CPU_FTR_ARCH_31))
 		vcpu->arch.tid = mfspr(SPRN_TIDR);
-- 
2.23.0

