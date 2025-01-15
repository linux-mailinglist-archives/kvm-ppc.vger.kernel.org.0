Return-Path: <kvm-ppc+bounces-185-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E5630A11A78
	for <lists+kvm-ppc@lfdr.de>; Wed, 15 Jan 2025 08:08:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E52D7A4696
	for <lists+kvm-ppc@lfdr.de>; Wed, 15 Jan 2025 07:08:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 819F922F853;
	Wed, 15 Jan 2025 07:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cmahyoQd"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693D922FADE
	for <kvm-ppc@vger.kernel.org>; Wed, 15 Jan 2025 07:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736924895; cv=none; b=jtErKOqNmALcd5f4cQ1i8bHq7tnZcIeBpHKpLQbrUZbE9O2ayFStSKKVZx5NNTfc4td+IO9RGA68yu9IJWYvs/N5KvJXoNvP9f+6yRLaswkHYreOxs7Dj2HC8OP4ZsxOnF2Y/ZU7WqYhy0qYDtr0bdsl4k+E1LvZP9w088nv8VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736924895; c=relaxed/simple;
	bh=dVcIgbXTGAZn6/eyaCXlIvlVqCimn9nm0wO0bre1wNU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UTILoS0ZLtQIG4GfrlQdaat/ZR21RuBwPrwiW5pM3TO7GoMSZa016JoFdjuHVyfrDHwqhRyQsrBuvURbSH7BuvjwFQh7KQPFbyPTcjZ/9ePDadEYSGG2wV8XWzPLxdeO5aAWsCQ38N7cIa1oZYBxnaE/9V2MndvgwVy9JhvdZwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cmahyoQd; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50EJKnti021120;
	Wed, 15 Jan 2025 07:07:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=IcCSXCMpr848GPCFWVJIydGEJn6uK2l1QVyrBxvUa
	og=; b=cmahyoQdKtCALjRMfBOX3x0KxvixALveHg4dXLBjRyhK6hoXyc0+cGBFM
	HoX/GQ/J5WMRKpdiiEmU4FbgNejzGCck66W6u4+2dw22DfzKE31DiSemwi1CMx8x
	6mNHAH88dC5NV48N0WZbhieTQD0fl7sBapqBVo17+tmQ8a1bWDkdthsbutJtsfV+
	15+4nrKmH0Za66d27JiXUa73H0UkpJ356yp68uzk8s7YcaVR+Srnrn9wjgsBiUWx
	0MP+SLk6GVjmq+c4ESzDuBL5MWQZl7Jt0uDnRyo5rXwTevkPcdBVmYzjWA9JvbIb
	YyTJA9fALLBNFeN4xo1E4bgIqXkXA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 445m43514f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 07:07:57 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50F6uJix002387;
	Wed, 15 Jan 2025 07:07:56 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 445m43514d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 07:07:56 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50F6DaAp016976;
	Wed, 15 Jan 2025 07:07:56 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4444fk70g2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 07:07:56 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50F77pbI43319736
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jan 2025 07:07:51 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0448920040;
	Wed, 15 Jan 2025 07:07:51 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD27C20043;
	Wed, 15 Jan 2025 07:07:47 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.124.211.202])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 15 Jan 2025 07:07:47 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Wed, 15 Jan 2025 12:37:46 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: qemu-devel@nongnu.org, kvm-ppc@vger.kernel.org, qemu-ppc@nongnu.org,
        david@gibson.dropbear.id.au
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>, groug@kaod.org, npiggin@gmail.com,
        danielhb413@gmail.com, harshpb@linux.ibm.com, dantan@linux.ibm.com
Subject: [PATCH] spapr: nested: Add support for reporting Hostwide state counter
Date: Wed, 15 Jan 2025 12:37:40 +0530
Message-ID: <20250115070741.297944-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: D9f1lXr4SVaOg_DBbwUEJsVY1F5s1k7c
X-Proofpoint-GUID: NvHnSpD-tv4oACU-DBXnPH8ODTVzemPE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-15_02,2025-01-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 malwarescore=0 impostorscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501 clxscore=1011
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501150051

Add support for reporting Hostwide state counters for nested KVM pseries
guests running with 'cap-nested-hv' with Qemu-TCG acting as
L0-hypervisor. sPAPR supports reporting various stats counters for
Guest-Management-Area(GMA) thats owned by L0-Hypervisor and are documented
at [1]. These stats counters are exposed via a new bit-flag named
'getHostWideState' for the H_GUEST_GET_STATE hcall. Once this flag is set
the hcall should populate the Guest-State-Elements in the requested GSB
with the stat counter values. Currently following five counters are
supported:

* host_heap		: The currently used bytes in the
			  Hypervisor's Guest Management Space
			  associated with the Host Partition.
* host_heap_max		: The maximum bytes available in the
			  Hypervisor's Guest Management Space
			  associated with the Host Partition.
* host_pagetable	: The currently used bytes in the
			  Hypervisor's Guest Page Table Management
			  Space associated with the Host Partition.
* host_pagetable_max	: The maximum bytes available in the
			  Hypervisor's Guest Page Table Management
			  Space associated with the Host Partition.
* host_pagetable_reclaim: The amount of space in bytes that has
			  been reclaimed due to overcommit in the
			  Hypervisor's Guest Page Table Management
			  Space associated with the Host Partition.

At the moment '0' is being reported for all these counters as these
counters doesnt align with how L0-Qemu manages Guest memory.

The patch implements support for these counters by adding new members to
the 'struct SpaprMachineStateNested'. These new members are then plugged
into the existing 'guest_state_element_types[]' with the help of a new
macro 'GSBE_MACHINE_NESTED_DW' together with a new helper
'get_machine_ptr()'. guest_state_request_check() is updated to ensure
correctness of the requested GSB and finally h_guest_getset_state() is
updated to handle the newly introduced flag
'GUEST_STATE_REQUEST_HOST_WIDE'.

This patch is tested with the proposed linux-kernel implementation to
expose these stat-counter as perf-events at [2].

[2]
https://lore.kernel.org/all/20241222140247.174998-1-vaibhav@linux.ibm.com

[1]
https://lore.kernel.org/all/20241222140247.174998-2-vaibhav@linux.ibm.com

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 hw/ppc/spapr_nested.c         | 82 ++++++++++++++++++++++++++---------
 include/hw/ppc/spapr_nested.h | 36 ++++++++++++---
 2 files changed, 93 insertions(+), 25 deletions(-)

diff --git a/hw/ppc/spapr_nested.c b/hw/ppc/spapr_nested.c
index 7def8eb73b..d912b99e92 100644
--- a/hw/ppc/spapr_nested.c
+++ b/hw/ppc/spapr_nested.c
@@ -64,10 +64,9 @@ static
 SpaprMachineStateNestedGuest *spapr_get_nested_guest(SpaprMachineState *spapr,
                                                      target_ulong guestid)
 {
-    SpaprMachineStateNestedGuest *guest;
-
-    guest = g_hash_table_lookup(spapr->nested.guests, GINT_TO_POINTER(guestid));
-    return guest;
+    return spapr->nested.guests ?
+        g_hash_table_lookup(spapr->nested.guests,
+                            GINT_TO_POINTER(guestid)) : NULL;
 }
 
 bool spapr_get_pate_nested_papr(SpaprMachineState *spapr, PowerPCCPU *cpu,
@@ -613,6 +612,13 @@ static void *get_guest_ptr(SpaprMachineStateNestedGuest *guest,
     return guest; /* for GSBE_NESTED */
 }
 
+static void *get_machine_ptr(SpaprMachineStateNestedGuest *guest,
+                             target_ulong vcpuid)
+{
+    SpaprMachineState *spapr = SPAPR_MACHINE(qdev_get_machine());
+    return &spapr->nested;
+}
+
 /*
  * set=1 means the L1 is trying to set some state
  * set=0 means the L1 is trying to get some state
@@ -1012,7 +1018,12 @@ struct guest_state_element_type guest_state_element_types[] = {
     GSBE_NESTED_VCPU(GSB_VCPU_OUT_BUFFER, 0x10, runbufout,   copy_state_runbuf),
     GSBE_NESTED_VCPU(GSB_VCPU_OUT_BUF_MIN_SZ, 0x8, runbufout, out_buf_min_size),
     GSBE_NESTED_VCPU(GSB_VCPU_HDEC_EXPIRY_TB, 0x8, hdecr_expiry_tb,
-                     copy_state_hdecr)
+                     copy_state_hdecr),
+    GSBE_MACHINE_NESTED_DW(GSB_GUEST_HEAP, current_guest_heap),
+    GSBE_MACHINE_NESTED_DW(GSB_GUEST_HEAP_MAX, max_guest_heap),
+    GSBE_MACHINE_NESTED_DW(GSB_GUEST_PGTABLE_SIZE, current_pgtable_size),
+    GSBE_MACHINE_NESTED_DW(GSB_GUEST_PGTABLE_SIZE_MAX, max_pgtable_size),
+    GSBE_MACHINE_NESTED_DW(GSB_GUEST_PGTABLE_RECLAIM, pgtable_reclaim_size),
 };
 
 void spapr_nested_gsb_init(void)
@@ -1030,6 +1041,10 @@ void spapr_nested_gsb_init(void)
         else if (type->id >= GSB_VCPU_IN_BUFFER)
             /* 0x0c00 - 0xf000 Thread + RW */
             type->flags = 0;
+        else if (type->id >= GSB_GUEST_HEAP)
+            /*0x0800 - 0x0804 Hostwide Counters*/
+            type->flags = GUEST_STATE_ELEMENT_TYPE_FLAG_HOST_WIDE |
+                          GUEST_STATE_ELEMENT_TYPE_FLAG_READ_ONLY;
         else if (type->id >= GSB_VCPU_LPVR)
             /* 0x0003 - 0x0bff Guest + RW */
             type->flags = GUEST_STATE_ELEMENT_TYPE_FLAG_GUEST_WIDE;
@@ -1138,22 +1153,30 @@ static bool guest_state_request_check(struct guest_state_request *gsr)
             return false;
         }
 
-        if (type->flags & GUEST_STATE_ELEMENT_TYPE_FLAG_GUEST_WIDE) {
+        if (type->flags & GUEST_STATE_ELEMENT_TYPE_FLAG_HOST_WIDE) {
+            /* Hostwide elements cant be clubbed with other types */
+            if (!(gsr->flags & GUEST_STATE_REQUEST_HOST_WIDE)) {
+                qemu_log_mask(LOG_GUEST_ERROR, "trying to get/set a host wide "
+                              "Element ID:%04x.\n", id);
+                return false;
+            }
+        } else  if (type->flags & GUEST_STATE_ELEMENT_TYPE_FLAG_GUEST_WIDE) {
             /* guest wide element type */
             if (!(gsr->flags & GUEST_STATE_REQUEST_GUEST_WIDE)) {
-                qemu_log_mask(LOG_GUEST_ERROR, "trying to set a guest wide "
+                qemu_log_mask(LOG_GUEST_ERROR, "trying to get/set a guest wide "
                               "Element ID:%04x.\n", id);
                 return false;
             }
         } else {
             /* thread wide element type */
-            if (gsr->flags & GUEST_STATE_REQUEST_GUEST_WIDE) {
-                qemu_log_mask(LOG_GUEST_ERROR, "trying to set a thread wide "
-                              "Element ID:%04x.\n", id);
+            if (gsr->flags & (GUEST_STATE_REQUEST_GUEST_WIDE |
+                              GUEST_STATE_ELEMENT_TYPE_FLAG_HOST_WIDE)) {
+                qemu_log_mask(LOG_GUEST_ERROR, "trying to get/set a thread wide"
+                            " Element ID:%04x.\n", id);
                 return false;
             }
         }
-next_element:
+    next_element:
         element = guest_state_element_next(element, &len, &num_elements);
 
     }
@@ -1509,26 +1532,45 @@ static target_ulong h_guest_getset_state(PowerPCCPU *cpu,
     target_ulong buf = args[3];
     target_ulong buflen = args[4];
     struct guest_state_request gsr;
-    SpaprMachineStateNestedGuest *guest;
+    SpaprMachineStateNestedGuest *guest = NULL;
 
-    guest = spapr_get_nested_guest(spapr, lpid);
-    if (!guest) {
-        return H_P2;
-    }
     gsr.buf = buf;
     assert(buflen <= GSB_MAX_BUF_SIZE);
     gsr.len = buflen;
     gsr.flags = 0;
-    if (flags & H_GUEST_GETSET_STATE_FLAG_GUEST_WIDE) {
+
+    /* Works for both get/set state */
+    if (cpu_to_be64(flags) & GUEST_STATE_REQUEST_GUEST_WIDE) {
         gsr.flags |= GUEST_STATE_REQUEST_GUEST_WIDE;
     }
-    if (flags & ~H_GUEST_GETSET_STATE_FLAG_GUEST_WIDE) {
-        return H_PARAMETER; /* flag not supported yet */
-    }
 
     if (set) {
+        if (flags & ~H_GUEST_SET_STATE_FLAGS_MASK) {
+            return H_PARAMETER;
+        }
         gsr.flags |= GUEST_STATE_REQUEST_SET;
+    } else {
+        /*
+         * No reserved fields to be set in flags nor both
+         * GUEST/HOST wide bits
+         */
+        if ((flags == H_GUEST_GET_STATE_FLAGS_MASK) ||
+            (flags & ~H_GUEST_GET_STATE_FLAGS_MASK)) {
+            return H_PARAMETER;
+        }
+
+        if (cpu_to_be64(flags) & GUEST_STATE_REQUEST_HOST_WIDE) {
+            gsr.flags |= GUEST_STATE_REQUEST_HOST_WIDE;
+        }
     }
+
+    if (!(gsr.flags & GUEST_STATE_REQUEST_HOST_WIDE)) {
+        guest = spapr_get_nested_guest(spapr, lpid);
+        if (!guest) {
+            return H_P2;
+        }
+    }
+
     return map_and_getset_state(cpu, guest, vcpuid, &gsr);
 }
 
diff --git a/include/hw/ppc/spapr_nested.h b/include/hw/ppc/spapr_nested.h
index e420220484..c0ffd0a696 100644
--- a/include/hw/ppc/spapr_nested.h
+++ b/include/hw/ppc/spapr_nested.h
@@ -11,11 +11,18 @@
 #define GSB_TB_OFFSET           0x0004 /* Timebase Offset */
 #define GSB_PART_SCOPED_PAGETBL 0x0005 /* Partition Scoped Page Table */
 #define GSB_PROCESS_TBL         0x0006 /* Process Table */
-                    /* RESERVED 0x0007 - 0x0BFF */
+                   /* RESERVED 0x0007 - 0x07FF */
+#define GSB_PROCESS_TBL         0x0006 /* Process Table */
 #define GSB_VCPU_IN_BUFFER      0x0C00 /* Run VCPU Input Buffer */
 #define GSB_VCPU_OUT_BUFFER     0x0C01 /* Run VCPU Out Buffer */
 #define GSB_VCPU_VPA            0x0C02 /* HRA to Guest VCPU VPA */
                     /* RESERVED 0x0C03 - 0x0FFF */
+#define GSB_GUEST_HEAP          0x0800 /* Guest Management Heap Size */
+#define GSB_GUEST_HEAP_MAX      0x0801 /* Guest Management Heap Max Size */
+#define GSB_GUEST_PGTABLE_SIZE  0x0802 /* Guest Pagetable Size */
+#define GSB_GUEST_PGTABLE_SIZE_MAX   0x0803 /* Guest Pagetable Max Size */
+#define GSB_GUEST_PGTABLE_RECLAIM    0x0804 /* Pagetable Reclaim in bytes */
+                  /* RESERVED 0x0805 - 0x0FFF */
 #define GSB_VCPU_GPR0           0x1000
 #define GSB_VCPU_GPR1           0x1001
 #define GSB_VCPU_GPR2           0x1002
@@ -196,6 +203,13 @@ typedef struct SpaprMachineStateNested {
 #define NESTED_API_PAPR    2
     bool capabilities_set;
     uint32_t pvr_base;
+    /* Hostwide counters */
+    uint64_t current_guest_heap;
+    uint64_t max_guest_heap;
+    uint64_t current_pgtable_size;
+    uint64_t max_pgtable_size;
+    uint64_t pgtable_reclaim_size;
+
     GHashTable *guests;
 } SpaprMachineStateNested;
 
@@ -229,9 +243,11 @@ typedef struct SpaprMachineStateNestedGuest {
 #define HVMASK_HDEXCR                 0x00000000FFFFFFFF
 #define HVMASK_TB_OFFSET              0x000000FFFFFFFFFF
 #define GSB_MAX_BUF_SIZE              (1024 * 1024)
-#define H_GUEST_GETSET_STATE_FLAG_GUEST_WIDE 0x8000000000000000
-#define GUEST_STATE_REQUEST_GUEST_WIDE       0x1
-#define GUEST_STATE_REQUEST_SET              0x2
+#define H_GUEST_GET_STATE_FLAGS_MASK   0xC000000000000000ULL
+#define H_GUEST_SET_STATE_FLAGS_MASK   0x8000000000000000ULL
+#define GUEST_STATE_REQUEST_GUEST_WIDE 0x0000000000000080ULL
+#define GUEST_STATE_REQUEST_HOST_WIDE  0x0000000000000040ULL
+#define GUEST_STATE_REQUEST_SET        0x0000000000000008ULL
 
 /*
  * As per ISA v3.1B, following bits are reserved:
@@ -251,6 +267,15 @@ typedef struct SpaprMachineStateNestedGuest {
     .copy = (c)                                    \
 }
 
+#define GSBE_MACHINE_NESTED_DW(i, f)  {                             \
+        .id = (i),                                                  \
+        .size = 8,                                                  \
+        .location = get_machine_ptr,                                \
+        .offset = offsetof(struct SpaprMachineStateNested, f),     \
+        .copy = copy_state_8to8,                                    \
+        .mask = HVMASK_DEFAULT                                      \
+}
+
 #define GSBE_NESTED(i, sz, f, c) {                             \
     .id = (i),                                                 \
     .size = (sz),                                              \
@@ -509,7 +534,8 @@ struct guest_state_element_type {
     uint16_t id;
     int size;
 #define GUEST_STATE_ELEMENT_TYPE_FLAG_GUEST_WIDE 0x1
-#define GUEST_STATE_ELEMENT_TYPE_FLAG_READ_ONLY  0x2
+#define GUEST_STATE_ELEMENT_TYPE_FLAG_HOST_WIDE 0x2
+#define GUEST_STATE_ELEMENT_TYPE_FLAG_READ_ONLY 0x4
    uint16_t flags;
     void *(*location)(SpaprMachineStateNestedGuest *, target_ulong);
     size_t offset;
-- 
2.47.1


