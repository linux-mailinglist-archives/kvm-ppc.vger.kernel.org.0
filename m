Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF76421373
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235212AbhJDQES (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236289AbhJDQEN (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:04:13 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF858C061746
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:02:24 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id j4so209455plx.4
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TM/HAR2kIbbjsWEciD5SVgeeCTO1PDyzdJl58aiAKUU=;
        b=mg0Iw6mcWciAkTXZmbSjn0fIPZxsDgy0BgteZZFXRyFvyilYuuOastBAzHwDoRBuYf
         LvYLGn8PfLpVon3pT+gN0MQxG0unh6NK5OpSlaS1ix4OKzf1ka9tAe+/v0hXA/Z9yLOd
         uadUFkDtiz7XSrutFCTO6HdJOhWxU/LiqJV3GrSK7nQO/EY7gXIVP90qaKrX1eIaMxgq
         3bGmoNiiGojqCBFOFQ5cVWYdEDv8A6aUCuuC6Nnx14tQDjXkGP37p0sGzm493oSPLlF4
         oBSOgPKIzX0pvUYGEziebIAt3qF915nahHz1wSM6wWBeOfGczKkCzVs4PHR1vVGWm4Nj
         1H9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TM/HAR2kIbbjsWEciD5SVgeeCTO1PDyzdJl58aiAKUU=;
        b=6bN2RyL8Re0OWj09I0sAs4eFIK7kek4vfrgs+ffOCP4ckdo1rp7X41LRYNdetIF2y9
         ybWkJsr6cdcD2YUHC+kcIstaqE63mI7210l/3l7l5aJBwYGaya1MPVbYcQt60/SlucqV
         9J/EA36NoO/JZXSZ4Ugu1z5TuPZJeOeDV2G95TAFSnZFonO+TpC7cmKf1gaMhbfRZMyS
         eRbSozMZxtAzwEhlTDUeI+tRAFoidX8DXCeueEnEIjFNM1Ccr0HpscP/IC/Hl67xonts
         oJUpPT+tTkRDQdeqvAwjGWiAY8604exUmvNl5gVaTUm863CTjgYSbObFgesF3ONb9i7t
         AUXg==
X-Gm-Message-State: AOAM5314wVm5s0jFMp2ZnN8SkxMTs3Elgw/etozgoXijILzVf5Pb30V/
        aZvcqJAURhWgejtWvLsif0S09XENGcs=
X-Google-Smtp-Source: ABdhPJw9i0hkx/ZJX4gMlIdhV58CWJ6jGL1hsGTn/P4mcWSdf8vQ6enEN7lxxJB7ZPLqZykU8TlfWA==
X-Received: by 2002:a17:902:868d:b0:13d:dfa7:f3f2 with SMTP id g13-20020a170902868d00b0013ddfa7f3f2mr456589plo.30.1633363344226;
        Mon, 04 Oct 2021 09:02:24 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:02:24 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 34/52] KVM: PPC: Book3S HV P9: Restrict DSISR canary workaround to processors that require it
Date:   Tue,  5 Oct 2021 02:00:31 +1000
Message-Id: <20211004160049.1338837-35-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Use CPU_FTR_P9_RADIX_PREFETCH_BUG to apply the workaround, to test for
DD2.1 and below processors. This saves a mtSPR in guest entry.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          | 3 ++-
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 5a1859311b3e..6fb941aa77f1 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1590,7 +1590,8 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 		unsigned long vsid;
 		long err;
 
-		if (vcpu->arch.fault_dsisr == HDSISR_CANARY) {
+		if (cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG) &&
+		    unlikely(vcpu->arch.fault_dsisr == HDSISR_CANARY)) {
 			r = RESUME_GUEST; /* Just retry if it's the canary */
 			break;
 		}
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 619bbcd47b92..67f57b03a896 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -683,9 +683,11 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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

