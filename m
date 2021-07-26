Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE523D51C9
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhGZDLh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbhGZDL3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:11:29 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0092C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:57 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id p5-20020a17090a8685b029015d1a9a6f1aso11972650pjn.1
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4FMW47dARaup+eOqBMjIjGjKfF+ltOIcNH9DSadt5C4=;
        b=HOKqpTPk5lE5fjYw+uVPSwYFwNbq92SAWi8giqUyT9LLGQSBP9CPlEVg6B7jxa2QME
         4ckogK4xix6yhsQzIiFvajyHAdKGK/bUONAXdvqZofKGGA+6Q6gVNhUbILRxNDAp0Yyc
         aLkU/JwQLSk/9UUhwEm4zn5/45TuDir4OKZiu96YnarcMYYnxATog9gQaQpoS2ak8I6L
         CNJ78E0Yd3SlYBtmEj4ebqdL71AZhG9ZQ5pcV92xuBnDi5FSdZ0pNs729k2e7UIeIjg+
         IhwmNIUlXyJtdz9obRQI0HzLLLNjfLpUDqgZ/vnuhcSGHCzFJlAFmTUvnpB8P+7KKgXQ
         UV8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4FMW47dARaup+eOqBMjIjGjKfF+ltOIcNH9DSadt5C4=;
        b=OZ/FlsdbBnrIamwUvLNUwLEaLpkMFvNwrjUq5l+n5vJ10gs44SfaM0Hno/K4bmEDUo
         9QZ99pRM64jQ47rGpIaLtJgYxcXP/p7GMgHnYsaHGKg9CUvi9lddsH0aOdR2fptnZYrr
         v/JgOTgeIkArEA0zRWhBpo9R7ueKffYyWx8DOmV+e56FTwNc9wuYdcsd80IlAwZasFpi
         ak5or/dnIHLIKf1IUY3shnKsFO4TOuYTm4qkXCxiuGoipQjChldSHuMYx5ifwbSRu1EG
         wKEr5Z+sGV5NiQJvZXUjO4E5DfZWS0wPbd/IZ0tnmGzIIjEgQnL+/g0VlpbaPduHk3g2
         4sew==
X-Gm-Message-State: AOAM532ImHAEiNIHHjjOK1wLwftH1DuSzEupjWdtfVEk5j5naSFgmH7V
        c0ZaFyFkECfZSlnjbqLGZ7U/V+nKWcM=
X-Google-Smtp-Source: ABdhPJwHn4E6yTCWXtErPNc+BeOQyynG2dD/DRZCLKaW97xyd4T92AoQfu8XAB7VKDUHnQbRlMCpQw==
X-Received: by 2002:a63:1f24:: with SMTP id f36mr16264020pgf.151.1627271517416;
        Sun, 25 Jul 2021 20:51:57 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:51:57 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 31/55] KVM: PPC: Book3S HV P9: Juggle SPR switching around
Date:   Mon, 26 Jul 2021 13:50:12 +1000
Message-Id: <20210726035036.739609-32-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This juggles SPR switching on the entry and exit sides to be more
symmetric, which makes the next refactoring patch possible with no
functional change.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 56429b53f4dc..c2c72875fca9 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4175,7 +4175,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		msr = mfmsr(); /* TM restore can update msr */
 	}
 
-	switch_pmu_to_guest(vcpu, &host_os_sprs);
+	load_spr_state(vcpu, &host_os_sprs);
 
 	load_fp_state(&vcpu->arch.fp);
 #ifdef CONFIG_ALTIVEC
@@ -4183,7 +4183,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 #endif
 	mtspr(SPRN_VRSAVE, vcpu->arch.vrsave);
 
-	load_spr_state(vcpu, &host_os_sprs);
+	switch_pmu_to_guest(vcpu, &host_os_sprs);
 
 	if (kvmhv_on_pseries()) {
 		/*
@@ -4283,6 +4283,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			vcpu->arch.slb_max = 0;
 	}
 
+	switch_pmu_to_host(vcpu, &host_os_sprs);
+
 	store_spr_state(vcpu);
 
 	store_fp_state(&vcpu->arch.fp);
@@ -4297,8 +4299,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	vcpu_vpa_increment_dispatch(vcpu);
 
-	switch_pmu_to_host(vcpu, &host_os_sprs);
-
 	timer_rearm_host_dec(*tb);
 
 	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
-- 
2.23.0

