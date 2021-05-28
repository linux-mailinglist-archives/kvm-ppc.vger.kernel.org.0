Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5892C393F74
	for <lists+kvm-ppc@lfdr.de>; Fri, 28 May 2021 11:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhE1JKc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 28 May 2021 05:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235721AbhE1JKG (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 28 May 2021 05:10:06 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A64CC061344
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:28 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id z4so1322749plg.8
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cUEbB1uxydd11jDkucwIfUU2Dj7cII3oAzBBJlkL/QU=;
        b=lSoboG8tpdJv4KS0a7P39fwC7DcRRmfH6xAxTphPgUrJaYoZF2yRQxBmdMVJyrXIzh
         4jNX3OOeEIvO2xUmFSPYxC5by7c0CgquXgFuRNp9cteTfh8JMMwPdxgG55+AKPMif+7T
         D00rs9DM8xSjjmBNFuNmjIhCZlgU/YDTuauycbQF/K84iCn52Emm8ThKNK0fkrGA4y0q
         tTr+iuBHC5bI5/5F6w9LCQZOYttr3v0by8LPe6/TfB5SD0mx7HZU8Ly2n1xcQ7AzF1X7
         KL1Q5vSXg3C4dYb5hqxjxxX0OAlA892UnmLluSVM2iAx4Fprji179epbIyxCrtlhAU/l
         jQSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cUEbB1uxydd11jDkucwIfUU2Dj7cII3oAzBBJlkL/QU=;
        b=ngGCmpg1DFyju9Wb91UgiNPA9shCmbtm/etb6n1IUeLAhUTulGsnB1ulNRa9twNvIb
         hCERFYm8iVXU46IyiDZfKKP9Xx01/BcbdvF6DrEEKh7cMqVcrJ1fsUhs5TOWJbUBqvBY
         xLMZhPvJAK0KruQv/g+Bl5PgpjCK/Ou0BRpLSxoDzUz19f/UfpiuTN3Nff+kc/lkJxfN
         C/EoxqbiTC7+WVbkWRtLcJGPVRqxYPqwpuNdql1RjqQD3Sz/GwmKp1lNxcQXyCgdJl7j
         xt3Bg2LA3tNx2Vs4koLH+koThaZnG8pp1Z0yXo6KCZYl3gzmyj6uoXwGlei5bqoJL33A
         pc1A==
X-Gm-Message-State: AOAM532FzoEYEKQBAnn2UKGnHpyblsLg6cwHyoJiX8pbS5M1cPKxFFpw
        vB6+W58fPjveHXjiZRp18jbdSfvqG2Q=
X-Google-Smtp-Source: ABdhPJxrdarisH3hRxOuOV/WACSmAma1toX2dQ1LHiSLNjDGJKN08q6xHrQGCE+EM+hCtjt3nHlTnw==
X-Received: by 2002:a17:90a:a116:: with SMTP id s22mr3319681pjp.155.1622192908044;
        Fri, 28 May 2021 02:08:28 -0700 (PDT)
Received: from bobo.ibm.com (124-169-110-219.tpgi.com.au. [124.169.110.219])
        by smtp.gmail.com with ESMTPSA id a2sm3624183pfv.156.2021.05.28.02.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 02:08:27 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v7 11/32] KVM: PPC: Book3S HV P9: Move xive vcpu context management into kvmhv_p9_guest_entry
Date:   Fri, 28 May 2021 19:07:31 +1000
Message-Id: <20210528090752.3542186-12-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210528090752.3542186-1-npiggin@gmail.com>
References: <20210528090752.3542186-1-npiggin@gmail.com>
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
index d82ff7fe8ac7..bb326cfcf173 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3558,15 +3558,11 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	 */
 	mtspr(SPRN_HDEC, hdec);
 
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
@@ -3764,7 +3760,10 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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

