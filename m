Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C643C32EDDC
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhCEPIp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbhCEPIN (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:08:13 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE68C061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:08:13 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id u18so1532179plc.12
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R8hvFML+h7aGhio9m3pUmg59NCmoXjdz02/DBxwqSEo=;
        b=Glj0zZnlRMTA+9nBh8B+nwlD13WWMKlabugF3KEPmCfAHbCS7rgrYEzfcJHoL1kxSi
         gx4HOykdAKAoa0XGbjy6qtptf6Sx6dPeJuq8JkAztT1uzMjaBgOhfD7IjqopHrli6a15
         UeBYhpHPBQm2sDmmQ8PKEffUvz4hICJVlYDHhHjMUr6pXIvgvQV9qlGD81xnOTzhR8Yw
         ecRjgAjvhNH8hVZkels4sKd/urWqbeTKZw/LeqY/NQQgW19+q8vWuu9cACbQIJOEfun/
         ABTRhQ3CWkDHfor/tSray8qQXxLchfjIXf9SXjh74DPLt6jhh4K3I19TSxb5GygKxiif
         cgzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R8hvFML+h7aGhio9m3pUmg59NCmoXjdz02/DBxwqSEo=;
        b=l7qhxGJ49+u/NtKOvvGe3fRIEcWzMUtcOTB1slDRHIF13Ofbrzf2/p3OPbPoy2HxF1
         lgZ6hpZ/onac/2BTycBWz+/U2Fj5kMU+2YqnOFAlNqSdXQmGQyNv+kEIe+i8qti5MlKu
         iN9aJrEy3K/PXk/5E/R39xCXnN4xMpNvB2cYQookiemKvtleIlcN/9vYGokqcj6eDe/t
         knKepzzi7GtxobxL9absT/NNtA+wH/IMThzaeIUjK46M6SsqfkuUnmqPZWjnsYrEUGMq
         dY3gZ3BQsSCktyobQzUpuCnfbJqrhVt2ZIdIE95dztVyFo3I1iIt+wkUJfGyyI5qbKVt
         nIMg==
X-Gm-Message-State: AOAM532PXbvPiteRcZDR3wkSducXOVj2g5XR8JQaY+DIdOHp30uegEX7
        fhICdGxdGJaz2YE54b+gSLwXaeQwrOY=
X-Google-Smtp-Source: ABdhPJw7zClrxL2VsKtaYHhuvk9eJVRZg1IHxIPD2VrX6x37H9oIf9hRJ5HKUAAqq43G9jLaRv5pjg==
X-Received: by 2002:a17:902:eb11:b029:e4:a5c3:4328 with SMTP id l17-20020a170902eb11b02900e4a5c34328mr9278958plb.7.1614956892565;
        Fri, 05 Mar 2021 07:08:12 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:08:11 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 23/41] KVM: PPC: Book3S HV P9: Reduce mftb per guest entry/exit
Date:   Sat,  6 Mar 2021 01:06:20 +1000
Message-Id: <20210305150638.2675513-24-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

mftb is serialising (dispatch next-to-complete) so it is heavy weight
for a mfspr. Avoid reading it multiple times in the entry or exit paths.
A small number of cycles delay to timers is tolerable.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index c1965a9d8d00..6f3e3aed99aa 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3505,12 +3505,13 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 		host_dawrx1 = mfspr(SPRN_DAWRX1);
 	}
 
-	hdec = time_limit - mftb();
+	tb = mftb();
+	hdec = time_limit - tb;
 	if (hdec < 0)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
 
 	if (vc->tb_offset) {
-		u64 new_tb = mftb() + vc->tb_offset;
+		u64 new_tb = tb + vc->tb_offset;
 		mtspr(SPRN_TBU40, new_tb);
 		tb = mftb();
 		if ((tb & 0xffffff) < (new_tb & 0xffffff))
@@ -3703,7 +3704,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (!(vcpu->arch.ctrl & 1))
 		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
 
-	mtspr(SPRN_DEC, vcpu->arch.dec_expires - mftb());
+	mtspr(SPRN_DEC, vcpu->arch.dec_expires - tb);
 
 	if (kvmhv_on_pseries()) {
 		/*
@@ -3837,7 +3838,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
 
-	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - mftb());
+	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - tb);
 	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
 
 	kvmhv_load_host_pmu();
-- 
2.23.0

