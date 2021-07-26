Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7AF3D51C6
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbhGZDLg (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbhGZDLZ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:11:25 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A40C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:53 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id k4-20020a17090a5144b02901731c776526so17812798pjm.4
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dkosrLJncWeVp01oPT/L/8v9iInUM0LnXzW1YmzkeCg=;
        b=ebr+W46BWAkrvxze47hy6Dw2mtEoNd77bXIc+lm1eJkO8/rFAAYX2AVbvQKIefbFN8
         bXS3LF+wchbeRMkHzvGw8uQd6NXJwxZp53r9ag0dYZLmXDu7Fu8RAP6+9s6uipPcw5km
         Pmu8u7yQm2e6yXJ+t7GwakZ075KRrUnymW35ugql1r1HDLdkyuBTWlRcGWD+Y2UyM1y6
         oriScHpLVwTO1Od6rKHnLnShrlqY0UCFlOjjlQjqCTdqnx40yWJwQZB0hl5fu23+8TQo
         I+cta2zlsxcJV4z/mkNwyNNpdaS6xb8bQ0Qp6s5+c2oYUf/e34bKhSpQ70SmcPbUV8k2
         3DsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dkosrLJncWeVp01oPT/L/8v9iInUM0LnXzW1YmzkeCg=;
        b=sCqYiBwu+k6wXEtWEbrn9ZaHAaimTEcI0chcdiiMo5Gg3c4mYvEM0mlntmQ9vaIiT/
         aAfl0Hj6SaRAJBsZwyeEsv7i+s/Ip1aTwJ8YK/AdY06VmXbid+fftiI80tJV59MuhP4g
         G5AVxmxrhBsRIqd5d5P3IM2Z4oLkbQoyUFAuFv/vlYzbA1JhGUvT15+MFvp7UZlEkzjR
         rvk/IOtyI1fm3gcnQ0p4eLa5lGpMao0En/vI21tYFSlRvPDaZQlaCC0T+GvuDila0Rxz
         o3xkWgsZh9kPmRT8pEAPRsxLOKP652C830GSAgzAmP2OIaaUxqGmZBWYuatEKNUYb4AA
         4yOA==
X-Gm-Message-State: AOAM530XGkMUYCAUoILnzk1ZQX+WkKITVLRsVNFaVkqFkracLoblB65L
        BAwHx9Uw4Dgz3vkn8p8WkYAhReTzkSA=
X-Google-Smtp-Source: ABdhPJw9Omqh9W5+iCAZK7Gajq6QtnmP3F/tcC+JwM+NbCWFKQTQ8yJaoNlq5fJWBfBFDdeVqJFHDA==
X-Received: by 2002:aa7:82cb:0:b029:2e6:f397:d248 with SMTP id f11-20020aa782cb0000b02902e6f397d248mr16056472pfn.52.1627271513035;
        Sun, 25 Jul 2021 20:51:53 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:51:52 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 29/55] KVM: PPC: Book3S HV P9: Avoid SPR scoreboard stalls
Date:   Mon, 26 Jul 2021 13:50:10 +1000
Message-Id: <20210726035036.739609-30-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Avoid interleaving mfSPR and mtSPR.

-151 cycles (7427) POWER9 virt-mode NULL hcall

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          |  8 ++++----
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 19 +++++++++++--------
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index fa44bbca75e4..0d97138e6fa4 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4271,10 +4271,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	store_spr_state(vcpu);
 
-	timer_rearm_host_dec(*tb);
-
-	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
-
 	store_fp_state(&vcpu->arch.fp);
 #ifdef CONFIG_ALTIVEC
 	store_vr_state(&vcpu->arch.vr);
@@ -4289,6 +4285,10 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	switch_pmu_to_host(vcpu, &host_os_sprs);
 
+	timer_rearm_host_dec(*tb);
+
+	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
+
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
 
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 2bd96d8256d1..bd0021cd3a67 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -228,6 +228,9 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		host_dawrx1 = mfspr(SPRN_DAWRX1);
 	}
 
+	local_paca->kvm_hstate.host_purr = mfspr(SPRN_PURR);
+	local_paca->kvm_hstate.host_spurr = mfspr(SPRN_SPURR);
+
 	if (vc->tb_offset) {
 		u64 new_tb = *tb + vc->tb_offset;
 		mtspr(SPRN_TBU40, new_tb);
@@ -244,8 +247,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	mtspr(SPRN_DPDES, vc->dpdes);
 	mtspr(SPRN_VTB, vc->vtb);
 
-	local_paca->kvm_hstate.host_purr = mfspr(SPRN_PURR);
-	local_paca->kvm_hstate.host_spurr = mfspr(SPRN_SPURR);
 	mtspr(SPRN_PURR, vcpu->arch.purr);
 	mtspr(SPRN_SPURR, vcpu->arch.spurr);
 
@@ -448,10 +449,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	/* Advance host PURR/SPURR by the amount used by guest */
 	purr = mfspr(SPRN_PURR);
 	spurr = mfspr(SPRN_SPURR);
-	mtspr(SPRN_PURR, local_paca->kvm_hstate.host_purr +
-	      purr - vcpu->arch.purr);
-	mtspr(SPRN_SPURR, local_paca->kvm_hstate.host_spurr +
-	      spurr - vcpu->arch.spurr);
+	local_paca->kvm_hstate.host_purr += purr - vcpu->arch.purr;
+	local_paca->kvm_hstate.host_spurr += spurr - vcpu->arch.spurr;
 	vcpu->arch.purr = purr;
 	vcpu->arch.spurr = spurr;
 
@@ -464,6 +463,9 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	vcpu->arch.shregs.sprg2 = mfspr(SPRN_SPRG2);
 	vcpu->arch.shregs.sprg3 = mfspr(SPRN_SPRG3);
 
+	vc->dpdes = mfspr(SPRN_DPDES);
+	vc->vtb = mfspr(SPRN_VTB);
+
 	dec = mfspr(SPRN_DEC);
 	if (!(lpcr & LPCR_LD)) /* Sign extend if not using large decrementer */
 		dec = (s32) dec;
@@ -481,6 +483,9 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		vc->tb_offset_applied = 0;
 	}
 
+	mtspr(SPRN_PURR, local_paca->kvm_hstate.host_purr);
+	mtspr(SPRN_SPURR, local_paca->kvm_hstate.host_spurr);
+
 	/* Preserve PSSCR[FAKE_SUSPEND] until we've called kvmppc_save_tm_hv */
 	mtspr(SPRN_PSSCR, host_psscr |
 	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
@@ -509,8 +514,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	if (cpu_has_feature(CPU_FTR_ARCH_31))
 		asm volatile(PPC_CP_ABORT);
 
-	vc->dpdes = mfspr(SPRN_DPDES);
-	vc->vtb = mfspr(SPRN_VTB);
 	mtspr(SPRN_DPDES, 0);
 	if (vc->pcr)
 		mtspr(SPRN_PCR, PCR_MASK);
-- 
2.23.0

