Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470BE486AD5
	for <lists+kvm-ppc@lfdr.de>; Thu,  6 Jan 2022 21:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243578AbiAFUDf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 6 Jan 2022 15:03:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22458 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243563AbiAFUDe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 6 Jan 2022 15:03:34 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 206HwLnd006596;
        Thu, 6 Jan 2022 20:03:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WKRhUKJihlCf5qlffq3H7jBuGVKKLQn6KsAyRuth+lU=;
 b=qhx0uRBUqESwEGMZgmkden8lCkXhAO8boAaTsCYiLNCebJ/zN7V9u+fyHvDLx5lRR5pQ
 uXBpTKCMKaQxpz/fYWjkdM7xJ3jJ+GREF8kVCpEZlndsOvFz0iLov/liOqtazyq8JGLB
 yO4f3n9yBDyUc3BcAJDdyGHdFHzuJQ4iH72lgVaJbxE0if6UrpXB6pOZj8oDiUfIVXo4
 Eac9IYPjLvaZNVaVyRmUVfam2Ywc2oDra0mVoV5/ur5EFwnzJIfFZqYUZcdrRmXfEo4/
 2Jn68B4PAB2g+AIQjH3ckhWctg3S/3Pt86NAulWHhf7sl8i7fbTBhdE1CfLTCuk7ZWBI Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3de59st0vf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 20:03:28 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 206K02la028043;
        Thu, 6 Jan 2022 20:03:27 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3de59st0us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 20:03:27 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 206JwBZ5021856;
        Thu, 6 Jan 2022 20:03:26 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma05wdc.us.ibm.com with ESMTP id 3de5hnhmra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 20:03:26 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 206K3PNu31392194
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jan 2022 20:03:25 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADE90BE059;
        Thu,  6 Jan 2022 20:03:25 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00BB1BE056;
        Thu,  6 Jan 2022 20:03:24 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.211.150.192])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  6 Jan 2022 20:03:23 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v2 6/7] KVM: PPC: mmio: Return to guest after emulation failure
Date:   Thu,  6 Jan 2022 17:03:03 -0300
Message-Id: <20220106200304.4070825-7-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220106200304.4070825-1-farosas@linux.ibm.com>
References: <20220106200304.4070825-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qRoFV2cloh3H-Ql39xOpBXTfLqeGAGc_
X-Proofpoint-ORIG-GUID: DkFq904efV9VjsEsaHoyg9QRbLJJY7mk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-06_08,2022-01-06_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201060126
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

If MMIO emulation fails we don't want to crash the whole guest by
returning to userspace.

The original commit bbf45ba57eae ("KVM: ppc: PowerPC 440 KVM
implementation") added a todo:

  /* XXX Deliver Program interrupt to guest. */

and later the commit d69614a295ae ("KVM: PPC: Separate loadstore
emulation from priv emulation") added the Program interrupt injection
but in another file, so I'm assuming it was missed that this block
needed to be altered.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/powerpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index a2e78229d645..50e08635e18a 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -309,7 +309,7 @@ int kvmppc_emulate_mmio(struct kvm_vcpu *vcpu)
 		kvmppc_get_last_inst(vcpu, INST_GENERIC, &last_inst);
 		kvmppc_core_queue_program(vcpu, 0);
 		pr_info("%s: emulation failed (%08x)\n", __func__, last_inst);
-		r = RESUME_HOST;
+		r = RESUME_GUEST;
 		break;
 	}
 	default:
-- 
2.33.1

