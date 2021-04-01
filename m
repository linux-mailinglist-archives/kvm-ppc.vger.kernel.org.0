Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B383351839
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 19:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236313AbhDARoT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 13:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234837AbhDARkl (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 13:40:41 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A02AC0F26EF
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:04:50 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so4860031pjb.0
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/wOLBycO7ANmZmJ1hyUAWBGRDu4iKrKXe/fsD7uKbxk=;
        b=dJBI861D3Ep/GuWZfpznMlvaWij/Rgyg6EDvbH8wdBQgeIs7adD0KT8TpCSr3MGj1J
         fyyVd/lpecQl8h53SvLeyo+uupwDUEcOuSo6cuVKMWxXx62cuoq4GGXAqiQ5VhHO2q0/
         CPDfZTQHuu/jbkzRuuSZC+hhiKzxRrKZpb/fKes+HlaGybf+caytjNoNcYIyNSu04J8Y
         v3hTxCtx6QH2UAL1zGC7rcNpWNSh0vtbareDTt4yxGSqBuQmerGJRvp97qUeSzRl4f9g
         ZtsHkb+7GVpSQ/Y4SP/RmQ8Ap4PxYj51EqUzaELAzl3RqK/VXH+QIakzlKPeb14kPT3D
         8hhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/wOLBycO7ANmZmJ1hyUAWBGRDu4iKrKXe/fsD7uKbxk=;
        b=aQVs458GH2aAguVaXIU/BR+oE5sF13dKn4q5xtDZ+oVjB1xKLAQRNww/tsbrb7/FUZ
         lJzOgqYxPTcCRKQiJIOiesS86JDyhkHFo1P5+xm0OvjUAL6+E5agQUKDG+SxEWEKYgfc
         lmloZl9cPJmzAIJX4MydA2IyvIrUe979MMsur8IDHrvSvXx5h46yiETljwaUi4e4tpdw
         T1LEkJ4kqfe+1ye5ehcaLRuPVkS8hrRe9lxpddTZeQuyCQ+MhhGYqi+1nSqaoP4UJSk6
         Iou8ajf0YsvLIo2oHk3E/jGo8p7YjlAyQ4JkO7SZWN6p+PNbhDP4IHNDuCcpibd/vxyp
         onoA==
X-Gm-Message-State: AOAM531xUVr+TLZjrfPSoakJRq86nZca++tHOiOOuUwCDZVDwYZIErcm
        3AOSqQFOjpSK/91pJjzEiUcLlpiat/U=
X-Google-Smtp-Source: ABdhPJwI7NGzR3SPRUV/+jaX2KQCXxZkjEKdSbn7D6dHHsiREg32Qe1nA8sWnaBbMg847j91NHOBMA==
X-Received: by 2002:a17:90a:8a8b:: with SMTP id x11mr9213247pjn.151.1617289489480;
        Thu, 01 Apr 2021 08:04:49 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:04:49 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v5 23/48] KVM: PPC: Book3S HV P9: Move setting HDEC after switching to guest LPCR
Date:   Fri,  2 Apr 2021 01:03:00 +1000
Message-Id: <20210401150325.442125-24-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
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
index c45352fbc25d..c249f77ea08c 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3551,20 +3551,9 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -3610,6 +3599,12 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 
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

