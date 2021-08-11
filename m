Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832E13E9543
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbhHKQCk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhHKQCj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:02:39 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB54C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:15 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id a8so4183090pjk.4
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Tl3zXkbeXpBq6mAh0/9Zs7l8/9YC+oa4x6XGIsxxGGo=;
        b=N5sjZMtT9K69iH2m2eteFZv++BFi2L8HHmNSZUVktJrQhe1hEbvxTqWylZkE6OsKDS
         0GY8jbZsQOd4hh+OgUudQTt1+8zKLvBil2ro86wa9cQB5ik5E2wITYCCYcPp8ngik6mR
         argJbXnnIkvL6+HWf8JQATw3gApQVFhnHp/9qr/TRoPAm4uJgP/2yiMczHz9xaDX1icS
         QeYJX4HnPEOCw+Lm7lhr5Na/wN22hhfPuDonJqstJcB4/VE362BFF1uyBsqrdtpIDS7b
         1BAsmuPZ2OtFOsqQgOOTx4AGfOPNYymXpVDkKGLaT20GNrtdNc3/RpTqum9GEITg8pT/
         KXEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tl3zXkbeXpBq6mAh0/9Zs7l8/9YC+oa4x6XGIsxxGGo=;
        b=qwzqcxLqyHnwu2VXSVW3kqfZvl+ec1ehbwLLgIYNw1aaMcK5AoGjIK1+95aPwsfx2h
         kCkZPq0uqkSoLa9dq5x/7OWMxK7h06/wXxN9cQWW5tLrb75onpZ9hEEQiawO2z8i/Byh
         hnVV25pFcl62317gItq0XebMJHPOSjJ9QEmcIgv9C7GtBrB6xXLrB0Ium2F8H1e0E0t8
         2kj/lrQk10kUgX70kSJVJyqE/tZ/XXwpk/VR1RhynZOR9dEfJFJBVCOb2Xi23+9zHXQh
         8qKRQXXWVq1tIyeyxtN5zgLE33gaqOw7IoAHN9sGWyF4SpvpsaVtNVduBJou1GvRPKIU
         A0WQ==
X-Gm-Message-State: AOAM5304wzNtk0Vo1UwPrFpIyZaTnUB5Jz/k5hsJ95Pxr8tESEKRq0d5
        X/63BnQA+Xq/ktru7AzvsJpfMOoy51Q=
X-Google-Smtp-Source: ABdhPJxs5j/8Y/rZDioQ1c2Qs6LYpXVO0wQceVK3BdUJRs9Ssodo3Da77SJxVwOUu1xKcy2MXTFAlA==
X-Received: by 2002:a62:7bd4:0:b029:3b7:29bf:b0f with SMTP id w203-20020a627bd40000b02903b729bf0b0fmr35332836pfc.15.1628697735410;
        Wed, 11 Aug 2021 09:02:15 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:02:15 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 12/60] KVM: PPC: Book3S HV P9: Use host timer accounting to avoid decrementer read
Date:   Thu, 12 Aug 2021 02:00:46 +1000
Message-Id: <20210811160134.904987-13-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
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
index b60a70177507..34e95d3c89e5 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3859,18 +3859,17 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
 
@@ -4049,7 +4048,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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

