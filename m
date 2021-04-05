Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330B4353AA3
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbhDEBVr (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbhDEBVo (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:21:44 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E1AC0613E6
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:21:36 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id w10so1676810pgh.5
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f+RLgCMRv6O15PdiYr5GNGDONEdfPWC0BUYjL4OnyJc=;
        b=XqqXjBvasFw+mvDlcQ/12Ge0gaQq5Ipff7tNUFiI3mRhX47BqpZrogoLW4VASjLw3j
         tL3M9YM3GURnZw2ivDP3VxuN0HOsRwtSQcY0APA+mrh2Jv292Afv0Y5Xgfz3//5zOlKo
         AYBcAeIzBKO2s8x3cqimf8adjZBB5tB0Zo+Dko78tC0g/wPhgmTfuCQJcmT6NzdnM0Q2
         nSQHn/ZKxKNawFQ4OLk0D5X9CZ63MKrAs+aTIz+x82dufca/xjOo+vBWkkqD9GKktmsj
         0pmi2e8IeXlB7vXQ+FUr/ng6M9whqx3GjWpvgRu3cYYSiR3xGyhd5HuQXzLh+3CeveT+
         1fBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f+RLgCMRv6O15PdiYr5GNGDONEdfPWC0BUYjL4OnyJc=;
        b=PDwL0bY+8LwV2C6UyjrQsS2mTZ3XT9j/7+XE8eazgzX5AczUuA+SkAIFza6Zd7vo47
         9fcBioV3O/n2lkjYUJlRp8iog6rKSTA3ZbKf9ZxukAUKUo6mplBWotqBpW6/NSRnu2b2
         IR9CX5Tps5iluHdoZMAqby/yF9Nu9Uzk0K831LrHRtBVcz9WNfxX3CLRHhCnYpUkNs85
         p0P3KQC8rBwbTQMu6os3Duuo/dgwz3vv0I155/tFeyVYdugpLacRToc2QfxJfTHrZGMC
         xNLUyneGuY6dsmMkwUVDyPdy289maox1nadunWrNsNBH1zn/BweTGdR75Vf5JrRtHIrh
         vjsA==
X-Gm-Message-State: AOAM533ikK2S4Pd8uhCrrsqdYKitxuw7VlfKqJfpb+IPFLA3hmjeNACk
        RMG/jg2yQu2/wTjjgubWZfEp9/Mrv4iYew==
X-Google-Smtp-Source: ABdhPJxhaCnIkBD0fPONlRhruTAvtVBHOrnpyr67ZOIEYp3UTwNJ2MhnxAyUI+9q04Ln6f7WDgKoyQ==
X-Received: by 2002:a65:41c6:: with SMTP id b6mr20794644pgq.7.1617585695980;
        Sun, 04 Apr 2021 18:21:35 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:21:35 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v6 27/48] KVM: PPC: Book3S HV P9: Reduce irq_work vs guest decrementer races
Date:   Mon,  5 Apr 2021 11:19:27 +1000
Message-Id: <20210405011948.675354-28-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

irq_work's use of the DEC SPR is racy with guest<->host switch and guest
entry which flips the DEC interrupt to guest, which could lose a host
work interrupt.

This patch closes one race, and attempts to comment another class of
races.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index f4e5a64457e6..dae59f05ef50 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3761,6 +3761,18 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (!(vcpu->arch.ctrl & 1))
 		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
 
+	/*
+	 * When setting DEC, we must always deal with irq_work_raise via NMI vs
+	 * setting DEC. The problem occurs right as we switch into guest mode
+	 * if a NMI hits and sets pending work and sets DEC, then that will
+	 * apply to the guest and not bring us back to the host.
+	 *
+	 * irq_work_raise could check a flag (or possibly LPCR[HDICE] for
+	 * example) and set HDEC to 1? That wouldn't solve the nested hv
+	 * case which needs to abort the hcall or zero the time limit.
+	 *
+	 * XXX: Another day's problem.
+	 */
 	mtspr(SPRN_DEC, vcpu->arch.dec_expires - tb);
 
 	if (kvmhv_on_pseries()) {
@@ -3897,6 +3909,9 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	next_timer = timer_get_next_tb();
 	mtspr(SPRN_DEC, next_timer - tb);
+	/* We may have raced with new irq work */
+	if (test_irq_work_pending())
+		set_dec(1);
 	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
 
 	kvmhv_load_host_pmu();
-- 
2.23.0

