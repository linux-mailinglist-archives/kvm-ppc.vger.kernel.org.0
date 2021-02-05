Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3C43112A2
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Feb 2021 21:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbhBES4F (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Feb 2021 13:56:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42648 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232861AbhBEPE0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Feb 2021 10:04:26 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 115Gg3Td105612;
        Fri, 5 Feb 2021 11:42:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2CLLm2jArK2LVDHui3EuwFCiCxm1AUnIWFTw2F88tlo=;
 b=B2Z4yLK1sPGoLwFDE7HQYIHbp5wj0mQkUYdV8PHUp3Av1BXWh5M3z3Xu5IgYmSUNCu+x
 jwVCK4FKV2dmEcpurgZ7wqw2KILzc3PhTTYYSNgMAsG4+f1bon3LUwTovsI2KtY8Aumb
 q2z4joDwgZ3ZHz1fjHMxXiQTjOoRQHDoYlLgvzi3Lz1IiaA28Q3d8mj+K8db1PM0GfCv
 DJNHcVhJYtT4J+0GTwWOhF7liMddZ/lBjn7dU58uaQ2R+b2J/ngcQfxLXXoK5VCPfbjU
 OdvElLPpDYvmhp8UC+XLfsO2qHsxysOhnzssQ/Eq4/2F++4mzW9vUeyJ3a139JCORKOZ kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36h9rx8020-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 11:42:02 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 115Gg22f105568;
        Fri, 5 Feb 2021 11:42:02 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36h9rx801q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 11:42:02 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 115GWGtc001057;
        Fri, 5 Feb 2021 16:42:01 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03dal.us.ibm.com with ESMTP id 36f3kw1sfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 16:42:01 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 115Gg05k31064512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Feb 2021 16:42:01 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF6D6AC064;
        Fri,  5 Feb 2021 16:42:00 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47C0FAC059;
        Fri,  5 Feb 2021 16:41:59 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.163.5.169])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  5 Feb 2021 16:41:58 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, npiggin@gmail.com
Subject: [PATCH] KVM: PPC: Don't always report hash MMU capability for P9 < DD2.2
Date:   Fri,  5 Feb 2021 13:41:54 -0300
Message-Id: <20210205164154.1513317-1-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210118062809.1430920-2-npiggin@gmail.com>
References: <20210118062809.1430920-2-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-05_09:2021-02-05,2021-02-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 phishscore=0 adultscore=0 impostorscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102050104
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

These machines don't support running both MMU types at the same time,
so remove the KVM_CAP_PPC_MMU_HASH_V3 capability when the host is
using Radix MMU.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/include/asm/kvm_ppc.h |  1 +
 arch/powerpc/kvm/book3s_hv.c       | 10 ++++++++++
 arch/powerpc/kvm/powerpc.c         |  3 +--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 0a056c64c317..b36abc89baf3 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -314,6 +314,7 @@ struct kvmppc_ops {
 			      int size);
 	int (*enable_svm)(struct kvm *kvm);
 	int (*svm_off)(struct kvm *kvm);
+	bool (*hash_v3_possible)(void);
 };
 
 extern struct kvmppc_ops *kvmppc_hv_ops;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 6f612d240392..d20c0682cae5 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5599,6 +5599,15 @@ static int kvmhv_svm_off(struct kvm *kvm)
 	return ret;
 }
 
+static bool kvmppc_hash_v3_possible(void)
+{
+	if (radix_enabled() && no_mixing_hpt_and_radix)
+		return false;
+
+	return cpu_has_feature(CPU_FTR_ARCH_300) &&
+		cpu_has_feature(CPU_FTR_HVMODE);
+}
+
 static struct kvmppc_ops kvm_ops_hv = {
 	.get_sregs = kvm_arch_vcpu_ioctl_get_sregs_hv,
 	.set_sregs = kvm_arch_vcpu_ioctl_set_sregs_hv,
@@ -5642,6 +5651,7 @@ static struct kvmppc_ops kvm_ops_hv = {
 	.store_to_eaddr = kvmhv_store_to_eaddr,
 	.enable_svm = kvmhv_enable_svm,
 	.svm_off = kvmhv_svm_off,
+	.hash_v3_possible = kvmppc_hash_v3_possible,
 };
 
 static int kvm_init_subcore_bitmap(void)
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index cf52d26f49cd..b9fb2f20f879 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -611,8 +611,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = !!(hv_enabled && radix_enabled());
 		break;
 	case KVM_CAP_PPC_MMU_HASH_V3:
-		r = !!(hv_enabled && cpu_has_feature(CPU_FTR_ARCH_300) &&
-		       cpu_has_feature(CPU_FTR_HVMODE));
+		r = !!(hv_enabled && kvmppc_hv_ops->hash_v3_possible());
 		break;
 	case KVM_CAP_PPC_NESTED_HV:
 		r = !!(hv_enabled && kvmppc_hv_ops->enable_nested &&
-- 
2.29.2

