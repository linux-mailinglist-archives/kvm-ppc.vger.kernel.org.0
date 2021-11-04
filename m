Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFDF444C55
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Nov 2021 01:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbhKDAaP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 3 Nov 2021 20:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbhKDA3O (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 3 Nov 2021 20:29:14 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB841C06127A
        for <kvm-ppc@vger.kernel.org>; Wed,  3 Nov 2021 17:26:37 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id g26-20020a63521a000000b0029524f04f5aso2404636pgb.5
        for <kvm-ppc@vger.kernel.org>; Wed, 03 Nov 2021 17:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=z9H8IQzlDNgV44iopVPD/a5Trpa0ZdTpJckFcsIyzz0=;
        b=YKpIJ4e4/wfganLDuC8K208Zpsp5JVcK50xnWQQTLSFM+X50LE78T6m87p5qT3DblR
         Oqy3rk1VQsN1i/paB2gXcz5pvl+Jhd8ELjKdXAD0WmwFnDoXvIApQ5t8wATtH/xHBo3e
         E3zgwsISbQWVPjz/S1RIgDi94l9z3MF9WBJMMJEtMbLYrCmw/M0/pklTGnCcvsIM1IzC
         7p8hk9aIycQqutIs+/eYz7g/lbNHI/oVf07ie2vQl+tlRkiyfau6HsmDc9DeODVl5ybk
         WJzJ95EFnzX+H5HwRah9xIveGt9v2x/cU0TbcVn1MuEYGyTz7eHSGiF0kmPeMBG8mGAx
         hpBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=z9H8IQzlDNgV44iopVPD/a5Trpa0ZdTpJckFcsIyzz0=;
        b=zodwBYIbY64uYUHRJjU2LzfgNeVrdo8t/X5Aia4WhgFTrcXxaTKVn7dGKdtVeCUnXw
         bW3RcApXrZf99w1DCGrc47YNaGBwMXjTJI2c4+xpUUVkvR/lfxSkQgVoaSN4qmkdZzem
         4sffr+dOituh3i5IR5tl7gQ/wOvgblsByPUQHNEsb/f1PWXA/j6cnP5YDhAJF+RIv+N4
         ofTRwNCH0WFYyjG/dyz1riDbJTGTaxwUDr1Sh1m0hzp31Sz/t+nzoIo+8iUTd6Y6+vdS
         GOHjw8b3zYJg1pboMkdny4PHsTGR8HJwenKH/D+g+BLfkMaLTBHhFk/1rnuvqEnIJ4vG
         7hFw==
X-Gm-Message-State: AOAM531G5ncXIiSk7GdY1/LIvPP1KQlwksdX94w0h9rLglyYLDkCm8d6
        5hfxrQRDQk/JecCHNv1ChqgRr58TV68=
X-Google-Smtp-Source: ABdhPJzonurVPT2PlJyw4WaELXDlFkKjeT4hoSllYUuMDrNarwts75/W8wr8EQC45lWUJfQCoW+ypti7LUM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:5285:: with SMTP id
 w5mr261421pjh.1.1635985596589; Wed, 03 Nov 2021 17:26:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Nov 2021 00:25:23 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-23-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 22/30] KVM: Move WARN on invalid memslot index to update_memslots()
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

Since kvm_memslot_move_forward() can theoretically return a negative
memslot index even when kvm_memslot_move_backward() returned a positive one
(and so did not WARN) let's just move the warning to the common code.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a2d51ce957e1..d45d574a5a2d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1307,8 +1307,7 @@ static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
 	struct kvm_memory_slot *mslots = slots->memslots;
 	int i;
 
-	if (WARN_ON_ONCE(slots->id_to_index[memslot->id] == -1) ||
-	    WARN_ON_ONCE(!slots->used_slots))
+	if (slots->id_to_index[memslot->id] == -1 || !slots->used_slots)
 		return -1;
 
 	/*
@@ -1412,6 +1411,9 @@ static void update_memslots(struct kvm_memslots *slots,
 			i = kvm_memslot_move_backward(slots, memslot);
 		i = kvm_memslot_move_forward(slots, memslot, i);
 
+		if (WARN_ON_ONCE(i < 0))
+			return;
+
 		/*
 		 * Copy the memslot to its new position in memslots and update
 		 * its index accordingly.
-- 
2.33.1.1089.g2158813163f-goog

