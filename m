Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99F034D4DE
	for <lists+kvm-ppc@lfdr.de>; Mon, 29 Mar 2021 18:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhC2QYA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 29 Mar 2021 12:24:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61312 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231192AbhC2QX3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 29 Mar 2021 12:23:29 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12TG5sO9137869;
        Mon, 29 Mar 2021 12:23:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=Hx3fi2Q+P4ksONsGgd+byzzB7qT+hU6hrNzx9nEi/mQ=;
 b=H1Zde1GyQ8Rn/d0RuS8PCuDv3SZw22eqMmZco/lUrta2OrNUYFGacmsKrWGC5ttwGZa7
 YWGQdAS9QiMIJIE/f4oG54JMDs4QOF3ozlX2bvwxmTbFOiZYIhKFnrBVbYoU5HTypvd9
 XyNq66AmSLerYnUGlVrFt32+RyhdxEnTxk/XkMzKZeeGxuZDvoU4wgoS7xl+OqjyTy0h
 O2iNErbwvvsQHglOTZYhqltGYY3zJd+NXrrxBNhgDwLHU24TZraJ8QL5pmpWfJ9qy9Pw
 cZhGzVri9Lg3PxufEinQC3I2gPAA22IbNvARHmi1UAywc8kyaXegwLB7b1ftY59CYtyE 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jhsrwf1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 12:23:18 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12TG6ggF140806;
        Mon, 29 Mar 2021 12:23:18 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jhsrwf0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 12:23:17 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12TGHYVB027108;
        Mon, 29 Mar 2021 16:23:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 37huyh91n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 16:23:15 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12TGNCRU21561606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 16:23:12 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E764C52051;
        Mon, 29 Mar 2021 16:23:11 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.199.32.234])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 2782152054;
        Mon, 29 Mar 2021 16:23:07 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Mon, 29 Mar 2021 21:53:01 +0530
From:   Vaibhav Jain <vaibhav@linux.ibm.com>
To:     qemu-devel@nongnu.org, kvm-ppc@vger.kernel.org,
        qemu-ppc@nongnu.org, david@gibson.dropbear.id.au, mst@redhat.com,
        imammedo@redhat.com, xiaoguangrong.eric@gmail.com
Cc:     Vaibhav Jain <vaibhav@linux.ibm.com>, shivaprasadbhat@gmail.com,
        bharata@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com,
        groug@kaod.org, ehabkost@redhat.com, marcel.apfelbaum@gmail.com
Subject: [PATCH] ppc/spapr: Add support for implement support for H_SCM_HEALTH
Date:   Mon, 29 Mar 2021 21:52:59 +0530
Message-Id: <20210329162259.536964-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: x45TEkg21_tEQI_vfq9kbMxW333R3s48
X-Proofpoint-ORIG-GUID: plkVkfeFRB0KYvPDakx7v36qc2PKnziC
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_10:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 phishscore=0 impostorscore=0 bulkscore=0 suspectscore=0 clxscore=1011
 priorityscore=1501 mlxscore=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103290118
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Add support for H_SCM_HEALTH hcall described at [1] for spapr
nvdimms. This enables guest to detect the 'unarmed' status of a
specific spapr nvdimm identified by its DRC and if its unarmed, mark
the region backed by the nvdimm as read-only.

The patch adds h_scm_health() to handle the H_SCM_HEALTH hcall which
returns two 64-bit bitmaps (health bitmap, health bitmap mask) derived
from 'struct nvdimm->unarmed' member.

Linux kernel side changes to enable handling of 'unarmed' nvdimms for
ppc64 are proposed at [2].

References:
[1] "Hypercall Op-codes (hcalls)"
    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/powerpc/papr_hcalls.rst

[2] "powerpc/papr_scm: Mark nvdimm as unarmed if needed during probe"
    https://lore.kernel.org/linux-nvdimm/20210329113103.476760-1-vaibhav@linux.ibm.com/

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 hw/ppc/spapr_nvdimm.c  | 30 ++++++++++++++++++++++++++++++
 include/hw/ppc/spapr.h |  4 ++--
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
index b46c36917c..e38740036d 100644
--- a/hw/ppc/spapr_nvdimm.c
+++ b/hw/ppc/spapr_nvdimm.c
@@ -31,6 +31,13 @@
 #include "qemu/range.h"
 #include "hw/ppc/spapr_numa.h"
 
+/* DIMM health bitmap bitmap indicators */
+/* SCM device is unable to persist memory contents */
+#define PAPR_PMEM_UNARMED (1ULL << (63 - 0))
+
+/* Bits status indicators for health bitmap indicating unarmed dimm */
+#define PAPR_PMEM_UNARMED_MASK (PAPR_PMEM_UNARMED)
+
 bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
                            uint64_t size, Error **errp)
 {
@@ -467,6 +474,28 @@ static target_ulong h_scm_unbind_all(PowerPCCPU *cpu, SpaprMachineState *spapr,
     return H_SUCCESS;
 }
 
+static target_ulong h_scm_health(PowerPCCPU *cpu, SpaprMachineState *spapr,
+                                 target_ulong opcode, target_ulong *args)
+{
+    uint32_t drc_index = args[0];
+    SpaprDrc *drc = spapr_drc_by_index(drc_index);
+    NVDIMMDevice *nvdimm;
+
+    if (drc && spapr_drc_type(drc) != SPAPR_DR_CONNECTOR_TYPE_PMEM) {
+        return H_PARAMETER;
+    }
+
+    nvdimm = NVDIMM(drc->dev);
+
+    /* Check if the nvdimm is unarmed and send its status via health bitmaps */
+    args[0] = nvdimm->unarmed ? PAPR_PMEM_UNARMED_MASK : 0;
+
+    /* health bitmap mask same as the health bitmap */
+    args[1] = args[0];
+
+    return H_SUCCESS;
+}
+
 static void spapr_scm_register_types(void)
 {
     /* qemu/scm specific hcalls */
@@ -475,6 +504,7 @@ static void spapr_scm_register_types(void)
     spapr_register_hypercall(H_SCM_BIND_MEM, h_scm_bind_mem);
     spapr_register_hypercall(H_SCM_UNBIND_MEM, h_scm_unbind_mem);
     spapr_register_hypercall(H_SCM_UNBIND_ALL, h_scm_unbind_all);
+    spapr_register_hypercall(H_SCM_HEALTH, h_scm_health);
 }
 
 type_init(spapr_scm_register_types)
diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index 47cebaf3ac..18859b9ab2 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -538,8 +538,8 @@ struct SpaprMachineState {
 #define H_SCM_BIND_MEM          0x3EC
 #define H_SCM_UNBIND_MEM        0x3F0
 #define H_SCM_UNBIND_ALL        0x3FC
-
-#define MAX_HCALL_OPCODE        H_SCM_UNBIND_ALL
+#define H_SCM_HEALTH            0x400
+#define MAX_HCALL_OPCODE        H_SCM_HEALTH
 
 /* The hcalls above are standardized in PAPR and implemented by pHyp
  * as well.
-- 
2.30.2

