Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46D732EDD7
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhCEPIO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbhCEPIF (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:08:05 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA5EC061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:08:05 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id a4so1563190pgc.11
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QzXCzutKukC9Wg7gG7X4oitma3Q1T8uld96XlvQC3Po=;
        b=B/hI0z2/TUpmpqxB+Qyll0GHT+RKS9kLLrrKBq0y2QN3tdGeh27XjYH0wcPvUhwsu9
         EiytOTWgSd/nC1rKiB7h/+/OIcuscmg69ztw4M+aGt+xQHv9qXSmhu3IeZbtuH/OJbeC
         RO0IDpRx94Gzrqq+LMT4WY5uZGy8kqQcQntpMQ0PP8tj3ydUCGOeFcpbisjJ55zIAXM3
         VQ2RAlcCDmX1w+qdm9ppEZL5zJ8TkCNHu2yQjYYfnq0O8WXjG7t64c5a5DqZJo5qJnr8
         LOsTo+N+5hbj6VypaM7S7aZYk04KjryRNo6O0WPOD/v+tcBcDyGZBoNdhkkPFeRhcilX
         m+lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QzXCzutKukC9Wg7gG7X4oitma3Q1T8uld96XlvQC3Po=;
        b=gfDQHwsD9W+gH2CjGaUEcWrbfcBxYnjPPVz8ooDmwrY+aIPBqUqiFAGSKvTF0TAXDt
         IRUbRqFUV+GWDjFtuDYd8Q27t3Giauo4QIBmLFkijXp6K2vKKHsT+E9cZgj+Q3R1bQR6
         Wq5vSHRyBkGvdrPPbTsaKggyepHOz7pSpmsloYu+yvnnpvtvMQ7y5THqmz8F7J9Dn32w
         zjuZ6A0KvN4DwFcd4EJSBrbCSqHIuqWMHX4pNP/Y2g+cbFJGEa4Z0CMj+hTc+5hRsEWQ
         itnVUjFg0jeI1y23EXifDBUu3dTVXArEqwW7C7uWulOvXGZEkz/QuF8ml2w11R532j4i
         n3Ig==
X-Gm-Message-State: AOAM532XvJQfyJd4qHjgptJyr6mw/cGHtK/D751/fqTLZC69I+ZW1mJD
        GaBQGr43nN7dtnJ/yfz5DOFhLQYBpa4=
X-Google-Smtp-Source: ABdhPJyQpptMhLq5xAwh1XlV8bHuoF+2aAcPCC0YBYqpDhVuOYLFRSYLp68TZr2mr2oIElBtbWoHHA==
X-Received: by 2002:a63:a54f:: with SMTP id r15mr8223576pgu.430.1614956884242;
        Fri, 05 Mar 2021 07:08:04 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:08:03 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 22/41] KVM: PPC: Book3S HV P9: Use host timer accounting to avoid decrementer read
Date:   Sat,  6 Mar 2021 01:06:19 +1000
Message-Id: <20210305150638.2675513-23-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

There is no need to save away the host DEC value, as it is derived
from the host timer subsystem, which maintains the next timer time.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/time.h |  5 +++++
 arch/powerpc/kernel/time.c      |  1 +
 arch/powerpc/kvm/book3s_hv.c    | 12 ++++++------
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index 68d94711811e..0128cd9769bc 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -101,6 +101,11 @@ extern void __init time_init(void);
 
 DECLARE_PER_CPU(u64, decrementers_next_tb);
 
+static inline u64 timer_get_next_tb(void)
+{
+	return __this_cpu_read(decrementers_next_tb);
+}
+
 /* Convert timebase ticks to nanoseconds */
 unsigned long long tb_to_ns(unsigned long long tb_ticks);
 
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index b67d93a609a2..c5d524622c17 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -108,6 +108,7 @@ struct clock_event_device decrementer_clockevent = {
 EXPORT_SYMBOL(decrementer_clockevent);
 
 DEFINE_PER_CPU(u64, decrementers_next_tb);
+EXPORT_SYMBOL_GPL(decrementers_next_tb);
 static DEFINE_PER_CPU(struct clock_event_device, decrementers);
 
 #define XSEC_PER_SEC (1024*1024)
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 24b0680f0ad7..c1965a9d8d00 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3645,16 +3645,16 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	unsigned long host_amr = mfspr(SPRN_AMR);
 	unsigned long host_fscr = mfspr(SPRN_FSCR);
 	s64 dec;
-	u64 tb;
+	u64 tb, next_timer;
 	int trap, save_pmu;
 
-	dec = mfspr(SPRN_DEC);
 	tb = mftb();
-	if (dec < 0)
+	next_timer = timer_get_next_tb();
+	if (tb >= next_timer)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
-	local_paca->kvm_hstate.dec_expires = dec + tb;
-	if (local_paca->kvm_hstate.dec_expires < time_limit)
-		time_limit = local_paca->kvm_hstate.dec_expires;
+	local_paca->kvm_hstate.dec_expires = next_timer;
+	if (next_timer < time_limit)
+		time_limit = next_timer;
 
 	vcpu->arch.ceded = 0;
 
-- 
2.23.0

