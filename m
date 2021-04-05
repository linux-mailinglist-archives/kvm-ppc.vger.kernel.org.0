Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964C9353AA2
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhDEBVp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbhDEBVk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:21:40 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77114C061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:21:33 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y2so4928828plg.5
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UTdFrL60rN3R2a4gJO4rGMS50+4Qry4ThLyQTVbs3+w=;
        b=tSmSaEhmk9tUFLcu1b7wpbjcIvl6TNiIA+rpbb9nvW7B9ScMmNz07Ey/y8XAsmiNw1
         G7YKBEtHvp0pZ4b3F/xxk+Xk4E3di2GhxWEhcQg8gPQzdT2HhlMmdK8REEr48UHfbZAW
         0ciO2fcd1J6cVtkMm9fde2IGaMfhyIJH7UjBlCNcQhbdiY49BX2LIIlGfY1e7eGEuSSN
         4tdkYuQzzsGadDF+7nBm/TzqGOLa7Tof31Jmu4llRWEkritWt8cnIOmrMsAwUE01WhHd
         G/Imu4r0SZyiDJ8+X1hgwY1eRXEgTksVs82drRyx6LtkY8u/zIyYg1HnRtoALHbB6Xe+
         3suA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UTdFrL60rN3R2a4gJO4rGMS50+4Qry4ThLyQTVbs3+w=;
        b=cTs2qaLSvyd+yQPnuBAdb7I7lrYu0yOKuFXjXYDkV+zq+nQgCEvZp7iMUYr8FFwC1q
         87TbLmwjdCVEw8g0DiKT5IIree/aXBU2EJM+0m6kVRCkUCwNE9KUrbY8NR3UyRH7V8IR
         yqHwoBao9tdyJzVOlizaQtZ/saiJ/+6zSNZBO/QCongTlUvnYGAzXRjM/aGP2ER+g+bw
         Yl6fVJ4jXZEvtETjheJjQ29ncNyQ9XxhcqMhiFs4W7DVHpiIgr/aoYG8p7RpQ2/ta6qJ
         Hc0tdJycJTV/tS/4IElexSDGsRXzTY3SMhCFPGSi/hdXEpVGhmYpaGyKWH0TNcVfBb6y
         h7jg==
X-Gm-Message-State: AOAM531tgQfi2s8aqnH8in+19V0frsReMnppWsOEn7uTb4jnVllVClqV
        a5yabwN/kx+dvl5Vd2ayOfe5MJZ493lwjQ==
X-Google-Smtp-Source: ABdhPJzt4Nw7omWht0GkfIRhyfsUb8mGIt3gtOEO5he5gZ3Pvyl5AH54D5QTOU0D0ZDar/Lg6ND29A==
X-Received: by 2002:a17:90a:5d14:: with SMTP id s20mr24457309pji.6.1617585692953;
        Sun, 04 Apr 2021 18:21:32 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:21:32 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v6 26/48] KVM: PPC: Book3S HV P9: Reduce mftb per guest entry/exit
Date:   Mon,  5 Apr 2021 11:19:26 +1000
Message-Id: <20210405011948.675354-27-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

mftb is serialising (dispatch next-to-complete) so it is heavy weight
for a mfspr. Avoid reading it multiple times in the entry or exit paths.
A small number of cycles delay to timers is tolerable.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 5c4ccebce682..f4e5a64457e6 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3557,12 +3557,13 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -3760,7 +3761,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (!(vcpu->arch.ctrl & 1))
 		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
 
-	mtspr(SPRN_DEC, vcpu->arch.dec_expires - mftb());
+	mtspr(SPRN_DEC, vcpu->arch.dec_expires - tb);
 
 	if (kvmhv_on_pseries()) {
 		/*
@@ -3895,7 +3896,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->in_guest = 0;
 
 	next_timer = timer_get_next_tb();
-	mtspr(SPRN_DEC, next_timer - mftb());
+	mtspr(SPRN_DEC, next_timer - tb);
 	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
 
 	kvmhv_load_host_pmu();
-- 
2.23.0

