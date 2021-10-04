Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8190421361
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236247AbhJDQDm (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236245AbhJDQDl (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:03:41 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55B3C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:01:52 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id m21so16926702pgu.13
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+uifPGYlRIbN5mTHvUbZjtaaYYRvM7KqJ3vO8EmF4DI=;
        b=XITgc8RJByYf5tfAAvYEE3fH5jgqKB2ALbN1qiAbVXPBSv3UghC3UhFKAggSOwhafw
         nd9sbGhwE0w/Ce6sxG/M4VHE4EMtvxNJypiDXY/5Rr5wPcO59ioDlh+FDVev9c/un9zR
         ZOS6i7BAzbp76Vb7vJpA6JHPtpRUqxcQSpo1eyrH/YY3pWwD6H7uLBZfvrRVRZcqpQDS
         HihpwPE8PpWqiOQq/+UIirBaDJZfb6utgiZPv9rt3vhQpTBkz0JKHaOR3UksFClgl8PX
         2e664zqByaQX1VH0Dq17LnQdUKi6HxhZxhTD7l2Q+78gAa4qUgdvm/mEvYq5ALIlzwa2
         k6hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+uifPGYlRIbN5mTHvUbZjtaaYYRvM7KqJ3vO8EmF4DI=;
        b=t0p6QoXicVQefhQKre93HV12REaepXfnmcLXJdVBI96zK+n/vYhOuIALWjUZE08CAn
         HN5DWOhSWqAU/J1j8tXw57j+Z/a/9tI+ZX4SX3DO4bBl7QIbIEfs3cK5eTrnyzf4UbdU
         XHqiBUAC7jb2/LPme1yriPzWj43UExDgt71mVNuttiG5eo+wfxdm8f6mVXy3ia2YB6mt
         Q21qbHSMx80Ei1lBKWuXsS7iAsQ1Y+u6RH9ikeVsW6gj5x83KjohqYvq+/wvfC8hkJql
         n2xRtmE+joAMXjpILIR+4pCTknEUVi1hMxw7f3DDQ1W/XG7TQSxlYeuVXaO7eAHkaC19
         JM6Q==
X-Gm-Message-State: AOAM531N1LhjOGXTZgMZuWn+A2JBoUYzfmtSEFoLdpG+XMfskdLg2aKf
        +KkRIjj4ryPjqyJp4/4pvlaSwx33s0A=
X-Google-Smtp-Source: ABdhPJyNq27FnsuPIjdFF/2bUzMcOMAx0XQUSvD/HRDWTzd9kWE+rNvvjQl1qezB9/4JVlhHsWfEMQ==
X-Received: by 2002:a63:ce52:: with SMTP id r18mr11325811pgi.350.1633363312287;
        Mon, 04 Oct 2021 09:01:52 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:01:52 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v3 21/52] KVM: PPC: Book3S HV P9: Add kvmppc_stop_thread to match kvmppc_start_thread
Date:   Tue,  5 Oct 2021 02:00:18 +1000
Message-Id: <20211004160049.1338837-22-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Small cleanup makes it a bit easier to match up entry and exit
operations.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 7e8ddffd61c7..0a711d929531 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3070,6 +3070,13 @@ static void kvmppc_start_thread(struct kvm_vcpu *vcpu, struct kvmppc_vcore *vc)
 		kvmppc_ipi_thread(cpu);
 }
 
+/* Old path does this in asm */
+static void kvmppc_stop_thread(struct kvm_vcpu *vcpu)
+{
+	vcpu->cpu = -1;
+	vcpu->arch.thread_cpu = -1;
+}
+
 static void kvmppc_wait_for_nap(int n_threads)
 {
 	int cpu = smp_processor_id();
@@ -4297,8 +4304,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		dec = (s32) dec;
 	tb = mftb();
 	vcpu->arch.dec_expires = dec + tb;
-	vcpu->cpu = -1;
-	vcpu->arch.thread_cpu = -1;
 
 	store_spr_state(vcpu);
 
@@ -4782,6 +4787,8 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	guest_exit_irqoff();
 
+	kvmppc_stop_thread(vcpu);
+
 	powerpc_local_irq_pmu_restore(flags);
 
 	cpumask_clear_cpu(pcpu, &kvm->arch.cpu_in_guest);
-- 
2.23.0

