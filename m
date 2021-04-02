Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB8B3529A6
	for <lists+kvm-ppc@lfdr.de>; Fri,  2 Apr 2021 12:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbhDBKV4 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 2 Apr 2021 06:21:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41006 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229553AbhDBKVz (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 2 Apr 2021 06:21:55 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 132A4BB2055741;
        Fri, 2 Apr 2021 06:21:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=3qnGUXmqwCWgooqZMftpfW1Vtoke/9Nr6w55XiJTdhI=;
 b=cdHfhRpN0UsED+pBcLyVdIe88jDbkW2yqHCoeZBrJVzh4TD2NCkQIHQ60G4hzNHnd1qX
 SwMm0cUrcqcDwTGk1XLMukADA9lSY8EtWCmdj0+35iM5yRUNR4eLvpmLHcVqEUMPzoP8
 nfUx3sFLzgnS41bMLtDipN5jBWmQNdGO6+zyyTM3x3dQECA9DRuadmdNLlVYYGpH/6Z5
 Bmi5K8QDbMXVNAinMQGufc0bOAIIiGJ3VVvmfX9MSeb7RGNqGYz/OSvchehE4wBzr5b8
 AYKh8sXDURtPOx5q/kBb3cCs47EJfldLRUrYJylJ68+z7R0dkIzcngmdPYiLeSOSH615 kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37n8r13e8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Apr 2021 06:21:41 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 132A5Z5L060926;
        Fri, 2 Apr 2021 06:21:40 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37n8r13e7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Apr 2021 06:21:40 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 132AJEv1028078;
        Fri, 2 Apr 2021 10:21:37 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 37n28w0n3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Apr 2021 10:21:37 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 132ALEX336110670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Apr 2021 10:21:15 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD932A405C;
        Fri,  2 Apr 2021 10:21:34 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37189A4054;
        Fri,  2 Apr 2021 10:21:30 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.102.3.66])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri,  2 Apr 2021 10:21:29 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Fri, 02 Apr 2021 15:51:28 +0530
From:   Vaibhav Jain <vaibhav@linux.ibm.com>
To:     qemu-devel@nongnu.org, kvm-ppc@vger.kernel.org,
        qemu-ppc@nongnu.org, david@gibson.dropbear.id.au, mst@redhat.com,
        imammedo@redhat.com, xiaoguangrong.eric@gmail.com
Cc:     Vaibhav Jain <vaibhav@linux.ibm.com>, shivaprasadbhat@gmail.com,
        bharata@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com,
        groug@kaod.org, ehabkost@redhat.com, marcel.apfelbaum@gmail.com
Subject: [PATCH v3] ppc/spapr: Add support for implement support for H_SCM_HEALTH
Date:   Fri,  2 Apr 2021 15:51:28 +0530
Message-Id: <20210402102128.213943-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sqZztXwxsX2TAsEqAkkW_I2kjhKkWK2r
X-Proofpoint-GUID: Wp8Fm3F--AF7gGrkHb4GqFCNL73XSVrR
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-02_06:2021-04-01,2021-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104020070
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
    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/powerpc/papr_hcalls.rst#n220
[2] "powerpc/papr_scm: Mark nvdimm as unarmed if needed during probe"
    https://lore.kernel.org/linux-nvdimm/20210329113103.476760-1-vaibhav@linux.ibm.com/

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
Changelog

v3:
* Switched to PPC_BIT macro for definitions of the health bits. [ Greg, David ]
* Updated h_scm_health() to use a const uint64_t to denote supported
  bits in 'hbitmap_mask'.
* Fixed an error check for drc->dev to return H_PARAMETER in case nvdimm
  is not yet plugged in [ Greg ]
* Fixed an wrong error check for ensuring drc and drc-type are correct
  [ Greg ]

v2:
* Added a check for drc->dev to ensure that the dimm is plugged in
  when servicing H_SCM_HEALTH. [ Shiva ]
* Instead of accessing the 'nvdimm->unarmed' member directly use the
  object_property_get_bool accessor to fetch it. [ Shiva ]
* Update the usage of PAPR_PMEM_UNARMED* macros [ Greg ]
* Updated patch description reference#1 to point appropriate section
  in the documentation. [ Greg ]
---
 hw/ppc/spapr_nvdimm.c  | 36 ++++++++++++++++++++++++++++++++++++
 include/hw/ppc/spapr.h |  3 ++-
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
index b46c36917c..252204e25f 100644
--- a/hw/ppc/spapr_nvdimm.c
+++ b/hw/ppc/spapr_nvdimm.c
@@ -31,6 +31,10 @@
 #include "qemu/range.h"
 #include "hw/ppc/spapr_numa.h"
 
+/* DIMM health bitmap bitmap indicators. Taken from kernel's papr_scm.c */
+/* SCM device is unable to persist memory contents */
+#define PAPR_PMEM_UNARMED PPC_BIT(0)
+
 bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
                            uint64_t size, Error **errp)
 {
@@ -467,6 +471,37 @@ static target_ulong h_scm_unbind_all(PowerPCCPU *cpu, SpaprMachineState *spapr,
     return H_SUCCESS;
 }
 
+static target_ulong h_scm_health(PowerPCCPU *cpu, SpaprMachineState *spapr,
+                                 target_ulong opcode, target_ulong *args)
+{
+
+    NVDIMMDevice *nvdimm;
+    uint64_t hbitmap = 0;
+    uint32_t drc_index = args[0];
+    SpaprDrc *drc = spapr_drc_by_index(drc_index);
+    const uint64_t hbitmap_mask = PAPR_PMEM_UNARMED;
+
+
+    /* Ensure that the drc is valid & is valid PMEM dimm and is plugged in */
+    if (!drc || !drc->dev ||
+        spapr_drc_type(drc) != SPAPR_DR_CONNECTOR_TYPE_PMEM) {
+        return H_PARAMETER;
+    }
+
+    nvdimm = NVDIMM(drc->dev);
+
+    /* Update if the nvdimm is unarmed and send its status via health bitmaps */
+    if (object_property_get_bool(OBJECT(nvdimm), NVDIMM_UNARMED_PROP, NULL)) {
+        hbitmap |= PAPR_PMEM_UNARMED;
+    }
+
+    /* Update the out args with health bitmap/mask */
+    args[0] = hbitmap;
+    args[1] = hbitmap_mask;
+
+    return H_SUCCESS;
+}
+
 static void spapr_scm_register_types(void)
 {
     /* qemu/scm specific hcalls */
@@ -475,6 +510,7 @@ static void spapr_scm_register_types(void)
     spapr_register_hypercall(H_SCM_BIND_MEM, h_scm_bind_mem);
     spapr_register_hypercall(H_SCM_UNBIND_MEM, h_scm_unbind_mem);
     spapr_register_hypercall(H_SCM_UNBIND_ALL, h_scm_unbind_all);
+    spapr_register_hypercall(H_SCM_HEALTH, h_scm_health);
 }
 
 type_init(spapr_scm_register_types)
diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index 47cebaf3ac..6e1eafb05d 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -538,8 +538,9 @@ struct SpaprMachineState {
 #define H_SCM_BIND_MEM          0x3EC
 #define H_SCM_UNBIND_MEM        0x3F0
 #define H_SCM_UNBIND_ALL        0x3FC
+#define H_SCM_HEALTH            0x400
 
-#define MAX_HCALL_OPCODE        H_SCM_UNBIND_ALL
+#define MAX_HCALL_OPCODE        H_SCM_HEALTH
 
 /* The hcalls above are standardized in PAPR and implemented by pHyp
  * as well.
-- 
2.30.2

