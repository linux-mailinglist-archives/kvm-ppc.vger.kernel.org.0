Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16261345485
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhCWBEv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbhCWBEe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:04:34 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E48C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:33 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id l3so12539545pfc.7
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oi3rFVg7s4YqpLlxvEO8J+wccg/jPuk5mshi+6/N23M=;
        b=HiLjf44/VHH2aT9EPQ+ThTqjMJk27ht24Ty6z1eCauzjy9dfsOpoPKJDGRm4G/ayFu
         I1JvgDzUDyfexo83K8b/rp/cMZMCYYpFWVyTxpfblqs1AC7eXd7QYAtkn8Jnzv2QQmYJ
         OvRhbr9LXqS88fXM9cPW1KWp3j759qqyHJaqEz6ZWGjgAwdR204khsTvw9p6j29xInGh
         3cBhefzo2VudXul4PC0GP1XfcBuq9yUjJrLrW+qhWKkEqNBSdYqB/cU3/9feS0xUzKWJ
         WfvuhZsz3Cs4voMIPW89Lib/pkw7P9OsxfGw9s6v/DQjVki3rGf97h/qISHIzyTR3oT6
         gdHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oi3rFVg7s4YqpLlxvEO8J+wccg/jPuk5mshi+6/N23M=;
        b=ZZwdxkqOMw58Mp18zv1zmt+8RaJE1RblghhwttzHJAiSK0KptybRWR2Smh9vtCIt2L
         oV/Obc6VMBawbBVtLXcKWqhfsPm/ckCtmyuwSZ8Lq8KU7BeNwqIfal2e81qFoLimxAjT
         hCLzEjEyW186lNcx3g4n61HrKq8N/fxLFHRTSaQRbOpOr0GA3/zY8ZKqwIZY5mSD+evQ
         kl06kLWlqyEalpVxbayPcnIrnspNDfxO0wLE8Z0w8CMjlK5fDfgWTfq99OxqfO8HhvTb
         6pqlTCp2rOhmFfW2N+4QpQV3DrkTc5ygVzDZ/gvYNBdXd00G0lnRRKpkm3EU0vp6X++p
         RkBg==
X-Gm-Message-State: AOAM532tuOLYUrmIykE3pLJy1nSFbZ/gymjhnuI+l3TPg0PBfo+HeUL2
        67Zd4niykkMZwm+s9w02CSVGBk079Kk=
X-Google-Smtp-Source: ABdhPJxR2rjrIbqJLjRniFE/5WhegxWnBzygZusywztZ2QCEB/f4CoDOgA+wiR5aWh8tT/oRfcFwtw==
X-Received: by 2002:aa7:9a89:0:b029:1f6:26b9:bb73 with SMTP id w9-20020aa79a890000b02901f626b9bb73mr2047942pfi.78.1616461473422;
        Mon, 22 Mar 2021 18:04:33 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:04:33 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 25/46] KVM: PPC: Book3S HV P9: Use host timer accounting to avoid decrementer read
Date:   Tue, 23 Mar 2021 11:02:44 +1000
Message-Id: <20210323010305.1045293-26-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
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
 arch/powerpc/kernel/time.c      |  1 +
 arch/powerpc/kvm/book3s_hv.c    | 12 ++++++------
 3 files changed, 12 insertions(+), 6 deletions(-)

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
 
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index b67d93a609a2..c5d524622c17 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -108,6 +108,7 @@ struct clock_event_device decrementer_clockevent = {
 EXPORT_SYMBOL(decrementer_clockevent);
 
 DEFINE_PER_CPU(u64, decrementers_next_tb);
+EXPORT_SYMBOL_GPL(decrementers_next_tb);
 static DEFINE_PER_CPU(struct clock_event_device, decrementers);
 
 #define XSEC_PER_SEC (1024*1024)
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index bb30c5ab53d1..db807eebb3bd 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3686,16 +3686,16 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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

