Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF864275FD
	for <lists+kvm-ppc@lfdr.de>; Sat,  9 Oct 2021 04:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244458AbhJICPy (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 8 Oct 2021 22:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244457AbhJICPe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 8 Oct 2021 22:15:34 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050FEC061796
        for <kvm-ppc@vger.kernel.org>; Fri,  8 Oct 2021 19:13:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b9-20020a5b07890000b0290558245b7eabso15003837ybq.10
        for <kvm-ppc@vger.kernel.org>; Fri, 08 Oct 2021 19:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=iENfBAERukntPY2X5QGQTh9qzr8Td2a/eMmZN0gkPVI=;
        b=DzCx6d3mDseqABvdcGbaVVyn1eWP9DyM0ptlZC0Av6M11xsmwM4hDygp2I9SRsOTlD
         CaLslZ/5tpgFn7ZGK8Q+oAp/z+7Kry0ksTb1JHhzjTahq7Wh+o5eGwzQrJzYlowAOZ48
         VNCB+jXgqhl1lAdIBlzi52PfjMMWOIp8/GrzMp+AjpBgmC/UstMbkG/AsaR/Zi/J2Jar
         o4OtrA3m//aakuHjWV9VK3H1BLYWwyP3onVfEMCmc4KxgicKakfGDgJSztgcePWQk2I1
         bTHWhpYvVB73G/ZnG29ntm8kUxVEF6vAxFCPnskmCGo64vtpSvX8eFpV4pMmLiFClOgf
         jaMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=iENfBAERukntPY2X5QGQTh9qzr8Td2a/eMmZN0gkPVI=;
        b=xUfxiAMJHlMir102/D+178Th8QwqroqXorLfSFTr2snp49ug+JccxFq3TQkqBOLEDc
         P/niqG9h2kI+OLCFHW3suF/Hv8qTGTpgBdru8oWn2Z05NAG0NQ8X2U6pxw2iiYOIUKG8
         veewfHZ40OF03NSTB0DlIDSRxTNAR+G0evx/+H5LKWy5PODLvZMhx6UcgU6YpXO2GiTi
         NcPoY0Q0Ib5p6aNxfpF6SX5Hzc386sdLyc9+Vvkc+XIbFgfAlDZSc0Hm6wwEL9z4l/mj
         mczg20dxEDxjBDX8zV+XphB2rzTddjZGT/woB4bAFnZAJ1xZys9uYV6VJbKlvUAgwOTn
         6ajA==
X-Gm-Message-State: AOAM5308eJfONx/Q3J4irPmFq9F1tNDM03RBGP6eLG1Hrw05RqX322p3
        EPlvtqpeMw/RPGQJdmi70JqqGv38UWQ=
X-Google-Smtp-Source: ABdhPJzWNw6k/Tym0AlNYDL00dpB0fqVjcBxlLLKgA5wVnQqHXg+hyQOuiK3gpCLlIvGNpb1Xv6thLhfBP8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:bb93:: with SMTP id y19mr7661688ybg.266.1633745601224;
 Fri, 08 Oct 2021 19:13:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:12:09 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-17-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 16/43] KVM: Don't redo ktime_get() when calculating
 halt-polling stop/deadline
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

Calculate the halt-polling "stop" time using "cur" instead of redoing
ktime_get().  In the happy case where hardware correctly predicts
do_halt_poll, "cur" is only a few cycles old.  And if the branch is
mispredicted, arguably that extra latency should count toward the
halt-polling time.

In all likelihood, the numbers involved are in the noise and either
approach is perfectly ok.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a36ccdc93a72..481e8178b43d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3272,7 +3272,7 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 
 	start = cur = poll_end = ktime_get();
 	if (do_halt_poll) {
-		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
+		ktime_t stop = ktime_add_ns(cur, vcpu->halt_poll_ns);
 
 		do {
 			/*
-- 
2.33.0.882.g93a45727a2-goog

