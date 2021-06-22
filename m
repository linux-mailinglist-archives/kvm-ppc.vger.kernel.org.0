Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12153B01F4
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhFVLA1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbhFVLA0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:00:26 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46D3C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:09 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id b5-20020a17090a9905b029016fc06f6c5bso1552772pjp.5
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2HwJMJ+M3lZ7LKAr188SC+V94ehruDB42lsvXKWHhLw=;
        b=KsljJKuITKwAGTy1HlWe/atuGOyB50IBg64I0rlMWeigk6Xnc/NVVRjOPFBx41en55
         Nzh61AuzPRoCTeuDJZ/e7LTTptdxRs4ZI5dYCa097wMZrCNkMkeCx/G0uQ8JPs+MN13v
         624v/ov82HWdkQDgxFCZkLBSLRLiNUl7qTVq7qrnnNqOfvePB1FILbspa9gkVdwCft1w
         hXbMfQs1IMyxHSndeld71X33uxCCtVOPG28HltdP5YMOSnIW/vXpX35FnFMZVMPCc4FK
         9MB+s8xeo/81cSmHDuN/+mXqgkMXwhKCJ9RytvtQgaOzsdrOb2oRI/Dzubw1WHY22ttw
         lgVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2HwJMJ+M3lZ7LKAr188SC+V94ehruDB42lsvXKWHhLw=;
        b=SxdRTdHvDRPBLldg4naJuHI2A1D1c6K9FadYC1xaEea+gwV/wuuWKznXwiJOfV1xxI
         JgdmHgDRAwM9MAtVf878WrHl9d50zt8ZzD+c+WFQLw5/sWe7wWV6IJXE79MuBlo9OvWP
         sTzT8eFztF1V6csuxguD+8r19r1yg+6wrw0E4OJZFLzHbI67YCNEo917Su7HBh9cM9b6
         748FRpfmisZPiX5t5TBDNJLt8+QGnIt5jTGM9bf5uH0h0CIxp9hyR9VlK88ZuQDmpoag
         ip1UAi8xQECncnuirtquICHy/sRXDpN2cXLGNiQPseluMjO+WwwygblKqdxJCQXJ3hII
         3iQQ==
X-Gm-Message-State: AOAM533LICkKHHhf2nPXJxTVOP4SbduVomWty6RVSC6ZfDTbgsgd5Bfk
        1t3ijefcSaU15AgUoVtaRoCy/OH3Vqg=
X-Google-Smtp-Source: ABdhPJzoOumOB90vpW0/ovtLjN1XL8sGNQJor6rhhW7lWsrYLLlfzJfGhdRpOrZj6l7a0HLKDiLzAA==
X-Received: by 2002:a17:90b:11ca:: with SMTP id gv10mr3408322pjb.94.1624359489126;
        Tue, 22 Jun 2021 03:58:09 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:58:08 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [RFC PATCH 05/43] KVM: PPC: Book3S HV P9: Reduce mftb per guest entry/exit
Date:   Tue, 22 Jun 2021 20:56:58 +1000
Message-Id: <20210622105736.633352-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

mftb is serialising (dispatch next-to-complete) so it is heavy weight
for a mfspr. Avoid reading it multiple times in the entry or exit paths.
A small number of cycles delay to timers is tolerable.

-118 cycles (9137) POWER9 virt-mode NULL hcall

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          | 4 ++--
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index a413377aafb5..5ec534620e07 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3794,7 +3794,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	 *
 	 * XXX: Another day's problem.
 	 */
-	mtspr(SPRN_DEC, vcpu->arch.dec_expires - mftb());
+	mtspr(SPRN_DEC, vcpu->arch.dec_expires - tb);
 
 	if (kvmhv_on_pseries()) {
 		/*
@@ -3914,7 +3914,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->in_guest = 0;
 
 	next_timer = timer_get_next_tb();
-	set_dec(next_timer - mftb());
+	set_dec(next_timer - tb);
 	/* We may have raced with new irq work */
 	if (test_irq_work_pending())
 		set_dec(1);
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 63afd277c5f3..c4f3e066fcb4 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -203,7 +203,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	unsigned long host_dawr1;
 	unsigned long host_dawrx1;
 
-	hdec = time_limit - mftb();
+	tb = mftb();
+	hdec = time_limit - tb;
 	if (hdec < 0)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
 
@@ -215,7 +216,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	vcpu->arch.ceded = 0;
 
 	if (vc->tb_offset) {
-		u64 new_tb = mftb() + vc->tb_offset;
+		u64 new_tb = tb + vc->tb_offset;
 		mtspr(SPRN_TBU40, new_tb);
 		tb = mftb();
 		if ((tb & 0xffffff) < (new_tb & 0xffffff))
-- 
2.23.0

