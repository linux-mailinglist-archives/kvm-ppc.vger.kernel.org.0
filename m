Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7643E9560
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbhHKQDm (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233276AbhHKQDk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:03:40 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F907C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:17 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so10329502pjn.4
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XEm+DUqj4PUtiyOis8qtw0OTEw1uAY3Zp3uaXAMjEQ4=;
        b=dJC/kinxyhAdc5J8a4tDG79b2oCr39+gJuy90PWsrsw9a0ps6Mca8mQcPrqYaOV6U5
         fF1PAfH9PVxfLfLX1aIbZrZqilYHQtksGV/c7MathOCCZSA3kpCo11yJ6zS0uKFSeGjK
         zk6gQJn/RW7fZUO6cbGOvoqOS/EksCwdpezAp5UjSLmQX/u5dAhyzqp2exkbU+X0T5qv
         w1IDeiyumd5IwBauDOGe9E0SvOFkIyaSxfUXNV4L1MRGhoEQq7g5t/lBcbMIwMHTYr0N
         MdOLrqjuKUguerPpxnVUKy6Io/eKxH0QkGIlKwOHF1gi89j8kA2JordYjPw6dJCIwpuG
         yPyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XEm+DUqj4PUtiyOis8qtw0OTEw1uAY3Zp3uaXAMjEQ4=;
        b=Kyk4Q+jqkTZ+LoPfjThQcxpB0wzwHhhE5ohUbt2HfXQTOfgDShhOaILs2RJSbiKBbf
         k+9NBKokgSvTy9/Xaho+BPALbxdTLQ7E1/OLvbs9pG4695LNf2U2t80JMrk+ovfLFTt7
         e/nIkDdOF/VY5vtZk7RiVfVEadYCWQrSJQDXoXv+QekpbaCK96PC9eggOLx5C4HMuioZ
         yQMc8uMU3go+iXK5JMBCC6O6GzgirgtxPbCwtd1JjiQVuDFt7bT2wNz1lbRrpGS5uyyC
         J33CY6fg6aAfPhN+N/00ihD4aMDEQ1z8JiJYK8UWK20P0lT0omNN6K+iwx1CJLkPzH7H
         UAqg==
X-Gm-Message-State: AOAM533J/2B7iW2Va53OayJacHNnA7J5ncHGMGrsrZGfZ1IThlI82dCR
        r2rb2cDInpIWRSzgR/a6jPUY8HtCemI=
X-Google-Smtp-Source: ABdhPJwbukVAGKjLO2gZJLa3Iwc+KZUCF6MrCW4j/yqRZ8x8u2AzScv9ZLLuH3hXgM/MnFAfSTZUnQ==
X-Received: by 2002:a17:90a:c006:: with SMTP id p6mr6424106pjt.144.1628697796538;
        Wed, 11 Aug 2021 09:03:16 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:03:16 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 35/60] KVM: PPC: Book3S HV P9: Juggle SPR switching around
Date:   Thu, 12 Aug 2021 02:01:09 +1000
Message-Id: <20210811160134.904987-36-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
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
index 85f441d9ce63..7867d6793b3e 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4211,7 +4211,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		msr = mfmsr(); /* TM restore can update msr */
 	}
 
-	switch_pmu_to_guest(vcpu, &host_os_sprs);
+	load_spr_state(vcpu, &host_os_sprs);
 
 	load_fp_state(&vcpu->arch.fp);
 #ifdef CONFIG_ALTIVEC
@@ -4219,7 +4219,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 #endif
 	mtspr(SPRN_VRSAVE, vcpu->arch.vrsave);
 
-	load_spr_state(vcpu, &host_os_sprs);
+	switch_pmu_to_guest(vcpu, &host_os_sprs);
 
 	if (kvmhv_on_pseries()) {
 		/*
@@ -4319,6 +4319,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			vcpu->arch.slb_max = 0;
 	}
 
+	switch_pmu_to_host(vcpu, &host_os_sprs);
+
 	store_spr_state(vcpu);
 
 	store_fp_state(&vcpu->arch.fp);
@@ -4333,8 +4335,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	vcpu_vpa_increment_dispatch(vcpu);
 
-	switch_pmu_to_host(vcpu, &host_os_sprs);
-
 	timer_rearm_host_dec(*tb);
 
 	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
-- 
2.23.0

