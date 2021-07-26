Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078AF3D51CE
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhGZDLk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbhGZDLf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:11:35 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED63C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:04 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ch6so2117060pjb.5
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E7lSZKkeRBx/lmK1ZoScnTXTHEokSNfF7n9IIZhjKQo=;
        b=YBpupHcoosdsjx1bOr/CykY+lat2mvzOYg7BAfxFWPCzAl7yFICO2Qjm3SikCcM1hi
         +vRUxqF0omZ3T88ih3A0goPjvKwCXHf4XFE2QCXHqhg5uhmUSFEC8x95IuXtkUJEdi3u
         Y3KlazkdDRyx/wmtpPflD0SWPvecuA/H+mfWFqfElGRuNY5/o5w5lIonsyKK9RxKmPTh
         LZjR3F7QhPTZlbT1ne4Iyl4en8zK4gW5Wo8xJbLK4dNePxjf82lFphw0TRMChl/8YT/u
         fHQnE8LFavjroy4SEV8gjFH+9embDMCjHegJ9uIl/IPmDG1/7kYyZ+VsvXSd72z2yMlr
         BeaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E7lSZKkeRBx/lmK1ZoScnTXTHEokSNfF7n9IIZhjKQo=;
        b=mJp1Hbq39pIpt5sdyGrF+gvwqiTmSvMyYSMBbefzBKhSaGQ5Y82PTCcHpGjgSA7Rrx
         VJBTpgZZg6QEdZiWrLXfaq88zBK65TmrUjLjph2uM0aobxzR+XU8I2hrwEY4+kKIHJq9
         kjirZUhUaNwhy+y4XDkV3d6qMIsPJElyN/ashGp6GzQxedM04HkV9SprGlvV1EHJfrIq
         NoM6o+A/JyM9EHC/Fum8/kDD3iUOR/QSkVJ780m3x1U5MlQtJziY8ERbJl32S+ORdkC8
         tBtHfe4m16EEGvUYE2XISu0SwfGmCMbcORcCmj3yhaz2OWdRkDGX0HdL5bp9GTdIqE3Z
         GwhA==
X-Gm-Message-State: AOAM533ru1+JatNBgXfc0jbu5MCxOz+wUn1g6LjSj+GLklJhmIWgJYmz
        qRV9plwYti+VSD7fLy4vC/+ZYmOD8Gc=
X-Google-Smtp-Source: ABdhPJxXIfnXaG+zeKXPwYRcltDiIUqW6u3IvV15bXucFIUJFYdE8KTH07jRzewjdwaIFknPG2FQhA==
X-Received: by 2002:a17:90b:4b08:: with SMTP id lx8mr15407571pjb.66.1627271524129;
        Sun, 25 Jul 2021 20:52:04 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:52:03 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 34/55] KVM: PPC: Book3S HV P9: Move nested guest entry into its own function
Date:   Mon, 26 Jul 2021 13:50:15 +1000
Message-Id: <20210726035036.739609-35-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
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
index 977712eb74e0..cb66c9534dbf 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3789,6 +3789,72 @@ static void vcpu_vpa_increment_dispatch(struct kvm_vcpu *vcpu)
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
@@ -3797,7 +3863,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	struct p9_host_os_sprs host_os_sprs;
-	s64 dec;
 	u64 next_timer;
 	unsigned long msr;
 	int trap;
@@ -3850,63 +3915,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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

