Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148F9299E13
	for <lists+kvm-ppc@lfdr.de>; Tue, 27 Oct 2020 01:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411833AbgJ0ALw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 26 Oct 2020 20:11:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439295AbgJ0ALw (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 26 Oct 2020 20:11:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4D4B2151B;
        Tue, 27 Oct 2020 00:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757510;
        bh=hP7h/RRUoYHzprBdN0Vj4BtVDcb9zPDb6kdxUZX5yRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXe+4/eJueNx1rdYzZkiXeBeeZ7Y+pa/opJ6CxKKFSasonr6zkRUmEMkmNGhTdsKo
         HRLRMzHD2BrUJOsXi1q5XHNNsZOBoygaYv4IM9cCmxLrU3bcbivGucDKydDy17/TxQ
         FTpKPMd7dpygRDjHlv6w7a/AA7kDhLpVPNPyDm5A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabiano Rosas <farosas@linux.ibm.com>,
        Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>,
        Greg Kurz <groug@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.4 21/25] KVM: PPC: Book3S HV: Do not allocate HPT for a nested guest
Date:   Mon, 26 Oct 2020 20:11:19 -0400
Message-Id: <20201027001123.1027642-21-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027001123.1027642-1-sashal@kernel.org>
References: <20201027001123.1027642-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Fabiano Rosas <farosas@linux.ibm.com>

[ Upstream commit 05e6295dc7de859c9d56334805485c4d20bebf25 ]

The current nested KVM code does not support HPT guests. This is
informed/enforced in some ways:

- Hosts < P9 will not be able to enable the nested HV feature;

- The nested hypervisor MMU capabilities will not contain
  KVM_CAP_PPC_MMU_HASH_V3;

- QEMU reflects the MMU capabilities in the
  'ibm,arch-vec-5-platform-support' device-tree property;

- The nested guest, at 'prom_parse_mmu_model' ignores the
  'disable_radix' kernel command line option if HPT is not supported;

- The KVM_PPC_CONFIGURE_V3_MMU ioctl will fail if trying to use HPT.

There is, however, still a way to start a HPT guest by using
max-compat-cpu=power8 at the QEMU machine options. This leads to the
guest being set to use hash after QEMU calls the KVM_PPC_ALLOCATE_HTAB
ioctl.

With the guest set to hash, the nested hypervisor goes through the
entry path that has no knowledge of nesting (kvmppc_run_vcpu) and
crashes when it tries to execute an hypervisor-privileged (mtspr
HDEC) instruction at __kvmppc_vcore_entry:

root@L1:~ $ qemu-system-ppc64 -machine pseries,max-cpu-compat=power8 ...

<snip>
[  538.543303] CPU: 83 PID: 25185 Comm: CPU 0/KVM Not tainted 5.9.0-rc4 #1
[  538.543355] NIP:  c00800000753f388 LR: c00800000753f368 CTR: c0000000001e5ec0
[  538.543417] REGS: c0000013e91e33b0 TRAP: 0700   Not tainted  (5.9.0-rc4)
[  538.543470] MSR:  8000000002843033 <SF,VEC,VSX,FP,ME,IR,DR,RI,LE>  CR: 22422882  XER: 20040000
[  538.543546] CFAR: c00800000753f4b0 IRQMASK: 3
               GPR00: c0080000075397a0 c0000013e91e3640 c00800000755e600 0000000080000000
               GPR04: 0000000000000000 c0000013eab19800 c000001394de0000 00000043a054db72
               GPR08: 00000000003b1652 0000000000000000 0000000000000000 c0080000075502e0
               GPR12: c0000000001e5ec0 c0000007ffa74200 c0000013eab19800 0000000000000008
               GPR16: 0000000000000000 c00000139676c6c0 c000000001d23948 c0000013e91e38b8
               GPR20: 0000000000000053 0000000000000000 0000000000000001 0000000000000000
               GPR24: 0000000000000001 0000000000000001 0000000000000000 0000000000000001
               GPR28: 0000000000000001 0000000000000053 c0000013eab19800 0000000000000001
[  538.544067] NIP [c00800000753f388] __kvmppc_vcore_entry+0x90/0x104 [kvm_hv]
[  538.544121] LR [c00800000753f368] __kvmppc_vcore_entry+0x70/0x104 [kvm_hv]
[  538.544173] Call Trace:
[  538.544196] [c0000013e91e3640] [c0000013e91e3680] 0xc0000013e91e3680 (unreliable)
[  538.544260] [c0000013e91e3820] [c0080000075397a0] kvmppc_run_core+0xbc8/0x19d0 [kvm_hv]
[  538.544325] [c0000013e91e39e0] [c00800000753d99c] kvmppc_vcpu_run_hv+0x404/0xc00 [kvm_hv]
[  538.544394] [c0000013e91e3ad0] [c0080000072da4fc] kvmppc_vcpu_run+0x34/0x48 [kvm]
[  538.544472] [c0000013e91e3af0] [c0080000072d61b8] kvm_arch_vcpu_ioctl_run+0x310/0x420 [kvm]
[  538.544539] [c0000013e91e3b80] [c0080000072c7450] kvm_vcpu_ioctl+0x298/0x778 [kvm]
[  538.544605] [c0000013e91e3ce0] [c0000000004b8c2c] sys_ioctl+0x1dc/0xc90
[  538.544662] [c0000013e91e3dc0] [c00000000002f9a4] system_call_exception+0xe4/0x1c0
[  538.544726] [c0000013e91e3e20] [c00000000000d140] system_call_common+0xf0/0x27c
[  538.544787] Instruction dump:
[  538.544821] f86d1098 60000000 60000000 48000099 e8ad0fe8 e8c500a0 e9264140 75290002
[  538.544886] 7d1602a6 7cec42a6 40820008 7d0807b4 <7d164ba6> 7d083a14 f90d10a0 480104fd
[  538.544953] ---[ end trace 74423e2b948c2e0c ]---

This patch makes the KVM_PPC_ALLOCATE_HTAB ioctl fail when running in
the nested hypervisor, causing QEMU to abort.

Reported-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
Reviewed-by: Greg Kurz <groug@kaod.org>
Reviewed-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 54c6ba87a25ad..b005ce9dc8f04 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3157,6 +3157,12 @@ static long kvm_arch_vm_ioctl_hv(struct file *filp,
 	case KVM_PPC_ALLOCATE_HTAB: {
 		u32 htab_order;
 
+		/* If we're a nested hypervisor, we currently only support radix */
+		if (kvmhv_on_pseries()) {
+			r = -EOPNOTSUPP;
+			break;
+		}
+
 		r = -EFAULT;
 		if (get_user(htab_order, (u32 __user *)argp))
 			break;
-- 
2.25.1

