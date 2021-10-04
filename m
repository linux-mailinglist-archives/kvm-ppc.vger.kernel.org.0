Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E940442137D
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhJDQEZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbhJDQEZ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:04:25 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E660C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:02:36 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 133so17002880pgb.1
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U3rikcBBW6faBn9HW3G/ktrFps4HGeSwQYtxL/+Kwgo=;
        b=Hy52umQOBt8v9QuYumotMc+kSrjUGAZoKUKZFj5nBcJTyiZQnJxeAEsR0ie3Z8XMwZ
         L4FQrms+jX0aYmH3lQg9XVY1oajRLdP72wcp2KCduFmyM9V7io/d9Rk0sjiN7+T0+rcT
         UhQfH33NhMoU48SEQOM0taJuj0GKerLknWXv611g/T3HbQLGY9JysqTqNWWBYYlFlKmH
         tdSHZiYBMliAer1Mp43QkhZC4KvBOKFhsZ+xELy+5RA75cJ4HGl1LSy1xqslepRrh1Vk
         bOhPrvAQq6wphSgejk0liwfSANJ5oeDvljm4TBG2VerLyFluLsi6hH5Dc0A2kM0/KBVN
         JFGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U3rikcBBW6faBn9HW3G/ktrFps4HGeSwQYtxL/+Kwgo=;
        b=BbYy01lRfClWdny6eNV/lTfGQkYAKygbXS5ORToIW7V7piF1o7RkXGwh7wpVBHv788
         DHAbELAjEj9Q5BIVoZBlCDSMkA5LrsfKiyoYO4ivmPy8O1Oq7PaDP13+Q901sG1WMXAO
         NTL0QbzppQRM1e+dJuB2qM141rHtr/o6wwqLL66nEV8JxdlsfojTNLfg3UNJ9qrHXcqa
         5flu3tdIeYYbEaIlPH/Jlk2kfz0iYDTa61FpbB9bpT6Lzu9BesrqCsahgXnnhG2h8nKQ
         dFm1/o4VEwq8p40l8RF3dXm2pkgR19yG5CO9LbP1a9fRcRxw7Q4il2AVc7tykmIDHjWP
         isYQ==
X-Gm-Message-State: AOAM530jG9E45twgzwnBtlZCX3CCwgRIg/hiWo82VwswrC/79tDQAEHO
        rM0xZ+sejMYEQiI2TvxKyCSovKJmmf0=
X-Google-Smtp-Source: ABdhPJzsypEJIIifJ7XSCEdsBaVL8nldxpkpYEg6Z1RMD1hwbzyAaneO3LlWwUJ2YY3JmOPVZ+3Z3w==
X-Received: by 2002:a65:4209:: with SMTP id c9mr11252545pgq.399.1633363355674;
        Mon, 04 Oct 2021 09:02:35 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:02:35 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 39/52] KVM: PPC: Book3S HV P9: Comment and fix MMU context switching code
Date:   Tue,  5 Oct 2021 02:00:36 +1000
Message-Id: <20211004160049.1338837-40-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Tighten up partition switching code synchronisation and comments.

In particular, hwsync ; isync is required after the last access that is
performed in the context of a partition, before the partition is
switched away from.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_64_entry.S     | 11 +++++--
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  4 +++
 arch/powerpc/kvm/book3s_hv_p9_entry.c  | 40 +++++++++++++++++++-------
 3 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
index 983b8c18bc31..05e003eb5d90 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -374,11 +374,16 @@ END_MMU_FTR_SECTION_IFCLR(MMU_FTR_TYPE_RADIX)
 BEGIN_FTR_SECTION
 	mtspr	SPRN_DAWRX1,r10
 END_FTR_SECTION_IFSET(CPU_FTR_DAWR1)
-	mtspr	SPRN_PID,r10
 
 	/*
-	 * Switch to host MMU mode
+	 * Switch to host MMU mode (don't have the real host PID but we aren't
+	 * going back to userspace).
 	 */
+	hwsync
+	isync
+
+	mtspr	SPRN_PID,r10
+
 	ld	r10, HSTATE_KVM_VCPU(r13)
 	ld	r10, VCPU_KVM(r10)
 	lwz	r10, KVM_HOST_LPID(r10)
@@ -389,6 +394,8 @@ END_FTR_SECTION_IFSET(CPU_FTR_DAWR1)
 	ld	r10, KVM_HOST_LPCR(r10)
 	mtspr	SPRN_LPCR,r10
 
+	isync
+
 	/*
 	 * Set GUEST_MODE_NONE so the handler won't branch to KVM, and clear
 	 * MSR_RI in r12 ([H]SRR1) so the handler won't try to return.
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 16359525a40f..8cebe5542256 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -57,6 +57,8 @@ unsigned long __kvmhv_copy_tofrom_guest_radix(int lpid, int pid,
 
 	preempt_disable();
 
+	asm volatile("hwsync" ::: "memory");
+	isync();
 	/* switch the lpid first to avoid running host with unallocated pid */
 	old_lpid = mfspr(SPRN_LPID);
 	if (old_lpid != lpid)
@@ -75,6 +77,8 @@ unsigned long __kvmhv_copy_tofrom_guest_radix(int lpid, int pid,
 		ret = __copy_to_user_inatomic((void __user *)to, from, n);
 	pagefault_enable();
 
+	asm volatile("hwsync" ::: "memory");
+	isync();
 	/* switch the pid first to avoid running host with unallocated pid */
 	if (quadrant == 1 && pid != old_pid)
 		mtspr(SPRN_PID, old_pid);
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 093ac0453d91..323b692bbfe2 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -531,17 +531,19 @@ static void switch_mmu_to_guest_radix(struct kvm *kvm, struct kvm_vcpu *vcpu, u6
 	lpid = nested ? nested->shadow_lpid : kvm->arch.lpid;
 
 	/*
-	 * All the isync()s are overkill but trivially follow the ISA
-	 * requirements. Some can likely be replaced with justification
-	 * comment for why they are not needed.
+	 * Prior memory accesses to host PID Q3 must be completed before we
+	 * start switching, and stores must be drained to avoid not-my-LPAR
+	 * logic (see switch_mmu_to_host).
 	 */
+	asm volatile("hwsync" ::: "memory");
 	isync();
 	mtspr(SPRN_LPID, lpid);
-	isync();
 	mtspr(SPRN_LPCR, lpcr);
-	isync();
 	mtspr(SPRN_PID, vcpu->arch.pid);
-	isync();
+	/*
+	 * isync not required here because we are HRFID'ing to guest before
+	 * any guest context access, which is context synchronising.
+	 */
 }
 
 static void switch_mmu_to_guest_hpt(struct kvm *kvm, struct kvm_vcpu *vcpu, u64 lpcr)
@@ -551,25 +553,41 @@ static void switch_mmu_to_guest_hpt(struct kvm *kvm, struct kvm_vcpu *vcpu, u64
 
 	lpid = kvm->arch.lpid;
 
+	/*
+	 * See switch_mmu_to_guest_radix. ptesync should not be required here
+	 * even if the host is in HPT mode because speculative accesses would
+	 * not cause RC updates (we are in real mode).
+	 */
+	asm volatile("hwsync" ::: "memory");
+	isync();
 	mtspr(SPRN_LPID, lpid);
 	mtspr(SPRN_LPCR, lpcr);
 	mtspr(SPRN_PID, vcpu->arch.pid);
 
 	for (i = 0; i < vcpu->arch.slb_max; i++)
 		mtslb(vcpu->arch.slb[i].orige, vcpu->arch.slb[i].origv);
-
-	isync();
+	/*
+	 * isync not required here, see switch_mmu_to_guest_radix.
+	 */
 }
 
 static void switch_mmu_to_host(struct kvm *kvm, u32 pid)
 {
+	/*
+	 * The guest has exited, so guest MMU context is no longer being
+	 * non-speculatively accessed, but a hwsync is needed before the
+	 * mtLPIDR / mtPIDR switch, in order to ensure all stores are drained,
+	 * so the not-my-LPAR tlbie logic does not overlook them.
+	 */
+	asm volatile("hwsync" ::: "memory");
 	isync();
 	mtspr(SPRN_PID, pid);
-	isync();
 	mtspr(SPRN_LPID, kvm->arch.host_lpid);
-	isync();
 	mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
-	isync();
+	/*
+	 * isync is not required after the switch, because mtmsrd with L=0
+	 * is performed after this switch, which is context synchronising.
+	 */
 
 	if (!radix_enabled())
 		slb_restore_bolted_realmode();
-- 
2.23.0

