Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1E7C4750
	for <lists+kvm-ppc@lfdr.de>; Wed,  2 Oct 2019 08:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfJBGAz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 2 Oct 2019 02:00:55 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37486 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfJBGAy (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 2 Oct 2019 02:00:54 -0400
Received: by mail-pg1-f195.google.com with SMTP id c17so11291511pgg.4
        for <kvm-ppc@vger.kernel.org>; Tue, 01 Oct 2019 23:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZX0zfvRtAA562ZIDPi2zpxAIxjmN5v6Crr7qVu5FmrU=;
        b=bbIE3m09qoM3Nhg1pDfzgXvJ5cycSo8nBFBen9sKa8wWGDwyPG+WzZPsohI9cAqkJD
         paoyyBM9d55eVjCmxkYDRWy/tW6dpom92Lt+unyZpEKtVSMXlkomB9aMyzGkgDYFepdm
         CPmnc0oN5POjVmnYFHoPReUAWDrMyZ6nBlD+fZatqRuw1VmBMNR5an09QTApAVplBqie
         1pIyNcllNbIYPA4f2+1P1n67UnDuXiYHR001ePXGAqQi4qq3LQqyf58kjEqTTz4vuS8o
         ezyzV8LIAELSyU3gpP/3TrvgObF7fpFDOS1vd5hLjscDMhqB+51UGqwg2v/BTtZfu+YI
         Bsbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZX0zfvRtAA562ZIDPi2zpxAIxjmN5v6Crr7qVu5FmrU=;
        b=mxc1nEKZC2KONvls4zwlLUuVca7vh9Pn8jmT3TH64P4BeyNz/Q2tXrtO8vBOO82H24
         pYrSAPL6FZ6F5EC5jTNGeCws8Al0Kj9cARHyOpu1LAs0fLciw8/pORCPoIb010awuzw1
         75wS7Ur3AdP0QtkPhXrksnUusYQ8rbiGIZnkVR6McQXY7emP7RRQj5St/GQ9NjlYSSv2
         X1IdLQrmzAaL2u9bfu3xqVfqTItuycgmk/3NqGSSUQHlQJyaLP78mGx4pINs6hgyt/tS
         uHQZCai0ekBhGddGgtMWD9R0kBuiZfn9DaMnf6v1nwq7Ah+rwZwBP9YkhecLpg24Rofc
         1qBg==
X-Gm-Message-State: APjAAAUKlk4BcF2RjHcYHrPWNQS+oFhnyYYCFy8utHGDDBMbsg21R7f3
        O+3429GIfYs24II0VlMsCUoVpSMw
X-Google-Smtp-Source: APXvYqxpOUJiAWQWLhHKq4Z4wupgehTb+RECvCZtis6VSMWD4sfbNZ7d7WEErWx7KhYsJgQ7GBcWjg==
X-Received: by 2002:a62:5441:: with SMTP id i62mr2714468pfb.49.1569996053651;
        Tue, 01 Oct 2019 23:00:53 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id v12sm18660749pgr.31.2019.10.01.23.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 23:00:53 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH v2 1/5] KVM: PPC: Book3S: Define and use SRR1_MSR_BITS
Date:   Wed,  2 Oct 2019 16:00:21 +1000
Message-Id: <20191002060025.11644-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002060025.11644-1-npiggin@gmail.com>
References: <20191002060025.11644-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Acked-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/reg.h      | 12 ++++++++++++
 arch/powerpc/kvm/book3s.c           |  2 +-
 arch/powerpc/kvm/book3s_hv_nested.c |  2 +-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index b3cbb1136bce..75c7e95a321b 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -748,6 +748,18 @@
 #define SPRN_USPRG7	0x107	/* SPRG7 userspace read */
 #define SPRN_SRR0	0x01A	/* Save/Restore Register 0 */
 #define SPRN_SRR1	0x01B	/* Save/Restore Register 1 */
+
+#ifdef CONFIG_PPC_BOOK3S
+/*
+ * Bits loaded from MSR upon interrupt.
+ * PPC (64-bit) bits 33-36,42-47 are interrupt dependent, the others are
+ * loaded from MSR. The exception is that SRESET and MCE do not always load
+ * bit 62 (RI) from MSR. Don't use PPC_BITMASK for this because 32-bit uses
+ * it.
+ */
+#define   SRR1_MSR_BITS		(~0x783f0000UL)
+#endif
+
 #define   SRR1_ISI_NOPT		0x40000000 /* ISI: Not found in hash */
 #define   SRR1_ISI_N_OR_G	0x10000000 /* ISI: Access is no-exec or G */
 #define   SRR1_ISI_PROT		0x08000000 /* ISI: Other protection fault */
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index d7fcdfa7fee4..38466df81d33 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -136,7 +136,7 @@ void kvmppc_inject_interrupt(struct kvm_vcpu *vcpu, int vec, u64 flags)
 {
 	kvmppc_unfixup_split_real(vcpu);
 	kvmppc_set_srr0(vcpu, kvmppc_get_pc(vcpu));
-	kvmppc_set_srr1(vcpu, (kvmppc_get_msr(vcpu) & ~0x783f0000ul) | flags);
+	kvmppc_set_srr1(vcpu, (kvmppc_get_msr(vcpu) & SRR1_MSR_BITS) | flags);
 	kvmppc_set_pc(vcpu, kvmppc_interrupt_offset(vcpu) + vec);
 	vcpu->arch.mmu.reset_msr(vcpu);
 }
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index cdf30c6eaf54..dc97e5be76f6 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -1186,7 +1186,7 @@ static int kvmhv_translate_addr_nested(struct kvm_vcpu *vcpu,
 forward_to_l1:
 	vcpu->arch.fault_dsisr = flags;
 	if (vcpu->arch.trap == BOOK3S_INTERRUPT_H_INST_STORAGE) {
-		vcpu->arch.shregs.msr &= ~0x783f0000ul;
+		vcpu->arch.shregs.msr &= SRR1_MSR_BITS;
 		vcpu->arch.shregs.msr |= flags;
 	}
 	return RESUME_HOST;
-- 
2.23.0

