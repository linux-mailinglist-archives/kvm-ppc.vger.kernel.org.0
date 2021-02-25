Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2513250D8
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhBYNtP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhBYNtK (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:49:10 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0054C06121E
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:19 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id j12so3621356pfj.12
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5VNlGtaRSctLYlPeChdxDgtGvbZrSWxq9sa/ajZPH1c=;
        b=SOqp7vt2cwBvh3FOLS+ZqkyswmxMv+IhcaCzXAtn+qMSGhlYztYsdA+BBQIvrLXkZL
         X4cBl5NndAKHtxlH8P51LKzFrkCqqor39tC0shbwkzh4plUzUOftmEvgTUDGCueuP0rp
         Q/JNsUYw86WBdNOy1B9Yx1RQ94x3/98ZM9ixvpS2rCBPwWd0wSz8sLKDQHWbmsWcMC51
         DdSr8XQuNpgyqpcQiwuimBggX2WntJfAUYU6qcBDldyTu/fzPfWZG4BXvo2MpDZ9xoOo
         JiohBow/zRFTOsV1f7sKDCNxuZIJ+JAfkwzg1V1Iwuiyc0IMBZTBhSOlyV2+x5UxSXlm
         8WYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5VNlGtaRSctLYlPeChdxDgtGvbZrSWxq9sa/ajZPH1c=;
        b=f/EuXpuot/+9iGuNGyZ12nca45ghNYfX5yytbYeA3T8pER3k5ph9aLaR47/nMRPz2Y
         6Q0Ia/iQkAjEigrwFCiFWg2ZNWHPUnHP85mfGBsR3wduG1B5ygy91k2nRp6TV+TrlVRo
         UU6e6BV/1fKgAOKeEHHkOeFNvarYXKyQ75chEmcAeg9kO8JdxUWpuMmeGy8dqlbXOzNz
         UX/PzhynCE04gZZyDRtGfoQmwFyroCLEQNKWpVf//uZqDruya1ENUhWYOUzO62BL+vUf
         GRk1BmuABpCEffORUf/A9GW+4pRn29lf7DQE+WMNhQU9doYlOBEkQ2xhE+6C3vTQhD4M
         s3jw==
X-Gm-Message-State: AOAM533ENedBw/4moTeZpoBMzjKamF5m2go+S+SqhJwO0ImFMu6rJsOn
        OsjqvGfBz89NEwq+j0HkKitrN5POR+M=
X-Google-Smtp-Source: ABdhPJx1UcBDTKpvP1zGz70sEDd9oVgfptBMzSZBjBnBZSh09cKJ2k7xVwMFEO7HEGjA0y5ByNwwng==
X-Received: by 2002:a62:8686:0:b029:1ed:7a8b:4933 with SMTP id x128-20020a6286860000b02901ed7a8b4933mr3470531pfd.9.1614260898881;
        Thu, 25 Feb 2021 05:48:18 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:48:18 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 22/37] KVM: PPC: Book3S HV P9: Reduce irq_work vs guest decrementer races
Date:   Thu, 25 Feb 2021 23:46:37 +1000
Message-Id: <20210225134652.2127648-23-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

irq_work's use of the DEC SPR is racy with guest<->host switch and guest
entry which flips the DEC interrupt to guest, which could lose a host
work interrupt.

This patch closes one race, and attempts to comment several others.

(XXX: should think a bit harder about this)

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/paca.h |  1 +
 arch/powerpc/kvm/book3s_hv.c    | 15 ++++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
index ec18ac818e3a..23c12048fbc9 100644
--- a/arch/powerpc/include/asm/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -174,6 +174,7 @@ struct paca_struct {
 	u8 irq_happened;		/* irq happened while soft-disabled */
 	u8 irq_work_pending;		/* IRQ_WORK interrupt while soft-disable */
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+	/* Could have irq_work_using_hdec here, but what about nested HV entry modifying DEC? Could have a pointer to the hv struct time limit */
 	u8 pmcregs_in_use;		/* pseries puts this in lppaca */
 #endif
 	u64 sprg_vdso;			/* Saved user-visible sprg */
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index d98958b78830..1997cf347d3e 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3689,6 +3689,18 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (!(vcpu->arch.ctrl & 1))
 		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
 
+	/*
+	 * XXX: must always deal with irq_work_raise via NMI vs setting DEC.
+	 * The problem occurs right as we switch into guest mode if a NMI
+	 * hits and sets pending work and sets DEC, then that will apply to
+	 * the guest and not bring us back to the host.
+	 *
+	 * irq_work_raise could check a flag (or possibly LPCR[HDICE] for
+	 * example) and set HDEC to 1? That wouldn't solve the nested hv
+	 * case which needs to abort the hcall or zero the time limit.
+	 *
+	 * Another day's problem.
+	 */
 	mtspr(SPRN_DEC, vcpu->arch.dec_expires - tb);
 
 	if (kvmhv_on_pseries()) {
@@ -3822,7 +3834,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
 
-	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - tb);
+	set_dec_or_work(local_paca->kvm_hstate.dec_expires - tb);
+
 	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
 
 	kvmhv_load_host_pmu();
-- 
2.23.0

