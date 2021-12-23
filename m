Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8346847E8F2
	for <lists+kvm-ppc@lfdr.de>; Thu, 23 Dec 2021 22:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbhLWVPx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 23 Dec 2021 16:15:53 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39646 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234130AbhLWVPx (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 23 Dec 2021 16:15:53 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BNKfSI4017944;
        Thu, 23 Dec 2021 21:15:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=r9SBDjlUoSs4Ovdcv9eHIusJId//mFFEprInoUNJY9Q=;
 b=jbzsVFIhG7IAoEB2dhyBqmmyNS/YwQdMeUsNgWJ1Jdgh7Ph5089DbUdIQ8AUTwzIJGS5
 W2/ODlD9aB1ke7zoxfZQoEtocdLFweDCWxLYABr3244llWKqVhxahpPYoOOosVryp+Cu
 UBIWKVWkBRsYIcHFCaAxNmzQ1LRuMMP8IClVw5fQ0NVfe33qxpE+DiTrjvDSNBahaRn+
 BQmRpHAa8LdXj8Lj/wGfw/2wiYUFVT9gSFGesXErTcYrkSvzJjN3u988j6n78nWRs/G1
 JiJ3XuryqABlaIEfvgbOBJlUgM4gAnEEwdjlkOKb+BER/3LBnoE/ze4FXaNAbDxwctBS VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d50ca0gcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Dec 2021 21:15:46 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BNKnstX003916;
        Thu, 23 Dec 2021 21:15:45 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d50ca0gc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Dec 2021 21:15:45 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BNL82jX032005;
        Thu, 23 Dec 2021 21:15:44 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04wdc.us.ibm.com with ESMTP id 3d179kg2yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Dec 2021 21:15:44 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BNLFhZl23986566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 21:15:43 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1751AC062;
        Thu, 23 Dec 2021 21:15:43 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF3B6AC060;
        Thu, 23 Dec 2021 21:15:41 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.163.19.83])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 23 Dec 2021 21:15:41 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH 3/3] KVM: PPC: Fix mmio length message
Date:   Thu, 23 Dec 2021 18:15:28 -0300
Message-Id: <20211223211528.3560711-4-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211223211528.3560711-1-farosas@linux.ibm.com>
References: <20211223211528.3560711-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Do9MDl2xKJnyL1kdPFGwDx3UVfq9vjOH
X-Proofpoint-GUID: 7inAJcAaixFw0gmL5yAx2NkwJfy0gGLV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-23_04,2021-12-22_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0 spamscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112230106
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

We check against 'bytes' but print 'run->mmio.len' which at that point
has an old value.

e.g. 16-byte load:

before:
__kvmppc_handle_load: bad MMIO length: 8

now:
__kvmppc_handle_load: bad MMIO length: 16

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/powerpc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 793d42bd6c8f..7823207eb8f1 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -1246,7 +1246,7 @@ static int __kvmppc_handle_load(struct kvm_vcpu *vcpu,
 
 	if (bytes > sizeof(run->mmio.data)) {
 		printk(KERN_ERR "%s: bad MMIO length: %d\n", __func__,
-		       run->mmio.len);
+		       bytes);
 	}
 
 	run->mmio.phys_addr = vcpu->arch.paddr_accessed;
@@ -1335,7 +1335,7 @@ int kvmppc_handle_store(struct kvm_vcpu *vcpu,
 
 	if (bytes > sizeof(run->mmio.data)) {
 		printk(KERN_ERR "%s: bad MMIO length: %d\n", __func__,
-		       run->mmio.len);
+		       bytes);
 	}
 
 	run->mmio.phys_addr = vcpu->arch.paddr_accessed;
-- 
2.33.1

