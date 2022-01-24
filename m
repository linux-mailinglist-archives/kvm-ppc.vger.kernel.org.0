Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A8049A4F5
	for <lists+kvm-ppc@lfdr.de>; Tue, 25 Jan 2022 03:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352780AbiAYAYE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 24 Jan 2022 19:24:04 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21120 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1588865AbiAXWyE (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 24 Jan 2022 17:54:04 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20OKgBgR010417;
        Mon, 24 Jan 2022 22:08:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vQQ+afYAt9zJvf51LHL2VQMYia7s/quLfez1pazlcY0=;
 b=MuNHVtE0yHH+OhUNhZfaHRewaUEuPdZlHBhvM0nuLj/heW0n8Xx94qwGOaDo5juC7Oy2
 XD19q9qpYvcWlQA1SHApCwCkRGQTdskMYrQSNniCDJe3TOLiP7SZzIj74vrxRuh9dSw6
 HqIMXfr1L6Vxhc5DW0UVKexPCYGFvsuV2524tP6267XqXqEqSdxqAozrlzE5L5/bR2GY
 Gve1B4UkvXlt5CCNqbxwzQl9TBTERY0Hx9DH+ZIxy8cTOkN2FOB8ppYKqw+hckzSiCwl
 9BxWfNlIfhYEuatPmyRmPK96vJh1/liOSHxtChSFStLzZJuNTP0ZpOMbcC47zUFYAVcM uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dt3cf9jmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 22:08:20 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20OLaOGl008141;
        Mon, 24 Jan 2022 22:08:19 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dt3cf9jmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 22:08:19 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20OM7Lo7010949;
        Mon, 24 Jan 2022 22:08:18 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04wdc.us.ibm.com with ESMTP id 3dr9j9yxt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 22:08:18 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20OM8HDX35914000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jan 2022 22:08:17 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9562578063;
        Mon, 24 Jan 2022 22:08:17 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3FFC7807B;
        Mon, 24 Jan 2022 22:08:15 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.163.24.67])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 24 Jan 2022 22:08:15 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v2 3/4] KVM: PPC: Book3S HV: Free allocated memory if module init fails
Date:   Mon, 24 Jan 2022 19:08:02 -0300
Message-Id: <20220124220803.1011673-4-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124220803.1011673-1-farosas@linux.ibm.com>
References: <20220124220803.1011673-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gwMRTZ-qyP_bKQxTFGMxukPgipz8w1B6
X-Proofpoint-GUID: oXeNi09-mwkZsJR_qz8UZoA6PDu4lgv-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-24_09,2022-01-24_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201240143
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

