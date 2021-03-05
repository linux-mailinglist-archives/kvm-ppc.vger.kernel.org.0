Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D0A32EDE2
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhCEPIp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbhCEPIW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:08:22 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A04C061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:08:21 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id s23so2212010pji.1
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yC+1gMIfp5/fBh4frRkx5vMgkuDaaRYQYLGX38RY4MU=;
        b=DbZHtPCISKAGzjeNLDsQKfxNn0mvkF7eoHNpVXeNNJb0P8neL+qIaHgqsHAlpTvcLF
         +riBivG2mRZxW77wGV6g/j4ROIGwcFwykrfZiX1rn4A9KAMdNpqk658LsnPmhOfudMhw
         PCMUayDLQoTwoaqtFt7wpBw4r+/fCCs7iiBGVPYWv/jty7UET8NfmJAvEB5GOAUuHkLu
         2DT2JiguvOYdJpC4CJdQAp5P22H2h1kl3/IYD1YrdG5r1o3PFEeL9/e1z+OYRZ9Qpjsw
         /9TIleF0L8ioC5iScn9nnEqiBbWOdauqGCB0objN7rnEPVWM9L4J4h5CN0U+bQtu8Z6J
         s0vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yC+1gMIfp5/fBh4frRkx5vMgkuDaaRYQYLGX38RY4MU=;
        b=k6mvUjBvxV9FCWIJdLOQd3/Rm0AxPWpaLlDQ9irLOMh8XR3D2bvGjfI0iLyNkb6ymg
         N56yqk8x++AwpXvoNfWSU5eUlTydn1HgB2N0T5P0QvxhTJIzkmbrsm67zYE0PtOhLkpz
         4l9xWgszWefGXtGV5CVVzO+SJtpPIcieEcWZ1Wd0LAYNuBBEe0eghBQuKkZlrzbs0xbY
         CX7d7UVqehflKKpwkA1060WS1sjwK80V29ur2XNhS9EQ9ejKZ68G3JLkCYt1qZjKYg+Q
         5tOK/qa3ipfgU74EetWZ+38zqzd0hXEyb7KWDtQrnnohjT2R4YVxO/c/ELkB34203LJR
         CL3w==
X-Gm-Message-State: AOAM5335LieHOMnoyZAGqxRjREGEhJHqMz3xmnA1LozWGGmecOi2+/VD
        16yOR2n2QowoCtn5HFCpVjU2naR41c0=
X-Google-Smtp-Source: ABdhPJwQJywiunVLiS6fiZLcesmhrTfsXM709wrs+/veTeV8STKg1vqu5MmpZPf3cGYJHk1OTNvLsQ==
X-Received: by 2002:a17:902:7401:b029:e4:5992:e64a with SMTP id g1-20020a1709027401b02900e45992e64amr9043113pll.75.1614956900968;
        Fri, 05 Mar 2021 07:08:20 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:08:20 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 25/41] KVM: PPC: Book3S HV P9: Reduce irq_work vs guest decrementer races
Date:   Sat,  6 Mar 2021 01:06:22 +1000
Message-Id: <20210305150638.2675513-26-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

irq_work's use of the DEC SPR is racy with guest<->host switch and guest
entry which flips the DEC interrupt to guest, which could lose a host
work interrupt.

This patch closes one race, and attempts to comment another class of
races.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 6f3e3aed99aa..b7a88960ac49 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3704,6 +3704,18 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (!(vcpu->arch.ctrl & 1))
 		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
 
+	/*
+	 * When setting DEC, we must always deal with irq_work_raise via NMI vs
+	 * setting DEC. The problem occurs right as we switch into guest mode
+	 * if a NMI hits and sets pending work and sets DEC, then that will
+	 * apply to the guest and not bring us back to the host.
+	 *
+	 * irq_work_raise could check a flag (or possibly LPCR[HDICE] for
+	 * example) and set HDEC to 1? That wouldn't solve the nested hv
+	 * case which needs to abort the hcall or zero the time limit.
+	 *
+	 * XXX: Another day's problem.
+	 */
 	mtspr(SPRN_DEC, vcpu->arch.dec_expires - tb);
 
 	if (kvmhv_on_pseries()) {
@@ -3838,7 +3850,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
 
-	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - tb);
+	set_dec_or_work(local_paca->kvm_hstate.dec_expires - tb);
+
 	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
 
 	kvmhv_load_host_pmu();
-- 
2.23.0

