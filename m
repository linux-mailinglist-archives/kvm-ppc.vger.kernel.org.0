Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49910199607
	for <lists+kvm-ppc@lfdr.de>; Tue, 31 Mar 2020 14:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbgCaML2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 31 Mar 2020 08:11:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40580 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730358AbgCaML2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 31 Mar 2020 08:11:28 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02VC3jjL031124;
        Tue, 31 Mar 2020 08:11:17 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 303uj37ff1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Mar 2020 08:11:17 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02VC3xlw032316;
        Tue, 31 Mar 2020 08:11:16 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 303uj37feh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Mar 2020 08:11:16 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02VCAMqQ005821;
        Tue, 31 Mar 2020 12:11:15 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01dal.us.ibm.com with ESMTP id 301x776t70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Mar 2020 12:11:15 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02VCBFxG38601170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Mar 2020 12:11:15 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FC12112063;
        Tue, 31 Mar 2020 12:11:15 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD133112061;
        Tue, 31 Mar 2020 12:11:14 +0000 (GMT)
Received: from sofia.ibm.com (unknown [9.85.71.250])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 31 Mar 2020 12:11:14 +0000 (GMT)
Received: by sofia.ibm.com (Postfix, from userid 1000)
        id A64672E3B08; Tue, 31 Mar 2020 17:41:10 +0530 (IST)
From:   "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Neuling <mikey@neuling.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        David Gibson <david@gibson.dropbear.id.au>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@ozlabs.org,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>
Subject: [RFC/PATCH  3/3] cpuidle/pseries: Add stop0lite state
Date:   Tue, 31 Mar 2020 17:40:58 +0530
Message-Id: <1585656658-1838-4-git-send-email-ego@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1585656658-1838-1-git-send-email-ego@linux.vnet.ibm.com>
References: <1585656658-1838-1-git-send-email-ego@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-03-31_04:2020-03-31,2020-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 impostorscore=0 adultscore=0 mlxlogscore=746 lowpriorityscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 phishscore=0 clxscore=1011
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003310106
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>

The POWER ISA v3.0 allows stop instruction to be executed from a
HV=0,PR=0 context. If the PSSCR[ESL|EC] bits are cleared, then the
stop instruction thus executed will cause the thread to pause, thereby
donating its cycles to the other threads in the core until the paused
thread is woken up by an interrupt.

In this patch we define a cpuidle state for pseries guests named
stop0lite. This has a latency and residency intermediate to that of
snooze and CEDE. While snooze has non-existent latency, it consumes
the CPU cycles without contributing to anything useful. CEDE on the
other hand requires a full VM exit, which can result in some other
vCPU being scheduled on this physical CPU thereby delaying the
scheduling of the CEDEd vCPU back. In such cases, when the expected
idle duration is small (1-20us), the vCPU can go to this stop0lite
state which provides a nice intermediate state between snooze and
CEDE.

Signed-off-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
---
 drivers/cpuidle/cpuidle-pseries.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/cpuidle/cpuidle-pseries.c b/drivers/cpuidle/cpuidle-pseries.c
index 74c2479..9c8c18d 100644
--- a/drivers/cpuidle/cpuidle-pseries.c
+++ b/drivers/cpuidle/cpuidle-pseries.c
@@ -20,6 +20,7 @@
 #include <asm/firmware.h>
 #include <asm/runlatch.h>
 #include <asm/plpar_wrappers.h>
+#include <asm/processor.h>
 
 struct cpuidle_driver pseries_idle_driver = {
 	.name             = "pseries_idle",
@@ -170,6 +171,26 @@ static int shared_cede_loop(struct cpuidle_device *dev,
 		.enter = &dedicated_cede_loop },
 };
 
+
+
+static int stop_loop(struct cpuidle_device *dev,
+		     struct cpuidle_driver *drv,
+		     int index)
+{
+	unsigned long srr1 = 0;
+
+	if (!prep_irq_for_idle_irqsoff())
+		return index;
+
+	__ppc64_runlatch_off();
+	asm volatile("stop");
+	__ppc64_runlatch_on();
+	fini_irq_for_idle_irqsoff();
+	irq_set_pending_from_srr1(srr1);
+
+	return index;
+}
+
 /*
  * States for shared partition case.
  */
@@ -180,6 +201,12 @@ static int shared_cede_loop(struct cpuidle_device *dev,
 		.exit_latency = 0,
 		.target_residency = 0,
 		.enter = &snooze_loop },
+	{ /* stop0_lite */
+		.name = "stop0lite",
+		.desc = "Pauses the CPU",
+		.exit_latency = 2,
+		.target_residency=20,
+		.enter = &stop_loop },
 	{ /* Shared Cede */
 		.name = "Shared Cede",
 		.desc = "Shared Cede",
-- 
1.9.4

