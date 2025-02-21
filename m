Return-Path: <kvm-ppc+bounces-224-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19CB1A3F9F4
	for <lists+kvm-ppc@lfdr.de>; Fri, 21 Feb 2025 17:03:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE09418916DF
	for <lists+kvm-ppc@lfdr.de>; Fri, 21 Feb 2025 15:58:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F24B91ADC6F;
	Fri, 21 Feb 2025 15:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fj+pFBV0"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB87191
	for <kvm-ppc@vger.kernel.org>; Fri, 21 Feb 2025 15:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740153322; cv=none; b=TpqFFv5XAek+nNmLXr8a2fIJrCy6Jd8sNj/NG3fdwMbbSQkaTIpAOalrXFn0vGpt8Z10hFSYC2EvV/BEC83keQqsEcGLndZ5qsCNsLTlGEatKudthtemP2c58OEdh9YxNbK8MDp1zwZmrHrt//FQbBFNFK7LeMm4I2Y6CrBsFlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740153322; c=relaxed/simple;
	bh=W/4JCetdgNlZ5UTcdfazvsbJuQfq8ZNPiQGGKzdtUak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Gwn7c696OI0ohYQG3ztpFRNYmqpv95G0WNDKEYhbEY2RkVJ45SZc4a6Ifao/qnYXvYeflSfkj/Ek/3mSYHJC4ygQ00KXMcZ2IR7dArnquxBAK2fp+twO9Dix/IKl6gEGrunsfGtj3tNrSYx0CQMu5XecIl1PvVwx601YrSht3X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fj+pFBV0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51LFTB9W008731;
	Fri, 21 Feb 2025 15:55:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=JdKdHfspwVppOCB2NOZ36JEx2X2B/ycvta/nAQUvm
	qw=; b=fj+pFBV01bABMwPWf80RcBBVQt2m3+0WH3nTOPB5F9PCdT7OuQa73LRhY
	EBCeBIbl+kn9/H5mAIoOFoqpf2Ai2KtIX1wezNll2dVL/v4ChE85k1sD1lGFar2m
	06+A8N6S6jmKxyIXwHXMG3BJddXG5qnN61sLsX7/9Qqhp5PMcdbLCHjEqCI10XJM
	STrGDMlfzkYfdStT5ajgecWEpesLfZL4Jmyk2FSk6DLNFt/akvhueGbkhwTYKsi3
	yKBhOzqhBwEvuOGh5kAppwEdWktcrHzC3PKcVJEOywe92CVweySy+fcaovFas5hz
	ZacyzmcgBCxFjEhRum2TEy2JHle/A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44xm752q29-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Feb 2025 15:55:14 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51LFq00Y023444;
	Fri, 21 Feb 2025 15:55:14 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44xm752q26-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Feb 2025 15:55:14 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51LCTLhV002297;
	Fri, 21 Feb 2025 15:55:13 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44w03xgscx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Feb 2025 15:55:13 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51LFtA0W59965938
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Feb 2025 15:55:10 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E4A2220043;
	Fri, 21 Feb 2025 15:55:09 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F40020040;
	Fri, 21 Feb 2025 15:55:06 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.39.30.226])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 21 Feb 2025 15:55:06 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Fri, 21 Feb 2025 21:25:04 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: qemu-devel@nongnu.org, kvm-ppc@vger.kernel.org, qemu-ppc@nongnu.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>, npiggin@gmail.com,
        harshpb@linux.ibm.com, shivaprasadbhat@gmail.com
Subject: [PATCH v4] spapr: nested: Add support for reporting Hostwide state counter
Date: Fri, 21 Feb 2025 21:24:48 +0530
Message-ID: <20250221155449.530645-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: O54dQVIv6KPnfOGkKAe9yzi6T30jsHek
X-Proofpoint-GUID: sEf0JACG3vueALExon64U56zaRq_mV98
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-21_05,2025-02-20_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502210111

Add support for reporting Hostwide state counters for nested KVM pseries
guests running with 'cap-nested-papr' on Qemu-TCG acting as
L0-hypervisor. The Hostwide state counters are statistics about state that
L0-hypervisor maintains for the L2-guests and represent the state of all
L2-guests, not just a specific one.

These stats counters are exposed to L1-Hypervisor by the L0-Hypervisor via a
new bit-flag named 'getHostWideState' for the H_GUEST_GET_STATE hcall which
is documented at [1]. Once this flag is set the hcall should populate the
Guest-State-Elements in the requested GSB with the stat counter
values. Currently following five counters are supported:

* l0_guest_heap_size_inuse
* l0_guest_heap_size_max
* l0_guest_pagetable_size_inuse
* l0_guest_pagetable_size_max
* l0_guest_pagetable_reclaimed

At the moment '0' is being reported for all these counters as these
counters doesn't align with how L0-Qemu manages Guest memory.

The patch implements support for these counters by adding new members to
the 'struct SpaprMachineStateNested'. These new members are then plugged
into the existing 'guest_state_element_types[]' with the help of a new
macro 'GSBE_NESTED_MACHINE_DW' together with a new helper
'get_machine_ptr()'. guest_state_request_check() is updated to ensure
correctness of the requested GSB and finally h_guest_getset_state() is
updated to handle the newly introduced flag
'GUEST_STATE_REQUEST_HOST_WIDE'.

This patch is tested with the proposed linux-kernel implementation to
expose these stat-counter as perf-events at [2].

[1]
https://lore.kernel.org/all/20241222140247.174998-2-vaibhav@linux.ibm.com

[2]
https://lore.kernel.org/all/20241222140247.174998-1-vaibhav@linux.ibm.com

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
Changelog:

v3->v4:
* Updated/Fixed patch description [ Nic ]
* Renamed the newly introduced struct members and defines [ Nic ]
* Updated 'struct guest_state_element_type.location' callback to also
accept 'struct SpaprMachineState *' [ Nic ]
* Updated code in 'spapr_nested.c' to pass around 'struct
SpaprMachineState *' which eventually needs to be sent to the 'struct
guest_state_element_type.location' callback.

v2->v3:
* Fixed minor nits suggested [Harsh]
* s/GUEST_STATE_ELEMENT_TYPE_FLAG_HOST_WIDE/GUEST_STATE_REQUEST_HOST_WIDE/
in guest_state_request_check() [Harsh]
* MInor change in the order of comparision in h_guest_getset_state()
[Harsh]
* Added reviewed-by of Harsh

v1->v2:
* Introduced new flags to correctly compare hcall flags
  for H_GUEST_{GET,SET}_STATE [Harsh]
* Fixed ordering of new GSB elements in spapr_nested.h [Harsh]
* s/GSBE_MACHINE_NESTED_DW/GSBE_NESTED_MACHINE_DW/
* Minor tweaks to patch description
* Updated recipients list
---
 hw/ppc/spapr_nested.c         | 119 ++++++++++++++++++++++++----------
 include/hw/ppc/spapr_nested.h |  67 +++++++++++++++++--
 2 files changed, 147 insertions(+), 39 deletions(-)

diff --git a/hw/ppc/spapr_nested.c b/hw/ppc/spapr_nested.c
index 7def8eb73b..4b1dee5eac 100644
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
@@ -593,26 +592,37 @@ static bool spapr_nested_vcpu_check(SpaprMachineStateNestedGuest *guest,
     return false;
 }
 
-static void *get_vcpu_state_ptr(SpaprMachineStateNestedGuest *guest,
-                              target_ulong vcpuid)
+static void *get_vcpu_state_ptr(SpaprMachineState *spapr,
+                                SpaprMachineStateNestedGuest *guest,
+                                target_ulong vcpuid)
 {
     assert(spapr_nested_vcpu_check(guest, vcpuid, false));
     return &guest->vcpus[vcpuid].state;
 }
 
-static void *get_vcpu_ptr(SpaprMachineStateNestedGuest *guest,
-                                   target_ulong vcpuid)
+static void *get_vcpu_ptr(SpaprMachineState *spapr,
+                          SpaprMachineStateNestedGuest *guest,
+                          target_ulong vcpuid)
 {
     assert(spapr_nested_vcpu_check(guest, vcpuid, false));
     return &guest->vcpus[vcpuid];
 }
 
-static void *get_guest_ptr(SpaprMachineStateNestedGuest *guest,
+static void *get_guest_ptr(SpaprMachineState *spapr,
+                           SpaprMachineStateNestedGuest *guest,
                            target_ulong vcpuid)
 {
     return guest; /* for GSBE_NESTED */
 }
 
+static void *get_machine_ptr(SpaprMachineState *spapr,
+                             SpaprMachineStateNestedGuest *guest,
+                             target_ulong vcpuid)
+{
+    /* ignore guest and vcpuid for this */
+    return &spapr->nested;
+}
+
 /*
  * set=1 means the L1 is trying to set some state
  * set=0 means the L1 is trying to get some state
@@ -1012,7 +1022,15 @@ struct guest_state_element_type guest_state_element_types[] = {
     GSBE_NESTED_VCPU(GSB_VCPU_OUT_BUFFER, 0x10, runbufout,   copy_state_runbuf),
     GSBE_NESTED_VCPU(GSB_VCPU_OUT_BUF_MIN_SZ, 0x8, runbufout, out_buf_min_size),
     GSBE_NESTED_VCPU(GSB_VCPU_HDEC_EXPIRY_TB, 0x8, hdecr_expiry_tb,
-                     copy_state_hdecr)
+                     copy_state_hdecr),
+    GSBE_NESTED_MACHINE_DW(GSB_L0_GUEST_HEAP_INUSE, l0_guest_heap_inuse),
+    GSBE_NESTED_MACHINE_DW(GSB_L0_GUEST_HEAP_MAX, l0_guest_heap_max),
+    GSBE_NESTED_MACHINE_DW(GSB_L0_GUEST_PGTABLE_SIZE_INUSE,
+                           l0_guest_pgtable_size_inuse),
+    GSBE_NESTED_MACHINE_DW(GSB_L0_GUEST_PGTABLE_SIZE_MAX,
+                           l0_guest_pgtable_size_max),
+    GSBE_NESTED_MACHINE_DW(GSB_L0_GUEST_PGTABLE_RECLAIMED,
+                           l0_guest_pgtable_reclaimed),
 };
 
 void spapr_nested_gsb_init(void)
@@ -1030,8 +1048,13 @@ void spapr_nested_gsb_init(void)
         else if (type->id >= GSB_VCPU_IN_BUFFER)
             /* 0x0c00 - 0xf000 Thread + RW */
             type->flags = 0;
+        else if (type->id >= GSB_L0_GUEST_HEAP_INUSE)
+
+            /*0x0800 - 0x0804 Hostwide Counters + RO */
+            type->flags = GUEST_STATE_ELEMENT_TYPE_FLAG_HOST_WIDE |
+                          GUEST_STATE_ELEMENT_TYPE_FLAG_READ_ONLY;
         else if (type->id >= GSB_VCPU_LPVR)
-            /* 0x0003 - 0x0bff Guest + RW */
+            /* 0x0003 - 0x07ff Guest + RW */
             type->flags = GUEST_STATE_ELEMENT_TYPE_FLAG_GUEST_WIDE;
         else if (type->id >= GSB_HV_VCPU_STATE_SIZE)
             /* 0x0001 - 0x0002 Guest + RO */
@@ -1138,18 +1161,26 @@ static bool guest_state_request_check(struct guest_state_request *gsr)
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
+                              GUEST_STATE_REQUEST_HOST_WIDE)) {
+                qemu_log_mask(LOG_GUEST_ERROR, "trying to get/set a thread wide"
+                            " Element ID:%04x.\n", id);
                 return false;
             }
         }
@@ -1418,7 +1449,8 @@ static target_ulong h_guest_create_vcpu(PowerPCCPU *cpu,
     return H_SUCCESS;
 }
 
-static target_ulong getset_state(SpaprMachineStateNestedGuest *guest,
+static target_ulong getset_state(SpaprMachineState *spapr,
+                                 SpaprMachineStateNestedGuest *guest,
                                  uint64_t vcpuid,
                                  struct guest_state_request *gsr)
 {
@@ -1451,7 +1483,7 @@ static target_ulong getset_state(SpaprMachineStateNestedGuest *guest,
 
         /* Get pointer to guest data to get/set */
         if (type->location && type->copy) {
-            ptr = type->location(guest, vcpuid);
+            ptr = type->location(spapr, guest, vcpuid);
             assert(ptr);
             if (!~(type->mask) && is_gsr_invalid(gsr, element, type)) {
                 return H_INVALID_ELEMENT_VALUE;
@@ -1468,6 +1500,7 @@ next_element:
 }
 
 static target_ulong map_and_getset_state(PowerPCCPU *cpu,
+                                         SpaprMachineState *spapr,
                                          SpaprMachineStateNestedGuest *guest,
                                          uint64_t vcpuid,
                                          struct guest_state_request *gsr)
@@ -1491,7 +1524,7 @@ static target_ulong map_and_getset_state(PowerPCCPU *cpu,
         goto out1;
     }
 
-    rc = getset_state(guest, vcpuid, gsr);
+    rc = getset_state(spapr, guest, vcpuid, gsr);
 
 out1:
     address_space_unmap(CPU(cpu)->as, gsr->gsb, len, is_write, len);
@@ -1509,27 +1542,46 @@ static target_ulong h_guest_getset_state(PowerPCCPU *cpu,
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
+    if ((flags & H_GUEST_GET_STATE_FLAGS_GUEST_WIDE) ||
+        (flags & H_GUEST_SET_STATE_FLAGS_GUEST_WIDE)) {
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
+        if ((flags & ~H_GUEST_GET_STATE_FLAGS_MASK) ||
+            (flags == H_GUEST_GET_STATE_FLAGS_MASK)) {
+            return H_PARAMETER;
+        }
+
+        if (flags & H_GUEST_GET_STATE_FLAGS_HOST_WIDE) {
+            gsr.flags |= GUEST_STATE_REQUEST_HOST_WIDE;
+        }
+    }
+
+    if (!(gsr.flags & GUEST_STATE_REQUEST_HOST_WIDE)) {
+        guest = spapr_get_nested_guest(spapr, lpid);
+        if (!guest) {
+            return H_P2;
+        }
     }
-    return map_and_getset_state(cpu, guest, vcpuid, &gsr);
+    return map_and_getset_state(cpu, spapr, guest, vcpuid, &gsr);
 }
 
 static target_ulong h_guest_set_state(PowerPCCPU *cpu,
@@ -1640,7 +1692,8 @@ static int get_exit_ids(uint64_t srr0, uint16_t ids[16])
     return nr;
 }
 
-static void exit_process_output_buffer(PowerPCCPU *cpu,
+static void exit_process_output_buffer(SpaprMachineState *spapr,
+                                       PowerPCCPU *cpu,
                                        SpaprMachineStateNestedGuest *guest,
                                        target_ulong vcpuid,
                                        target_ulong *r3)
@@ -1678,7 +1731,7 @@ static void exit_process_output_buffer(PowerPCCPU *cpu,
     gsr.gsb = gsb;
     gsr.len = VCPU_OUT_BUF_MIN_SZ;
     gsr.flags = 0; /* get + never guest wide */
-    getset_state(guest, vcpuid, &gsr);
+    getset_state(spapr, guest, vcpuid, &gsr);
 
     address_space_unmap(CPU(cpu)->as, gsb, len, true, len);
     return;
@@ -1704,7 +1757,7 @@ void spapr_exit_nested_papr(SpaprMachineState *spapr, PowerPCCPU *cpu, int excp)
 
     exit_nested_store_l2(cpu, excp, vcpu);
     /* do the output buffer for run_vcpu*/
-    exit_process_output_buffer(cpu, guest, vcpuid, &r3_return);
+    exit_process_output_buffer(spapr, cpu, guest, vcpuid, &r3_return);
 
     assert(env->spr[SPR_LPIDR] != 0);
     nested_load_state(cpu, spapr_cpu->nested_host_state);
@@ -1819,7 +1872,7 @@ static target_ulong h_guest_run_vcpu(PowerPCCPU *cpu,
     gsr.buf = vcpu->runbufin.addr;
     gsr.len = vcpu->runbufin.size;
     gsr.flags = GUEST_STATE_REQUEST_SET; /* Thread wide + writing */
-    rc = map_and_getset_state(cpu, guest, vcpuid, &gsr);
+    rc = map_and_getset_state(cpu, spapr,  guest, vcpuid, &gsr);
     if (rc == H_SUCCESS) {
         nested_papr_run_vcpu(cpu, lpid, vcpu);
     } else {
diff --git a/include/hw/ppc/spapr_nested.h b/include/hw/ppc/spapr_nested.h
index e420220484..f7be0d5a95 100644
--- a/include/hw/ppc/spapr_nested.h
+++ b/include/hw/ppc/spapr_nested.h
@@ -11,7 +11,13 @@
 #define GSB_TB_OFFSET           0x0004 /* Timebase Offset */
 #define GSB_PART_SCOPED_PAGETBL 0x0005 /* Partition Scoped Page Table */
 #define GSB_PROCESS_TBL         0x0006 /* Process Table */
-                    /* RESERVED 0x0007 - 0x0BFF */
+                    /* RESERVED 0x0007 - 0x07FF */
+#define GSB_L0_GUEST_HEAP_INUSE 0x0800 /* Guest Management Heap Size */
+#define GSB_L0_GUEST_HEAP_MAX   0x0801 /* Guest Management Heap Max Size */
+#define GSB_L0_GUEST_PGTABLE_SIZE_INUSE  0x0802 /* Guest Pagetable Size */
+#define GSB_L0_GUEST_PGTABLE_SIZE_MAX    0x0803 /* Guest Pagetable Max Size */
+#define GSB_L0_GUEST_PGTABLE_RECLAIMED   0x0804 /* Pagetable Reclaim in bytes */
+                    /* RESERVED 0x0805 - 0xBFF */
 #define GSB_VCPU_IN_BUFFER      0x0C00 /* Run VCPU Input Buffer */
 #define GSB_VCPU_OUT_BUFFER     0x0C01 /* Run VCPU Out Buffer */
 #define GSB_VCPU_VPA            0x0C02 /* HRA to Guest VCPU VPA */
@@ -196,6 +202,38 @@ typedef struct SpaprMachineStateNested {
 #define NESTED_API_PAPR    2
     bool capabilities_set;
     uint32_t pvr_base;
+
+    /**
+     * l0_guest_heap_inuse: The currently used bytes in the Hypervisor's Guest
+     * Management Space associated with the Host Partition.
+     **/
+    uint64_t l0_guest_heap_inuse;
+
+    /**
+     * host_heap_max: The maximum bytes available in the Hypervisor's Guest
+     * Management Space associated with the Host Partition.
+     **/
+    uint64_t l0_guest_heap_max;
+
+    /**
+     * host_pagetable: The currently used bytes in the Hypervisor's Guest
+     * Page Table Management Space associated with the Host Partition.
+     **/
+    uint64_t l0_guest_pgtable_size_inuse;
+
+    /**
+     * host_pagetable_max: The maximum bytes available in the Hypervisor's Guest
+     * Page Table Management Space associated with the Host Partition.
+     **/
+    uint64_t l0_guest_pgtable_size_max;
+
+    /**
+     * host_pagetable_reclaim: The amount of space in bytes that has been
+     * reclaimed due to overcommit in the  Hypervisor's Guest Page Table
+     * Management Space associated with the Host Partition.
+     **/
+    uint64_t l0_guest_pgtable_reclaimed;
+
     GHashTable *guests;
 } SpaprMachineStateNested;
 
@@ -229,9 +267,15 @@ typedef struct SpaprMachineStateNestedGuest {
 #define HVMASK_HDEXCR                 0x00000000FFFFFFFF
 #define HVMASK_TB_OFFSET              0x000000FFFFFFFFFF
 #define GSB_MAX_BUF_SIZE              (1024 * 1024)
-#define H_GUEST_GETSET_STATE_FLAG_GUEST_WIDE 0x8000000000000000
-#define GUEST_STATE_REQUEST_GUEST_WIDE       0x1
-#define GUEST_STATE_REQUEST_SET              0x2
+#define H_GUEST_GET_STATE_FLAGS_MASK   0xC000000000000000ULL
+#define H_GUEST_SET_STATE_FLAGS_MASK   0x8000000000000000ULL
+#define H_GUEST_SET_STATE_FLAGS_GUEST_WIDE 0x8000000000000000ULL
+#define H_GUEST_GET_STATE_FLAGS_GUEST_WIDE 0x8000000000000000ULL
+#define H_GUEST_GET_STATE_FLAGS_HOST_WIDE  0x4000000000000000ULL
+
+#define GUEST_STATE_REQUEST_GUEST_WIDE     0x1
+#define GUEST_STATE_REQUEST_HOST_WIDE      0x2
+#define GUEST_STATE_REQUEST_SET            0x4
 
 /*
  * As per ISA v3.1B, following bits are reserved:
@@ -251,6 +295,15 @@ typedef struct SpaprMachineStateNestedGuest {
     .copy = (c)                                    \
 }
 
+#define GSBE_NESTED_MACHINE_DW(i, f)  {                             \
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
@@ -509,9 +562,11 @@ struct guest_state_element_type {
     uint16_t id;
     int size;
 #define GUEST_STATE_ELEMENT_TYPE_FLAG_GUEST_WIDE 0x1
-#define GUEST_STATE_ELEMENT_TYPE_FLAG_READ_ONLY  0x2
+#define GUEST_STATE_ELEMENT_TYPE_FLAG_HOST_WIDE 0x2
+#define GUEST_STATE_ELEMENT_TYPE_FLAG_READ_ONLY 0x4
    uint16_t flags;
-    void *(*location)(SpaprMachineStateNestedGuest *, target_ulong);
+   void *(*location)(struct SpaprMachineState *, SpaprMachineStateNestedGuest *,
+                     target_ulong);
     size_t offset;
     void (*copy)(void *, void *, bool);
     uint64_t mask;
-- 
2.48.1


