Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 433E718A1DF
	for <lists+kvm-ppc@lfdr.de>; Wed, 18 Mar 2020 18:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgCRRni (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 18 Mar 2020 13:43:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61072 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726821AbgCRRni (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 18 Mar 2020 13:43:38 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02IHXXrv065553
        for <kvm-ppc@vger.kernel.org>; Wed, 18 Mar 2020 13:43:36 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yu96f8de1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Wed, 18 Mar 2020 13:43:36 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <groug@kaod.org>;
        Wed, 18 Mar 2020 17:43:34 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Mar 2020 17:43:32 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02IHhVuo36175996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 17:43:31 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58434AE045;
        Wed, 18 Mar 2020 17:43:31 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 116C6AE04D;
        Wed, 18 Mar 2020 17:43:31 +0000 (GMT)
Received: from bahia.lan (unknown [9.145.41.106])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Mar 2020 17:43:30 +0000 (GMT)
Subject: [PATCH 1/3] KVM: PPC: Fix kernel crash with PR KVM
From:   Greg Kurz <groug@kaod.org>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date:   Wed, 18 Mar 2020 18:43:30 +0100
In-Reply-To: <158455340419.178873.11399595021669446372.stgit@bahia.lan>
References: <158455340419.178873.11399595021669446372.stgit@bahia.lan>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20031817-0020-0000-0000-000003B6A11D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031817-0021-0000-0000-0000220F0BC4
Message-Id: <158455341029.178873.15248663726399374882.stgit@bahia.lan>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_07:2020-03-18,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 suspectscore=2 adultscore=0 priorityscore=1501 spamscore=0
 phishscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1034
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003180076
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

With PR KVM, shutting down a VM causes the host kernel to crash:

[  314.219284] BUG: Unable to handle kernel data access on read at 0xc00800000176c638
[  314.219299] Faulting instruction address: 0xc008000000d4ddb0
cpu 0x0: Vector: 300 (Data Access) at [c00000036da077a0]
    pc: c008000000d4ddb0: kvmppc_mmu_pte_flush_all+0x68/0xd0 [kvm_pr]
    lr: c008000000d4dd94: kvmppc_mmu_pte_flush_all+0x4c/0xd0 [kvm_pr]
    sp: c00000036da07a30
   msr: 900000010280b033
   dar: c00800000176c638
 dsisr: 40000000
  current = 0xc00000036d4c0000
  paca    = 0xc000000001a00000   irqmask: 0x03   irq_happened: 0x01
    pid   = 1992, comm = qemu-system-ppc
Linux version 5.6.0-master-gku+ (greg@palmb) (gcc version 7.5.0 (Ubuntu 7.5.0-3ubuntu1~18.04)) #17 SMP Wed Mar 18 13:49:29 CET 2020
enter ? for help
[c00000036da07ab0] c008000000d4fbe0 kvmppc_mmu_destroy_pr+0x28/0x60 [kvm_pr]
[c00000036da07ae0] c0080000009eab8c kvmppc_mmu_destroy+0x34/0x50 [kvm]
[c00000036da07b00] c0080000009e50c0 kvm_arch_vcpu_destroy+0x108/0x140 [kvm]
[c00000036da07b30] c0080000009d1b50 kvm_vcpu_destroy+0x28/0x80 [kvm]
[c00000036da07b60] c0080000009e4434 kvm_arch_destroy_vm+0xbc/0x190 [kvm]
[c00000036da07ba0] c0080000009d9c2c kvm_put_kvm+0x1d4/0x3f0 [kvm]
[c00000036da07c00] c0080000009da760 kvm_vm_release+0x38/0x60 [kvm]
[c00000036da07c30] c000000000420be0 __fput+0xe0/0x310
[c00000036da07c90] c0000000001747a0 task_work_run+0x150/0x1c0
[c00000036da07cf0] c00000000014896c do_exit+0x44c/0xd00
[c00000036da07dc0] c0000000001492f4 do_group_exit+0x64/0xd0
[c00000036da07e00] c000000000149384 sys_exit_group+0x24/0x30
[c00000036da07e20] c00000000000b9d0 system_call+0x5c/0x68

This is caused by a use-after-free in kvmppc_mmu_pte_flush_all()
which dereferences vcpu->arch.book3s which was previously freed by
kvmppc_core_vcpu_free_pr(). This happens because kvmppc_mmu_destroy()
is called after kvmppc_core_vcpu_free() since commit ff030fdf5573
("KVM: PPC: Move kvm_vcpu_init() invocation to common code").

The kvmppc_mmu_destroy() helper calls one of the following depending
on the KVM backend:

- kvmppc_mmu_destroy_hv() which does nothing (Book3s HV)

- kvmppc_mmu_destroy_pr() which undoes the effects of
  kvmppc_mmu_init() (Book3s PR 32-bit)

- kvmppc_mmu_destroy_pr() which undoes the effects of
  kvmppc_mmu_init() (Book3s PR 64-bit)

- kvmppc_mmu_destroy_e500() which does nothing (BookE e500/e500mc)

It turns out that this is only relevant to PR KVM actually. And both
32 and 64 backends need vcpu->arch.book3s to be valid when calling
kvmppc_mmu_destroy_pr(). So instead of calling kvmppc_mmu_destroy()
from kvm_arch_vcpu_destroy(), call kvmppc_mmu_destroy_pr() at the
beginning of kvmppc_core_vcpu_free_pr(). This is consistent with
kvmppc_mmu_init() being the last call in kvmppc_core_vcpu_create_pr().

For the same reason, if kvmppc_core_vcpu_create_pr() returns an
error then this means that kvmppc_mmu_init() was either not called
or failed, in which case kvmppc_mmu_destroy() should not be called.
Drop the line in the error path of kvm_arch_vcpu_create().

Fixes: ff030fdf5573 ("KVM: PPC: Move kvm_vcpu_init() invocation to common code")
Signed-off-by: Greg Kurz <groug@kaod.org>
---
 arch/powerpc/kvm/book3s_pr.c |    1 +
 arch/powerpc/kvm/powerpc.c   |    2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 729a0f12a752..db3a87319642 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1817,6 +1817,7 @@ static void kvmppc_core_vcpu_free_pr(struct kvm_vcpu *vcpu)
 {
 	struct kvmppc_vcpu_book3s *vcpu_book3s = to_book3s(vcpu);
 
+	kvmppc_mmu_destroy_pr(vcpu);
 	free_page((unsigned long)vcpu->arch.shared & PAGE_MASK);
 #ifdef CONFIG_KVM_BOOK3S_32_HANDLER
 	kfree(vcpu->arch.shadow_vcpu);
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 1af96fb5dc6f..302e9dccdd6d 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -759,7 +759,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	return 0;
 
 out_vcpu_uninit:
-	kvmppc_mmu_destroy(vcpu);
 	kvmppc_subarch_vcpu_uninit(vcpu);
 	return err;
 }
@@ -792,7 +791,6 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 	kvmppc_core_vcpu_free(vcpu);
 
-	kvmppc_mmu_destroy(vcpu);
 	kvmppc_subarch_vcpu_uninit(vcpu);
 }
 

