Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98E0421348
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236219AbhJDQC5 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236220AbhJDQC4 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:02:56 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C7EC061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:01:07 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id p1so8841150pfh.8
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cnfzayer/odaC20bEu/UMo0Ban8qAMEc7NkYV1p/hU8=;
        b=i/i7wLrhPuKj8xef4HNo0yzJAzxsWagLSCJZEm2GVybli0EMdfz1v0EvYh1rvtdAMK
         PLyzi991XdldSAV+o6uOOVlzLSqyfh+k8aIerL+yZDMox4vzWj/LomQ+KnqRV3s3+Oek
         i1t8GJa5GNdzvqTDX5xMZoy05HUBMbmm5eQwrs/aXw/hzHFNA/RhdSQAubcyf3Gzlyep
         Ua5O2JFnzZWaIL3PwVCwlZdadpUfWPJjAuDVAkWCXd64OfFQtqImKxg+9BPLgXC/FL9P
         f9nSXHwj396vz0WBj1QEEpxS0NZ6iT9uAVgh9MXbbycTMzyLVU3TPn4jK0eLNgnylV3z
         wlRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cnfzayer/odaC20bEu/UMo0Ban8qAMEc7NkYV1p/hU8=;
        b=Jg5LABHT0zKDzLBCQ31CIVgBQ2U75x2JlJ1R9IkcxRfxUuAkA4TGi9IayxOZujoDLB
         YpNH9g7Vg4J6b+p61xaN6ySJYikgj+GumPFJMt/n40USSrrmmQE8BOYnll5JbdziI3uA
         PA3hjlFlVmril37fy97Xp+U2q+3r7CTVo4RxO+zC99cJmxPqBevACmJIihCPiLpO2eRA
         7KEe+zG1XXIyWdW0VWNM1z3fEjX0dZbLO99a3XPsW1wGNh5Yuduh8UH20jCXRFhE/8uP
         TVrSyEicrCDS8tgIfOEUdrQppM6aJ5VjzIsiI6f1t5V8oi7SXyoKwYIKeQAL4Kf5F2ha
         TUXA==
X-Gm-Message-State: AOAM530QokAE5wDgEIyDsjrxsMXxBkXP7Uk/1FsL/B+61Ez/sQ1kDV32
        XME3h8VF7HY1hO/9y9tVp3jO/KF3C70=
X-Google-Smtp-Source: ABdhPJzQidBs0IfBrm6laNxRLmaLqZy0ljGZ98570y7F4m7cBL+iegV6TmHqU8fyrzqwkoW3aFxXdw==
X-Received: by 2002:aa7:8891:0:b0:44c:255d:391f with SMTP id z17-20020aa78891000000b0044c255d391fmr15502813pfe.26.1633363266698;
        Mon, 04 Oct 2021 09:01:06 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:01:06 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 02/52] powerpc/64s: guard optional TIDR SPR with CPU ftr test
Date:   Tue,  5 Oct 2021 01:59:59 +1000
Message-Id: <20211004160049.1338837-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The TIDR SPR only exists on POWER9. Avoid accessing it when the
feature bit for it is not set.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 12 ++++++++----
 arch/powerpc/xmon/xmon.c     | 10 ++++++++--
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 2acb1c96cfaf..f4a779fffd18 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3767,7 +3767,8 @@ static void load_spr_state(struct kvm_vcpu *vcpu)
 	mtspr(SPRN_EBBHR, vcpu->arch.ebbhr);
 	mtspr(SPRN_EBBRR, vcpu->arch.ebbrr);
 	mtspr(SPRN_BESCR, vcpu->arch.bescr);
-	mtspr(SPRN_TIDR, vcpu->arch.tid);
+	if (cpu_has_feature(CPU_FTR_P9_TIDR))
+		mtspr(SPRN_TIDR, vcpu->arch.tid);
 	mtspr(SPRN_AMR, vcpu->arch.amr);
 	mtspr(SPRN_UAMOR, vcpu->arch.uamor);
 
@@ -3793,7 +3794,8 @@ static void store_spr_state(struct kvm_vcpu *vcpu)
 	vcpu->arch.ebbhr = mfspr(SPRN_EBBHR);
 	vcpu->arch.ebbrr = mfspr(SPRN_EBBRR);
 	vcpu->arch.bescr = mfspr(SPRN_BESCR);
-	vcpu->arch.tid = mfspr(SPRN_TIDR);
+	if (cpu_has_feature(CPU_FTR_P9_TIDR))
+		vcpu->arch.tid = mfspr(SPRN_TIDR);
 	vcpu->arch.amr = mfspr(SPRN_AMR);
 	vcpu->arch.uamor = mfspr(SPRN_UAMOR);
 	vcpu->arch.dscr = mfspr(SPRN_DSCR);
@@ -3813,7 +3815,8 @@ struct p9_host_os_sprs {
 static void save_p9_host_os_sprs(struct p9_host_os_sprs *host_os_sprs)
 {
 	host_os_sprs->dscr = mfspr(SPRN_DSCR);
-	host_os_sprs->tidr = mfspr(SPRN_TIDR);
+	if (cpu_has_feature(CPU_FTR_P9_TIDR))
+		host_os_sprs->tidr = mfspr(SPRN_TIDR);
 	host_os_sprs->iamr = mfspr(SPRN_IAMR);
 	host_os_sprs->amr = mfspr(SPRN_AMR);
 	host_os_sprs->fscr = mfspr(SPRN_FSCR);
@@ -3827,7 +3830,8 @@ static void restore_p9_host_os_sprs(struct kvm_vcpu *vcpu,
 	mtspr(SPRN_UAMOR, 0);
 
 	mtspr(SPRN_DSCR, host_os_sprs->dscr);
-	mtspr(SPRN_TIDR, host_os_sprs->tidr);
+	if (cpu_has_feature(CPU_FTR_P9_TIDR))
+		mtspr(SPRN_TIDR, host_os_sprs->tidr);
 	mtspr(SPRN_IAMR, host_os_sprs->iamr);
 
 	if (host_os_sprs->amr != vcpu->arch.amr)
diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index dd8241c009e5..7958e5aae844 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -2107,8 +2107,14 @@ static void dump_300_sprs(void)
 	if (!cpu_has_feature(CPU_FTR_ARCH_300))
 		return;
 
-	printf("pidr   = %.16lx  tidr  = %.16lx\n",
-		mfspr(SPRN_PID), mfspr(SPRN_TIDR));
+	if (cpu_has_feature(CPU_FTR_P9_TIDR)) {
+		printf("pidr   = %.16lx  tidr  = %.16lx\n",
+			mfspr(SPRN_PID), mfspr(SPRN_TIDR));
+	} else {
+		printf("pidr   = %.16lx\n",
+			mfspr(SPRN_PID));
+	}
+
 	printf("psscr  = %.16lx\n",
 		hv ? mfspr(SPRN_PSSCR) : mfspr(SPRN_PSSCR_PR));
 
-- 
2.23.0

