Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A03D82299C
	for <lists+kvm-ppc@lfdr.de>; Mon, 20 May 2019 02:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbfETA5w (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 19 May 2019 20:57:52 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41197 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727866AbfETA5w (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 19 May 2019 20:57:52 -0400
Received: by mail-pl1-f195.google.com with SMTP id f12so5875189plt.8
        for <kvm-ppc@vger.kernel.org>; Sun, 19 May 2019 17:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tbxVwNhwho8GVbaR0I4qBM4WqRKlJ5uyUB9/wRGwLeQ=;
        b=nsQ62kXeyKTNQ5Ehfs68vVPWUsvVlAlgosrpW3BP1KSQ7HqLHa4BCXqh87UbFTZwkQ
         RaFH2EfJa4O1Q+T0RKYgMr1+y82TCzhhOV7CXWCExFNrod8uoo7zdkDrXBN6tHtYTJBO
         PcP1DFELUYMOpwHSzo1RCl6Ua0AzIKZFThwT+9SkjwfxSfLv0zvc5xe5gXQrlORKC5N2
         bfWFEObCHt3ORvSVqzSYGV+3/4Al0i1Z4vW7Yp4rAgwHfkAgXNOc9hmQNTRFBIYoPVd+
         LXOjn1mhu+Por4XrIgMPLh3wbjsz3iVQDj62vj+mZqmTYi9raAkiqaoBJKAnlgOn2mN9
         Y4Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tbxVwNhwho8GVbaR0I4qBM4WqRKlJ5uyUB9/wRGwLeQ=;
        b=fmIYzVG7QRj3ByF8nMtU7JNPPNvlSot62YPXlj/WiZYg9vSmWTXjjAguf/mvpTMgX4
         tQk0DUuLzaq0kpASX/mi8thx1nnwLUIlS6gn9VPkaLKvJavSrJr+pgWSKXQ2KOXIFilW
         Qx9u43AqoOjI3bwkdw7+OOCzSW9ubZTODLKHYPN7sVeHV4+HwJh7AvfMAFibGj3MRlN8
         Yv7LKqYGV+3A8BuJmhn+7c5zCDBbOmyz2gGzmNDobu015+WUNAJKhbAu3KK6NemSK6IL
         mD4SFqubfCdJ2sXwsMg8Yq85MZZ/GnnL4dE8HbCTZC+L2xcLH/AkxrReD25GujI3ofs1
         CGOA==
X-Gm-Message-State: APjAAAVdH+XDK6+bPwgf7etbuXmCzBd2/xPkO57E9swg5PhmROBlawtU
        lm/bo2t8PQg9djh28sPgJJrZTVWI
X-Google-Smtp-Source: APXvYqyjq59xpXC6My1fcyq4Zps46ZZibLosd+wF/3+aKbs7oLdhBCHXlItGFR19D+ZcF7Owugs4DA==
X-Received: by 2002:a17:902:aa97:: with SMTP id d23mr72898119plr.313.1558313871858;
        Sun, 19 May 2019 17:57:51 -0700 (PDT)
Received: from bobo.local0.net (193-116-79-244.tpgi.com.au. [193.116.79.244])
        by smtp.gmail.com with ESMTPSA id q193sm22643371pfc.52.2019.05.19.17.57.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 May 2019 17:57:51 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH 1/5] KVM: PPC: Book3S: Define and use SRR1_MSR_BITS
Date:   Mon, 20 May 2019 10:56:55 +1000
Message-Id: <20190520005659.18628-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/reg.h      | 12 ++++++++++++
 arch/powerpc/kvm/book3s.c           |  2 +-
 arch/powerpc/kvm/book3s_hv_nested.c |  2 +-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index 10caa145f98b..a79fc04acebc 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -742,6 +742,18 @@
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
index 61a212d0daf0..d59b9f666efb 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -139,7 +139,7 @@ void kvmppc_inject_interrupt(struct kvm_vcpu *vcpu, int vec, u64 flags)
 {
 	kvmppc_unfixup_split_real(vcpu);
 	kvmppc_set_srr0(vcpu, kvmppc_get_pc(vcpu));
-	kvmppc_set_srr1(vcpu, (kvmppc_get_msr(vcpu) & ~0x783f0000ul) | flags);
+	kvmppc_set_srr1(vcpu, (kvmppc_get_msr(vcpu) & SRR1_MSR_BITS) | flags);
 	kvmppc_set_pc(vcpu, kvmppc_interrupt_offset(vcpu) + vec);
 	vcpu->arch.mmu.reset_msr(vcpu);
 }
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 735e0ac6f5b2..8190cbbf4218 100644
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
2.20.1

