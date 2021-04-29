Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EBA36E3E3
	for <lists+kvm-ppc@lfdr.de>; Thu, 29 Apr 2021 06:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237671AbhD2Dud (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 28 Apr 2021 23:50:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36752 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237508AbhD2Du1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 28 Apr 2021 23:50:27 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13T3WcCb075405;
        Wed, 28 Apr 2021 23:48:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=4KIMiO2sjOWXrhzviSocX+mOq7VTbf8VHLKtOnxFNLs=;
 b=kzaFabpj+8jSNwOElUrBYLB+1i7OqDVTIJWT2qTGKFNAMLtLxiOdzQykUaYeeQu4d9Rs
 G+DaEnlT31w9lTjr9C5aWojJOTP/mWoJP8rNVcTYCd8KarcuurvmGP9n2ULZAadPN3Q5
 k9jExy0Yge7IMFfblJrXXkK4rDbROAHS1umEp13VTHEZz7zCPnbHdHzrNVoE7P/Q26zQ
 frFRDKafUYZU52xmDfmMEwA0ARP1rh1LJYOiy4BS0qbTTbRLkt7B5vAPcv5UX+dwJXdH
 Q7ow9MshEJq/aCAA3LKkj8wiaOMuqGKfJFgU073zSfo8zo5IldLjYQ4TlbNLrFbemzxZ 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 387mey8s5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Apr 2021 23:48:48 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13T3jjR2160568;
        Wed, 28 Apr 2021 23:48:47 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 387mey8s4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Apr 2021 23:48:47 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13T3mPl0011851;
        Thu, 29 Apr 2021 03:48:45 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 384ay8j61k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Apr 2021 03:48:45 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13T3mfZW44499218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 03:48:41 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B882152065;
        Thu, 29 Apr 2021 03:48:41 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.40.192.207])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A29475204E;
        Thu, 29 Apr 2021 03:48:38 +0000 (GMT)
Subject: [PATCH v4 1/3] spapr: nvdimm: Forward declare and move the
 definitions
From:   Shivaprasad G Bhat <sbhat@linux.ibm.com>
To:     david@gibson.dropbear.id.au, groug@kaod.org, qemu-ppc@nongnu.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        imammedo@redhat.com, xiaoguangrong.eric@gmail.com,
        peter.maydell@linaro.org, eblake@redhat.com, qemu-arm@nongnu.org,
        richard.henderson@linaro.org, pbonzini@redhat.com,
        marcel.apfelbaum@gmail.com, stefanha@redhat.com,
        haozhong.zhang@intel.com, shameerali.kolothum.thodi@huawei.com,
        kwangwoo.lee@sk.com, armbru@redhat.com
Cc:     qemu-devel@nongnu.org, aneesh.kumar@linux.ibm.com,
        linux-nvdimm@lists.01.org, kvm-ppc@vger.kernel.org,
        shivaprasadbhat@gmail.com, bharata@linux.vnet.ibm.com
Date:   Wed, 28 Apr 2021 23:48:37 -0400
Message-ID: <161966811094.652.571342595267518155.stgit@17be908f7c1c>
In-Reply-To: <161966810162.652.13723419108625443430.stgit@17be908f7c1c>
References: <161966810162.652.13723419108625443430.stgit@17be908f7c1c>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RXI5XW7jpBirXixvyzqZy_ElNMGivRUW
X-Proofpoint-ORIG-GUID: Co3mIJMA5Dxa1gj_EHFbJHIS-Wz247RZ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-29_02:2021-04-28,2021-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290025
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The subsequent patches add definitions which tend to
get the compilation to cyclic dependency. So, prepare
with forward declarations, move the defitions and clean up.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 hw/ppc/spapr_nvdimm.c         |   12 ++++++++++++
 include/hw/ppc/spapr_nvdimm.h |   14 ++------------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
index b46c36917c..8cf3fb2ffb 100644
--- a/hw/ppc/spapr_nvdimm.c
+++ b/hw/ppc/spapr_nvdimm.c
@@ -31,6 +31,18 @@
 #include "qemu/range.h"
 #include "hw/ppc/spapr_numa.h"
 
+/*
+ * The nvdimm size should be aligned to SCM block size.
+ * The SCM block size should be aligned to SPAPR_MEMORY_BLOCK_SIZE
+ * inorder to have SCM regions not to overlap with dimm memory regions.
+ * The SCM devices can have variable block sizes. For now, fixing the
+ * block size to the minimum value.
+ */
+#define SPAPR_MINIMUM_SCM_BLOCK_SIZE SPAPR_MEMORY_BLOCK_SIZE
+
+/* Have an explicit check for alignment */
+QEMU_BUILD_BUG_ON(SPAPR_MINIMUM_SCM_BLOCK_SIZE % SPAPR_MEMORY_BLOCK_SIZE);
+
 bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
                            uint64_t size, Error **errp)
 {
diff --git a/include/hw/ppc/spapr_nvdimm.h b/include/hw/ppc/spapr_nvdimm.h
index 73be250e2a..764f999f54 100644
--- a/include/hw/ppc/spapr_nvdimm.h
+++ b/include/hw/ppc/spapr_nvdimm.h
@@ -11,19 +11,9 @@
 #define HW_SPAPR_NVDIMM_H
 
 #include "hw/mem/nvdimm.h"
-#include "hw/ppc/spapr.h"
 
-/*
- * The nvdimm size should be aligned to SCM block size.
- * The SCM block size should be aligned to SPAPR_MEMORY_BLOCK_SIZE
- * inorder to have SCM regions not to overlap with dimm memory regions.
- * The SCM devices can have variable block sizes. For now, fixing the
- * block size to the minimum value.
- */
-#define SPAPR_MINIMUM_SCM_BLOCK_SIZE SPAPR_MEMORY_BLOCK_SIZE
-
-/* Have an explicit check for alignment */
-QEMU_BUILD_BUG_ON(SPAPR_MINIMUM_SCM_BLOCK_SIZE % SPAPR_MEMORY_BLOCK_SIZE);
+typedef struct SpaprDrc SpaprDrc;
+typedef struct SpaprMachineState SpaprMachineState;
 
 int spapr_pmem_dt_populate(SpaprDrc *drc, SpaprMachineState *spapr,
                            void *fdt, int *fdt_start_offset, Error **errp);


