Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DBD2C7231
	for <lists+kvm-ppc@lfdr.de>; Sat, 28 Nov 2020 23:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733136AbgK1VuY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 28 Nov 2020 16:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731835AbgK1SzT (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 28 Nov 2020 13:55:19 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F595C094251
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Nov 2020 23:07:46 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id b10so4967536pfo.4
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Nov 2020 23:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3UQ8a27frPjoA0hjZKr4P15dWLXH20x5zsQ+TlAD34E=;
        b=GDqZAGllhEk6/on6Ry3JIEm3bjK7GdmrjpnX9ekU0+dey4oI4jAtm9RPERfC7hRWFi
         hrDlBY3ygt5hNpCfh+Z+tNyEP4toki60uKrjt0csJJ9El/qFftRqgrrwLYmEVa+RA79l
         fg54s0jpjZjPNzCgX6XFlzot8MJ/8ddE/m6391an5+6eZ2A+zzbikyQj/LWz7f86FjOP
         0+R0MwfjVXR0tFjh0Es8QoE4P3x/hRG3k/1Dt+OzGDA5NmwOTVBw/xYNqppKu9o1ffS9
         37Vr5boOhl7KfwBYnLj/sq51O/PYi/I/7ofZms+l2iPbiMHlezo5EYz6yj26mk22r2NI
         ER1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3UQ8a27frPjoA0hjZKr4P15dWLXH20x5zsQ+TlAD34E=;
        b=l2p4kS36Xvhurb0W2aQwE7ZXYhaI5FeX7fpLdBfqMsH/MC/I/XpdfqWKiT3LP1Eh6u
         m/5y4cIRkR5VtV/hWZhlFW7+AaK+mIVQNSTZbdZVWEe5OrfKBQcKQkNty1uIN4AKtnfx
         8v8ODzOMV+O0csk09IfFhEmxrffWCXeYtlfBzreegwPBWW10uJl2wQGAdNIXpm5ivZX5
         15o6HERTpFeXrQ4Gk6XFYJS20TRGJEhybRvl92mY+W4OnAqzWBFvqGaUMouM02lremTz
         bI8wj4c39ZryfZYPf6+uiT1WmOblq/54XMip2EGWCS5qyJpDbbsL8zZQfVZ0Y9ZJY+B3
         OxZA==
X-Gm-Message-State: AOAM533WMeOF4mT8RKXwvU74kAJBfyYV0YYmD9OamXQiP7uryCYAtfdr
        IShmROgBtR4qKKimxlthNYw=
X-Google-Smtp-Source: ABdhPJz7b8QyWG+ch6F7y8M0CFx/Tw7twwhrbhnNsuDTRpQeC5YZ5PYkkPTt/SdnoNIZQVrOh2okXg==
X-Received: by 2002:a63:902:: with SMTP id 2mr9111381pgj.192.1606547265664;
        Fri, 27 Nov 2020 23:07:45 -0800 (PST)
Received: from bobo.ibm.com (193-116-103-132.tpgi.com.au. [193.116.103.132])
        by smtp.gmail.com with ESMTPSA id e31sm9087329pgb.16.2020.11.27.23.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 23:07:45 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org,
        Mahesh Salgaonkar <mahesh@linux.ibm.com>
Subject: [PATCH 3/8] KVM: PPC: Book3S HV: Don't attempt to recover machine checks for FWNMI enabled guests
Date:   Sat, 28 Nov 2020 17:07:23 +1000
Message-Id: <20201128070728.825934-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201128070728.825934-1-npiggin@gmail.com>
References: <20201128070728.825934-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Guests that can deal with machine checks would actually prefer the
hypervisor not to try recover for them. For example if SLB multi-hits
are recovered by the hypervisor by clearing the SLB then the guest
will not be able to log the contents and debug its programming error.

If guests don't register for FWNMI, they may not be so capable and so
the hypervisor will continue to recover for those.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_ras.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_ras.c b/arch/powerpc/kvm/book3s_hv_ras.c
index 6028628ea3ac..d4bca93b79f6 100644
--- a/arch/powerpc/kvm/book3s_hv_ras.c
+++ b/arch/powerpc/kvm/book3s_hv_ras.c
@@ -65,10 +65,9 @@ static void reload_slb(struct kvm_vcpu *vcpu)
  * On POWER7, see if we can handle a machine check that occurred inside
  * the guest in real mode, without switching to the host partition.
  */
-static void kvmppc_realmode_mc_power7(struct kvm_vcpu *vcpu)
+static long kvmppc_realmode_mc_power7(struct kvm_vcpu *vcpu)
 {
 	unsigned long srr1 = vcpu->arch.shregs.msr;
-	struct machine_check_event mce_evt;
 	long handled = 1;
 
 	if (srr1 & SRR1_MC_LDSTERR) {
@@ -106,6 +105,21 @@ static void kvmppc_realmode_mc_power7(struct kvm_vcpu *vcpu)
 		handled = 0;
 	}
 
+	return handled;
+}
+
+void kvmppc_realmode_machine_check(struct kvm_vcpu *vcpu)
+{
+	struct machine_check_event mce_evt;
+	long handled;
+
+	if (vcpu->kvm->arch.fwnmi_enabled) {
+		/* FWNMI guests handle their own recovery */
+		handled = 0;
+	} else {
+		handled = kvmppc_realmode_mc_power7(vcpu);
+	}
+
 	/*
 	 * Now get the event and stash it in the vcpu struct so it can
 	 * be handled by the primary thread in virtual mode.  We can't
@@ -122,11 +136,6 @@ static void kvmppc_realmode_mc_power7(struct kvm_vcpu *vcpu)
 	vcpu->arch.mce_evt = mce_evt;
 }
 
-void kvmppc_realmode_machine_check(struct kvm_vcpu *vcpu)
-{
-	kvmppc_realmode_mc_power7(vcpu);
-}
-
 /* Check if dynamic split is in force and return subcore size accordingly. */
 static inline int kvmppc_cur_subcore_size(void)
 {
-- 
2.23.0

