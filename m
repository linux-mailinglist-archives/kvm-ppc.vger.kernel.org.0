Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6C126BC48
	for <lists+kvm-ppc@lfdr.de>; Wed, 16 Sep 2020 08:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgIPGMQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 16 Sep 2020 02:12:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43836 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726068AbgIPGMP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 16 Sep 2020 02:12:15 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08G62ZqJ100274;
        Wed, 16 Sep 2020 02:11:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=zpQLGYprIJVoDk6lF9ZtdIAdspfOziYDgtS7miJMIT4=;
 b=dyBFUMw5lP1zdE0clQOl05X3BpZkOdRQLQhoeeXPXyy/zSVgPXvVlrKw0CSI3BjQGUUI
 vUOwEYG8Va0Yzep6PHwiIN+rnP9xCUIN4a58EyjiobVeKzomgsmqbkfPgJ6tN1PQ1fbI
 PeZJDIMHAPTAV/Tj3J9Z/plb6hE1rzzOJGJXzyjZR4FaCyI/D34RDw+kOxqJ6IREp5Xe
 NBJbPVr7PTrEvF/mxAQWsnzNsTq67QLwK83QlUDsP7GWfsGTxt+f2rUxJmyDG+QoUs0s
 /0z3irpknbcas8soy3nN64KDvlNDGZGt0UcipbKglLFkYvtXfas2tZ9H33n9EJXNKu6a Wg== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33kaf4v0p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Sep 2020 02:11:57 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08G5qt0J012875;
        Wed, 16 Sep 2020 06:11:55 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 33k64s85gf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Sep 2020 06:11:54 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08G6BqJg20709678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 06:11:52 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 874CAA405C;
        Wed, 16 Sep 2020 06:11:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6578FA4066;
        Wed, 16 Sep 2020 06:11:50 +0000 (GMT)
Received: from satheesh.ibmuc.com (unknown [9.85.113.207])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Sep 2020 06:11:50 +0000 (GMT)
From:   sathnaga@linux.vnet.ibm.com
To:     linux-doc@vger.kernel.org
Cc:     Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] Doc: admin-guide: Add entry for kvm_cma_resv_ratio kernel param
Date:   Wed, 16 Sep 2020 11:41:30 +0530
Message-Id: <20200916061130.723411-1-sathnaga@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-16_02:2020-09-15,2020-09-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 clxscore=1011 lowpriorityscore=0 mlxlogscore=999 impostorscore=0
 mlxscore=0 malwarescore=0 suspectscore=3 spamscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160043
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>

Add document entry for kvm_cma_resv_ratio kernel param which
is used to alter the KVM contiguous memory allocation percentage
for hash pagetable allocation used by hash mode PowerPC KVM guests.

Cc: linux-kernel@vger.kernel.org
Cc: kvm-ppc@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Jonathan Corbet <corbet@lwn.net>  
Signed-off-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index a1068742a6df..9cb126573c71 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -599,6 +599,15 @@
 			altogether. For more information, see
 			include/linux/dma-contiguous.h
 
+        kvm_cma_resv_ratio=n
+                        [PPC]
+                        Reserves given percentage from system memory area for
+                        contiguous memory allocation for KVM hash pagetable
+                        allocation.
+                        Bydefault it reserves 5% of total system memory.
+                        Format: <integer>
+                        Default: 5
+
 	cmo_free_hint=	[PPC] Format: { yes | no }
 			Specify whether pages are marked as being inactive
 			when they are freed.  This is used in CMO environments
-- 
2.26.2

