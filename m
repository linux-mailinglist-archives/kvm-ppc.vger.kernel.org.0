Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACDE499F73
	for <lists+kvm-ppc@lfdr.de>; Tue, 25 Jan 2022 00:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1841294AbiAXW6R (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 24 Jan 2022 17:58:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10784 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1839068AbiAXWtw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 24 Jan 2022 17:49:52 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20OLgkX5019331;
        Mon, 24 Jan 2022 22:08:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gCgJ6gJJ9qprIe3Yz88OrLeUA7q370d6LKfJqUBgWLo=;
 b=G6sej+xJ2bGHQyoU54nLAh16+ldd53EGLo5GuKejffZLrudu6g+Vk0mz4Yepuvseq3st
 SaForgjkMCSBB1yBuruu2HY36AbH6STO5YvsuQWOPb7lSOCF1lAPeJPHi6dIE8vjlL2k
 4JuKDQavxKi/wjqsZli/1cvizm9EeBMQxRGw2mi4blUV3RrX2KDa6g0fm4R2uCl+f8GF
 dgbE/5dS1o9yjaOIcLlfVccPw35JX9lV8YftdblAT30wGQ+FmbmupdHnP7ovF11MffvN
 XwNWXNFvZv605V7H0d/DRnw3laDVdy6FxXZCtdSv2de//vIgE9n1WC77oMj5DCsw7LBi og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dt48rrfa2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 22:08:15 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20OM0Oj4014530;
        Mon, 24 Jan 2022 22:08:15 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dt48rrf9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 22:08:15 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20OM7bJT000428;
        Mon, 24 Jan 2022 22:08:14 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 3dr9ja9krn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 22:08:14 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20OM8D5p29622646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jan 2022 22:08:13 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EA8E78067;
        Mon, 24 Jan 2022 22:08:13 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7199F78063;
        Mon, 24 Jan 2022 22:08:11 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.163.24.67])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 24 Jan 2022 22:08:11 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v2 1/4] KVM: PPC: Book3S HV: Check return value of kvmppc_radix_init
Date:   Mon, 24 Jan 2022 19:08:00 -0300
Message-Id: <20220124220803.1011673-2-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124220803.1011673-1-farosas@linux.ibm.com>
References: <20220124220803.1011673-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CNPtlQlSDZX2ps0LxU4N-VHISJfr5kbv
X-Proofpoint-ORIG-GUID: V9vYCtoD4X7cjT7UqtnREOwuIQJG3iNM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-24_09,2022-01-24_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 mlxscore=0 spamscore=0
 suspectscore=0 mlxlogscore=859 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201240143
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The return of the function is being shadowed by the call to
kvmppc_uvmem_init.

Fixes: ca9f4942670c ("KVM: PPC: Book3S HV: Support for running secure guests")
Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index d1817cd9a691..3a3845f366d4 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -6138,8 +6138,11 @@ static int kvmppc_book3s_init_hv(void)
 	if (r)
 		return r;
 
-	if (kvmppc_radix_possible())
+	if (kvmppc_radix_possible()) {
 		r = kvmppc_radix_init();
+		if (r)
+			return r;
+	}
 
 	r = kvmppc_uvmem_init();
 	if (r < 0)
-- 
2.34.1

