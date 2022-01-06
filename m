Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20112486ACE
	for <lists+kvm-ppc@lfdr.de>; Thu,  6 Jan 2022 21:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243551AbiAFUD2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 6 Jan 2022 15:03:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31110 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235093AbiAFUD1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 6 Jan 2022 15:03:27 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 206Iapl4005800;
        Thu, 6 Jan 2022 20:03:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zhFsFg7cMeCxBP2ChAMBVaj/egqCOmUPt3ocg2+o3A0=;
 b=ZavTj3y7kUNHIk1SYDvhFlj5twhaO5qH+DO1s+bNB/xocmEDg0TDYafhdB9s2+N0S74Y
 hnUmjd/5fQTTW2MY6ayaZh6VFyIZL0ubMWTFBtfnp3kdSk5Fs++fgijJ79UJuHeDBML3
 flLiWmbKs95ptZ9F4omquEnA7Wb8m9JAqFxzDLS0WwDWy9uiOzokZ4Bqx5IfzA7wnt52
 vKv7uw/1DzA9PRT7P40J9xxeWYx5Ao6AyGtRxPjKeusLJVUlcKwv1rAXG4NmYp7ixb2Z
 hhmH+HOBqtGpQznVmgCZk1lJoKFmdQcQTxO2M8LQAea/ekrJBnLQm+vzIm7Ae39IReP0 rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3de4y7j9ye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 20:03:19 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 206JsTkn010963;
        Thu, 6 Jan 2022 20:03:18 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3de4y7j9y4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 20:03:18 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 206Jv9ga022763;
        Thu, 6 Jan 2022 20:03:18 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 3de4xf2uux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 20:03:18 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 206K3Gja19661080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jan 2022 20:03:16 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDC2FBE058;
        Thu,  6 Jan 2022 20:03:16 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F24E3BE054;
        Thu,  6 Jan 2022 20:03:14 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.211.150.192])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  6 Jan 2022 20:03:14 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v2 2/7] KVM: PPC: Fix vmx/vsx mixup in mmio emulation
Date:   Thu,  6 Jan 2022 17:02:59 -0300
Message-Id: <20220106200304.4070825-3-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220106200304.4070825-1-farosas@linux.ibm.com>
References: <20220106200304.4070825-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HFHi749qYWyxR5iWeg_gktgw-Ew8XZCs
X-Proofpoint-ORIG-GUID: kXYj02me3_kEKoPI1tvpceBbYyIfnS7h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-06_08,2022-01-06_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=963 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201060126
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The MMIO emulation code for vector instructions is duplicated between
VSX and VMX. When emulating VMX we should check the VMX copy size
instead of the VSX one.

Fixes: acc9eb9305fe ("KVM: PPC: Reimplement LOAD_VMX/STORE_VMX instruction ...")
Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/powerpc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 1e130bb087c4..92e552ab5a77 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -1507,7 +1507,7 @@ int kvmppc_handle_vmx_load(struct kvm_vcpu *vcpu,
 {
 	enum emulation_result emulated = EMULATE_DONE;
 
-	if (vcpu->arch.mmio_vsx_copy_nums > 2)
+	if (vcpu->arch.mmio_vmx_copy_nums > 2)
 		return EMULATE_FAIL;
 
 	while (vcpu->arch.mmio_vmx_copy_nums) {
@@ -1604,7 +1604,7 @@ int kvmppc_handle_vmx_store(struct kvm_vcpu *vcpu,
 	unsigned int index = rs & KVM_MMIO_REG_MASK;
 	enum emulation_result emulated = EMULATE_DONE;
 
-	if (vcpu->arch.mmio_vsx_copy_nums > 2)
+	if (vcpu->arch.mmio_vmx_copy_nums > 2)
 		return EMULATE_FAIL;
 
 	vcpu->arch.io_gpr = rs;
-- 
2.33.1

