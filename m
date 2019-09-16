Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D942B35A6
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Sep 2019 09:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfIPHbV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Sep 2019 03:31:21 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37438 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfIPHbV (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 16 Sep 2019 03:31:21 -0400
Received: by mail-pg1-f196.google.com with SMTP id c17so11554463pgg.4
        for <kvm-ppc@vger.kernel.org>; Mon, 16 Sep 2019 00:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qC4mEy3HsBbzYD0/Vypqch5QKePwmfPyZ4LozVDplt0=;
        b=tUUA17vTXrXtX1Yh0WYuZZCA8/rishnSxVVxwCHz1KY1MHjf9UbsglJC2gsgG5dJog
         Vxb78x5LjgPVXUJc09Cxbmq7Y7MnrMa7CxvWe8xvIhSttvJTxCR77n+3rgQxSnGuYma9
         ywiwi3cmK8p7XKt6AGSm7/FdJ2qTMB2aoY+leOwZrrMv4qVGvtFxepuRhBjIFnlg+j/3
         LnJxN6TAr7iLH6UWHFIjaN8MucT3azhOVtIFCPT1BqZ0I6eJU0tHK1WdZpr65FF0EBSU
         jI4ZWkt76Yzs7pjrXA6BxatGdmOrSrrzA4ONwO8VSKANTNZWmawAi/1zrowdXxcMjFiH
         p8SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qC4mEy3HsBbzYD0/Vypqch5QKePwmfPyZ4LozVDplt0=;
        b=f63zwrZknVpcy8Od0mkDzGQixPSAwEJMUDq00wq+f/bHj8fXnUPGj6kMUTsVUfg89k
         +ipMvSmqGe73WCb0SQtce7794nzvzB2lPo9iISGFshIcNGO2VEp+z6Cca/cRCb1wSErG
         DDSrmJ6bYHetg//z5uRrxJTTiPhrjElbXxbYVTqEV/xNEUGpm92ti/Fa35rOOGX5AMDV
         8N6T/0z7DyoeAvPo5DKHNTrxBdapDyPuxQI6jdg3QWsUQ66lKQ+BurfBGcswSZRsj9nD
         t/3CS9QURT2/zjRka0/KySXu0mfpx2QQATP99Iw9azKhU3FZXb007yYlwWR5XTyKxs/D
         MkOg==
X-Gm-Message-State: APjAAAW2J7bWa7lICFG7boINUnZmBmIlXhw6aylFIOw7Z2m8ZRvOuj7P
        isPupACBtX1LHw03OHGxan6ZW/r/
X-Google-Smtp-Source: APXvYqy/Y/tjaxu/wV9NCIbt80XV3su/wgCcIhJdInX34s3IKgsgsEQjgkLWNHveKhNDR/9PUkN9uQ==
X-Received: by 2002:a63:e213:: with SMTP id q19mr54349938pgh.180.1568619080257;
        Mon, 16 Sep 2019 00:31:20 -0700 (PDT)
Received: from bobo.local0.net ([203.63.189.78])
        by smtp.gmail.com with ESMTPSA id 195sm12484964pfz.103.2019.09.16.00.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 00:31:19 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH v2 1/5] KVM: PPC: Book3S: Define and use SRR1_MSR_BITS
Date:   Mon, 16 Sep 2019 17:31:04 +1000
Message-Id: <20190916073108.3256-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190916073108.3256-1-npiggin@gmail.com>
References: <20190916073108.3256-1-npiggin@gmail.com>
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
index 9524d92bc45d..d3dc733d017a 100644
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
2.23.0

