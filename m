Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9049F8FE
	for <lists+kvm-ppc@lfdr.de>; Wed, 28 Aug 2019 05:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfH1D5A (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 27 Aug 2019 23:57:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27834 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726232AbfH1D5A (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 27 Aug 2019 23:57:00 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7S3q3uq110442;
        Tue, 27 Aug 2019 23:56:56 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2unhc1hr95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Aug 2019 23:56:56 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7S3t8aR021444;
        Wed, 28 Aug 2019 03:56:55 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 2ujvv6knqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Aug 2019 03:56:55 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7S3us8M40829290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 03:56:54 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4051B78063;
        Wed, 28 Aug 2019 03:56:54 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B68D7805C;
        Wed, 28 Aug 2019 03:56:51 +0000 (GMT)
Received: from rino.ibm.com (unknown [9.85.147.103])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 28 Aug 2019 03:56:50 +0000 (GMT)
From:   Claudio Carvalho <cclaudio@linux.ibm.com>
To:     linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>
Subject: [PATCH v3 2/2] powerpc/powernv: Add ultravisor message log interface
Date:   Wed, 28 Aug 2019 00:56:46 -0300
Message-Id: <20190828035646.907-2-cclaudio@linux.ibm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190828035646.907-1-cclaudio@linux.ibm.com>
References: <20190828035646.907-1-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-28_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908280039
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The ultravisor (UV) provides an in-memory console which follows the OPAL
in-memory console structure.

This patch extends the OPAL msglog code to initialize the UV memory
console and provide the "/sys/firmware/ultravisor/msglog" interface
for userspace to view the UV message log.

Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
---
This patch applies on top of the "kvmppc: Paravirtualize KVM to support
ultravisor" patch series submitted by Claudio Carvalho.
---
 arch/powerpc/include/asm/ultravisor.h        |  8 ++++
 arch/powerpc/platforms/powernv/opal-msglog.c | 36 ++++++++++++++++++
 arch/powerpc/platforms/powernv/ultravisor.c  | 40 ++++++++++++++++++++
 3 files changed, 84 insertions(+)

diff --git a/arch/powerpc/include/asm/ultravisor.h b/arch/powerpc/include/asm/ultravisor.h
index d7aa97aa7834..62932d403847 100644
--- a/arch/powerpc/include/asm/ultravisor.h
+++ b/arch/powerpc/include/asm/ultravisor.h
@@ -12,6 +12,14 @@
 #include <asm/ultravisor-api.h>
 #include <asm/firmware.h>
 
+/* /sys/firmware/ultravisor */
+extern struct kobject *ultravisor_kobj;
+
+/* /ibm,ultravisor/ibm,uv-firmware */
+extern struct device_node *uv_firmware_node;
+
+void ultra_msglog_init(void);
+void ultra_msglog_sysfs_init(void);
 int early_init_dt_scan_ultravisor(unsigned long node, const char *uname,
 				  int depth, void *data);
 
diff --git a/arch/powerpc/platforms/powernv/opal-msglog.c b/arch/powerpc/platforms/powernv/opal-msglog.c
index 0e8eb62c8afe..7c6b2001e62f 100644
--- a/arch/powerpc/platforms/powernv/opal-msglog.c
+++ b/arch/powerpc/platforms/powernv/opal-msglog.c
@@ -11,6 +11,7 @@
 #include <linux/of.h>
 #include <linux/types.h>
 #include <asm/barrier.h>
+#include <asm/ultravisor.h>
 
 /* OPAL in-memory console. Defined in OPAL source at core/console.c */
 struct memcons {
@@ -28,6 +29,7 @@ struct memcons {
 };
 
 static struct memcons *opal_memcons = NULL;
+static struct memcons *ultra_memcons;
 
 static ssize_t memcons_copy(struct memcons *mc, char *to, loff_t pos,
 			   size_t count)
@@ -104,6 +106,18 @@ static struct bin_attribute opal_msglog_attr = {
 	.read = opal_msglog_read
 };
 
+static ssize_t ultra_msglog_read(struct file *file, struct kobject *kobj,
+				struct bin_attribute *bin_attr, char *to,
+				loff_t pos, size_t count)
+{
+	return memcons_copy(ultra_memcons, to, pos, count);
+}
+
+static struct bin_attribute ultra_msglog_attr = {
+	.attr = {.name = "msglog", .mode = 0400},
+	.read = ultra_msglog_read
+};
+
 static struct memcons *memcons_load_from_dt(struct device_node *node,
 					    const char *mc_prop_name)
 {
@@ -159,3 +173,25 @@ void __init opal_msglog_sysfs_init(void)
 	if (sysfs_create_bin_file(opal_kobj, &opal_msglog_attr) != 0)
 		pr_warn("OPAL: sysfs file creation failed\n");
 }
+
+void __init ultra_msglog_init(void)
+{
+	ultra_memcons = memcons_load_from_dt(uv_firmware_node, "memcons");
+	if (!ultra_memcons) {
+		pr_warn("Ultravisor: memcons failed to load from DT\n");
+		return;
+	}
+
+	ultra_msglog_attr.size = memcons_get_size(ultra_memcons);
+}
+
+void __init ultra_msglog_sysfs_init(void)
+{
+	if (!ultra_memcons) {
+		pr_warn("Ultravisor: msglog initialisation failed, not creating sysfs entry\n");
+		return;
+	}
+
+	if (sysfs_create_bin_file(ultravisor_kobj, &ultra_msglog_attr) != 0)
+		pr_warn("Ultravisor: sysfs msglog file creation failed\n");
+}
diff --git a/arch/powerpc/platforms/powernv/ultravisor.c b/arch/powerpc/platforms/powernv/ultravisor.c
index 02ac57b4bded..4ec63b7c0c78 100644
--- a/arch/powerpc/platforms/powernv/ultravisor.c
+++ b/arch/powerpc/platforms/powernv/ultravisor.c
@@ -8,9 +8,14 @@
 #include <linux/init.h>
 #include <linux/printk.h>
 #include <linux/of_fdt.h>
+#include <linux/of.h>
 
 #include <asm/ultravisor.h>
 #include <asm/firmware.h>
+#include <asm/machdep.h>
+
+struct kobject *ultravisor_kobj;
+struct device_node *uv_firmware_node;
 
 int __init early_init_dt_scan_ultravisor(unsigned long node, const char *uname,
 					 int depth, void *data)
@@ -22,3 +27,38 @@ int __init early_init_dt_scan_ultravisor(unsigned long node, const char *uname,
 	pr_debug("Ultravisor detected!\n");
 	return 1;
 }
+
+static int __init ultra_sysfs_init(void)
+{
+	ultravisor_kobj = kobject_create_and_add("ultravisor", firmware_kobj);
+	if (!ultravisor_kobj) {
+		pr_warn("kobject_create_and_add ultravisor failed\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int __init ultra_init(void)
+{
+	int rc;
+
+	if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
+		goto out;
+
+	uv_firmware_node = of_find_compatible_node(NULL, NULL,
+						   "ibm,uv-firmware");
+	if (!uv_firmware_node) {
+		pr_err("ibm,uv-firmware node not found\n");
+		return -ENODEV;
+	}
+
+	ultra_msglog_init();
+
+	rc = ultra_sysfs_init();
+	if (rc == 0)
+		ultra_msglog_sysfs_init();
+out:
+	return 0;
+}
+machine_subsys_initcall(powernv, ultra_init);
-- 
2.20.1

