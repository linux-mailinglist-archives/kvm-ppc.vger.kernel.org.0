Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFB4191AAD
	for <lists+kvm-ppc@lfdr.de>; Tue, 24 Mar 2020 21:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbgCXUMf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 24 Mar 2020 16:12:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64790 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727088AbgCXUMe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 24 Mar 2020 16:12:34 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02OK3X6t083161;
        Tue, 24 Mar 2020 16:12:19 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywdr6h974-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Mar 2020 16:12:19 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02OK5fnJ031785;
        Tue, 24 Mar 2020 20:12:18 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02dal.us.ibm.com with ESMTP id 2ywaw22ukx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Mar 2020 20:12:18 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02OKCHLT50987312
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 20:12:18 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA88DAE062;
        Tue, 24 Mar 2020 20:12:17 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FD4AAE060;
        Tue, 24 Mar 2020 20:12:16 +0000 (GMT)
Received: from farosas.linux.ibm.com.ibmuc.com (unknown [9.85.129.145])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 Mar 2020 20:12:16 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org,
        linuxram@us.ibm.com
Subject: [PATCH] powerpc/prom_init: Include the termination message in ibm,os-term RTAS call
Date:   Tue, 24 Mar 2020 17:12:11 -0300
Message-Id: <20200324201211.1055236-1-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_07:2020-03-23,2020-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240096
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

QEMU can now print the ibm,os-term message[1], so let's include it in
the RTAS call. E.g.:

  qemu-system-ppc64: OS terminated: Switch to secure mode failed.

1- https://git.qemu.org/?p=qemu.git;a=commitdiff;h=a4c3791ae0

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kernel/prom_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 577345382b23..d543fb6d29c5 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -1773,6 +1773,9 @@ static void __init prom_rtas_os_term(char *str)
 	if (token == 0)
 		prom_panic("Could not get token for ibm,os-term\n");
 	os_term_args.token = cpu_to_be32(token);
+	os_term_args.nargs = cpu_to_be32(1);
+	os_term_args.args[0] = cpu_to_be32(__pa(str));
+
 	prom_rtas_hcall((uint64_t)&os_term_args);
 }
 #endif /* CONFIG_PPC_SVM */
-- 
2.23.0

