Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D833FE12D
	for <lists+kvm-ppc@lfdr.de>; Wed,  1 Sep 2021 19:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245220AbhIARfQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 1 Sep 2021 13:35:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33682 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236419AbhIARfP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 1 Sep 2021 13:35:15 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 181HXitP170462;
        Wed, 1 Sep 2021 13:34:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+56r6OTB+CpWdKpMX/+JhFpcuVs6G5sbcQgzO7h2LI4=;
 b=fj6XvZcbHSYc+2mDLw8P8tjMVHWAbDT8QRPw/1ETueOS6X7r09Ye4BBC6oFjBUC/UqKU
 stC7ZYMnUscljkBr8bfHEJx/7ZUcRIqlVBKHppp0IJnv6a1mRgEF5bf1Ny7+S4rxwoek
 Xijtx3hmZNy9A0XaKg+SoD9iz3xQI3pJ6atOicvWd5GTU/ph1gfniE6xK3CdMt6Qthf2
 Gpz5ho3wWIxJjoXW8QUhV1or4MTtbxjzrKv9BEUWZ3Fa4nHhvVln/lG4b+n6Vnyq/xf1
 2gzDTwxHkpLW+xbuv1xy55o/jmlI15sQ7P4nq+tFF8B8CL+NKi1W7T4JZI8D3wFQnfxd rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ate1dg0h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 13:34:11 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 181HXscq170963;
        Wed, 1 Sep 2021 13:34:10 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ate1dg0gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 13:34:10 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 181HXbHw012771;
        Wed, 1 Sep 2021 17:34:09 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03wdc.us.ibm.com with ESMTP id 3atdxtr39h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 17:34:09 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 181HY8bV35193286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 17:34:09 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3B0378060;
        Wed,  1 Sep 2021 17:34:08 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 590E578064;
        Wed,  1 Sep 2021 17:34:07 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.211.58.54])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 17:34:07 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, david@gibson.dropbear.id.au
Subject: [PATCH 3/5] KVM: PPC: Book3S HV: Free allocated memory if module init fails
Date:   Wed,  1 Sep 2021 14:33:55 -0300
Message-Id: <20210901173357.3183658-4-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210901173357.3183658-1-farosas@linux.ibm.com>
References: <20210901173357.3183658-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Zdl2Y88lX3Gv5KM5W2rGfGtkwM2LXQlB
X-Proofpoint-GUID: EINkZLJ-a-JZxedlVBZy8ieSd7OFd9zA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-01_05:2021-09-01,2021-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2108310000 definitions=main-2109010100
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The module's exit function is not called when the init fails, we need
to do cleanup before returning.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index fe20074faa61..a7b82eb438f5 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5963,7 +5963,7 @@ static int kvmppc_book3s_init_hv(void)
 
 	r = kvm_init_subcore_bitmap();
 	if (r)
-		return r;
+		goto err;
 
 	/*
 	 * We need a way of accessing the XICS interrupt controller,
@@ -5978,7 +5978,8 @@ static int kvmppc_book3s_init_hv(void)
 		np = of_find_compatible_node(NULL, NULL, "ibm,opal-intc");
 		if (!np) {
 			pr_err("KVM-HV: Cannot determine method for accessing XICS\n");
-			return -ENODEV;
+			r = -ENODEV;
+			goto err;
 		}
 		/* presence of intc confirmed - node can be dropped again */
 		of_node_put(np);
@@ -5991,12 +5992,12 @@ static int kvmppc_book3s_init_hv(void)
 
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
@@ -6009,6 +6010,12 @@ static int kvmppc_book3s_init_hv(void)
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
2.29.2

