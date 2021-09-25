Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49333417EEC
	for <lists+kvm-ppc@lfdr.de>; Sat, 25 Sep 2021 02:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346748AbhIYA6V (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 24 Sep 2021 20:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346622AbhIYA5i (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 24 Sep 2021 20:57:38 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C0DC0617A9
        for <kvm-ppc@vger.kernel.org>; Fri, 24 Sep 2021 17:55:53 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id m10-20020a05620a290a00b004334bcdf1f4so45004884qkp.2
        for <kvm-ppc@vger.kernel.org>; Fri, 24 Sep 2021 17:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=FPrvUwRoNgNi9U/w5sUiMk8txns9C/J9zkg6zAxmMUk=;
        b=Co6Y4RU2OAq+N8cxFZefD6arFCQ0JC5iLzm/wNQUkyHUQaJHgQOwXIreoskXNdo+n3
         AzYCM2VGwVbtuc4RHRZMftKrMPewa2HdqIvv4DhOT1T4TVXUiFm+z0hCrC7zvpiF3bFI
         YrZJATtvuBhXvAfmLk0XrUN/qH+BPPx66OadWSbCOd95621rbYCdmUW1NH06aGo1hYK+
         Xx216lgusMcmvOSwzMUUQUqsZv7pF4ciyTpPrxYAL4ksg4saB36TX8plZlhMO2dauaVz
         bfnWV2i9Gz80QoiefY5JGrMtQWt7jFR1u1lseg1viADOOm6p1dLSrT0hljxiuzqCT12T
         VcrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=FPrvUwRoNgNi9U/w5sUiMk8txns9C/J9zkg6zAxmMUk=;
        b=LqaSQTXDNlT6hPQqKh76BN+zN5ig6XTwOCbmBoWwF0cYLAGHQqS7fu+hizJu3ui3Du
         i2RHpjzBe30+ZI7cLHEQb4WMxHaVo9SODXaLruClF7l6RTSIcme1BICB+ru4gjnPD6Yx
         e+mgS6R/QHWCh7rRljh5DBL13vxkR6Xd3FyocNyk+ujcatyR2D35TJSecuFfES5wNvqA
         jFt8cO6jiwGmtZ0gCkvueIjfvecQJyKSU3WTQ1y9nd03awCWjCbWFPolFbvhkrym7LsH
         kEP1v5cxO6QoZT5UoZoWRwxzJUyUAlc4hIWNEdI35Fs5Y/fnyhAeO/YJTYgsDC676IyE
         qLdw==
X-Gm-Message-State: AOAM53273xwYMbd/cedJQq7enjHhYBeO9xjI7V4DoZA6jpBuFX9riJJS
        f/or0F95goKQcKumNBZLI9WYmQTVCPs=
X-Google-Smtp-Source: ABdhPJwj4rHidVuSerO73p+MgC4zPGIOlGhlmT9p6UEZnOURmS83LLMcFaC8wfCWoMIXuuPy00r2yP97Z9w=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a05:6214:1321:: with SMTP id
 c1mr5005905qvv.43.1632531352819; Fri, 24 Sep 2021 17:55:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Sep 2021 17:55:24 -0700
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Message-Id: <20210925005528.1145584-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 10/14] KVM: Split out a kvm_vcpu_block() helper from kvm_vcpu_halt()
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

Factor out the "block" part of kvm_vcpu_halt() so that x86 can emulate
non-halt wait/sleep/block conditions that should not be subjected to
halt-polling.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 50 ++++++++++++++++++++++++++++------------
 2 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d2a8be3fb9ba..655c2b24db2d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -966,6 +966,7 @@ void kvm_sigset_activate(struct kvm_vcpu *vcpu);
 void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
 
 void kvm_vcpu_halt(struct kvm_vcpu *vcpu);
+bool kvm_vcpu_block(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 280cf1dca7db..fe34457530c2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3199,6 +3199,34 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+/*
+ * Block the vCPU until the vCPU is runnable, an event arrives, or a signal is
+ * pending.  This is mostly used when halting a vCPU, but may also be used
+ * directly for other vCPU non-runnable states, e.g. x86's Wait-For-SIPI.
+ */
+bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
+{
+	bool waited = false;
+
+	kvm_arch_vcpu_blocking(vcpu);
+
+	prepare_to_rcuwait(&vcpu->wait);
+	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+
+		if (kvm_vcpu_check_block(vcpu) < 0)
+			break;
+
+		waited = true;
+		schedule();
+	}
+	finish_rcuwait(&vcpu->wait);
+
+	kvm_arch_vcpu_unblocking(vcpu);
+
+	return waited;
+}
+
 static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
 					  ktime_t end, bool success)
 {
@@ -3221,6 +3249,12 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
 	}
 }
 
+/*
+ * Emulate a vCPU halt condition, e.g. HLT on x86, WFI on arm, etc...  If halt
+ * polling is enabled, busy wait for a short time before blocking to avoid the
+ * expensive block+unblock sequence if a wake event arrives soon after the vCPU
+ * is halted.
+ */
 void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 {
 	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
@@ -3245,21 +3279,7 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 		} while (kvm_vcpu_can_poll(cur, stop));
 	}
 
-	kvm_arch_vcpu_blocking(vcpu);
-
-	prepare_to_rcuwait(&vcpu->wait);
-	for (;;) {
-		set_current_state(TASK_INTERRUPTIBLE);
-
-		if (kvm_vcpu_check_block(vcpu) < 0)
-			break;
-
-		waited = true;
-		schedule();
-	}
-	finish_rcuwait(&vcpu->wait);
-
-	kvm_arch_vcpu_unblocking(vcpu);
+	waited = kvm_vcpu_block(vcpu);
 
 	cur = ktime_get();
 	if (waited) {
-- 
2.33.0.685.g46640cef36-goog

