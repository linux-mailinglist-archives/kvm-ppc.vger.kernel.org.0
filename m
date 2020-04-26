Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99221B8D6D
	for <lists+kvm-ppc@lfdr.de>; Sun, 26 Apr 2020 09:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgDZH1i (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 26 Apr 2020 03:27:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43004 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725847AbgDZH1i (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 26 Apr 2020 03:27:38 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03Q72E8j135098
        for <kvm-ppc@vger.kernel.org>; Sun, 26 Apr 2020 03:27:37 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mh9k6vn4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Sun, 26 Apr 2020 03:27:37 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <linuxram@us.ibm.com>;
        Sun, 26 Apr 2020 08:26:43 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 26 Apr 2020 08:26:40 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03Q7RTmh62783494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Apr 2020 07:27:29 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBD4C5204E;
        Sun, 26 Apr 2020 07:27:29 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.85.192.49])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 32DDB5204F;
        Sun, 26 Apr 2020 07:27:27 +0000 (GMT)
Date:   Sun, 26 Apr 2020 00:27:24 -0700
From:   Ram Pai <linuxram@us.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     aik@ozlabs.ru, andmike@linux.ibm.com, groug@kaod.org,
        sukadev@linux.vnet.ibm.com, bauerman@linux.ibm.com,
        david@gibson.dropbear.id.au, clg@kaod.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
Subject: [PATCH v3] powerpc/XIVE: SVM: share the event-queue page with the
 Hypervisor.
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1585211927-784-1-git-send-email-linuxram@us.ibm.com>
 <20200426020518.GC5853@oc0525413822.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426020518.GC5853@oc0525413822.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 20042607-4275-0000-0000-000003C6422F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042607-4276-0000-0000-000038DBD216
Message-Id: <20200426072724.GB5865@oc0525413822.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-25_14:2020-04-24,2020-04-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=48 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004260060
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

XIVE interrupt controller uses an Event Queue (EQ) to enqueue event
notifications when an exception occurs. The EQ is a single memory page
provided by the O/S defining a circular buffer, one per server and
priority couple.

On baremetal, the EQ page is configured with an OPAL call. On pseries,
an extra hop is necessary and the guest OS uses the hcall
H_INT_SET_QUEUE_CONFIG to configure the XIVE interrupt controller.

The XIVE controller being Hypervisor privileged, it will not be allowed
to enqueue event notifications for a Secure VM unless the EQ pages are
shared by the Secure VM.

Hypervisor/Ultravisor still requires support for the TIMA and ESB page
fault handlers. Until this is complete, QEMU can use the emulated XIVE
device for Secure VMs, option "kernel_irqchip=off" on the QEMU pseries
machine.

Cc: kvm-ppc@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc: Michael Anderson <andmike@linux.ibm.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: David Gibson <david@gibson.dropbear.id.au>
Reviewed-by: Cedric Le Goater <clg@kaod.org>
Reviewed-by: Greg Kurz <groug@kaod.org>
Signed-off-by: Ram Pai <linuxram@us.ibm.com>

v3: fix a minor semantics in description.
    and added reviewed-by from Cedric and Greg.
v2: better description of the patch from Cedric.
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

