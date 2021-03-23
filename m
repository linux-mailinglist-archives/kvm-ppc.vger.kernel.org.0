Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94854345472
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhCWBDp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhCWBDe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:03:34 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB2BC061756
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:03:34 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 11so12532070pfn.9
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=96lVEMoY9hmNRY65UX3KaQpv8EehCYA8LF4BBDNeARg=;
        b=iSK4Rha4ojQO3w1SlTqJyLAZThuuX0MD2SeDxkMMa5SyRmgHPv3iBkYCzlfYbiXHap
         4W6LWw3i/tEZ80AXYb8vhj+z4OIw/2cHoNhgnvREZ6nI3HyYkmdU0+YN9LvnGRrXDZTc
         FxIEzDV3Q/504Hmz2gSgDVsxWLtCn9a2wW0Czckaa2Oi/pZRHkoimiOfAOzWBqEKM+lL
         9M/HrVUbOMfjB3YR5toJT7fDMxSMAUyWYS33gp+alUPVPNmCYnkh+ow4UGd/Dm+Vyl14
         feNPyZSeEB4EDqaUvi5/R/YF8Y25mCX3tArhFDkSGaLmabnUiaoUZAY7+NcGPrXyt1+s
         vMwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=96lVEMoY9hmNRY65UX3KaQpv8EehCYA8LF4BBDNeARg=;
        b=DgDM8zuVcJnyRB1IHA+nNZEOt8TmYMhHNTNxKdO8xzUAGv0hnGYMzsuXHJfKyrZkXM
         aNY2BgVfnKatM2wQMhM7dSRwMfBfTIhR8uhPeU0hLi0PsVL8ik0zhezLzIBhXSWAqwLC
         +ZmtLYDoYVaWGW9f4cXIbmWXAtoGbX9m6nZx+ZJy6S65P1EDWmAC86zu/BOOvub15etf
         oQF7hSdw4goloweytiglR4nO5ljbQZ6NqU4jF1grAWGiAoj+7gS+CmMqU2iA6eI14wup
         nZSrznt8DGZORsmaVEF2PBMIzbqzFm1qLXoZM5i51BrVrMxDpg8KNkjq9M+AtP22qx3f
         Qtpw==
X-Gm-Message-State: AOAM531ktf5B9KVUhkZkjR8Vrrqk+0kj7uQsfmbyH+mBCyU296gwA8tC
        Bl/XuJALe3TIWM+48UCY2//HBoCPWe4=
X-Google-Smtp-Source: ABdhPJwHaxaBbEuGdovpRjVbFcwmJA1YSF54aKN3EmfRzan+E5ppcHdiDa0PBOZV7uXBrp6yGDN3Rw==
X-Received: by 2002:a65:6a44:: with SMTP id o4mr1802492pgu.312.1616461409541;
        Mon, 22 Mar 2021 18:03:29 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:03:29 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 04/46] KVM: PPC: Book3S HV: Prevent radix guests from setting LPCR[TC]
Date:   Tue, 23 Mar 2021 11:02:23 +1000
Message-Id: <20210323010305.1045293-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This bit only applies to hash partitions.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c        | 6 ++++++
 arch/powerpc/kvm/book3s_hv_nested.c | 3 +--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index c5de7e3f22b6..1ffb0902e779 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1645,6 +1645,12 @@ static int kvm_arch_vcpu_ioctl_set_sregs_hv(struct kvm_vcpu *vcpu,
  */
 unsigned long kvmppc_filter_lpcr_hv(struct kvmppc_vcore *vc, unsigned long lpcr)
 {
+	struct kvm *kvm = vc->kvm;
+
+	/* LPCR_TC only applies to HPT guests */
+	if (kvm_is_radix(kvm))
+		lpcr &= ~LPCR_TC;
+
 	/* On POWER8 and above, userspace can modify AIL */
 	if (!cpu_has_feature(CPU_FTR_ARCH_207S))
 		lpcr &= ~LPCR_AIL;
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index f7b441b3eb17..851e3f527eb2 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -140,8 +140,7 @@ static void sanitise_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
 	/*
 	 * Don't let L1 change LPCR bits for the L2 except these:
 	 */
-	mask = LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_AIL | LPCR_LD |
-		LPCR_LPES | LPCR_MER;
+	mask = LPCR_DPFD | LPCR_ILE | LPCR_AIL | LPCR_LD | LPCR_LPES | LPCR_MER;
 	hr->lpcr = kvmppc_filter_lpcr_hv(vc,
 			(vc->lpcr & ~mask) | (hr->lpcr & mask));
 
-- 
2.23.0

