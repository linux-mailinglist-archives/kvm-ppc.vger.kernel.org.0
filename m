Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D103A32EDDE
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhCEPIq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhCEPIh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:08:37 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FC3C061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:08:36 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id a4so1564344pgc.11
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9mGOdjU30m0E6b/XzBmpf0ONvoTvN0BDP7Tm5+1bmtw=;
        b=K6pvWBfcw+XONrUyGb1h6XRowG9L0oy7eoJxSWs8qcI9gctB4aKIDjezhaVYPe4xR1
         ORTJImycW4l3+Lt+Nw9sT1dVeyXkexbfUfLrApnp7t9FU2i2gbL9a7I+kkjnzaglk9+g
         3ZBzeb8a2kHVL0aTY2U911u+dcsE31BkP3TpmO9pWrAhYUZLxTWbJGLykJpYHQkmSpAD
         kOisme458gyHASZ2mT1q/6DaaNsWYg/L+dcuA/OHQqElXupflUGkIRUqGgOXlkmKiMOu
         KBE26BejFipFAOeRFzn55Cqw51QClzsn3mG8tPU637ziW6BbISfBgFWLfBr/USqq6if7
         lD3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9mGOdjU30m0E6b/XzBmpf0ONvoTvN0BDP7Tm5+1bmtw=;
        b=Y6kAUXTl3Z2G16BC9ik2JXMhCoiWo2sRK3YetHwseupAGiq3mzb7ynTLSKC/rwAJZJ
         WMx+4xPry3vFkOaVlVFvT2vHJT5NMExhHEUQi8xI+WDCQq4glBBeJsscV2GP8eFU93fp
         nEQhnWjGBR0DEr1nYhsfDvsJRm20StkJxkn4CjPDyqLWK7xdrCFMmjcKgOwcBxOuyPcI
         9dvZREUq/XqVf0zWs0eSQMhVVmtlbV8gT+kD+bdaLBVjlkNkAUqfo5y57NgQ5evbcoT4
         aCbRlj7wwT880J39uQDiNAXBLOIchRPPhBQZar2kMf/07yQBNbmntVx0ZzMlqQcayNIZ
         czww==
X-Gm-Message-State: AOAM532YlCJRGl8Ma2juCQbjJ0wrAXWXp57SbLv2cp3GkAg0pMBJWFiR
        D3As7XLbrQrOBG3sE6enUcDK9vHhMUM=
X-Google-Smtp-Source: ABdhPJy/8rUerfCRqWSrS0HFBWouOkMz3OXqSQI1uxhqs1VwZO4OdAluEl85YmzWszaVjp+C+1tm4w==
X-Received: by 2002:a63:4658:: with SMTP id v24mr9008126pgk.258.1614956916157;
        Fri, 05 Mar 2021 07:08:36 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:08:35 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 29/41] KVM: PPC: Book3S HV P9: Improve exit timing accounting coverage
Date:   Sat,  6 Mar 2021 01:06:26 +1000
Message-Id: <20210305150638.2675513-30-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
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
index 145c634625f8..68514ab5a438 100644
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
@@ -343,8 +343,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	accumulate_time(vcpu, &vcpu->arch.rm_exit);
 
-	end_timing(vcpu);
-
 	/* Advance host PURR/SPURR by the amount used by guest */
 	purr = mfspr(SPRN_PURR);
 	spurr = mfspr(SPRN_SPURR);
@@ -409,6 +407,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	switch_mmu_to_host_radix(kvm, host_pidr);
 
+	end_timing(vcpu);
+
 	return trap;
 }
 EXPORT_SYMBOL_GPL(kvmhv_vcpu_entry_p9);
-- 
2.23.0

