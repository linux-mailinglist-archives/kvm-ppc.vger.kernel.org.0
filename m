Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8889349B820
	for <lists+kvm-ppc@lfdr.de>; Tue, 25 Jan 2022 17:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1582850AbiAYP7r (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 25 Jan 2022 10:59:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47396 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1582846AbiAYP6L (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 25 Jan 2022 10:58:11 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PFfnwM016176;
        Tue, 25 Jan 2022 15:57:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vQQ+afYAt9zJvf51LHL2VQMYia7s/quLfez1pazlcY0=;
 b=E0hskGL3mRyaaMfWjjCHXQG9Lo6FcfseZ7P152+FVLLuYTp6kR1YQlZdNLNrj17BUiH9
 r4L77yUhEULksUB1/X6CmJb/JcgiEJaGrMEpFkbEuus4sHfL+TwoQys98lUd6fDic8IU
 8OVxfvke0f+lceDvhioz4a3CpnYwcvnhyLsmxyObz4g6wjcNyAFaplbVSvNoKKfEGOR3
 IbpOfJPoykoGBRVbMqYDL2FyYpqYzJkRNU+MHrkr2QdrDeYYDwvbVMLeiZB0lkrvOiQq
 OMUD6vrOsfPQJCXNCr/HyBaxJMWjd5Fyl9iN72hTu2BGMyxeC+R2GnATH019rc8A8gid HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtm2pgdve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 15:57:52 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20PFpSt0009633;
        Tue, 25 Jan 2022 15:57:51 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtm2pgdus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 15:57:51 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20PFvlsh015882;
        Tue, 25 Jan 2022 15:57:50 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02wdc.us.ibm.com with ESMTP id 3dr9ja08r3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 15:57:50 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20PFvn8c18284928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 15:57:49 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4250C6074;
        Tue, 25 Jan 2022 15:57:48 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB3E8C6062;
        Tue, 25 Jan 2022 15:57:46 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.163.21.20])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jan 2022 15:57:46 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v3 3/4] KVM: PPC: Book3S HV: Free allocated memory if module init fails
Date:   Tue, 25 Jan 2022 12:57:34 -0300
Message-Id: <20220125155735.1018683-4-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125155735.1018683-1-farosas@linux.ibm.com>
References: <20220125155735.1018683-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: G7w-e3hh_WajgqHQWqkGZVDSVK1LKFjf
X-Proofpoint-GUID: LTLj7pDz5Yrs_qC7gdWc8r1uFpPFw2-i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_03,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 malwarescore=0 clxscore=1015 suspectscore=0 adultscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250100
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The module's exit function is not called when the init fails, we need
to do cleanup before returning.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index b9aace212599..87a49651a402 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -6104,7 +6104,7 @@ static int kvmppc_book3s_init_hv(void)
 	if (!cpu_has_feature(CPU_FTR_ARCH_300)) {
 		r = kvm_init_subcore_bitmap();
 		if (r)
-			return r;
+			goto err;
 	}
 
 	/*
@@ -6120,7 +6120,8 @@ static int kvmppc_book3s_init_hv(void)
 		np = of_find_compatible_node(NULL, NULL, "ibm,opal-intc");
 		if (!np) {
 			pr_err("KVM-HV: Cannot determine method for accessing XICS\n");
-			return -ENODEV;
+			r = -ENODEV;
+			goto err;
 		}
 		/* presence of intc confirmed - node can be dropped again */
 		of_node_put(np);
@@ -6133,12 +6134,12 @@ static int kvmppc_book3s_init_hv(void)
 
 	r = kvmppc_mmu_hv_init();
 	if (r)
-		return r;
+		goto err;
 
 	if (kvmppc_radix_possible()) {
 		r = kvmppc_radix_init();
 		if (r)
-			return r;
+			goto err;
 	}
 
 	r = kvmppc_uvmem_init();
@@ -6151,6 +6152,12 @@ static int kvmppc_book3s_init_hv(void)
 	kvmppc_hv_ops = &kvm_ops_hv;
 
 	return 0;
+
+err:
+	kvmhv_nested_exit();
+	kvmppc_radix_exit();
+
+	return r;
 }
 
 static void kvmppc_book3s_exit_hv(void)
-- 
2.34.1

