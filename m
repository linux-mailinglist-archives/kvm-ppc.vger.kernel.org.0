Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999CA3D51BB
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhGZDLQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhGZDLQ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:11:16 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35BCC061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:44 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id k1so9914351plt.12
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9VyGXv1qn0uoS5eA7BXzADizNISqN4ZTKzrUeAY//9w=;
        b=IoOAmkNrLBRNWr3ilu/SFJPoljfPjGQJCKRHtxFDUFSada09gMtmFGAOSihQ2WsX/m
         Ryz9vUvSkidgc4ZYqw/dJSTvBoiMIDb/IW3dTCou4f2i19wGaN4GHwYDkZknpWlsbcdQ
         Tb/mZJ5HLNkzvzwqz7C75ZWyCipmIn9Ok1NcT7+UQvrYQAk4/n6k5ieEvZfCNO8Sx85x
         v6GZyHcQJ9awqVBqsYK4E3Rkgctd9rTch0GHD4jhAt8odBtXGUHyPJlf6az5ys+iCByR
         4xAyBQuAlRSe6kBfAHuzgR89DdRQSaPIrku7EnaGDDZ+FGsHZVI7ZzGcluhBycJLB6qL
         2aPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9VyGXv1qn0uoS5eA7BXzADizNISqN4ZTKzrUeAY//9w=;
        b=ZNY9/gewEDNF1efbj0b3U1x/kNRj2TStC73J8ZeF2NytthXJfqQhctYNAMnaCIvmc8
         nMzZ4XzYzJ6P51ofsjAdUbIyc5GrfCM4qB5PtllY2b5bXgBWbimUkHsQ/TEchfo+tdCr
         di4UOzH0QmWbJtSJC6v9Jurjq74XEioHntcdn+ZevzM2zZgfFTgJaaX1ahr6HbejDXHX
         zzWeUw7HMr/8aIvQcWf5wjbzGFe9Wm0oFrIlGjvSJAptysINKXwZo8A3Ih1M91vYMqha
         bxefgmcUg2ZDNNnLH5MJpqiDicTEsS9FSfDen8+TYG3LwHTMRJNYhtgtTiCK1i2UhHh7
         uJAg==
X-Gm-Message-State: AOAM532xe/R+q6xbIvJa8OX4Fn2h3cOlg7jcunkXYrt0b1JbbGixlWvP
        cLaL8rywrx2dltgpq/tP9v8fO/3kCPA=
X-Google-Smtp-Source: ABdhPJyyepy2WnT5E3LdywhsJvWyzOZZkZDfMg020dcPBKUi6Vq51xKSXDckbl76dj55YUhmPjVPww==
X-Received: by 2002:a17:90a:8410:: with SMTP id j16mr15415744pjn.111.1627271504109;
        Sun, 25 Jul 2021 20:51:44 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:51:43 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v1 25/55] KVM: PPC: Book3S HV P9: Add kvmppc_stop_thread to match kvmppc_start_thread
Date:   Mon, 26 Jul 2021 13:50:06 +1000
Message-Id: <20210726035036.739609-26-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Small cleanup makes it a bit easier to match up entry and exit
operations.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 7654235c1507..4d757e4904c4 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3045,6 +3045,13 @@ static void kvmppc_start_thread(struct kvm_vcpu *vcpu, struct kvmppc_vcore *vc)
 		kvmppc_ipi_thread(cpu);
 }
 
+/* Old path does this in asm */
+static void kvmppc_stop_thread(struct kvm_vcpu *vcpu)
+{
+	vcpu->cpu = -1;
+	vcpu->arch.thread_cpu = -1;
+}
+
 static void kvmppc_wait_for_nap(int n_threads)
 {
 	int cpu = smp_processor_id();
@@ -4260,8 +4267,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		dec = (s32) dec;
 	tb = mftb();
 	vcpu->arch.dec_expires = dec + tb;
-	vcpu->cpu = -1;
-	vcpu->arch.thread_cpu = -1;
 
 	store_spr_state(vcpu);
 
@@ -4733,6 +4738,8 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	guest_exit_irqoff();
 
+	kvmppc_stop_thread(vcpu);
+
 	powerpc_local_irq_pmu_restore(flags);
 
 	cpumask_clear_cpu(pcpu, &kvm->arch.cpu_in_guest);
-- 
2.23.0

