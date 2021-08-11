Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6753E9574
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbhHKQE0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233589AbhHKQE0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:04:26 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D89C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:04:02 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id oa17so4230230pjb.1
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tuny/0eGXiUI7uo2gVucclOBaSeF7WVbv1eeHSQKFaE=;
        b=OZaXx3cUvijxkwm0x1eN2JTWJWgtsEwynt9e6yW/0x1n+/J7npACl0cjOAhtGMMY2D
         jO9aVROyUQIK/xurGp7CDQ6HuaFzIw3qKn0DjI+5a2psfC3kMCAmLfPKcXe4xcUb89sP
         iE/rLcnZvQ6w+Gs9xFOCZGDGGHfXHVIML9eZMJi2NcoR+yQuk9WX4548JZ+nl3FyKRuB
         J+G1e01iLqS6USBfWB1F2064lPFWqClXm27wtp8UD6xkUf4TnTAv6tQQJygSlgYvBm6H
         cR6DQCr2Z+/m1KvxbroiBxKJaPTZ9pxDsEbNWJrHZSSBm3e3a91giiW15vW+VflDndfa
         U1tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tuny/0eGXiUI7uo2gVucclOBaSeF7WVbv1eeHSQKFaE=;
        b=g02LGl217lDy1sgMjxqHTJPTCPacfxqpRXiQJR1K2QUDCCF/oPDzkkuLNIIgQ4YYBJ
         KUS6hyZGbsK64bVYUdd1mRpb/m/HMMQ0kNYwjGxvAHvqE0Z/lgfNNtiLRwTuGaF4KG9g
         YJzal+22dW9YBkDEjbPryixvE0qnLAFdoskx5rCBbbd9An56dhUNcAjACvxLWHIHaFya
         XynxWY1y6T9xwzIvRTuAmFbHc/QqIzIiQYeNeSQ5SyVcAO9YUIclC1utryshUyg2Pj61
         iut0ns5t6py8e5b+EA0jNZdcdc0rmWGqvcC7/YhnG+B8mDcY1fxYKtYNn2Uu6pg1YGTK
         HGcA==
X-Gm-Message-State: AOAM5314kYIXrv7sq0k76AeFsc1mQdnP+qCSaosj9qqJux/hYqE5zvjc
        TGJHZgnpm5awubViHT0QgpB0hzWegeA=
X-Google-Smtp-Source: ABdhPJy2Iq6P+yIa9UFj5axzhHa+x+EubqFC3tvbbYbE9FTipuyNemwAnPdcJOW0VYk4zQFHOfAaTA==
X-Received: by 2002:a17:90a:7185:: with SMTP id i5mr37588461pjk.236.1628697842379;
        Wed, 11 Aug 2021 09:04:02 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:04:02 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 53/60] KVM: PPC: Book3S HV P9: Optimise hash guest SLB saving
Date:   Thu, 12 Aug 2021 02:01:27 +1000
Message-Id: <20210811160134.904987-54-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
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
index fa6ac153c0f9..cb865fe2580d 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -483,10 +483,22 @@ static void __accumulate_time(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator
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
@@ -616,8 +628,10 @@ static void save_clear_guest_mmu(struct kvm *kvm, struct kvm_vcpu *vcpu)
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

