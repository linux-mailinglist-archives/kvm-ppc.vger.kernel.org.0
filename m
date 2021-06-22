Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9EC3B01FC
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbhFVLAm (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhFVLAm (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:00:42 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815DAC061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:26 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id i4so6539835plt.12
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XeckW1SELkzqZtdQyYlPpbgjiGzhPPr2SL3SVbOXvdk=;
        b=bWtxCbT8rwIKOB7gt8CU2C3NrB1/QC3aINzcoW5cjrqo7mUgwrwIPxMmCvVuA0w4cf
         5HUQDQm2TIgwLRsEQdIK8H2b9r6kI1PCQwWhfTYuWSKypIqsiUqOsKHZZrLPdXsveSum
         w/8SoU5j8Ynh6dl6vAqmAsv98bpbAxBd5UyyEmmQSCxZdOhCIJGY0xllAtXdBukn5afc
         DiGKmuY93/CuB1JKJW1UGT/hskEpibhxE/5nt2l0GH/iKGqIHF7aWhQ+NlL91ycfh4Fb
         zWLIV/OqAJ3YDAicke+KcgrDZiqGoZZIMqnPtFuyA59hT//0T6xHINmkwdlPZb97udA3
         Z4GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XeckW1SELkzqZtdQyYlPpbgjiGzhPPr2SL3SVbOXvdk=;
        b=XCGXHQL8zPSl6oRWLi+muLMtInjLc6SItt5xRcns5OtC+TO9Hrjsqnwely3qTF70/r
         G207dy/1XgF/2Q+eXmOk/ROnvCmYfu2fTRhQ/AcLGh8PCWwnFS5+O3tDmdYT8ezCeWnw
         LMlC7Gga0TSvWhl0+uu4L+/Ootqi9BHxQ4mHbNgor4CUWvveGuna2fo9pRnHN/MqqZL4
         xbgIMNy+Leq+O1lzmNbOQHfQtiKbjv/U5PMKyCY5qaRsx8ity/BcsYMhFFpZkJFIFuxb
         rrm/6aSsGm5MYnjhOAAFRs8iz0oGuZIoElwOFthcjKXR9qLLNw66mjhpPvkTc+IL3YTf
         dAJg==
X-Gm-Message-State: AOAM530+00lBZ/4zn2LDzdXIgDsHMD0SE3ferEkPvugfjkqbjelymMYt
        r2BLEeUJcbsR1g7g91t1BfUl7qnRIOU=
X-Google-Smtp-Source: ABdhPJwrvayOCZ/rKcVBT7/kWwv/S4SY4OZnIWwvy5U1sMYsfU0+O9b+jLN7128qkA2N515M/xCEdQ==
X-Received: by 2002:a17:902:c641:b029:122:6927:6e50 with SMTP id s1-20020a170902c641b029012269276e50mr10457543pls.6.1624359505798;
        Tue, 22 Jun 2021 03:58:25 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:58:25 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 12/43] KVM: PPC: Book3S HV P9: Factor out yield_count increment
Date:   Tue, 22 Jun 2021 20:57:05 +1000
Message-Id: <20210622105736.633352-13-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Factor duplicated code into a helper function.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index b1b94b3563b7..38d8afa16839 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3896,6 +3896,16 @@ static inline bool hcall_is_xics(unsigned long req)
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
@@ -3926,12 +3936,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -4069,12 +4074,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
 		kvmppc_save_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
 
-	if (vcpu->arch.vpa.pinned_addr) {
-		struct lppaca *lp = vcpu->arch.vpa.pinned_addr;
-		u32 yield_count = be32_to_cpu(lp->yield_count) + 1;
-		lp->yield_count = cpu_to_be32(yield_count);
-		vcpu->arch.vpa.dirty = 1;
-	}
+	vcpu_vpa_increment_dispatch(vcpu);
 
 	save_p9_guest_pmu(vcpu);
 #ifdef CONFIG_PPC_PSERIES
-- 
2.23.0

