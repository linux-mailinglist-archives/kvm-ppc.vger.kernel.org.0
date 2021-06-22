Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7793B0213
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhFVLBe (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbhFVLBc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:01:32 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAF9C061756
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:14 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id h4so5230712pgp.5
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=updQAf8t0ym29EfFgOrHg3nwT7DKOY58qleB66Aa4hY=;
        b=OW1mMXZNu+ZCgIsxMy2C530HmkrF1RmMy7/S1jn9RiIPWkODc3ENxiqiq53JUohvTS
         JenMuS+SJRsaKI9feHbe5M/zQPpWAvChVbOo8AyFDpzlcgAUj4KpnIbsI7QRPZcMOgSS
         gOH2tIZCz1JB7HzvEmMUUUVMPDX+cfcnVQlRvm319s6sGAWtlRNYMijATC/jfM9PNT9Z
         OGH/0UWhXdWSLYDDxSSmQxjjhTRmR25K/yb2VDviV4LlV8Py/H7V7c0bZvswITkduS2p
         QeurAePxYSUihiZitb0PBrm8ZCN0YBwuIgvN8asQ6uT1RsJ7ZOTrjT2TUMp98KUHnqYL
         dp1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=updQAf8t0ym29EfFgOrHg3nwT7DKOY58qleB66Aa4hY=;
        b=T6NLjvLUZqwCzCHrMjaOz3yGHbjipzq48/+x80j6SkXoOQPK3eSD4S6Vkkhs7+JLl/
         scJPR8v9ihVeXqbO4mjU5/ziUxvPhjqeiEbwLesngIF/rAw2CTvMWoIANVzYFxJ4yRKx
         f+fVig+Iyae5imtZ92uJk/mrVam6XfqF81Au6sbySGbRCT9mPzHexCrHJuUIRpVkjSAx
         4I+gv0FVAQAAZqyVXgsdewYryLxTLSB+7cXmjj3nt7XLmAszUlJbU8Ck8BvUXpkWrzGe
         XbYIn3hExcFd8tNe5VL5ANA/Y76/u0/U0b/PNXOEfCNmn0/6wCMRMDWPcYL55GSQmXME
         wc+g==
X-Gm-Message-State: AOAM533CZvrFnUMtm3H1s26eF6kQvj9CCqcL3RCuB+iP4YIk29R/fci1
        GUNgjzYNzCmw7hivaZyeRtbIXcAgc/I=
X-Google-Smtp-Source: ABdhPJzzseEap132pTuafgfhFewz+gmMGFnrcHC7nC23xChJ1Kh5BUT2W1ca0o2GOuemG/87H2GhRQ==
X-Received: by 2002:a63:a54b:: with SMTP id r11mr3220327pgu.43.1624359554094;
        Tue, 22 Jun 2021 03:59:14 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:59:13 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 32/43] KVM: PPC: Book3S HV P9: Restrict DSISR canary workaround to processors that require it
Date:   Tue, 22 Jun 2021 20:57:25 +1000
Message-Id: <20210622105736.633352-33-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Use CPU_FTR_P9_RADIX_PREFETCH_BUG for this, to test for DD2.1 and below
processors.

-43 cycles (7178) POWER9 virt-mode NULL hcall

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          | 3 ++-
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index a31397fde98e..ae528eb37792 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1523,7 +1523,8 @@ XXX benchmark guest exits
 		unsigned long vsid;
 		long err;
 
-		if (vcpu->arch.fault_dsisr == HDSISR_CANARY) {
+		if (cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG) &&
+		    unlikely(vcpu->arch.fault_dsisr == HDSISR_CANARY)) {
 			r = RESUME_GUEST; /* Just retry if it's the canary */
 			break;
 		}
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 9e58624566a4..b41be3d8f101 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -656,9 +656,11 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	 * HDSI which should correctly update the HDSISR the second time HDSI
 	 * entry.
 	 *
-	 * Just do this on all p9 processors for now.
+	 * The "radix prefetch bug" test can be used to test for this bug, as
+	 * it also exists fo DD2.1 and below.
 	 */
-	mtspr(SPRN_HDSISR, HDSISR_CANARY);
+	if (cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
+		mtspr(SPRN_HDSISR, HDSISR_CANARY);
 
 	mtspr(SPRN_SPRG0, vcpu->arch.shregs.sprg0);
 	mtspr(SPRN_SPRG1, vcpu->arch.shregs.sprg1);
-- 
2.23.0

