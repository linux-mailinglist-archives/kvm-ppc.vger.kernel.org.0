Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1D03524BB
	for <lists+kvm-ppc@lfdr.de>; Fri,  2 Apr 2021 02:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbhDBA5H (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 20:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234029AbhDBA5F (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 20:57:05 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06373C06178A
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 17:57:04 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v6so7612534ybk.9
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 17:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=DA+Fdq2lOX/CZ+xUDvMaD5HbV7riu4wHkKUqD8IM4/k=;
        b=jEH+4lhN683scpuXyDyNcFSmirhDLEuGk0lJE37N6PVMAVFNUPQDsSlroxmScN5YO3
         IBCGvHhBjtc8BMlUOqXKu1gYXzYw4MZpMUA7myDRgmdzVC/ZR0PTr4HKxjo/4SCJHEih
         Y08yAAvk7+fWeRM2OJoXDnImvQy8YXKdFHJEsuWkAfDOWtaTi+0uKhWpi3Ie7p/zDjMP
         iq644k8yugcuqQZ9i1mkoun+uj7px8E1zhFnLvbBtwUp/G6IJhnB5biBIIFY7KsXYCJg
         jnmfpegvWrj9R8JFD2AZ/HKcezGw+adh+gF5gk/hNaz+UDc8nBr71LdSLSS+hgpp5xK2
         yJkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=DA+Fdq2lOX/CZ+xUDvMaD5HbV7riu4wHkKUqD8IM4/k=;
        b=Zi5+7QOz6271GYS6wWYjGfa9Tx6lLNTsCE9pl+bX/JXdtdJgAwa1cq0ntydR38xZB3
         ddsIIZIG+HAc5tYJXt5wlm/uUyHGwKr6q7//JGgGx95T0q+eVFHIsaTbeyJp83TfpE4v
         fRxO9kKUFjTT1FWBLh+++3us/KZL7x58QnKYNHL4GaFaRF7TK5cZKQxDt+bWaDLNbNVI
         CXr48XmN7k3kK4OoxFcSHEBEbmkyaxTurfFGFn59y36yI4lDlPRiR8Bb8M9njOqHLCVO
         +r1HTzIKwO+w+BvfCu5U9H6xCrwm+m+YQElJtazWkeRkO5AiyAoMX3DFx7n6POfTou7B
         qYtw==
X-Gm-Message-State: AOAM530FAqMp87Ub9DYbj286BPGCWZAO25N+IkKyOCv2YW7PVKvlDlpy
        S+G0AQ3cjnWIsy8R6+fUVio30VfSrig=
X-Google-Smtp-Source: ABdhPJygeKAdy1Ue7ggQyWInnKM/181me24PPoeX8s/XsaZF77/exnxBmdxBDDEECxkfyMlEpqfXzJSZ32w=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:c0b4:8b8:bb34:6a56])
 (user=seanjc job=sendgmr) by 2002:a25:af05:: with SMTP id a5mr16043377ybh.86.1617325023277;
 Thu, 01 Apr 2021 17:57:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Apr 2021 17:56:49 -0700
In-Reply-To: <20210402005658.3024832-1-seanjc@google.com>
Message-Id: <20210402005658.3024832-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210402005658.3024832-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 01/10] KVM: Assert that notifier count is elevated in .change_pte()
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

In KVM's .change_pte() notification callback, replace the notifier
sequence bump with a WARN_ON assertion that the notifier count is
elevated.  An elevated count provides stricter protections than bumping
the sequence, and the sequence is guarnateed to be bumped before the
count hits zero.

When .change_pte() was added by commit 828502d30073 ("ksm: add
mmu_notifier set_pte_at_notify()"), bumping the sequence was necessary
as .change_pte() would be invoked without any surrounding notifications.

However, since commit 6bdb913f0a70 ("mm: wrap calls to set_pte_at_notify
with invalidate_range_start and invalidate_range_end"), all calls to
.change_pte() are guaranteed to be bookended by start() and end(), and
so are guaranteed to run with an elevated notifier count.

Note, wrapping .change_pte() with .invalidate_range_{start,end}() is a
bug of sorts, as invalidating the secondary MMU's (KVM's) PTE defeats
the purpose of .change_pte().  Every arch's kvm_set_spte_hva() assumes
.change_pte() is called when the relevant SPTE is present in KVM's MMU,
as the original goal was to accelerate Kernel Samepage Merging (KSM) by
updating KVM's SPTEs without requiring a VM-Exit (due to invalidating
the SPTE).  I.e. it means that .change_pte() is effectively dead code
on _all_ architectures.

x86 and MIPS are clearcut nops if the old SPTE is not-present, and that
is guaranteed due to the prior invalidation.  PPC simply unmaps the SPTE,
which again should be a nop due to the invalidation.  arm64 is a bit
murky, but it's also likely a nop because kvm_pgtable_stage2_map() is
called without a cache pointer, which means it will map an entry if and
only if an existing PTE was found.

For now, take advantage of the bug to simplify future consolidation of
KVMs's MMU notifier code.   Doing so will not greatly complicate fixing
.change_pte(), assuming it's even worth fixing.  .change_pte() has been
broken for 8+ years and no one has complained.  Even if there are
KSM+KVM users that care deeply about its performance, the benefits of
avoiding VM-Exits via .change_pte() need to be reevaluated to justify
the added complexity and testing burden.  Ripping out .change_pte()
entirely would be a lot easier.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d1de843b7618..8df091950161 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -461,12 +461,17 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 
 	trace_kvm_set_spte_hva(address);
 
+	/*
+	 * .change_pte() must be bookended by .invalidate_range_{start,end}(),
+	 * and so always runs with an elevated notifier count.  This obviates
+	 * the need to bump the sequence count.
+	 */
+	WARN_ON_ONCE(!kvm->mmu_notifier_count);
+
 	idx = srcu_read_lock(&kvm->srcu);
 
 	KVM_MMU_LOCK(kvm);
 
-	kvm->mmu_notifier_seq++;
-
 	if (kvm_set_spte_hva(kvm, address, pte))
 		kvm_flush_remote_tlbs(kvm);
 
-- 
2.31.0.208.g409f899ff0-goog

