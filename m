Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD0E3E9563
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbhHKQDs (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbhHKQDs (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:03:48 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E5DC061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:24 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id k2so3253172plk.13
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q71VMufbN+Ua/yV2KAAZXFo/19WvrB3dTeEElEh3dDo=;
        b=kzm6U5nPSp6URqDGs91N7tNtFkWp8g5XskgutpwxSlHaqj7NSF036UBh0HoKQcvTzk
         iHoZFCE9NgY0a8wCUQzJmnF+4/X/4vas26sFW9r1qAkYPAmlBkkc3f8kKDDCSTIcyVYL
         ldlecSjFkIAMnjJ7glnpqKybHxE6wPyEDKpB5Q1Nwn8a/VuhADpMd0M/2Jsc5xNalS1a
         aCwzEPiSa9zsIB4cEtEaZqEPf2eA/Nx7JdrodehLdWM8w11G7foyq3sYLayAa9GoZmnp
         9Zda4GMfjLhXERH5PmG1kwQYMeaAX7xn1HQkVh+laGXwEwDTKTz9CWHbckXBqpdqHtyB
         MYPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q71VMufbN+Ua/yV2KAAZXFo/19WvrB3dTeEElEh3dDo=;
        b=qP9Sml6PMFUJ5Vnda4DPtQKuO/7qGDH/8IU3T/aeKyeEjFYHP3PuYbfpJGZCqyNb3P
         ZiRrA7/SknVGHmC4o6SKOyO5SW9SAy/iY8Y5TJB408xLa+I4nEqCw8La5x5DbCfjwP1m
         Ch5/yjYSE6yYBSPuWtepZ5bO8Qu65eQ13iuvbtTWoFmLay4BaFzzQNzCnet3RfBMnqXc
         dA++tzjfu7m7+nlugYBy99LzjlPz29rF9/qMTHCX7TgHMKdgd+BleR+FRr2DPwSnpisM
         yBdvHAqcI8tnYSmIAAd0S+DkCcAlPmqrZC4dvdCl42fxqHg11VUJyxzTlNGpa7PALsWv
         6nQA==
X-Gm-Message-State: AOAM532U4wZy9tzfW6vzs2iz6ojWVe/ieyVsyncqbut6/+/G16giimhF
        /N5sv46fwyUgmyn2BRpx3VY7evE72+w=
X-Google-Smtp-Source: ABdhPJyIP+w1HFpynDG1Jen5Fv4k5nqFz7nRaPog37kcupKZs8M7uKjG6mKk5ckvxsrKXCp+f9DIbg==
X-Received: by 2002:a17:90a:de8b:: with SMTP id n11mr11387427pjv.31.1628697804353;
        Wed, 11 Aug 2021 09:03:24 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:03:24 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 38/60] KVM: PPC: Book3S HV P9: Move nested guest entry into its own function
Date:   Thu, 12 Aug 2021 02:01:12 +1000
Message-Id: <20210811160134.904987-39-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Move the part of the guest entry which is specific to nested HV into its
own function. This is just refactoring.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 125 +++++++++++++++++++----------------
 1 file changed, 67 insertions(+), 58 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 2731d3d39000..eaa4628b9b2a 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3812,6 +3812,72 @@ static void vcpu_vpa_increment_dispatch(struct kvm_vcpu *vcpu)
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
@@ -3820,7 +3886,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	struct p9_host_os_sprs host_os_sprs;
-	s64 dec;
 	u64 next_timer;
 	unsigned long msr;
 	int trap;
@@ -3873,63 +3938,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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

