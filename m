Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E6549B81D
	for <lists+kvm-ppc@lfdr.de>; Tue, 25 Jan 2022 17:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1582939AbiAYP7n (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 25 Jan 2022 10:59:43 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22412 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1582823AbiAYP56 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 25 Jan 2022 10:57:58 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PFFsDm003633;
        Tue, 25 Jan 2022 15:57:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=aaIroEC29w2ZkcJtlFFdHyKeAzECiRnd1ymma3nB0Wk=;
 b=L7PHOgRoJpO6vb8qWdGvWRJKBKJVx1CT+R0vb+TBEnkPkA8uYsqqp6PO5Com5J7g2gF0
 Q5wYN2VdRlLOVH4Q1yQVb5TH6EHETP/3jYNqe6zMTalxHFg+YDxKXzHKHHmFjwWVzV0x
 yk7nSPBRylUMmCh6P/8NyFWwNIuxikqW2h3E3dMf97TPfzcLDt4ebPUGvfgvd//g0UDy
 EEhsIYAs6vWn6ZMkPz7jeJho3g1tIu3kjMPWEPXmlnPnvZhxbrEGvIAoEnWxvisst/OY
 LnjcoIkRznIIMKQvbcPWeRXpvqLEvRZBfK6vqmZPD22tTqbhrXC/hIVL6E6tUEdUMdMl Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dthehvbum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 15:57:49 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20PFP7iw010365;
        Tue, 25 Jan 2022 15:57:49 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dthehvbu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 15:57:49 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20PFvCdx015266;
        Tue, 25 Jan 2022 15:57:48 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04dal.us.ibm.com with ESMTP id 3dr9jadw80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 15:57:48 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20PFvk9x33882430
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 15:57:46 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9956BC6066;
        Tue, 25 Jan 2022 15:57:46 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C064AC6063;
        Tue, 25 Jan 2022 15:57:44 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.163.21.20])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jan 2022 15:57:44 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v3 2/4] KVM: PPC: Book3S HV: Delay setting of kvm ops
Date:   Tue, 25 Jan 2022 12:57:33 -0300
Message-Id: <20220125155735.1018683-3-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125155735.1018683-1-farosas@linux.ibm.com>
References: <20220125155735.1018683-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: m5uUbibtqo1PIMj8G2zx6Hhx3APndNs-
X-Proofpoint-GUID: FBhaXBB0RBWiwVB8Dp8KCuIdJjmoeiao
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_03,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=868 clxscore=1015 mlxscore=0 phishscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250100
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
index 3a3845f366d4..b9aace212599 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -6127,9 +6127,6 @@ static int kvmppc_book3s_init_hv(void)
 	}
 #endif
 
-	kvm_ops_hv.owner = THIS_MODULE;
-	kvmppc_hv_ops = &kvm_ops_hv;
-
 	init_default_hcalls();
 
 	init_vcore_lists();
@@ -6145,10 +6142,15 @@ static int kvmppc_book3s_init_hv(void)
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
2.34.1

