Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB1E421370
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236280AbhJDQEK (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235926AbhJDQEJ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:04:09 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47901C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:02:20 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 75so16991460pga.3
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nw+tyfcHLpLdeHB2w2xt0EdeJ3op84k0Tqa/00/sMlA=;
        b=QQQKWRfhFnTxudCfehAR+peIPTn68znqLLiZU86od0c40MStRasZ0h39O6G8dER/3I
         PeYdfrurA3Y02cjC1SvQvuaxzv6gnkUY20vyDyUP5LUDEQm7LzEnXv1oF5psZImZRoii
         m9MMdA5wsXibGb2zQEE2+HWXkHnX0GOTwQw+bfoWP0hgdOSmlPEhfy7JYMw6byWA3QGx
         IJi/NABHQ5r30rDkbVGDq+BqmEwzeV/IedkUCx/Gl64KcfOl1aiRMp6l7wzS96eroBkp
         1GTdqm4UwkjSXkT7tiEeFre9m3RBa2QcQigAD7UIMWF1vz8UhPh1hsZwHDdG4YijNKXX
         DKOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nw+tyfcHLpLdeHB2w2xt0EdeJ3op84k0Tqa/00/sMlA=;
        b=mdfY3pcj3TecZl44LXK42S9ZpoRbwK6oA2tZrMcZyCyV2ltDgLpUcdfCAoYZeojpUI
         nmIZ2m3BghZVW/9ClxwtZ83vy4pEzOow4CuDFOBUhNLJITR4O/hd999KmqP+Oto+F3Nj
         7TCd7zav+ip51jGb4hF/+NGugDt34ZviZfdwjS8p90QlQuVtPBrW0sBof/mFl69zhYbO
         e9uf0eu91D3eqvXON4TKlpQBpoXDLd5Ieez6tk28hYsNMR5CXnKDSVs9sfntItv5Wxke
         1nQEJAKXJfz4BKOnBaMxMpMNwxngVZSN9ZY0z7uPyxStyYunmCP9QNa00ie4nqwbmOXm
         NJdg==
X-Gm-Message-State: AOAM533ugqYCet8hLr41oO5zxHwmTsSVV6PoUqU5i5PIii5tGqV0kdGb
        CxQUJNAEdP+/JRNsT5OBWTm+CGNXEHA=
X-Google-Smtp-Source: ABdhPJyIsfqeG/Mh1wu9pNeXGjllDPl6AWQsRBG0NXuAIklS2i5+g/aAkqsfdqFlERZET/MpBpwKrA==
X-Received: by 2002:a63:e741:: with SMTP id j1mr11594783pgk.86.1633363339405;
        Mon, 04 Oct 2021 09:02:19 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:02:19 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 32/52] KVM: PPC: Book3S HV P9: Implement TM fastpath for guest entry/exit
Date:   Tue,  5 Oct 2021 02:00:29 +1000
Message-Id: <20211004160049.1338837-33-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

If TM is not active, only TM register state needs to be saved and
restored, avoiding several mfmsr/mtmsrd instructions and improving
performance.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index fa080533bd8d..6bef509bccb8 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -287,11 +287,20 @@ bool load_vcpu_state(struct kvm_vcpu *vcpu,
 {
 	bool ret = false;
 
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 	if (cpu_has_feature(CPU_FTR_TM) ||
 	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
-		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
-		ret = true;
+		unsigned long guest_msr = vcpu->arch.shregs.msr;
+		if (MSR_TM_ACTIVE(guest_msr)) {
+			kvmppc_restore_tm_hv(vcpu, guest_msr, true);
+			ret = true;
+		} else {
+			mtspr(SPRN_TEXASR, vcpu->arch.texasr);
+			mtspr(SPRN_TFHAR, vcpu->arch.tfhar);
+			mtspr(SPRN_TFIAR, vcpu->arch.tfiar);
+		}
 	}
+#endif
 
 	load_spr_state(vcpu, host_os_sprs);
 
@@ -315,9 +324,19 @@ void store_vcpu_state(struct kvm_vcpu *vcpu)
 #endif
 	vcpu->arch.vrsave = mfspr(SPRN_VRSAVE);
 
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 	if (cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
-		kvmppc_save_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
+		unsigned long guest_msr = vcpu->arch.shregs.msr;
+		if (MSR_TM_ACTIVE(guest_msr)) {
+			kvmppc_save_tm_hv(vcpu, guest_msr, true);
+		} else {
+			vcpu->arch.texasr = mfspr(SPRN_TEXASR);
+			vcpu->arch.tfhar = mfspr(SPRN_TFHAR);
+			vcpu->arch.tfiar = mfspr(SPRN_TFIAR);
+		}
+	}
+#endif
 }
 EXPORT_SYMBOL_GPL(store_vcpu_state);
 
-- 
2.23.0

