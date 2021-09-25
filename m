Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0C4417EB8
	for <lists+kvm-ppc@lfdr.de>; Sat, 25 Sep 2021 02:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346092AbhIYA5J (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 24 Sep 2021 20:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345973AbhIYA5H (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 24 Sep 2021 20:57:07 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15C4C06161E
        for <kvm-ppc@vger.kernel.org>; Fri, 24 Sep 2021 17:55:33 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id x28-20020ac8701c000000b0029f4b940566so41361789qtm.19
        for <kvm-ppc@vger.kernel.org>; Fri, 24 Sep 2021 17:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=s8Ef8GFuvQfnF9BDar9o1LMsjHo/kVSjkp6RQOizXjk=;
        b=G61LH4mFxuFNSPc8dYANo1eT4LoYTtllF8CmUigAVUwE47niN3IxCLvz7gdu3kXJ4p
         ZQGRUPxd6lVd1pie3osAQPOxmbLJto1U72TFRKzU7SrEeLnRgNzwFM67EhN9OMHtfLK4
         0P8CpLo4DBhmRIO3KNivDhM66x7e790LPKbt1kMUUoaEFJ8BrQ0kHU4SkwA9CnUG4ZvG
         NOgccEjti04droRcKSejfuWWOI2KRU0PMG/o1TrFggkFEC3/F7K7dtkErqqSnuV7wQju
         UsaZQRj+Ze+2OUu3FUTytK0ap4L7DtgKMjJqvpn6WamsAAvTkNWZ6Fzz7ReqK7CQj28q
         kOig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=s8Ef8GFuvQfnF9BDar9o1LMsjHo/kVSjkp6RQOizXjk=;
        b=28+z4TkIZEVxDUrTBkyjsApKZgL+ngg5ogKNvIwJZxMCkZtf1t3MdG5q9l69xe5RLH
         57yrcaUyn8KNH0UXPz/avRix5W0yc8K0xv0EyWZjEygFIoPemmys0f2i7oPlb30Tx3iU
         R/L5AanX6KPopoWWvw1w4vBC0/HkhBL4N9hyKTusQpHG8y+EgFXc3QZe8qSuPXOp9qk/
         RqhoIYVHoa/cWJ0MfyQFJ5rTFO0Tzl/E0kDBHqZqv2lSgTku+egbTcm6sJXBkcMF5Dsd
         dvF/zyEnifXzWCELMkA8bsJDWP1lwatwElJd4Mx7k6q+5KduaaW52pEuFp0Lf0f4DwSs
         QD0Q==
X-Gm-Message-State: AOAM531Dny98+QT0qs7BbWb/v/XpDde0YFbU4cH1PQ7Vu4sPO1YUcU4S
        q6/bxQdgd16adMBeoCF/y67cweK9Juo=
X-Google-Smtp-Source: ABdhPJz4KlXw4aFKDakmak5VHFe0t/03Im2jas/e5lfzq06w+q+oBXLEOxDY5zwYzZ40nGkko5J4YoUheek=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a05:6214:2d1:: with SMTP id
 g17mr13106407qvu.63.1632531332975; Fri, 24 Sep 2021 17:55:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Sep 2021 17:55:15 -0700
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Message-Id: <20210925005528.1145584-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 01/14] KVM: s390: Ensure kvm_arch_no_poll() is read once when
 blocking vCPU
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

Wrap s390's halt_poll_max_steal with READ_ONCE and snapshot the result of
kvm_arch_no_poll() in kvm_vcpu_block() to avoid a mostly-theoretical,
largely benign bug on s390 where the result of kvm_arch_no_poll() could
change due to userspace modifying halt_poll_max_steal while the vCPU is
blocking.  The bug is largely benign as it will either cause KVM to skip
updating halt-polling times (no_poll toggles false=>true) or to update
halt-polling times with a slightly flawed block_ns.

Note, READ_ONCE is unnecessary in the current code, add it in case the
arch hook is ever inlined, and to provide a hint that userspace can
change the param at will.

Fixes: 8b905d28ee17 ("KVM: s390: provide kvm_arch_no_poll function")
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/s390/kvm/kvm-s390.c | 2 +-
 virt/kvm/kvm_main.c      | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6a6dd5e1daf6..7cabe6778b1b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3446,7 +3446,7 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 {
 	/* do not poll with more than halt_poll_max_steal percent of steal time */
 	if (S390_lowcore.avg_steal_timer * 100 / (TICK_USEC << 12) >=
-	    halt_poll_max_steal) {
+	    READ_ONCE(halt_poll_max_steal)) {
 		vcpu->stat.halt_no_poll_steal++;
 		return true;
 	}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 191dac6b1bed..768a4cbb26a6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3213,6 +3213,7 @@ update_halt_poll_stats(struct kvm_vcpu *vcpu, u64 poll_ns, bool waited)
  */
 void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 {
+	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
 	ktime_t start, cur, poll_end;
 	bool waited = false;
 	u64 block_ns;
@@ -3220,7 +3221,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_blocking(vcpu);
 
 	start = cur = poll_end = ktime_get();
-	if (vcpu->halt_poll_ns && !kvm_arch_no_poll(vcpu)) {
+	if (vcpu->halt_poll_ns && halt_poll_allowed) {
 		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
 
 		++vcpu->stat.generic.halt_attempted_poll;
@@ -3275,7 +3276,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	update_halt_poll_stats(
 		vcpu, ktime_to_ns(ktime_sub(poll_end, start)), waited);
 
-	if (!kvm_arch_no_poll(vcpu)) {
+	if (halt_poll_allowed) {
 		if (!vcpu_valid_wakeup(vcpu)) {
 			shrink_halt_poll_ns(vcpu);
 		} else if (vcpu->kvm->max_halt_poll_ns) {
-- 
2.33.0.685.g46640cef36-goog

