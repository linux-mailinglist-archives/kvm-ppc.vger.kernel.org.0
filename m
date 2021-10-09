Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87869427654
	for <lists+kvm-ppc@lfdr.de>; Sat,  9 Oct 2021 04:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244326AbhJICSZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 8 Oct 2021 22:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244231AbhJICSB (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 8 Oct 2021 22:18:01 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8224C0613BC
        for <kvm-ppc@vger.kernel.org>; Fri,  8 Oct 2021 19:14:08 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id x28-20020ac8701c000000b0029f4b940566so8778814qtm.19
        for <kvm-ppc@vger.kernel.org>; Fri, 08 Oct 2021 19:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=vARluonyUKpRy8G9DjKrfNHNdAc1HGSYAf2sHJRtsxE=;
        b=dDNQpdZfL83I4Xoa9PZ3E5EsYnabe1TnFcUqC0GiE/0/lo3YBI4SgbGlytEWdsCvOf
         LL61F+TPG4wVAi+hBDwL0hYJr0Sf/hDhYBcY7jqTws2bL+a5fPjX5OLlspq9+auO8uLB
         LlWM6ttM2AIBOgSzLaGHfzimLEgh21na9pO5BUmiCsH43tkGQwDiPq/uFgoyBvKjufM1
         qqm6SRzQMrUy4KCFfX/YOo+AIQIUXaJKY/DR/AD2RJh1k/DEWqufdKKiBjO5+vKlBr1h
         rts7eeL0kCC8yhrzj1lM+laL06N4oAUmGKJnSLoqoH7hEPeImUfW3S7INsYE4a0g/dn5
         bbFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=vARluonyUKpRy8G9DjKrfNHNdAc1HGSYAf2sHJRtsxE=;
        b=4L0vjIuv4pev4UgxJfkYNQuwZS/MIIX2vR77qg/61If/DQo+QYZFYpwGZLWb0th56H
         zCmVy/T1NjwZFSY8PHLbjDJRs/geb/1YxqZtRSpX4cd9yj6o43EmoJ88952hhR8IeebG
         8WYkMweWLGX9UPL2yHKnGdAJe7dB1gXN1nW2+cttgCTvPdFOcfsvG11aJg2jYGPhRBiu
         3eLYe9sJHQkVWgSMaCy7unthQs+eIkxf+F5QD6VmpQE0ZynAwk5DpRFKU+By9yD8SxIu
         0kZVQQ2ZUhxmmYLLXrAUH7N+MJnpSzLiSt1OVHO0gRMfPPVnyahtH2ShBvoHpXzkqx19
         qipA==
X-Gm-Message-State: AOAM530+HguV9O/gsE8ucrK40nCmB60JUxevdj9LYWuzDedi5NJqsGmQ
        SLmbkSws8o28S/Xo3P94S4EnBqvMGJo=
X-Google-Smtp-Source: ABdhPJz6N4BKMo0pT3bkNnK0CxX1fpn8ACkILDo1YTK4hK+oppBaD3kzEAa1dfJV1AQiV4D0k1Eht0uMACM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:ac8:7010:: with SMTP id x16mr1970027qtm.136.1633745647867;
 Fri, 08 Oct 2021 19:14:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:12:28 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-36-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 35/43] KVM: SVM: Signal AVIC doorbell iff vCPU is in guest mode
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

Signal the AVIC doorbell iff the vCPU is running in the guest.  If the vCPU
is not IN_GUEST_MODE, it's guaranteed to pick up any pending IRQs on the
next VMRUN, which unconditionally processes the vIRR.

Add comments to document the logic.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 208c5c71e827..cbf02e7e20d0 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -674,7 +674,12 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 	kvm_lapic_set_irr(vec, vcpu->arch.apic);
 	smp_mb__after_atomic();
 
-	if (avic_vcpu_is_running(vcpu)) {
+	/*
+	 * Signal the doorbell to tell hardware to inject the IRQ if the vCPU
+	 * is in the guest.  If the vCPU is not in the guest, hardware will
+	 * automatically process AVIC interrupts at VMRUN.
+	 */
+	if (vcpu->mode == IN_GUEST_MODE) {
 		int cpu = READ_ONCE(vcpu->cpu);
 
 		/*
@@ -687,8 +692,13 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 		if (cpu != get_cpu())
 			wrmsrl(SVM_AVIC_DOORBELL, kvm_cpu_get_apicid(cpu));
 		put_cpu();
-	} else
+	} else {
+		/*
+		 * Wake the vCPU if it was blocking.  KVM will then detect the
+		 * pending IRQ when checking if the vCPU has a wake event.
+		 */
 		kvm_vcpu_wake_up(vcpu);
+	}
 
 	return 0;
 }
-- 
2.33.0.882.g93a45727a2-goog

