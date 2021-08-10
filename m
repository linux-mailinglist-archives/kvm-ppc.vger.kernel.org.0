Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0995A3E8617
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 00:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235141AbhHJWdO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 10 Aug 2021 18:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235138AbhHJWdO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 10 Aug 2021 18:33:14 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0C8C061765
        for <kvm-ppc@vger.kernel.org>; Tue, 10 Aug 2021 15:32:51 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id z1-20020a1709030181b029012c775d35e1so11497151plg.20
        for <kvm-ppc@vger.kernel.org>; Tue, 10 Aug 2021 15:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=00ZMQWWrPnTtriCG8SBJuuMaQXJlszZtdg67sPgdI/k=;
        b=b4TEoEHibgtArcgU5tE6LTnUNCXRWt5oXS8XInj6uvzhOXp+5IMvJTiNnanSwrNxzZ
         JNa5WuA3g9KnlvPXV3dwANwBo+kdSXoix7+rwxcoHSdwrldY6RHEwkKROoLTM0j/6upk
         OfNJAeK8V7pr9uUzRtIzJvzveXP7eQYd1MOTojjKfO/BlMnin7FntnqDkt2mqevhSOtv
         vXspXWtp3hjB6lTmUqtieh25LZ8pHGSL6kfb7QoItz4ALgfPIFNMH1Pao6vyf9qIvHsy
         ZCEjRNzLKwQpEYomb1niFadN/X77nM6xFGZ7lVaoqqxAp8WpP57eBoBxPE89dAMOqXRx
         ROmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=00ZMQWWrPnTtriCG8SBJuuMaQXJlszZtdg67sPgdI/k=;
        b=oNmmKweD3IzZ5LGdg9Bkydj3104GUs2j+WLE7JyXEkjY4+OkpgRmjQYOEfsygzLrGq
         GsCv2EbfxURfUxvX89x5h0SMFswNWzdIP/cwAFEqPK4XLEq/2xloiLuwcbZMCKoih6Jc
         FBac1xwZ4etItDXAqoYOZ32PXtuX84BQ5m9naBtMmDoxAzU8+H8w1H6zID1V/PocSJwY
         SDVVwmm4A/kpgJnC0znrzpBluAcQlygxHjJIgXGYwfgaGbe2hGmx4Y+72F6bNR0ZtzLV
         LxJaeEwaz8HYlb721mRwlYCaML7pOKppp8fuPdMYDdeJkwpRya6w32ksk3NgC6e2EEYs
         Xwng==
X-Gm-Message-State: AOAM531VUFs/QMXV8qH8yz6FWDBHTEC/hmeRtcCNNNpIUxvU0Ib5+PWp
        TWbR0IZw2wbdQkVldRwxfdUanw/IcqfXD74gsA==
X-Google-Smtp-Source: ABdhPJydalLA/jRgj6Nhgmv8xUc+XGDGljHpp00AVmtDKGoywQiAjnc3hfU6gAH1vq4eXTiUpFlIk6rXV98LOIqVhw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:aa7:8148:0:b029:31b:10b4:f391 with
 SMTP id d8-20020aa781480000b029031b10b4f391mr24985012pfn.69.1628634770190;
 Tue, 10 Aug 2021 15:32:50 -0700 (PDT)
Date:   Tue, 10 Aug 2021 22:32:38 +0000
Message-Id: <20210810223238.979194-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH] KVM: stats: Add VM dirty_pages stats for the number of dirty pages
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Peter Feiner <pfeiner@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Add a generic VM stats dirty_pages to record the number of dirty pages
reflected in dirty_bitmap at the moment.

Original-by: Peter Feiner <pfeiner@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  8 ++++++--
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  1 +
 arch/powerpc/kvm/book3s_hv_rm_mmu.c    |  1 +
 include/linux/kvm_host.h               |  3 ++-
 include/linux/kvm_types.h              |  1 +
 virt/kvm/kvm_main.c                    | 26 +++++++++++++++++++++++---
 6 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index c63e263312a4..e4aafa10efa1 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -1122,8 +1122,10 @@ long kvmppc_hv_get_dirty_log_hpt(struct kvm *kvm,
 		 * since we always put huge-page HPTEs in the rmap chain
 		 * corresponding to their page base address.
 		 */
-		if (npages)
+		if (npages) {
 			set_dirty_bits(map, i, npages);
+			kvm->stat.generic.dirty_pages += npages;
+		}
 		++rmapp;
 	}
 	preempt_enable();
@@ -1178,8 +1180,10 @@ void kvmppc_unpin_guest_page(struct kvm *kvm, void *va, unsigned long gpa,
 	gfn = gpa >> PAGE_SHIFT;
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 	memslot = gfn_to_memslot(kvm, gfn);
-	if (memslot && memslot->dirty_bitmap)
+	if (memslot && memslot->dirty_bitmap) {
 		set_bit_le(gfn - memslot->base_gfn, memslot->dirty_bitmap);
+		++kvm->stat.generic.dirty_pages;
+	}
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 }
 
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index b5905ae4377c..3a6cb3854a44 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -1150,6 +1150,7 @@ long kvmppc_hv_get_dirty_log_radix(struct kvm *kvm,
 		j = i + 1;
 		if (npages) {
 			set_dirty_bits(map, i, npages);
+			kvm->stat.generic.dirty_pages += npages;
 			j = i + npages;
 		}
 	}
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 632b2545072b..16806bc473fa 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -109,6 +109,7 @@ void kvmppc_update_dirty_map(const struct kvm_memory_slot *memslot,
 	npages = (psize + PAGE_SIZE - 1) / PAGE_SIZE;
 	gfn -= memslot->base_gfn;
 	set_dirty_bits_atomic(memslot->dirty_bitmap, gfn, npages);
+	kvm->stat.generic.dirty_pages += npages;
 }
 EXPORT_SYMBOL_GPL(kvmppc_update_dirty_map);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f50bfcf225f0..1e8e66fb915b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1421,7 +1421,8 @@ struct _kvm_stats_desc {
 		KVM_STATS_BASE_POW10, -9)
 
 #define KVM_GENERIC_VM_STATS()						       \
-	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush)
+	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush),		       \
+	STATS_DESC_COUNTER(VM_GENERIC, dirty_pages)
 
 #define KVM_GENERIC_VCPU_STATS()					       \
 	STATS_DESC_COUNTER(VCPU_GENERIC, halt_successful_poll),		       \
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index ed6a985c5680..6c05df00aebf 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -78,6 +78,7 @@ struct kvm_mmu_memory_cache {
 
 struct kvm_vm_stat_generic {
 	u64 remote_tlb_flush;
+	u64 dirty_pages;
 };
 
 struct kvm_vcpu_stat_generic {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a438a7a3774a..93f0ca2ea326 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1228,6 +1228,19 @@ static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
 	return 0;
 }
 
+static inline unsigned long hweight_dirty_bitmap(
+						struct kvm_memory_slot *memslot)
+{
+	unsigned long i;
+	unsigned long count = 0;
+	unsigned long n = kvm_dirty_bitmap_bytes(memslot);
+
+	for (i = 0; i < n / sizeof(long); ++i)
+		count += hweight_long(memslot->dirty_bitmap[i]);
+
+	return count;
+}
+
 /*
  * Delete a memslot by decrementing the number of used slots and shifting all
  * other entries in the array forward one spot.
@@ -1612,6 +1625,7 @@ static int kvm_delete_memslot(struct kvm *kvm,
 	if (r)
 		return r;
 
+	kvm->stat.generic.dirty_pages -= hweight_dirty_bitmap(old);
 	kvm_free_memslot(kvm, old);
 	return 0;
 }
@@ -1733,8 +1747,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (r)
 		goto out_bitmap;
 
-	if (old.dirty_bitmap && !new.dirty_bitmap)
+	if (old.dirty_bitmap && !new.dirty_bitmap) {
+		kvm->stat.generic.dirty_pages -= hweight_dirty_bitmap(&old);
 		kvm_destroy_dirty_bitmap(&old);
+	}
 	return 0;
 
 out_bitmap:
@@ -1895,6 +1911,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 			offset = i * BITS_PER_LONG;
 			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
 								offset, mask);
+			kvm->stat.generic.dirty_pages -= hweight_long(mask);
 		}
 		KVM_MMU_UNLOCK(kvm);
 	}
@@ -2012,6 +2029,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 			flush = true;
 			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
 								offset, mask);
+			kvm->stat.generic.dirty_pages -= hweight_long(mask);
 		}
 	}
 	KVM_MMU_UNLOCK(kvm);
@@ -3062,11 +3080,13 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 		u32 slot = (memslot->as_id << 16) | memslot->id;
 
-		if (kvm->dirty_ring_size)
+		if (kvm->dirty_ring_size) {
 			kvm_dirty_ring_push(kvm_dirty_ring_get(kvm),
 					    slot, rel_gfn);
-		else
+		} else {
 			set_bit_le(rel_gfn, memslot->dirty_bitmap);
+			++kvm->stat.generic.dirty_pages;
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);

base-commit: d0732b0f8884d9cc0eca0082bbaef043f3fef7fb
-- 
2.32.0.605.g8dce9f2422-goog

