Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF50632EDED
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhCEPJU (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhCEPJB (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:09:01 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A72C061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:09:01 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id e6so1569334pgk.5
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=13/LI6QJ9l5UtYR4jbZJIMmUnJrtQHumj1KYrw7W0CI=;
        b=HcQ5rHPoa9dsaFfRDSWl5mhHtEPXd8Qz7sv0LZY8FtCipBq7rRpLOqMVNLdCS4cl5r
         EqapcsCVUXi5fbXcotEoDay4OYPwhlxIdR2kSDiyWX3cYzAsUIpbluQVfyRT0rYnGE3F
         RMJRtUQGUaYzw1Fv/VyZlpB8SrFbvPAI46SeV8RfJ0zw+UzR3MsqkU5cMY/XjiZ6+oYu
         iMBzoZqbGq/64riAKAxd4NXTg1RKLf7ZsphFIoPpZ+s+tgzOpNEzYKouQoFch/vomxw5
         gSJLPZJ6/Qa0HKHhQIQJrduvfq3pVFedkTqILFByJxgkMGAbL0EG2ioMuSuJZ/4/QDIE
         QsMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=13/LI6QJ9l5UtYR4jbZJIMmUnJrtQHumj1KYrw7W0CI=;
        b=hu/OGWDNxGVPfG1hnw/31gIlvOpn4rxy4qE7/JGRPUiM+BJ5a7YJC3W6QrYrUggyRz
         3ZO0+ypiU9whLv/IoOUEOzM9/A8meyQ4kcoGPRJm0zhGEMloEsl74+DqPQ6IC+ksuvYl
         BJmqHKQgR6VwexohOs2E6Z+Q/Kctp0RXXygEZ759Zt/QgzXe7lrSDl8ARwG1CCiYrbDX
         uyiVTfRsEqw0gpVE3lc3U1YLHFk8SvAYtmLA6Tcxvdv99RvrTIhN27PD8/Xu/C35c92G
         Js7CLUq1iMklnbUc1a50+GwRdaz2s8i1IrURxQKG9jM54MmU4JThBvvnnmvc9rm/R20/
         Wpaw==
X-Gm-Message-State: AOAM531egjGHcMv1+2TzK10El15S2eSobNMdBhO2lwh6/yTSgH8UtTM5
        S5HRhJqu6cr6NQDQjuMrd836lC0U5y8=
X-Google-Smtp-Source: ABdhPJwDErNNhVln7WdJYJ736K6EN62eaFZPypbMoyWrVhFK1+XYvOrZv1RhJU1htu6rtEYz4pmJJw==
X-Received: by 2002:a63:465d:: with SMTP id v29mr8923837pgk.225.1614956940349;
        Fri, 05 Mar 2021 07:09:00 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:08:59 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 36/41] KVM: PPC: Book3S HV P9: Allow all P9 processors to enable nested HV
Date:   Sat,  6 Mar 2021 01:06:33 +1000
Message-Id: <20210305150638.2675513-37-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

All radix guests go via the P9 path now, so there is no need to limit
nested HV to processors that support "mixed mode" MMU. Remove the
restriction.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 928ed8180d9d..5debe7652928 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5393,7 +5393,7 @@ static int kvmhv_enable_nested(struct kvm *kvm)
 {
 	if (!nested)
 		return -EPERM;
-	if (!cpu_has_feature(CPU_FTR_ARCH_300) || no_mixing_hpt_and_radix)
+	if (!cpu_has_feature(CPU_FTR_ARCH_300))
 		return -ENODEV;
 
 	/* kvm == NULL means the caller is testing if the capability exists */
-- 
2.23.0

