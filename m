Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950C33E9549
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233608AbhHKQCp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbhHKQCo (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:02:44 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315E8C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:21 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id lw7-20020a17090b1807b029017881cc80b7so10332803pjb.3
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mf3TsS6jnjzVv5z7Oc/l3ztXe15tmjXwWcLWuTb9UUM=;
        b=MKBLyv6wGjirWARVahG68wX6UrgEZSgOvPPYa+e+MMEbAl+ZEUFhYynkZ9VgiCZ6+2
         RT0p9qMBvtrwv0eUPtM81dEYCiHDM6kP44liDTZ54jMvUXsIUOHjH4i85t28AhNWH0gz
         DOjQfDpiljVuuE4WKftOVFxenUjuTdnOjJNEtKhwlkaX0Yq/gjt0Zqac02fb3WfOsySi
         StBUQiDe843a17MNiLDPPTU26xjV5Q38V4CB2ihhy32f2e03Ue0LkHcycjH2yBMNcOtC
         IJliefC+5Y6abbhVY6pVGPXuvYEUh4MNHCc8zPoTonxIipADPsqSXMpeCrcvnfXelCI2
         8EWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mf3TsS6jnjzVv5z7Oc/l3ztXe15tmjXwWcLWuTb9UUM=;
        b=ED57lL6AYvqak5bJX8IhEOZXOWxZSI06mjyQM27SfYcpe/3w6tdA5upwnoOOLtWNJN
         6tfRS4cTd+GNavZOh2VPyADGXe5u4v5RUjWv+ho4vs7GQji0GwLzRsyse+RWuuEe7f/T
         9pjm48+0AtR5ZYHd9AWjjBKTGK8UeI1TUDEweZw0+QY+NubjgqTS79YtQknoN9K7OOnf
         hyTD5YLGexxgJ+nmlLGpDKYBOzI37oHTywXiJxcUCTUau+a7Grneut5XZvz++tYZYlVI
         8T17AEw/NMYVATmj9HTKO1lxfgAnZ2cKnQCnpwEadjDVXOqmHsCZMLQaUX7hfUxoHB9M
         UfXQ==
X-Gm-Message-State: AOAM530Cbi/nsuYFIy60hQtfJkeI0FpLNYY5bgXBXyd+Q/OXZOxSKm79
        aIW4ngoQOj9dWEfHJTxqkcTVA7TkBEc=
X-Google-Smtp-Source: ABdhPJypWybYsNqExAn5HNW8Otzxniv9N4Q81dTKLO/4cyNhrdpr+vPvmKt/IyP44fho1NG0XMLA0A==
X-Received: by 2002:a63:f342:: with SMTP id t2mr540567pgj.45.1628697740696;
        Wed, 11 Aug 2021 09:02:20 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:02:20 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v2 14/60] KVM: PPC: Book3S HV P9: Reduce mftb per guest entry/exit
Date:   Thu, 12 Aug 2021 02:00:48 +1000
Message-Id: <20210811160134.904987-15-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
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
index 34e95d3c89e5..49a3c1e6a544 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3926,7 +3926,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	 *
 	 * XXX: Another day's problem.
 	 */
-	mtspr(SPRN_DEC, vcpu->arch.dec_expires - mftb());
+	mtspr(SPRN_DEC, vcpu->arch.dec_expires - tb);
 
 	if (kvmhv_on_pseries()) {
 		/*
@@ -4049,7 +4049,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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

