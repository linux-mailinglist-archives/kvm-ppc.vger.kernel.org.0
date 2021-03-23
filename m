Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA9F34546A
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhCWBDp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbhCWBDe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:03:34 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83A1C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:03:33 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 32so3910058pgm.1
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A/SnEbu0v05VvXraZOiAb1e9wcvWFKJdoZf5OUf6Yb0=;
        b=JuDOVyXU2df0CU3+R6S09KRDtVt/8n4GJK0Ch+5DH5ljnxTiVaS3sdai/S8/zQzkDD
         S/ovhELE/16rS+8eVkva1wf/zoK7PIBGgCokdzWtOtpe0eecheLJmvzcPboQHT155fQ4
         syVRm+RXb+pbaZjR1zC+DPni20iVW2uyH8o+qKlChvamO/vxebQbklnTuFVALfsqy+Cu
         zr4tlz4DAE4fYc6hBTIq0aWANeo3m/Vjq2xa7xa0N8QkhKqvKWPDFnUURVU6qHVRoHjS
         BXbiprbmUXW++Q9JDRcNfeCeuwsGUadw2PghxU/OceUoPoshiBy70vJ4HMZZYNIpkdhh
         uuMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A/SnEbu0v05VvXraZOiAb1e9wcvWFKJdoZf5OUf6Yb0=;
        b=GVR9IXYzS8iFpkMEHzC5GN2EFfhRkDbEdZM7e3Ttrmwlfk/TZM8x+tviXJ6vz4EBrF
         Ap+WRoqwydsRMmH6yK0o90xlFTxlQc8zDRlUvJYyb13EFYGBtWfBybeCBnG0Zq5HbXlr
         clFzZ3sdXuqcSbWajfYEjJWiMhhZAc7xAUN8DamBFSyNzxd6z+bn8qv+E1xiUpNrbaAX
         4dM2cnw4gw7heTxELdpDqjUN2f5zG9lgdOlz6nHjdUbmzPsS3MsNuh2dOqgr0RXH9lOs
         XRHCsl/jO/O1qw2LPPB5RRz8yY+EqhVwCaRr1ax/mMZ60Qu99hR0D7jIeXAhN+K+cp5Q
         7CrQ==
X-Gm-Message-State: AOAM530lorUEscwmekV3T1YvAYjuqaZ1m1Vqel2uANd12dPlUjA5P0KH
        aeD1AqDfoRzz6WBvIzupJD47K7Z88gE=
X-Google-Smtp-Source: ABdhPJxqJvrbrlx/7iCJz0s11fRARFxYLUUGvx9PFsEE91s5bQ+/yI9/oWpFx6L+15k1SwL7NpEifw==
X-Received: by 2002:a17:902:c9c3:b029:e6:f027:b01e with SMTP id q3-20020a170902c9c3b02900e6f027b01emr818869pld.74.1616461412848;
        Mon, 22 Mar 2021 18:03:32 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:03:32 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Daniel Axtens <dja@axtens.net>
Subject: [PATCH v4 05/46] KVM: PPC: Book3S HV: Remove redundant mtspr PSPB
Date:   Tue, 23 Mar 2021 11:02:24 +1000
Message-Id: <20210323010305.1045293-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This SPR is set to 0 twice when exiting the guest.

Suggested-by: Fabiano Rosas <farosas@linux.ibm.com>
Reviewed-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 1ffb0902e779..7cfaabab2c20 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3781,7 +3781,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	mtspr(SPRN_DSCR, host_dscr);
 	mtspr(SPRN_TIDR, host_tidr);
 	mtspr(SPRN_IAMR, host_iamr);
-	mtspr(SPRN_PSPB, 0);
 
 	if (host_amr != vcpu->arch.amr)
 		mtspr(SPRN_AMR, host_amr);
-- 
2.23.0

