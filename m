Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8908444C45
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Nov 2021 01:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbhKDAaM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 3 Nov 2021 20:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233378AbhKDA3I (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 3 Nov 2021 20:29:08 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A468C061714
        for <kvm-ppc@vger.kernel.org>; Wed,  3 Nov 2021 17:26:31 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id l7-20020a622507000000b00494608c84a4so263204pfl.6
        for <kvm-ppc@vger.kernel.org>; Wed, 03 Nov 2021 17:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=uYjj4f3K7aLt9wIaWKUjF6y1lKdICOYwfejCWHB3aF8=;
        b=Uhm3v8WNND1uUP79qkh3iF9ngMS/QpmsXEC/6vevUuzviyfyF3+tSzE2rdmLrNYnov
         ivEPHlTaSTgUBPTTi0LsyRVmw9xXp2mzAafjmpRwoFL1KovVk8wtgK3U+1IWl+jiRT2o
         7QOXBMeLcoMyFIuk8nfYq8Z4cK4ySxLX4VQvCwivT4uBC8D1531XJeoZcVX+WcQdgv/2
         15XpbR3gJyAolfjM0WcGNgJS3ceK1iyuvg9S+WhHGJq+B2HdNn7lGmW8IZ2NF2RpaP0n
         2NlCasOBpN6Ngo/ODMi6fT9lbV6fzIJZALi7PZVoZsnpUFpAWoSzDGNfxoR0u+D8gkJP
         KhsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=uYjj4f3K7aLt9wIaWKUjF6y1lKdICOYwfejCWHB3aF8=;
        b=eEyt+zY2HtN3mea6/iaJmMcKJ6NDr381GHlXURVHSGbnzNsoOR6rjbF/v041mOM0Bk
         Vgnnr7F4zMpHToMNwI1cdjr8Q/qU2L7eUu2EMFez9vR8fUyNbudIl8u5xhQd6GqCt35t
         KJE+9uqoTDNE87rbmMp8s3SELfFOUgFYuA7zA97lWDWcNw/Qypx4BDuquzu2dQNBS9pI
         mUalnRp4d3iFFVWpi+zX481YWYwsHteHzl9K5EFg4JvcjYPNW+grX4JXSrhKVDQlzJtk
         2RoIERi7+or7VNErRydCwTvNMgsz+enMSsgCsmTGc2NuFVZtswswGNDlKZQ882raq++D
         vXmA==
X-Gm-Message-State: AOAM533h6Km2pNJeRXXbvSLNWBZu6O23enxCGhlIzX6SSwUZmEhjOoji
        Md5A2h5vm38dWeuHrpYzpuCKkKEInB0=
X-Google-Smtp-Source: ABdhPJyzJUVQ4+X7UL4YhSp9RCZBPi0XLOQZSFtg0LZxrgaDfXLCgqmWWI3ojjh232hTQrMrLyr2UsSbIBM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1511:b0:492:61fe:9fa6 with SMTP id
 q17-20020a056a00151100b0049261fe9fa6mr9114017pfu.57.1635985590891; Wed, 03
 Nov 2021 17:26:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Nov 2021 00:25:20 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-20-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 19/30] KVM: x86: Don't call kvm_mmu_change_mmu_pages() if
 the count hasn't changed
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

There is no point in calling kvm_mmu_change_mmu_pages() for memslot
operations that don't change the total page count, so do it just for
KVM_MR_CREATE and KVM_MR_DELETE.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 80183f7eadeb..4b0cb7390902 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11836,7 +11836,8 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
-	if (!kvm->arch.n_requested_mmu_pages)
+	if (!kvm->arch.n_requested_mmu_pages &&
+	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE))
 		kvm_mmu_change_mmu_pages(kvm,
 				kvm_mmu_calculate_default_mmu_pages(kvm));
 
-- 
2.33.1.1089.g2158813163f-goog

