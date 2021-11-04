Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC6E444C3F
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Nov 2021 01:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbhKDAaK (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 3 Nov 2021 20:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233341AbhKDA3F (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 3 Nov 2021 20:29:05 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4ECC061203
        for <kvm-ppc@vger.kernel.org>; Wed,  3 Nov 2021 17:26:28 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h10-20020a63df4a000000b002a6ba425b58so2356883pgj.17
        for <kvm-ppc@vger.kernel.org>; Wed, 03 Nov 2021 17:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=IsY0WRuuTFV0eCJh4XuxLWgE9EBRjAtittkz8TMTuco=;
        b=O7s96ScNe9nmLZhqPDRepEfehWbch5lSXwuuBFzYiqZgVQsgJRuuGd/HsCCp0bLNu4
         cYQEx19ZWNPAdMz0HClIalz8ml2QbzjuG+kpgnfMKZafKps+5AXiFqHJNbVFhjHTioYL
         tC1EMjtQ3yJ0X06NcpoHHSW6eMNaRj1UY0Egh3hPuOjeGtPjO4DN4XnLvAY2osT6lAMm
         Q868Qm3pLeksx//ppWn43EQZ/TdzYIIwGOwnzwEzdl67hcCGzEJJpjoe2w8tgpCv7e+t
         TP/XmqLrn9P33rNcE9thKpdxIqj+9MZJlkaTX8cqkFRjS/EbxZ7CKKedokkl4MG1CITB
         FVVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=IsY0WRuuTFV0eCJh4XuxLWgE9EBRjAtittkz8TMTuco=;
        b=o4hJZ6Rmxy18wWTUTJJlQXyn+dD+t6zW+a4uQWCSFYPWR3TI2ThXT5uF+giN6lGnEM
         0uQJI/pdlKTlLPXOZVf831yPkGAy7ImWfcgL0q1Dg3un786jG75G8qoSegJj0JZDZbVG
         pXxTcS9D3M3CgQLBtPtza44uJo1T5e6tKUKS8Qmx+LBtknZSd4oZ5C+V988Gs39nlM3H
         cc35Z7UaWXNQK4fOaxaxlmhddO3W8pVF2wSjbIRvoQ5IlrqXQsa+MT16jhPAr0R11rb+
         btwpNiPZwiSzSeiwcIY4ektSIVdXNPl5obwP0tACD/VJQqyve/PRS/MxfYFqdkZEeaRk
         3zzA==
X-Gm-Message-State: AOAM530dAsRzpYfOAcHO+TfClzJBVk4+feRuMvFkY+TBVtM9So4BN+0y
        j390Qjz4orl9gQybdm9/K04qtvglE9U=
X-Google-Smtp-Source: ABdhPJz+o3KGoFfULDwKrO6qcyTUUuzAUo3X1uvau9DDSuCs/3Lm9Kc5uh2iA0skAT+76ch/61YBaYAjQn0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:5285:: with SMTP id
 w5mr261386pjh.1.1635985587426; Wed, 03 Nov 2021 17:26:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Nov 2021 00:25:18 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-18-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 17/30] KVM: s390: Skip gfn/size sanity checks on memslot
 DELETE or FLAGS_ONLY
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Sanity check the hva, gfn, and size of a userspace memory region only if
any of those properties can change, i.e. skip the checks for DELETE and
FLAGS_ONLY.  KVM doesn't allow moving the hva or changing the size, a gfn
change shows up as a MOVE even if flags are being modified, and the
checks are pointless for the DELETE case as userspace_addr and gfn_base
are zeroed by common KVM.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/s390/kvm/kvm-s390.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 81f90891db0f..c4d0ed5f3400 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5020,7 +5020,14 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
-	gpa_t size = new->npages * PAGE_SIZE;
+	gpa_t size;
+
+	/* When we are protected, we should not change the memory slots */
+	if (kvm_s390_pv_get_handle(kvm))
+		return -EINVAL;
+
+	if (change == KVM_MR_DELETE || change == KVM_MR_FLAGS_ONLY)
+		return 0;
 
 	/* A few sanity checks. We can have memory slots which have to be
 	   located/ended at a segment boundary (1MB). The memory in userland is
@@ -5030,15 +5037,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	if (new->userspace_addr & 0xffffful)
 		return -EINVAL;
 
+	size = new->npages * PAGE_SIZE;
 	if (size & 0xffffful)
 		return -EINVAL;
 
 	if ((new->base_gfn * PAGE_SIZE) + size > kvm->arch.mem_limit)
 		return -EINVAL;
 
-	/* When we are protected, we should not change the memory slots */
-	if (kvm_s390_pv_get_handle(kvm))
-		return -EINVAL;
 	return 0;
 }
 
-- 
2.33.1.1089.g2158813163f-goog

