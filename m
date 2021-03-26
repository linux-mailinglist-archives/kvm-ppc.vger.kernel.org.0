Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A57F349F90
	for <lists+kvm-ppc@lfdr.de>; Fri, 26 Mar 2021 03:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhCZCU4 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Mar 2021 22:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbhCZCUq (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Mar 2021 22:20:46 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FBAC0613D7
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Mar 2021 19:20:45 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a19so2613345ybg.10
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Mar 2021 19:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=TaRsW9hCT9gEJ/YVzW7kB9YFbRu5cnB3H0FViU1bRhk=;
        b=kBPgGMYl4blfSBIqQ5FKhwNHBKbvitDKr+WZYdt/8IhMnlfsrTKNXxhUeD4Dfv4OdK
         Qp85biDD6s+K+U5KksvGPm1ktvKtYdF7mnE9MrHxMeaVxGrZG5ap40dtbvhTh6LLvRmq
         EVe4q3actfo6eycSfr6QO9c/QHHJUOWKxLFg2JRrhbugVxZPDZF4Tws0K8Q0zTr01x17
         AhbFvngDP583OBSyiGm1/Mz3bjEOz7lQ/Yjo2wW5h41dxHGv5x1vrgqkeUC6D0RE05dK
         3WjGfoR4fP8tf2U8RHVaSt/5IZ2QjRAtja0LwszjEpZxXU5VWS0iy7Sr4MaEgtMnRZgZ
         ZNJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=TaRsW9hCT9gEJ/YVzW7kB9YFbRu5cnB3H0FViU1bRhk=;
        b=O+HQdc9auo89xghSJLFcOKIJIr4AJ4XtQY8+KUloG8GtD3rfS5aBjzZiTbzz8RAog1
         I9t35X8e6u3nsk5ZLR3B2Gt+pfNFi6ifuhFPqI9UCx1ulDFMkc6+3nb/w7x7QUGqRoDK
         t4uyVaI9IIQ/t8YyDuUNAqFOCg8GryTKncGtXqi18jzKOwHUftVEvmEQe8icORoGmaXV
         Kxd6mF4ZA6ppf5B7C0KrR+2EpQafd2Ouh2DO6ffxReL7RbElk1f1CxLvEfoIolWDGWWx
         K3BLaTI7kqXQGVvQWhEUz2Zu+kvycCB6Fy1RHTIz236Dw+UKkeGg0pou5LIvZumjbuw0
         J/Aw==
X-Gm-Message-State: AOAM5338esqYf1WwXEQBIXxjY6XE1097nBZr+O5igcdh/wKquhlkifCx
        CEigI/lMUbx71LrN/jA0DOu/IIs9mR4=
X-Google-Smtp-Source: ABdhPJy2kLsKpNboktKYvRYtclaI6TLQhJXYHuQbVsBNzQbrVXujQcH971ASv0KdE05FkcrHFObwQrNjrD8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a25:5f46:: with SMTP id h6mr16551423ybm.255.1616725245154;
 Thu, 25 Mar 2021 19:20:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Mar 2021 19:19:54 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-16-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 15/18] KVM: Take mmu_lock when handling MMU notifier iff the
 hva hits a memslot
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

Defer acquiring mmu_lock in the MMU notifier paths until a "hit" has been
detected in the memslots, i.e. don't take the lock for notifications that
don't affect the guest.

For small VMs, spurious locking is a minor annoyance.  And for "volatile"
setups where the majority of notifications _are_ relevant, this barely
qualifies as an optimization.

But, for large VMs (hundreds of threads) with static setups, e.g. no
page migration, no swapping, etc..., the vast majority of MMU notifier
callbacks will be unrelated to the guest, e.g. will often be in response
to the userspace VMM adjusting its own virtual address space.  In such
large VMs, acquiring mmu_lock can be painful as it blocks vCPUs from
handling page faults.  In some scenarios it can even be "fatal" in the
sense that it causes unacceptable brownouts, e.g. when rebuilding huge
pages after live migration, a significant percentage of vCPUs will be
attempting to handle page faults.

x86's TDP MMU implementation is especially susceptible to spurious
locking due it taking mmu_lock for read when handling page faults.
Because rwlock is fair, a single writer will stall future readers, while
the writer is itself stalled waiting for in-progress readers to complete.
This is exacerbated by the MMU notifiers often firing multiple times in
quick succession, e.g. moving a page will (always?) invoke three separate
notifiers: .invalidate_range_start(), invalidate_range_end(), and
.change_pte().  Unnecessarily taking mmu_lock each time means even a
single spurious sequence can be problematic.

Note, this optimizes only the unpaired callbacks.  Optimizing the
.invalidate_range_{start,end}() pairs is more complex and will be done in
a future patch.

Suggested-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index bfa43eea891a..0c2aff8a4aa1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -458,6 +458,7 @@ struct kvm_hva_range {
 	unsigned long end;
 	pte_t pte;
 	hva_handler_t handler;
+	bool caller_locked;
 	bool flush_on_ret;
 	bool may_block;
 };
@@ -465,14 +466,12 @@ struct kvm_hva_range {
 static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 						  const struct kvm_hva_range *range)
 {
-	struct kvm_memory_slot *slot;
-	struct kvm_memslots *slots;
+	bool ret = false, locked = range->caller_locked;
 	struct kvm_gfn_range gfn_range;
-	bool ret = false;
+	struct kvm_memory_slot *slot;
+	struct kvm_memslots *slots;
 	int i, idx;
 
-	lockdep_assert_held_write(&kvm->mmu_lock);
-
 	idx = srcu_read_lock(&kvm->srcu);
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
@@ -503,6 +502,10 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
 			gfn_range.slot = slot;
 
+			if (!locked) {
+				locked = true;
+				KVM_MMU_LOCK(kvm);
+			}
 			ret |= range->handler(kvm, &gfn_range);
 		}
 	}
@@ -510,6 +513,9 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 	if (range->flush_on_ret && (ret || kvm->tlbs_dirty))
 		kvm_flush_remote_tlbs(kvm);
 
+	if (locked && !range->caller_locked)
+		KVM_MMU_UNLOCK(kvm);
+
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	/* The notifiers are averse to booleans. :-( */
@@ -528,16 +534,11 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 		.end		= end,
 		.pte		= pte,
 		.handler	= handler,
+		.caller_locked	= false,
 		.flush_on_ret	= true,
 		.may_block	= false,
 	};
-	int ret;
-
-	KVM_MMU_LOCK(kvm);
-	ret = __kvm_handle_hva_range(kvm, &range);
-	KVM_MMU_UNLOCK(kvm);
-
-	return ret;
+	return __kvm_handle_hva_range(kvm, &range);
 }
 
 static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn,
@@ -551,16 +552,12 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
 		.end		= end,
 		.pte		= __pte(0),
 		.handler	= handler,
+		.caller_locked	= false,
 		.flush_on_ret	= false,
 		.may_block	= false,
 	};
-	int ret;
 
-	KVM_MMU_LOCK(kvm);
-	ret = __kvm_handle_hva_range(kvm, &range);
-	KVM_MMU_UNLOCK(kvm);
-
-	return ret;
+	return __kvm_handle_hva_range(kvm, &range);
 }
 static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 					struct mm_struct *mm,
@@ -581,6 +578,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		.end		= range->end,
 		.pte		= __pte(0),
 		.handler	= kvm_unmap_gfn_range,
+		.caller_locked	= true,
 		.flush_on_ret	= true,
 		.may_block	= mmu_notifier_range_blockable(range),
 	};
-- 
2.31.0.291.g576ba9dcdaf-goog

