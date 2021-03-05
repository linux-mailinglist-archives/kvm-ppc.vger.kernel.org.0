Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD62032EDD5
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhCEPIO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbhCEPH4 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:07:56 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163A1C061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:07:56 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id p21so1562841pgl.12
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kQ3/M2pAv7d1Wpqn9zaXNomJqAHRErrNglb/BiHoKmY=;
        b=bolL2wY5wK2mZH94RhDD72Y/iJHKEqk30tF0KlkrHNiJwvXnCJKqm05YsxMYVtfpQG
         ssclPQeUFV8S7nhz4M8afSEI4rzQgVrB2KURUD/191uyuVfr+rkhZ2sPbMEPgtOT/f8c
         ehf2pFzPYm9WvRMW0WSzDQtareSS8kUt3dAYH4shNAqAchnrwMTOHCw70+wMV7fef9rz
         Cobycxvzg/Aypc1xQ0DnW1IpseNz/pOJRRm1Cv5SOIcserVm3j9Mgo7RvePmzHOrCwSJ
         Gp5dryGySp8Z1y9/Vfa9OpN8BhjvyLL35NqKMYNGm/FHSDE9FoxsnF3PJtcoZWHVQQum
         XA1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kQ3/M2pAv7d1Wpqn9zaXNomJqAHRErrNglb/BiHoKmY=;
        b=YULG3iLvKkGFV9E5FB9rbJ1nUCf8HOak8+eQ5fq/Al1LLHEt0RGb9x8/ujibMmz9rt
         byA9dFkIwkBRvDrfyyqyX4KeoGUPAcdHIiTjon3bawPpsLy8ZssavHQTVR6WQSDNExzs
         NQNOr2HmuwVIF8ocCEC8IpLfKCfVBnUvbfmLDIPpQgFuV4uf8mW3l2YDvsT4IDSO4RKf
         bJuSs2CH2/cjEqVIXYXsZipB5eOkOOD/Vb/jEEDx9W+4pWVb/zsrsRgZI9dN+Efl08P1
         f9AOLRxWeI3CEw8sLBLVyuDctDE/64q5UUKZDymk8t+E/EKXOiEJ+LJpwcUr0Q6tG9Rj
         Q9bg==
X-Gm-Message-State: AOAM532dK4l1rCPiIEijh4Tlpg30ue7lUuSGuB3EVyHzEBUefl5Uy/Au
        FzuGqezuIuGkpwS5/WpJyU28dZkZb2k=
X-Google-Smtp-Source: ABdhPJxW1J59E4vIIpJ2pB6l0t3RwysNthEwiN9dw/x43lfNUpOYvOoa1CsoqTVfXdzr+MoRICyWEw==
X-Received: by 2002:a63:50a:: with SMTP id 10mr8923239pgf.89.1614956875270;
        Fri, 05 Mar 2021 07:07:55 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:07:54 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 20/41] KVM: PPC: Book3S HV P9: Move setting HDEC after switching to guest LPCR
Date:   Sat,  6 Mar 2021 01:06:17 +1000
Message-Id: <20210305150638.2675513-21-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
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
 arch/powerpc/kvm/book3s_hv.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 1f2ba8955c6a..ffde1917ab68 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3505,20 +3505,9 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -3564,6 +3553,12 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 
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

