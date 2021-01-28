Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEFB306D67
	for <lists+kvm-ppc@lfdr.de>; Thu, 28 Jan 2021 07:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhA1GGT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 28 Jan 2021 01:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbhA1GGQ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 28 Jan 2021 01:06:16 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13754C061786
        for <kvm-ppc@vger.kernel.org>; Wed, 27 Jan 2021 22:05:36 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id e19so3313172pfh.6
        for <kvm-ppc@vger.kernel.org>; Wed, 27 Jan 2021 22:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UygKOqEf59SFJHMhhfR+HLz4CGF5Uv9S4hRfcJbt+yk=;
        b=Qh8VODAieLH4894A4MDu3uPPXE5kLO4XxZpYmBxJ82EmJjvCd38+PvJXeC7WfYCIBI
         64aPWxpI+2Wuja2TEV1w1O7J/k/33st78VPhJvOw7GI1Ov6clXkA1iu5LQJ5MR4dUH8V
         v91cI0vNifEcoZnWwsn/8BSJmyZEYnqUhOWFg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UygKOqEf59SFJHMhhfR+HLz4CGF5Uv9S4hRfcJbt+yk=;
        b=ZTTb53LWTKZkiF7eqxzK8Z+Lk6G6h9zGxSKtOwdc/grkBJ78EA4k93S6xvcaNmToti
         PjuNlyMdYpI2Mtj9nyyfvDCMJgbZSe2w4HrUIlFbOX41jGUM+MBjxbbrsARK4k8Sr0wY
         mgDdDKlrOO/jXBy8EmLtX+XwvYYxqlGGDwHYk+seEHv9jFOZcTgq9HAZqQYL/H3/qo5n
         WfbvFMYPnF6bnuoMsFBZKdWn7TM9vOyeYP6iviqd/mVEeironDSQDsckaHYXnwT0DavW
         b4lZdmuzNFJhV46TyP4LCfFovdfHGra+cBYpNTj3ELme+GPizxUpW4pxec7eE4OzVsEt
         HSuQ==
X-Gm-Message-State: AOAM531LFwlqn487QLOQVLHWzMOyBBrB47oAS7yBwT1H4ZK7PtIQGBzf
        MCwdzpWUC0xUCJOisue8IoBXyg==
X-Google-Smtp-Source: ABdhPJx6bZB3eesMD+UMxqDOEfHH1P0CPHJvUJWhsABLqESuXZOj3BsZQpCR3iBz434VwICAw3KJ+g==
X-Received: by 2002:a62:bd05:0:b029:1ab:6d2:5edf with SMTP id a5-20020a62bd050000b02901ab06d25edfmr14361887pff.32.1611813935673;
        Wed, 27 Jan 2021 22:05:35 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:919f:d6:7815:52bc])
        by smtp.gmail.com with ESMTPSA id s73sm4388027pgc.46.2021.01.27.22.05.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 22:05:35 -0800 (PST)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        kvm-ppc@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH v3 1/2] KVM: x86/mmu: Skip mmu_notifier check when handling MMIO page fault
Date:   Thu, 28 Jan 2021 15:05:14 +0900
Message-Id: <20210128060515.1732758-2-stevensd@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
In-Reply-To: <20210128060515.1732758-1-stevensd@google.com>
References: <20210128060515.1732758-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Don't retry a page fault due to an mmu_notifier invalidation when
handling a page fault for a GPA that did not resolve to a memslot, i.e.
an MMIO page fault.  Invalidations from the mmu_notifier signal a change
in a host virtual address (HVA) mapping; without a memslot, there is no
HVA and thus no possibility that the invalidation is relevant to the
page fault being handled.

Note, the MMIO vs. memslot generation checks handle the case where a
pending memslot will create a memslot overlapping the faulting GPA.  The
mmu_notifier checks are orthogonal to memslot updates.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 2 +-
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6d16481aa29d..9ac0a727015d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3725,7 +3725,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 	r = RET_PF_RETRY;
 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
+	if (!is_noslot_pfn(pfn) && mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
 	r = make_mmu_pages_available(vcpu);
 	if (r)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 50e268eb8e1a..ab54263d857c 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -869,7 +869,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 
 	r = RET_PF_RETRY;
 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
+	if (!is_noslot_pfn(pfn) && mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
 
 	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
-- 
2.30.0.280.ga3ce27912f-goog

