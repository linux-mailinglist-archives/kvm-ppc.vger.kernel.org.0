Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBD4350B7C
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 03:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhDABGT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 31 Mar 2021 21:06:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17618 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229486AbhDABF4 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 31 Mar 2021 21:05:56 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13113YIj111381;
        Wed, 31 Mar 2021 21:05:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=lqGRzVm48nouvVTLixPfttRJPvqeBGwFOk4tCZ8RI+s=;
 b=VK6gntUqwjcJNMGYeAE3rvn0zQJLI7p00QyOkBppTPRwltnLs/yYx+NmKutxQ8MwNXGd
 PdV12/mI7sM+E6plQN/wkH/xKEB7neBg0Be8MY75ouHhPlXi0KSRyHzBxC/AUUuEvWEH
 tAW/pv4Z4nzhunKIEq+7cDrYlEYoLDyJuKPPD776kSWZsivuzuuriBRWKK0eapCDQqT0
 Y6APwTtuzlHDqj6/hn16PInEUXBfEjWk/EkERKatmJV8C1AgOJXWslN/yzyRAA4TCdey
 xBLW/aZ1EIxb4k9SLxA2IMHnWHsiyp17PkA36goedpPPMSqAFT9bI7eHTf/m1K9wgjqE zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37n2edabm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 21:05:30 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1311599j118797;
        Wed, 31 Mar 2021 21:05:30 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37n2edabkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 21:05:30 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1310w7lY030504;
        Thu, 1 Apr 2021 01:05:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 37n28tr2be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Apr 2021 01:05:28 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 131155Ik26280294
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Apr 2021 01:05:05 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39AF8AE045;
        Thu,  1 Apr 2021 01:05:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CC0DAE057;
        Thu,  1 Apr 2021 01:05:21 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.199.43.15])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu,  1 Apr 2021 01:05:20 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Thu, 01 Apr 2021 06:35:20 +0530
From:   Vaibhav Jain <vaibhav@linux.ibm.com>
To:     qemu-devel@nongnu.org, kvm-ppc@vger.kernel.org,
        qemu-ppc@nongnu.org, david@gibson.dropbear.id.au, mst@redhat.com,
        imammedo@redhat.com, xiaoguangrong.eric@gmail.com
Cc:     Vaibhav Jain <vaibhav@linux.ibm.com>, shivaprasadbhat@gmail.com,
        bharata@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com,
        groug@kaod.org, ehabkost@redhat.com, marcel.apfelbaum@gmail.com
Subject: [PATCH v2] ppc/spapr: Add support for implement support for H_SCM_HEALTH
Date:   Thu,  1 Apr 2021 06:35:19 +0530
Message-Id: <20210401010519.7225-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uDpwi3j0r4DXPqXow9P6f_3Y3rdCSgSp
X-Proofpoint-GUID: LErx0t8uYbRbtOyN-vR0khyzSqv2Q-DP
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-31_11:2021-03-31,2021-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 impostorscore=0 adultscore=0 clxscore=1015 spamscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104010004
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

v2:
* Added a check for drc->dev to ensure that the dimm is plugged in
  when servicing H_SCM_HEALTH. [ Shiva ]
* Instead of accessing the 'nvdimm->unarmed' member directly use the
  object_property_get_bool accessor to fetch it. [ Shiva ]
* Update the usage of PAPR_PMEM_UNARMED* macros [ Greg ]
* Updated patch description reference#1 to point appropriate section
  in the documentation. [ Greg ]
---
 hw/ppc/spapr_nvdimm.c  | 38 ++++++++++++++++++++++++++++++++++++++
 include/hw/ppc/spapr.h |  3 ++-
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
index b46c36917c..34096e4718 100644
--- a/hw/ppc/spapr_nvdimm.c
+++ b/hw/ppc/spapr_nvdimm.c
@@ -31,6 +31,13 @@
 #include "qemu/range.h"
 #include "hw/ppc/spapr_numa.h"
 
+/* DIMM health bitmap bitmap indicators. Taken from kernel's papr_scm.c */
+/* SCM device is unable to persist memory contents */
+#define PAPR_PMEM_UNARMED (1ULL << (63 - 0))
+
+/* Bits status indicators for health bitmap indicating unarmed dimm */
+#define PAPR_PMEM_UNARMED_MASK (PAPR_PMEM_UNARMED)
+
 bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
                            uint64_t size, Error **errp)
 {
@@ -467,6 +474,36 @@ static target_ulong h_scm_unbind_all(PowerPCCPU *cpu, SpaprMachineState *spapr,
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
+    /* Ensure that the dimm is plugged in */
+    if (!drc->dev) {
+        return H_HARDWARE;
+    }
+
+    nvdimm = NVDIMM(drc->dev);
+
+    args[0] = 0;
+    /* Check if the nvdimm is unarmed and send its status via health bitmaps */
+    if (object_property_get_bool(OBJECT(nvdimm), NVDIMM_UNARMED_PROP, NULL)) {
+        args[0] |= PAPR_PMEM_UNARMED;
+    }
+
+    /* Update the health bitmap with the applicable mask */
+    args[1] = PAPR_PMEM_UNARMED_MASK;
+
+    return H_SUCCESS;
+}
+
 static void spapr_scm_register_types(void)
 {
     /* qemu/scm specific hcalls */
@@ -475,6 +512,7 @@ static void spapr_scm_register_types(void)
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

