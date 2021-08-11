Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282773E953C
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbhHKQCX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbhHKQCX (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:02:23 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E62C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:01:59 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id cp15-20020a17090afb8fb029017891959dcbso10347896pjb.2
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NYei3BlTiyrrgi66vFfJKSG/jGz/R3VmvpQE8Xx8Q/8=;
        b=RFqv6pBnoB7du76hq41hx30dFEObjs+y27xkrKJ93QHQHmoMIp/OW2w/t7RJk0Su2y
         2n2gwtAt1zZ5NkNe46HpWnrUtkKagG55+GaFEpCGn4IQoCdxstDT8bmKo1PTxwMCbVpG
         V4FxcnYv6DVQZXR2Ph9njPvAAR2n4HZwNQklt2QQc333LgH6AfFyMxAN6tUnIzQ+K6T6
         DGoF7TvtIVSpL0wOk5TcOE7n4jsEqovqcTMTg4OyUlNx/JQrsFJ9u7HdEwY6eyOpLSEz
         zNrrTkBu6g9VAg+aduWtbNxjTuXHfyQvkSFAqsKZ0lCRuvSdvy5s/yk878s04G+CyjDq
         p8/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NYei3BlTiyrrgi66vFfJKSG/jGz/R3VmvpQE8Xx8Q/8=;
        b=hB07XCgGwNGxls2nrrUcZA3QOLtuRpmXPQ44rCCmnw0+KYAMpv9WG+gP5e4hPHA/nG
         EVmcHveUEleOUW8xVpR0nhtV/jj4pnm/5od0OZEveCqRl3bLrVs4SHTOAT+V0vEjZaUs
         37xsGg5nALyJpmmWksZOqxcKVf+VqRMx/BlaM0/+CpsJlWiJrqHlQtBxwJPWv2nKpc3t
         Lxa50tOo9AqxpyAc5TxM6Gb50SJpV58gvF1kkTCha00AdwDfF+wVimgIi+spKAD0SDLP
         uWV0LMZamfTYt+4awz+04VVwOx+gcqks/Kk4WolK4rl4Y6zytqeCGi5jZf5mOBzwNfef
         lwfA==
X-Gm-Message-State: AOAM533K3vX/bxhGiU6Ki8F7kXYJoBvDvtIVSsbs4J1S0JpF74OARR2n
        9n6ZFEJzz2DUI4L1Yq5CEfIGrklxOdw=
X-Google-Smtp-Source: ABdhPJxmK/zmVg7WvVk6WLaFW5ifqZuJQ2yzKqGhVkALuU6uyQ2ci1JjQ5Tpz2QpAXv6xTtB+UnaVw==
X-Received: by 2002:a65:6894:: with SMTP id e20mr841206pgt.419.1628697719294;
        Wed, 11 Aug 2021 09:01:59 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:01:59 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 06/60] KVM: PPC: Book3S HV Nested: Make nested HFSCR state accessible
Date:   Thu, 12 Aug 2021 02:00:40 +1000
Message-Id: <20210811160134.904987-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

When the L0 runs a nested L2, there are several permutations of HFSCR
that can be relevant. The HFSCR that the L1 vcpu L1 requested, the
HFSCR that the L1 vcpu may use, and the HFSCR that is actually being
used to run the L2.

The L1 requested HFSCR is not accessible outside the nested hcall
handler, so copy that into a new kvm_nested_guest.hfscr field.

The permitted HFSCR is taken from the HFSCR that the L1 runs with,
which is also not accessible while the hcall is being made. Move
this into a new kvm_vcpu_arch.hfscr_permitted field.

These will be used by the next patch to improve facility handling
for nested guests, and later by facility demand faulting patches.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_book3s_64.h | 1 +
 arch/powerpc/include/asm/kvm_host.h      | 2 ++
 arch/powerpc/kvm/book3s_hv.c             | 2 ++
 arch/powerpc/kvm/book3s_hv_nested.c      | 5 +++--
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index eaf3a562bf1e..19b6942c6969 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -39,6 +39,7 @@ struct kvm_nested_guest {
 	pgd_t *shadow_pgtable;		/* our page table for this guest */
 	u64 l1_gr_to_hr;		/* L1's addr of part'n-scoped table */
 	u64 process_table;		/* process table entry for this guest */
+	u64 hfscr;			/* HFSCR that the L1 requested for this nested guest */
 	long refcnt;			/* number of pointers to this struct */
 	struct mutex tlb_lock;		/* serialize page faults and tlbies */
 	struct kvm_nested_guest *next;
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 9f52f282b1aa..a779f7849cfb 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -811,6 +811,8 @@ struct kvm_vcpu_arch {
 
 	u32 online;
 
+	u64 hfscr_permitted;	/* A mask of permitted HFSCR facilities */
+
 	/* For support of nested guests */
 	struct kvm_nested_guest *nested;
 	u32 nested_vcpu_id;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index e79eedb65e6b..c65bd8fa4368 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2718,6 +2718,8 @@ static int kvmppc_core_vcpu_create_hv(struct kvm_vcpu *vcpu)
 	if (cpu_has_feature(CPU_FTR_TM_COMP))
 		vcpu->arch.hfscr |= HFSCR_TM;
 
+	vcpu->arch.hfscr_permitted = vcpu->arch.hfscr;
+
 	kvmppc_mmu_book3s_hv_init(vcpu);
 
 	vcpu->arch.state = KVMPPC_VCPU_NOTREADY;
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 1eb4e989edc7..5ad5014c6f68 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -272,10 +272,10 @@ static void load_l2_hv_regs(struct kvm_vcpu *vcpu,
 				      (vc->lpcr & ~mask) | (*lpcr & mask));
 
 	/*
-	 * Don't let L1 enable features for L2 which we've disabled for L1,
+	 * Don't let L1 enable features for L2 which we don't allow for L1,
 	 * but preserve the interrupt cause field.
 	 */
-	vcpu->arch.hfscr = l2_hv->hfscr & (HFSCR_INTR_CAUSE | vcpu->arch.hfscr);
+	vcpu->arch.hfscr = l2_hv->hfscr & (HFSCR_INTR_CAUSE | vcpu->arch.hfscr_permitted);
 
 	/* Don't let data address watchpoint match in hypervisor state */
 	vcpu->arch.dawrx0 = l2_hv->dawrx0 & ~DAWRX_HYP;
@@ -362,6 +362,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	/* set L1 state to L2 state */
 	vcpu->arch.nested = l2;
 	vcpu->arch.nested_vcpu_id = l2_hv.vcpu_token;
+	l2->hfscr = l2_hv.hfscr;
 	vcpu->arch.regs = l2_regs;
 
 	/* Guest must always run with ME enabled, HV disabled. */
-- 
2.23.0

