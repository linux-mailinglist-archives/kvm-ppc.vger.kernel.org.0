Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED8F423908
	for <lists+kvm-ppc@lfdr.de>; Wed,  6 Oct 2021 09:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhJFHjp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 6 Oct 2021 03:39:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31573 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230013AbhJFHjp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 6 Oct 2021 03:39:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633505872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Gyw5R4SyvxKZs08K5h9MF/DzccP5WiPryhGpnJiBB6w=;
        b=TbtWsRVvFDoO8uaPMfGWJmyD2eMuFkIQIHtDGG6kiv0rRpk3r6ndO0+Js67xD6qYRABn+8
        6pY3iphnedI1iyZzzf5+MWMepQhpA7YwGYsWW0fk7zLuTTOuCVBerHEQ7cMM3fFAuTdb1m
        meIxMVazgD1+3lsv4QbGxOeFi/HzuQY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-PRnThVInPqCZG6UN_wl6-g-1; Wed, 06 Oct 2021 03:37:51 -0400
X-MC-Unique: PRnThVInPqCZG6UN_wl6-g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E8C1801E72;
        Wed,  6 Oct 2021 07:37:50 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.39.192.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB2DF5D9CA;
        Wed,  6 Oct 2021 07:37:46 +0000 (UTC)
From:   Laurent Vivier <lvivier@redhat.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH] KVM: PPC: Defer vtime accounting 'til after IRQ handling
Date:   Wed,  6 Oct 2021 09:37:45 +0200
Message-Id: <20211006073745.82109-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Commit 61bd0f66ff92 has moved guest_enter() out of the interrupt
protected area to be able to have updated tick counters, but
commit 112665286d08 moved back to this area to avoid wrong
context warning (or worse).

None of them are correct, to fix the problem port to POWER
the x86 fix 160457140187 ("KVM: x86: Defer vtime accounting 'til
after IRQ handling"):

"Defer the call to account guest time until after servicing any IRQ(s)
 that happened in the guest or immediately after VM-Exit.  Tick-based
 accounting of vCPU time relies on PF_VCPU being set when the tick IRQ
 handler runs, and IRQs are blocked throughout the main sequence of
 vcpu_enter_guest(), including the call into vendor code to actually
 enter and exit the guest."

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2009312
Fixes: 61bd0f66ff92 ("KVM: PPC: Book3S HV: Fix guest time accounting with VIRT_CPU_ACCOUNTING_GEN")
Fixes: 112665286d08 ("KVM: PPC: Book3S HV: Context tracking exit guest context before enabling irqs")
Cc: npiggin@gmail.com

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---
 arch/powerpc/kvm/book3s_hv.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 2acb1c96cfaf..43e1ce853785 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3695,6 +3695,8 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 
 	srcu_read_unlock(&vc->kvm->srcu, srcu_idx);
 
+	context_tracking_guest_exit();
+
 	set_irq_happened(trap);
 
 	spin_lock(&vc->lock);
@@ -3726,9 +3728,8 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 
 	kvmppc_set_host_core(pcpu);
 
-	guest_exit_irqoff();
-
 	local_irq_enable();
+	vtime_account_guest_exit();
 
 	/* Let secondaries go back to the offline loop */
 	for (i = 0; i < controlled_threads; ++i) {
@@ -4506,13 +4507,14 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 
+	context_tracking_guest_exit();
+
 	set_irq_happened(trap);
 
 	kvmppc_set_host_core(pcpu);
 
-	guest_exit_irqoff();
-
 	local_irq_enable();
+	vtime_account_guest_exit();
 
 	cpumask_clear_cpu(pcpu, &kvm->arch.cpu_in_guest);
 
-- 
2.31.1

