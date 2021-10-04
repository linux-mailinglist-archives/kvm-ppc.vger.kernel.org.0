Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A87421353
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236263AbhJDQDR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236290AbhJDQDP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:03:15 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21222C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:01:26 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id on12-20020a17090b1d0c00b001997c60aa29so219100pjb.1
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oslM7klffgoOo53VoIAiFJMx7FPxrNftk+02tBkeY6s=;
        b=LPzQsVx4rkOGxLLHKYHLDQqOzFvI38KsG1kttIJJDtIMCdbRx1PnU6OglVO7Micaa0
         jsnXZBtiKBZjW76UQuAnFg6WFR93EYu+49rQkhEdpWcr9RQOVkmjspKLrfs0SmPtBVVH
         ZAB/kOjh5cTZ0sTD0QKN5puwLIhcvmRTK/NS66JLky3Q41RmA89TrMQHBJjGktdQ6ya/
         vuSeEImgwsHmjLLtErDzRKRB5qQkT7eFil8+jia7sGyb6RYNRROxgXH2T27hfSwqc/jg
         RKOa/LS+VxB3P6qzFSK6GigWPmVjM4gjFzVNZrW5Sr97pK1I4xxLekulnxsuwi5EmpPq
         rOYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oslM7klffgoOo53VoIAiFJMx7FPxrNftk+02tBkeY6s=;
        b=G2dcdqinbr86dCljhipHSmnZSjFZnJNKkI3VOREMNY8dQZN3MhXpkyxBO8D+5gIJSI
         6dFsO0SAdRbogJ1GpexUAOxMWqXmCZ9U67+dXMJ9pU+rH5eO22bRjMZfcEA6KB2pkm3v
         bHZhBVRvenOHa+7IKmQGqiILsQHlS8hVjzLhKWcZOprgdthZiqS8Juj3dKeyzbcnFGFn
         sBTCU30A2DhJsoITKL3Li+fAeTYtFvAA0WteSpX0o9/uzTrOE5hYAaH2EjdaqPhHuWT3
         bTooEX3AQlci1quuTHJGecNgAcFcA/hoxRKuESLfcw3yXSXhzfB8s/KcHGntxo7dNVL1
         7R9w==
X-Gm-Message-State: AOAM531JJuWu5EfO1T+kq8nTO3n7bqYeoRrIWnj6zTm5Rhv8hJCmAere
        ZyG3+LGuY9nok6X36PHyPEYyTizhKlU=
X-Google-Smtp-Source: ABdhPJysvUsKeQEhtUvipCr5T40K5nZMcks97YpkNLjlZsetXXqBEYEtzOUFlstJtKM5/TxJmfJfVw==
X-Received: by 2002:a17:90a:8b8d:: with SMTP id z13mr33328686pjn.214.1633363285542;
        Mon, 04 Oct 2021 09:01:25 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:01:25 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 10/52] KVM: PPC: Book3S HV: Don't always save PMU for guest capable of nesting
Date:   Tue,  5 Oct 2021 02:00:07 +1000
Message-Id: <20211004160049.1338837-11-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Provide a config option that controls the workaround added by commit
63279eeb7f93 ("KVM: PPC: Book3S HV: Always save guest pmu for guest
capable of nesting"). The option defaults to y for now, but is expected
to go away within a few releases.

Nested capable guests running with the earlier commit ("KVM: PPC: Book3S
HV Nested: Indicate guest PMU in-use in VPA") will now indicate the PMU
in-use status of their guests, which means the parent does not need to
unconditionally save the PMU for nested capable guests.

After this latest round of performance optimisations, this option costs
about 540 cycles or 10% entry/exit performance on a POWER9 nested-capable
guest.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/Kconfig     | 15 +++++++++++++++
 arch/powerpc/kvm/book3s_hv.c | 10 ++++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index ff581d70f20c..1e7aae522be8 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -130,6 +130,21 @@ config KVM_BOOK3S_HV_EXIT_TIMING
 
 	  If unsure, say N.
 
+config KVM_BOOK3S_HV_NESTED_PMU_WORKAROUND
+	bool "Nested L0 host workaround for L1 KVM host PMU handling bug" if EXPERT
+	depends on KVM_BOOK3S_HV_POSSIBLE
+	default !EXPERT
+	help
+	  Old nested HV capable Linux guests have a bug where the don't
+	  reflect the PMU in-use status of their L2 guest to the L0 host
+	  while the L2 PMU registers are live. This can result in loss
+          of L2 PMU register state, causing perf to not work correctly in
+	  L2 guests.
+
+	  Selecting this option for the L0 host implements a workaround for
+	  those buggy L1s which saves the L2 state, at the cost of performance
+	  in all nested-capable guest entry/exit.
+
 config KVM_BOOKE_HV
 	bool
 
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 463534402107..945fc9a96439 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4034,8 +4034,14 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		vcpu->arch.vpa.dirty = 1;
 		save_pmu = lp->pmcregs_in_use;
 	}
-	/* Must save pmu if this guest is capable of running nested guests */
-	save_pmu |= nesting_enabled(vcpu->kvm);
+	if (IS_ENABLED(CONFIG_KVM_BOOK3S_HV_NESTED_PMU_WORKAROUND)) {
+		/*
+		 * Save pmu if this guest is capable of running nested guests.
+		 * This is option is for old L1s that do not set their
+		 * lppaca->pmcregs_in_use properly when entering their L2.
+		 */
+		save_pmu |= nesting_enabled(vcpu->kvm);
+	}
 
 	kvmhv_save_guest_pmu(vcpu, save_pmu);
 #ifdef CONFIG_PPC_PSERIES
-- 
2.23.0

