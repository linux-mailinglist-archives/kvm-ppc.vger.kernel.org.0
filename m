Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BF71B900A
	for <lists+kvm-ppc@lfdr.de>; Sun, 26 Apr 2020 14:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgDZMjP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 26 Apr 2020 08:39:15 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:46856 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726144AbgDZMjO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 26 Apr 2020 08:39:14 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01419;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0TwgcTe9_1587904746;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0TwgcTe9_1587904746)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 26 Apr 2020 20:39:07 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     pbonzini@redhat.com, tsbogend@alpha.franken.de, paulus@ozlabs.org,
        mpe@ellerman.id.au, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        tianjia.zhang@linux.alibaba.com
Subject: [PATCH v3 1/7] KVM: s390: clean up redundant 'kvm_run' parameters
Date:   Sun, 26 Apr 2020 20:38:59 +0800
Message-Id: <20200426123905.8336-2-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200426123905.8336-1-tianjia.zhang@linux.alibaba.com>
References: <20200426123905.8336-1-tianjia.zhang@linux.alibaba.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

In the current kvm version, 'kvm_run' has been included in the 'kvm_vcpu'
structure. Earlier than historical reasons, many kvm-related function
parameters retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time.
This patch does a unified cleanup of these remaining redundant parameters.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 arch/s390/kvm/kvm-s390.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index e335a7e5ead7..c0d94eaa00d7 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4176,8 +4176,9 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 	return rc;
 }
 
-static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static void sync_regs_fmt2(struct kvm_vcpu *vcpu)
 {
+	struct kvm_run *kvm_run = vcpu->run;
 	struct runtime_instr_cb *riccb;
 	struct gs_cb *gscb;
 
@@ -4243,8 +4244,10 @@ static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	/* SIE will load etoken directly from SDNX and therefore kvm_run */
 }
 
-static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static void sync_regs(struct kvm_vcpu *vcpu)
 {
+	struct kvm_run *kvm_run = vcpu->run;
+
 	if (kvm_run->kvm_dirty_regs & KVM_SYNC_PREFIX)
 		kvm_s390_set_prefix(vcpu, kvm_run->s.regs.prefix);
 	if (kvm_run->kvm_dirty_regs & KVM_SYNC_CRS) {
@@ -4273,7 +4276,7 @@ static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	/* Sync fmt2 only data */
 	if (likely(!kvm_s390_pv_cpu_is_protected(vcpu))) {
-		sync_regs_fmt2(vcpu, kvm_run);
+		sync_regs_fmt2(vcpu);
 	} else {
 		/*
 		 * In several places we have to modify our internal view to
@@ -4292,8 +4295,10 @@ static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	kvm_run->kvm_dirty_regs = 0;
 }
 
-static void store_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static void store_regs_fmt2(struct kvm_vcpu *vcpu)
 {
+	struct kvm_run *kvm_run = vcpu->run;
+
 	kvm_run->s.regs.todpr = vcpu->arch.sie_block->todpr;
 	kvm_run->s.regs.pp = vcpu->arch.sie_block->pp;
 	kvm_run->s.regs.gbea = vcpu->arch.sie_block->gbea;
@@ -4313,8 +4318,10 @@ static void store_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	/* SIE will save etoken directly into SDNX and therefore kvm_run */
 }
 
-static void store_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static void store_regs(struct kvm_vcpu *vcpu)
 {
+	struct kvm_run *kvm_run = vcpu->run;
+
 	kvm_run->psw_mask = vcpu->arch.sie_block->gpsw.mask;
 	kvm_run->psw_addr = vcpu->arch.sie_block->gpsw.addr;
 	kvm_run->s.regs.prefix = kvm_s390_get_prefix(vcpu);
@@ -4333,7 +4340,7 @@ static void store_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	current->thread.fpu.fpc = vcpu->arch.host_fpregs.fpc;
 	current->thread.fpu.regs = vcpu->arch.host_fpregs.regs;
 	if (likely(!kvm_s390_pv_cpu_is_protected(vcpu)))
-		store_regs_fmt2(vcpu, kvm_run);
+		store_regs_fmt2(vcpu);
 }
 
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
@@ -4371,7 +4378,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		goto out;
 	}
 
-	sync_regs(vcpu, kvm_run);
+	sync_regs(vcpu);
 	enable_cpu_timer_accounting(vcpu);
 
 	might_fault();
@@ -4393,7 +4400,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	}
 
 	disable_cpu_timer_accounting(vcpu);
-	store_regs(vcpu, kvm_run);
+	store_regs(vcpu);
 
 	kvm_sigset_deactivate(vcpu);
 
-- 
2.17.1

