Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A31A3250C9
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbhBYNsq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbhBYNso (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:48:44 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20CFC0617AB
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:09 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id g20so3230695plo.2
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IAvUmJ5x6WP1qzuhU/NEz1W7bJ05d4CA4Gd/jBet5Cc=;
        b=I9SIJ+2JSZBissr8WFV6oI788xYTeZUYkdHy2Fr7d3QjcaxD9ob+STuQ2EJnJoiJM/
         VSens5ZyguuoSXAG60mLHo1UzagDqGXhIyY6GUB6q8uY/XLVWozxhNCL8mjVtpHLceiB
         6oUdrEZ0s/TQclr1y4zjdzwUnzXNNc2XMUWPfrPi364Z5mi39rSQx5vqULiVXaemf36N
         zz1n59rK9ML+F9r632G1SxUGArcy1ysEGQzXUDiLkpvE26ej5RGw+VY4V8zS68+/+n7w
         cN85mExtgr7JiZ0deMVGstQVPWCd/XWs6W6GhfD5WASULvwXHOTouXUct6f/Mpcigqmd
         Rh2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IAvUmJ5x6WP1qzuhU/NEz1W7bJ05d4CA4Gd/jBet5Cc=;
        b=CR4SUgb7AiBtBCDc1BC6wHcsLffJ4VQJQu7x/Ja811xcCX0QDh9X+GLesNjnI2W0gQ
         +HhCWse2EHKIqUEaF3VdChG1daqHOqMdNM+mc317PwlA5LPWD4uQwUpi4tlAKxDKzLKJ
         DNSxKeaxUYEeOQsZKxnPKlyzwwzAqRiYYmYFoZXUNlmcZrQz2EHKfWXo/bdU5Fx1Embu
         jHLL5oMQqjMVldCjWAmsyXiImyiBmUfEFsZV3V3lbOdkDKQ9QH0E6BULO7W0PkefAYKO
         Zk72E5s7t5aSF1Usan8GTuzrm+HqkGDjcbqhxPJwOhyd9jjLKQuIKgI6tgLBK3qHty3M
         GT2A==
X-Gm-Message-State: AOAM5309vCc90JiIhgOCzSnBy7NkrO5xEU0VqU17L9SKnI9Tm4LC34Ah
        72b/Af1UAuEMfLEYtdosN1/Q3NQ+inU=
X-Google-Smtp-Source: ABdhPJwwyG9yKV5GO5sIoo2EFzuVqiNXSgeaLsc4YQlwyGDnXto2BpBBrTCwAO9r4VQwzIe2fKpiQQ==
X-Received: by 2002:a17:902:9349:b029:df:fab3:64b8 with SMTP id g9-20020a1709029349b02900dffab364b8mr2985259plp.72.1614260888800;
        Thu, 25 Feb 2021 05:48:08 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:48:07 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 19/37] KVM: PPC: Book3S HV P9: Use host timer accounting to avoid decrementer read
Date:   Thu, 25 Feb 2021 23:46:34 +1000
Message-Id: <20210225134652.2127648-20-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

There is no need to save away the host DEC value, as it is derived
from the host timer subsystem, which maintains the next timer time.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/time.h |  5 +++++
 arch/powerpc/kvm/book3s_hv.c    | 12 ++++++------
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index 68d94711811e..0128cd9769bc 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -101,6 +101,11 @@ extern void __init time_init(void);
 
 DECLARE_PER_CPU(u64, decrementers_next_tb);
 
+static inline u64 timer_get_next_tb(void)
+{
+	return __this_cpu_read(decrementers_next_tb);
+}
+
 /* Convert timebase ticks to nanoseconds */
 unsigned long long tb_to_ns(unsigned long long tb_ticks);
 
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 913582bd848f..735ec40ece86 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3631,16 +3631,16 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	unsigned long host_amr = mfspr(SPRN_AMR);
 	unsigned long host_fscr = mfspr(SPRN_FSCR);
 	s64 dec;
-	u64 tb;
+	u64 tb, next_timer;
 	int trap, save_pmu;
 
-	dec = mfspr(SPRN_DEC);
 	tb = mftb();
-	if (dec < 0)
+	next_timer = timer_get_next_tb();
+	if (tb >= next_timer)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
-	local_paca->kvm_hstate.dec_expires = dec + tb;
-	if (local_paca->kvm_hstate.dec_expires < time_limit)
-		time_limit = local_paca->kvm_hstate.dec_expires;
+	local_paca->kvm_hstate.dec_expires = next_timer;
+	if (next_timer < time_limit)
+		time_limit = next_timer;
 
 	vcpu->arch.ceded = 0;
 
-- 
2.23.0

