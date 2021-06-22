Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171073B01F2
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhFVLAU (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbhFVLAT (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:00:19 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647CEC061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:04 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id x22so8706902pll.11
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3M5Rz+SV0BCD75nUdkUKbQnfnMylnjg389Pi8D3mD1U=;
        b=LIC/ZyZPrgouKoAhY2NAGHgyl5vEP2qSs2PDU/NmU9O+R3RI4J9/ACTw5g0RZKkE5I
         XXvC4jCsN166hzgYzgNqRtrdaaAG/p5LiBDXKwIeMsXYY1NnzzZeUzPyWevMJ5m4inxz
         Rq82yMn8qOFG4IH/mLeOrxruI8YoSRzlG+XFP8uoIDenUSqMsM1jojL3mZRHjTbTpJdl
         nJGYic/c9tP4SoOHaJWNtVhNPx8pBoNu37wjSEFmlbFsJ1JBPCNbiV/I1Gq6WcelcuLh
         rqgqnZGACBjKntqaFXWVL3NautaSwVSVPIlH0L0WHwN0mGYU769IRkd3oJ2E2yjZ+7pa
         kSIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3M5Rz+SV0BCD75nUdkUKbQnfnMylnjg389Pi8D3mD1U=;
        b=WnW3UKZJ3KJec4MGf43+EdHTBNYm6WaMTaWCxGU4m9phMdUAayzAQdbWaVIZqsGBNJ
         Kh6tcORmCwSZy4tHMBeUOntC6sZ07HfeP1YDqOSiiV+gsPBbw/lwarjwBgY5DQMZM0R6
         glXC4PoflyS16Lj8NAnXB62cQbUBm2dakHtTkYsIpYFAjXXzchOPB0M6aBqENkIPqyE3
         9kbwFVHsRaEUn6DjOMNOnDJZpklTXlytX0HnRqp53O3ygBEn6GiBKbVt3Qr1h5e5PFH/
         HLeFWSqh4x11xq0zwzo0fLrfKY3NXMbTj9dKn72lYGPMfEYZsHaZHxGLbNcHjwOhW9q3
         1nZQ==
X-Gm-Message-State: AOAM532FhnAQ6V1dca3Hbf3K3PQ5e57765jpeygOAHYcX8yMZYnnt0tK
        Bfa7Neaan44yaGfvknLcqLVdr+lbTHE=
X-Google-Smtp-Source: ABdhPJxpC2TOsQNBxt3nmWEWrAnaBPBLc7UZ0N7d0sbeYqQy+b2OjRXLhrcK/2/RzHcmtmEdXnYtww==
X-Received: by 2002:a17:90a:e00b:: with SMTP id u11mr3533229pjy.53.1624359483833;
        Tue, 22 Jun 2021 03:58:03 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:58:03 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 03/43] KVM: PPC: Book3S HV P9: Use host timer accounting to avoid decrementer read
Date:   Tue, 22 Jun 2021 20:56:56 +1000
Message-Id: <20210622105736.633352-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
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
index da995c5fb97d..98bdd96141f2 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -108,6 +108,7 @@ struct clock_event_device decrementer_clockevent = {
 EXPORT_SYMBOL(decrementer_clockevent);
 
 DEFINE_PER_CPU(u64, decrementers_next_tb);
+EXPORT_SYMBOL_GPL(decrementers_next_tb);
 static DEFINE_PER_CPU(struct clock_event_device, decrementers);
 
 #define XSEC_PER_SEC (1024*1024)
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index d19b4ae01642..a413377aafb5 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3729,18 +3729,17 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
 
@@ -3914,7 +3913,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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

