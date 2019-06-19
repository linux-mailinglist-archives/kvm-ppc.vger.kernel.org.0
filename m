Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9704B8B8
	for <lists+kvm-ppc@lfdr.de>; Wed, 19 Jun 2019 14:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731773AbfFSMgZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 19 Jun 2019 08:36:25 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:53983 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731711AbfFSMgY (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 19 Jun 2019 08:36:24 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 45TPZY50tMz9s7h; Wed, 19 Jun 2019 22:36:21 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: fabb2efcf0846e28b4910fc20bdc203d3d0170af
X-Patchwork-Hint: ignore
In-Reply-To: <20190617071619.19360-2-sjitindarsingh@gmail.com>
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     mikey@neuling.org, clg@kaod.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: PPC: Book3S HV: Fix r3 corruption in h_set_dabr()
Message-Id: <45TPZY50tMz9s7h@ozlabs.org>
Date:   Wed, 19 Jun 2019 22:36:21 +1000 (AEST)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, 2019-06-17 at 07:16:18 UTC, Suraj Jitindar Singh wrote:
> From: Michael Neuling <mikey@neuling.org>
> 
> Commit c1fe190c0672 ("powerpc: Add force enable of DAWR on P9
> option") screwed up some assembler and corrupted a pointer in
> r3. This resulted in crashes like the below:
> 
>   [   44.374746] BUG: Kernel NULL pointer dereference at 0x000013bf
>   [   44.374848] Faulting instruction address: 0xc00000000010b044
>   [   44.374906] Oops: Kernel access of bad area, sig: 11 [#1]
>   [   44.374951] LE PAGE_SIZE=64K MMU=Radix MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
>   [   44.375018] Modules linked in: vhost_net vhost tap xt_CHECKSUM iptable_mangle xt_MASQUERADE iptable_nat nf_nat xt_conntrack nf_conntrack nf_defrag_ipv6 libcrc32c nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 xt_tcpudp bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter bpfilter vmx_crypto crct10dif_vpmsum crc32c_vpmsum kvm_hv kvm sch_fq_codel ip_tables x_tables autofs4 virtio_net net_failover virtio_scsi failover
>   [   44.375401] CPU: 8 PID: 1771 Comm: qemu-system-ppc Kdump: loaded Not tainted 5.2.0-rc4+ #3
>   [   44.375500] NIP:  c00000000010b044 LR: c0080000089dacf4 CTR: c00000000010aff4
>   [   44.375604] REGS: c00000179b397710 TRAP: 0300   Not tainted  (5.2.0-rc4+)
>   [   44.375691] MSR:  800000000280b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 42244842  XER: 00000000
>   [   44.375815] CFAR: c00000000010aff8 DAR: 00000000000013bf DSISR: 42000000 IRQMASK: 0
>   [   44.375815] GPR00: c0080000089dd6bc c00000179b3979a0 c008000008a04300 ffffffffffffffff
>   [   44.375815] GPR04: 0000000000000000 0000000000000003 000000002444b05d c0000017f11c45d0
>   [   44.375815] GPR08: 078000003e018dfe 0000000000000028 0000000000000001 0000000000000075
>   [   44.375815] GPR12: c00000000010aff4 c000000007ff6300 0000000000000000 0000000000000000
>   [   44.375815] GPR16: 0000000000000000 c0000017f11d0000 00000000ffffffff c0000017f11ca7a8
>   [   44.375815] GPR20: c0000017f11c42ec ffffffffffffffff 0000000000000000 000000000000000a
>   [   44.375815] GPR24: fffffffffffffffc 0000000000000000 c0000017f11c0000 c000000001a77ed8
>   [   44.375815] GPR28: c00000179af70000 fffffffffffffffc c0080000089ff170 c00000179ae88540
>   [   44.376673] NIP [c00000000010b044] kvmppc_h_set_dabr+0x50/0x68
>   [   44.376754] LR [c0080000089dacf4] kvmppc_pseries_do_hcall+0xa3c/0xeb0 [kvm_hv]
>   [   44.376849] Call Trace:
>   [   44.376886] [c00000179b3979a0] [c0000017f11c0000] 0xc0000017f11c0000 (unreliable)
>   [   44.376982] [c00000179b397a10] [c0080000089dd6bc] kvmppc_vcpu_run_hv+0x694/0xec0 [kvm_hv]
>   [   44.377084] [c00000179b397ae0] [c0080000093f8bcc] kvmppc_vcpu_run+0x34/0x48 [kvm]
>   [   44.377185] [c00000179b397b00] [c0080000093f522c] kvm_arch_vcpu_ioctl_run+0x2f4/0x400 [kvm]
>   [   44.377286] [c00000179b397b90] [c0080000093e3618] kvm_vcpu_ioctl+0x460/0x850 [kvm]
>   [   44.377384] [c00000179b397d00] [c0000000004ba6c4] do_vfs_ioctl+0xe4/0xb40
>   [   44.377464] [c00000179b397db0] [c0000000004bb1e4] ksys_ioctl+0xc4/0x110
>   [   44.377547] [c00000179b397e00] [c0000000004bb258] sys_ioctl+0x28/0x80
>   [   44.377628] [c00000179b397e20] [c00000000000b888] system_call+0x5c/0x70
>   [   44.377712] Instruction dump:
>   [   44.377765] 4082fff4 4c00012c 38600000 4e800020 e96280c0 896b0000 2c2b0000 3860ffff
>   [   44.377862] 4d820020 50852e74 508516f6 78840724 <f88313c0> f8a313c8 7c942ba6 7cbc2ba6
> 
> Fix the bug by only changing r3 when we are returning immediately.
> 
> Fixes: c1fe190c0672 ("powerpc: Add force enable of DAWR on P9 option")
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> Reported-by: Cédric Le Goater <clg@kaod.org>

Series applied to powerpc fixes, thanks.

https://git.kernel.org/powerpc/c/fabb2efcf0846e28b4910fc20bdc203d3d0170af

cheers
