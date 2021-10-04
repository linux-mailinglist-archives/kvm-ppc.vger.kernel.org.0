Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D883B42135C
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236242AbhJDQDc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236129AbhJDQDa (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:03:30 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2EBC061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:01:41 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 75so16989511pga.3
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DFMn8lvRPRNRmYA8rM8dLrBYTRNSq64OxGEvfMyovHo=;
        b=p2/urn5rzExbS67HM4XpjZhOqytqq3R9uNF5LhYfxjg9s2C5kGrXIOHbSTJnEyF8TJ
         N9qFZ1qNpP48uE/6UZijGyoIyKBi62ju4f+MyWaw4rxOZYLtZJqlU+DPYQzotm+zdQnG
         eKZhtr/jGmkviquHoZUG0pr4RlsMyV7euLIIRRc5Xub1Hc3l87eBujVvCCc+zvC75JKa
         lL4ffj5tuRZ7XNSajAx8uSU50CBzlU8g8M38oT2ytiK9DTJM84vHf7/ZcGBLtUZEmVED
         xsqy7eWyiyVtRSy7LV+L1TVAtOgqVUmabpzLlucar/bspU2PAyAbP0xXK/9jVfaJ5xcM
         BbIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DFMn8lvRPRNRmYA8rM8dLrBYTRNSq64OxGEvfMyovHo=;
        b=pHF4PU3Mym8jYKNbU2rlGOoFqFd7pqxoqIOckUGYj3unSTMSqAgxesQcX53JnHWcte
         TJMS3eWWuM7+fREYiNTPHaVjKljImvE4XOoKI879GeVwVzz85oZsWzdxa346jEQ3gYQS
         iss4tnlAj2jvpKOnlVKMumcYn1GIXqZNrdLNFwmyjsD4jTYhHCUCDy3ZR2+XYROW84k1
         wuidifaZ9c+akMoRbZB0KRNcUrTuDhQKmi8n9Udiughgje5Jd+VZfuxwuSoN30eSmfNh
         mFigbA8qCjQHhDxwN7u20QDMfeYCsLoi3r53Ltt3bsiP0Z5IiOsHzALWfQNgLhO6N9x0
         9vRA==
X-Gm-Message-State: AOAM532s/B//Vez3k4i7L4fSOAhdRaQQ7b3Nq9wjrSQkYBCb7jxYt7XU
        9UgchFqxgUeJZUOH8/FpxKr8UISGJ+Y=
X-Google-Smtp-Source: ABdhPJz7235PlBwZMUX3vYxKnU/kU7PPk5wr8vpAcHfgGeteQsFyXpMYRgn032dUqomdMr9D++w2KQ==
X-Received: by 2002:a63:af4a:: with SMTP id s10mr11525585pgo.469.1633363301244;
        Mon, 04 Oct 2021 09:01:41 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:01:41 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v3 16/52] KVM: PPC: Book3S HV P9: Factor out yield_count increment
Date:   Tue,  5 Oct 2021 02:00:13 +1000
Message-Id: <20211004160049.1338837-17-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Factor duplicated code into a helper function.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 6bbd670658b9..f0ad3fb2eabd 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4118,6 +4118,16 @@ static inline bool hcall_is_xics(unsigned long req)
 		req == H_IPOLL || req == H_XIRR || req == H_XIRR_X;
 }
 
+static void vcpu_vpa_increment_dispatch(struct kvm_vcpu *vcpu)
+{
+	struct lppaca *lp = vcpu->arch.vpa.pinned_addr;
+	if (lp) {
+		u32 yield_count = be32_to_cpu(lp->yield_count) + 1;
+		lp->yield_count = cpu_to_be32(yield_count);
+		vcpu->arch.vpa.dirty = 1;
+	}
+}
+
 /*
  * Guest entry for POWER9 and later CPUs.
  */
@@ -4146,12 +4156,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->entry_exit_map = 1;
 	vc->in_guest = 1;
 
-	if (vcpu->arch.vpa.pinned_addr) {
-		struct lppaca *lp = vcpu->arch.vpa.pinned_addr;
-		u32 yield_count = be32_to_cpu(lp->yield_count) + 1;
-		lp->yield_count = cpu_to_be32(yield_count);
-		vcpu->arch.vpa.dirty = 1;
-	}
+	vcpu_vpa_increment_dispatch(vcpu);
 
 	if (cpu_has_feature(CPU_FTR_TM) ||
 	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
@@ -4279,12 +4284,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
 		kvmppc_save_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
 
-	if (vcpu->arch.vpa.pinned_addr) {
-		struct lppaca *lp = vcpu->arch.vpa.pinned_addr;
-		u32 yield_count = be32_to_cpu(lp->yield_count) + 1;
-		lp->yield_count = cpu_to_be32(yield_count);
-		vcpu->arch.vpa.dirty = 1;
-	}
+	vcpu_vpa_increment_dispatch(vcpu);
 
 	switch_pmu_to_host(vcpu, &host_os_sprs);
 
-- 
2.23.0

