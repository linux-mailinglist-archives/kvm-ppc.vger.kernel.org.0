Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD353250C7
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhBYNsm (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:48:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbhBYNsm (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:48:42 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAFAC061756
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:56 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id m6so3656519pfk.1
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FGYCVyl5qXjwebi/u46IYNl3I3VlFCFB0eRTWRiaPFU=;
        b=Zd9/+fJBaQaHATcB1cKjB+Ry16+u0gjeugQgYRGrma7/1Creqsv7nrs8HiS92vyF0o
         fEbKWEflW7epS08ZrVD7aFrcgVfDNKhexxzLhAvURVWEdWQdNxpOe8cvmyjsMSYzXYZh
         8iMh4efteUhbF0CQjTRndsRJeP/a19rsBiShhVExmFfQ4iw/t+KTs8SKya0YZO12bUUo
         bu5Jiks3vQL1kV8wQejRs1drG7Ktxr4m27SZljiUSqYTrkZNK9VwTtOE3ArAtQUZEEXD
         dmkanXuxSNsFNiBM8rzflOr77vVUnK83Eex99prKmTKpFDUHST5Rvo/P8bAvpyerYQyV
         bmdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FGYCVyl5qXjwebi/u46IYNl3I3VlFCFB0eRTWRiaPFU=;
        b=mVvfmTxQXfSleCo3TY1Qy/x36xNYcUfPnM5IrevWhVIpVKCYZAT6uCQYUw5iEpNbT7
         auVc9qBWiBskUXqr5S7s3a6ZSHvPti/c/AwCccBp/Kil6K6jnBUoJRzzyNd+E2nD/C/k
         zhNYv6HrVQ6JqQ4fUgU9unRAtGYIgCOHiQiG6NKduAqjZagxDGtKY5mH2oeMHmu1/uV9
         SrDTWWXghIgi4Yz1Mhv9JlLZzWOqgbnNb6VsvMN6ltMgfrDTkkxkwBjOMSnrBZHIwDX7
         BLMud6+p5oQQNvti2dJt3N5FRgkfIOlzPYfa7NZQ0hiDAqLIG12udwyKqyVJwIVdo0Bf
         UB2A==
X-Gm-Message-State: AOAM5314be3u7wJzeT+rZ6Defiec72mcT4dqKUU7g7ooxki0gZlQ9t8K
        zT/kJdxYY5jaeQ2fAsq67jqQGSm1RsA=
X-Google-Smtp-Source: ABdhPJx5BZk10husdXQ7k44Rx1C1FfwF1Vsz1f+vgH6EJfpVQbwBLoV90YqFP98X0H1jrjStXY+ZoQ==
X-Received: by 2002:a05:6a00:2353:b029:1ba:d824:f1dc with SMTP id j19-20020a056a002353b02901bad824f1dcmr3363293pfj.9.1614260875507;
        Thu, 25 Feb 2021 05:47:55 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:47:54 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 15/37] KVM: PPC: Book3S HV P9: Move xive vcpu context management into kvmhv_p9_guest_entry
Date:   Thu, 25 Feb 2021 23:46:30 +1000
Message-Id: <20210225134652.2127648-16-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Move the xive management up so the low level register switching can be
pushed further down in a later patch. XIVE MMIO CI operations can run in
higher level code with machine checks, tracing, etc., available.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index e3344d58537d..7e23838b7f9b 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3549,15 +3549,11 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 
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
@@ -3740,7 +3736,10 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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

