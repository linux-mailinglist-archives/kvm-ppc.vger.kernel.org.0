Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE754967D4
	for <lists+kvm-ppc@lfdr.de>; Fri, 21 Jan 2022 23:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbiAUW0w (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 21 Jan 2022 17:26:52 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49886 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233357AbiAUW0v (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 21 Jan 2022 17:26:51 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20LKgCoL008961;
        Fri, 21 Jan 2022 22:26:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zPDUp72TJn/t9oxpDadcWEWbhpR15FARI/Lv/O5sZws=;
 b=Lv5BeHVBsQI6uk87R+zhHCaXh21pbt+wS0vS9iwK42fBUAy/CKUVc01RK7ItJXhmXNZg
 dC7U6g9M2XOZdPyg/6+kxNC38WHXuudIf3ZELFN+2hcUaO1zAhTbr3DE+7iTpE1V1cJ/
 kIMuj186qhfhq/LpwuwWchkWjbQAr1A7U3XLuv9gIMmc++c8JBhnzjIPTN2ZGXo4TajW
 QeDk0eBcTThmWtic8EplQhKmxD9Hxfk5FDjZAcj1DqPnLWsLlC4vmTuLUS3gAyAmWAao
 W40FuqvN+RjrqHsnwuW035E5S6uhGKZIjNWi0ieHRKa0dPPfbaFqDoqGl/X3S4gNBUM/ FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dr43h1sdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 22:26:44 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20LMQ31j012929;
        Fri, 21 Jan 2022 22:26:44 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dr43h1sda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 22:26:44 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20LMMDRh009137;
        Fri, 21 Jan 2022 22:26:43 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01wdc.us.ibm.com with ESMTP id 3dqjur3d86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 22:26:43 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20LMQgMi34013458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 22:26:42 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6B08AE062;
        Fri, 21 Jan 2022 22:26:41 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46CD7AE060;
        Fri, 21 Jan 2022 22:26:39 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.211.81.234])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jan 2022 22:26:38 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v4 2/5] KVM: PPC: Fix vmx/vsx mixup in mmio emulation
Date:   Fri, 21 Jan 2022 19:26:23 -0300
Message-Id: <20220121222626.972495-3-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220121222626.972495-1-farosas@linux.ibm.com>
References: <20220121222626.972495-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mGaTCVSc6N1oCx4DwkjywszqmweYUq3l
X-Proofpoint-ORIG-GUID: TPxwu3m7_fwKT_bpt4AQhVpLedL_vqel
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_10,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=883
 impostorscore=0 phishscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 clxscore=1011 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210140
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
index 50414fb2a5ea..c2bd29e90314 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -1499,7 +1499,7 @@ int kvmppc_handle_vmx_load(struct kvm_vcpu *vcpu,
 {
 	enum emulation_result emulated = EMULATE_DONE;
 
-	if (vcpu->arch.mmio_vsx_copy_nums > 2)
+	if (vcpu->arch.mmio_vmx_copy_nums > 2)
 		return EMULATE_FAIL;
 
 	while (vcpu->arch.mmio_vmx_copy_nums) {
@@ -1596,7 +1596,7 @@ int kvmppc_handle_vmx_store(struct kvm_vcpu *vcpu,
 	unsigned int index = rs & KVM_MMIO_REG_MASK;
 	enum emulation_result emulated = EMULATE_DONE;
 
-	if (vcpu->arch.mmio_vsx_copy_nums > 2)
+	if (vcpu->arch.mmio_vmx_copy_nums > 2)
 		return EMULATE_FAIL;
 
 	vcpu->arch.io_gpr = rs;
-- 
2.34.1

