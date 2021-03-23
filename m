Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13F2345488
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhCWBEy (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbhCWBEm (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:04:42 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976AFC061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:41 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so11462263pjc.2
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5JdTn5OxXho5EBUjE83UnAYh8oHgW8yUHH3wXU/FFlA=;
        b=RFz5Owr03qtm4vmeA3ix064bN5Djes2y2TvOfF+VgTrlFgsxr6SPWKh1HO51+jeLNz
         3btqsKXfOTlD069K+QWAsU6UWJxEPTxTKY7pTCrXCsyDeKnKDDCq/L+AazT+NJyufOu6
         Y4GWQcO7IEqc+RvpuL6/sLB044MpcT4niFyEE/jJnHdAMep5GRmPYW3whk5kXMeLsz0s
         Hg4T7XQzvlTJlVGiuhNqiGELKhPShs9ufjYxze6AfB5W8P/aYL9D88Lrn9SEbz+65dPh
         TdrPGl2MLzLkkwBtfqoymJEnWyQncm48dSt9hL4WCeKNKj2ssGWySyrHw9r0Gg5vfZyv
         +f+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5JdTn5OxXho5EBUjE83UnAYh8oHgW8yUHH3wXU/FFlA=;
        b=pQkeOKQ8qK2x+SPIv4fTl8uSsmrarF9udO1Ib8sBvXfxR3NBxRgZmF5b0a3iubl9iI
         7bf3R+un7hOyj4PZXhuDENchKpQ9/DoNsECgXJRcEUG2TQFg+CSHdknhBZDKF5BfFCIY
         c4m8OKhIL2F1D1wA+R8BV9s/VV2feumndKmQ9qB+ZMhXE+3dWsjddSLW+vweuaKKe4ok
         Z/+TnmaEJV847Apn4DExMEofRB3Oc02JPRv/4S7vASzoW2w6DA52CQ/NLRp0q0k2F5V4
         lpYkMQDTEJBAyX+rN+/BwllHQz1NmJ4DTg3YidKJrWypSG2bKgr95oxkbNZU/IBPZG7o
         6dcA==
X-Gm-Message-State: AOAM5318MA1+GAtCKMvvYzofa2tpfKwW5whNkbivicnxpq8fnugdiNmh
        fz+uA+JbXFtLvgrlDBIuQl69jozpiNA=
X-Google-Smtp-Source: ABdhPJz41VEeWwXzCYnfFe7aZlNTXw4ctcWU0T6seoc/kgfqqOO7RmqGqEM9/gKyvHzMyZe0G5cUcA==
X-Received: by 2002:a17:90a:ba05:: with SMTP id s5mr1810923pjr.194.1616461481061;
        Mon, 22 Mar 2021 18:04:41 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:04:40 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 28/46] KVM: PPC: Book3S HV P9: Reduce irq_work vs guest decrementer races
Date:   Tue, 23 Mar 2021 11:02:47 +1000
Message-Id: <20210323010305.1045293-29-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
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
index 1f38a0abc611..989a1ff5ad11 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3745,6 +3745,18 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -3879,7 +3891,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
 
-	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - tb);
+	set_dec_or_work(local_paca->kvm_hstate.dec_expires - tb);
+
 	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
 
 	kvmhv_load_host_pmu();
-- 
2.23.0

