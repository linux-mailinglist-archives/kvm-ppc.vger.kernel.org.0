Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD52427618
	for <lists+kvm-ppc@lfdr.de>; Sat,  9 Oct 2021 04:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244600AbhJICQX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 8 Oct 2021 22:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244457AbhJICP4 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 8 Oct 2021 22:15:56 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8071C061776
        for <kvm-ppc@vger.kernel.org>; Fri,  8 Oct 2021 19:13:31 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id x16-20020a25b910000000b005b6b7f2f91cso15203370ybj.1
        for <kvm-ppc@vger.kernel.org>; Fri, 08 Oct 2021 19:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=JkZfdKKKsnqnpAtGUC7eJv8NSTwENPUfH6MKqHK3m28=;
        b=qVLIqxee/wprC+4bjZNYJueP2zjkd+ggVBKmgUwNSOpnEV7X/9yGfblAJrRqdCWEih
         HkkaQsOOaOeL+/6gKeVGYHju8vK+HKNcdt3bTPsONepW8SXVyQdRvqfaAKZcB8+jVwae
         l3QyVEsfib1Ds5XSLDwK5fjGQZuWnnjDxgzphYDPgXfwssEpRJVHvOakRnpFdPD78q0R
         +0gwjhJzjz6GJsBbS0TZrWfFGUf6BV3+uE57g+PTVVc8UKWIe6wyeSoVcPpQNBbE7SiU
         oPp2V17b+NBHZjC8Iixu81AY6DPeXf4DpNjHUN5949xj5Ej8bfX8i2do7PuBJAHe/oBY
         ATyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=JkZfdKKKsnqnpAtGUC7eJv8NSTwENPUfH6MKqHK3m28=;
        b=Dp6mQe3QuUTdLKwXNvEXpsZ9CIEBVAN7zK4rjVET8oHR8Qgzn4VEXpze3FLopkviYq
         LNgsLoNS6BSUQpR2PCzj8LcECbk+XqwNhI8yx31jmL49IGPrOxaXvZ0s3jkI3N4CIIuC
         DuR2231xgXs/yF66J/VO0M7k1aSNC8KCd68krnIWMXZYJR2Xjcr7TYhpcStStpey+PDO
         bvgEIcIzRBn330hhm4vRktr6iDNeVclubV2033ckQ2+++KECJLBaPJGP83MncFIqPrWt
         LI3u5io+/zHHtYpMIOzICOh0za8LcnPhSWKlJQyKKVI5gCxiQJzYyd9g4Po29hCVzorM
         xLpA==
X-Gm-Message-State: AOAM533LUd9eQX4ljjLvV/Xc2YhPGA+T0sTRAQmgkGh03isM4fwk/R1M
        DZ4YgEiHrrgdi486Ofbr4FMc7GpNgiE=
X-Google-Smtp-Source: ABdhPJzgeMmRSEoifPybAsuoSY+JDjln6XTZNwptycydEyLK/6KcdeEb7uS4dZEit5L6yoPPTC+t8rdx1rg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a5b:d03:: with SMTP id y3mr7590634ybp.400.1633745611129;
 Fri, 08 Oct 2021 19:13:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:12:13 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-21-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 20/43] KVM: VMX: Skip Posted Interrupt updates if APICv is
 hard disabled
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

Explicitly skip posted interrupt updates if APICv is disabled in all of
KVM, or if the guest doesn't have an in-kernel APIC.  The PI descriptor
is kept up-to-date if APICv is inhibited, e.g. so that re-enabling APICv
doesn't require a bunch of updates, but neither the module param nor the
APIC type can be changed on-the-fly.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 3263056784f5..351666c41bbc 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -28,11 +28,14 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	unsigned int dest;
 
 	/*
-	 * In case of hot-plug or hot-unplug, we may have to undo
-	 * vmx_vcpu_pi_put even if there is no assigned device.  And we
-	 * always keep PI.NDST up to date for simplicity: it makes the
-	 * code easier, and CPU migration is not a fast path.
+	 * To simplify hot-plug and dynamic toggling of APICv, keep PI.NDST and
+	 * PI.SN up-to-date even if there is no assigned device or if APICv is
+	 * deactivated due to a dynamic inhibit bit, e.g. for Hyper-V's SyncIC.
 	 */
+	if (!enable_apicv || !lapic_in_kernel(vcpu))
+		return;
+
+	/* Nothing to do if PI.SN==0 and the vCPU isn't being migrated. */
 	if (!pi_test_sn(pi_desc) && vcpu->cpu == cpu)
 		return;
 
-- 
2.33.0.882.g93a45727a2-goog

