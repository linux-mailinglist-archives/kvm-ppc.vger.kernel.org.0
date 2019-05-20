Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 474EC2299F
	for <lists+kvm-ppc@lfdr.de>; Mon, 20 May 2019 02:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbfETA6C (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 19 May 2019 20:58:02 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36901 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727866AbfETA6B (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 19 May 2019 20:58:01 -0400
Received: by mail-pl1-f193.google.com with SMTP id p15so5887534pll.4
        for <kvm-ppc@vger.kernel.org>; Sun, 19 May 2019 17:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BB17cEG+gwuyLazefEWFCaJAEfHHGLjeUrPVtXqaLKQ=;
        b=HSeyYJY/LUz1Wr3Sf106fODIGxDVP3J65iyjxlRaagYSr7O4DSS/f6lfCUuARZ1WCt
         pvMgihZxlJcV80BYJmZwjbiUJZmWuOZT1BiCuoAmXFC4Eu5zZtVO+aFLMmnCyPApSlq/
         pPfVkch+d1Djc3bARWLB2kR29L6hgfSnSo8bRZTtnuhBzRQ5/BuT9HNid29Z7F6j1VAC
         Vw61hPvNj0c4nZpBRsDs1h2aQBndz8pI4nL1qK0lmCCY0abmE46NOPAujKcEIH5nJZL3
         xzAAlW+PDtk6Aj7maAybUzqJTIojHxNihYPVaK+p+EeJOKVaDwA5z0++v3Y8Cq5erlX6
         PU2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BB17cEG+gwuyLazefEWFCaJAEfHHGLjeUrPVtXqaLKQ=;
        b=ilSppSDkPRrYLADryrIFEk4RHCM1oMepXJ10K2JsHk58IMnh8LXF7JbeD4Wz/OYJ3Y
         e+MxEQcj2gV/S6AD1RwfveVpi+V5sAdBCC0XNbpWk00sP1xOsw3IT1WEUk5GsxCV5+MB
         1jKT2SpTMzGZhibr2dWYsHtt1rW4b5ZxmUFNJWJHtQhpsvacaHq3IjYnXTxvDX0jX5uL
         gMGloYkExEM/QhsoqMF15Jj5zwLj5LkLTJdxlhSA/AjqSinp3OM6GzgulHC8WgMwSNBI
         +zjgyn8WIPQ18lTHEZI1hSyEGH4zkaGqr/Oz/vJj/60G873F1JinNRhCaV/yIr8wuOzR
         JyfQ==
X-Gm-Message-State: APjAAAUN+3Gp+q0EbfOzv+h5xoP1774/V/9lHngub7bh9HPLryYRIpKQ
        GB20x/rbq1ovaybhgTzkc7Tbi9y/
X-Google-Smtp-Source: APXvYqzlvlqUbu2dLaUUtpZNbld0ztu5jeSINnSiTknzSK64MjvlZjLvfRW59hxK3+b2NXmxase0tg==
X-Received: by 2002:a17:902:163:: with SMTP id 90mr73662735plb.212.1558313880884;
        Sun, 19 May 2019 17:58:00 -0700 (PDT)
Received: from bobo.local0.net (193-116-79-244.tpgi.com.au. [193.116.79.244])
        by smtp.gmail.com with ESMTPSA id q193sm22643371pfc.52.2019.05.19.17.57.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 May 2019 17:58:00 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH 4/5] KVM: PPC: Book3S HV: Implement LPCR[AIL]=3 mode for injected interrupts
Date:   Mon, 20 May 2019 10:56:58 +1000
Message-Id: <20190520005659.18628-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190520005659.18628-1-npiggin@gmail.com>
References: <20190520005659.18628-1-npiggin@gmail.com>
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
index 5ae7f8359368..2453a085da86 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -797,6 +797,20 @@ void kvmppc_inject_interrupt_hv(struct kvm_vcpu *vcpu, int vec, u64 srr1_flags)
 		new_msr |= msr & MSR_TS_MASK;
 #endif
 
+#ifdef CONFIG_PPC_BOOK3S_64
+	/*
+	 * LPCR[AIL]=2 deliveries are not supported.
+	 * AIL does not apply to HMI, but it doesn't get delivered to guests.
+	 */
+	if (vec != BOOK3S_INTERRUPT_SYSTEM_RESET &&
+	    vec != BOOK3S_INTERRUPT_MACHINE_CHECK &&
+	    (vcpu->arch.vcore->lpcr & LPCR_AIL) == LPCR_AIL_3 &&
+	    (msr & (MSR_IR|MSR_DR)) == (MSR_IR|MSR_DR) ) {
+		new_msr |= MSR_IR | MSR_DR;
+		new_pc += 0xC000000000004000ULL;
+	}
+#endif
+
 	kvmppc_set_srr0(vcpu, pc);
 	kvmppc_set_srr1(vcpu, (msr & SRR1_MSR_BITS) | srr1_flags);
 	kvmppc_set_pc(vcpu, new_pc);
-- 
2.20.1

