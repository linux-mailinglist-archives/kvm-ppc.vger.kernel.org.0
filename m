Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71812349FA1
	for <lists+kvm-ppc@lfdr.de>; Fri, 26 Mar 2021 03:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhCZCUw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Mar 2021 22:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbhCZCU2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Mar 2021 22:20:28 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1719C061763
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Mar 2021 19:20:27 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id m35so4440748qtd.11
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Mar 2021 19:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=6DC92nb/KI7jWYCp6JOuoACO+r7yp8IjmJZ11jFmVcc=;
        b=JbUTKZPl/W/MrrvWQUZUwB6/PNz+uprjL43QoBtU1wD/mAej30Q8jYby+47AHKHhaD
         qBqEBSQiu2bEr1qfUHbwQYlI6gWDl4chgn5S8D90qIehLlVx/nchC3vJJMtesz8zy8/Y
         M1LbviODPL1MGWHOIgE4Z5dpFy6id4wLzGJaHGzRuSpy/ZC1eQarGzMJCuDST+iapHDq
         hqHQp6qA6x7NQdKxbbnSJd/iB8Dkv/td88Lb87UdQ6D804kTiRc9d9Vha8oDU/N1jtA7
         3mxTxHygoTzC20DEx3ttGZ8pl2+fGX8Q1O74BGCQbeoumy93ZYjiqrVLI4BWvrM36iOI
         OzrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=6DC92nb/KI7jWYCp6JOuoACO+r7yp8IjmJZ11jFmVcc=;
        b=WqOLBBTGLN4I/lW6ZbuQ/R3sj3VxtpAyJdRLNBIHC0LVn+cWCEzx9xT5wj/DNVROfA
         mQaOcyhhbj8rHgEK0areVrpDJ1KpWlSm7VJAox04TFDGhMFYk/PHnntcSOeZFA93F/RS
         d05IDCSlc4/rhYLZ7NjuSy1qPdeqBuTAouDw5I6wl4PMPmDZQE3ro+tVKBfsOgo2B3+H
         atdn7EoLb6I/7ziH3GWeJ3y9x7C8727bs/XipBVGKybRrIqhg8Gz0eEoF9LIRgH4hn/6
         wnOeOK13fzmU97wvAub64tHfiP6Fv0tutMksZhWmiaPnlt0OUAed+ErbIUBi4aMfTglu
         3c8w==
X-Gm-Message-State: AOAM531aKfv4d9ClScK1XcQGaidL5+ROGZgLB32Dv/72NCPNR+jKl1ST
        22S+c90FNcbX3vRR/Z3HysCFswYRqvo=
X-Google-Smtp-Source: ABdhPJxJS3G4Tp3oACq1aE0Kk13Vb4BteCkja1S5xuHowEheSpbEGJ6yFi11Vc4ofL1uuJo1KA/BTZTheoY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:ad4:5812:: with SMTP id dd18mr10836929qvb.7.1616725226899;
 Thu, 25 Mar 2021 19:20:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Mar 2021 19:19:46 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 07/18] KVM: x86/mmu: Use leaf-only loop for walking TDP SPTEs
 when changing SPTE
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Use the leaf-only TDP iterator when changing the SPTE in reaction to a
MMU notifier.  Practically speaking, this is a nop since the guts of the
loop explicitly looks for 4k SPTEs, which are always leaf SPTEs.  Switch
the iterator to match age_gfn_range() and test_age_gfn() so that a future
patch can consolidate the core iterating logic.

No real functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7fe5004b1565..a2b3d9699320 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1042,7 +1042,7 @@ static int set_tdp_spte(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	new_pfn = pte_pfn(*ptep);
 
-	tdp_root_for_each_pte(iter, root, gfn, gfn + 1) {
+	tdp_root_for_each_leaf_pte(iter, root, gfn, gfn + 1) {
 		if (iter.level != PG_LEVEL_4K)
 			continue;
 
-- 
2.31.0.291.g576ba9dcdaf-goog

