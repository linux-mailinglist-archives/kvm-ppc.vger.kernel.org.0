Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E03AF354A
	for <lists+kvm-ppc@lfdr.de>; Thu,  7 Nov 2019 18:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729701AbfKGRD1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 7 Nov 2019 12:03:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46612 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727606AbfKGRD1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 7 Nov 2019 12:03:27 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA7GsG0T144728;
        Thu, 7 Nov 2019 12:03:12 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w4nfans6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 12:03:10 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xA7H1Yvb030675;
        Thu, 7 Nov 2019 17:03:04 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 2w41ujmptj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 17:03:04 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA7H34CT52167014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Nov 2019 17:03:04 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EAADCAE064;
        Thu,  7 Nov 2019 17:03:03 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D78E8AE060;
        Thu,  7 Nov 2019 17:03:02 +0000 (GMT)
Received: from LeoBras.br.ibm.com (unknown [9.18.235.40])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu,  7 Nov 2019 17:03:02 +0000 (GMT)
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc:     Leonardo Bras <leonardo@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH v2 1/4] powerpc/kvm/book3s: Fixes possible 'use after release' of kvm
Date:   Thu,  7 Nov 2019 14:02:55 -0300
Message-Id: <20191107170258.36379-2-leonardo@linux.ibm.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191107170258.36379-1-leonardo@linux.ibm.com>
References: <20191107170258.36379-1-leonardo@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-07_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=887 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911070159
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Fixes a possible 'use after free' of kvm variable in
kvm_vm_ioctl_create_spapr_tce, where it does a mutex_unlock(&kvm->lock)
after a kvm_put_kvm(kvm).

Signed-off-by: Leonardo Bras <leonardo@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_64_vio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 5834db0a54c6..a402ead833b6 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -316,14 +316,13 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
 
 	if (ret >= 0)
 		list_add_rcu(&stt->list, &kvm->arch.spapr_tce_tables);
-	else
-		kvm_put_kvm(kvm);
 
 	mutex_unlock(&kvm->lock);
 
 	if (ret >= 0)
 		return ret;
 
+	kvm_put_kvm(kvm);
 	kfree(stt);
  fail_acct:
 	account_locked_vm(current->mm, kvmppc_stt_pages(npages), false);
-- 
2.23.0

