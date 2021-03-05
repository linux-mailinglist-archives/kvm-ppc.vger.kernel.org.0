Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBCA32EDC1
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhCEPHJ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbhCEPG5 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:06:57 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1FDC061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:06:57 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id o6so2190171pjf.5
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OqE85jl6MTcwHuvBnwFd1UHp75PiplctVH/sjdMOP1s=;
        b=C5Xz5RYQOMw1QPhs6aQT3WoCyvr3U5jPVO4aRwZCz7U2Yt7tj5XMKFFrhV5NKgUSbC
         zmB394eJOoELma7tlIhpOez/ZddcpNSqwl1hHJzKOxVw0qhpv6JLU1nMlhM/d0dMSeA0
         ILnRYWGOrXw5wI8GM8a9kRcgVwNpWfN8Jlk7Ezs9gGpWKGSsnh38JcYGLTtMT5eWHxbZ
         352+M/Bc4XY0Qw/4Wf+3ooc3BkyeAvgoNxin/GFqvCfjAUBMmkHsE4sRL7cAvAnIE87y
         qNFakIw0/mAN8s4EYF5YnLKQsgf72j0bk/T7oOwXhmr+RGo+XjuTx/F0yW2h6nT6DnjO
         vKLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OqE85jl6MTcwHuvBnwFd1UHp75PiplctVH/sjdMOP1s=;
        b=JOR298oPGplnE0uecCwtojxA1ygpbqFCS92DW40IOTRDI+7nAyPcDD7zUQu59IOUPy
         E0VC0IX/9H0cYH6FKNxZFj26YC+gdU6uO+MezfZrk3VM2vhfwG/QTkYYdHRwY9Z2A1xu
         t01aP4DBkD0F2qRm3IXdZq0EPVNMj6Pcrs9jamcGzMIy4oTldUxHiyDeMlDYWIrVNLVJ
         MTcsSZXp1XyfJQDNM/e/YN9+VOMCnys3k8qjKTW5J7e/q+DX4A2m5NHFV0KPauqrpbQj
         0cKwE9dRDN1ik9DsDhMzugJu1KW1AeDvFNoJXznegt/p4uFlogtj2F/5K8d9EJDIXTka
         WTzQ==
X-Gm-Message-State: AOAM533yDghYqCPuhIklJggiEqtBsfOhaCBwDr+uG4pXIiwaugiI9mFN
        5GUf82fyb6NxEDA4oYL6yNC+tKVtNuk=
X-Google-Smtp-Source: ABdhPJx5/llvTT6K0Ik963e3DaHBuAbSBuyIFWQzDdCt4SFmbhfbV+lkfx7rdu7zbuCBN3odG28UGg==
X-Received: by 2002:a17:902:ec83:b029:e3:ec1f:9dfe with SMTP id x3-20020a170902ec83b02900e3ec1f9dfemr9011629plg.59.1614956816281;
        Fri, 05 Mar 2021 07:06:56 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:06:55 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v3 03/41] KVM: PPC: Book3S HV: Remove redundant mtspr PSPB
Date:   Sat,  6 Mar 2021 01:06:00 +1000
Message-Id: <20210305150638.2675513-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This SPR is set to 0 twice when exiting the guest.

Suggested-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 2e29b96ef775..0542d7f17dc3 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3758,7 +3758,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	mtspr(SPRN_DSCR, host_dscr);
 	mtspr(SPRN_TIDR, host_tidr);
 	mtspr(SPRN_IAMR, host_iamr);
-	mtspr(SPRN_PSPB, 0);
 
 	if (host_amr != vcpu->arch.amr)
 		mtspr(SPRN_AMR, host_amr);
-- 
2.23.0

