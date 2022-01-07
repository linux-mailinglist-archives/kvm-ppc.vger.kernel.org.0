Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F23487DE7
	for <lists+kvm-ppc@lfdr.de>; Fri,  7 Jan 2022 22:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiAGVAg (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 7 Jan 2022 16:00:36 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9546 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229597AbiAGVAf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 7 Jan 2022 16:00:35 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 207JbWSX029686;
        Fri, 7 Jan 2022 21:00:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=D729H6qKmUNbmToCIhVwh/rKuoaDvSyvps9gAYATpLA=;
 b=A24nlUP44yW6wENhfX9zE6OmPgitutMa+KPjabGKKsfDI5sKhP07Z5ZOrGDxDmuqhZ6K
 4JRreMNN5j6EEe20KRvGcIXwRHhGibFZsIBIHodjGz/f44FhJaTeg4NL3PeHzV8RYBX2
 /XxpGc5QWBod1kK++FOXfYal/n/0hQ/OW5Qil7UmHYQr80uekBp9ZVvop81f/CsN1Gtb
 a/mbPcWBAPwEn+lDjVd62UhuuDMLSCfwtzHUEld3cmlL0+s9JwWE9t2sHu0KvWsw0BGo
 N88j4At8Z+oY4nA10jJTlw0pKq1R+/G1apv+a2IpsrZRRIWHbmSzFUqpBlp0dAPjZSBE Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3depqvqp4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jan 2022 21:00:27 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 207KM9dK025081;
        Fri, 7 Jan 2022 21:00:26 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3depqvqp46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jan 2022 21:00:26 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 207KqSfn000536;
        Fri, 7 Jan 2022 21:00:25 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01dal.us.ibm.com with ESMTP id 3de5fqcksr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jan 2022 21:00:25 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 207L0M6A20447638
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Jan 2022 21:00:22 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 838D77806A;
        Fri,  7 Jan 2022 21:00:22 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC2F57806D;
        Fri,  7 Jan 2022 21:00:20 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.211.59.174])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  7 Jan 2022 21:00:20 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v3 1/6] KVM: PPC: Book3S HV: Stop returning internal values to userspace
Date:   Fri,  7 Jan 2022 18:00:07 -0300
Message-Id: <20220107210012.4091153-2-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107210012.4091153-1-farosas@linux.ibm.com>
References: <20220107210012.4091153-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GQaXyIZyBcaheGoonQPufl7icLiJdLmc
X-Proofpoint-GUID: FASKz6AvXj6XvjaOFhrC_iC5o5e9jlCc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-07_09,2022-01-07_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 malwarescore=0 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201070125
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Our kvm_arch_vcpu_ioctl_run currently returns the RESUME_HOST values
to userspace, against the API of the KVM_RUN ioctl which returns 0 on
success.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
---
This was noticed while enabling the kvm selftests for powerpc. There's
an assert at the _vcpu_run function when we return a value different
from the expected.
---
 arch/powerpc/kvm/powerpc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index a72920f4f221..1e130bb087c4 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -1849,6 +1849,14 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 #ifdef CONFIG_ALTIVEC
 out:
 #endif
+
+	/*
+	 * We're already returning to userspace, don't pass the
+	 * RESUME_HOST flags along.
+	 */
+	if (r > 0)
+		r = 0;
+
 	vcpu_put(vcpu);
 	return r;
 }
-- 
2.33.1

