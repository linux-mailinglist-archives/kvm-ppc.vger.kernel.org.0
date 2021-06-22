Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D763B020D
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhFVLBV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhFVLBU (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:01:20 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C00C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:05 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id e20so16798035pgg.0
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/g2zw/cdJtE/kPmVrn6tdSPVU/Uf/92XnHBavXt+6AE=;
        b=lL2wmhqQH7+aVvPgOnC8pi35cD1vtugia7JG8VS6af6efAlY3s9zBTwoblUXUKpiXs
         KP5UrL1Qy6QCIa2A2UkiTpkLZS627LR6mMv8asgEyYa65ZUsIg2+vIeULc8jRH/mfE+D
         uiHxR0Ify3U0DlnSpzZFhEZHR7dOQE+k7bP3irR8DFRMjsGC0TiOsuB6p9Zj3KUKna1u
         NejrZmfFK35wnRorBRrXLX2xKQsVqzgmZ1KcN/k37SI4m/hIIeO/PQEFB9M1snrUOWjo
         GMrWz3RI+6I81X2oruoXf3jINdLLLDr0B50WOOhqMDWYMy88lktR9hp4B9crqlHw/76o
         wlwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/g2zw/cdJtE/kPmVrn6tdSPVU/Uf/92XnHBavXt+6AE=;
        b=VRZ05qME1edJHTI3ZEMQKbWKP812p1ZxoAEpmHiCdFFGpr4SO5wtv6bPy+N6OifHnr
         ZpdtrYcl5KZNg2tglt5QoiBZm9VEJRR03gPmRRoRZAHHHGxEG0ozFPvjE7QR37rAJDVy
         a4nhzCDu36MHCX1UT+f/Ijv5Z57M6z3UMXX/J5AjAvFu8XH1P2f3tBm1tLh//pohn/ep
         RISrdbjkd9oG84ujTOBBb+fe0CITBw15TKKN0dFA1ueIUoWLO7sa7nC9ijR3hfv+K3cA
         QyO6sBXBHJzTiFf4GiAmXnLFaVRvaQuJC+8d+49uaqJ4/FcJiHTPC6kO/u/QcPB+Ky3k
         XSBA==
X-Gm-Message-State: AOAM530rIf/WjsQEeE4uXLdqragdH2n95Cb+y4mDyFiBn3To0JQqiqRd
        TNP7VmLb9dLaCaW0bqDOxve5bVDr0fA=
X-Google-Smtp-Source: ABdhPJwGZdj5UBns3wZvViaeyJ5go1dR3i+0isQj9gGNzl/MTdSXqPtofNZzLI3tg4J0G1scG4krJg==
X-Received: by 2002:a65:50c5:: with SMTP id s5mr3230642pgp.138.1624359544853;
        Tue, 22 Jun 2021 03:59:04 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:59:04 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 28/43] KVM: PPC: Book3S HV P9: Move nested guest entry into its own function
Date:   Tue, 22 Jun 2021 20:57:21 +1000
Message-Id: <20210622105736.633352-29-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This is just refactoring.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 125 +++++++++++++++++++----------------
 1 file changed, 67 insertions(+), 58 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index a7660af22161..64386fc0cd00 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3692,6 +3692,72 @@ static void vcpu_vpa_increment_dispatch(struct kvm_vcpu *vcpu)
 	}
 }
 
+/* call our hypervisor to load up HV regs and go */
+static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpcr, u64 *tb)
+{
+	struct kvmppc_vcore *vc = vcpu->arch.vcore;
+	unsigned long host_psscr;
+	struct hv_guest_state hvregs;
+	int trap;
+	s64 dec;
+
+	/*
+	 * We need to save and restore the guest visible part of the
+	 * psscr (i.e. using SPRN_PSSCR_PR) since the hypervisor
+	 * doesn't do this for us. Note only required if pseries since
+	 * this is done in kvmhv_vcpu_entry_p9() below otherwise.
+	 */
+	host_psscr = mfspr(SPRN_PSSCR_PR);
+	mtspr(SPRN_PSSCR_PR, vcpu->arch.psscr);
+	kvmhv_save_hv_regs(vcpu, &hvregs);
+	hvregs.lpcr = lpcr;
+	vcpu->arch.regs.msr = vcpu->arch.shregs.msr;
+	hvregs.version = HV_GUEST_STATE_VERSION;
+	if (vcpu->arch.nested) {
+		hvregs.lpid = vcpu->arch.nested->shadow_lpid;
+		hvregs.vcpu_token = vcpu->arch.nested_vcpu_id;
+	} else {
+		hvregs.lpid = vcpu->kvm->arch.lpid;
+		hvregs.vcpu_token = vcpu->vcpu_id;
+	}
+	hvregs.hdec_expiry = time_limit;
+
+	/*
+	 * When setting DEC, we must always deal with irq_work_raise
+	 * via NMI vs setting DEC. The problem occurs right as we
+	 * switch into guest mode if a NMI hits and sets pending work
+	 * and sets DEC, then that will apply to the guest and not
+	 * bring us back to the host.
+	 *
+	 * irq_work_raise could check a flag (or possibly LPCR[HDICE]
+	 * for example) and set HDEC to 1? That wouldn't solve the
+	 * nested hv case which needs to abort the hcall or zero the
+	 * time limit.
+	 *
+	 * XXX: Another day's problem.
+	 */
+	mtspr(SPRN_DEC, kvmppc_dec_expires_host_tb(vcpu) - *tb);
+
+	mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
+	mtspr(SPRN_DSISR, vcpu->arch.shregs.dsisr);
+	trap = plpar_hcall_norets(H_ENTER_NESTED, __pa(&hvregs),
+				  __pa(&vcpu->arch.regs));
+	kvmhv_restore_hv_return_state(vcpu, &hvregs);
+	vcpu->arch.shregs.msr = vcpu->arch.regs.msr;
+	vcpu->arch.shregs.dar = mfspr(SPRN_DAR);
+	vcpu->arch.shregs.dsisr = mfspr(SPRN_DSISR);
+	vcpu->arch.psscr = mfspr(SPRN_PSSCR_PR);
+	mtspr(SPRN_PSSCR_PR, host_psscr);
+
+	dec = mfspr(SPRN_DEC);
+	if (!(lpcr & LPCR_LD)) /* Sign extend if not using large decrementer */
+		dec = (s32) dec;
+	*tb = mftb();
+	vcpu->arch.dec_expires = dec + (*tb + vc->tb_offset);
+
+	return trap;
+}
+
 /*
  * Guest entry for POWER9 and later CPUs.
  */
@@ -3700,7 +3766,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	struct p9_host_os_sprs host_os_sprs;
-	s64 dec;
 	u64 next_timer;
 	unsigned long msr;
 	int trap;
@@ -3752,63 +3817,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	switch_pmu_to_guest(vcpu, &host_os_sprs);
 
 	if (kvmhv_on_pseries()) {
-		/*
-		 * We need to save and restore the guest visible part of the
-		 * psscr (i.e. using SPRN_PSSCR_PR) since the hypervisor
-		 * doesn't do this for us. Note only required if pseries since
-		 * this is done in kvmhv_vcpu_entry_p9() below otherwise.
-		 */
-		unsigned long host_psscr;
-		/* call our hypervisor to load up HV regs and go */
-		struct hv_guest_state hvregs;
-
-		host_psscr = mfspr(SPRN_PSSCR_PR);
-		mtspr(SPRN_PSSCR_PR, vcpu->arch.psscr);
-		kvmhv_save_hv_regs(vcpu, &hvregs);
-		hvregs.lpcr = lpcr;
-		vcpu->arch.regs.msr = vcpu->arch.shregs.msr;
-		hvregs.version = HV_GUEST_STATE_VERSION;
-		if (vcpu->arch.nested) {
-			hvregs.lpid = vcpu->arch.nested->shadow_lpid;
-			hvregs.vcpu_token = vcpu->arch.nested_vcpu_id;
-		} else {
-			hvregs.lpid = vcpu->kvm->arch.lpid;
-			hvregs.vcpu_token = vcpu->vcpu_id;
-		}
-		hvregs.hdec_expiry = time_limit;
-
-		/*
-		 * When setting DEC, we must always deal with irq_work_raise
-		 * via NMI vs setting DEC. The problem occurs right as we
-		 * switch into guest mode if a NMI hits and sets pending work
-		 * and sets DEC, then that will apply to the guest and not
-		 * bring us back to the host.
-		 *
-		 * irq_work_raise could check a flag (or possibly LPCR[HDICE]
-		 * for example) and set HDEC to 1? That wouldn't solve the
-		 * nested hv case which needs to abort the hcall or zero the
-		 * time limit.
-		 *
-		 * XXX: Another day's problem.
-		 */
-		mtspr(SPRN_DEC, kvmppc_dec_expires_host_tb(vcpu) - *tb);
-
-		mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
-		mtspr(SPRN_DSISR, vcpu->arch.shregs.dsisr);
-		trap = plpar_hcall_norets(H_ENTER_NESTED, __pa(&hvregs),
-					  __pa(&vcpu->arch.regs));
-		kvmhv_restore_hv_return_state(vcpu, &hvregs);
-		vcpu->arch.shregs.msr = vcpu->arch.regs.msr;
-		vcpu->arch.shregs.dar = mfspr(SPRN_DAR);
-		vcpu->arch.shregs.dsisr = mfspr(SPRN_DSISR);
-		vcpu->arch.psscr = mfspr(SPRN_PSSCR_PR);
-		mtspr(SPRN_PSSCR_PR, host_psscr);
-
-		dec = mfspr(SPRN_DEC);
-		if (!(lpcr & LPCR_LD)) /* Sign extend if not using large decrementer */
-			dec = (s32) dec;
-		*tb = mftb();
-		vcpu->arch.dec_expires = dec + (*tb + vc->tb_offset);
+		trap = kvmhv_vcpu_entry_p9_nested(vcpu, time_limit, lpcr, tb);
 
 		/* H_CEDE has to be handled now, not later */
 		if (trap == BOOK3S_INTERRUPT_SYSCALL && !vcpu->arch.nested &&
-- 
2.23.0

