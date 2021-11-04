Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8824444C5B
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Nov 2021 01:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhKDA35 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 3 Nov 2021 20:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233244AbhKDA2v (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 3 Nov 2021 20:28:51 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFD3C061203
        for <kvm-ppc@vger.kernel.org>; Wed,  3 Nov 2021 17:26:14 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id f15-20020a63f74f000000b002cc203e1ee6so2399912pgk.7
        for <kvm-ppc@vger.kernel.org>; Wed, 03 Nov 2021 17:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=8x8y6LCkLptxfKHX5+pDaTNp73wBECOiN1YdxqMK+rA=;
        b=Kwf8l4ALLidbOCnsA8IZb7EGVbQY2I/GyIc70v/xPgAN2uNZmJzzLzZJfwAX2uOOCO
         bOK9U8USa/+T5EGJ5WM+xo1wGM21VgQud3S9i76kNITLTzwA0wNdnUr/fJDAgqhSvhap
         Yw0ASqeY//wjIN0mhEQ3qwyRthBADSpw3C4ZFZ4+KorPOGjjv9GHHalj2Z0JVLcN7rKX
         1aJXnhddEMDTeyAz0wqrWJZzkxWK24hOVug2NjMIF6/CfNf9YTCoQnGyCXWnO5Qwes4j
         g5HbrauvOLkXEcvWsWbG0nodw7IIljy/H4UiUpBEQUah5lbLSlwy7/6wMiTLEuWxciTS
         tAtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=8x8y6LCkLptxfKHX5+pDaTNp73wBECOiN1YdxqMK+rA=;
        b=JTSNzY16wZM9t0WpGiasx9QJS4fUFTGwHdAGBL1iZSC8MMqowDO5WJE4JEZLFttUH5
         brP3O25p7+61C2w3JITl2lkOh3sNTT8KNd8vGlSORQQV/Lq7vJl5bOJ+iQSNZy0HwMVg
         cxKzzPs6b1vwW8xMopnF+M+z/m2Hg8/Zqe+oTrvwBi4rlIFsYuCxpcNL6zbyjQGNTcH9
         LG0UNqDFybqi/unfw+bDlXzz5ZRy2dAQVjxM481EolKzDMDGxy8wTbYvTLFgPfabDiOv
         fEd0M5iU2Z3uEiM2/VWq1MhQoTzahoHLR8lgLWbbyYcvKng9XI3VwK9xYgZMaslA/hxy
         o/3Q==
X-Gm-Message-State: AOAM532QJXTQtch+uQb2ZIcIP9ZkbK4H2TWUa1hs5eAN7Aphe3f8nnwO
        UyuGo7oAHw22+Xt/IHU1QyZjOsCX8fU=
X-Google-Smtp-Source: ABdhPJxsJ29Wj32AtuAm6joDY8iQebT4Rnu7/phTa+MfeSdX22KfADwkK1eYIPGppvLFyQSyOgzQ6GfE4Fg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:5285:: with SMTP id
 w5mr261308pjh.1.1635985573544; Wed, 03 Nov 2021 17:26:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Nov 2021 00:25:10 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-10-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 09/30] KVM: MIPS: Drop pr_debug from memslot commit to
 avoid using "mem"
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

Remove an old (circa 2012) kvm_debug from kvm_arch_commit_memory_region()
to print basic information when committing a memslot change.  The primary
motivation for removing the kvm_debug is to avoid using @mem, the user
memory region, so that said param can be removed.

Alternatively, the debug message could be converted to use @new, but that
would require synthesizing select state to play nice with the DELETED
case, which will pass NULL for @new in the future.  And there's no
argument to be had for dumping generic information in an arch callback,
i.e. if there's a good reason for the debug message, then it belongs in
common KVM code where all architectures can benefit.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/mips/kvm/mips.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 8c94cd4093af..b7aa8fa4a5fb 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -249,10 +249,6 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 {
 	int needs_flush;
 
-	kvm_debug("%s: kvm: %p slot: %d, GPA: %llx, size: %llx, QVA: %llx\n",
-		  __func__, kvm, mem->slot, mem->guest_phys_addr,
-		  mem->memory_size, mem->userspace_addr);
-
 	/*
 	 * If dirty page logging is enabled, write protect all pages in the slot
 	 * ready for dirty logging.
-- 
2.33.1.1089.g2158813163f-goog

