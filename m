Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD93346015
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 14:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhCWNsG (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 23 Mar 2021 09:48:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50610 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230316AbhCWNr6 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 23 Mar 2021 09:47:58 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12NDX104135950;
        Tue, 23 Mar 2021 09:47:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=DVvOGRZJuX8wj/UKpBycg8EvqXUyY8hWOaM6pEpbX/c=;
 b=RQ3PoWmqw1qlSGDFyXL9nZviWIQHpYlmFYGJgrIlFRmvvS6hUO9Jcxw2AyF262DwOwHJ
 QlN5PepW6UuVBa4dJFR82gxxE9gMONDNub63Hs6n5IR4OqmhE1bo8OQPEBUugXGqTOhe
 I74eFInGuDLDvKdiesg3PPadtO1eK3Z8F5BNpB0YifQPNTzSoweQRz0klIew5g2RVOvx
 7M6yq27GK2i1ufbW6LhXCuQmKQab6dFD4j2ETRc8wdWp69RjOlLUVEIBvbikjjgkIoGe
 a+Rlvk+T3U5wUYh2mqr2V0f8VMsgGT2JGB+PEB/HB+PS9w7Gw6XPVxTIvUWcqmtHMEiI 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37ef6nckgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 09:47:32 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12NDXPFG137235;
        Tue, 23 Mar 2021 09:47:31 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37ef6nckfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 09:47:31 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12NDlCrp031026;
        Tue, 23 Mar 2021 13:47:29 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 37d9bpss1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 13:47:28 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12NDlQoH38469996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 13:47:26 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9BA911C050;
        Tue, 23 Mar 2021 13:47:26 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A44FA11C04C;
        Tue, 23 Mar 2021 13:47:24 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.40.192.207])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Mar 2021 13:47:24 +0000 (GMT)
Subject: [PATCH v3 1/3] spapr: nvdimm: Forward declare and move the
 definitions
From:   Shivaprasad G Bhat <sbhat@linux.ibm.com>
To:     sbhat@linux.vnet.ibm.com, david@gibson.dropbear.id.au,
        groug@kaod.org, qemu-ppc@nongnu.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, mst@redhat.com, imammedo@redhat.com,
        xiaoguangrong.eric@gmail.com
Cc:     qemu-devel@nongnu.org, aneesh.kumar@linux.ibm.com,
        linux-nvdimm@lists.01.org, kvm-ppc@vger.kernel.org,
        shivaprasadbhat@gmail.com, bharata@linux.vnet.ibm.com
Date:   Tue, 23 Mar 2021 09:47:23 -0400
Message-ID: <161650723903.2959.2652600316416885453.stgit@6532096d84d3>
In-Reply-To: <161650723087.2959.8703728357980727008.stgit@6532096d84d3>
References: <161650723087.2959.8703728357980727008.stgit@6532096d84d3>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-23_06:2021-03-22,2021-03-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 spamscore=0 malwarescore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103230100
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The subsequent patches add definitions which tend to
get the compilation to cyclic dependency. So, prepare
with forward declarations, move the defitions and clean up.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 hw/ppc/spapr_nvdimm.c         |   12 ++++++++++++
 include/hw/ppc/spapr_nvdimm.h |   21 ++++++---------------
 2 files changed, 18 insertions(+), 15 deletions(-)

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
index 73be250e2a..abcacda5d7 100644
--- a/include/hw/ppc/spapr_nvdimm.h
+++ b/include/hw/ppc/spapr_nvdimm.h
@@ -11,23 +11,14 @@
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
+struct SpaprDrc;
+struct SpaprMachineState;
 
-int spapr_pmem_dt_populate(SpaprDrc *drc, SpaprMachineState *spapr,
-                           void *fdt, int *fdt_start_offset, Error **errp);
-void spapr_dt_persistent_memory(SpaprMachineState *spapr, void *fdt);
+int spapr_pmem_dt_populate(struct SpaprDrc *drc,
+                           struct SpaprMachineState *spapr, void *fdt,
+                           int *fdt_start_offset, Error **errp);
+void spapr_dt_persistent_memory(struct SpaprMachineState *spapr, void *fdt);
 bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
                            uint64_t size, Error **errp);
 void spapr_add_nvdimm(DeviceState *dev, uint64_t slot);


