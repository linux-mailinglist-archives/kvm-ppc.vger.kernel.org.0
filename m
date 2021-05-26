Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0BC390E9C
	for <lists+kvm-ppc@lfdr.de>; Wed, 26 May 2021 05:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbhEZDDD (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 25 May 2021 23:03:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64596 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230499AbhEZDDC (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 25 May 2021 23:03:02 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14Q2k0fp127398;
        Tue, 25 May 2021 23:01:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=nS6q41nOB2liJ/Eb3TlZI3Wi5PmzSUNrHUcBTsozV28=;
 b=Bts6GySb9fFKepzZ2mNTFActHKLP2eXNvh0jd93WFtISOsnBccloMTHhgZUtAzWl5882
 irPLCfvzS7v7Ioa+GC/yDTxZ4OEEMBvhOvdYGKY6OAPDBzewL9S9ClC4GqTcKweOrT77
 lf/qmycZdtOL7iz6K5B9/SG30DwjbDw/7+Ai3r5yMrJ9WghAlIIo2XxzqvFmiEOfh9Cz
 enSKRWUFcbfCNetVnnuxiTlwVrmZ3N6Ew6obRAXnEqA3kyJ+vGCK+HB583FWedygommt
 BQKWPd12dgN/vAUylpz+TVf8LJCpOI6TjGF0Be0yrIkDl6opUOJ1Zj7y9tLUaZv14Dof Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38sdu907mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 May 2021 23:01:10 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14Q2le6V129940;
        Tue, 25 May 2021 23:01:09 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38sdu907k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 May 2021 23:01:09 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14Q2wv9D020973;
        Wed, 26 May 2021 03:01:06 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 38s1r5054v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 03:01:06 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14Q313P416908710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 03:01:03 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 754E052051;
        Wed, 26 May 2021 03:01:03 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.85.69.160])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 51B3C52065;
        Wed, 26 May 2021 03:00:59 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Wed, 26 May 2021 08:30:58 +0530
From:   Vaibhav Jain <vaibhav@linux.ibm.com>
To:     qemu-devel@nongnu.org, kvm-ppc@vger.kernel.org,
        qemu-ppc@nongnu.org, david@gibson.dropbear.id.au, mst@redhat.com,
        imammedo@redhat.com, xiaoguangrong.eric@gmail.com
Cc:     Vaibhav Jain <vaibhav@linux.ibm.com>, shivaprasadbhat@gmail.com,
        bharata@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com,
        groug@kaod.org, ehabkost@redhat.com, marcel.apfelbaum@gmail.com
Subject: [RFC PATCH v4] ppc/spapr: Add support for H_SCM_PERFORMANCE_STATS hcall
Date:   Wed, 26 May 2021 08:30:57 +0530
Message-Id: <20210526030057.395092-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cmXW6mt9P6m8KyHcZl6n1juvI2PC0c_L
X-Proofpoint-ORIG-GUID: uS42kuGdNWNpjljaNPUi2cYtutEItNkv
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_02:2021-05-25,2021-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 mlxscore=0 bulkscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105260016
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Add support for H_SCM_PERFORMANCE_STATS described at [1] for
spapr nvdimms. This enables guest to fetch performance stats[2] like
expected life of an nvdimm ('MemLife ') etc and display them to the
user. Linux kernel support for fetching these performance stats and
exposing them to the user-space was done via [3].

The hcall semantics mandate that each nvdimm performance stats is
uniquely identied by a 8-byte ascii string encoded as an unsigned
integer (e.g 'MemLife ' == 0x4D656D4C69666520) and its value be a
8-byte unsigned integer. These performance-stats are exchanged with
the guest in via a guest allocated buffer called
'requestAndResultBuffer' or rr-buffer for short. This buffer contains
a header descibed by 'struct papr_scm_perf_stats' followed by an array
of performance-stats described by 'struct papr_scm_perf_stat'. The
hypervisor is expected to validate the rr-buffer header and then based
on the request copy the needed performance-stats to the array of
'struct papr_scm_perf_stat' following the header.

The patch proposes a new function h_scm_performance_stats() that
services the H_SCM_PERFORMANCE_STATS hcall. After verifying the
validity of the rr-buffer header via scm_perf_check_rr_buffer() it
proceeds to fill the rr-buffer with requested performance-stats. The
value of individual stats is retrived from individual accessor
function for the stat which are indexed in the array
'nvdimm_perf_stats'.

References:
[1] "Hypercall Op-codes (hcalls)"
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/powerpc/papr_hcalls.rst#n269
[2] Sysfs attribute documentation for papr_scm
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/ABI/testing/sysfs-bus-papr-pmem#n36
[3] "powerpc/papr_scm: Fetch nvdimm performance stats from PHYP"
https://lore.kernel.org/r/20200731064153.182203-2-vaibhav@linux.ibm.com

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
Changelog

Since RFC-v3:
* Introduced consistent types 'perf_stat_id/val' for handling
  perf-stats in code rather than switching between u64 and char[8]. [
  David Gibson ]
* Removed a redundant temporary variable 'stat_id' usage from
  nvdimm_stat_getval() [ David Gibson ]
* Move the tests for buffer sizes around to a a central place in
  h_scm_performance_stats() [ David Gibson ]
* Update the allocation size/type of rr-buffer in
  h_scm_performance_stats [ David Gibson, Groug ]
* Reworked the loop for generating canned-response in
  h_scm_performance_stats().
* Reworked logic for returning an unknown stat-id in h_scm_performance_stats().

Since RFC-v2:
* s/SCM_STATS_MAX_OUTPUT_BUFFER/SCM_STATS_MIN_OUTPUT_BUFFER/ thats the
  minimum size buffer needed to return all supported performance
  stats. Value for this is derived from size of array 'nvdimm_perf_stats'
* Added SCM_STATS_MAX_OUTPUT_BUFFER to indicate maximum supported
  rr-buffer size from a guest. Value for this is derived from hard
  limit of SCM_STATS_MAX_STATS.
* Updated scm_perf_check_rr_buffer() to add a check for max size of
  rr-buffer. [David]
* Updated scm_perf_check_rr_buffer() to removed a reduntant check for
  min size of rr-buffer [David]
* Updated h_scm_performance_stats() to have a single allocation for
  rr-buffer and copy it back to guest memory in a single shot. [David]

Since RFC-v1:
* Removed empty lines from code [ David ]
* Updated struct papr_scm_perf_stat to use uint64_t for
  statistic_id.
* Added a hard limit on max number of stats requested to 255 [ David ]
* Updated scm_perf_check_rr_buffer() to check for rr-buffer header
  size [ David ]
* Removed a redundant check from nvdimm_stat_getval() [ David ]
* Removed a redundant call to address_space_access_valid() in
  scm_perf_check_rr_buffer() [ David ]
* Instead of allocating a minimum size local buffer, allocate a max
  possible size local rr-buffer. [ David ]
* Updated nvdimm_stat_getval() to set 'val' to '0' on error. [ David ]
* Updated h_scm_performance_stats() to use a canned-response method
  for simplifying num_stats==0 case [ David ].
---
 hw/ppc/spapr_nvdimm.c  | 219 +++++++++++++++++++++++++++++++++++++++++
 include/hw/ppc/spapr.h |  22 ++++-
 2 files changed, 240 insertions(+), 1 deletion(-)

diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
index 252204e25f..81ab2811bc 100644
--- a/hw/ppc/spapr_nvdimm.c
+++ b/hw/ppc/spapr_nvdimm.c
@@ -35,6 +35,23 @@
 /* SCM device is unable to persist memory contents */
 #define PAPR_PMEM_UNARMED PPC_BIT(0)
 
+/* Maximum number of stats that we can return back in a single stat request */
+#define SCM_STATS_MAX_STATS 255
+
+/* Given _numstats_ != 0 calculate the size of RR buffer required */
+#define SCM_STATS_RR_BUFFER_SIZE(_numstats_)                            \
+    (sizeof(struct papr_scm_perf_stats) +                               \
+     sizeof(struct papr_scm_perf_stat) *                                \
+     (_numstats_))
+
+/* Maximum possible output buffer to fulfill a perf-stats request */
+#define SCM_STATS_MAX_OUTPUT_BUFFER  \
+    (SCM_STATS_RR_BUFFER_SIZE(SCM_STATS_MAX_STATS))
+
+/* Minimum output buffer size needed to return all perf_stats except noopstat */
+#define SCM_STATS_MIN_OUTPUT_BUFFER  (SCM_STATS_RR_BUFFER_SIZE\
+                                      (ARRAY_SIZE(nvdimm_perf_stats) - 1))
+
 bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
                            uint64_t size, Error **errp)
 {
@@ -502,6 +519,207 @@ static target_ulong h_scm_health(PowerPCCPU *cpu, SpaprMachineState *spapr,
     return H_SUCCESS;
 }
 
+static int perf_stat_noop(SpaprDrc *drc, perf_stat_id unused,
+                          perf_stat_val *val)
+{
+    *val = 0;
+    return H_SUCCESS;
+}
+
+static int perf_stat_memlife(SpaprDrc *drc, perf_stat_id unused,
+                             perf_stat_val *val)
+{
+    /* Assume full life available of an NVDIMM right now */
+    *val = 100;
+    return H_SUCCESS;
+}
+
+/*
+ * Holds all supported performance stats accessors. Each performance-statistic
+ * is uniquely identified by a 8-byte ascii string for example: 'MemLife '
+ * which indicate in percentage how much usage life of an nvdimm is remaining.
+ * 'NoopStat' which is primarily used to test support for retriving performance
+ * stats and also to replace unknown stats present in the rr-buffer.
+ *
+ */
+static const struct {
+    perf_stat_id stat_id;
+    int  (*stat_getval)(SpaprDrc *drc, perf_stat_id id, perf_stat_val *val);
+} nvdimm_perf_stats[] = {
+    { "NoopStat", perf_stat_noop},
+    { "MemLife ", perf_stat_memlife},
+};
+
+/*
+ * Given a nvdimm drc and stat-name return its value. In case given stat-name
+ * isnt supported then return H_PARTIAL.
+ */
+static int nvdimm_stat_getval(SpaprDrc *drc, perf_stat_id id,
+                              perf_stat_val *val)
+{
+    int index;
+
+    *val = 0;
+
+    /* Lookup the stats-id in the nvdimm_perf_stats table */
+    for (index = 0; index < ARRAY_SIZE(nvdimm_perf_stats); ++index) {
+        if (!memcmp(&nvdimm_perf_stats[index].stat_id, id,
+                    sizeof(perf_stat_id))) {
+            return nvdimm_perf_stats[index].stat_getval(drc, id, val);
+        }
+    }
+    return H_PARTIAL;
+}
+
+/*
+ * Given a request & result buffer header verify its contents. Also
+ * buffer-size and number of stats requested are within our expected
+ * sane bounds.
+ */
+static int scm_perf_check_rr_buffer(struct papr_scm_perf_stats *header,
+                                    hwaddr addr, size_t size,
+                                    uint32_t *num_stats)
+{
+    size_t expected_buffsize;
+
+    /* Verify the header eyecather and version */
+    if (memcmp(&header->eye_catcher, SCM_STATS_EYECATCHER,
+               sizeof(header->eye_catcher))) {
+        return H_BAD_DATA;
+    }
+    if (be32_to_cpu(header->stats_version) != 0x1) {
+        return H_NOT_AVAILABLE;
+    }
+
+    /* verify that rr buffer has enough space */
+    *num_stats = be32_to_cpu(header->num_statistics);
+    if (*num_stats > SCM_STATS_MAX_STATS) {
+        /* Too many stats requested */
+        return H_P3;
+    }
+
+    expected_buffsize  = *num_stats ?
+        SCM_STATS_RR_BUFFER_SIZE(*num_stats) : SCM_STATS_MIN_OUTPUT_BUFFER;
+    if (size < expected_buffsize) {
+        return H_P3;
+    }
+
+    return H_SUCCESS;
+}
+
+/*
+ * For a given DRC index (R3) return one ore more performance stats of an nvdimm
+ * device in guest allocated Request-and-result buffer (rr-buffer) (R4) of
+ * given 'size' (R5). The rr-buffer consists of a header described by
+ * 'struct papr_scm_perf_stats' that embeds the 'stats_version' and
+ * 'num_statistics' fields. This is followed by an array of
+ * 'struct papr_scm_perf_stat'. Based on the request type the writes the
+ * performance into the array of 'struct papr_scm_perf_stat' embedded inside
+ * the rr-buffer provided by the guest.
+ * Special cases handled are:
+ * 'size' == 0  : Return the maximum possible size of rr-buffer
+ * 'size' != 0 && 'num_statistics == 0' : Return all possible performance stats
+ *
+ * In case there was an error fetching a specific stats (e.g stat-id unknown or
+ * any other error) then return the stat-id in R4 and also replace its stat
+ * entry in rr-buffer with 'NoopStat'
+ */
+static target_ulong h_scm_performance_stats(PowerPCCPU *cpu,
+                                            SpaprMachineState *spapr,
+                                            target_ulong opcode,
+                                            target_ulong *args)
+{
+    SpaprDrc *drc = spapr_drc_by_index(args[0]);
+    const hwaddr addr = args[1];
+    size_t size = args[2];
+    g_autofree struct papr_scm_perf_stats *perfstats = NULL;
+    struct papr_scm_perf_stat *stats;
+    perf_stat_val stat_val;
+    uint32_t num_stats;
+    int index;
+    long rc;
+
+    /* Ensure that the drc is valid & is valid PMEM dimm and is plugged in */
+    if (!drc || !drc->dev ||
+        spapr_drc_type(drc) != SPAPR_DR_CONNECTOR_TYPE_PMEM) {
+        return H_PARAMETER;
+    }
+
+    /* Guest requested max buffer size for output buffer */
+    if (size == 0) {
+        args[0] = SCM_STATS_MIN_OUTPUT_BUFFER;
+        return H_SUCCESS;
+    }
+
+    /* verify size is enough to hold rr-buffer */
+    if (size < sizeof(struct papr_scm_perf_stats)) {
+        return H_BAD_DATA;
+    }
+
+    if (size > SCM_STATS_MAX_OUTPUT_BUFFER) {
+        return H_P3;
+    }
+
+    /* allocate enough buffer space locally for holding max stats */
+    perfstats = g_try_malloc0(size);
+    if (!perfstats) {
+        return H_NO_MEM;
+    }
+    stats = &perfstats->scm_statistics[0];
+
+    /* Read and verify rr-buffer */
+    rc = address_space_read(&address_space_memory, addr, MEMTXATTRS_UNSPECIFIED,
+                            perfstats, size);
+    if (rc != MEMTX_OK) {
+        return H_PRIVILEGE;
+    }
+    rc = scm_perf_check_rr_buffer(perfstats, addr, size, &num_stats);
+    if (rc != H_SUCCESS) {
+        return rc;
+    }
+
+    /* when returning all stats generate a canned response first */
+    if (num_stats == 0) {
+        /* Ignore 'noopstat' when generating canned response */
+        for (num_stats = 0; num_stats < ARRAY_SIZE(nvdimm_perf_stats) - 1;
+             ++num_stats) {
+            memcpy(&stats[num_stats].statistic_id,
+                   nvdimm_perf_stats[num_stats + 1].stat_id,
+                   sizeof(perf_stat_id));
+        }
+    }
+
+    /* Populate the rr-buffer with stat values */
+    for (args[0] = 0, index = 0; index < num_stats; ++index) {
+        rc = nvdimm_stat_getval(drc, stats[index].statistic_id, &stat_val);
+
+        /* On error add noop stat to rr buffer & save last inval stat-id */
+        if (rc != H_SUCCESS) {
+            if (!args[0]) {
+                memcpy(&args[0], stats[index].statistic_id,
+                       sizeof(perf_stat_id));
+            }
+            memcpy(&stats[index].statistic_id, nvdimm_perf_stats[0].stat_id,
+                   sizeof(perf_stat_id));
+        }
+        /* Caller expects stat values in BE encoding */
+        stats[index].statistic_value = cpu_to_be64(stat_val);
+    }
+
+    /* Update and copy the local rr-buffer back to guest */
+    perfstats->num_statistics = cpu_to_be32(num_stats);
+    g_assert(size <= SCM_STATS_MAX_OUTPUT_BUFFER);
+    rc = address_space_write(&address_space_memory, addr,
+                             MEMTXATTRS_UNSPECIFIED, perfstats, size);
+
+    if (rc != MEMTX_OK) {
+        return H_PRIVILEGE;
+    }
+
+    /* Check if there was a failure in fetching any stat */
+    return args[0] ? H_PARTIAL : H_SUCCESS;
+}
+
 static void spapr_scm_register_types(void)
 {
     /* qemu/scm specific hcalls */
@@ -511,6 +729,7 @@ static void spapr_scm_register_types(void)
     spapr_register_hypercall(H_SCM_UNBIND_MEM, h_scm_unbind_mem);
     spapr_register_hypercall(H_SCM_UNBIND_ALL, h_scm_unbind_all);
     spapr_register_hypercall(H_SCM_HEALTH, h_scm_health);
+    spapr_register_hypercall(H_SCM_PERFORMANCE_STATS, h_scm_performance_stats);
 }
 
 type_init(spapr_scm_register_types)
diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index bbf817af46..9e093b3a00 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -326,6 +326,7 @@ struct SpaprMachineState {
 #define H_P8              -61
 #define H_P9              -62
 #define H_OVERLAP         -68
+#define H_BAD_DATA        -70
 #define H_UNSUPPORTED_FLAG -256
 #define H_MULTI_THREADS_ACTIVE -9005
 
@@ -539,8 +540,9 @@ struct SpaprMachineState {
 #define H_SCM_UNBIND_MEM        0x3F0
 #define H_SCM_UNBIND_ALL        0x3FC
 #define H_SCM_HEALTH            0x400
+#define H_SCM_PERFORMANCE_STATS 0x418
 
-#define MAX_HCALL_OPCODE        H_SCM_HEALTH
+#define MAX_HCALL_OPCODE        H_SCM_PERFORMANCE_STATS
 
 /* The hcalls above are standardized in PAPR and implemented by pHyp
  * as well.
@@ -793,6 +795,24 @@ OBJECT_DECLARE_SIMPLE_TYPE(SpaprTceTable, SPAPR_TCE_TABLE)
 DECLARE_INSTANCE_CHECKER(IOMMUMemoryRegion, SPAPR_IOMMU_MEMORY_REGION,
                          TYPE_SPAPR_IOMMU_MEMORY_REGION)
 
+/* Defs and structs exchanged with guest when reporting drc perf stats */
+#define SCM_STATS_EYECATCHER "SCMSTATS"
+
+typedef char perf_stat_id[8];
+typedef uint64_t perf_stat_val;
+
+struct QEMU_PACKED papr_scm_perf_stat {
+    perf_stat_id statistic_id;
+    perf_stat_val statistic_value;
+};
+
+struct QEMU_PACKED papr_scm_perf_stats {
+    uint8_t eye_catcher[8];    /* Should be “SCMSTATS” */
+    uint32_t stats_version;  /* Should be 0x01 */
+    uint32_t num_statistics; /* Number of stats following */
+    struct papr_scm_perf_stat scm_statistics[]; /* Performance matrics */
+};
+
 struct SpaprTceTable {
     DeviceState parent;
     uint32_t liobn;
-- 
2.31.1

