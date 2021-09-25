Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E591F417ED5
	for <lists+kvm-ppc@lfdr.de>; Sat, 25 Sep 2021 02:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346471AbhIYA5U (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 24 Sep 2021 20:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346320AbhIYA5O (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 24 Sep 2021 20:57:14 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40038C0614ED
        for <kvm-ppc@vger.kernel.org>; Fri, 24 Sep 2021 17:55:40 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v66-20020a25abc8000000b0059ef57c3386so5834576ybi.1
        for <kvm-ppc@vger.kernel.org>; Fri, 24 Sep 2021 17:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=FC6lH+ozNX1rSn/Zvey/qYq1p870FyZo4a/L9N/Tnnw=;
        b=H1jaweJg22GIvKz5wgIWDSWv9jBnold6xO8+Vir58J3vlW5yvGMJeY+RWUfUakOq0R
         orXdIRa207F1tk4zi8vuNL8CHfSf+xkMzWW/nJggJB4dETOCDuAFmo/uxwSrXfHa281o
         qUP6uOeam12R8fIodx3kiS3/hgxxDJx4AhPCjd3rZUC9XrvKS1+XNmDeTDwaJ19xQqhV
         cyard+R6ZMOtQO+e0PqanrPIokG2Of63+8xBF7DfYrbPWcKhcpKGH/k2SRB/D5Z/gfcU
         kBugNJHQN0/5+P2fD4RJGRBJy0JvWbzcwyoR231nRb6G1W76P8apmJbzeaDCVzireilR
         R6gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=FC6lH+ozNX1rSn/Zvey/qYq1p870FyZo4a/L9N/Tnnw=;
        b=yWg6K8Q2Vj9P1/RHlpcWz5KVx+BLG72hec38D0EQJHUp5cNvow2kMRDf78ZdvMi3dh
         VJy2eYwyDS1VvAnLBqhP301Ee1oT6PnFR8F6CvF2W8eOdarh75X7kV2qbI3oDW6IYTNZ
         2DAT3IC++D/L9xwmv/X/WjnkHPDKKP+a/wFrlr7O7qYRb9nzB627WRBd3kITlecANaZU
         C5s65a2JisUb5DfB2IAzytiT1YG0xUX5D4KDywdv2YTGOoeZz5UMOLNJrH2/CGHTThRc
         rmTgFEivoKF6tLqIksyWvTYGXCbCpUvME4WjkDcrkoqJvHQTuoJn1Tg+W3LwALgjrlUQ
         TfOQ==
X-Gm-Message-State: AOAM530OwwzZJkESU4wilY/k61QpWU3jEws3lixk9HV9aZFc2F7QgLEb
        zmlXyDbq4y36sQ4bONltfH+dy6zbg8U=
X-Google-Smtp-Source: ABdhPJxLhkd4HzFL3dM1t/bnW3GVwOoYRsLTHfSU097HYEpOs+mMFMdF2Jxk4a9ePTkex/UXZCMknlTjhiQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a25:d747:: with SMTP id o68mr16209002ybg.488.1632531339489;
 Fri, 24 Sep 2021 17:55:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Sep 2021 17:55:18 -0700
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Message-Id: <20210925005528.1145584-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 04/14] KVM: Reconcile discrepancies in halt-polling stats
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

Move the halt-polling "success" and histogram stats update into the
dedicated helper to fix a discrepancy where the success/fail "time" stats
consider polling successful so long as the wait is avoided, but the main
"success" and histogram stats consider polling successful if and only if
a wake event was detected by the halt-polling loop.

Move halt_attempted_poll to the helper as well so that all the stats are
updated in a single location.  While it's a bit odd to update the stat
well after the fact, practically speaking there's no meaningful advantage
to updating before polling.

Note, there is a functional change in addition to the success vs. fail
change.  The histogram updates previously called ktime_get() instead of
using "cur".  But that change is desirable as it means all the stats are
now updated with the same polling time, and avoids the extra ktime_get(),
which isn't expensive but isn't free either.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 12fe91a0a4c8..2ba22b68af3b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3202,12 +3202,23 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
 static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
 					  ktime_t end, bool success)
 {
+	struct kvm_vcpu_stat_generic *stats = &vcpu->stat.generic;
 	u64 poll_ns = ktime_to_ns(ktime_sub(end, start));
 
-	if (success)
-		vcpu->stat.generic.halt_poll_success_ns += poll_ns;
-	else
-		vcpu->stat.generic.halt_poll_fail_ns += poll_ns;
+	++vcpu->stat.generic.halt_attempted_poll;
+
+	if (success) {
+		++vcpu->stat.generic.halt_successful_poll;
+
+		if (!vcpu_valid_wakeup(vcpu))
+			++vcpu->stat.generic.halt_poll_invalid;
+
+		stats->halt_poll_success_ns += poll_ns;
+		KVM_STATS_LOG_HIST_UPDATE(stats->halt_poll_success_hist, poll_ns);
+	} else {
+		stats->halt_poll_fail_ns += poll_ns;
+		KVM_STATS_LOG_HIST_UPDATE(stats->halt_poll_fail_hist, poll_ns);
+	}
 }
 
 /*
@@ -3227,30 +3238,16 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	if (do_halt_poll) {
 		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
 
-		++vcpu->stat.generic.halt_attempted_poll;
 		do {
 			/*
 			 * This sets KVM_REQ_UNHALT if an interrupt
 			 * arrives.
 			 */
-			if (kvm_vcpu_check_block(vcpu) < 0) {
-				++vcpu->stat.generic.halt_successful_poll;
-				if (!vcpu_valid_wakeup(vcpu))
-					++vcpu->stat.generic.halt_poll_invalid;
-
-				KVM_STATS_LOG_HIST_UPDATE(
-				      vcpu->stat.generic.halt_poll_success_hist,
-				      ktime_to_ns(ktime_get()) -
-				      ktime_to_ns(start));
+			if (kvm_vcpu_check_block(vcpu) < 0)
 				goto out;
-			}
 			cpu_relax();
 			poll_end = cur = ktime_get();
 		} while (kvm_vcpu_can_poll(cur, stop));
-
-		KVM_STATS_LOG_HIST_UPDATE(
-				vcpu->stat.generic.halt_poll_fail_hist,
-				ktime_to_ns(ktime_get()) - ktime_to_ns(start));
 	}
 
 
-- 
2.33.0.685.g46640cef36-goog

