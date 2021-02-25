Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190B83250C8
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbhBYNsn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbhBYNsn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:48:43 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8088C061788
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:02 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id l18so3562155pji.3
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kbXDPVn/6/K9PcQafkWtS0R94LJwb94j0RZ+KsMZVko=;
        b=cZG/TmfIJYP9ySL3cURRthWTojPynINIW6XqbZoJb+2omF6EgjZKQ61a8JJDuzRdnr
         x2VV63vHuuObIA/2cChPJyXmZZdlz3zssKpWwv1u+BBAa9OZ/ekPV4Z22dy4TZ7xe4Op
         RjENg68UGSrRwE+0RTXgFnQVRzkJfLx/3rgCHv/wI/fphgGFf23U+7MJcxCEvgIkQ+PH
         iKC1pb7XyL7H9L6eiCAoow9XILu+EUvmCmqRWRLjMJYTkISODOPcg9BEXkh3VKv0FwSb
         R0BI91c1vvduiIZL4dbjl2hXPCWQ2qmgPhskY0/NSBe7/Ux2aJtfIxt2KqJOldHHi/ur
         DAMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kbXDPVn/6/K9PcQafkWtS0R94LJwb94j0RZ+KsMZVko=;
        b=gALVSzJsrVxYToE+vytk/T+5QC6eYw+GWveu6uowHpV7ZNo0x0pMK+NRvua8M2GulY
         jxRXGe24DzRjZk7JQ7Q1m83GSrjz3VfZaKYbDcVmZaW6iuh8U0Ok8f7AvvslyY5lylq9
         wFJkZQkDYSqJAqUWv4dYtMK6Zmc56SzStqaFKF3nNuyJsRWhQY6jW0RN8bw7TCPGnjcq
         9if9jRvcj5Xum7Y5O6kPemp9CdMJzvqfXmF8iGLqDvBLnLDJ/FaRFa7U81ze0l7WK0tC
         dNJSE82MMFD9IAeFVAxebsw9llGpfYhw9HEcAEsGgmtUVgG8YWLAIeVeKnFea9tJeH9d
         csXg==
X-Gm-Message-State: AOAM531dA128QlB2E5UjGv2Yllz29Am60ST5PtkJihf34EUGXiNE8Q+q
        0NePpfiOn3BnsXJpxzlR1Eg/PMJwI/w=
X-Google-Smtp-Source: ABdhPJyc5gaQwKOIAt8FWXSy3UqBYnhW/0DQWRY2+1dIg+EUjt5VYmoWzjive5AP27muZzAdO2kOfA==
X-Received: by 2002:a17:90a:7f87:: with SMTP id m7mr3354890pjl.64.1614260881707;
        Thu, 25 Feb 2021 05:48:01 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:48:01 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 17/37] KVM: PPC: Book3S HV P9: Move setting HDEC after switching to guest LPCR
Date:   Thu, 25 Feb 2021 23:46:32 +1000
Message-Id: <20210225134652.2127648-18-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

LPCR[HDICE]=0 suppresses hypervisor decrementer exceptions on some
processors, so it must be enabled before HDEC is set.

Rather than set it in the host LPCR then setting HDEC, move the HDEC
update to after the guest MMU context (including LPCR) is loaded.
There shouldn't be much concern with delaying HDEC by some 10s or 100s
of nanoseconds by setting it a bit later.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index d4770b222d7e..63cc92c45c5d 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3490,23 +3490,13 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 		host_dawrx1 = mfspr(SPRN_DAWRX1);
 	}
 
-	/*
-	 * P8 and P9 suppress the HDEC exception when LPCR[HDICE] = 0,
-	 * so set HDICE before writing HDEC.
-	 */
-	mtspr(SPRN_LPCR, kvm->arch.host_lpcr | LPCR_HDICE);
-	isync();
-
-	hdec = time_limit - mftb();
-	if (hdec < 0) {
-		mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
-		isync();
+	tb = mftb();
+	hdec = time_limit - tb;
+	if (hdec < 0)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
-	}
-	mtspr(SPRN_HDEC, hdec);
 
 	if (vc->tb_offset) {
-		u64 new_tb = mftb() + vc->tb_offset;
+		u64 new_tb = tb + vc->tb_offset;
 		mtspr(SPRN_TBU40, new_tb);
 		tb = mftb();
 		if ((tb & 0xffffff) < (new_tb & 0xffffff))
@@ -3549,6 +3539,12 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
 
+	/*
+	 * P9 suppresses the HDEC exception when LPCR[HDICE] = 0,
+	 * so set guest LPCR (with HDICE) before writing HDEC.
+	 */
+	mtspr(SPRN_HDEC, hdec);
+
 	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
 	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
 
-- 
2.23.0

