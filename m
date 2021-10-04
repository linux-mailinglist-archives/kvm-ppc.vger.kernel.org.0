Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5654242134C
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbhJDQDG (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236220AbhJDQDG (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:03:06 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0186BC061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:01:17 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id j4so206851plx.4
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P62UrD3SpPpaMK7k10CAwEFBjd5vnrhxdqO8ECNd8U0=;
        b=FCziMgI9AaGEovNt/QKLpPFBLgnJjYeeHh/KRLugwuD861QiK50nr058K9Ls+5nXL8
         UDc74nFKDZj3TyN7Uw/4khxZgSYpf9hzyl5DI8pnjlCX09GqR223NcD7CMd8sdwDRYn2
         +JTQw/COgcHOgNRbr4JdWEhgBSQlBl1SrgiEbEF3iPsz1Aa2ZlPmmSe1DnuNRrBct5Hw
         5zXQP40YyvrWnAVvY/An/Htk3lvjbz7omdInkk5LRsjpqtGKffTNEt+NBLKKiUh5QQlF
         Mq0/gl9YnVp83uV6Kw5KFsf42AHwSDZQ+pZGQNTKAHHI81OhFbwkHkWnopV26/Yvpw/K
         cOGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P62UrD3SpPpaMK7k10CAwEFBjd5vnrhxdqO8ECNd8U0=;
        b=iWV1UaToe7Rvy6IQHi8V9/xPWsrcla9YeZ3+WzuvtNWmaqNz0fDvTJRY7cDf7KpToi
         0cZUVUEySsr8jdXbP3Tl3WlK5pMYR8xgYs1qJPL8kz8WZu5SxaZ5sENEsUFZcnZENwE3
         NW9nDcGPVvYhPPzeTFj6DY4kJ35QCWcKxunJ9ZZwcESlTc1S1XbvZHleKiw0Qil5wB9J
         hSgBxAuWHm5a95r7COED1nX/2NdpVz2yghaplO34En3Qy3Qsj+2dkNhBb74dDlonVU7d
         rY3QJ+5MayWsnEzLWmPddkxUVWlAZhLWsWRumfZsHvqQFAsRQv1698FNAWGG71t6S7Se
         Y0KQ==
X-Gm-Message-State: AOAM533ERtCu+/n4/KU9jpwZxnN6ESluwNWzl3xU3Ent9U2AqgZbFTyk
        FGPck7upgowfaZORu6k+qf85TGHrdhQ=
X-Google-Smtp-Source: ABdhPJyK1bPWSFe9put/M7hNKFj8s2/NB8n6YBriVYPsFRbJTuQrzXDQSsX+VXK8hzI3gEdXK27xzw==
X-Received: by 2002:a17:90b:1d8f:: with SMTP id pf15mr30069847pjb.200.1633363276385;
        Mon, 04 Oct 2021 09:01:16 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:01:16 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v3 06/52] KVM: PPC: Book3S HV P9: Reduce mftb per guest entry/exit
Date:   Tue,  5 Oct 2021 02:00:03 +1000
Message-Id: <20211004160049.1338837-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

mftb is serialising (dispatch next-to-complete) so it is heavy weight
for a mfspr. Avoid reading it multiple times in the entry or exit paths.
A small number of cycles delay to timers is tolerable.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          | 4 ++--
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 30d400bf161b..e4482bf546ed 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3927,7 +3927,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	 *
 	 * XXX: Another day's problem.
 	 */
-	mtspr(SPRN_DEC, vcpu->arch.dec_expires - mftb());
+	mtspr(SPRN_DEC, vcpu->arch.dec_expires - tb);
 
 	if (kvmhv_on_pseries()) {
 		/*
@@ -4050,7 +4050,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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

