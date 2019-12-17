Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59146123864
	for <lists+kvm-ppc@lfdr.de>; Tue, 17 Dec 2019 22:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfLQVHf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 17 Dec 2019 16:07:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9298 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726634AbfLQVHf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 17 Dec 2019 16:07:35 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHKw0Li045694;
        Tue, 17 Dec 2019 16:07:22 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wy46cvduj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 16:07:22 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xBHL7CWf003720;
        Tue, 17 Dec 2019 21:07:21 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02dal.us.ibm.com with ESMTP id 2wvqc6qgy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 21:07:21 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBHL7KOV51511682
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 21:07:20 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6632EAE05F;
        Tue, 17 Dec 2019 21:07:20 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 118F0AE063;
        Tue, 17 Dec 2019 21:07:19 +0000 (GMT)
Received: from LeoBras.aus.stglabs.ibm.com (unknown [9.18.235.137])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 17 Dec 2019 21:07:18 +0000 (GMT)
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Leonardo Bras <leonardo@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        farosas@linux.ibm.com, aik@ozlabs.ru
Subject: [PATCH 1/1] kvm/book3s_64: Fixes crash caused by not cleaning vhost IOTLB
Date:   Tue, 17 Dec 2019 18:06:58 -0300
Message-Id: <20191217210658.73144-1-leonardo@linux.ibm.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_04:2019-12-17,2019-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 suspectscore=2 mlxlogscore=999 spamscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912170168
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Fixes a bug that happens when a virtual machine is created without DDW,
with vhost supporting a virtio-net device.

In this scenario, an IOMMU with 32-bit DMA window will possibly map
IOVA's to different memory addresses.

As the code works today, H_STUFF_TCE hypercall will be dealt only with
kvm code, which does not invalidate the IOTLB entry in vhost, meaning
that at some point, and old entry can cause an access to a previous
memory address that IOVA pointed.

Example:
- virtio-net passes IOVA N to vhost, which point to M1
- vhost tries IOTLB, but miss
- vhost translates IOVA N and stores result to IOTLB
- vhost writes to M1
- (some IOMMU usage)
- virtio-net passes IOVA N to vhost, which now points to M2
- vhost tries IOTLB, and translates IOVA N to M1
- vhost writes to M1 <error, should write to M2>

The reason why this error was not so evident, is probably because the
IOTLB was small enough to almost always miss at the point an IOVA was
reused. Raising the IOTLB size to 32k (which is a module parameter that
defaults to 2k) is enough to reproduce the bug in +90% of the runs.
It usually takes less than 10 seconds of netperf to cause this bug
to happen.

A few minutes after reproducing this bug, the guest usually crash.

Fixing this bug involves cleaning a IOVA entry from IOTLB.
The guest kernel trigger this by doing a H_STUFF_TCE hypercall with
tce_value == 0.

This change fixes this bug by returning H_TOO_HARD on kvmppc_h_stuff_tce
when tce_value == 0, which causes kvm to let qemu deal with this.
In this case, qemu does free the vhost IOTLB entry, which fixes the bug.

Signed-off-by: Leonardo Bras <leonardo@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_64_vio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 883a66e76638..841eff3f6392 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -710,6 +710,9 @@ long kvmppc_h_stuff_tce(struct kvm_vcpu *vcpu,
 	if (ret != H_SUCCESS)
 		return ret;
 
+	if (tce_value == 0)
+		return H_TOO_HARD;
+
 	/* Check permission bits only to allow userspace poison TCE for debug */
 	if (tce_value & (TCE_PCI_WRITE | TCE_PCI_READ))
 		return H_PARAMETER;
-- 
2.23.0

