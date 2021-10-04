Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C365421383
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236335AbhJDQEj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234465AbhJDQEi (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:04:38 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A30C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:02:49 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so293855pjb.3
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EPQZDhgPqi5g0CfouGHl1rvGEVKlv1XdekS1P2LkqM4=;
        b=jGT2p6ldMXThpfkhQJu2ytHRGELk/8SfvLk0Prd5doutrh1lOyv8tPlyn/VzDmrg4R
         VR7ZqyI/ECY/46f1BvRPyfK8D3Ozx68r1ikoW5krfQMGhDruugUfFMqGcjBtfUtNtnbM
         1ffrST3fiot3MZt7nw/n3/DY7Ni1z7lQoRJLzrO3C5K627JOO1wytUOnJNYsNov8IRJz
         QUartURyW0NwLMPrQC6MaP3jbTwux2IZowTcF+6i4GRMFked9KIU3v8IuB20VPjnNwlX
         yp/yjgdZ+yYi0ruAqO9fdlpOzQ6xl9Bn2wTT90Pbf4DcCWumwn5inhcFC8m+SyCAZYG4
         /tIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EPQZDhgPqi5g0CfouGHl1rvGEVKlv1XdekS1P2LkqM4=;
        b=caXt0cG7k1tZrN9kONxQk7bjBGOhbrauRxb123o+z9ZkQXFkaNSJqp7+1kGB942NwM
         UDO8LS7kLbA+D1sOWa+SPMs2e1bZsim4rtZ80oYrXTYpcViKdj9ReQHT+2EGl3tlFRDN
         VjZQy/9uqYAsynQhDoXy0+VvuMht3QuwU3S5M/MZIJnx5qzR3hMuiLFr1/uMGrNXNs6Y
         ekA3Mz6pFfzJAGzDFmdQlq3QC55ueHfEy/FeU7VPEc7896nFqoI2CgyVUJkfQSJJtiKd
         Pfmo6Q5Srbc3cX8SZSCxgd9MlPnfM1+LKO++OCMY/jDktgBcTahbNJaoQWugX6TFx0jO
         Lm7A==
X-Gm-Message-State: AOAM530QoPlfcdez1s9HhQufldiK6d65Ox0ZnuhyQO1itLZNM5tf1rA/
        s8rmZIOFNo0uZmuIz/mMy+btRl+Qxwk=
X-Google-Smtp-Source: ABdhPJyKmvYE4L++eCYVyA+2RJsqZeQTlLo+rudyoP6QA7smhpqFh7ozmGlrFA6ads/+gv+RXkon7A==
X-Received: by 2002:a17:90a:df8a:: with SMTP id p10mr4053591pjv.137.1633363369138;
        Mon, 04 Oct 2021 09:02:49 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:02:48 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 45/52] KVM: PPC: Book3S HV P9: Optimise hash guest SLB saving
Date:   Tue,  5 Oct 2021 02:00:42 +1000
Message-Id: <20211004160049.1338837-46-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
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
index 646f487ebf97..99ce5805ea28 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -487,10 +487,22 @@ static void __accumulate_time(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator
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
@@ -620,8 +632,10 @@ static void save_clear_guest_mmu(struct kvm *kvm, struct kvm_vcpu *vcpu)
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

