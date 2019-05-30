Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8103008D
	for <lists+kvm-ppc@lfdr.de>; Thu, 30 May 2019 19:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfE3RKX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 30 May 2019 13:10:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44028 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725961AbfE3RKX (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 30 May 2019 13:10:23 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4UH4ncV023714
        for <kvm-ppc@vger.kernel.org>; Thu, 30 May 2019 13:10:22 -0400
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2stjjy1q2g-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Thu, 30 May 2019 13:10:22 -0400
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <farosas@linux.ibm.com>;
        Thu, 30 May 2019 18:10:21 +0100
Received: from b01cxnp22033.gho.pok.ibm.com (9.57.198.23)
        by e12.ny.us.ibm.com (146.89.104.199) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 30 May 2019 18:10:18 +0100
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4UHAHVu36831416
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 May 2019 17:10:17 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 222F2112066;
        Thu, 30 May 2019 17:10:17 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33CC0112061;
        Thu, 30 May 2019 17:10:16 +0000 (GMT)
Received: from farosas.linux.ibm.com.br.ibm.com (unknown [9.86.26.122])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 30 May 2019 17:10:15 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH] KVM: PPC: Remove leftover comment from emulate_loadstore.c
Date:   Thu, 30 May 2019 14:10:14 -0300
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19053017-0060-0000-0000-0000034A0298
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011185; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01210829; UDB=6.00636183; IPR=6.00991863;
 MB=3.00027121; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-30 17:10:19
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19053017-0061-0000-0000-0000498E3E5F
Message-Id: <20190530171014.1733-1-farosas@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-30_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=650 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905300120
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The mmio_vsx_tx_sx_enabled field was removed but its documentation was
left behind.

4eeb85568e56 KVM: PPC: Remove mmio_vsx_tx_sx_enabled in KVM MMIO
emulation

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/emulate_loadstore.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/powerpc/kvm/emulate_loadstore.c b/arch/powerpc/kvm/emulate_loadstore.c
index f91b1309a0a8..806dbc439131 100644
--- a/arch/powerpc/kvm/emulate_loadstore.c
+++ b/arch/powerpc/kvm/emulate_loadstore.c
@@ -100,12 +100,6 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
 	rs = get_rs(inst);
 	rt = get_rt(inst);
 
-	/*
-	 * if mmio_vsx_tx_sx_enabled == 0, copy data between
-	 * VSR[0..31] and memory
-	 * if mmio_vsx_tx_sx_enabled == 1, copy data between
-	 * VSR[32..63] and memory
-	 */
 	vcpu->arch.mmio_vsx_copy_nums = 0;
 	vcpu->arch.mmio_vsx_offset = 0;
 	vcpu->arch.mmio_copy_type = KVMPPC_VSX_COPY_NONE;
-- 
2.20.1

