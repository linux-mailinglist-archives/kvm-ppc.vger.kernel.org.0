Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CB83250DB
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhBYNtY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:49:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhBYNtO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:49:14 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE1DC06178C
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:33 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id o22so5064690pjs.1
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z1msQbx0Hbt6eMglomvgJz+el+SEDc6l3SYc2zTEVxU=;
        b=s/3/KaxDPHyERPd/FnBJhlvLUnkzX9y1IsZx0j3QaTcL/Gipm0lPbo8XGLZvDRSftk
         hBlGclraQunoazuEo+vX574p2QYOejng4GO1m/lIeZQxSVJ1xNHpuLaj2IYY5l4A43JM
         02KT3G4q3jFJTj/YQ1HoGkesgqqDKw/IC6A5VCiJfRT8fbkwOQN6PpQnYhFXDDn/AcuS
         ZN8H7/WEIFJvmeTAumrTGRJeiLilgigsFAZkXaEUR80YIk9fI79TC6vc3Vhs1Z7YEm2R
         dj5MQ9cZ81OZEECp/nklW5t5o4x3MOhDtCV78/bNYfYPF8L6ItybhStJ2rRbW7KEvEG2
         UPFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z1msQbx0Hbt6eMglomvgJz+el+SEDc6l3SYc2zTEVxU=;
        b=gSW2ufTtpU6M1qPicqiUCCWDN3m+Yxq/yUT3SL6sb+Gvm1B/5YfWa19IBKY8YiJ/X0
         uJMdvXsPfvIN0g4j1Sc/kvVDMrdR9qJZjkBrtk6qniQHjha7Ii1VBQfBAgijVcO9/KDz
         rg1zY5HVQBgfYM4F/ek843Be3zA4b5yEBVycJM7BaWs9JFJnAivmGn2MYQmoT4SLd0Wx
         CzzR9gpoYxZx0IGorFdBwYOLPRKZtAalclvCH3AsMC2XRxRS0qWbljjb5hOhwuUBnGfR
         5A3uXQjpED6CnYPcWpptWnTqdg7bBLP6bHWcFmhAkfOuh1c6brxqIJ5Fi5bjGRcXc5jP
         7d6w==
X-Gm-Message-State: AOAM532gn3/QqHUr5SVLru6gOh8ctAvzFlBo163RyjpPsLfPSdZxx7dt
        deMLIMau/Q86sQh1hXm1qbQEwAIA8PU=
X-Google-Smtp-Source: ABdhPJwHr4Jo55/pa7u26cgrj7FDeHBSv5PrK2PSvYxQlz7IUuv26xNR9pMVXf3fZ7hr1Iwpv+dYsg==
X-Received: by 2002:a17:90b:1290:: with SMTP id fw16mr3374278pjb.99.1614260912722;
        Thu, 25 Feb 2021 05:48:32 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:48:32 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 26/37] KVM: PPC: Book3S HV P9: Improve exit timing accounting coverage
Date:   Thu, 25 Feb 2021 23:46:41 +1000
Message-Id: <20210225134652.2127648-27-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The C conversion caused exit timing to become a bit cramped. Expand it
to cover more of the entry and exit code.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_interrupt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/book3s_hv_interrupt.c
index f5fef7398e37..4a158c8fc0bc 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -148,6 +148,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	if (hdec < 0)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
 
+	start_timing(vcpu, &vcpu->arch.rm_entry);
+
 	if (vc->tb_offset) {
 		u64 new_tb = tb + vc->tb_offset;
 		mtspr(SPRN_TBU40, new_tb);
@@ -198,8 +200,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	 */
 	mtspr(SPRN_HDEC, hdec);
 
-	start_timing(vcpu, &vcpu->arch.rm_entry);
-
 	vcpu->arch.ceded = 0;
 
 	WARN_ON_ONCE(vcpu->arch.shregs.msr & MSR_HV);
@@ -334,8 +334,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	accumulate_time(vcpu, &vcpu->arch.rm_exit);
 
-	end_timing(vcpu);
-
 	/* Advance host PURR/SPURR by the amount used by guest */
 	purr = mfspr(SPRN_PURR);
 	spurr = mfspr(SPRN_SPURR);
@@ -400,6 +398,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	switch_mmu_to_host_radix(kvm, host_pidr);
 
+	end_timing(vcpu);
+
 	return trap;
 }
 EXPORT_SYMBOL_GPL(kvmhv_vcpu_entry_p9);
-- 
2.23.0

