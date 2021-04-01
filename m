Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CDC351824
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 19:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbhDARoH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 13:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234620AbhDARi1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 13:38:27 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA82C0F26F3
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:05:01 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id l123so158775pfl.8
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q5kLhVg/MvykyPPNmMCuNWVc2bIiaBHBOMGefD2pi70=;
        b=o5x803vaLuhSLiL2m55/F18h/axKjowbv/0eLFEK1BEfhPNw/VYH96aFwytbqBXw7/
         8vzQA0Kl6Y590eyI/6zLOIh4XiS9OOD5GZCsDNHOukGmY+I/3oitK+TNJ2wJc5TRHeKM
         EIq7tBMspWCpDxapOj8396C0/rcunlNAchb/Y0NL5FA1VeBAAREWxL6NC5nRBNZaK3Bo
         eGFm3SP1PS/MSqWjSC3rgwsLQ6E4l7VYcQ6FjFRTd2h5gf3CmLMdwcQmKnupJISdL5ze
         LvrnzfHNm8JzTy7yTtKYK1YM60fZQ3RDj17MJTtbajWQXg4pq8T9Idp6PLGF3sRZr6aA
         acrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q5kLhVg/MvykyPPNmMCuNWVc2bIiaBHBOMGefD2pi70=;
        b=KwmoiYm7b/ffjFzpaawJ+4I7Q+BzTCX34txKE6aODZSupYcmvyVi94RDlkl/13/HFl
         MFoipz1YlphjttKQZd9hnctzLGGwzCghxFz/dFt3xJrSzJNwlKl5ffelh95PmgMihGAM
         /mEyDhcXyCjxZz/ymWxbY/9+jjS8plZxxiGX3YINqvGCelRYjoaRhnhtDZsjGfKdzQY0
         BXX996yXMMlLw9wDLoKSlHTKU18Q96GEJCNmcn6vHLl19VqejGpbBt/xQl9IdmK+Tewb
         4tLIpK6s0bbM5JAjSMc5u2FPQBB4XJDLhxh0WuZ3LyFxrtUGRLp9RAUaLpqnqM+FyxnK
         sIaQ==
X-Gm-Message-State: AOAM533XHoCujGGv/l/5N+mk7eZgvrWsuw1nINYAf+AKb3lhdoRZW5BF
        i2NT1ejYdpDKmLGA5+rtJ12D86bHpP4=
X-Google-Smtp-Source: ABdhPJx8LV+GqfZ+ydBxBTgRLBsgiGqZmiv4U0JPdlfOj8dd8zWmoiGU/1i3txf4PH8zazf/csVeGw==
X-Received: by 2002:a63:a54:: with SMTP id z20mr7879950pgk.228.1617289500976;
        Thu, 01 Apr 2021 08:05:00 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:05:00 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v5 27/48] KVM: PPC: Book3S HV P9: Reduce irq_work vs guest decrementer races
Date:   Fri,  2 Apr 2021 01:03:04 +1000
Message-Id: <20210401150325.442125-28-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
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
 arch/powerpc/kvm/book3s_hv.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 46f457c3b828..6cfac8f553f6 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3755,6 +3755,18 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -3891,6 +3903,9 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	next_timer = timer_get_next_tb();
 	mtspr(SPRN_DEC, next_timer - tb);
+	/* We may have raced with new irq work */
+	if (test_irq_work_pending())
+		set_dec(1);
 	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
 
 	kvmhv_load_host_pmu();
-- 
2.23.0

