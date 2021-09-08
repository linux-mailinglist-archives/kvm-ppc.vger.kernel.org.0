Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBBE4037AF
	for <lists+kvm-ppc@lfdr.de>; Wed,  8 Sep 2021 12:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345759AbhIHKSh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 8 Sep 2021 06:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235008AbhIHKSh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 8 Sep 2021 06:18:37 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF84FC061575
        for <kvm-ppc@vger.kernel.org>; Wed,  8 Sep 2021 03:17:29 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id j16so1637389pfc.2
        for <kvm-ppc@vger.kernel.org>; Wed, 08 Sep 2021 03:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XJL6i+YCXvCo5U+3ydR+e/rNKFY7FEPlcahYujkfk38=;
        b=GsTHxmt7/p0l7lRb3A8EU9YOngEBaP/k7avWA0s8IGPIgRutpXhKuVMVx9hdwn6MtX
         aijnWx0rKArojVNf997GWPApjUz06PzUNhk8jdFUkXur36htDJIM5YokkqLBQZooiAXX
         pYbVwmm43MvFOVLZTKAMG0tRls2km1S6n3KEu/39ALHSwGqEk1Mp+iASv5wWj3yrgZBv
         xDXB9qv2seGhd5wcryuwcSXCc3T/iBCWocoDxAwWUQYLFhQlYQvqTlornNewy5rP3SiK
         BeE8ZkEUstHDTt/S9XHw3he163PtdZdj2rnet2UIPHLKlqUFOYdAe4y1frrnLlLyQK8l
         04bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XJL6i+YCXvCo5U+3ydR+e/rNKFY7FEPlcahYujkfk38=;
        b=UVZ00vrGOcElIbqJab/kw489HsG++Kvw6JLUoIyu6F4lFouuGjtOH86IjbJLm72f0E
         n3KJ+llZjLS+3F5VPYVFX4+2x+GGuhudtSfXKFrTKehjXEzSPhSIRREFzNSkULuezhRU
         MIME2CguAay/neFNjmYxsMTZgHev/E2u+fCprhQzj6h4X2ONUYv/g8v4F9knzg3TUWYC
         XolcOLr7rxUw4vAbge5gugGmijE2bFMM4psIVuFqCOWjty8vZ9fvlb5d7b0mdyOMHjHt
         038ZhLq+Acs0ddqBC8LVRjb+qv3OJOxFKut5GzS6WMVsxMHdZeaF7lXLu6n6hgxP8MZa
         6dfQ==
X-Gm-Message-State: AOAM532UjDudJH3jQdav11RYPIt+OjEcWNvMGPfsHaSHilFwMGI8yw9U
        LP+3EIOajYLCbFq78y1nE9w=
X-Google-Smtp-Source: ABdhPJziM6Ow0sUvG+SQ6pzjdoiUoFSffznbPeovqLT8kJ7D3AiFrv6xbYsegIKORt/mF7lwG/K1PA==
X-Received: by 2002:a63:b40a:: with SMTP id s10mr2986935pgf.481.1631096248831;
        Wed, 08 Sep 2021 03:17:28 -0700 (PDT)
Received: from bobo.ibm.com (115-64-207-17.tpgi.com.au. [115.64.207.17])
        by smtp.gmail.com with ESMTPSA id bj13sm1722019pjb.28.2021.09.08.03.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 03:17:28 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org,
        Eirik Fuller <efuller@redhat.com>
Subject: [PATCH v1 1/2] powerpc/64s: system call rfscv workaround for TM bugs
Date:   Wed,  8 Sep 2021 20:17:17 +1000
Message-Id: <20210908101718.118522-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The rfscv instruction does not work correctly with the fake-suspend mode
in POWER9, which can end up with the hypervisor restoring an incorrect
checkpoint.

Work around this by setting the _TIF_RESTOREALL flag if a system call
returns to a transaction active state, causing rfid to be used instead
of rfscv to return, which will do the right thing. The contents of the
registers are irrelevant because they will be overwritten in this case
anyway.

Reported-by: Eirik Fuller <efuller@redhat.com>
Fixes: 7fa95f9adaee7 ("powerpc/64s: system call support for scv/rfscv instructions")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/interrupt.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/powerpc/kernel/interrupt.c b/arch/powerpc/kernel/interrupt.c
index c77c80214ad3..917a2ac4def6 100644
--- a/arch/powerpc/kernel/interrupt.c
+++ b/arch/powerpc/kernel/interrupt.c
@@ -139,6 +139,19 @@ notrace long system_call_exception(long r3, long r4, long r5,
 	 */
 	irq_soft_mask_regs_set_state(regs, IRQS_ENABLED);
 
+	/*
+	 * If system call is called with TM active, set _TIF_RESTOREALL to
+	 * prevent RFSCV being used to return to userspace, because POWER9
+	 * TM implementation has problems with this instruction returning to
+	 * transactional state. Final register values are not relevant because
+	 * the transaction will be aborted upon return anyway. Or in the case
+	 * of unsupported_scv SIGILL fault, the return state does not much
+	 * matter because it's an edge case.
+	 */
+	if (IS_ENABLED(CONFIG_PPC_TRANSACTIONAL_MEM) &&
+			unlikely(MSR_TM_TRANSACTIONAL(regs->msr)))
+		current_thread_info()->flags |= _TIF_RESTOREALL;
+
 	/*
 	 * If the system call was made with a transaction active, doom it and
 	 * return without performing the system call. Unless it was an
-- 
2.23.0

