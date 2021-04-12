Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3D435B847
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Apr 2021 03:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236273AbhDLBtu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 11 Apr 2021 21:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236377AbhDLBtr (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 11 Apr 2021 21:49:47 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18D2C061574
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:49:28 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id k8so8181492pgf.4
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SrGG57sCJsQ8pkpP+3mT7sg63D+3Ca06l9D6kjJ6tqw=;
        b=vGp7Me7om9cdFzBdOGxgR7OLxv7BopSYT5hdQT1LGRCoYIbbqpNA3VGdLIt7Dw0FkC
         DJWxCWLmNqzExkIFKOqQDGgYk6CVirQ3fR/a1+UGoek7boS9IRiCtCxITLnQ/ULkzNsb
         /J8vNc3Fvw/5p1cpzhO/wh0zxBoUvPnEafKakczeIQaPprv3zb0ZcpqygIviQ7XDBJtO
         yaLzRoo5tzNnbrQytROss9GyS+tE4i387QxKgFaIrIFRgO6C/E6VBmhRfPdvi8O7Sdqv
         X0+qbLHRWug9oEs1/3hnf8Cz//0AKUysW1vqpiVaOBf0DYlnxRk7gVS/OpDodrexIsUf
         d6Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SrGG57sCJsQ8pkpP+3mT7sg63D+3Ca06l9D6kjJ6tqw=;
        b=a3tsm8I3ku07SDsdCf+Zjqk5T3sYnZsyyoXOJr4nZaAMRwV83mEDfHHWd0GgBXTH6D
         E7EbWsbN1C1eeg4YBMaCvNoxiZc8/CbkLBPCT11qasiA18zWY6yS72dgZX8jMrVxIVJ8
         5ToiBWs5BI2MZcqDrlTIMGl7WyeOdNjdIyzSZ/G1JSR1itaFaOfB6SoBtyq3tg2Qsdc/
         3LiOGbNLEp8ZQGQTWGiPIIzCNPA5gDneD0EYFaVOLXPWAiRspIDvPrPk0o5glpLjN7D+
         k4lUYAtfE8fSfQF91ASGOuNeQLhMkIz9AOzySSWOASsE1TxeKCB6CdnwB48DSr/TfShP
         hp5Q==
X-Gm-Message-State: AOAM532VZhrDqxvbNoj0kkRGKyHeFdSA2CCR71MrUH+Uur1Co8k+vq8H
        hNohkGo8Y3s5ZzjKgwJdQXlQnA4zwI8=
X-Google-Smtp-Source: ABdhPJw3ZMdGiv+pO6hLANfM5DZrtutZPxb6wmVxQnFeXntYKqtXZQN53v9QtdoFZphST5/uIwMcIw==
X-Received: by 2002:a63:1a50:: with SMTP id a16mr25388216pgm.92.1618192168509;
        Sun, 11 Apr 2021 18:49:28 -0700 (PDT)
Received: from bobo.ibm.com (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id m9sm9502345pgt.65.2021.04.11.18.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:49:28 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH v1 12/12] KVM: PPC: Book3S HV: Ensure MSR[HV] is always clear in guest MSR
Date:   Mon, 12 Apr 2021 11:48:45 +1000
Message-Id: <20210412014845.1517916-13-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210412014845.1517916-1-npiggin@gmail.com>
References: <20210412014845.1517916-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Rather than clear the HV bit from the MSR at guest entry, make it clear
that the hypervisor does not allow the guest to set the bit.

The HV clear is kept in guest entry for now, but a future patch will
warn if it is set.

Acked-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_builtin.c | 4 ++--
 arch/powerpc/kvm/book3s_hv_nested.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 41cb03d0bde4..7a0e33a9c980 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -662,8 +662,8 @@ static void kvmppc_end_cede(struct kvm_vcpu *vcpu)
 
 void kvmppc_set_msr_hv(struct kvm_vcpu *vcpu, u64 msr)
 {
-	/* Guest must always run with ME enabled. */
-	msr = msr | MSR_ME;
+	/* Guest must always run with ME enabled, HV disabled. */
+	msr = (msr | MSR_ME) & ~MSR_HV;
 
 	/*
 	 * Check for illegal transactional state bit combination
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index fb03085c902b..60724f674421 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -344,8 +344,8 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	vcpu->arch.nested_vcpu_id = l2_hv.vcpu_token;
 	vcpu->arch.regs = l2_regs;
 
-	/* Guest must always run with ME enabled. */
-	vcpu->arch.shregs.msr = vcpu->arch.regs.msr | MSR_ME;
+	/* Guest must always run with ME enabled, HV disabled. */
+	vcpu->arch.shregs.msr = (vcpu->arch.regs.msr | MSR_ME) & ~MSR_HV;
 
 	sanitise_hv_regs(vcpu, &l2_hv);
 	restore_hv_regs(vcpu, &l2_hv);
-- 
2.23.0

