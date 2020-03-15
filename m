Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68734186043
	for <lists+kvm-ppc@lfdr.de>; Sun, 15 Mar 2020 23:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbgCOWiH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 15 Mar 2020 18:38:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55148 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729275AbgCOWiH (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 15 Mar 2020 18:38:07 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02FMXqxv107830
        for <kvm-ppc@vger.kernel.org>; Sun, 15 Mar 2020 18:38:06 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yrus5b00f-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Sun, 15 Mar 2020 18:38:06 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <linuxram@us.ibm.com>;
        Sun, 15 Mar 2020 22:38:04 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 15 Mar 2020 22:38:00 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02FMawwF44826954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 15 Mar 2020 22:36:58 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 475F0AE06F;
        Sun, 15 Mar 2020 22:37:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A04EEAE073;
        Sun, 15 Mar 2020 22:37:56 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.80.222.34])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 15 Mar 2020 22:37:56 +0000 (GMT)
From:   Ram Pai <linuxram@us.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     mpe@ellerman.id.au, bauerman@linux.ibm.com, andmike@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, aik@ozlabs.ru, paulus@ozlabs.org,
        groug@kaod.org, clg@fr.ibm.com, david@gibson.dropbear.id.au
Subject: [RFC PATCH v1] powerpc/XIVE: SVM: share the event-queue page with the Hypervisor.
Date:   Sun, 15 Mar 2020 15:37:32 -0700
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
x-cbid: 20031522-0008-0000-0000-0000035DBEA1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031522-0009-0000-0000-00004A7F0FD7
Message-Id: <1584311852-15471-1-git-send-email-linuxram@us.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-15_04:2020-03-12,2020-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 mlxscore=0
 adultscore=0 phishscore=0 mlxlogscore=991 malwarescore=0 bulkscore=0
 spamscore=0 suspectscore=48 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003150121
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

XIVE interrupt controller maintains a Event-Queue(EQ) page. This page is
used to communicate events with the Hypervisor/Qemu. In Secure-VM,
unless a page is shared with the Hypervisor, the Hypervisor will
not be able to read/write to that page.

Explicitly share the EQ page with the Hypervisor, and unshare it
during cleanup.  This enables SVM to use XIVE.

(NOTE: If the Hypervisor/Ultravisor is unable to target interrupts
 directly to Secure VM, use "kernel_irqchip=off" on the qemu command
 line).

Cc: kvm-ppc@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc: Michael Anderson <andmike@linux.ibm.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Greg Kurz <groug@kaod.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 arch/powerpc/sysdev/xive/spapr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/powerpc/sysdev/xive/spapr.c b/arch/powerpc/sysdev/xive/spapr.c
index 55dc61c..608b52f 100644
--- a/arch/powerpc/sysdev/xive/spapr.c
+++ b/arch/powerpc/sysdev/xive/spapr.c
@@ -26,6 +26,8 @@
 #include <asm/xive.h>
 #include <asm/xive-regs.h>
 #include <asm/hvcall.h>
+#include <asm/svm.h>
+#include <asm/ultravisor.h>
 
 #include "xive-internal.h"
 
@@ -501,6 +503,9 @@ static int xive_spapr_configure_queue(u32 target, struct xive_q *q, u8 prio,
 		rc = -EIO;
 	} else {
 		q->qpage = qpage;
+		if (is_secure_guest())
+			uv_share_page(PHYS_PFN(qpage_phys),
+					1 << xive_alloc_order(order));
 	}
 fail:
 	return rc;
@@ -534,6 +539,8 @@ static void xive_spapr_cleanup_queue(unsigned int cpu, struct xive_cpu *xc,
 		       hw_cpu, prio);
 
 	alloc_order = xive_alloc_order(xive_queue_shift);
+	if (is_secure_guest())
+		uv_unshare_page(PHYS_PFN(__pa(q->qpage)), 1 << alloc_order);
 	free_pages((unsigned long)q->qpage, alloc_order);
 	q->qpage = NULL;
 }
-- 
1.8.3.1

