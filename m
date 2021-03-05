Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347B732EDE4
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhCEPIq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhCEPIk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:08:40 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17590C061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:08:40 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id d12so2297817pfo.7
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ng35u+WMA/qGWz587TPAryNNgxNTtoIA/vWcbEoH+FI=;
        b=C3oJapWjkCMlnytC2LatdI8vXXW0ivp39To+cqTM4bZKxRpgk0A7n6WVxreAzo73x8
         TexgkpR0Viy4Dm3ugG5xQkb2G2IdupUgc45c0/aBdd5Nn4bFf5VhMO+lfMsxtfNP2dvf
         e+71fNMkBmQKJ/EYtot7Dh4L24bIZ/cAnoSJ+neqpDfIBmTJleJRxIeEvBpGJnBw9zsg
         4WlOtGlr00zJFCh80fDEIN3qp7Mx74dB8eIokYOc3hS+OkR575KKLRRV4uEksnIBILgn
         vGF/Q3Xwtn9fZErzYl8CwU7M96w3uZPxaB1blsMlbmb9gCeyxUHFmnAuCNx7f6CuzxJK
         sgvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ng35u+WMA/qGWz587TPAryNNgxNTtoIA/vWcbEoH+FI=;
        b=V97+xVoMbzA8QVES4ffoUtjnHkcPGabuejTmiIoHDvVuTB5JVaDrmfMEkLr6edzxnj
         W1lQpEzVKZkhQTHN50fDPj2IzPcA6FAzH/lrYlcp8EvwMQSy2JfXP91riSnvSU/dHglh
         FGboj6vZ7OjiW+EX4PdRmKtgqc/p/NMfgbAMzNsBF4/dWoKt2b6nols8C8ZAzEmhNXJZ
         /rhAKwA7+qlLL8aL1c6IAwgn2aHrvFRRKj0QVlz3V7cHiB/DkkMS1OR8K2ksqPlxD7jk
         kVF/QuQ23eLvfvHPs4+ogDFviFfICVkU3Q3yZYLXmFm34HD9tgU4aO8/FYu9VZ6LD2mZ
         gGSQ==
X-Gm-Message-State: AOAM531x4nBUMnBSMDiVCJTXHvveJAbLJ+P//Bsj8BmR5eGKy79zNr4B
        ZAOBFtHnBnofQZGYsdsSLUDsXwOL2YM=
X-Google-Smtp-Source: ABdhPJwh+4+cqQLfeLEqswCg8NCwhljf48NkGzhpsY/+eHliO7mDc3DYeNuh9gCEBdr6fopMoZzzEg==
X-Received: by 2002:a63:1725:: with SMTP id x37mr9131048pgl.48.1614956919330;
        Fri, 05 Mar 2021 07:08:39 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:08:38 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 30/41] KVM: PPC: Book3S HV P9: Move SPR loading after expiry time check
Date:   Sat,  6 Mar 2021 01:06:27 +1000
Message-Id: <20210305150638.2675513-31-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This is wasted work if the time limit is exceeded.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_interrupt.c | 36 ++++++++++++++++----------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/book3s_hv_interrupt.c
index 68514ab5a438..d81aef6c69d9 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -127,21 +127,16 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	u64 tb, purr, spurr;
 	u64 *exsave;
 	bool ri_set;
-	unsigned long msr = mfmsr();
 	int trap;
-	unsigned long host_hfscr = mfspr(SPRN_HFSCR);
-	unsigned long host_ciabr = mfspr(SPRN_CIABR);
-	unsigned long host_dawr0 = mfspr(SPRN_DAWR0);
-	unsigned long host_dawrx0 = mfspr(SPRN_DAWRX0);
-	unsigned long host_psscr = mfspr(SPRN_PSSCR);
-	unsigned long host_pidr = mfspr(SPRN_PID);
-	unsigned long host_dawr1 = 0;
-	unsigned long host_dawrx1 = 0;
-
-	if (cpu_has_feature(CPU_FTR_DAWR1)) {
-		host_dawr1 = mfspr(SPRN_DAWR1);
-		host_dawrx1 = mfspr(SPRN_DAWRX1);
-	}
+	unsigned long msr;
+	unsigned long host_hfscr;
+	unsigned long host_ciabr;
+	unsigned long host_dawr0;
+	unsigned long host_dawrx0;
+	unsigned long host_psscr;
+	unsigned long host_pidr;
+	unsigned long host_dawr1;
+	unsigned long host_dawrx1;
 
 	tb = mftb();
 	hdec = time_limit - tb;
@@ -159,6 +154,19 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		vc->tb_offset_applied = vc->tb_offset;
 	}
 
+	msr = mfmsr();
+
+	host_hfscr = mfspr(SPRN_HFSCR);
+	host_ciabr = mfspr(SPRN_CIABR);
+	host_dawr0 = mfspr(SPRN_DAWR0);
+	host_dawrx0 = mfspr(SPRN_DAWRX0);
+	host_psscr = mfspr(SPRN_PSSCR);
+	host_pidr = mfspr(SPRN_PID);
+	if (cpu_has_feature(CPU_FTR_DAWR1)) {
+		host_dawr1 = mfspr(SPRN_DAWR1);
+		host_dawrx1 = mfspr(SPRN_DAWRX1);
+	}
+
 	if (vc->pcr)
 		mtspr(SPRN_PCR, vc->pcr | PCR_MASK);
 	mtspr(SPRN_DPDES, vc->dpdes);
-- 
2.23.0

