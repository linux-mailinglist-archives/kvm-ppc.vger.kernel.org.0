Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DE43D51D9
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhGZDL7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbhGZDL6 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:11:58 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA14C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:27 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id e21so5528375pla.5
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HLk6HQ2z18NVVIxNvv7ggfI6nteda2G9xIwBhEx3DRA=;
        b=jY1YdaiW8IgRfdLESK4f4q/4PvLd8YOSNM0z4I5+GnB93BrdspXXkM38MaNV8dmbv1
         43HOOjeCqympcBUjz0ZjAmh5Q26NrTeRX86qRWBDaSLoMV5ua14a1rTawJ59XyWFS7Xf
         OoQmJfjekfKWvwkN9cLC9LVD8LnFdlxftawKU11q/0xPFsSfa74tAiM7bZTcsPOs6KZQ
         G1nZlfDIU0AkPbEdD4G/aZd0n0SIGb8UkdvXfO2ECSu49dRNsLa8rzWlsBuuyzc7gWsw
         S8hvwkvJ2sCOu3zZZxLSJh39I5PyJUUHBcGIk31mU+IeyFD+yuzxaURZ0E4z4KbhceU+
         p92Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HLk6HQ2z18NVVIxNvv7ggfI6nteda2G9xIwBhEx3DRA=;
        b=rbYGS/0upOz7a2TiVagzF3ecxK51cBzr4wFIHnwheKHRXNLJxkXbgBE0Yr2BBPS/xC
         JZKY8SuibH0rHXA8kovYbJAPmBrDcFCmUSfGQ6QD3DlDHR3D9gcB+NoMMU2r6fFxefcn
         aeKayq3LUaDoX7pk1UAc9F2uuWVm1LCka3KAKkvcSCxH2wXhqzc02yJeRSEc7tpMjoLX
         DnOmF7I4VFGvn/Aw8dk9yiTip5p0nE9jSWAiGpL4l06YF2XQcjBZe5CEGVX4Ikt8NiUW
         nffXu4OszqRi7FajHbTUgC0MNFCEgmFf9YRSxw+m4WB4/Mb34bj13VbZLcgUrV5zsNBO
         vnvg==
X-Gm-Message-State: AOAM533OkZbuhK7++zWEyf7PR7gACL2AIB5iDTkrDHnEz8yTtoxCI6tO
        5OvE898cnquQWUXTnBpyHAepjyZk4Gw=
X-Google-Smtp-Source: ABdhPJy5Iq0w/nkquumaKPmXNbJJpEX0ODTDzd4tC7tGfKeCS5HCEBavwGpVltJ+qGXCpsT58KKsbQ==
X-Received: by 2002:a63:1f5c:: with SMTP id q28mr16263015pgm.114.1627271546679;
        Sun, 25 Jul 2021 20:52:26 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:52:26 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 44/55] KVM: PPC: Book3S HV P9: Test dawr_enabled() before saving host DAWR SPRs
Date:   Mon, 26 Jul 2021 13:50:25 +1000
Message-Id: <20210726035036.739609-45-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Some of the DAWR SPR access is already predicated on dawr_enabled(),
apply this to the remainder of the accesses.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 34 ++++++++++++++++-----------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 0aad2bf29d6e..976687c3709a 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -656,13 +656,16 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	host_hfscr = mfspr(SPRN_HFSCR);
 	host_ciabr = mfspr(SPRN_CIABR);
-	host_dawr0 = mfspr(SPRN_DAWR0);
-	host_dawrx0 = mfspr(SPRN_DAWRX0);
 	host_psscr = mfspr(SPRN_PSSCR);
 	host_pidr = mfspr(SPRN_PID);
-	if (cpu_has_feature(CPU_FTR_DAWR1)) {
-		host_dawr1 = mfspr(SPRN_DAWR1);
-		host_dawrx1 = mfspr(SPRN_DAWRX1);
+
+	if (dawr_enabled()) {
+		host_dawr0 = mfspr(SPRN_DAWR0);
+		host_dawrx0 = mfspr(SPRN_DAWRX0);
+		if (cpu_has_feature(CPU_FTR_DAWR1)) {
+			host_dawr1 = mfspr(SPRN_DAWR1);
+			host_dawrx1 = mfspr(SPRN_DAWRX1);
+		}
 	}
 
 	local_paca->kvm_hstate.host_purr = mfspr(SPRN_PURR);
@@ -996,15 +999,18 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	mtspr(SPRN_HFSCR, host_hfscr);
 	if (vcpu->arch.ciabr != host_ciabr)
 		mtspr(SPRN_CIABR, host_ciabr);
-	if (vcpu->arch.dawr0 != host_dawr0)
-		mtspr(SPRN_DAWR0, host_dawr0);
-	if (vcpu->arch.dawrx0 != host_dawrx0)
-		mtspr(SPRN_DAWRX0, host_dawrx0);
-	if (cpu_has_feature(CPU_FTR_DAWR1)) {
-		if (vcpu->arch.dawr1 != host_dawr1)
-			mtspr(SPRN_DAWR1, host_dawr1);
-		if (vcpu->arch.dawrx1 != host_dawrx1)
-			mtspr(SPRN_DAWRX1, host_dawrx1);
+
+	if (dawr_enabled()) {
+		if (vcpu->arch.dawr0 != host_dawr0)
+			mtspr(SPRN_DAWR0, host_dawr0);
+		if (vcpu->arch.dawrx0 != host_dawrx0)
+			mtspr(SPRN_DAWRX0, host_dawrx0);
+		if (cpu_has_feature(CPU_FTR_DAWR1)) {
+			if (vcpu->arch.dawr1 != host_dawr1)
+				mtspr(SPRN_DAWR1, host_dawr1);
+			if (vcpu->arch.dawrx1 != host_dawrx1)
+				mtspr(SPRN_DAWRX1, host_dawrx1);
+		}
 	}
 
 	if (vc->dpdes)
-- 
2.23.0

