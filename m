Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E252715C132
	for <lists+kvm-ppc@lfdr.de>; Thu, 13 Feb 2020 16:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgBMPQs (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 13 Feb 2020 10:16:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35396 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725781AbgBMPQs (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 13 Feb 2020 10:16:48 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01DF0Kdu086762;
        Thu, 13 Feb 2020 10:16:36 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y4j87jdvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Feb 2020 10:16:36 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01DFBwjX009980;
        Thu, 13 Feb 2020 15:16:35 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 2y1mm8q647-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Feb 2020 15:16:35 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01DFGYqX13959984
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 15:16:34 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6ABDE112063;
        Thu, 13 Feb 2020 15:16:34 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1427B112062;
        Thu, 13 Feb 2020 15:16:34 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.41.166.54])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 13 Feb 2020 15:16:33 +0000 (GMT)
From:   Gustavo Romero <gromero@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org, paulus@ozlabs.org
Cc:     gromero@linux.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] KVM: PPC: Book3S HV: Treat unrecognized TM instructions as illegal
Date:   Thu, 13 Feb 2020 10:15:32 -0500
Message-Id: <20200213151532.12559-1-gromero@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-13_05:2020-02-12,2020-02-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=978
 impostorscore=0 priorityscore=1501 spamscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 clxscore=1011 lowpriorityscore=0
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002130119
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On P9 DD2.2 due to a CPU defect some TM instructions need to be emulated by
KVM. This is handled at first by the hardware raising a softpatch interrupt
when certain TM instructions that need KVM assistance are executed in the
guest. Some TM instructions, although not defined in the Power ISA, might
raise a softpatch interrupt. For instance, 'tresume.' instruction as
defined in the ISA must have bit 31 set (1), but an instruction that
matches 'tresume.' OP and XO opcodes but has bit 31 not set (0), like
0x7cfe9ddc, also raises a softpatch interrupt, for example, if a code
like the following is executed in the guest it will raise a softpatch
interrupt just like a 'tresume.' when the TM facility is enabled:

int main() { asm("tabort. 0; .long 0x7cfe9ddc;"); }

Currently in such a case KVM throws a complete trace like the following:

[345523.705984] WARNING: CPU: 24 PID: 64413 at arch/powerpc/kvm/book3s_hv_tm.c:211 kvmhv_p9_tm_emulation+0x68/0x620 [kvm_hv]
[345523.705985] Modules linked in: kvm_hv(E) xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp ip6table_mangle ip6table_nat
iptable_mangle iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ebtable_filter ebtables ip6table_filter
ip6_tables iptable_filter bridge stp llc sch_fq_codel ipmi_powernv at24 vmx_crypto ipmi_devintf ipmi_msghandler
ibmpowernv uio_pdrv_genirq kvm opal_prd uio leds_powernv ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp
libiscsi scsi_transport_iscsi ip_tables x_tables autofs4 btrfs blake2b_generic zstd_compress raid10 raid456
async_raid6_recov async_memcpy async_pq async_xor async_tx libcrc32c xor raid6_pq raid1 raid0 multipath linear tg3
crct10dif_vpmsum crc32c_vpmsum ipr [last unloaded: kvm_hv]
[345523.706030] CPU: 24 PID: 64413 Comm: CPU 0/KVM Tainted: G        W   E     5.5.0+ #1
[345523.706031] NIP:  c0080000072cb9c0 LR: c0080000072b5e80 CTR: c0080000085c7850
[345523.706034] REGS: c000000399467680 TRAP: 0700   Tainted: G        W   E      (5.5.0+)
[345523.706034] MSR:  900000010282b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE,TM[E]>  CR: 24022428  XER: 00000000
[345523.706042] CFAR: c0080000072b5e7c IRQMASK: 0
                GPR00: c0080000072b5e80 c000000399467910 c0080000072db500 c000000375ccc720
                GPR04: c000000375ccc720 00000003fbec0000 0000a10395dda5a6 0000000000000000
                GPR08: 000000007cfe9ddc 7cfe9ddc000005dc 7cfe9ddc7c0005dc c0080000072cd530
                GPR12: c0080000085c7850 c0000003fffeb800 0000000000000001 00007dfb737f0000
                GPR16: c0002001edcca558 0000000000000000 0000000000000000 0000000000000001
                GPR20: c000000001b21258 c0002001edcca558 0000000000000018 0000000000000000
                GPR24: 0000000001000000 ffffffffffffffff 0000000000000001 0000000000001500
                GPR28: c0002001edcc4278 c00000037dd80000 800000050280f033 c000000375ccc720
[345523.706062] NIP [c0080000072cb9c0] kvmhv_p9_tm_emulation+0x68/0x620 [kvm_hv]
[345523.706065] LR [c0080000072b5e80] kvmppc_handle_exit_hv.isra.53+0x3e8/0x798 [kvm_hv]
[345523.706066] Call Trace:
[345523.706069] [c000000399467910] [c000000399467940] 0xc000000399467940 (unreliable)
[345523.706071] [c000000399467950] [c000000399467980] 0xc000000399467980
[345523.706075] [c0000003994679f0] [c0080000072bd1c4] kvmhv_run_single_vcpu+0xa1c/0xb80 [kvm_hv]
[345523.706079] [c000000399467ac0] [c0080000072bd8e0] kvmppc_vcpu_run_hv+0x5b8/0xb00 [kvm_hv]
[345523.706087] [c000000399467b90] [c0080000085c93cc] kvmppc_vcpu_run+0x34/0x48 [kvm]
[345523.706095] [c000000399467bb0] [c0080000085c582c] kvm_arch_vcpu_ioctl_run+0x244/0x420 [kvm]
[345523.706101] [c000000399467c40] [c0080000085b7498] kvm_vcpu_ioctl+0x3d0/0x7b0 [kvm]
[345523.706105] [c000000399467db0] [c0000000004adf9c] ksys_ioctl+0x13c/0x170
[345523.706107] [c000000399467e00] [c0000000004adff8] sys_ioctl+0x28/0x80
[345523.706111] [c000000399467e20] [c00000000000b278] system_call+0x5c/0x68
[345523.706112] Instruction dump:
[345523.706114] 419e0390 7f8a4840 409d0048 6d497c00 2f89075d 419e021c 6d497c00 2f8907dd
[345523.706119] 419e01c0 6d497c00 2f8905dd 419e00a4 <0fe00000> 38210040 38600000 ebc1fff0

and then treats the executed instruction as 'nop' whilst it should actually
be treated as an illegal instruction since it's not defined by the ISA.

This commit changes the handling of the case above by treating the
unrecognized TM instructions that can raise a softpatch but are not
defined in the ISA as illegal ones instead of as 'nop' and by gently
reporting it to the host instead of throwing a trace.

Signed-off-by: Gustavo Romero <gromero@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv_tm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_tm.c b/arch/powerpc/kvm/book3s_hv_tm.c
index 0db937497169..d342a9e11298 100644
--- a/arch/powerpc/kvm/book3s_hv_tm.c
+++ b/arch/powerpc/kvm/book3s_hv_tm.c
@@ -3,6 +3,8 @@
  * Copyright 2017 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_ppc.h>
@@ -208,6 +210,8 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 	}
 
 	/* What should we do here? We didn't recognize the instruction */
-	WARN_ON_ONCE(1);
+	kvmppc_core_queue_program(vcpu, SRR1_PROGILL);
+	pr_warn_ratelimited("Unrecognized TM-related instruction %#x for emulation", instr);
+
 	return RESUME_GUEST;
 }
-- 
2.17.1

