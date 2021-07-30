Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9694E3DB26E
	for <lists+kvm-ppc@lfdr.de>; Fri, 30 Jul 2021 06:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhG3En3 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 30 Jul 2021 00:43:29 -0400
Received: from ozlabs.ru ([107.174.27.60]:42188 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229609AbhG3En3 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 30 Jul 2021 00:43:29 -0400
Received: from fstn1-p1.ozlabs.ibm.com. (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 76B7CAE80062;
        Fri, 30 Jul 2021 00:43:20 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org
Subject: [PATCH kernel] powerpc/powernv: Check if powernv_rng is initialized
Date:   Fri, 30 Jul 2021 14:43:15 +1000
Message-Id: <20210730044315.956125-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The powernv-rng driver has 2 users - the bare metal powernv platform and
the KVM's H_RANDOM hcall. The hcall handler works fine when it is L0 KVM
but fails in L1 KVM as there is no support for the HW registers in L1 VMs
and such support is not advertised either (== no "ibm,power-rng" in
the FDT). So when a nested VM tries H_RANDOM, the L1 KVM crashes on
in_be64(rng->regs).

This checks the pointers and returns an error if the feature is not
set up.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---


Randomly randomized H_RANDOM:

00:00:45 executing program 10:
r0 = openat$kvm(0xffffffffffffff9c, &(0x7f0000000000), 0x0, 0x0)
r1 = ioctl$KVM_CREATE_VM(r0, 0x2000ae01, 0x0)
r2 = ioctl$KVM_CREATE_VCPU(r1, 0x2000ae41, 0x0)
ioctl$KVM_SET_REGS(r2, 0x8188ae82, &(0x7f00000001c0)={[0x0, 0x0, 0xffffffffffffffe1, 0x0, 0x0, 0x200000953, 0x0, 0xfffffffffffffffe, 0x0, 0x0, 0x2], 0x2000})
syz_kvm_setup_cpu$ppc64(0xffffffffffffffff, r2, &(0x7f0000e80000/0x180000)=nil, 0x0, 0x0, 0x0, 0x0, 0x0)
r3 = openat$kvm(0xffffffffffffff9c, &(0x7f0000000100), 0x0, 0x0)
syz_kvm_setup_cpu$ppc64(r1, r2, &(0x7f0000e70000/0x180000)=nil, &(0x7f0000000080)=[{0x0, &(0x7f0000000280)="0000e03d0080ef61e403ef790000ef650900ef61647b007c0000e03f0000ff63e403ff7b0000ff679952ff6370e63f7e0000603c00006360e4036378000063640003636018a8803c28bf8460e4038478ef97846436888460b6f6a03c88d6a560e403a5781beda564d879a5602665c03cb08dc660e403c67806b3c664966fc660d53fe03cddf1e760e403e7785c41e7646623e76022000044463fb1f20000803e00809462e403947a0000946604009462a6a6607f4abb4c130000603f00007b63e4037b7b00007b679a367b6332d9c17c201c994f7201004cbb7a603f72047b63e4037b7b955f7b6799947b636401607f", 0xf0}], 0x1, 0x0, &(0x7f00000000c0)=[@featur2={0x1, 0x1000}], 0x1)


cpu 0xd: Vector: 300 (Data Access) at [c00000001599f590]
    pc: c00000000011d2bc: powernv_get_random_long+0x4c/0xc0
    lr: c00000000011d298: powernv_get_random_long+0x28/0xc0
    sp: c00000001599f830
   msr: 800000000280b033
   dar: 0
 dsisr: 40000000
  current = 0xc0000000614c7f80
  paca    = 0xc0000000fff81700	 irqmask: 0x03	 irq_happened: 0x01
    pid   = 31576, comm = syz-executor.10

Linux version 5.14.0-rc2-le_f29cf1ff9a23_a+fstn1 (aik@fstn1-p1) (gcc (Ubuntu 10.3.0-1ubuntu1) 10.3.0, GNU ld (GNU Binutils for Ubuntu) 2.36.1) #263 SMP Thu Jul 29 17:56:12 AEST 2021
enter ? for help
[c00000001599f860] c0000000001e45f8 kvmppc_pseries_do_hcall+0x5d8/0x2190
[c00000001599f8f0] c0000000001ea2dc kvmppc_vcpu_run_hv+0x31c/0x14d0
[c00000001599f9c0] c0000000001bd518 kvmppc_vcpu_run+0x48/0x60
[c00000001599f9f0] c0000000001b74b0 kvm_arch_vcpu_ioctl_run+0x580/0x7d0
[c00000001599fa90] c00000000019e6f8 kvm_vcpu_ioctl+0x418/0xd00
[c00000001599fc70] c00000000079d8c4 sys_ioctl+0xb44/0x2100
[c00000001599fd90] c00000000003b704 system_call_exception+0x224/0x410
[c00000001599fe10] c00000000000c0e8 system_call_vectored_common+0xe8/0x278



---
 arch/powerpc/platforms/powernv/rng.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/platforms/powernv/rng.c b/arch/powerpc/platforms/powernv/rng.c
index 72c25295c1c2..070d0963995d 100644
--- a/arch/powerpc/platforms/powernv/rng.c
+++ b/arch/powerpc/platforms/powernv/rng.c
@@ -105,6 +105,8 @@ int powernv_get_random_long(unsigned long *v)
 	struct powernv_rng *rng;
 
 	rng = get_cpu_var(powernv_rng);
+	if (!rng || !rng->regs)
+		return 0;
 
 	*v = rng_whiten(rng, in_be64(rng->regs));
 
-- 
2.30.2

