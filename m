Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7304635D310
	for <lists+kvm-ppc@lfdr.de>; Tue, 13 Apr 2021 00:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343729AbhDLW1h (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 12 Apr 2021 18:27:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5416 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343698AbhDLW1g (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 12 Apr 2021 18:27:36 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CM4KNW077369;
        Mon, 12 Apr 2021 18:27:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=luum+pxer+WirNEHYuoLeR8uzLoE4JG3p9cQsJmIasA=;
 b=Wg0CPOavJ3uE1n5qX7HblbGliNZ/zg3t9iEtpU1QDxSQ3hecAKGOiuLe4lTubCTfg7kq
 M5H1nlUjzSSVKe7568XFvb1m3WwvQ+4nZ1lFBYfRUTcVp4G3r08i5NhicydcK7XaN8df
 MRMlQZlTFYjJ1OwEmyVslNKFyPNRUyQof6y9lLaXJEH+JLs+Xh4pPfl/9mbHJ8yP5Dey
 kPKr9skN1W2ZJyy9Cl7BjAfUaLGePlXXovI1eQCpVUvqIVOvMd0KZBT0gYXGldd2zfef
 ek5YuLlnZgXlXWNtHv92mugSbcbCeCfHoo34LeVk6VO2d5iKYSBy17RIdmQeqdUwr4Ug Iw== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vkdgb967-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 18:27:08 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13CMBj1s025896;
        Mon, 12 Apr 2021 22:27:07 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01dal.us.ibm.com with ESMTP id 37u3n98mvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 22:27:07 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13CMR6ZK24445210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 22:27:06 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C22FBE054;
        Mon, 12 Apr 2021 22:27:06 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFD32BE04F;
        Mon, 12 Apr 2021 22:27:04 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.211.82.34])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 12 Apr 2021 22:27:04 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, david@gibson.dropbear.id.au, groug@kaod.org
Subject: [RFC PATCH 2/2] KVM: PPC: Book3S HV: Provide a more accurate MAX_VCPU_ID in P9
Date:   Mon, 12 Apr 2021 19:26:56 -0300
Message-Id: <20210412222656.3466987-3-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210412222656.3466987-1-farosas@linux.ibm.com>
References: <20210412222656.3466987-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oCn6YlPUZtVWsAbTJdrY0kke-9Qv5__6
X-Proofpoint-ORIG-GUID: oCn6YlPUZtVWsAbTJdrY0kke-9Qv5__6
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_11:2021-04-12,2021-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 phishscore=0 mlxlogscore=967 impostorscore=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120142
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The KVM_CAP_MAX_VCPU_ID capability was added by commit 0b1b1dfd52a6
("kvm: introduce KVM_MAX_VCPU_ID") to allow for vcpu ids larger than
KVM_MAX_VCPU in powerpc.

For a P9 host we depend on the guest VSMT value to know what is the
maximum number of vcpu id we can support:

kvmppc_core_vcpu_create_hv:
    (...)
    if (cpu_has_feature(CPU_FTR_ARCH_300)) {
-->         if (id >= (KVM_MAX_VCPUS * kvm->arch.emul_smt_mode)) {
                    pr_devel("KVM: VCPU ID too high\n");
                    core = KVM_MAX_VCORES;
            } else {
                    BUG_ON(kvm->arch.smt_mode != 1);
                    core = kvmppc_pack_vcpu_id(kvm, id);
            }
    } else {
            core = id / kvm->arch.smt_mode;
    }

which means that the value being returned by the capability today for
a given guest is potentially way larger than what we actually support:

\#define KVM_MAX_VCPU_ID (MAX_SMT_THREADS * KVM_MAX_VCORES)

If the capability is queried before userspace enables the
KVM_CAP_PPC_SMT ioctl there is not much we can do, but if the emulated
smt mode is already known we could provide a more accurate value.

The only practical effect of this change today is to make the
kvm_create_max_vcpus test pass for powerpc. The QEMU spapr machine has
a lower max vcpu than what KVM allows so even KVM_MAX_VCPU is not
reached.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>

---
I see that for ppc, QEMU uses the capability after enabling
KVM_CAP_PPC_SMT, so we could change QEMU to issue the check extension
on the vm fd so that it would get the more accurate value.
---
 arch/powerpc/kvm/powerpc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index a2a68a958fa0..95c9f47cc1b3 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -649,7 +649,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_MAX_VCPUS;
 		break;
 	case KVM_CAP_MAX_VCPU_ID:
-		r = KVM_MAX_VCPU_ID;
+		if (hv_enabled && cpu_has_feature(CPU_FTR_ARCH_300))
+			r = KVM_MAX_VCPUS * ((kvm) ? kvm->arch.emul_smt_mode : 1);
+		else
+			r = KVM_MAX_VCPU_ID;
 		break;
 #ifdef CONFIG_PPC_BOOK3S_64
 	case KVM_CAP_PPC_GET_SMMU_INFO:
-- 
2.29.2

