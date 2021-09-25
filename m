Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24AD7417EF5
	for <lists+kvm-ppc@lfdr.de>; Sat, 25 Sep 2021 02:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346490AbhIYA6h (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 24 Sep 2021 20:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346911AbhIYA6V (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 24 Sep 2021 20:58:21 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3CDC0617BB
        for <kvm-ppc@vger.kernel.org>; Fri, 24 Sep 2021 17:55:57 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id s10-20020a05621406aa00b003821a333809so23915125qvz.21
        for <kvm-ppc@vger.kernel.org>; Fri, 24 Sep 2021 17:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=5cNFroYBSThqqpJCYxzBjAkytlwovA+rbtWpXsyqDeo=;
        b=SfLacDGDPv0O+ce1feGYy7BDlJVOIPkrwFpJqoWdePykloL2O82WlaKRzOwLeffojV
         WekB5mzNRTsRAE7CDSxzp55a5GlHpqh/h04E/0Cqn+9co39zSHc1rwlgwjHIm0Eq+/g1
         rLsDyI7TI6ImRbwiTwKX0t1Q8ZQyoCYrzRYyQ4Xqwn0rlAUNh8TrYEq/em7hwrNonrfc
         Au70p/9HXYWVD3oyP35n9WXZarKqfxjjLGSen8K95241TMcO649zTLMZSD1UsjUAj//k
         JNR5GrbIoX2CF5HqJzqUR8/mcVQlOI2NUabeIFYhUNE1yZiL3ZPJAKN3+lQsuLE7ow/b
         sO3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=5cNFroYBSThqqpJCYxzBjAkytlwovA+rbtWpXsyqDeo=;
        b=QdxHTZxWc3WEyZShxUrEW82MHPEeSSUND98A5vsmhTDwfDr+Hr7M/aJnsf/KODHMsC
         /TeRERvrHXivsl0dwuJ0o3DySwOVzr91oaYoObXUXlYuZ0hp+Hc68sRqKPsTaveGON7X
         FtUuTg+HVs5BwKRQVzD0VUGkvZygpqnftT4pcJ1nF4b/TIZAlSKUJAnIf5c2uvLWp0F2
         B7LrEgA1C/7bZxaBNN4sU4qhX39BSem3XrJlpBt43TSQ74wwS1GNIoJJqtJtBAWqhczQ
         CiNAtG2FCm4Te2xhu4ZK8X5LwmSGzSrxYHqcq/zdmMELCmq9leVFpUx8jLiO7XQGKTcS
         GIAg==
X-Gm-Message-State: AOAM533XJ68ZmzGqWoDj5T+rqktMHxInKaJ6KT2/AJdmG2CDUkdH7AXB
        Qt6In/F+kS1Y47LVcDtUwbv26Rj3SWM=
X-Google-Smtp-Source: ABdhPJwTW1UybwFgg5M8F4nzh531Ub5JbtN0jF/yWxCBJfUYuvXgy/++XZQV+BSuMlLfxb0INGVd0hW95rg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a05:6214:148b:: with SMTP id
 bn11mr13269187qvb.67.1632531356963; Fri, 24 Sep 2021 17:55:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Sep 2021 17:55:26 -0700
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Message-Id: <20210925005528.1145584-13-seanjc@google.com>
Mime-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 12/14] KVM: Don't redo ktime_get() when calculating
 halt-polling stop/deadline
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
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
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
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

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2980d2b88559..80f78daa6b8d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3267,7 +3267,7 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 
 	start = cur = poll_end = ktime_get();
 	if (do_halt_poll) {
-		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
+		ktime_t stop = ktime_add_ns(cur, vcpu->halt_poll_ns);
 
 		do {
 			/*
-- 
2.33.0.685.g46640cef36-goog

