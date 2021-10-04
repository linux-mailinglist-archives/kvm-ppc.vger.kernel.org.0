Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C201A421377
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236300AbhJDQES (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236290AbhJDQES (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:04:18 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D55C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:02:29 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id d13-20020a17090ad3cd00b0019e746f7bd4so4285371pjw.0
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fq87rfMDwDfdeH36xguI8Sx1EqHcJXrKBlZ1OzcLmnA=;
        b=WpCXD4wi/JI5J9ibOIBdVVZ0N5PAqJddWLsrhhWtAGvTAK8HiI+aJUGd671MHfe+/8
         0EvIltI4Zm6O7rM0jvNygX3+LyfIXolv7Ln5h519+x2sseaauZ7+ixU90yQ1LrZL9AUK
         3F/KI0sEnaGBRdTCa/idSsO5BABqcsPAVksPEXDoU//aG6rxcIaYeO4axxrJkVu2P6Rx
         yVVxPqXTsP9aEdY5cpd+IgNzN1ufwjAqcy2kVD6gnRDA9ThzOJLyg3uv2EHaATTFoDUW
         6U5fL6Rf/FWIgwlZiHev1eqIeqUMnho85KkB8qA0o622zoQjXqVGonxqcLSTdOQbsLON
         BT0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fq87rfMDwDfdeH36xguI8Sx1EqHcJXrKBlZ1OzcLmnA=;
        b=bsKr7HTqNjsDGdUQp5f40+TWCqeZmkiYe/erqcU4VXbTgckRKUU1Zfe+Ce2aVaVXIR
         SoG+LRj1jbOUj6F+oNPJpbGuQhYrzaOMk877k9QkBYCPFN2XDzUeLUKSg9hHpCXryBg4
         6+Nee2cJmYjH1piBtbrTmHnXTNAk8NpLznYpUcBlRgS1pu+x8YY/FELABwpD5AkKRiIa
         osEgCVeuulbGMIcyRN2LWOdLWYnhpNGaTlsAP3dwazeQjcrsP7Dp6fnHsQLkAc7hc23W
         9KXY+Opw65hqEB0kROYGiLILWp+KDnUR0+ICckriryI6N7Ih7rK5a8ojpkQguQe0tlOH
         In7Q==
X-Gm-Message-State: AOAM533JrsFthNCJO7rerAPSCm+7+egYxbDsU4+d3eAyIPKtub8PWTX4
        bYCKDfG0l+DxOSKtjgrEH+/10H35JwE=
X-Google-Smtp-Source: ABdhPJwehgfWWGzyLyrKMEkByEkD9YvBHWhENI58G7BW0sEb2h7rAE9jlDKCpERH+RyvGgKKToOEXw==
X-Received: by 2002:a17:902:7e84:b0:13e:d793:20d8 with SMTP id z4-20020a1709027e8400b0013ed79320d8mr400306pla.67.1633363348816;
        Mon, 04 Oct 2021 09:02:28 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:02:28 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v3 36/52] KVM: PPC: Book3S HV P9: Demand fault EBB facility registers
Date:   Tue,  5 Oct 2021 02:00:33 +1000
Message-Id: <20211004160049.1338837-37-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
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

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_host.h   |  1 +
 arch/powerpc/kvm/book3s_hv.c          | 16 +++++++++++++--
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 28 +++++++++++++++++++++------
 3 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index c5fc4d016695..9c63eff35812 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -579,6 +579,7 @@ struct kvm_vcpu_arch {
 	ulong cfar;
 	ulong ppr;
 	u32 pspb;
+	u8 load_ebb;
 	ulong fscr;
 	ulong shadow_fscr;
 	ulong ebbhr;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 6fb941aa77f1..070469867bf5 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1436,6 +1436,16 @@ static int kvmppc_pmu_unavailable(struct kvm_vcpu *vcpu)
 	return RESUME_GUEST;
 }
 
+static int kvmppc_ebb_unavailable(struct kvm_vcpu *vcpu)
+{
+	if (!(vcpu->arch.hfscr_permitted & HFSCR_EBB))
+		return EMULATE_FAIL;
+
+	vcpu->arch.hfscr |= HFSCR_EBB;
+
+	return RESUME_GUEST;
+}
+
 static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 				 struct task_struct *tsk)
 {
@@ -1727,6 +1737,8 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 				r = kvmppc_emulate_doorbell_instr(vcpu);
 			if (cause == FSCR_PM_LG)
 				r = kvmppc_pmu_unavailable(vcpu);
+			if (cause == FSCR_EBB_LG)
+				r = kvmppc_ebb_unavailable(vcpu);
 		}
 		if (r == EMULATE_FAIL) {
 			kvmppc_core_queue_program(vcpu, SRR1_PROGILL);
@@ -2771,9 +2783,9 @@ static int kvmppc_core_vcpu_create_hv(struct kvm_vcpu *vcpu)
 	vcpu->arch.hfscr_permitted = vcpu->arch.hfscr;
 
 	/*
-	 * PM is demand-faulted so start with it clear.
+	 * PM, EBB is demand-faulted so start with it clear.
 	 */
-	vcpu->arch.hfscr &= ~HFSCR_PM;
+	vcpu->arch.hfscr &= ~(HFSCR_PM | HFSCR_EBB);
 
 	kvmppc_mmu_book3s_hv_init(vcpu);
 
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index a23f09fa7d2d..929a7c336b09 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -232,9 +232,12 @@ static void load_spr_state(struct kvm_vcpu *vcpu,
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
 
 	if (cpu_has_feature(CPU_FTR_P9_TIDR))
 		mtspr(SPRN_TIDR, vcpu->arch.tid);
@@ -265,9 +268,22 @@ static void load_spr_state(struct kvm_vcpu *vcpu,
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
+		if (!vcpu->arch.nested) {
+			vcpu->arch.load_ebb++;
+			if (!vcpu->arch.load_ebb)
+				vcpu->arch.hfscr &= ~HFSCR_EBB;
+		}
+	}
 
 	if (cpu_has_feature(CPU_FTR_P9_TIDR))
 		vcpu->arch.tid = mfspr(SPRN_TIDR);
-- 
2.23.0

