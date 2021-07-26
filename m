Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3F93D51B5
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhGZDLF (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhGZDLE (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:11:04 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE49C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:33 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id e21so5526606pla.5
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3EPodwAY04xAoBbUr0lK1mnu3c10gNvTZRm9usPrYgg=;
        b=L4k3j5Dp6o7T71/jhIrr7oSzW9uROFemXyfUu/avw1s4K6QadE4NS6lf4IbtDRhCoQ
         SKNp2Tdz3f1oGUZE/hXPX+uENx5dnXf4WUS/gNJ4w8ZywCvxGsH3hEYo0cw2WUD9QXxb
         Uf4RKznOSArw6xMXW6jCOTUvvT/fyul3ImbUePg5bt85uD8AhKPn7E8vITIEsmq0+Ofe
         N3AyEXisbbIZRiKCSdE+wxFkQ19UlEhGiWA3eZRhKHZhdyFxxLoMM1O2XYEOUw4HGIeu
         dgc2+tY1G0PHMkCywQptVvw3MSDnCum7n/hoANT4dl7BGNHhZodrC3LjVw1ofYb4UXNg
         O2Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3EPodwAY04xAoBbUr0lK1mnu3c10gNvTZRm9usPrYgg=;
        b=B8oaCzfSm5q9ppFY554yqYLUImRPP+KgqiEpfeGHHLnRf9wCDtIAp/qL0G3hgyYXh5
         PwZ6cWaCgQPQuctasFq5YwCfZYdyTbTPXZzWUgW3bl8SgSU0cSg1QVW/PKbOQV0q3C1I
         L2AGYXVpLtST7L2Ec2QyryXNdEpp6g0LEh8yIDjJZAkVKPykake6H/F04OgjdkIf2cn8
         bkIHhb/WM4pXESkoNSDnvsHxsyeZFu6kwL3J3q/iTF3//QqiDWDivR27iOcO7Yz/cOeB
         b/OTr+GsE0A/120oELSWB8WBzKhRFdRX6qpRXvvrMo5eE2IUBeBM0Kc2XRMmx2t+gEbN
         Qa7w==
X-Gm-Message-State: AOAM532YCJw7Mc4eg4aE9CukZUROZZMkyN/W0bJ/cbNu3HETPbYKnifa
        hdzFxWBL3yio5H/0Zz2kSboEflqV244=
X-Google-Smtp-Source: ABdhPJylr8Y1mDqJPxXyJH8MJieXqvQy65R5784ZTRSdS5SquIZmSZAh/czNwnmyPbehP0baKjar9A==
X-Received: by 2002:a17:90a:19c2:: with SMTP id 2mr15305821pjj.233.1627271492764;
        Sun, 25 Jul 2021 20:51:32 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:51:32 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v1 20/55] KVM: PPC: Book3S HV P9: Factor out yield_count increment
Date:   Mon, 26 Jul 2021 13:50:01 +1000
Message-Id: <20210726035036.739609-21-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Factor duplicated code into a helper function.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 7c75f63648d6..772f1e6c93e1 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4081,6 +4081,16 @@ static inline bool hcall_is_xics(unsigned long req)
 		req == H_IPOLL || req == H_XIRR || req == H_XIRR_X;
 }
 
+static void vcpu_vpa_increment_dispatch(struct kvm_vcpu *vcpu)
+{
+	struct lppaca *lp = vcpu->arch.vpa.pinned_addr;
+	if (lp) {
+		u32 yield_count = be32_to_cpu(lp->yield_count) + 1;
+		lp->yield_count = cpu_to_be32(yield_count);
+		vcpu->arch.vpa.dirty = 1;
+	}
+}
+
 /*
  * Guest entry for POWER9 and later CPUs.
  */
@@ -4109,12 +4119,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->entry_exit_map = 1;
 	vc->in_guest = 1;
 
-	if (vcpu->arch.vpa.pinned_addr) {
-		struct lppaca *lp = vcpu->arch.vpa.pinned_addr;
-		u32 yield_count = be32_to_cpu(lp->yield_count) + 1;
-		lp->yield_count = cpu_to_be32(yield_count);
-		vcpu->arch.vpa.dirty = 1;
-	}
+	vcpu_vpa_increment_dispatch(vcpu);
 
 	if (cpu_has_feature(CPU_FTR_TM) ||
 	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
@@ -4242,12 +4247,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
 		kvmppc_save_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
 
-	if (vcpu->arch.vpa.pinned_addr) {
-		struct lppaca *lp = vcpu->arch.vpa.pinned_addr;
-		u32 yield_count = be32_to_cpu(lp->yield_count) + 1;
-		lp->yield_count = cpu_to_be32(yield_count);
-		vcpu->arch.vpa.dirty = 1;
-	}
+	vcpu_vpa_increment_dispatch(vcpu);
 
 	switch_pmu_to_host(vcpu, &host_os_sprs);
 
-- 
2.23.0

