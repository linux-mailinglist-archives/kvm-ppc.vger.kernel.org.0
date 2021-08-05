Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C3C3E1DFC
	for <lists+kvm-ppc@lfdr.de>; Thu,  5 Aug 2021 23:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhHEV04 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 5 Aug 2021 17:26:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5474 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229729AbhHEV04 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 5 Aug 2021 17:26:56 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175L56Uq169298;
        Thu, 5 Aug 2021 17:26:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5uDUnNicEF28MTqBHVAyoLIf8xB5V0KoEqHJw+eR7sg=;
 b=KTix5zAWAfLr527FjKjjXvQrGTxjcXn8Lq6qL1DQcS26Gige4/g3ErkH4x3H/oxNrINJ
 umBINlCqXWlKri0YdwnFTqHozIjxb2hmjsAgnH++5ozwnIEHfDZVm3eTn+LsSSpEoVom
 sJIDrQ/POBJl85f2ESteHWYQzlPG3XhlYMQIdHRttqugW3m0CNZ/H4KGwHb8h7NWy9AS
 +YOD0aBGnRrJSmh50zRYI9fJUyVUqpA8Y5VKY/AuQJKQx3N2/0rSo/rbmGg+1hZj2nEl
 KBe4aG5rnAU3iiLb85rAU07ubbFtUvAnyMde6nJ1RziAU56RcDlBLVjqompJBsroaPAB 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a8j8ha6ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 17:26:30 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 175LHUAk073408;
        Thu, 5 Aug 2021 17:26:30 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a8j8ha6nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 17:26:30 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 175LMIB2023846;
        Thu, 5 Aug 2021 21:26:29 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 3a7anjyaux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 21:26:29 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 175LQSf111534758
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Aug 2021 21:26:28 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5F3E112070;
        Thu,  5 Aug 2021 21:26:28 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8915E11206F;
        Thu,  5 Aug 2021 21:26:26 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.163.18.4])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu,  5 Aug 2021 21:26:26 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@c-s.fr
Subject: [PATCH v2 2/3] KVM: PPC: Book3S HV: Add sanity check to copy_tofrom_guest
Date:   Thu,  5 Aug 2021 18:26:15 -0300
Message-Id: <20210805212616.2641017-3-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210805212616.2641017-1-farosas@linux.ibm.com>
References: <20210805212616.2641017-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lBDHlG7nPo0lxJjaV9xLP7GkhB-ZA7BL
X-Proofpoint-ORIG-GUID: XpJoplgsj1ZQ8RVXoD-9tBSOlYu2z9i5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-05_10:2021-08-05,2021-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 mlxlogscore=950 lowpriorityscore=0
 adultscore=0 spamscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108050124
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Both paths into __kvmhv_copy_tofrom_guest_radix ensure that we arrive
with an effective address that is smaller than our total addressable
space and addresses quadrant 0.

- The H_COPY_TOFROM_GUEST hypercall path rejects the call with
H_PARAMETER if the effective address has any of the twelve most
significant bits set.

- The kvmhv_copy_tofrom_guest_radix path clears the top twelve bits
before calling the internal function.

Although the callers make sure that the effective address is sane, any
future use of the function is exposed to a programming error, so add a
sanity check.

Suggested-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 44eb7b1ef289..1b1c9e9e539b 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -44,6 +44,9 @@ unsigned long __kvmhv_copy_tofrom_guest_radix(int lpid, int pid,
 					  (to != NULL) ? __pa(to): 0,
 					  (from != NULL) ? __pa(from): 0, n);
 
+	if (eaddr & (0xFFFUL << 52))
+		return ret;
+
 	quadrant = 1;
 	if (!pid)
 		quadrant = 2;
-- 
2.29.2

