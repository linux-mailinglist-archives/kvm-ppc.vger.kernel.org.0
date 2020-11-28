Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A802C7220
	for <lists+kvm-ppc@lfdr.de>; Sat, 28 Nov 2020 23:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732410AbgK1VuZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 28 Nov 2020 16:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732768AbgK1TDA (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 28 Nov 2020 14:03:00 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A061CC094252
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Nov 2020 23:07:49 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id e23so1149120pgk.12
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Nov 2020 23:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YHTQ2tLy/d04r6IvpEtna9DRjc+d1mk5YsFV97Z4NF0=;
        b=NCdFD4ZmTUdhk0ZrCNBTRE5MiY5aURIjx/nnVALmGV/8lWK+q9UhUgcCoQABWsRZF2
         9bnU5nAP8i9F+xZAartmKa2FgOU3eh+BqIKkkVqvMQxNxjgnVu/vbL7xu8slLPvPLntw
         DqnZwaFj1QErs0GgDb+l/OohfINPtt+QnM2oozJf1yhnSUbZ7Z2tFLkcLYOg1H+NZo1N
         kJcxsc5AZPrAgvP4aiBsf4jw8Au1wjJ2n7/R0bFuLOxZnusCpKpWW6jOHItIsis11uGo
         2ReVfP/LxZrA0v1nJpE6riQ3Mz1tEc0hJA+AIr+5N7nZNPcdYRc09+D36UZ+S3LVqDpi
         V33Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YHTQ2tLy/d04r6IvpEtna9DRjc+d1mk5YsFV97Z4NF0=;
        b=MuBPoF5Xb88Cuab+IZc0Ehey8Ax/ogGoJTxLCcDubqMjKnpQoMONqRDJDTbHfCKZaA
         lcHBV0zVN8Z/caTVexaLrhQNcFmUXY+UADFQTxEaGHoGG/n0r2oUKGyL+4APQtASIR/2
         /YcECU7FhWad3ytUlnPA+ZE7IyNTQDGuYLT9PBqrQjpPJfiy8frCyfuLb5EKwPA531Hj
         uVkNOvC9VeX3twheCzHmef1/trMHseNRWH/acqrnGT6LWQpodlAWJsVulChuum3xZBk+
         qxlbtuZ18UXt+5bROspo6l8AJ/tTez8xdlYRfvPQNBcRn9y96IqfibhLkslVT02b+QCA
         gguw==
X-Gm-Message-State: AOAM532dUj13kDtU1nzrznjtlK4njrNArk+kooFW1vq81b9IX0DCi1eW
        1Nb7UB/iFiWEl212f5SDSOY=
X-Google-Smtp-Source: ABdhPJy62w/d0sevYcY0gWUiJGcx9ttCDDHknzoO+hkfyH8YEcZkBW1JUplHuEWEXItMLS2UKo+9HA==
X-Received: by 2002:a63:1d12:: with SMTP id d18mr9590988pgd.314.1606547269307;
        Fri, 27 Nov 2020 23:07:49 -0800 (PST)
Received: from bobo.ibm.com (193-116-103-132.tpgi.com.au. [193.116.103.132])
        by smtp.gmail.com with ESMTPSA id e31sm9087329pgb.16.2020.11.27.23.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 23:07:48 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org,
        Mahesh Salgaonkar <mahesh@linux.ibm.com>
Subject: [PATCH 4/8] KVM: PPC: Book3S HV: Ratelimit machine check messages coming from guests
Date:   Sat, 28 Nov 2020 17:07:24 +1000
Message-Id: <20201128070728.825934-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201128070728.825934-1-npiggin@gmail.com>
References: <20201128070728.825934-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

A number of machine check exceptions are triggerable by the guest.
Ratelimit these to avoid a guest flooding the host console and logs.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index e3b1839fc251..c94f9595133d 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1328,8 +1328,12 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 		r = RESUME_GUEST;
 		break;
 	case BOOK3S_INTERRUPT_MACHINE_CHECK:
-		/* Print the MCE event to host console. */
-		machine_check_print_event_info(&vcpu->arch.mce_evt, false, true);
+		/*
+		 * Print the MCE event to host console. Ratelimit so the guest
+		 * can't flood the host log.
+		 */
+		if (printk_ratelimit())
+			machine_check_print_event_info(&vcpu->arch.mce_evt,false, true);
 
 		/*
 		 * If the guest can do FWNMI, exit to userspace so it can
@@ -1519,7 +1523,8 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
 		/* Pass the machine check to the L1 guest */
 		r = RESUME_HOST;
 		/* Print the MCE event to host console. */
-		machine_check_print_event_info(&vcpu->arch.mce_evt, false, true);
+		if (printk_ratelimit())
+			machine_check_print_event_info(&vcpu->arch.mce_evt, false, true);
 		break;
 	/*
 	 * We get these next two if the guest accesses a page which it thinks
-- 
2.23.0

