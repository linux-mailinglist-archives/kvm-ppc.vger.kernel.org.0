Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85663D51AA
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhGZDKl (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhGZDKk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:10:40 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A68BC061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:09 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id ds11-20020a17090b08cbb0290172f971883bso17851740pjb.1
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EgZ4lpFfP2pWHmRv1UKIWaTNAZ0Rl+EpOrIWSU3SiM0=;
        b=XzrO6kzkK2HwLUUSSSBJzaIK9uqXtBDKZRhxDjYmwEa2A+BO7maUk5GqoxrL6ZAg5L
         QFjX4zYm2+S7/i/xcWeGC3RVwtBkXMxYiwetxongZEqhUMgt/q0LI9AynUyeU34Qc1GM
         pcOqWtXh+s5tJdBwLfRrRzDjGdVbWGGPw6IndAZS27ZC/rMcaokeGA2JCRg1S3lTh9TA
         jcFmA4//GKObolRxpmJ5JSiR7v/aFhr1D64UMRabmOw3+SqIIXVb/6XbRHZiGXVu/zxZ
         YUMHCMb+1EyfCaPWU/wlcdgkyAMvlFum+3dyQHqfLm3xu0ddY0+vIZeLg4rjtKgo+DM1
         7sFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EgZ4lpFfP2pWHmRv1UKIWaTNAZ0Rl+EpOrIWSU3SiM0=;
        b=f7gA0AZfxO+hF+CrABBi/fIEyakrnrSJ8vJgt9UD3x3BhZry5fBnPaWjbdWqZxmE0v
         L9wsshefCc37kGSpGFat6B844Wgff0FWB01JwBB+RR1PRnqL6eTXH6AhijWj/8TsNQnG
         KOSN/qtRvWkeAsKQoCwqlm5rLtFAOGweEQi7pKAbja8tJJGCJFZsElPZAaL4qmZ2NZ3+
         ogZIOk6DZl58GRg6tv3kwFHygXv2OyOEIS6n1Dd4hoGfXWuuwpdx5zGIzC/ERMlevIGb
         RinpQsfaJ3gzAlTqbbCqDp7jNfJj/aJq+VJ8Wo5i8HNILrKkNRiSHSFzexyfRDGuSsld
         HJVg==
X-Gm-Message-State: AOAM533rq5KhC1wF7L2KFxXchu2QysKHko5PXF1TFq6DmEDswu+I6W8N
        x8kIzyQGbUbxv8Irb6FVoHHxJuv94uE=
X-Google-Smtp-Source: ABdhPJxJe/TQNIbWluVSSKqWVVzlk1rNVgOoBs3cG3lcm2X/e4R7v/2XpBTZqoQ5lREEQFjwzZzohA==
X-Received: by 2002:a62:cfc4:0:b029:2fe:eaf8:8012 with SMTP id b187-20020a62cfc40000b02902feeaf88012mr15652003pfg.45.1627271469004;
        Sun, 25 Jul 2021 20:51:09 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:51:08 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v1 10/55] KVM: PPC: Book3S HV P9: Reduce mftb per guest entry/exit
Date:   Mon, 26 Jul 2021 13:49:51 +1000
Message-Id: <20210726035036.739609-11-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
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
index 82976f734bd1..6e6cfb10e9bb 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3896,7 +3896,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	 *
 	 * XXX: Another day's problem.
 	 */
-	mtspr(SPRN_DEC, vcpu->arch.dec_expires - mftb());
+	mtspr(SPRN_DEC, vcpu->arch.dec_expires - tb);
 
 	if (kvmhv_on_pseries()) {
 		/*
@@ -4019,7 +4019,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->in_guest = 0;
 
 	next_timer = timer_get_next_tb();
-	set_dec(next_timer - mftb());
+	set_dec(next_timer - tb);
 	/* We may have raced with new irq work */
 	if (test_irq_work_pending())
 		set_dec(1);
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 0ff9ddb5e7ca..bd8cf0a65ce8 100644
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

