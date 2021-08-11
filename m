Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B313E9554
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbhHKQDN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhHKQDM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:03:12 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1951C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:48 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id b7so3282505plh.7
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QqPmgr/sGr5j1zDNMnH53gsmq1i0Fa0vOmXvGCg74L4=;
        b=Oga2Xv/cYKmKt+7qubqKM3fMNcJU24OXsL9KjiqLqi0tF9gDQJqkR5UCarU6Ys2Asl
         Yd+RkuDpGdHGrj4WtMGCQ1UjNAeb9KvlFQYybusL0jtuDX1pY+/0Kfp9FOpFV8OjuEjH
         g4njjLDRuvVhPEHu+K/8DqgAze4cTvbZKJ2yYutvIce3+hKlJpCa7SugTq0fGHqUtRHf
         9qU8ypjya/shZM3RMKgwDiLzCKgl98gH/CNd9Qj1O1xYW29Gg06AvCoS9Bghksz7bfHI
         TWA9e9Jn0UOpasAlC530YmDUgNDxxYMDtgThop6GLcy1TUzLoso1yKZD23MijgLiQcwu
         SjJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QqPmgr/sGr5j1zDNMnH53gsmq1i0Fa0vOmXvGCg74L4=;
        b=L/pX0A4iNoEbf5e/aQPiOWDOrGPiIndDzxEO42HT1V4kYtk5Jw4w812YRUjrqTjVAt
         zAbzZK5/vs1ZEimLfqZEfcsTzXNlnNbdwiZe/Ez2qGwSBTyeDlZGCvBzei9BN9ngjspU
         qRx8SROs+E1e2MRgmnMjllYYU7c3O8+78jLjvnu1R4OzLaUw10SIMQcI1bdcOv0aGDQv
         rSDnJNbpLuDc1jN6NmLmOBuOwqY3d1SV1XwqvbpNVe0uy1a4guwq9xDPyyH93RUx4Oky
         n7Fw+9bTuJmZjVqpfj0R2IWYBWX3BGvRtdwFmJL6k7sNAlWkkphuehzMPF3IAEy8Z8X9
         98rA==
X-Gm-Message-State: AOAM533h0eh9xECI3PJYpkEQDDAZSRrMJoGRMr7pQWUhTDwt6LWy8zw2
        n6tU9mY3u5yYL7DETAvM90vwmITe8FA=
X-Google-Smtp-Source: ABdhPJyEilrPW7asJOvFeaFex2/BT3EDl9ATGVLj6BS67i90hGQjqkAIxNbcmDCowWQj7LwcesqaMg==
X-Received: by 2002:a17:90a:db44:: with SMTP id u4mr11278276pjx.180.1628697768491;
        Wed, 11 Aug 2021 09:02:48 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:02:48 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v2 24/60] KVM: PPC: Book3S HV P9: Factor out yield_count increment
Date:   Thu, 12 Aug 2021 02:00:58 +1000
Message-Id: <20210811160134.904987-25-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
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
index 9ff7e3ea70f9..fa12a3efeeb2 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4117,6 +4117,16 @@ static inline bool hcall_is_xics(unsigned long req)
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
@@ -4145,12 +4155,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -4278,12 +4283,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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

