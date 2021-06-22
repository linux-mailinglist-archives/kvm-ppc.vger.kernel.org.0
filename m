Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF333B0203
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhFVLA7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbhFVLA7 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:00:59 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3A0C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:42 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id bb10-20020a17090b008ab029016eef083425so1485814pjb.5
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x0dmCYsk3isHrWBVd9EbNCHjQXM1SSzoE2891T24aTQ=;
        b=nXsy7rDk+i6FzKBhv/WpWQ0dGfEcplkfWDd5Dl6bCyN0GAe5EXq4QSZ1RwE1gOyAMo
         HkOmwiNd6zvcuVOt+tJnU2ZrD63n38CKoxMXkdsyfzZfTRwzJIAvQqNAPkZ5nsQRsdXQ
         fbeUQAiCIZgdA2389cACDgck2PO0v8Z4Z0PBs0VVcIH/d+xAJ59YzmGocNyYajrHA/HO
         o+qYtXZ/wclvkouhaq9rWayTKjlnHY0B0ZNnYzPIGVEK/DRXeuenQmx4I0lXZUqpfuU1
         sGmCgsIGj6xqoUdABIjW8jaBW28zGOMDlKUgSV4XsgkkwPEKvxgk4zxTNYZFxViWiLNC
         2oXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x0dmCYsk3isHrWBVd9EbNCHjQXM1SSzoE2891T24aTQ=;
        b=Ka5J9qI85/B5zrw5DJP7KpvjDP0/0bLZY/rNLDMr4EcaqrYOahHMgvgmSUCqR8r1OB
         koZdmGL+z5Fj4kn37o5Z8yrTVAl45Vl6HYAIownGXu49aIyo8az1rQ4U9v711h98Y2fI
         SNHOjldt++Dr2uyqHDEUsEcEuTEGyj/YT5fyZWqgY9NHAlDGzs7sBhagIVdcDVpyz2Kc
         cPCfuD2dxIEcSdoswq8+DsIGN9q3ezoC6vx3rLZXa8BsiJ1dg4+ixCdcZsEKMQS5sGwB
         CrEKfEz7/jfctyWwds2mABTCKiwFd5caHDOgoHzSAObGPm55NhUYyiZKNjDBRNFE7SCm
         zZVQ==
X-Gm-Message-State: AOAM533G/nENo/a3zf8sH15RtwEPgUr6tyuuzQtjN46acSHHa9QlYfMY
        p/p1HKRqShI+o3gHAT07CVHKb5FWVGY=
X-Google-Smtp-Source: ABdhPJw8xCm9//WytbwWWoOvZMoOdUfSDCugUNHUkbclbRRNYp+rsOgAWV4rphMV891Z4K06wEQtkg==
X-Received: by 2002:a17:90a:5998:: with SMTP id l24mr3205269pji.169.1624359522112;
        Tue, 22 Jun 2021 03:58:42 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:58:41 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 19/43] KVM: PPC: Book3S HV P9: Add kvmppc_stop_thread to match kvmppc_start_thread
Date:   Tue, 22 Jun 2021 20:57:12 +1000
Message-Id: <20210622105736.633352-20-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Small cleanup makes it a bit easier to match up entry and exit
operations.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index b8b0695a9312..86c85e303a6d 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2948,6 +2948,13 @@ static void kvmppc_start_thread(struct kvm_vcpu *vcpu, struct kvmppc_vcore *vc)
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
@@ -4154,8 +4161,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		dec = (s32) dec;
 	tb = mftb();
 	vcpu->arch.dec_expires = dec + tb;
-	vcpu->cpu = -1;
-	vcpu->arch.thread_cpu = -1;
 
 	store_spr_state(vcpu);
 
@@ -4627,6 +4632,8 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	guest_exit_irqoff();
 
+	kvmppc_stop_thread(vcpu);
+
 	powerpc_local_irq_pmu_restore(flags);
 
 	cpumask_clear_cpu(pcpu, &kvm->arch.cpu_in_guest);
-- 
2.23.0

