Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC043D51A8
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhGZDKg (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhGZDKf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:10:35 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73183C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:04 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c16so4438606plh.7
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XKVxs40Y3Ht4HwL4eALZtDA3njvIWQGeUzaIg+a0YoY=;
        b=QPzPdEGTO+eSvTcth7+jwiO5ueC0TvVJQS4BUYKRHy38O0yEYtwm9gMGhRpBpUJW/E
         xzSLzqzfErZZIsMcf/ws1SFHZe4LgyNE3z7VlqRMjJXEOV8zBY4t1IVGyt/QbYsfOZZd
         V6G7WABrCjummg3Uhvi3UhB5UaoE+GLWPHubt09PLRSh18iNb9gCO+xCju47pqUCjwsA
         ESQuBIRJym46XxTS9kcXhmfgngF1NdqA0jletsUx3XT0rMkmBG7GQAAKl7ZOdvS6R0aw
         TbO7co8QSvMOb8b+65l5QVaxWiYledgtQuuQaEvTkMS8v9b8d25WpYoRmFZhGL+c0BqK
         71TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XKVxs40Y3Ht4HwL4eALZtDA3njvIWQGeUzaIg+a0YoY=;
        b=fdi/exXZyFqXumSOhu2GWvKQO4HNfvb5fIBOBYWG/qUAO2C3z51rBaMdN7qmomGwM0
         uVWPI4a4Cslq2Cc5VsPkRthZJOaX+Y8il/KtUjS2aiUByYzTMuM6NGGfUaFJSzVI0K0K
         lALVKI1+IDOVc1CAZkLkq8OKMdrrfZLollEjGq4Oz9PpiRVCT5miRFQgi9i5DmVAjaty
         epxlhbMjLAQR/nVYPTkpLH0qKGkTOFa5sCavX92Bvi7zoAWbbhqd5ACXBDiZS88XllIa
         Not/QGU0NGXlygKnedbLVwZbVBuO91wr2tov25fcIOpFE7G+iaW06aZTw5Mfw4djWlcD
         SuhQ==
X-Gm-Message-State: AOAM5308i5D6aDA4g6aDBk5UJcg4hfDmcI8ifGydpM/Fr7W0Lj4zuh1M
        V9yyTq3ebh/lBeeKonXbukhMuM94fRA=
X-Google-Smtp-Source: ABdhPJxo9hVzjn7hW3VmNYfRG/qy/icGPi79DwZhCNr6qvpgl+mPOUebyZqm/10pXKdzhDyuGjIcYg==
X-Received: by 2002:a17:90b:3905:: with SMTP id ob5mr1018792pjb.211.1627271463935;
        Sun, 25 Jul 2021 20:51:03 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:51:03 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 08/55] KVM: PPC: Book3S HV P9: Use host timer accounting to avoid decrementer read
Date:   Mon, 26 Jul 2021 13:49:49 +1000
Message-Id: <20210726035036.739609-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

There is no need to save away the host DEC value, as it is derived
from the host timer subsystem which maintains the next timer time,
so it can be restored from there.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/time.h |  5 +++++
 arch/powerpc/kernel/time.c      |  1 +
 arch/powerpc/kvm/book3s_hv.c    | 14 +++++++-------
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index 8c2c3dd4ddba..fd09b4797fd7 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -111,6 +111,11 @@ static inline unsigned long test_irq_work_pending(void)
 
 DECLARE_PER_CPU(u64, decrementers_next_tb);
 
+static inline u64 timer_get_next_tb(void)
+{
+	return __this_cpu_read(decrementers_next_tb);
+}
+
 /* Convert timebase ticks to nanoseconds */
 unsigned long long tb_to_ns(unsigned long long tb_ticks);
 
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index e45ce427bffb..01df89918aa4 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -108,6 +108,7 @@ struct clock_event_device decrementer_clockevent = {
 EXPORT_SYMBOL(decrementer_clockevent);
 
 DEFINE_PER_CPU(u64, decrementers_next_tb);
+EXPORT_SYMBOL_GPL(decrementers_next_tb);
 static DEFINE_PER_CPU(struct clock_event_device, decrementers);
 
 #define XSEC_PER_SEC (1024*1024)
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 7020cbbf3aa1..82976f734bd1 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3829,18 +3829,17 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	struct p9_host_os_sprs host_os_sprs;
 	s64 dec;
-	u64 tb;
+	u64 tb, next_timer;
 	int trap, save_pmu;
 
 	WARN_ON_ONCE(vcpu->arch.ceded);
 
-	dec = mfspr(SPRN_DEC);
 	tb = mftb();
-	if (dec < 0)
+	next_timer = timer_get_next_tb();
+	if (tb >= next_timer)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
-	local_paca->kvm_hstate.dec_expires = dec + tb;
-	if (local_paca->kvm_hstate.dec_expires < time_limit)
-		time_limit = local_paca->kvm_hstate.dec_expires;
+	if (next_timer < time_limit)
+		time_limit = next_timer;
 
 	save_p9_host_os_sprs(&host_os_sprs);
 
@@ -4019,7 +4018,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
 
-	set_dec(local_paca->kvm_hstate.dec_expires - mftb());
+	next_timer = timer_get_next_tb();
+	set_dec(next_timer - mftb());
 	/* We may have raced with new irq work */
 	if (test_irq_work_pending())
 		set_dec(1);
-- 
2.23.0

