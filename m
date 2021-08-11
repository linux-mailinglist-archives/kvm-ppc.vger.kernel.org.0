Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994343E956F
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbhHKQEO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbhHKQEO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:04:14 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD876C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:50 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so10373771pjr.1
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2UkDeEQqH1oXKRQpz834yLkjuDuYrb2VyZuIaA4gH9A=;
        b=ZjnFCn5gGqX88WJn9BGjTMhZSskOyCntplbH/g6S0hEaleZr5BCBPSqqYr1hdRxyiZ
         C6I3o8HCzQY0NaGk7WVLDrm47eHb0a2Bu+/9pAFOwRiC30NtmvnOIRC+PMIzauiTnKTf
         HefkIhnb2JATZJOhQq6J3vWZSPS63ISjWNZ0LcDyDFACwG5VD2Suh3/bE2qbEiKB6Nvf
         bxdqhnOgwFLJeaxsF50Gx1ZdsocRqN/ZkT38REHgh4udrwYQ9HA+M+XUyP50bBxN3no+
         PcmgSj6140/6vJhbajLO4rkbCqLqobhPjiGUF6FoWbOnbXOKpK+GVAZU8iebYyKi4EpP
         t8/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2UkDeEQqH1oXKRQpz834yLkjuDuYrb2VyZuIaA4gH9A=;
        b=FZ0x8MGTWc8s51z167FA3TM/ZJ2xhT+uBpld3l8i+1YtKNHIVa+cov4cJtNiUJwSA2
         7G1m3bHQ92MiyLuWC5KaWcC7uOCSzgl9aH/1g9ja+zLdf7YWZOYTGA3DxhXIr48XoDhI
         dxD2vI2JLknv7KTSupnNFEO6V7YVF/im8FfZ+YivZfQ2jSyTPIr+28khrna90BmA2+Ig
         d/nY+YSeRGokwh0SddqOosnkj6zNmNqoapaAoE+k0304kbwJpctUn4y5jggV8ACOi4wK
         u1qZeHgtNgcKbCHVMLPg1t2tXFmFqAl5GZkNVjcYcO20/rxUY4YPnrjrV+WYXuVOcEwG
         c3uA==
X-Gm-Message-State: AOAM533AtCwNR40PG/1ea8JwRCOYLjPhbemJzICa291F9WP5XaP4lwfW
        UalU+NFhTgxcKb8I4xAFEqN3Ty8UrO4=
X-Google-Smtp-Source: ABdhPJxsjXX0Vn4evla/BCdzjDSDlmdyzl8fdfZgP73VPVWsj/bdlMQYLg81IYfh764HEpdllLZ6Kg==
X-Received: by 2002:a17:902:bcc2:b029:12c:de9d:3473 with SMTP id o2-20020a170902bcc2b029012cde9d3473mr4814824pls.6.1628697830226;
        Wed, 11 Aug 2021 09:03:50 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:03:50 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 48/60] KVM: PPC: Book3S HV P9: Test dawr_enabled() before saving host DAWR SPRs
Date:   Thu, 12 Aug 2021 02:01:22 +1000
Message-Id: <20210811160134.904987-49-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Some of the DAWR SPR access is already predicated on dawr_enabled(),
apply this to the remainder of the accesses.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 34 ++++++++++++++++-----------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 7fc391ecf39f..f8599e6f75fc 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -662,13 +662,16 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	host_hfscr = mfspr(SPRN_HFSCR);
 	host_ciabr = mfspr(SPRN_CIABR);
-	host_dawr0 = mfspr(SPRN_DAWR0);
-	host_dawrx0 = mfspr(SPRN_DAWRX0);
 	host_psscr = mfspr(SPRN_PSSCR);
 	host_pidr = mfspr(SPRN_PID);
-	if (cpu_has_feature(CPU_FTR_DAWR1)) {
-		host_dawr1 = mfspr(SPRN_DAWR1);
-		host_dawrx1 = mfspr(SPRN_DAWRX1);
+
+	if (dawr_enabled()) {
+		host_dawr0 = mfspr(SPRN_DAWR0);
+		host_dawrx0 = mfspr(SPRN_DAWRX0);
+		if (cpu_has_feature(CPU_FTR_DAWR1)) {
+			host_dawr1 = mfspr(SPRN_DAWR1);
+			host_dawrx1 = mfspr(SPRN_DAWRX1);
+		}
 	}
 
 	local_paca->kvm_hstate.host_purr = mfspr(SPRN_PURR);
@@ -1002,15 +1005,18 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	mtspr(SPRN_HFSCR, host_hfscr);
 	if (vcpu->arch.ciabr != host_ciabr)
 		mtspr(SPRN_CIABR, host_ciabr);
-	if (vcpu->arch.dawr0 != host_dawr0)
-		mtspr(SPRN_DAWR0, host_dawr0);
-	if (vcpu->arch.dawrx0 != host_dawrx0)
-		mtspr(SPRN_DAWRX0, host_dawrx0);
-	if (cpu_has_feature(CPU_FTR_DAWR1)) {
-		if (vcpu->arch.dawr1 != host_dawr1)
-			mtspr(SPRN_DAWR1, host_dawr1);
-		if (vcpu->arch.dawrx1 != host_dawrx1)
-			mtspr(SPRN_DAWRX1, host_dawrx1);
+
+	if (dawr_enabled()) {
+		if (vcpu->arch.dawr0 != host_dawr0)
+			mtspr(SPRN_DAWR0, host_dawr0);
+		if (vcpu->arch.dawrx0 != host_dawrx0)
+			mtspr(SPRN_DAWRX0, host_dawrx0);
+		if (cpu_has_feature(CPU_FTR_DAWR1)) {
+			if (vcpu->arch.dawr1 != host_dawr1)
+				mtspr(SPRN_DAWR1, host_dawr1);
+			if (vcpu->arch.dawrx1 != host_dawrx1)
+				mtspr(SPRN_DAWRX1, host_dawrx1);
+		}
 	}
 
 	if (vc->dpdes)
-- 
2.23.0

