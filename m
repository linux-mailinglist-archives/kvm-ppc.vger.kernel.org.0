Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CF93D51DE
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhGZDMK (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbhGZDMK (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:12:10 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C18CC061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:38 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id k4-20020a17090a5144b02901731c776526so17814538pjm.4
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ss4SKT1mXpLqh5sHj/o40xs+IZbBpzSCdWo+XRcuK+I=;
        b=TNpHgJIrduC7LKWTgROEqE0OvQNLCPmPxYxafWgzN9+45UdApS0cAvqJDNcA/HyyLD
         2ifIGY7B6lJYPM5k4LxIHgxhofJ7AwIqVwSLJalvx/vY0qkSJfs8zqUTW0glll+/Aw11
         EeVU5XMdHgJAo/EgUSicIoq+ZVBorCMBwt2bNgaROtjzdaVTPA38cIj9KSjRM0THouJy
         CKulW7uyuFe93LSgr+qVvE5xzEWa4Pzuwqkcpu/N29nCy5BwpqlcrZVYh0tWIBCb/Iq3
         aH7fKVh7XSTExSVXwADaVACxYg/6CVvMO+pqrviWqDddGj9qfNJt649oXGy7y9gGodbr
         Mjlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ss4SKT1mXpLqh5sHj/o40xs+IZbBpzSCdWo+XRcuK+I=;
        b=l6NJlCr8A6m/2OHn2Jj0QHctCel3NrL9h0jp5ROt54FXGToKBDBjRWgP100L+1jTlp
         nGf6NeKtunisxXPPP+giQeWe4Ys5u3acoLk+aB15oxrKxMNyZQBlIoha3e6GQrkRYDfX
         bTVY3p3F61xh8Oki9SLNuRJwiokMDiPlKj9D7X+gmzF9IuHGhR3QBtql6HNWlXwLEoDO
         6ThZefxoh6XuiZ5Pi0dd8MR+DqqjRlR5fnJ0Ox0dOq2codlh3XxAdphXV4u/TOFUy9Q8
         830NCh45LajAbB1BokiO4vmbkCOLQ3iSoeCpZLN3PdAJOpwH3tYv5hmjyEtjxHrcE877
         oAvQ==
X-Gm-Message-State: AOAM5308dMkntrttlVCIvkLetrPTkeaNXQS8Uw/bJzadqZy9+KGjotMZ
        D7CjgH7uI59uCyh9qrmMTgiRJt8PaPE=
X-Google-Smtp-Source: ABdhPJz2PWY2wqBl1nbx6nNLUFWaqLoEMHAWftB5D29WCaNQQxV/uu7OTwoucCw4z7znMCz8lH+3PA==
X-Received: by 2002:aa7:93cd:0:b029:328:9d89:a790 with SMTP id y13-20020aa793cd0000b02903289d89a790mr15681898pff.71.1627271557733;
        Sun, 25 Jul 2021 20:52:37 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:52:37 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 49/55] KVM: PPC: Book3S HV P9: Optimise hash guest SLB saving
Date:   Mon, 26 Jul 2021 13:50:30 +1000
Message-Id: <20210726035036.739609-50-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

slbmfee/slbmfev instructions are very expensive, moreso than a regular
mfspr instruction, so minimising them significantly improves hash guest
exit performance. The slbmfev is only required if slbmfee found a valid
SLB entry.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 1287dac918a0..338873f90c72 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -477,10 +477,22 @@ static void __accumulate_time(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator
 #define accumulate_time(vcpu, next) do {} while (0)
 #endif
 
-static inline void mfslb(unsigned int idx, u64 *slbee, u64 *slbev)
+static inline u64 mfslbv(unsigned int idx)
 {
-	asm volatile("slbmfev  %0,%1" : "=r" (*slbev) : "r" (idx));
-	asm volatile("slbmfee  %0,%1" : "=r" (*slbee) : "r" (idx));
+	u64 slbev;
+
+	asm volatile("slbmfev  %0,%1" : "=r" (slbev) : "r" (idx));
+
+	return slbev;
+}
+
+static inline u64 mfslbe(unsigned int idx)
+{
+	u64 slbee;
+
+	asm volatile("slbmfee  %0,%1" : "=r" (slbee) : "r" (idx));
+
+	return slbee;
 }
 
 static inline void mtslb(u64 slbee, u64 slbev)
@@ -610,8 +622,10 @@ static void save_clear_guest_mmu(struct kvm *kvm, struct kvm_vcpu *vcpu)
 		 */
 		for (i = 0; i < vcpu->arch.slb_nr; i++) {
 			u64 slbee, slbev;
-			mfslb(i, &slbee, &slbev);
+
+			slbee = mfslbe(i);
 			if (slbee & SLB_ESID_V) {
+				slbev = mfslbv(i);
 				vcpu->arch.slb[nr].orige = slbee | i;
 				vcpu->arch.slb[nr].origv = slbev;
 				nr++;
-- 
2.23.0

