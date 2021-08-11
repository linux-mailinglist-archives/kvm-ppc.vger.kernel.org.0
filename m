Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8853E9559
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhHKQDZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233639AbhHKQDZ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:03:25 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEBFC061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:02 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id oa17so4225327pjb.1
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YG43b2W+WoOa/mX7jhMUWZGR+grphI4ggOCmMv7FBAk=;
        b=hSIw1UerUdjTWk5TlQspyucFFJ7sfWEWHYe2rpzn7bFT6wos1pT94pr7kBjamtyrrr
         XfjceckV3iOU71r5CJ4muwZbxfDR9hPDvtYzmd4PFqHGiojsQkq0t5KlMv0aNwyMj6Ko
         7iMHvVuIRTywrqtHTuTsmZLa7nqcEvRfhpGBejnVKVoMKyScGBuSl1TQ3aeFl6PVScdu
         YcaGCVvztOij/RKZ0Jsd0tZuG/Jz4Sec8Ow/1SkdYRMpOXJA7jy0K90Wj47fEF3lKMPb
         wBuO0KmKN94M9/z/pX58jgLrD1ffc+DCVkx5jTtTYkzCaNkkhGnoMYpMkXYPNrz5Nm1D
         eJSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YG43b2W+WoOa/mX7jhMUWZGR+grphI4ggOCmMv7FBAk=;
        b=jpSjDdGUQ0QRFvJzD82nyx4813C61IrQ9G83ueiIBysio4EwxN3ixze5XyKPiCzf5v
         mgcx+WmNfLN5wmT196zMIFRYVWHseqk7VkZSjwy7gzjJ3c55DHL8FWFNYP90j0ueQjBV
         FG6zoFhIVtLXIeTHVAQnCl9QwE38T6WLy2l8uHkxacnCSlhYgswUmOP5zi9oRgXQ5srW
         WcvMIzruiW7LapwSpi9Xc5yE5a+CHQFHiBSWYgIP0Y1nJYzkdv1ZyHzpZwHOIwTiXZl/
         OoD3OIapnQO9fAh8TfdhHVxTH+v1/4qtyU2rlythwfcW/+4F1A5Hx0pS0D1ESyZz1/rQ
         R4qQ==
X-Gm-Message-State: AOAM5322SDdCFw5xxZBh86VKdI0MNlBLWRWoWDUKDXd1+ToO1aHWxUOJ
        WWxdpF9D/9E34dRnJtkX/mF1Qosxb4Q=
X-Google-Smtp-Source: ABdhPJzJYNPIqFkRKx0725GrTNxMOhNWPKDF8yupEL2kKHem8uRusSiWI92yY6h2mOTEeZMGuZr+Pg==
X-Received: by 2002:a65:448a:: with SMTP id l10mr718362pgq.313.1628697781369;
        Wed, 11 Aug 2021 09:03:01 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:03:01 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v2 29/60] KVM: PPC: Book3S HV P9: Add kvmppc_stop_thread to match kvmppc_start_thread
Date:   Thu, 12 Aug 2021 02:01:03 +1000
Message-Id: <20210811160134.904987-30-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
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
index 376687286fef..e25eccfe1501 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3073,6 +3073,13 @@ static void kvmppc_start_thread(struct kvm_vcpu *vcpu, struct kvmppc_vcore *vc)
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
@@ -4296,8 +4303,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		dec = (s32) dec;
 	tb = mftb();
 	vcpu->arch.dec_expires = dec + tb;
-	vcpu->cpu = -1;
-	vcpu->arch.thread_cpu = -1;
 
 	store_spr_state(vcpu);
 
@@ -4769,6 +4774,8 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	guest_exit_irqoff();
 
+	kvmppc_stop_thread(vcpu);
+
 	powerpc_local_irq_pmu_restore(flags);
 
 	cpumask_clear_cpu(pcpu, &kvm->arch.cpu_in_guest);
-- 
2.23.0

