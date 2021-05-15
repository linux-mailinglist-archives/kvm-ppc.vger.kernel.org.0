Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB62381699
	for <lists+kvm-ppc@lfdr.de>; Sat, 15 May 2021 09:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbhEOHjn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 15 May 2021 03:39:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12356 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230508AbhEOHjm (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 15 May 2021 03:39:42 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14F7XNj3037435;
        Sat, 15 May 2021 03:38:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=oxzDKLJRYlc6I0CEJbLCpLA62PkfJcnGzhfThAyiypY=;
 b=I6A2Pnmt0sS4KdtUCUVIYQzvX0L+Yz440qf3L5aoMpmJ8/9gVTYsgaQ4UCW1a1VaIsZ6
 GHsQepKQxBDK5WuEnv4huEsTWMsGufmxBwuyK/zFBoMdG7TNT+bG1zFZ8zgu3dEE17z8
 0V8lQ5duoWQTNuSFCLEMO5YSt/Cy9J2Pyy+ZrD+DXxQXV2QN7g2H/AwZ6MYw7wh74Vr7
 OhGCMAknR6ZWXk6jVqTiudnpIxhDzwpAR+GnRZ/gUAjWEpSrh8kW5m2ry7qdIY6GMbEm
 xA6bisMdDpqaAvSH7PuZLCz2sqwFXV24fJnn1KDd3rGIZkWDniZWjzCSQ5qWUw1G/nO2 bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38j9j78g7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 15 May 2021 03:38:10 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14F7cAKb054661;
        Sat, 15 May 2021 03:38:10 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38j9j78g73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 15 May 2021 03:38:10 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14F7XNQw019276;
        Sat, 15 May 2021 07:38:08 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 38j5x7r1uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 15 May 2021 07:38:08 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14F7c5WZ29426172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 07:38:05 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1748A405F;
        Sat, 15 May 2021 07:38:05 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76F00A4054;
        Sat, 15 May 2021 07:38:01 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.199.41.126])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Sat, 15 May 2021 07:38:01 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Sat, 15 May 2021 13:08:00 +0530
From:   Vaibhav Jain <vaibhav@linux.ibm.com>
To:     qemu-devel@nongnu.org, kvm-ppc@vger.kernel.org,
        qemu-ppc@nongnu.org, david@gibson.dropbear.id.au, mst@redhat.com,
        imammedo@redhat.com, xiaoguangrong.eric@gmail.com
Cc:     Vaibhav Jain <vaibhav@linux.ibm.com>, shivaprasadbhat@gmail.com,
        bharata@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com,
        groug@kaod.org, ehabkost@redhat.com, marcel.apfelbaum@gmail.com
Subject: [RFC PATCH v3] ppc/spapr: Add support for H_SCM_PERFORMANCE_STATS hcall
Date:   Sat, 15 May 2021 13:07:59 +0530
Message-Id: <20210515073759.10505-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9ysojjJ5lM4cCn6wP7xeP4JwMCk7U0kG
X-Proofpoint-GUID: iSi8Q4cJ7YKBZSB2qEaX6sn2VYiSlSP7
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-15_04:2021-05-12,2021-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 suspectscore=0 phishscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150054
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
 hw/ppc/spapr_nvdimm.c  | 222 +++++++++++++++++++++++++++++++++++++++++
 include/hw/ppc/spapr.h |  19 +++-
 2 files changed, 240 insertions(+), 1 deletion(-)

diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
index 252204e25f..287326b9c0 100644
--- a/hw/ppc/spapr_nvdimm.c
+++ b/hw/ppc/spapr_nvdimm.c
@@ -35,6 +35,19 @@
 /* SCM device is unable to persist memory contents */
 #define PAPR_PMEM_UNARMED PPC_BIT(0)
 
+/* Minimum output buffer size needed to return all nvdimm_perf_stats */
+#define SCM_STATS_MIN_OUTPUT_BUFFER  (sizeof(struct papr_scm_perf_stats) + \
+                                      sizeof(struct papr_scm_perf_stat) * \
+                                      ARRAY_SIZE(nvdimm_perf_stats))
+
+/* Maximum number of stats that we can return back in a single stat request */
+#define SCM_STATS_MAX_STATS 255
+
+/* Maximum possible output buffer to fulfill a perf-stats request */
+#define SCM_STATS_MAX_OUTPUT_BUFFER  (sizeof(struct papr_scm_perf_stats) + \
+                                      sizeof(struct papr_scm_perf_stat) * \
+                                      SCM_STATS_MAX_STATS)
+
 bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
                            uint64_t size, Error **errp)
 {
@@ -502,6 +515,214 @@ static target_ulong h_scm_health(PowerPCCPU *cpu, SpaprMachineState *spapr,
     return H_SUCCESS;
 }
 
+static int perf_stat_noop(SpaprDrc *drc, uint64_t unused, uint64_t *val)
+{
+    *val = 0;
+    return H_SUCCESS;
+}
+
+static int perf_stat_memlife(SpaprDrc *drc, uint64_t unused, uint64_t *val)
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
+    char stat_id[8];
+    int  (*stat_getval)(SpaprDrc *drc, uint64_t id, uint64_t *val);
+} nvdimm_perf_stats[] = {
+    { "NoopStat", perf_stat_noop},
+    { "MemLife ", perf_stat_memlife},
+};
+
+/*
+ * Given a nvdimm drc and stat-name return its value. In case given stat-name
+ * isnt supported then return H_PARTIAL.
+ */
+static int nvdimm_stat_getval(SpaprDrc *drc, uint64_t id, uint64_t *val)
+{
+    int index;
+    char stat_id[8];
+
+    /* since comparision is done */
+    memcpy(&stat_id[0], &id, 8);
+    *val = 0;
+
+    /* Lookup the stats-id in the nvdimm_perf_stats table */
+    for (index = 0; index < ARRAY_SIZE(nvdimm_perf_stats); ++index) {
+        if (memcmp(nvdimm_perf_stats[index].stat_id, &stat_id[0], 8) == 0) {
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
+    if (*num_stats == 0) { /* Return all stats */
+        expected_buffsize = SCM_STATS_MIN_OUTPUT_BUFFER;
+    } else if (*num_stats > SCM_STATS_MAX_STATS) {
+        /* Too many stats requested */
+        return H_P3;
+    } else { /* Return a subset of stats */
+        expected_buffsize = sizeof(struct papr_scm_perf_stats) +
+            (*num_stats) * sizeof(struct papr_scm_perf_stat);
+    }
+
+    if (size < expected_buffsize || size > SCM_STATS_MAX_OUTPUT_BUFFER) {
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
+    struct papr_scm_perf_stats *perfstats;
+    struct papr_scm_perf_stat *stats;
+    uint64_t invalid_stat = 0, stat_val;
+    MemTxResult result;
+    uint32_t num_stats;
+    unsigned long rc;
+    int index;
+
+    /* Ensure that the drc is valid & is valid PMEM dimm and is plugged in */
+    if (!drc || !drc->dev ||
+        spapr_drc_type(drc) != SPAPR_DR_CONNECTOR_TYPE_PMEM) {
+        return H_PARAMETER;
+    }
+
+    /* Guest requested max buffer size for output buffer */
+    if (size == 0) {
+        args[0] = SCM_STATS_MAX_OUTPUT_BUFFER;
+        return H_SUCCESS;
+    }
+
+    /* verify size is enough to hold rr-buffer header */
+    if (size < sizeof(struct papr_scm_perf_stats)) {
+        return H_BAD_DATA;
+    }
+
+    /* allocate enough buffer space locally for holding max stats */
+    perfstats = g_try_malloc0(SCM_STATS_MAX_OUTPUT_BUFFER);
+    if (!perfstats) {
+        return H_NO_MEM;
+    }
+
+    /* Read and verify rr-buffer header */
+    result = address_space_read(&address_space_memory, addr,
+                                MEMTXATTRS_UNSPECIFIED, perfstats,
+                                sizeof(struct papr_scm_perf_stats));
+    rc = (result == MEMTX_OK) ?
+        scm_perf_check_rr_buffer(perfstats, addr, size, &num_stats) :
+        H_PRIVILEGE;
+    if (rc != H_SUCCESS) {
+        g_free(perfstats);
+        return rc;
+    }
+
+    stats = &perfstats->scm_statistics[0];
+    /* when returning all stats generate a canned response first */
+    if (num_stats == 0) {
+        for (index = 1; index < ARRAY_SIZE(nvdimm_perf_stats); ++index) {
+            memcpy(&stats[index - 1].statistic_id,
+                   &nvdimm_perf_stats[index].stat_id, 8);
+        }
+        num_stats = ARRAY_SIZE(nvdimm_perf_stats) - 1;
+    } else {
+        /* copy the rr-buffer from the guest memory */
+        result = address_space_read(&address_space_memory,
+                                    addr + sizeof(struct papr_scm_perf_stats),
+                                    MEMTXATTRS_UNSPECIFIED, stats,
+                                    size - sizeof(struct papr_scm_perf_stats));
+        if (result != MEMTX_OK) {
+            g_free(perfstats);
+            return H_PRIVILEGE;
+        }
+    }
+
+    for (index = 0; index < num_stats; ++index) {
+        rc = nvdimm_stat_getval(drc, stats[index].statistic_id, &stat_val);
+
+        /* On error add noop stat to rr buffer & save last inval stat-id */
+        if (rc != H_SUCCESS) {
+            if (!invalid_stat) {
+                invalid_stat = stats[index].statistic_id;
+            }
+            memcpy(&stats[index].statistic_id, nvdimm_perf_stats[0].stat_id, 8);
+        }
+        /* Caller expects stat values in BE encoding */
+        stats[index].statistic_value = cpu_to_be64(stat_val);
+    }
+
+    /* Update and copy the local rr-buffer back to guest */
+    perfstats->num_statistics = cpu_to_be32(num_stats);
+    g_assert(size <= SCM_STATS_MAX_OUTPUT_BUFFER);
+    result = address_space_write(&address_space_memory, addr,
+                                 MEMTXATTRS_UNSPECIFIED, perfstats, size);
+
+    /* Cleanup the stats buffer */
+    g_free(perfstats);
+    if (result) {
+        return H_PRIVILEGE;
+    }
+    /* Check if there was a failure in fetching any stat */
+    args[0] = invalid_stat;
+    return invalid_stat ? H_PARTIAL : H_SUCCESS;
+}
+
 static void spapr_scm_register_types(void)
 {
     /* qemu/scm specific hcalls */
@@ -511,6 +732,7 @@ static void spapr_scm_register_types(void)
     spapr_register_hypercall(H_SCM_UNBIND_MEM, h_scm_unbind_mem);
     spapr_register_hypercall(H_SCM_UNBIND_ALL, h_scm_unbind_all);
     spapr_register_hypercall(H_SCM_HEALTH, h_scm_health);
+    spapr_register_hypercall(H_SCM_PERFORMANCE_STATS, h_scm_performance_stats);
 }
 
 type_init(spapr_scm_register_types)
diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index d2b5a9bdf9..6f3353b4ea 100644
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
@@ -787,6 +789,21 @@ OBJECT_DECLARE_SIMPLE_TYPE(SpaprTceTable, SPAPR_TCE_TABLE)
 DECLARE_INSTANCE_CHECKER(IOMMUMemoryRegion, SPAPR_IOMMU_MEMORY_REGION,
                          TYPE_SPAPR_IOMMU_MEMORY_REGION)
 
+/* Defs and structs exchanged with guest when reporting drc perf stats */
+#define SCM_STATS_EYECATCHER "SCMSTATS"
+
+struct QEMU_PACKED papr_scm_perf_stat {
+    uint64_t statistic_id;
+    uint64_t statistic_value;
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

