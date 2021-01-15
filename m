Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D17F2F8135
	for <lists+kvm-ppc@lfdr.de>; Fri, 15 Jan 2021 17:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbhAOQvE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 15 Jan 2021 11:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727863AbhAOQvD (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 15 Jan 2021 11:51:03 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CF8C0613D3
        for <kvm-ppc@vger.kernel.org>; Fri, 15 Jan 2021 08:50:23 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id n10so6333119pgl.10
        for <kvm-ppc@vger.kernel.org>; Fri, 15 Jan 2021 08:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ox1+kJB8/svJPOlYh8jiLo0n0VnUtKrOgdur+kuGqWU=;
        b=GIiui6q9Vy/u0VLhKY1rzjdyMVHCPtuQqko+TsutQwhkCRwIT3ahF8vAEpiRowVIG2
         CaDO5L0U7UZwVYzfGWNP/hV0NWymuqbFmnWeZXQZN3CV3XoNx5gCTNOIgkKciVR9D7DN
         ymglN6RRXuGfEscC7Vbias7Avros2hSQnxp6iPC6ph0S4056SKyD9glWghB8qcr+QlBc
         cR1uFX4v43E9nuGvtmQxvf9EJieOUkO+IsIRZqKWnv5TsL9v4J50g7ttBcxbuHRqHU5K
         WpCDOUTvuYBCsVkb0FgT0mWhTcyRaJmL3hoARIZjFtGtYhnB1aojXADKUdL58q5yr7fe
         wN0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ox1+kJB8/svJPOlYh8jiLo0n0VnUtKrOgdur+kuGqWU=;
        b=k9jzi4S5RD2R+XmYErupJj0x4a+AQsX6dI0NtC/5AUflyCsj70pmyPsosrreb/Odux
         J5bsukSFuEsBqeVcJMHJZuHrOFp/Ems3JQyZvLryCNLzn4Ulm4ia3yrGJc8loPdAJpKf
         uA6bYRcnOxWmJMV45EPfEmEjDBQadh6kAfulHdTIVR0DtfNOEPcOcZ4Yb/18uL05Negh
         h7jnz6//nIHjtaV2SpCRea32gjuU2ZrZB6nzYUeD1Ce5tJcvEoo7XcAfjaoZVkvLYmgL
         s8ZGY8sgzx64vAS5MmRoszX/AiZ2WowwYaFNYCBQUgf02UBiIrO3HldrcikUxB5+bTwe
         QGCw==
X-Gm-Message-State: AOAM533TxQBGbET+Umqc58wEQSGZXq5FXqSneIIXKLtaxA8W0oRKiJgy
        +DX/cBNvBozC3COiwsLDjTbDOb2YtM8=
X-Google-Smtp-Source: ABdhPJxAInOSpswkrOe9JKPoooLZxSMoSmMTL9H6e0nUJDIM1dztJk2rzEZ9ncHQRliyHHycYff+nw==
X-Received: by 2002:a63:d041:: with SMTP id s1mr13367575pgi.249.1610729423327;
        Fri, 15 Jan 2021 08:50:23 -0800 (PST)
Received: from bobo.ibm.com ([124.170.13.62])
        by smtp.gmail.com with ESMTPSA id u1sm8455477pjr.51.2021.01.15.08.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 08:50:22 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        kvm-ppc@vger.kernel.org
Subject: [PATCH v6 01/39] KVM: PPC: Book3S HV: Context tracking exit guest context before enabling irqs
Date:   Sat, 16 Jan 2021 02:49:34 +1000
Message-Id: <20210115165012.1260253-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210115165012.1260253-1-npiggin@gmail.com>
References: <20210115165012.1260253-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Interrupts that occur in kernel mode expect that context tracking
is set to kernel. Enabling local irqs before context tracking
switches from guest to host means interrupts can come in and trigger
warnings about wrong context, and possibly worse.

Cc: kvm-ppc@vger.kernel.org
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 6f612d240392..d348e77cee20 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3407,8 +3407,9 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 
 	kvmppc_set_host_core(pcpu);
 
+	guest_exit_irqoff();
+
 	local_irq_enable();
-	guest_exit();
 
 	/* Let secondaries go back to the offline loop */
 	for (i = 0; i < controlled_threads; ++i) {
@@ -4217,8 +4218,9 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	kvmppc_set_host_core(pcpu);
 
+	guest_exit_irqoff();
+
 	local_irq_enable();
-	guest_exit();
 
 	cpumask_clear_cpu(pcpu, &kvm->arch.cpu_in_guest);
 
-- 
2.23.0

