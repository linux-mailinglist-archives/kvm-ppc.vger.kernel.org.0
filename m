Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1606B349F6D
	for <lists+kvm-ppc@lfdr.de>; Fri, 26 Mar 2021 03:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhCZCUO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Mar 2021 22:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbhCZCUN (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Mar 2021 22:20:13 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D09C0613D7
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Mar 2021 19:20:13 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i2so8371710ybl.21
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Mar 2021 19:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=xb8DgI2xFcrM/12UvqDPQlPXHEZwzPOiZzDwlsIie/g=;
        b=LTA+FlztlbawA45c1WTNtB0+0k4zDG2JNcBSVgOBw6hAgXeXfNjZbqxa0273lIWLNe
         ttjcg3fq+z634BQAWTxUlSsrRwNAaP+NP0BoTVohovvNTClDA7Atl31Oegy0JstB9ddH
         QquMjA9vYXTD8sE0ETK+TS3DQ0/9PyHdPbhasPovVlJc6LBQ4ZzAIKNbkbAQxLe+0uY9
         5ul5DAL52znGITYaaSnYG1czEu70soT/ovFzF22WuRsZzZM2LTU5TaSfaNlMMeAYoxEh
         nxkXSMEvdAqjZ2IhpJWyzFxM0kGdcqc6rH1PgDdXHrzIHZH3KWpk77UxwCuoas+sWLNA
         Nygg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=xb8DgI2xFcrM/12UvqDPQlPXHEZwzPOiZzDwlsIie/g=;
        b=NHDMx4i3bLiQUU1oK3UVZPiKJcGyqLEs2RIQifNmoefK3L+GxRMYKBV+0ZurVxiX/B
         R8NRzRZpD40OL/I+qJTPxC5roVporRjiNV0vr9PIuLb5t0azAVp9IuJxRmbPyqvgN+rD
         oABeGc/aCsHx9Sp+XP6bq6A6Pp7fmvCUPAnhTi+bfb7yRLqqLqHpb14frB/eIQgv8R4h
         pd2D3twirauFDwOJ8nMyzZl3BWJdMbrNEHPTkXF0pXNTvgHnmquoza2s+F5ab53eFmKo
         j0pqhXHuitibIpBEj4ksIKC23/mCiLDVHL0hTDVgKF5miZLh/zgpA2kWqOjSK/5KoeUc
         D2aA==
X-Gm-Message-State: AOAM530FfbKUbUNiyJE6GXyBhwCmJd2Adh+xsnf4cePP9ORxXPurcwJ+
        ihIgwMZ+uVfCfF+dDDApEx9L3JtprQY=
X-Google-Smtp-Source: ABdhPJzT/d6MruEkvrArmoOcIHLexgvlTJlZNDyv9Tx14134QiRzKCyIxhCXc8QGkX5T07WTvqrR6kS/xTk=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a25:37c1:: with SMTP id e184mr16469856yba.260.1616725212722;
 Thu, 25 Mar 2021 19:20:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Mar 2021 19:19:40 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 01/18] KVM: x86/mmu: Coalesce TDP MMU TLB flushes when zapping
 collapsible SPTEs
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

When zapping collapsible SPTEs across multiple roots, gather pending
flushes and perform a single remote TLB flush at the end, as opposed to
flushing after processing every root.

Note, flush may be cleared by the result of zap_collapsible_spte_range().
This is intended and correct, e.g. yielding may have serviced a prior
pending flush.

Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 08667e3cf091..463f1be6ff0d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1278,21 +1278,21 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
  * Clear leaf entries which could be replaced by large mappings, for
  * GFNs within the slot.
  */
-static void zap_collapsible_spte_range(struct kvm *kvm,
+static bool zap_collapsible_spte_range(struct kvm *kvm,
 				       struct kvm_mmu_page *root,
-				       struct kvm_memory_slot *slot)
+				       struct kvm_memory_slot *slot,
+				       bool flush)
 {
 	gfn_t start = slot->base_gfn;
 	gfn_t end = start + slot->npages;
 	struct tdp_iter iter;
 	kvm_pfn_t pfn;
-	bool spte_set = false;
 
 	rcu_read_lock();
 
 	tdp_root_for_each_pte(iter, root, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, spte_set)) {
-			spte_set = false;
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, flush)) {
+			flush = false;
 			continue;
 		}
 
@@ -1308,12 +1308,12 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
 
-		spte_set = true;
+		flush = true;
 	}
 
 	rcu_read_unlock();
-	if (spte_set)
-		kvm_flush_remote_tlbs(kvm);
+
+	return flush;
 }
 
 /*
@@ -1324,6 +1324,7 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				       struct kvm_memory_slot *slot)
 {
 	struct kvm_mmu_page *root;
+	bool flush = false;
 	int root_as_id;
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root) {
@@ -1331,8 +1332,11 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 		if (root_as_id != slot->as_id)
 			continue;
 
-		zap_collapsible_spte_range(kvm, root, slot);
+		flush = zap_collapsible_spte_range(kvm, root, slot, flush);
 	}
+
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
 }
 
 /*
-- 
2.31.0.291.g576ba9dcdaf-goog

