Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C023E0A5F
	for <lists+kvm-ppc@lfdr.de>; Thu,  5 Aug 2021 00:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbhHDW3U (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 4 Aug 2021 18:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233345AbhHDW3T (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 4 Aug 2021 18:29:19 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBD9C061799
        for <kvm-ppc@vger.kernel.org>; Wed,  4 Aug 2021 15:29:06 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id s8-20020a17090a0748b0290177ecd83711so3723077pje.2
        for <kvm-ppc@vger.kernel.org>; Wed, 04 Aug 2021 15:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=r4KSt42d4XavFyyskSaAj5jovU4vP6wMC/qg76U9MT4=;
        b=saxQfM/DE5sak0n0k+Ca6yVZgSHFIEiarauRjxb8Bi2TNY3WwY2jmG67uGoM9c1suk
         r5aU0FY2iJblaiCJtmntiICjJW/duvb69W2EnZqjsSIHouQYRCBVfi/h6k5ejfKZVPrc
         T/3LOilp5kT8fKEc4FY6UoPHHewFa4+4IBgUfAPTR+qb1rjzFD0Kl3+ulRk9XW1a+gjY
         T/hzfbh1YaM/pX2/O81b8XgSZxglG4VbXshYomH85qmvtNx4PomMbTCYYAW6NuN4CJEe
         oVcAqj9ThcvPiSvdGJs17TPOQa6cihAIjQPuO4rHsQ0DhfO+b2s83T0SPHzhxECGNx73
         fCcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=r4KSt42d4XavFyyskSaAj5jovU4vP6wMC/qg76U9MT4=;
        b=skbhgEf2A+36Fb1ixYu5G1RyOjbT0kQE8EmKvUDInPutIJcoDjUHG3gnOcfxkURvd9
         943l89RfKcu1CHLQRhzs6pUXy9jiLxfavSDZfCGsttRVerQ8RtXPSOFrc0YP6clJNbbm
         i/eV3Rsosid01TOBG5MAGk3aEKUS2yu8vDYC3zrN/v7ZqdhFdv9vPCf42LfZAHow08Se
         ZW9i1ZQOmXKCnjNthizUN5EtCJwobYSABqvKj7XzCZrpyI6TA4sSEYB/KZHcoQfRRbay
         tltu1oAPvGZGcGGCaup8PLuM6zw/WZ03c+n3BcCR8xFciG3b3iugMin3MtgM+Awwt6UD
         dVkQ==
X-Gm-Message-State: AOAM533Y0pKLOZEjKGDrqiEfFfM/yUQ98JcbXs0B4NFOVTm6JJue1qkK
        tnEYBsEX+cjINqUt2EEtjnJzRJQCJVU+Cg==
X-Google-Smtp-Source: ABdhPJwztsKEFalvD8y8OYu//RhJK+QYKZxTVE4i+C3flJ6riHbA13iz9bp8e/azIxsDBdK85rJet2G2FpIUag==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:15d3:b029:3a5:f4dd:4627 with
 SMTP id o19-20020a056a0015d3b02903a5f4dd4627mr1814572pfu.4.1628116145880;
 Wed, 04 Aug 2021 15:29:05 -0700 (PDT)
Date:   Wed,  4 Aug 2021 22:28:41 +0000
In-Reply-To: <20210804222844.1419481-1-dmatlack@google.com>
Message-Id: <20210804222844.1419481-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20210804222844.1419481-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v2 4/7] KVM: x86/mmu: Leverage vcpu->last_used_slot in tdp_mmu_map_handle_target_level
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

The existing TDP MMU methods to handle dirty logging are vcpu-agnostic
since they can be driven by MMU notifiers and other non-vcpu-specific
events in addition to page faults. However this means that the TDP MMU
is not benefiting from the new vcpu->last_used_slot. Fix that by
introducing a tdp_mmu_map_set_spte_atomic() which is only called during
a TDP page fault and has access to the kvm_vcpu for fast slot lookups.

This improves "Populate memory time" in dirty_log_perf_test by 5%:

Command                         | Before           | After
------------------------------- | ---------------- | -------------
./dirty_log_perf_test -v64 -x64 | 5.472321072s     | 5.169832886s

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 42 ++++++++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 43f12f5d12c0..dab6cb46cdb2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -542,15 +542,40 @@ static inline bool tdp_mmu_set_spte_atomic_no_dirty_log(struct kvm *kvm,
 	return true;
 }
 
-static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
-					   struct tdp_iter *iter,
-					   u64 new_spte)
+/*
+ * tdp_mmu_map_set_spte_atomic - Set a leaf TDP MMU SPTE atomically to resolve a
+ * TDP page fault.
+ *
+ * @vcpu: The vcpu instance that took the TDP page fault.
+ * @iter: a tdp_iter instance currently on the SPTE that should be set
+ * @new_spte: The value the SPTE should be set to
+ *
+ * Returns: true if the SPTE was set, false if it was not. If false is returned,
+ *	    this function will have no side-effects.
+ */
+static inline bool tdp_mmu_map_set_spte_atomic(struct kvm_vcpu *vcpu,
+					       struct tdp_iter *iter,
+					       u64 new_spte)
 {
+	struct kvm *kvm = vcpu->kvm;
+
 	if (!tdp_mmu_set_spte_atomic_no_dirty_log(kvm, iter, new_spte))
 		return false;
 
-	handle_changed_spte_dirty_log(kvm, iter->as_id, iter->gfn,
-				      iter->old_spte, new_spte, iter->level);
+	/*
+	 * Use kvm_vcpu_gfn_to_memslot() instead of going through
+	 * handle_changed_spte_dirty_log() to leverage vcpu->last_used_slot.
+	 */
+	if (is_writable_pte(new_spte)) {
+		struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, iter->gfn);
+
+		if (slot && kvm_slot_dirty_track_enabled(slot)) {
+			/* Enforced by kvm_mmu_hugepage_adjust. */
+			WARN_ON_ONCE(iter->level > PG_LEVEL_4K);
+			mark_page_dirty_in_slot(kvm, slot, iter->gfn);
+		}
+	}
+
 	return true;
 }
 
@@ -563,7 +588,7 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * immediately installing a present entry in its place
 	 * before the TLBs are flushed.
 	 */
-	if (!tdp_mmu_set_spte_atomic(kvm, iter, REMOVED_SPTE))
+	if (!tdp_mmu_set_spte_atomic_no_dirty_log(kvm, iter, REMOVED_SPTE))
 		return false;
 
 	kvm_flush_remote_tlbs_with_address(kvm, iter->gfn,
@@ -931,7 +956,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
-	else if (!tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
+	else if (!tdp_mmu_map_set_spte_atomic(vcpu, iter, new_spte))
 		return RET_PF_RETRY;
 
 	/*
@@ -1035,8 +1060,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			new_spte = make_nonleaf_spte(child_pt,
 						     !shadow_accessed_mask);
 
-			if (tdp_mmu_set_spte_atomic(vcpu->kvm, &iter,
-						    new_spte)) {
+			if (tdp_mmu_set_spte_atomic_no_dirty_log(vcpu->kvm, &iter, new_spte)) {
 				tdp_mmu_link_page(vcpu->kvm, sp, true,
 						  huge_page_disallowed &&
 						  req_level >= iter.level);
-- 
2.32.0.554.ge1b32706d8-goog

