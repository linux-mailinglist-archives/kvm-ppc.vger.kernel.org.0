Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8956049BE0E
	for <lists+kvm-ppc@lfdr.de>; Tue, 25 Jan 2022 22:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbiAYV5W (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 25 Jan 2022 16:57:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4436 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233430AbiAYV5V (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 25 Jan 2022 16:57:21 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PLZeGi016802;
        Tue, 25 Jan 2022 21:57:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0Di2lMCeT/ExAzTlR1/NgXftdJl07tsrJiS2voyqkMs=;
 b=Al+MAvAC2NQLHTON1qR2OzPwFCfYiVm35a9nkT46UcLIriEEsLXGneuoaw6k/frMPxQx
 ITp4/KwEskUpd8ZIHkD7NbtwGne0khVka7RCUeaV88fLHmhbIh3P/yCN/bjcaYnMVewa
 u/8WgUHEwspOfQ4dxy7WQfdEgYAXQFGL6OqTyVXLq8easi9LnJj5mMSMFDfZ/p7qUp/+
 zdkuw1hEukkw3MpCzAsrtQO9njjZcukRlRFRGwj4NrA+70IyFDuATOQSjPH2jEduRo0q
 hbGPXDacLy9PiN8J8zGMWisHkdU+dDydPfqDL7oF88RIZwakjwaflpyAIGxx48SkQlQf Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtnwgmc4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 21:57:13 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20PLnRA6011943;
        Tue, 25 Jan 2022 21:57:12 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtnwgmc46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 21:57:12 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20PLrEkO029864;
        Tue, 25 Jan 2022 21:57:11 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma04dal.us.ibm.com with ESMTP id 3dr9janh0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 21:57:11 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20PLvAOu33423728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 21:57:10 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77D3BC6067;
        Tue, 25 Jan 2022 21:57:10 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9F71C6059;
        Tue, 25 Jan 2022 21:57:08 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.163.21.20])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jan 2022 21:57:08 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v5 4/5] KVM: PPC: mmio: Return to guest after emulation failure
Date:   Tue, 25 Jan 2022 18:56:54 -0300
Message-Id: <20220125215655.1026224-5-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125215655.1026224-1-farosas@linux.ibm.com>
References: <20220125215655.1026224-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: f9wfENRIutBNGT_MYB_0Jlf1Iejs1kJz
X-Proofpoint-ORIG-GUID: LcapL-tq3QjrDKYB5zTvrwTZQcFs-Kqw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_05,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 mlxscore=0 suspectscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201250128
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
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/powerpc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 27fb2b70f631..acb0d2a4bdb9 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -307,9 +307,9 @@ int kvmppc_emulate_mmio(struct kvm_vcpu *vcpu)
 		u32 last_inst;
 
 		kvmppc_get_last_inst(vcpu, INST_GENERIC, &last_inst);
-		/* XXX Deliver Program interrupt to guest. */
-		pr_emerg("%s: emulation failed (%08x)\n", __func__, last_inst);
-		r = RESUME_HOST;
+		kvm_debug_ratelimited("Guest access to device memory using unsupported instruction (opcode: %#08x)\n",
+				      last_inst);
+		r = RESUME_GUEST;
 		break;
 	}
 	default:
-- 
2.34.1

