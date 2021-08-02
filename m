Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9380E3DDE1E
	for <lists+kvm-ppc@lfdr.de>; Mon,  2 Aug 2021 18:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhHBQ44 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 2 Aug 2021 12:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbhHBQ4z (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 2 Aug 2021 12:56:55 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1122CC06175F
        for <kvm-ppc@vger.kernel.org>; Mon,  2 Aug 2021 09:56:45 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id e16-20020ac867100000b0290257b7db4a28so10232909qtp.9
        for <kvm-ppc@vger.kernel.org>; Mon, 02 Aug 2021 09:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VXgwAAaOZDdhQJAmcCsgajsK7P41PLb/M4QBrHtckB4=;
        b=uu/yX7pHqaAAnRRi8Htyf6pBMrBCqXOibwZDpnbIu0BeYMF59NqPMgSBMpU4+v9cmo
         pzfccr0SY9o8sv+uWxPFw5U3G2F2rnUNUipaPp2r9c9lZMtfY14HP523uBYyLzZX+074
         7tZuGo35ZQ3xKrRBjrFpOTrYXWHH/nNKIbtBtpz3UZHRCXpZjvX5qifXY+0w9wBXPvvV
         A6rqQ+qiHWwY2mTuvIFXdWuCB5WlJ1mX344tPjuvkC2z6cgzjvsZyPwDz36qI5ZzwZhy
         GcasoGIZffjX8DnjayYwCwOh85VrVBKxIzY5m1MhZKi1ka4lOhKhU0T2nOEKtB5mmD9s
         vS3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VXgwAAaOZDdhQJAmcCsgajsK7P41PLb/M4QBrHtckB4=;
        b=KNdmh4ki5GLN91RoldPDaPtBDueCdjHuyYdDNsdKPMIXtGspAbMK2Q3/M3DlYZu762
         PwRkui6j5OoTSNRRiXmbX2Gnq5ng1xRzVdwjEZnBdZRPUBiEJQ0CtqEBQ70f6Fy6WP6b
         gJnwFe8+U9K/gjPIZHWjiS/I7bQn3R+tGwCvqGelJ7kJ5fq1Mo50I0xmdmnVJnaMo9MV
         xujysURxUF4XLNpDGCJLmiHPsXimccSLdE/tiuQ7XVqIrT83ZYYxRX2FFOrk21n+Gkr5
         SeEWaRPZSEWc7pOt/HBXLlnx2h1zYw8cOeRUAvyCjFaGM0y0k/wBmweJ6dhngkRdW6gP
         ykAw==
X-Gm-Message-State: AOAM531uJojpyTFXeZ6FeW8EVrCqcxMqell7ftfCOEqdgq1Dsm2eyQF0
        mLDlyeBLUpM939Txuh0JeDHdjnl0X9z5TFG2rA==
X-Google-Smtp-Source: ABdhPJzSVgOt+I8hE7F+dMFTwoIwceAnL+TZyLr2Lod8tHBnGw0g7rMKXyKpoSWaKDECLgbhxIltoepmGIpkqP7osA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:ad4:4972:: with SMTP id
 p18mr5954084qvy.26.1627923404246; Mon, 02 Aug 2021 09:56:44 -0700 (PDT)
Date:   Mon,  2 Aug 2021 16:56:33 +0000
In-Reply-To: <20210802165633.1866976-1-jingzhangos@google.com>
Message-Id: <20210802165633.1866976-6-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210802165633.1866976-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v3 5/5] KVM: stats: Add halt polling related histogram stats
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Add three log histogram stats to record the distribution of time spent
on successful polling, failed polling and VCPU wait.
halt_poll_success_hist: Distribution of spent time for a successful poll.
halt_poll_fail_hist: Distribution of spent time for a failed poll.
halt_wait_hist: Distribution of time a VCPU has spent on waiting.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/powerpc/kvm/book3s_hv.c | 16 ++++++++++++++--
 include/linux/kvm_host.h     |  8 +++++++-
 include/linux/kvm_types.h    |  5 +++++
 virt/kvm/kvm_main.c          | 12 ++++++++++++
 4 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 813ca155561b..6d63c8e6d4f0 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4146,17 +4146,29 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 	if (do_sleep) {
 		vc->runner->stat.generic.halt_wait_ns +=
 			ktime_to_ns(cur) - ktime_to_ns(start_wait);
+		KVM_STATS_LOG_HIST_UPDATE(
+				vc->runner->stat.generic.halt_wait_hist,
+				ktime_to_ns(cur) - ktime_to_ns(start_wait));
 		/* Attribute failed poll time */
-		if (vc->halt_poll_ns)
+		if (vc->halt_poll_ns) {
 			vc->runner->stat.generic.halt_poll_fail_ns +=
 				ktime_to_ns(start_wait) -
 				ktime_to_ns(start_poll);
+			KVM_STATS_LOG_HIST_UPDATE(
+				vc->runner->stat.generic.halt_poll_fail_hist,
+				ktime_to_ns(start_wait) -
+				ktime_to_ns(start_poll));
+		}
 	} else {
 		/* Attribute successful poll time */
-		if (vc->halt_poll_ns)
+		if (vc->halt_poll_ns) {
 			vc->runner->stat.generic.halt_poll_success_ns +=
 				ktime_to_ns(cur) -
 				ktime_to_ns(start_poll);
+			KVM_STATS_LOG_HIST_UPDATE(
+				vc->runner->stat.generic.halt_poll_success_hist,
+				ktime_to_ns(cur) - ktime_to_ns(start_poll));
+		}
 	}
 
 	/* Adjust poll time */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9b773fef7bba..b67f01f61840 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1403,7 +1403,13 @@ struct _kvm_stats_desc {
 	STATS_DESC_COUNTER(VCPU_GENERIC, halt_wakeup),			       \
 	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_success_ns),	       \
 	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_ns),		       \
-	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_wait_ns)
+	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_wait_ns),		       \
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_success_hist,     \
+			HALT_POLL_HIST_COUNT),				       \
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_hist,	       \
+			HALT_POLL_HIST_COUNT),				       \
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_wait_hist,	       \
+			HALT_POLL_HIST_COUNT)
 
 extern struct dentry *kvm_debugfs_dir;
 
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 291ef55125b2..de7fb5f364d8 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -76,6 +76,8 @@ struct kvm_mmu_memory_cache {
 };
 #endif
 
+#define HALT_POLL_HIST_COUNT			32
+
 struct kvm_vm_stat_generic {
 	u64 remote_tlb_flush;
 };
@@ -88,6 +90,9 @@ struct kvm_vcpu_stat_generic {
 	u64 halt_poll_success_ns;
 	u64 halt_poll_fail_ns;
 	u64 halt_wait_ns;
+	u64 halt_poll_success_hist[HALT_POLL_HIST_COUNT];
+	u64 halt_poll_fail_hist[HALT_POLL_HIST_COUNT];
+	u64 halt_wait_hist[HALT_POLL_HIST_COUNT];
 };
 
 #define KVM_STATS_NAME_SIZE	48
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index af9bcb50fdd4..717006de17e7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3166,13 +3166,23 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 				++vcpu->stat.generic.halt_successful_poll;
 				if (!vcpu_valid_wakeup(vcpu))
 					++vcpu->stat.generic.halt_poll_invalid;
+
+				KVM_STATS_LOG_HIST_UPDATE(
+				      vcpu->stat.generic.halt_poll_success_hist,
+				      ktime_to_ns(ktime_get()) -
+				      ktime_to_ns(start));
 				goto out;
 			}
 			cpu_relax();
 			poll_end = cur = ktime_get();
 		} while (kvm_vcpu_can_poll(cur, stop));
+
+		KVM_STATS_LOG_HIST_UPDATE(
+				vcpu->stat.generic.halt_poll_fail_hist,
+				ktime_to_ns(ktime_get()) - ktime_to_ns(start));
 	}
 
+
 	prepare_to_rcuwait(&vcpu->wait);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -3188,6 +3198,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	if (waited) {
 		vcpu->stat.generic.halt_wait_ns +=
 			ktime_to_ns(cur) - ktime_to_ns(poll_end);
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.generic.halt_wait_hist,
+				ktime_to_ns(cur) - ktime_to_ns(poll_end));
 	}
 out:
 	kvm_arch_vcpu_unblocking(vcpu);
-- 
2.32.0.554.ge1b32706d8-goog

