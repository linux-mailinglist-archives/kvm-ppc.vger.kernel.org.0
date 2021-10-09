Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151474275C9
	for <lists+kvm-ppc@lfdr.de>; Sat,  9 Oct 2021 04:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244290AbhJICPB (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 8 Oct 2021 22:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244271AbhJICPA (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 8 Oct 2021 22:15:00 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F68C061767
        for <kvm-ppc@vger.kernel.org>; Fri,  8 Oct 2021 19:13:02 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id f11-20020ac80a4b000000b002a778ec70e4so1311307qti.21
        for <kvm-ppc@vger.kernel.org>; Fri, 08 Oct 2021 19:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=W7si8hyBuDcp1dRXujL6OsjQExomH1E+fqXnahmPoDg=;
        b=aOVayCn6ej6FxmmrHt2sU4373bV7AgGsudgxlqChxKNBKeRvLn96S5TTWXhl5ULPJk
         I6iByFgjio/SidNywR7tnUGCRvSDXMEtfg0wpwAATih5seZXq+QX1sQoTghgk9QHQB57
         9ciB8V1aON0p6mmmnPOJ6EOL7AvSBtzp/rM+Pa2gx/RTljJgt7PpcpYhy/Qeqj3D6m5L
         wMWuAky/wekhi60e5vPGB9DlvsoJ6WhNX1rDvrD4Mdh5h3FUJIFjNxaS/4ltVuEBwBOD
         3ZYnQpGBK4gqS0MSsSW1ri3MD09TSEw2EHYYwemAOuNZ4Mo8BpFRTOjf8EBWWgJpnE4g
         pPUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=W7si8hyBuDcp1dRXujL6OsjQExomH1E+fqXnahmPoDg=;
        b=dDKqG+SDT6YfP2Qb74GJnSUJdrg2+Llax80YqtL7x4AODV4/FEZuPP/Dnlu0mH1pA1
         TIDIrcs1KrcPbjm1GjpofkAHR5ozmU/3HcxmXervpNcnFT2w8IN7tVbBKnb0q9/6j5xz
         SNu0FS3LCHo1tlzHVt3Lx9v7AwehlceauX9YlbNyxT96ZQMClKeYq2w9bAaxQsnD6x5R
         LVh3TFc2o/K0T+BoQF1wOP0Yck6o5pAXmooIoYUNl/gCm7zhyo4HL6zI26KEf3Mmet1J
         T74Q7CwymHOPRstvIC1OfGbDBTV5yrm6i4WVCULPYWTdp8cXTcMOJZbYb1cyh05Dax90
         CqXg==
X-Gm-Message-State: AOAM530Aq9WIf4kAfgT8rVUNQ/CJpu2e7i/Y1kiBHY5Jz6TyGeGsPUfc
        oPJLsEAS+cD/WJXcwAKhnhBTdfv1Olk=
X-Google-Smtp-Source: ABdhPJwDz7eOExNK6QVdxoBv7GDWAS3HydxP9exQUahtOx0TYXHuOmh7cJR1yTxOnJ8gdBtj54I2n5FqkLI=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:ac8:5682:: with SMTP id h2mr1879396qta.361.1633745581703;
 Fri, 08 Oct 2021 19:13:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:12:01 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-9-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 08/43] KVM: s390: Clear valid_wakeup in kvm_s390_handle_wait(),
 not in arch hook
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
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Move the clearing of valid_wakeup from kvm_arch_vcpu_block_finish() so
that a future patch can drop said arch hook.  Unlike the other blocking-
related arch hooks, vcpu_blocking/unblocking(), vcpu_block_finish() needs
to be called even if the KVM doesn't actually block the vCPU.  This will
allow future patches to differentiate between truly blocking the vCPU and
emulating a halt condition without introducing a contradiction.

Alternatively, the hook could be renamed to kvm_arch_vcpu_halt_finish(),
but there's literally one call site in s390, and future cleanup can also
be done to handle valid_wakeup fully within kvm_s390_handle_wait() and
allow generic KVM to drop vcpu_valid_wakeup().

No functional change intended.

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/s390/kvm/interrupt.c | 1 +
 arch/s390/kvm/kvm-s390.c  | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 10722455fd02..520450a7956f 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1336,6 +1336,7 @@ int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
 no_timer:
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 	kvm_vcpu_block(vcpu);
+	vcpu->valid_wakeup = false;
 	__unset_cpu_idle(vcpu);
 	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 7cabe6778b1b..08ed68639a21 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5082,7 +5082,7 @@ static inline unsigned long nonhyp_mask(int i)
 
 void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu)
 {
-	vcpu->valid_wakeup = false;
+
 }
 
 static int __init kvm_s390_init(void)
-- 
2.33.0.882.g93a45727a2-goog

