Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0B735E059
	for <lists+kvm-ppc@lfdr.de>; Tue, 13 Apr 2021 15:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242681AbhDMNmz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 13 Apr 2021 09:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242387AbhDMNmz (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 13 Apr 2021 09:42:55 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CA8C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 13 Apr 2021 06:42:36 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 10so2575029pfl.1
        for <kvm-ppc@vger.kernel.org>; Tue, 13 Apr 2021 06:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aIFXl4n2S7P3tkdBMKDpSD5hoW2eh9a/kOWHPmLANoc=;
        b=a9hdC8gxYXkIUMjE7kaLVixRR+c2bEeHakuuhbRFTO2Rhbi2O2RB4J2ObLCP5vvVv6
         NM5vghhwr/RqnXYXAtgNy/NTcYW7Bl2pz+Ztu+CPDlLgzbF4AQ/wPo5Ycbd3oJ4hpjvc
         Fc9GqjmXy2wBZb8QkgregjWl8Oj6BBZjCHRyddiYQjxq7WS8DV7vJR0Ea2dvRo/z6mBU
         RM4Xrwk1Ndm6u0f1bxqZKCEgXMEV4mqZ27bAt3SN9w6WJ0smF47AnW4TgGhreK2vq3mx
         meSCdejdPYDo3X9ad1LFE1SaPmlD5ktk40zFXep46MlkV7y2+bW3ryeQwKuzi4+xYEKL
         Y3Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aIFXl4n2S7P3tkdBMKDpSD5hoW2eh9a/kOWHPmLANoc=;
        b=VCdkgO9Phh8fbixoC7wh/KNP94QAo67UaQfXg5hE5/dFFJHLI7+vjAjMZhHMAsllpg
         RQ/JYDci6VywpKTpQV3LJ4hltfFdZuTwiAml6YrUzLC93atzKtTdlHlXe4WZQXy56hOb
         6mAjF2D0oG338++FUIhpxK726MjlJBPA3jZNxGh3/RTp/YKUcECjZYvdApJ5e6TC4cuh
         lB3Qhlh+D0B07SIH5spAtT6Oxcr86jRrXIkQsg7bEOpmeGJ5xIRHCO9fsU1+4u6GBpUh
         Y2BiXEJIkmqf4wmWXqyvgq7mwcpzVeHHlTtYkPxli96vIrCSzxXRifnZWlMxOiJ2+K8F
         uWvg==
X-Gm-Message-State: AOAM532ipy0rTJtJOaxTlvkaVqwCiwz/t33KB+tvZKU5wMv3e6Qtqumc
        QdzxqhHduVlZmZDmtMVsMCQzPM40dlk=
X-Google-Smtp-Source: ABdhPJyX1Q/bskGNFB2AqhCSy8C2F6XutdV4ZJZ16AVWY0/DeH3YKBgzlb6lwlP6pNHfxWTALbgmcg==
X-Received: by 2002:a63:d810:: with SMTP id b16mr31024741pgh.72.1618321355531;
        Tue, 13 Apr 2021 06:42:35 -0700 (PDT)
Received: from bobo.ibm.com (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id l22sm100465pjc.13.2021.04.13.06.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 06:42:35 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v1 1/2] KVM: PPC: Book3S HV P9: Move setting HDEC after switching to guest LPCR
Date:   Tue, 13 Apr 2021 23:42:22 +1000
Message-Id: <20210413134223.1691892-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210413134223.1691892-1-npiggin@gmail.com>
References: <20210413134223.1691892-1-npiggin@gmail.com>
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

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 981bcaf787a8..48df339affdf 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3502,20 +3502,9 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 		host_dawrx1 = mfspr(SPRN_DAWRX1);
 	}
 
-	/*
-	 * P8 and P9 suppress the HDEC exception when LPCR[HDICE] = 0,
-	 * so set HDICE before writing HDEC.
-	 */
-	mtspr(SPRN_LPCR, vcpu->kvm->arch.host_lpcr | LPCR_HDICE);
-	isync();
-
 	hdec = time_limit - mftb();
-	if (hdec < 0) {
-		mtspr(SPRN_LPCR, vcpu->kvm->arch.host_lpcr);
-		isync();
+	if (hdec < 0)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
-	}
-	mtspr(SPRN_HDEC, hdec);
 
 	if (vc->tb_offset) {
 		u64 new_tb = mftb() + vc->tb_offset;
@@ -3563,6 +3552,12 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	mtspr(SPRN_LPCR, lpcr);
 	isync();
 
+	/*
+	 * P9 suppresses the HDEC exception when LPCR[HDICE] = 0,
+	 * so set guest LPCR (with HDICE) before writing HDEC.
+	 */
+	mtspr(SPRN_HDEC, hdec);
+
 	kvmppc_xive_push_vcpu(vcpu);
 
 	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
-- 
2.23.0

