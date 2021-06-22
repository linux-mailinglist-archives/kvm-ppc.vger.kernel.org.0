Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94EA13B0221
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhFVLB5 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhFVLB4 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:01:56 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217D8C061756
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:40 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id u190so12926545pgd.8
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DsgwPnyTUdZa/AjF9rolFYob05oJxOKI9sd1Aj7QIvU=;
        b=ucZqRXDFh94YgWql53590Q3D8VYn+GfCLaFLyfmEV/pP6B4GTcK3tHBtN8YOvG/UzT
         ynJXuf7oZzwUA3gkpncYJZVl6vs1bCZsBft8oTvxYORveU5rkkJ42MBznDYstWCtO11i
         V2NdYExIWgcTWPaUKsCALKuV9vJlQ5XI0wsNMNrvbTM9CPfLErZQnSt/4zG1J39nhgkE
         gaanD15Um/cCohGx/ujb2OJQVLygwybI9XDBWo8gO+IgTZF4MO5567wLdtTf2H+FyQZg
         qmVFviWNuJJDYftUI9fNLKVBGG8poc+mC9zHHLLDORuNMQlbAcPRje0NKrUbe6217IQF
         0ogQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DsgwPnyTUdZa/AjF9rolFYob05oJxOKI9sd1Aj7QIvU=;
        b=MNYVaRXwUW7nndORM6/yNC0ZLifHq8Jw7vXUaVzZyygBz62NT4jlTu61nAH5/O1R77
         DxNbQS/d9d3XHH/vjaKHXQdgW+D0DyDJJxY6rq1MDoTAxAg5xkv5qemFeh0Lkpyt01bq
         b/zn7IA3vUg5oyOkX+wDubzOv8TUZDApcgQH+9vmod3SSqlqUqhIxfvGF9Av71cfvJJM
         xMeFknRdYq/tulz7nufStFfA5VlXUwKL+LHWOvwRLXF9hgFQG8E7n+VPCSaPr0aLmLdr
         oJU6iuw0G9E8gXnyjgNVTs3kElCIcNEc60F54z78GeR+0A/7n4oun/jVUVBNkXmtI3s2
         eq6A==
X-Gm-Message-State: AOAM531SoYmLZxxPmy1IQzOulAd/xsWphdZH3x0KkZRyIxSXb1ZepzKv
        hQArmWitNoQAeEtyP8iuqYPUR3qvvDU=
X-Google-Smtp-Source: ABdhPJwt2bqZQu7WX7dsPof+cuDJrpVVgvI/q3zgbiyq8PMYIVs6AhCdF/59Mgz7LoEmAp52obMLFg==
X-Received: by 2002:aa7:8806:0:b029:302:f067:7b52 with SMTP id c6-20020aa788060000b0290302f0677b52mr3131946pfo.13.1624359579612;
        Tue, 22 Jun 2021 03:59:39 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:59:39 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 43/43] KVM: PPC: Book3S HV P9: Optimise hash guest SLB saving
Date:   Tue, 22 Jun 2021 20:57:36 +1000
Message-Id: <20210622105736.633352-44-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
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
index 3fffcec67ff8..5e9e9f809297 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -459,10 +459,22 @@ static void __accumulate_time(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator
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
@@ -592,8 +604,10 @@ static void save_clear_guest_mmu(struct kvm *kvm, struct kvm_vcpu *vcpu)
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

