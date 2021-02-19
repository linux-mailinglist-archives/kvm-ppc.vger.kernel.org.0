Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A86331F51F
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Feb 2021 07:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhBSGgh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Feb 2021 01:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhBSGgh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 Feb 2021 01:36:37 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2EFC061786
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:35:56 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id d2so3550784pjs.4
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b8gwQXsU+oWm28rWdq4cNryrpKLXUAViiB3s2Y4xHIk=;
        b=JGGcOeTKnBFT8mdrOzezl8KdS+W2Y9fxPzHT8b9PZtf7WN3xHO+pu3TQmlzYsuhJGZ
         GNOEPVoDpysQfKnDilHFe4n/EpvZS/UhT1tmbJ5K+VW/Y6+Khgd1/Brak2Alaz8Xsfru
         lp+G9+sjHE4EfPr/1P5huLTM93TgoEqfoLbefh6F4K44LVvCMWL/E9fQYJn8ZxAgoH3m
         kP4L0SBxw6XjrZ8g0UtajAGfDr4PyHl2VKJfaUE3/vC7cAdn7dwpyUCFll/A8yZ4R5YM
         EL74mRwhE9LzahQuHrYMVfbgHYO9KI6Mt6wlhC7Bbqi/gUCN0z3p3TGLvLuQpMFCmpC1
         xayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b8gwQXsU+oWm28rWdq4cNryrpKLXUAViiB3s2Y4xHIk=;
        b=A+MrDscMhhT5drsLgmUw1mvjr7lfp+uX/Tmfq/hYh55zpWdvrK5D0Nwzd8ppfxHgiR
         77iwQZBw+lU9MqTHjvSQ/Mk7EUvY3VDrEECOg4U1eYT5IGtf3Qz66Ab6kKe4bWEXfQJD
         EDND6/Al9RSi9d0q3uqlBDW2kJ7X+QJhM0hkv5f2Hy9a9kuwksVgwKPeattvQOGQNWMf
         CeZPtbxbfX6B8uBGeOyQQlX7/jLu3mMdxfEZLlzvl+4ti0MNmLG/eScsqlsqK8/6J89k
         Hw69K5+0yFpC+3v5j9ZdjnSeDUkSaqarKjF4ZMnzssOtyCxNTWkw7M7pnomIjkAP/yQj
         O/VQ==
X-Gm-Message-State: AOAM532E71xvf1qzi9fDZJg5J7XVjCPk3CIHLFRIFZ89XgYGNguj6bZK
        SDiitvULbBmRPOT0gUA9slWyepopmXg=
X-Google-Smtp-Source: ABdhPJzbHn2NIZSJiZIEFBV8d3q56GiFJlDdhuTXN4418Ep//sYUNuK+itG627a4aUwec0c82QICBA==
X-Received: by 2002:a17:90a:9f96:: with SMTP id o22mr7612271pjp.119.1613716556076;
        Thu, 18 Feb 2021 22:35:56 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (14-201-150-91.tpgi.com.au. [14.201.150.91])
        by smtp.gmail.com with ESMTPSA id v16sm7813099pfu.76.2021.02.18.22.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 22:35:55 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 02/13] powerpc/64s: remove KVM SKIP test from instruction breakpoint handler
Date:   Fri, 19 Feb 2021 16:35:31 +1000
Message-Id: <20210219063542.1425130-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210219063542.1425130-1-npiggin@gmail.com>
References: <20210219063542.1425130-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The code being executed in KVM_GUEST_MODE_SKIP is hypervisor code with
MSR[IR]=0, so the faults of concern are the d-side ones caused by access
to guest context by the hypervisor.

Instruction breakpoint interrupts are not a concern here. It's unlikely
any good would come of causing breaks in this code, but skipping the
instruction that caused it won't help matters (e.g., skip the mtmsr that
sets MSR[DR]=0 or clears KVM_GUEST_MODE_SKIP).

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/exceptions-64s.S | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 5d0ad3b38e90..5bc689a546ae 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -2597,7 +2597,6 @@ EXC_VIRT_NONE(0x5200, 0x100)
 INT_DEFINE_BEGIN(instruction_breakpoint)
 	IVEC=0x1300
 #ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
-	IKVM_SKIP=1
 	IKVM_REAL=1
 #endif
 INT_DEFINE_END(instruction_breakpoint)
-- 
2.23.0

