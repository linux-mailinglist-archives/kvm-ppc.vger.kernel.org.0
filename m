Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4FC3B020A
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhFVLBO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhFVLBN (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:01:13 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAE1C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:58 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id d12so2207843pgd.9
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fJodkEL3mlkd09uEBZ0qy1MXGKcAacqn5bf7t2b6BD4=;
        b=LbsTxDlX3EJ/YgLJJ6Oo476zONcdaSAtPw7RTLXiDsSaaTi9AGcN0AU1IQPF+ExvKR
         0Sh++pLlOCTwvZhw0FaY+/TRTuSW8rmUEh/OE05n19IJZofbgPO6k9x8VKNypzDsy3u0
         SZOgOVtNkqJQ5m61Oej2SvlIM1TGnFAnoz8QcAkfCEaAfZBxILcIaccNL5lDl8YTamy5
         ZiOtSLQukq8USI0Ku+dlD0tUUPc8w50zCynW/tJUgxjtHObhEyppnVmZiilvNIFs2Is6
         0C+q+HVqgaYsJDg7BV3sTybVibd5FIC4reueexqHOIAZXATnSaymT5OViadml64bqEsH
         QfWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fJodkEL3mlkd09uEBZ0qy1MXGKcAacqn5bf7t2b6BD4=;
        b=K4rx/1wZwSd9ffQZqxHHoeJSc+PK7/a50749M80D/KgRyAZsc4JDYbejdwDyEcxSY2
         Vyp4aBv3ABPUfFnKIbMHoTf2WWJ7BlKYde2Gzb7SiotaU+cSK0kP/qjvOakd9Hzf2OzS
         CHWZGQrYvmKxkrK6XxnjVz+OFvkoalj6ZB+6Ji8xTp5SD2NW4AxULdEhCVnQpnywS29L
         LR9hs22rN/QU+E/K/NaKdYOQHAOKRBT8G8R/8sMNg656cH0a+1moIzDJJssW/BIxGb9X
         uDLkCBgd26zj8Okum/WnT0v2/FM1NXqc9AvamEP8TBTFVXNtHS7of2DKWjucvfiIHgYj
         Rc3w==
X-Gm-Message-State: AOAM533Sg7hXSBk3Dq2GDsyrbkAwOesCKZJCtW6Mp4OqLgeTTU0gFm7I
        zajVvsde7ac6Ugo3rgularMU2yWiMDs=
X-Google-Smtp-Source: ABdhPJygGW0fZVLDBJVE3wO94MhuNwPdJ3LH/1XjLnBXyOHKiG3WU0l9aO70MrwzHx/ApHkeUWjaYw==
X-Received: by 2002:a63:be45:: with SMTP id g5mr3168250pgo.311.1624359537779;
        Tue, 22 Jun 2021 03:58:57 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:58:57 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 25/43] KVM: PPC: Book3S HV P9: Juggle SPR switching around
Date:   Tue, 22 Jun 2021 20:57:18 +1000
Message-Id: <20210622105736.633352-26-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
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
index 612b70216e75..a780a9b9effd 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4069,7 +4069,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
 		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
 
-	switch_pmu_to_guest(vcpu, &host_os_sprs);
+	load_spr_state(vcpu, &host_os_sprs);
 
 	load_fp_state(&vcpu->arch.fp);
 #ifdef CONFIG_ALTIVEC
@@ -4077,7 +4077,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 #endif
 	mtspr(SPRN_VRSAVE, vcpu->arch.vrsave);
 
-	load_spr_state(vcpu, &host_os_sprs);
+	switch_pmu_to_guest(vcpu, &host_os_sprs);
 
 	if (kvmhv_on_pseries()) {
 		/*
@@ -4177,6 +4177,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			vcpu->arch.slb_max = 0;
 	}
 
+	switch_pmu_to_host(vcpu, &host_os_sprs);
+
 	store_spr_state(vcpu);
 
 	store_fp_state(&vcpu->arch.fp);
@@ -4191,8 +4193,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	vcpu_vpa_increment_dispatch(vcpu);
 
-	switch_pmu_to_host(vcpu, &host_os_sprs);
-
 	timer_rearm_host_dec(*tb);
 
 	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
-- 
2.23.0

