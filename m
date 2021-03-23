Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E59345484
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhCWBEu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbhCWBEc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:04:32 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD80C061756
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:28 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id a22-20020a17090aa516b02900c1215e9b33so11433720pjq.5
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R+RBK5Wp2FbOLAF9RxuzFwJgi7lrOETPRx1F7UbJZI8=;
        b=qOZDoJN30FiMNb2d0dJip1qgpjEGvQ8z7IjDdwguu/vGI1BcfXfCsslGUnkpH6w9bs
         4vWgczq1+f/Z29exaAO0KdZPtSy0XekeGlMSaooObecU0GFWNKsHJ8l7PwH5TB8sC5vb
         OQ6o8ABQ5+/buGOhX9h+T0IW1zkeUp84tivZBxEICMZa1hVRcLSKb6q071LvO1J5Z+0Q
         Z+wuSzhZGLIcgmd37hzjPBo9bPNPp4QmP2163U/pL8K9qFPJ0p+W46VsnqCGxgUAI1Hw
         /HlwxY/lqjOpXjmdPK889leTaX7xnPpEdCg6jgCCan/vkqjIFb+uUriG0KOHaUH0NIMN
         StZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R+RBK5Wp2FbOLAF9RxuzFwJgi7lrOETPRx1F7UbJZI8=;
        b=dcyDvtoTOzs/bLCUmOhM00ReT8atrmS1P9SnYNwHIgbkOmNhb6Rtg1nRvo4ZjY2J2L
         FcerR3nQ2xvT3Nfhnoa1ipVFU0/W4CPdu9DzpzYD42+J0TRngR02Bo5xd4ygY0Ot+Ybl
         +cfsY9h4E4wcuqYK4zaORQScc2QyebiMDhDxz2IQj8MAYDG1kQe5WDn9b7YDzfbXtnZl
         A1FGyeTbbIJDVMme9p4fUa3odfb1AF9np7gW+AbhWRiNKK5nsUNdgnB4hJemEeSXpo/s
         XTDfDPAZBqXQvXf+WQ8ctvZ7Z7DlmO7UBVQbML/NeA+pJSMI+T1CFFEMEAW7aujAjgi5
         GuEA==
X-Gm-Message-State: AOAM531RBsYg9+D4nuEkCUlSSIypz17mQZw+lYRhITx+/h82YX3chw6Y
        XNfjJti2LRGPjvZZtIwgVhCruJLyEkg=
X-Google-Smtp-Source: ABdhPJzQ7LzQaiOb4v6RfX3ok6MJKTVncrPs9yIekTG23t9fpsEwvB2iQiTk5fxImVlPO9mr/A6vUQ==
X-Received: by 2002:a17:90a:a513:: with SMTP id a19mr1880824pjq.210.1616461468167;
        Mon, 22 Mar 2021 18:04:28 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:04:27 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v4 23/46] KVM: PPC: Book3S HV P9: Move setting HDEC after switching to guest LPCR
Date:   Tue, 23 Mar 2021 11:02:42 +1000
Message-Id: <20210323010305.1045293-24-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
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
index 17739aaee3d8..8215430e6d5e 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3540,20 +3540,9 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 		host_dawrx1 = mfspr(SPRN_DAWRX1);
 	}
 
-	/*
-	 * P8 and P9 suppress the HDEC exception when LPCR[HDICE] = 0,
-	 * so set HDICE before writing HDEC.
-	 */
-	mtspr(SPRN_LPCR, kvm->arch.host_lpcr | LPCR_HDICE);
-	isync();
-
 	hdec = time_limit - mftb();
-	if (hdec < 0) {
-		mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
-		isync();
+	if (hdec < 0)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
-	}
-	mtspr(SPRN_HDEC, hdec);
 
 	if (vc->tb_offset) {
 		u64 new_tb = mftb() + vc->tb_offset;
@@ -3599,6 +3588,12 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 
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

