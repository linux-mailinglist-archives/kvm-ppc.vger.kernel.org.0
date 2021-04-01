Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793DE351979
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236102AbhDARxq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 13:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237381AbhDARvi (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 13:51:38 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E1DC0F26EC
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:04:43 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id q5so1660131pfh.10
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c0MvDZ1F9X/SZ94TT66c0+OApX1YU3GVKikmjXf/RuQ=;
        b=QDrbaKKl4WJo116T3m5J+nThsFCCAJjbD08Ya/KCo3bhZr+RUNprwOenBM+8uA+h6W
         CLBaueG1oeu71aqam273bP/zbIuwLvvRd/QwThvZMYnol/TNSAozWKQV0ss1bnU3h7Gw
         Z1yF+oMMZxWXXK1HvVlkFHGZeLztPzKAbjpgS+gxgUj3G4A+1/GG0y103ux8ukXEqkDg
         q6jUY54mGVXL6W8sMKcvMCvuqbKnEIEgsoatjk/SctwypEHwJq+s3ZZJxMaFCrLc3g3v
         A4nFlNRTwp5P82bnJsARO6GX+i2nWdUAGxHBwKjRzM+89ibwcxdLVar/BkKkbgj2x1oZ
         aFQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c0MvDZ1F9X/SZ94TT66c0+OApX1YU3GVKikmjXf/RuQ=;
        b=JP1Dvxathguk7h23ndxYPb1GNQGyGmEO3Mp0JEcmYEam9zMAPYqhI1EngN0X+CztJw
         qhjx5O+0yEe8o1zq8j9TwSVR+3krQhpkODVpUdLrURUN2ktAz3oTVYNHiEkIszALSCNR
         jZFxddW362ty4b6lxE4MtgEuZTvVzr9vdiR7dY/Axdsb5bFD9KqNyHe6uBMUMB/FrgF4
         nqYF+/BqTry4qTjGX29KAA2QtbbLCDtO96PacHGfVlNuI1xQ+Ole8q2Fc9bUS3W7uX3q
         YE3DktASYEO7c6npMEFGgd26R2U5HNbjqOuigE20UcJOK3xisyElQ6MOImTe3v48Ocwj
         OpFw==
X-Gm-Message-State: AOAM533dPUuhihb4Q1lbVEExzWnyix6/AVaRIurkUskNyFRbob0Yh4U3
        nfNSN2364klfO626GdZ0SrxnWW+IFLI=
X-Google-Smtp-Source: ABdhPJwoe9nt/y+HVSAP7R7a6fwU0KO2dPmkum/E2dxR1CHVvxDjeD2Hs+X2glI01g4qufvlQHqo3Q==
X-Received: by 2002:aa7:9687:0:b029:22e:e5ce:95b6 with SMTP id f7-20020aa796870000b029022ee5ce95b6mr7902473pfk.53.1617289482652;
        Thu, 01 Apr 2021 08:04:42 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:04:42 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v5 21/48] KVM: PPC: Book3S HV P9: Move xive vcpu context management into kvmhv_p9_guest_entry
Date:   Fri,  2 Apr 2021 01:02:58 +1000
Message-Id: <20210401150325.442125-22-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Move the xive management up so the low level register switching can be
pushed further down in a later patch. XIVE MMIO CI operations can run in
higher level code with machine checks, tracing, etc., available.

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 6ca47f26a397..2dc65d752f80 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3598,15 +3598,11 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
 
-	kvmppc_xive_push_vcpu(vcpu);
-
 	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
 	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
 
 	trap = __kvmhv_vcpu_entry_p9(vcpu);
 
-	kvmppc_xive_pull_vcpu(vcpu);
-
 	/* Advance host PURR/SPURR by the amount used by guest */
 	purr = mfspr(SPRN_PURR);
 	spurr = mfspr(SPRN_SPURR);
@@ -3789,7 +3785,10 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			trap = 0;
 		}
 	} else {
+		kvmppc_xive_push_vcpu(vcpu);
 		trap = kvmhv_load_hv_regs_and_go(vcpu, time_limit, lpcr);
+		kvmppc_xive_pull_vcpu(vcpu);
+
 	}
 
 	vcpu->arch.slb_max = 0;
-- 
2.23.0

