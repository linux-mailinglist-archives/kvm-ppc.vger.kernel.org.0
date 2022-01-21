Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4EC4967D7
	for <lists+kvm-ppc@lfdr.de>; Fri, 21 Jan 2022 23:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbiAUW06 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 21 Jan 2022 17:26:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52190 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233179AbiAUW05 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 21 Jan 2022 17:26:57 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20LL5j9f013959;
        Fri, 21 Jan 2022 22:26:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=R6VIuyLgIhhg8WD3gJzSU3C+d3OUCyJY+RffyafifCQ=;
 b=YL8K+9qUVDaoAqZEyeEK+qMFVLiOG8HpfDZJvkb8ptvFKzaO5sO0Vhe+Z/xnQkV6SK/3
 zP81Xjbsb/LTgHPndz3BY95gVKOMr2fqB7MXvuxtf6ctctdxKof1fdJG0zWfZ6UjA0on
 +U2nPUqU+AWW5HsBu4WPbYB8AfIIbRtvw6wbq8Hl7stnhTdeIK1ZkfJteBdmvsYd8+Rw
 Ca7QmPXIxJM126Zw8RJBh48qvr23mwuSB/pVn4RUmshuNiS2+wLd2hXhit17jdDBH0q8
 vMDJS00XiIlqKQ+lJMNxE2kLnXNM9pbc6rU9Y6R0B/6ZIO9jKKuXfZbSU0g5Ep3y/paj kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dr1w3vhp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 22:26:51 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20LMQoDE006432;
        Fri, 21 Jan 2022 22:26:50 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dr1w3vhnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 22:26:50 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20LMMR3k008670;
        Fri, 21 Jan 2022 22:26:49 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03dal.us.ibm.com with ESMTP id 3dqj1k9bn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 22:26:49 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20LMQm7w42991976
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 22:26:48 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47267AE063;
        Fri, 21 Jan 2022 22:26:48 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A64E3AE062;
        Fri, 21 Jan 2022 22:26:45 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.211.81.234])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jan 2022 22:26:45 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v4 4/5] KVM: PPC: mmio: Return to guest after emulation failure
Date:   Fri, 21 Jan 2022 19:26:25 -0300
Message-Id: <20220121222626.972495-5-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220121222626.972495-1-farosas@linux.ibm.com>
References: <20220121222626.972495-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9VPZDLMM0mz9wGoRWOG47mn939McK5z_
X-Proofpoint-ORIG-GUID: 9ETZzTkB5U7mH_SUlPGs_rPMTvSKV8u-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_10,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 mlxscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210140
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

Also change the message to a ratelimited one since we're letting the
guest run and it could flood the host logs.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/powerpc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 27fb2b70f631..214602c58f13 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -307,9 +307,9 @@ int kvmppc_emulate_mmio(struct kvm_vcpu *vcpu)
 		u32 last_inst;
 
 		kvmppc_get_last_inst(vcpu, INST_GENERIC, &last_inst);
-		/* XXX Deliver Program interrupt to guest. */
-		pr_emerg("%s: emulation failed (%08x)\n", __func__, last_inst);
-		r = RESUME_HOST;
+		pr_info_ratelimited("KVM: guest access to device memory using unsupported instruction (PID: %d opcode: %#08x)\n",
+				    current->pid, last_inst);
+		r = RESUME_GUEST;
 		break;
 	}
 	default:
-- 
2.34.1

