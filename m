Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEEE73250D7
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhBYNtP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbhBYNtJ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:49:09 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E15C061356
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:12 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id f8so3216730plg.5
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5gBupD6w9IAV3hK4OXn3cqVs1/uQmmRToC//irklCQ4=;
        b=otc6vdNMX1R7wpi+EcZ6Sx/eMagFElg1z8C/hMvENJbfsoJiLAhL5xwPj8SfUnDy+W
         aY1OVgUMSruJ8aIiwH1p0tsLDQQrwXxFjbYjHWkWd+fjJxnSKkoNSZjqx/HjCAP2D35X
         ZjEKcid0iFjqrvMztOaDevAI2MgEJRv3m+WOn9j0x8sEj6n+uT+PZRN7BeiP6FDUQKbo
         EsdcsF/UTVK4qvvy5c9jNADiI6+zBA5wx2TM1h3YATs+IyB1i+tc+F1ScFXkdIMzsOvc
         JvbLWs3rJESGSXoCiHzOH40ijL+qUZ25IPJFtwkw4tt61odrQzzqMa32Fpnh8bJbURSy
         oyeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5gBupD6w9IAV3hK4OXn3cqVs1/uQmmRToC//irklCQ4=;
        b=K3bPvimTOxWlPlSqwEyFfB7zjPf8qTzIMbVx/R1oWGxjl5nRfuzE5AzeJjSBNq81EA
         zdDY1RB+VpOT9neeL6ALQ365nd8ghNCHp7h6GITWBZ2QfGYmtf0b9XaRUs/zRT2gq5Op
         2+WCAQ40FmQz08kzmcNDvnts+ujxoxbXA/WjUvPQR49Ftlm8AP/H3+2yuEBC38aA8U2i
         V7byz6wsblxCBaL2mQ3I4CRFqtg42NAIrJtmhR9d9sFgmGn7cqcCzKNxqqrZ+sSkTGFX
         ZBS9tcCISM5i84stX2yvrSo54H5tEFlyU1NFDFLYkjNAFC7ZxDSkK0sQTkvFz+cKzmzf
         O5fA==
X-Gm-Message-State: AOAM533STMkzCUY43Jc2u3UL7nPZAs4JH9fVc6BxW8+l7/pF0GxskCm2
        XQmdsIsH4Je8FDA/1AduN93GTW1+h/s=
X-Google-Smtp-Source: ABdhPJw55Z0GXGwEI7LASJoBShS68vWHDeVV6WM1gcGrjR0KrZyT0feHuIU12BgvwOse21jbUSEqfw==
X-Received: by 2002:a17:902:ced2:b029:e2:8db8:266f with SMTP id d18-20020a170902ced2b02900e28db8266fmr3008957plg.34.1614260891850;
        Thu, 25 Feb 2021 05:48:11 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:48:11 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 20/37] KVM: PPC: Book3S HV P9: Reduce mftb per guest entry/exit
Date:   Thu, 25 Feb 2021 23:46:35 +1000
Message-Id: <20210225134652.2127648-21-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

mftb is serialising (dispatch next-to-complete) so it is heavy weight
for a mfspr. Avoid reading it multiple times in the entry or exit paths.
A small number of cycles delay to timers is tolerable.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 735ec40ece86..d98958b78830 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3689,7 +3689,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (!(vcpu->arch.ctrl & 1))
 		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
 
-	mtspr(SPRN_DEC, vcpu->arch.dec_expires - mftb());
+	mtspr(SPRN_DEC, vcpu->arch.dec_expires - tb);
 
 	if (kvmhv_on_pseries()) {
 		/*
@@ -3822,7 +3822,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
 
-	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - mftb());
+	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - tb);
 	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
 
 	kvmhv_load_host_pmu();
-- 
2.23.0

