Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E84233C1B
	for <lists+kvm-ppc@lfdr.de>; Fri, 31 Jul 2020 01:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbgG3X0G (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 30 Jul 2020 19:26:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61832 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730332AbgG3X0F (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 30 Jul 2020 19:26:05 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06UN1nnd050337;
        Thu, 30 Jul 2020 19:25:52 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32m2h1r7fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jul 2020 19:25:52 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06UNPRI6016664;
        Thu, 30 Jul 2020 23:25:50 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 32gcpwc2kk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jul 2020 23:25:50 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06UNPl8s60162292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jul 2020 23:25:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 868D8A405F;
        Thu, 30 Jul 2020 23:25:47 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7ABD0A405B;
        Thu, 30 Jul 2020 23:25:43 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.211.129.132])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Jul 2020 23:25:43 +0000 (GMT)
From:   Ram Pai <linuxram@us.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        bharata@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, ldufour@linux.ibm.com,
        bauerman@linux.ibm.com, david@gibson.dropbear.id.au,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sathnaga@linux.vnet.ibm.com
Subject: [PATCH] KVM: PPC: Book3S HV: fix a oops in kvmppc_uvmem_page_free()
Date:   Thu, 30 Jul 2020 16:25:26 -0700
Message-Id: <1596151526-4374-1-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_18:2020-07-30,2020-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 suspectscore=2
 priorityscore=1501 phishscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007300158
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Observed the following oops while stress-testing, using multiple
secureVM on a distro kernel. However this issue theoritically exists in
5.5 kernel and later.

This issue occurs when the total number of requested device-PFNs exceed
the total-number of available device-PFNs.  PFN migration fails to
allocate a device-pfn, which causes migrate_vma_finalize() to trigger
kvmppc_uvmem_page_free() on a page, that is not associated with any
device-pfn.  kvmppc_uvmem_page_free() blindly tries to access the
contents of the private data which can be null, leading to the following
kernel fault.

 --------------------------------------------------------------------------
 Unable to handle kernel paging request for data at address 0x00000011
 Faulting instruction address: 0xc00800000e36e110
 Oops: Kernel access of bad area, sig: 11 [#1]
 LE SMP NR_CPUS=2048 NUMA PowerNV
....
 MSR:  900000000280b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>
		 CR: 24424822  XER: 00000000
 CFAR: c000000000e3d764 DAR: 0000000000000011 DSISR: 40000000 IRQMASK: 0
 GPR00: c00800000e36e0a4 c000001f1d59f610 c00800000e38a400 0000000000000000
 GPR04: c000001fa5000000 fffffffffffffffe ffffffffffffffff c000201fffeaf300
 GPR08: 00000000000001f0 0000000000000000 0000000000000f80 c00800000e373608
 GPR12: c000000000e3d710 c000201fffeaf300 0000000000000001 00007fef87360000
 GPR16: 00007fff97db4410 c000201c3b66a578 ffffffffffffffff 0000000000000000
 GPR20: 0000000119db9ad0 000000000000000a fffffffffffffffc 0000000000000001
 GPR24: c000201c3b660000 c000001f1d59f7a0 c0000000004cffb0 0000000000000001
 GPR28: 0000000000000000 c00a001ff003e000 c00800000e386150 0000000000000f80
 NIP [c00800000e36e110] kvmppc_uvmem_page_free+0xc8/0x210 [kvm_hv]
 LR [c00800000e36e0a4] kvmppc_uvmem_page_free+0x5c/0x210 [kvm_hv]
 Call Trace:
 [c000000000512010] free_devmap_managed_page+0xd0/0x100
 [c0000000003f71d0] put_devmap_managed_page+0xa0/0xc0
 [c0000000004d24bc] migrate_vma_finalize+0x32c/0x410
 [c00800000e36e828] kvmppc_svm_page_in.constprop.5+0xa0/0x460 [kvm_hv]
 [c00800000e36eddc] kvmppc_uv_migrate_mem_slot.isra.2+0x1f4/0x230 [kvm_hv]
 [c00800000e36fa98] kvmppc_h_svm_init_done+0x90/0x170 [kvm_hv]
 [c00800000e35bb14] kvmppc_pseries_do_hcall+0x1ac/0x10a0 [kvm_hv]
 [c00800000e35edf4] kvmppc_vcpu_run_hv+0x83c/0x1060 [kvm_hv]
 [c00800000e95eb2c] kvmppc_vcpu_run+0x34/0x48 [kvm]
 [c00800000e95a2dc] kvm_arch_vcpu_ioctl_run+0x374/0x830 [kvm]
 [c00800000e9433b4] kvm_vcpu_ioctl+0x45c/0x7c0 [kvm]
 [c0000000005451d0] do_vfs_ioctl+0xe0/0xaa0
 [c000000000545d64] sys_ioctl+0xc4/0x160
 [c00000000000b408] system_call+0x5c/0x70
 Instruction dump:
 a12d1174 2f890000 409e0158 a1271172 3929ffff b1271172 7c2004ac 39200000
 913e0140 39200000 e87d0010 f93d0010 <89230011> e8c30000 e9030008 2f890000
 --------------------------------------------------------------------------

 Fix the oops..

fixes: ca9f49 ("KVM: PPC: Book3S HV: Support for running secure guests")
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 2806983..f4002bf 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -1018,13 +1018,15 @@ static void kvmppc_uvmem_page_free(struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page) -
 			(kvmppc_uvmem_pgmap.res.start >> PAGE_SHIFT);
-	struct kvmppc_uvmem_page_pvt *pvt;
+	struct kvmppc_uvmem_page_pvt *pvt = page->zone_device_data;
+
+	if (!pvt)
+		return;
 
 	spin_lock(&kvmppc_uvmem_bitmap_lock);
 	bitmap_clear(kvmppc_uvmem_bitmap, pfn, 1);
 	spin_unlock(&kvmppc_uvmem_bitmap_lock);
 
-	pvt = page->zone_device_data;
 	page->zone_device_data = NULL;
 	if (pvt->remove_gfn)
 		kvmppc_gfn_remove(pvt->gpa >> PAGE_SHIFT, pvt->kvm);
-- 
1.8.3.1

