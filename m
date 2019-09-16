Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23BC2B35A9
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Sep 2019 09:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfIPHb3 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Sep 2019 03:31:29 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:32777 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfIPHb3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 16 Sep 2019 03:31:29 -0400
Received: by mail-pg1-f194.google.com with SMTP id n190so19329956pgn.0
        for <kvm-ppc@vger.kernel.org>; Mon, 16 Sep 2019 00:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kNInSqUn4WDWmrev/DGpAq4x5sDdoX62DrJXr09cvjw=;
        b=K+MVP4xWrkujhIS7u3OyMDDcwHwC1woFxkVSyulPHjcoSXCR8g3MwZlyFs8x0Sjgfc
         7ddTkGUS8uBeHGP0CzkvZdqE4L/cf7RjaQJ4jwr+LsAbKYSkleJoPfPv95HuepdRrzei
         av78PQX/k3btdGk7S2Mu9FjXFCFms58qcsSfNbVwy2CcXwtODFVu0WvyBUdDILszkQiN
         eW+6a2sJa82dU3XvGjMSC3SHSBhD1RYpAhcQr85C0JkEZ2/evVbzOT6nPfIDsLV1RKLm
         +5b4/F4Hmuy2OxH7eKwDCexRq55Qm7DA0tcxPMTUHKkdZf2rHJS+SmBWKn427+N6+AHQ
         xkxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kNInSqUn4WDWmrev/DGpAq4x5sDdoX62DrJXr09cvjw=;
        b=rmXG2vNclVnEpBG5sEOqDXnflaMaoBMSjn/jq3z2hu9VDnsXjs7hM7rdMu8mYadBm3
         5Od34O7oU5m8RwJGYyfTXH6qqF+C2UaHIBo/rcuRDPi+XkPuTI82V20AfKMHkPQHaI9k
         nlyrSohRxM5UtA0Q7Eq/R/QYj1nP+F5je65yZHb78PUfB4zdOrgflV87RLR4lSeb94Tw
         POSivbd2CpTA4Ox/Vb56evPYI3drq3PyUm7+OfAVXXehb0g+ohojvIK89feXs/53CvEh
         Y1QguV3aISn82ojMEKXzHE6jWDtqMQPDdmgD0daJ+J6V+EqhMHy4klvImC7InhrfXKAy
         rS8Q==
X-Gm-Message-State: APjAAAXghfP2455G3VrxKMcxb2BDiOPZINEvZHWryrNzu6uVxkZo4Sjs
        HYK5s297Vd1ZJzI90B96jptD5yyt
X-Google-Smtp-Source: APXvYqyS/ZOdZyQBt23i/Ny9YU4DXOJhHoelMm8EaVH/IOLXxFqYQbXQTpeZhai+6TCnVOxuPMfVag==
X-Received: by 2002:a63:9a11:: with SMTP id o17mr11888265pge.434.1568619089041;
        Mon, 16 Sep 2019 00:31:29 -0700 (PDT)
Received: from bobo.local0.net ([203.63.189.78])
        by smtp.gmail.com with ESMTPSA id 195sm12484964pfz.103.2019.09.16.00.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 00:31:28 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH v2 4/5] KVM: PPC: Book3S HV: Implement LPCR[AIL]=3 mode for injected interrupts
Date:   Mon, 16 Sep 2019 17:31:07 +1000
Message-Id: <20190916073108.3256-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190916073108.3256-1-npiggin@gmail.com>
References: <20190916073108.3256-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

kvmppc_inject_interrupt does not implement LPCR[AIL]!=0 modes, which
can result in the guest receiving interrupts as if LPCR[AIL]=0
contrary to the ISA.

In practice, Linux guests cope with this deviation, but it should be
fixed.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_builtin.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 47b44d9b5c1f..c73de4e875a5 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -792,6 +792,20 @@ static void inject_interrupt(struct kvm_vcpu *vcpu, int vec, u64 srr1_flags)
 	else
 		new_msr |= msr & MSR_TS_MASK;
 
+	/*
+	 * LPCR[AIL]=2 deliveries are not supported.
+	 *
+	 * AIL does not apply to SRESET, MCE, or HMI (which is never
+	 * delivered to the guest).
+	 */
+	if (vec != BOOK3S_INTERRUPT_SYSTEM_RESET &&
+	    vec != BOOK3S_INTERRUPT_MACHINE_CHECK &&
+	    (vcpu->arch.vcore->lpcr & LPCR_AIL) == LPCR_AIL_3 &&
+	    (msr & (MSR_IR|MSR_DR)) == (MSR_IR|MSR_DR) ) {
+		new_msr |= MSR_IR | MSR_DR;
+		new_pc += 0xC000000000004000ULL;
+	}
+
 	kvmppc_set_srr0(vcpu, pc);
 	kvmppc_set_srr1(vcpu, (msr & SRR1_MSR_BITS) | srr1_flags);
 	kvmppc_set_pc(vcpu, new_pc);
-- 
2.23.0

