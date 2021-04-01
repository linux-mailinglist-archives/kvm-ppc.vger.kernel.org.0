Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F756351B9C
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbhDASJH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 14:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234697AbhDASBI (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 14:01:08 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7629BC0F26F1
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:04:55 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id t18so1297650pjs.3
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u8vp9roVuaRmhfBRtCwb/lKR6w+iZpeDEIXPZDywVoQ=;
        b=hfyiHCMbXdtonpwpG1ansFgGIxJ9EjEmvStKFVtVkMmmCcOVrtKL/TWWQDh3eh9jyr
         ZTBcAIfCS5H5Itbzd8ARniWW9Yf0QfXwiy6ubkLOUl9IofTc45yWwXlsAnoDQg2ABSKv
         O/dZJUZsLt0Ol9wD/phH08OYNhwvF7Mmr70JSEVMQlGtqWA74WXGwjrpQJCB/T/BeoGe
         8wB+7whCnLI8TH111Y6LCo2efFhqdlgrgYkfSLgGohXByRexyOzWqb+Q5+gJDgwIqhXY
         VOz5EMmPc/KF1S78Z60eY9jkkIpZJA4FU+6+ORDms0bvFnSqCxu4jkA4pWpw6UgvX3AU
         oU5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u8vp9roVuaRmhfBRtCwb/lKR6w+iZpeDEIXPZDywVoQ=;
        b=No9fBf4T+QJcHsF+R8s3RwvSqseJVYesnNKnHrFn7Fns8f0SMOG82tf7DfKzFOxtWc
         KsMMvXGhogwUh36Gsj3hZm9z1pan2HA00oXPEZBWHp10jIgrmjuSp6oC8ToZ63tBN7IC
         70Zo5xAxeSMBSh6tXBBBF2Tf5X3YuUyOsGBQgIs4P6t6kfoVl8Sw8KOCtcYL/fGa+qWV
         7PuGZW8T5fhZnF01i8EnAAl0HKdIfFwKS2T5+F8YFHeCQ9qkJm4Gqvy9XfBZqZQDNF6u
         4suii+Lygjd5+gAcVc/5F7WaKssU6prGs0MoYtI8KLIU7E9pB9BfEKOCiRQU/zJBMcAS
         5BBw==
X-Gm-Message-State: AOAM533ekAOFW5Bbry7YZaJVgNQkk+2aLZuS95ILtcRS2arnImLtqW97
        dvzOF9sufGOAwVnNVXHSkpm3mESMOXs=
X-Google-Smtp-Source: ABdhPJwtiAqSy7ggl5dRplnMo1pOdemOcDfqBG87KJseRlzov9cX6dEamRmHv7jHFxMGSDJE0mwxCw==
X-Received: by 2002:a17:902:c084:b029:e7:32bd:6bc6 with SMTP id j4-20020a170902c084b02900e732bd6bc6mr8272375pld.58.1617289494852;
        Thu, 01 Apr 2021 08:04:54 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:04:54 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v5 25/48] KVM: PPC: Book3S HV P9: Use host timer accounting to avoid decrementer read
Date:   Fri,  2 Apr 2021 01:03:02 +1000
Message-Id: <20210401150325.442125-26-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
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
index 7afa2e7a2867..dc1232d2a198 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3697,16 +3697,15 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
 
@@ -3889,7 +3888,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
 
-	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - mftb());
+	next_timer = timer_get_next_tb();
+	mtspr(SPRN_DEC, next_timer - mftb());
 	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
 
 	kvmhv_load_host_pmu();
-- 
2.23.0

