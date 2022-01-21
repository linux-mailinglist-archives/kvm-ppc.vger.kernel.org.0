Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1B04967D5
	for <lists+kvm-ppc@lfdr.de>; Fri, 21 Jan 2022 23:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbiAUW0w (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 21 Jan 2022 17:26:52 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9004 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233179AbiAUW0v (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 21 Jan 2022 17:26:51 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20LKXt9t013674;
        Fri, 21 Jan 2022 22:26:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ctZuzhBM6CJQJJu4zT2LTPEcoV/54KLWJ/wAADHyD90=;
 b=m/4fL7fjS4cGGe00I+Gzie17VmfxorpByFlnaVmT5X4LFmkmiJ3Dt9IhMbYthPm4UHe/
 +ULg5SoBrYwTHNtHEi4E502EE+WoCULm9x8MqnO6XjQjGKZEYGm/eGeyEKi+9kl4jBco
 jeIrJLis8EequdWHlLgicQaSeYPpHDLajaQBB/0WTVKvG3ORo7rGVy1GkAwaJ21Hlv3m
 3B1jufGbpOGl+YMY9hi0zW2GRoiI3mA1jDdDCJ9nm9M7kDvRWFU04BWFWNGrB1zqwMAv
 sdIj7NJPpxhHA1dbDnyz5SUWiZ1hlch5o1SlR0WWPo1te5JmxlW0GxoWmOMnNnmZotuR zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dr3najbcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 22:26:41 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20LMQerP005779;
        Fri, 21 Jan 2022 22:26:40 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dr3najbc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 22:26:40 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20LMMPl7009813;
        Fri, 21 Jan 2022 22:26:39 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03wdc.us.ibm.com with ESMTP id 3dr1umkvm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 22:26:39 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20LMQcFM30540104
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 22:26:38 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1577AE063;
        Fri, 21 Jan 2022 22:26:38 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00240AE060;
        Fri, 21 Jan 2022 22:26:35 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.211.81.234])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jan 2022 22:26:35 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v4 1/5] KVM: PPC: Book3S HV: Stop returning internal values to userspace
Date:   Fri, 21 Jan 2022 19:26:22 -0300
Message-Id: <20220121222626.972495-2-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220121222626.972495-1-farosas@linux.ibm.com>
References: <20220121222626.972495-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: n8LS5CotW9Ux_UcwDt3hM7rewioC0L1Y
X-Proofpoint-ORIG-GUID: Nj7LTkyLIZzUC4VdiBYFfEhBRGaOCU-V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_10,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 bulkscore=0 spamscore=0 priorityscore=1501 mlxlogscore=914 adultscore=0
 suspectscore=0 impostorscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210140
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
index 2ad0ccd202d5..50414fb2a5ea 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -1841,6 +1841,14 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
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
2.34.1

