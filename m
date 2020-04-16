Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8BEF1ACDA6
	for <lists+kvm-ppc@lfdr.de>; Thu, 16 Apr 2020 18:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391186AbgDPQ1c (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 16 Apr 2020 12:27:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40446 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728987AbgDPQ1Z (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 16 Apr 2020 12:27:25 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03GG4tln035078
        for <kvm-ppc@vger.kernel.org>; Thu, 16 Apr 2020 12:27:23 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30eswva5qn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Thu, 16 Apr 2020 12:27:23 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <ldufour@linux.ibm.com>;
        Thu, 16 Apr 2020 17:26:45 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 16 Apr 2020 17:26:42 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03GGRHhJ52428924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Apr 2020 16:27:18 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D662942041;
        Thu, 16 Apr 2020 16:27:17 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 763554204B;
        Thu, 16 Apr 2020 16:27:17 +0000 (GMT)
Received: from pomme.tlslab.ibm.com (unknown [9.145.24.8])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Apr 2020 16:27:17 +0000 (GMT)
From:   Laurent Dufour <ldufour@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     paulus@samba.org, mpe@ellerman.id.au, linux-kernel@vger.kernel.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>, benh@kernel.crashing.org
Subject: [PATCH] KVM: PPC: Book3S HV: read ibm,secure-memory nodes
Date:   Thu, 16 Apr 2020 18:27:15 +0200
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20041616-4275-0000-0000-000003C106C5
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20041616-4276-0000-0000-000038D68199
Message-Id: <20200416162715.45846-1-ldufour@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-16_06:2020-04-14,2020-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004160112
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The newly introduced ibm,secure-memory nodes supersede the
ibm,uv-firmware's property secure-memory-ranges.

Firmware will no more expose the secure-memory-ranges property so first
read the new one and if not found rollback to the older one.

Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 53b88cae3e73..ad950f8996e0 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -735,6 +735,20 @@ static u64 kvmppc_get_secmem_size(void)
 	const __be32 *prop;
 	u64 size = 0;
 
+	/*
+	 * First try the new ibm,secure-memory nodes which supersede the
+	 * secure-memory-ranges property.
+	 * If we found somes, no need to read the deprecated one.
+	 */
+	for_each_compatible_node(np, NULL, "ibm,secure-memory") {
+		prop = of_get_property(np, "reg", &len);
+		if (!prop)
+			continue;
+		size += of_read_number(prop + 2, 2);
+	}
+	if (size)
+		return size;
+
 	np = of_find_compatible_node(NULL, NULL, "ibm,uv-firmware");
 	if (!np)
 		goto out;
-- 
2.26.1

