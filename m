Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEBE0C04AA
	for <lists+kvm-ppc@lfdr.de>; Fri, 27 Sep 2019 13:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbfI0Lxz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 27 Sep 2019 07:53:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26354 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727138AbfI0Lxz (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 27 Sep 2019 07:53:55 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8RBknsU116561
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Sep 2019 07:53:52 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v9gjfav0r-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Sep 2019 07:53:52 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <groug@kaod.org>;
        Fri, 27 Sep 2019 12:53:49 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 27 Sep 2019 12:53:45 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8RBriqs26804264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Sep 2019 11:53:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8678E52050;
        Fri, 27 Sep 2019 11:53:44 +0000 (GMT)
Received: from bahia.lan (unknown [9.145.172.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 21A645204E;
        Fri, 27 Sep 2019 11:53:44 +0000 (GMT)
Subject: [PATCH v2 2/6] KVM: PPC: Book3S HV: XIVE: Ensure VP isn't already
 in use
From:   Greg Kurz <groug@kaod.org>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?utf-8?q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?b?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Date:   Fri, 27 Sep 2019 13:53:43 +0200
In-Reply-To: <156958521220.1503771.2119482814236775333.stgit@bahia.lan>
References: <156958521220.1503771.2119482814236775333.stgit@bahia.lan>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19092711-0008-0000-0000-0000031BA63F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19092711-0009-0000-0000-00004A3A4572
Message-Id: <156958522381.1503771.12331024889520676681.stgit@bahia.lan>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-27_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=850 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909270112
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Connecting a vCPU to a XIVE KVM device means establishing a 1:1
association between a vCPU id and the offset (VP id) of a VP
structure within a fixed size block of VPs. We currently try to
enforce the 1:1 relationship by checking that a vCPU with the
same id isn't already connected. This is good but unfortunately
not enough because we don't map VP ids to raw vCPU ids but to
packed vCPU ids, and the packing function kvmppc_pack_vcpu_id()
isn't bijective by design. We got away with it because QEMU passes
vCPU ids that fit well in the packing pattern. But nothing prevents
userspace to come up with a forged vCPU id resulting in a packed id
collision which causes the KVM device to associate two vCPUs to the
same VP. This greatly confuses the irq layer and ultimately crashes
the kernel, as shown below.

Example: a guest with 1 guest thread per core, a core stride of
8 and 300 vCPUs has vCPU ids 0,8,16...2392. If QEMU is patched to
inject at some point an invalid vCPU id 348, which is the packed
version of itself and 2392, we get:

genirq: Flags mismatch irq 199. 00010000 (kvm-2-2392) vs. 00010000 (kvm-2-348)
CPU: 24 PID: 88176 Comm: qemu-system-ppc Not tainted 5.3.0-xive-nr-servers-5.3-gku+ #38
Call Trace:
[c000003f7f9937e0] [c000000000c0110c] dump_stack+0xb0/0xf4 (unreliable)
[c000003f7f993820] [c0000000001cb480] __setup_irq+0xa70/0xad0
[c000003f7f9938d0] [c0000000001cb75c] request_threaded_irq+0x13c/0x260
[c000003f7f993940] [c00800000d44e7ac] kvmppc_xive_attach_escalation+0x104/0x270 [kvm]
[c000003f7f9939d0] [c00800000d45013c] kvmppc_xive_connect_vcpu+0x424/0x620 [kvm]
[c000003f7f993ac0] [c00800000d444428] kvm_arch_vcpu_ioctl+0x260/0x448 [kvm]
[c000003f7f993b90] [c00800000d43593c] kvm_vcpu_ioctl+0x154/0x7c8 [kvm]
[c000003f7f993d00] [c0000000004840f0] do_vfs_ioctl+0xe0/0xc30
[c000003f7f993db0] [c000000000484d44] ksys_ioctl+0x104/0x120
[c000003f7f993e00] [c000000000484d88] sys_ioctl+0x28/0x80
[c000003f7f993e20] [c00000000000b278] system_call+0x5c/0x68
xive-kvm: Failed to request escalation interrupt for queue 0 of VCPU 2392
------------[ cut here ]------------
remove_proc_entry: removing non-empty directory 'irq/199', leaking at least 'kvm-2-348'
WARNING: CPU: 24 PID: 88176 at /home/greg/Work/linux/kernel-kvm-ppc/fs/proc/generic.c:684 remove_proc_entry+0x1ec/0x200
Modules linked in: kvm_hv kvm dm_mod vhost_net vhost tap xt_CHECKSUM iptable_mangle xt_MASQUERADE iptable_nat nf_nat xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 tun bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter squashfs loop fuse i2c_dev sg ofpart ocxl powernv_flash at24 xts mtd uio_pdrv_genirq vmx_crypto opal_prd ipmi_powernv uio ipmi_devintf ipmi_msghandler ibmpowernv ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ip_tables ext4 mbcache jbd2 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq libcrc32c raid1 raid0 linear sd_mod ast i2c_algo_bit drm_vram_helper ttm drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm ahci libahci libata tg3 drm_panel_orientation_quirks [last unloaded: kvm]
CPU: 24 PID: 88176 Comm: qemu-system-ppc Not tainted 5.3.0-xive-nr-servers-5.3-gku+ #38
NIP:  c00000000053b0cc LR: c00000000053b0c8 CTR: c0000000000ba3b0
REGS: c000003f7f9934b0 TRAP: 0700   Not tainted  (5.3.0-xive-nr-servers-5.3-gku+)
MSR:  9000000000029033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 48228222  XER: 20040000
CFAR: c000000000131a50 IRQMASK: 0
GPR00: c00000000053b0c8 c000003f7f993740 c0000000015ec500 0000000000000057
GPR04: 0000000000000001 0000000000000000 000049fb98484262 0000000000001bcf
GPR08: 0000000000000007 0000000000000007 0000000000000001 9000000000001033
GPR12: 0000000000008000 c000003ffffeb800 0000000000000000 000000012f4ce5a1
GPR16: 000000012ef5a0c8 0000000000000000 000000012f113bb0 0000000000000000
GPR20: 000000012f45d918 c000003f863758b0 c000003f86375870 0000000000000006
GPR24: c000003f86375a30 0000000000000007 c0002039373d9020 c0000000014c4a48
GPR28: 0000000000000001 c000003fe62a4f6b c00020394b2e9fab c000003fe62a4ec0
NIP [c00000000053b0cc] remove_proc_entry+0x1ec/0x200
LR [c00000000053b0c8] remove_proc_entry+0x1e8/0x200
Call Trace:
[c000003f7f993740] [c00000000053b0c8] remove_proc_entry+0x1e8/0x200 (unreliable)
[c000003f7f9937e0] [c0000000001d3654] unregister_irq_proc+0x114/0x150
[c000003f7f993880] [c0000000001c6284] free_desc+0x54/0xb0
[c000003f7f9938c0] [c0000000001c65ec] irq_free_descs+0xac/0x100
[c000003f7f993910] [c0000000001d1ff8] irq_dispose_mapping+0x68/0x80
[c000003f7f993940] [c00800000d44e8a4] kvmppc_xive_attach_escalation+0x1fc/0x270 [kvm]
[c000003f7f9939d0] [c00800000d45013c] kvmppc_xive_connect_vcpu+0x424/0x620 [kvm]
[c000003f7f993ac0] [c00800000d444428] kvm_arch_vcpu_ioctl+0x260/0x448 [kvm]
[c000003f7f993b90] [c00800000d43593c] kvm_vcpu_ioctl+0x154/0x7c8 [kvm]
[c000003f7f993d00] [c0000000004840f0] do_vfs_ioctl+0xe0/0xc30
[c000003f7f993db0] [c000000000484d44] ksys_ioctl+0x104/0x120
[c000003f7f993e00] [c000000000484d88] sys_ioctl+0x28/0x80
[c000003f7f993e20] [c00000000000b278] system_call+0x5c/0x68
Instruction dump:
2c230000 41820008 3923ff78 e8e900a0 3c82ff69 3c62ff8d 7fa6eb78 7fc5f378
3884f080 3863b948 4bbf6925 60000000 <0fe00000> 4bffff7c fba10088 4bbf6e41
---[ end trace b925b67a74a1d8d1 ]---
BUG: Kernel NULL pointer dereference at 0x00000010
Faulting instruction address: 0xc00800000d44fc04
Oops: Kernel access of bad area, sig: 11 [#1]
LE PAGE_SIZE=64K MMU=Radix MMU=Hash SMP NR_CPUS=2048 NUMA PowerNV
Modules linked in: kvm_hv kvm dm_mod vhost_net vhost tap xt_CHECKSUM iptable_mangle xt_MASQUERADE iptable_nat nf_nat xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 tun bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter squashfs loop fuse i2c_dev sg ofpart ocxl powernv_flash at24 xts mtd uio_pdrv_genirq vmx_crypto opal_prd ipmi_powernv uio ipmi_devintf ipmi_msghandler ibmpowernv ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ip_tables ext4 mbcache jbd2 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq libcrc32c raid1 raid0 linear sd_mod ast i2c_algo_bit drm_vram_helper ttm drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm ahci libahci libata tg3 drm_panel_orientation_quirks [last unloaded: kvm]
CPU: 24 PID: 88176 Comm: qemu-system-ppc Tainted: G        W         5.3.0-xive-nr-servers-5.3-gku+ #38
NIP:  c00800000d44fc04 LR: c00800000d44fc00 CTR: c0000000001cd970
REGS: c000003f7f9938e0 TRAP: 0300   Tainted: G        W          (5.3.0-xive-nr-servers-5.3-gku+)
MSR:  9000000000009033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 24228882  XER: 20040000
CFAR: c0000000001cd9ac DAR: 0000000000000010 DSISR: 40000000 IRQMASK: 0
GPR00: c00800000d44fc00 c000003f7f993b70 c00800000d468300 0000000000000000
GPR04: 00000000000000c7 0000000000000000 0000000000000000 c000003ffacd06d8
GPR08: 0000000000000000 c000003ffacd0738 0000000000000000 fffffffffffffffd
GPR12: 0000000000000040 c000003ffffeb800 0000000000000000 000000012f4ce5a1
GPR16: 000000012ef5a0c8 0000000000000000 000000012f113bb0 0000000000000000
GPR20: 000000012f45d918 00007ffffe0d9a80 000000012f4f5df0 000000012ef8c9f8
GPR24: 0000000000000001 0000000000000000 c000003fe4501ed0 c000003f8b1d0000
GPR28: c0000033314689c0 c000003fe4501c00 c000003fe4501e70 c000003fe4501e90
NIP [c00800000d44fc04] kvmppc_xive_cleanup_vcpu+0xfc/0x210 [kvm]
LR [c00800000d44fc00] kvmppc_xive_cleanup_vcpu+0xf8/0x210 [kvm]
Call Trace:
[c000003f7f993b70] [c00800000d44fc00] kvmppc_xive_cleanup_vcpu+0xf8/0x210 [kvm] (unreliable)
[c000003f7f993bd0] [c00800000d450bd4] kvmppc_xive_release+0xdc/0x1b0 [kvm]
[c000003f7f993c30] [c00800000d436a98] kvm_device_release+0xb0/0x110 [kvm]
[c000003f7f993c70] [c00000000046730c] __fput+0xec/0x320
[c000003f7f993cd0] [c000000000164ae0] task_work_run+0x150/0x1c0
[c000003f7f993d30] [c000000000025034] do_notify_resume+0x304/0x440
[c000003f7f993e20] [c00000000000dcc4] ret_from_except_lite+0x70/0x74
Instruction dump:
3bff0008 7fbfd040 419e0054 847e0004 2fa30000 419effec e93d0000 8929203c
2f890000 419effb8 4800821d e8410018 <e9230010> e9490008 9b2a0039 7c0004ac
---[ end trace b925b67a74a1d8d2 ]---

Kernel panic - not syncing: Fatal exception

This affects both XIVE and XICS-on-XIVE devices since the beginning.

Check the VP id instead of the vCPU id when a new vCPU is connected.
The allocation of the XIVE CPU structure in kvmppc_xive_connect_vcpu()
is moved after the check to avoid the need for rollback.

Cc: stable@vger.kernel.org # v4.12+
Signed-off-by: Greg Kurz <groug@kaod.org>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
---
v2: - more detailed changelog
---
 arch/powerpc/kvm/book3s_xive.c        |   24 ++++++++++++++++--------
 arch/powerpc/kvm/book3s_xive.h        |   12 ++++++++++++
 arch/powerpc/kvm/book3s_xive_native.c |    6 ++++--
 3 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index 99884662facb..baa740815b3c 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -1217,6 +1217,7 @@ int kvmppc_xive_connect_vcpu(struct kvm_device *dev,
 	struct kvmppc_xive *xive = dev->private;
 	struct kvmppc_xive_vcpu *xc;
 	int i, r = -EBUSY;
+	u32 vp_id;
 
 	pr_devel("connect_vcpu(cpu=%d)\n", cpu);
 
@@ -1228,25 +1229,32 @@ int kvmppc_xive_connect_vcpu(struct kvm_device *dev,
 		return -EPERM;
 	if (vcpu->arch.irq_type != KVMPPC_IRQ_DEFAULT)
 		return -EBUSY;
-	if (kvmppc_xive_find_server(vcpu->kvm, cpu)) {
-		pr_devel("Duplicate !\n");
-		return -EEXIST;
-	}
 	if (cpu >= (KVM_MAX_VCPUS * vcpu->kvm->arch.emul_smt_mode)) {
 		pr_devel("Out of bounds !\n");
 		return -EINVAL;
 	}
-	xc = kzalloc(sizeof(*xc), GFP_KERNEL);
-	if (!xc)
-		return -ENOMEM;
 
 	/* We need to synchronize with queue provisioning */
 	mutex_lock(&xive->lock);
+
+	vp_id = kvmppc_xive_vp(xive, cpu);
+	if (kvmppc_xive_vp_in_use(xive->kvm, vp_id)) {
+		pr_devel("Duplicate !\n");
+		r = -EEXIST;
+		goto bail;
+	}
+
+	xc = kzalloc(sizeof(*xc), GFP_KERNEL);
+	if (!xc) {
+		r = -ENOMEM;
+		goto bail;
+	}
+
 	vcpu->arch.xive_vcpu = xc;
 	xc->xive = xive;
 	xc->vcpu = vcpu;
 	xc->server_num = cpu;
-	xc->vp_id = kvmppc_xive_vp(xive, cpu);
+	xc->vp_id = vp_id;
 	xc->mfrr = 0xff;
 	xc->valid = true;
 
diff --git a/arch/powerpc/kvm/book3s_xive.h b/arch/powerpc/kvm/book3s_xive.h
index 955b820ffd6d..fe3ed50e0818 100644
--- a/arch/powerpc/kvm/book3s_xive.h
+++ b/arch/powerpc/kvm/book3s_xive.h
@@ -220,6 +220,18 @@ static inline u32 kvmppc_xive_vp(struct kvmppc_xive *xive, u32 server)
 	return xive->vp_base + kvmppc_pack_vcpu_id(xive->kvm, server);
 }
 
+static inline bool kvmppc_xive_vp_in_use(struct kvm *kvm, u32 vp_id)
+{
+	struct kvm_vcpu *vcpu = NULL;
+	int i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (vcpu->arch.xive_vcpu && vp_id == vcpu->arch.xive_vcpu->vp_id)
+			return true;
+	}
+	return false;
+}
+
 /*
  * Mapping between guest priorities and host priorities
  * is as follow.
diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index 6b91c74839d5..ebb4215baf45 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -106,6 +106,7 @@ int kvmppc_xive_native_connect_vcpu(struct kvm_device *dev,
 	struct kvmppc_xive *xive = dev->private;
 	struct kvmppc_xive_vcpu *xc = NULL;
 	int rc;
+	u32 vp_id;
 
 	pr_devel("native_connect_vcpu(server=%d)\n", server_num);
 
@@ -124,7 +125,8 @@ int kvmppc_xive_native_connect_vcpu(struct kvm_device *dev,
 
 	mutex_lock(&xive->lock);
 
-	if (kvmppc_xive_find_server(vcpu->kvm, server_num)) {
+	vp_id = kvmppc_xive_vp(xive, server_num);
+	if (kvmppc_xive_vp_in_use(xive->kvm, vp_id)) {
 		pr_devel("Duplicate !\n");
 		rc = -EEXIST;
 		goto bail;
@@ -141,7 +143,7 @@ int kvmppc_xive_native_connect_vcpu(struct kvm_device *dev,
 	xc->vcpu = vcpu;
 	xc->server_num = server_num;
 
-	xc->vp_id = kvmppc_xive_vp(xive, server_num);
+	xc->vp_id = vp_id;
 	xc->valid = true;
 	vcpu->arch.irq_type = KVMPPC_IRQ_XIVE;
 

