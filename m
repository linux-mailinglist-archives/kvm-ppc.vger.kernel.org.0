Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1203E0A63
	for <lists+kvm-ppc@lfdr.de>; Thu,  5 Aug 2021 00:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhHDW3Y (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 4 Aug 2021 18:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233831AbhHDW3X (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 4 Aug 2021 18:29:23 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF958C061798
        for <kvm-ppc@vger.kernel.org>; Wed,  4 Aug 2021 15:29:09 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id na18-20020a17090b4c12b0290178153d1c65so3752778pjb.4
        for <kvm-ppc@vger.kernel.org>; Wed, 04 Aug 2021 15:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3qLK4Nv4GPhySUMhSJiYmgwBgyQ559hu8zpABx1xjR0=;
        b=TgtY1f7yds1E8Fs3NAPTCRCGoGCzS5AfionwpI+MG424S+xOhXX/S/HKxwkbx8Vvj/
         yazkb3I+Jgx67wL8PDx6Iq+b5JxU9AtnsV3flsj73g2UIdoiudSEy8eXpkQXEDue1vCn
         cJZIJDk5Ig6BKELnCyLOB5d/rdAylN9XvzXciHPC6WiQF0BjhLbhaXUYw9HJHw9cfBGj
         QVyhRedd8QSJfTjjkEttHGRKF2RJvDLBKqNghlzzsCgiyulFkqrNCf+N5pPjJ43WAce9
         P0xqhY7rY5+DNmvFCP0/yu0dMIry4rv2bXXKhRNnjJBuy5sXQV/6bzLn1Y0KIQRNTLy6
         8GYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3qLK4Nv4GPhySUMhSJiYmgwBgyQ559hu8zpABx1xjR0=;
        b=OQg04Euht6l/TvBby7N5gYeOMdqc0g6F2qCQP2NFEzCG9rqk4li3+6ZWwiN+OuiR9p
         ZDjisHc/O6r2rb9OS1vtipjsEl02nZrm934/marqGdZRZWgrFftUXhmwIrRnRJJ+xDmN
         vrLTjJOpy+uikvdpwVlyfJJB4SB+zdibIu30QDsT+dUoreEOlzelJ/67f/ux85jMwK2b
         2P0NvvsvUwHo1sQIhGuVoYrhKwvgbYWexOkbztFIWGpl/rDQ+kQefez1HJsDZ/RgAfzj
         RwxpSOJphb31iqLKcsYogIGV6W/58VBK7QTLYrx8ei6wgy0Yf+Dt3pYwAOloGRaiop51
         KGUA==
X-Gm-Message-State: AOAM533jiSZU9GAZC7NV2wbpP1ESgP3MHQGrPkkKpYyS70XPlF8OWdIL
        c6y1LdHTinbtfxt7GD79rGP26bXyNdOAfA==
X-Google-Smtp-Source: ABdhPJxFOMR8j/pwMF2t/iZDzGRGA/E3skLYQpraW5OBBp83QOPT/xwsoQ9MJAHsnFYumDWWqxb8fwvqR5OQBQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:f293:: with SMTP id
 fs19mr636339pjb.0.1628116148870; Wed, 04 Aug 2021 15:29:08 -0700 (PDT)
Date:   Wed,  4 Aug 2021 22:28:43 +0000
In-Reply-To: <20210804222844.1419481-1-dmatlack@google.com>
Message-Id: <20210804222844.1419481-7-dmatlack@google.com>
Mime-Version: 1.0
References: <20210804222844.1419481-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v2 6/7] KVM: x86/mmu: Rename __gfn_to_rmap to gfn_to_rmap
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

gfn_to_rmap was removed in the previous patch so there is no need to
retain the double underscore on __gfn_to_rmap.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c       | 25 ++++++++++++-------------
 arch/x86/kvm/mmu/mmu_audit.c |  4 ++--
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 370a6ebc2ede..df493729d86c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1034,8 +1034,8 @@ static bool pte_list_destroy(struct kvm_rmap_head *rmap_head,
 	return true;
 }
 
-static struct kvm_rmap_head *__gfn_to_rmap(gfn_t gfn, int level,
-					   const struct kvm_memory_slot *slot)
+static struct kvm_rmap_head *gfn_to_rmap(gfn_t gfn, int level,
+					 const struct kvm_memory_slot *slot)
 {
 	unsigned long idx;
 
@@ -1060,7 +1060,7 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 	sp = sptep_to_sp(spte);
 	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	rmap_head = __gfn_to_rmap(gfn, sp->role.level, slot);
+	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 	return pte_list_add(vcpu, spte, rmap_head);
 }
 
@@ -1084,7 +1084,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	slots = kvm_memslots_for_spte_role(kvm, sp->role);
 
 	slot = __gfn_to_memslot(slots, gfn);
-	rmap_head = __gfn_to_rmap(gfn, sp->role.level, slot);
+	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 
 	__pte_list_remove(spte, rmap_head);
 }
@@ -1306,8 +1306,8 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 		return;
 
 	while (mask) {
-		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
-					  PG_LEVEL_4K, slot);
+		rmap_head = gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
+					PG_LEVEL_4K, slot);
 		__rmap_write_protect(kvm, rmap_head, false);
 
 		/* clear the first set bit */
@@ -1339,8 +1339,8 @@ static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 		return;
 
 	while (mask) {
-		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
-					  PG_LEVEL_4K, slot);
+		rmap_head = gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
+					PG_LEVEL_4K, slot);
 		__rmap_clear_dirty(kvm, rmap_head, slot);
 
 		/* clear the first set bit */
@@ -1406,7 +1406,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 
 	if (kvm_memslots_have_rmaps(kvm)) {
 		for (i = min_level; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
-			rmap_head = __gfn_to_rmap(gfn, i, slot);
+			rmap_head = gfn_to_rmap(gfn, i, slot);
 			write_protected |= __rmap_write_protect(kvm, rmap_head, true);
 		}
 	}
@@ -1506,9 +1506,8 @@ rmap_walk_init_level(struct slot_rmap_walk_iterator *iterator, int level)
 {
 	iterator->level = level;
 	iterator->gfn = iterator->start_gfn;
-	iterator->rmap = __gfn_to_rmap(iterator->gfn, level, iterator->slot);
-	iterator->end_rmap = __gfn_to_rmap(iterator->end_gfn, level,
-					   iterator->slot);
+	iterator->rmap = gfn_to_rmap(iterator->gfn, level, iterator->slot);
+	iterator->end_rmap = gfn_to_rmap(iterator->end_gfn, level, iterator->slot);
 }
 
 static void
@@ -1638,7 +1637,7 @@ static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 
 	sp = sptep_to_sp(spte);
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	rmap_head = __gfn_to_rmap(gfn, sp->role.level, slot);
+	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 
 	kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
 	kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
diff --git a/arch/x86/kvm/mmu/mmu_audit.c b/arch/x86/kvm/mmu/mmu_audit.c
index cedc17b2f60e..9e7dcf999f08 100644
--- a/arch/x86/kvm/mmu/mmu_audit.c
+++ b/arch/x86/kvm/mmu/mmu_audit.c
@@ -147,7 +147,7 @@ static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
 		return;
 	}
 
-	rmap_head = __gfn_to_rmap(gfn, rev_sp->role.level, slot);
+	rmap_head = gfn_to_rmap(gfn, rev_sp->role.level, slot);
 	if (!rmap_head->val) {
 		if (!__ratelimit(&ratelimit_state))
 			return;
@@ -200,7 +200,7 @@ static void audit_write_protection(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 	slots = kvm_memslots_for_spte_role(kvm, sp->role);
 	slot = __gfn_to_memslot(slots, sp->gfn);
-	rmap_head = __gfn_to_rmap(sp->gfn, PG_LEVEL_4K, slot);
+	rmap_head = gfn_to_rmap(sp->gfn, PG_LEVEL_4K, slot);
 
 	for_each_rmap_spte(rmap_head, &iter, sptep) {
 		if (is_writable_pte(*sptep))
-- 
2.32.0.554.ge1b32706d8-goog

