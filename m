Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208A03E954D
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbhHKQCz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhHKQCz (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:02:55 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD195C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:31 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d1so3308564pll.1
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cKT4fTx7oGwRWzvpaHxdjqzbrtTqZjyygbqKOYWpOIc=;
        b=Qe0/FtQKhVwQV1cLcmplgCvwntQW+FjPNErVOqKGPL31gn6QeXoMl/3bNoON4C0gUH
         lv9QcHtJJ3G2J+FqJa/m5968lJbIzxGJpv7evVhhQxlXwCLdWs7AvWmbPtMCskfBnl7N
         gRkSo158HYGVTJmIYk3Ncr7DXnyIGqgVJrqgkJJBORe+PSItVe2DXoFTLqNje9qfV6Qs
         iiKuF5Q/24Pz19o+Ce0yqfyRbDGNL4PZ6fzEGoTkBe/6ueiAJfwGJUj5uEcKKAFBkOwR
         fd6+FgVRk74o3w7HRbJNBjkquh7y3Cev1tdKMFzEaASR9YqCj9u9Oyj8oVqIyx3J8POs
         7Law==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cKT4fTx7oGwRWzvpaHxdjqzbrtTqZjyygbqKOYWpOIc=;
        b=QgBJTfXRJIDBSBGR1S4MwAhDvB4/D1CGF/bcvZw9dg/dZDq6ofBUSYq51UeXCML85L
         EmujTGPn9afun7tbpRCTcH42ekYkJk0vhbOu1QGsa3Q0CMIbiZFeIXDR0zP1NOPzyeUL
         jvRzmTk1mFuuuk7HNvWoiXubkNAXODn79R3Frj4P+o44Sjiq/asPNUjQzn1/cPM8uecx
         kClAezbfIPSiQU3oex5rQow19V1qyQIaNavePQY/qQ2uhNo1Jt4zbh4X8XFBe6BFL3/n
         oinaQYgXqI0/x+DgIOhSN1IRR8IGoAt9CKVJ0Uqummqi/N1fL57F1eTfAa+P1dsPnF2c
         H6rw==
X-Gm-Message-State: AOAM532hlLvtErS+zQDhpIvucpZwpLrKlF9bxt1YHRokJqU1Y5d/zscr
        HgGfTNMwKOQAy10xlJX43EkZet+QEe0=
X-Google-Smtp-Source: ABdhPJwQ5ivMxxa21BFrRKDX9Rhm0Iomm4tEiMybappdPSnvp0DlNEF3LTosHm27OJKOt4BGfREdVQ==
X-Received: by 2002:a17:902:ecc6:b029:12c:44b:40bd with SMTP id a6-20020a170902ecc6b029012c044b40bdmr7605549plh.33.1628697751009;
        Wed, 11 Aug 2021 09:02:31 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:02:30 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 18/60] KVM: PPC: Book3S HV: Don't always save PMU for guest capable of nesting
Date:   Thu, 12 Aug 2021 02:00:52 +1000
Message-Id: <20210811160134.904987-19-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Provide a config option that controls the the workaround added by commit
63279eeb7f93a ("KVM: PPC: Book3S HV: Always save guest pmu for guest
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
index e45644657d49..d57dcbc4eb0f 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -131,6 +131,21 @@ config KVM_BOOK3S_HV_EXIT_TIMING
 
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
index 2fe01dc2062f..197665c1a1cd 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4033,8 +4033,14 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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

