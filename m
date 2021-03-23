Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236AE345478
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbhCWBEP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhCWBDp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:03:45 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75839C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:03:45 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id r17so10054257pgi.0
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iRArmwHwr1TW/EUMAbr86c7nTk5KyXg+Q8BT8bAWL9c=;
        b=oKMKoZdgeHwZKUo4PRlD2Dzc7IhbEUC8mMjDI3zWI6qayRcFZ0kMCLzGyVTbNS4jIp
         REPS/XiU+8RlsfByynrWUE3UhQFoAd32MK/xEX7vdgua3YqClvwLM1D5iIXYSZMA6apI
         MoUC+5diufJPKJnQuRW6IUc3VDdw8u+Ry9TKY/OFonRoZQqvoJoltfMN6U7XR7s1N1Tb
         JlXxFvk0zQb89/mhh+cgrSz9xy1CChqivVksFQNmf5Gkquj0pbGaWQnobQ21heDgy6uW
         Q7RGqeK+qe0xIN8KxqghpsAAtvodH9vT6vY+Fu/KQrJk51WBdYuH72ALKdG33DHWp+0a
         CWSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iRArmwHwr1TW/EUMAbr86c7nTk5KyXg+Q8BT8bAWL9c=;
        b=ptFQzbL5Ko6h5npMN0qkwlZRjtcVmQBpwrtVfEd5BPAFsARfj63MpMX9bb9mZCBPUb
         LIA+ZD2h7RHrWioxdHyBjVT2sAIjtbq1t+CldWJdjpqdffPVOGVr8xS6L8EEUv1RYqwn
         8ecDKoQ96uFugLNElOldhw2+RqbtoMzcY5pBSk74/ryrmuAU2aB1pZu/fJnWdzituBU+
         wZPZo4gGZj/lVskLfhrcygEOWml3n+nCNKrIa1gWQfMChZumrJQ+JwS+E0ojFpPtckwn
         +W8QNruOTXYdUjEmqfkE0qr8FRo49ECLOoQc2Pkz99r+7gKRJREacQ2vEE0Q2X57dPa8
         10Cg==
X-Gm-Message-State: AOAM530ypYBL3PvlwI6QfFwiJQfwicHuQ4lPNMaJvAp4MWmuiVbnIGLB
        XeOgxtwwKoviiiqkPFQwnYZLidbEVIs=
X-Google-Smtp-Source: ABdhPJzGGLMwTFHfxJ4kbBx1rf1nML+TaFzWPnx+5G4RmWW8X+78FVGC3rdNB0BbPO+Mb1X03nKx/g==
X-Received: by 2002:a17:902:d304:b029:e6:bab4:8df3 with SMTP id b4-20020a170902d304b02900e6bab48df3mr2303950plc.5.1616461424936;
        Mon, 22 Mar 2021 18:03:44 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:03:44 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Daniel Axtens <dja@axtens.net>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v4 09/46] powerpc/64s: remove KVM SKIP test from instruction breakpoint handler
Date:   Tue, 23 Mar 2021 11:02:28 +1000
Message-Id: <20210323010305.1045293-10-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
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

Reviewed-by: Daniel Axtens <dja@axtens.net>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/exceptions-64s.S | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index a0515cb829c2..c9c446ccff54 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -2553,7 +2553,6 @@ EXC_VIRT_NONE(0x5200, 0x100)
 INT_DEFINE_BEGIN(instruction_breakpoint)
 	IVEC=0x1300
 #ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
-	IKVM_SKIP=1
 	IKVM_REAL=1
 #endif
 INT_DEFINE_END(instruction_breakpoint)
-- 
2.23.0

