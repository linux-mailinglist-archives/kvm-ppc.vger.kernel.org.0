Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C120447E903
	for <lists+kvm-ppc@lfdr.de>; Thu, 23 Dec 2021 22:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350333AbhLWVUg (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 23 Dec 2021 16:20:36 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33110 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233222AbhLWVUf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 23 Dec 2021 16:20:35 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BNLBjFs030317;
        Thu, 23 Dec 2021 21:20:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=t14t2vj/S6GC1hZeq8psc24jMksUbqcWz8p32ljojM0=;
 b=VT4gGb3J2iYR2G3pq6F95YJ0BBo6YgY3TaitAm4d+40JYN5qmjeUxuD1eGyeyJow98I4
 J0g7HStPo028ZA7Fb4wQnpinEUbyt87Fw//aiQSi0uPM8NDfpiG3qLrx5IF/IUGFPT1n
 yPo3kbY6Uyd8WieUH/OuyVE5CJktzJM6QZFI51UTTBSip2TfUpi5T9crIN0qiiievxzq
 41yNzNSy8JWMkQCXgXcyCbsybbmHQNmHB1ouz9ks2UObu4qn+q6oOajhIgMq25uussPK
 PfWKxClX84PkQTW39Nj495r9Eo1sHCSAli6yRstNy6SFC3IoZ/fRwTTEQQoebfxtoDJN ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d50te83yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Dec 2021 21:20:27 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BNLCOlL031386;
        Thu, 23 Dec 2021 21:20:27 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d50te83y5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Dec 2021 21:20:27 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BNLKIsS016542;
        Thu, 23 Dec 2021 21:20:26 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 3d179cqdtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Dec 2021 21:20:26 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BNLJcf728049728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 21:19:38 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEA6DBE063;
        Thu, 23 Dec 2021 21:19:38 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECA84BE05D;
        Thu, 23 Dec 2021 21:19:36 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.163.19.83])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 23 Dec 2021 21:19:36 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com
Subject: [PATCH 2/3] KVM: PPC: Book3S HV: Delay setting of kvm ops
Date:   Thu, 23 Dec 2021 18:19:30 -0300
Message-Id: <20211223211931.3560887-3-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211223211931.3560887-1-farosas@linux.ibm.com>
References: <20211223211931.3560887-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JFOmQZ0HQsOqR0YOVZBiWcB3citxsPz0
X-Proofpoint-GUID: _phdkWjETO7giu6CqoiNPz03Hx1fUGsU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-23_04,2021-12-22_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=853 malwarescore=0 priorityscore=1501 mlxscore=0 phishscore=0
 impostorscore=0 adultscore=0 clxscore=1015 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112230106
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Delay the setting of kvm_hv_ops until after all init code has
completed. This avoids leaving the ops still accessible if the init
fails.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 9f4765951733..53400932f5d8 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -6087,9 +6087,6 @@ static int kvmppc_book3s_init_hv(void)
 	}
 #endif
 
-	kvm_ops_hv.owner = THIS_MODULE;
-	kvmppc_hv_ops = &kvm_ops_hv;
-
 	init_default_hcalls();
 
 	init_vcore_lists();
@@ -6105,10 +6102,15 @@ static int kvmppc_book3s_init_hv(void)
 	}
 
 	r = kvmppc_uvmem_init();
-	if (r < 0)
+	if (r < 0) {
 		pr_err("KVM-HV: kvmppc_uvmem_init failed %d\n", r);
+		return r;
+	}
 
-	return r;
+	kvm_ops_hv.owner = THIS_MODULE;
+	kvmppc_hv_ops = &kvm_ops_hv;
+
+	return 0;
 }
 
 static void kvmppc_book3s_exit_hv(void)
-- 
2.33.1

