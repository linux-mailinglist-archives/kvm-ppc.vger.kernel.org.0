Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53779444C57
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Nov 2021 01:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbhKDAaT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 3 Nov 2021 20:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbhKDA3T (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 3 Nov 2021 20:29:19 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D97C06127A
        for <kvm-ppc@vger.kernel.org>; Wed,  3 Nov 2021 17:26:42 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id s22-20020a056a0008d600b00480fea2e96cso2350330pfu.7
        for <kvm-ppc@vger.kernel.org>; Wed, 03 Nov 2021 17:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=g2JE1NchR5OuOuOibWq+8/K2CyWjv7Vlzl0jcmmyHKg=;
        b=UK0IuaxMRM8VI2p4RKcIncQCt3/rVVcLXbP5evDmYD/5MRFF0cnYdOJohdcwHEX0UL
         s1jIdejQk2RCs3P65ng7Qi/Nch6xWlLb3AJpNe9St0b08O8bclGAcjcwNlhuwKwlVdU1
         UAsDfdzka5c/8R6jSfqZAOtxqrF3sWb5+CRYIfY9EL/+phX4RhDTxJKT1BO5pHPTYR1k
         fxXTYBb9kgrmzPKpgw9GKqSRQ5hvlxWlweftTu0Q9G5eaVLj6I+ooPTk+H0MMEpbFXMo
         f+ER1N4nuFT1F4WSwfp35dekPy4XgcZqB/FM/tQgwuYCGxh5wKA5FoaSXrqIYkgUbgeI
         PAHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=g2JE1NchR5OuOuOibWq+8/K2CyWjv7Vlzl0jcmmyHKg=;
        b=aAOGraIFMJVy6/3OdOTmPtkBOpmhtY0PeBFoIWhS+Y2ehIYgpZjlRwfj4aajAcyKgg
         vU91H+MJ7SCg2AYho7KIZR7Z7BI/ketHIzj1ol1sOvRDn5lflD9+/AUk0WL7c6NEVVJy
         fBnFbGjRIHkTdV4ZDorIPtkbPtzeW5I9L5+4CW02uO3l1LOkK9E/marh5qzc1tcHJI4d
         NJfAP4TfEoaYOutXTpHWMgwlxZOPdVxTGcIJv7Oy5eAGbaggmstCU/7Py9VJKr4G6DqI
         RLQyqrFRvUcz7QTO66TjP6TVveiRQBeWYUrvph0M6giXPu0BOcLYDQCrpRSFgEoJ2b/+
         Dv4g==
X-Gm-Message-State: AOAM531qvKpcOy15GVtrm045euofxgzqaq32EdwgzGbdXZsYGLSES1+T
        pAXQPeHsk11m2WpWZvy6p+YzE+7vOLk=
X-Google-Smtp-Source: ABdhPJxEVZZh8c79kJBVhyomHBKtGxgWv7d32Tr+YGvJXzn/bVGhXaf6aJM8D0LQz8M/cEOUCA1R/OXLlBc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2c7:b0:142:f06:e5fa with SMTP id
 n7-20020a170902d2c700b001420f06e5famr12493355plc.87.1635985601544; Wed, 03
 Nov 2021 17:26:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Nov 2021 00:25:26 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-26-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 25/30] KVM: s390: Introduce kvm_s390_get_gfn_end()
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

From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

And use it where s390 code would just access the memslot with the highest
gfn directly.

No functional change intended.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/s390/kvm/kvm-s390.c |  2 +-
 arch/s390/kvm/kvm-s390.h | 12 ++++++++++++
 arch/s390/kvm/pv.c       |  4 +---
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 4e032e176216..f7cc0853866b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2012,7 +2012,7 @@ static int kvm_s390_get_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
 	if (!ms)
 		return 0;
 	next_gfn = kvm_s390_next_dirty_cmma(slots, cur_gfn + 1);
-	mem_end = slots->memslots[0].base_gfn + slots->memslots[0].npages;
+	mem_end = kvm_s390_get_gfn_end(slots);
 
 	while (args->count < bufsize) {
 		hva = gfn_to_hva(kvm, cur_gfn);
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 52bc8fbaa60a..207d299d7fea 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -208,6 +208,18 @@ static inline int kvm_s390_user_cpu_state_ctrl(struct kvm *kvm)
 	return kvm->arch.user_cpu_state_ctrl != 0;
 }
 
+/* get the end gfn of the last (highest gfn) memslot */
+static inline unsigned long kvm_s390_get_gfn_end(struct kvm_memslots *slots)
+{
+	struct kvm_memory_slot *ms;
+
+	if (WARN_ON(!slots->used_slots))
+		return 0;
+
+	ms = slots->memslots;
+	return ms->base_gfn + ms->npages;
+}
+
 /* implemented in pv.c */
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
 int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index c8841f476e91..e51cccfded25 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -117,7 +117,6 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	unsigned long base = uv_info.guest_base_stor_len;
 	unsigned long virt = uv_info.guest_virt_var_stor_len;
 	unsigned long npages = 0, vlen = 0;
-	struct kvm_memory_slot *memslot;
 
 	kvm->arch.pv.stor_var = NULL;
 	kvm->arch.pv.stor_base = __get_free_pages(GFP_KERNEL_ACCOUNT, get_order(base));
@@ -131,8 +130,7 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	 * Slots are sorted by GFN
 	 */
 	mutex_lock(&kvm->slots_lock);
-	memslot = kvm_memslots(kvm)->memslots;
-	npages = memslot->base_gfn + memslot->npages;
+	npages = kvm_s390_get_gfn_end(kvm_memslots(kvm));
 	mutex_unlock(&kvm->slots_lock);
 
 	kvm->arch.pv.guest_len = npages * PAGE_SIZE;
-- 
2.33.1.1089.g2158813163f-goog

