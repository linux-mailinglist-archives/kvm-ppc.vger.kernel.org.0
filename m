Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85155486AD1
	for <lists+kvm-ppc@lfdr.de>; Thu,  6 Jan 2022 21:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243556AbiAFUDb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 6 Jan 2022 15:03:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44818 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243552AbiAFUDa (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 6 Jan 2022 15:03:30 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 206I27NB017406;
        Thu, 6 Jan 2022 20:03:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zATVJKLGjj7/huZ8r7rtTXJgr9JKqKZKcWqqySRdKJM=;
 b=tOpwWfo5EYH8PCb4+/Fk1+sk1lHt7s+TXJt2X1k1+HpBzvd8ey4yUq6DbWIBbzL9DW8i
 j4jJcUrAZg6O5M6jWPVgUEzb84FrPYE4Ba/pryrl2JvJXwc5cwzXc3EKlSsc7X1LBSM8
 BpA2QBjFMWaYSfkd5phoKb68+M6XYh2PbDkNCGA1HH6GKA/YEUXpvUsvod6eiJ9MWi1i
 S6LldKCQvd+g39S1842h6GrjDJO9wKBRneIt5K1YAaK38VbxY4uvxRK6OXF1HNYy4ZWE
 /N00digXcCItldtFdCrbOMF9qIX4M0JLZm77vrLJL7sYvXpsWqGVRJeW4fBtGpsrlH4e XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3de5bq9yg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 20:03:24 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 206K0vl4017961;
        Thu, 6 Jan 2022 20:03:23 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3de5bq9yfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 20:03:23 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 206JvugX030956;
        Thu, 6 Jan 2022 20:03:22 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 3de5fpj4he-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 20:03:22 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 206K3L8p13631886
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jan 2022 20:03:21 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5520EBE051;
        Thu,  6 Jan 2022 20:03:21 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79AD1BE04F;
        Thu,  6 Jan 2022 20:03:19 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.211.150.192])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  6 Jan 2022 20:03:19 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v2 4/7] KVM: PPC: Don't use pr_emerg when mmio emulation fails
Date:   Thu,  6 Jan 2022 17:03:01 -0300
Message-Id: <20220106200304.4070825-5-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220106200304.4070825-1-farosas@linux.ibm.com>
References: <20220106200304.4070825-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jnqzZPNzc0NWLBqMppKAxHm_gmxIHOSN
X-Proofpoint-ORIG-GUID: San99yTkMiRvKjaQm51iSKm8pgSBHl1e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-06_08,2022-01-06_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 impostorscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 clxscore=1015 bulkscore=0 adultscore=0 phishscore=0
 mlxlogscore=919 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201060126
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

If MMIO emulation fails we deliver a Program interrupt to the
guest. This is a normal event for the host, so use pr_info.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/powerpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 0b0818d032e1..3fc8057db4b4 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -308,7 +308,7 @@ int kvmppc_emulate_mmio(struct kvm_vcpu *vcpu)
 
 		kvmppc_get_last_inst(vcpu, INST_GENERIC, &last_inst);
 		/* XXX Deliver Program interrupt to guest. */
-		pr_emerg("%s: emulation failed (%08x)\n", __func__, last_inst);
+		pr_info("%s: emulation failed (%08x)\n", __func__, last_inst);
 		r = RESUME_HOST;
 		break;
 	}
-- 
2.33.1

