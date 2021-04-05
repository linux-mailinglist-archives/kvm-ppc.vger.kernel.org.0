Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F9B353AA1
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhDEBVg (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbhDEBVf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:21:35 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDEAC061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:21:29 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id a6so1597699pls.1
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/MfbnRN8dnuzRj+Aq/3W1T9BSSMMXrvqkGuD+Sv636E=;
        b=Y30UY1OgHfg+ZONfB5UWRtxeu1z7SAmRVSRRpwSWYu1X0M60zAQm/dxBMlFadC71Xn
         gFCwn0aAoi9Uz7cgoch+a4fOwIZt71Qj0R7R9Gz4T2voCbECnuPZQISATswKeUw7kBpn
         LO22W8C4/aUDRo15mnzq51q96lAbgtQ4POROIHidD+OeV60hA2ptBmJwu1nBbZcv3qYg
         EmLlAu1bKtBwHCrjsXywZXuJrkx0OyhUeZ8LkNv1DbzdjT+xfCMTyvC3gtCxZW7bL4Dj
         s4zHNWdxewjs0waBce7pteF4al5f/fLN4BLTiq2pnGnGXqGZ774f48hz0uGzIaMdJ71w
         kxag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/MfbnRN8dnuzRj+Aq/3W1T9BSSMMXrvqkGuD+Sv636E=;
        b=cHbefwt+6/sXZ8V/vkQlQNd8dVcpQEZS/vj5L3NcKbsaMhEvyGTQstvMyoTejqYC5J
         b+z43vTeUEot1cvc5e5kz/avd34G7xxBxLziqAuaSObywKL6NpN2qo3HGXNh4JhgIxTs
         5tdjxGv3AMua8a9xZF+gOR4bN+9lqO6g1W3igv6adDzqjndyuz7JxRaD5YaH+jTGDssL
         QqfP4GWP+qeJZk0/cHLcP7NxlyoCWlkRKrMxu9R5tfiu6pTStUNfAxPVm+GHhN/aDUnO
         aMqrocc0cO5haYLy+drUSp9LxhW7NTlegP7MJvI9KGx6f4/HcGdPIR0XIB6EkJsZ1jz0
         Ecvw==
X-Gm-Message-State: AOAM531FO1R06hCaWjBdMyuKjPIYz/GMa0YTZFfTD4xM9UGBokiIGt0V
        gOKK74+ZxU9YQgf42bTQbYKo9NwtA/hSVA==
X-Google-Smtp-Source: ABdhPJxFZ92JUxArnB0Kjn4AsWGbEnW4X0TXT/LT+PNWX5v4UnSYf00JBDJV/2+536BmLm/nculj2Q==
X-Received: by 2002:a17:90a:9f8d:: with SMTP id o13mr23645774pjp.25.1617585689484;
        Sun, 04 Apr 2021 18:21:29 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:21:29 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v6 25/48] KVM: PPC: Book3S HV P9: Use host timer accounting to avoid decrementer read
Date:   Mon,  5 Apr 2021 11:19:25 +1000
Message-Id: <20210405011948.675354-26-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
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
 arch/powerpc/kvm/book3s_hv.c    | 14 +++++++-------
 3 files changed, 13 insertions(+), 7 deletions(-)

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
index fc42594c8223..8b9b38a8ce57 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -109,6 +109,7 @@ struct clock_event_device decrementer_clockevent = {
 EXPORT_SYMBOL(decrementer_clockevent);
 
 DEFINE_PER_CPU(u64, decrementers_next_tb);
+EXPORT_SYMBOL_GPL(decrementers_next_tb);
 static DEFINE_PER_CPU(struct clock_event_device, decrementers);
 
 #define XSEC_PER_SEC (1024*1024)
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 3029ffb4b792..5c4ccebce682 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3703,16 +3703,15 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
+	if (next_timer < time_limit)
+		time_limit = next_timer;
 
 	vcpu->arch.ceded = 0;
 
@@ -3895,7 +3894,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
 
-	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - mftb());
+	next_timer = timer_get_next_tb();
+	mtspr(SPRN_DEC, next_timer - mftb());
 	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
 
 	kvmhv_load_host_pmu();
-- 
2.23.0

