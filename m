Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2434817B2F2
	for <lists+kvm-ppc@lfdr.de>; Fri,  6 Mar 2020 01:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgCFA2v (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 5 Mar 2020 19:28:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43548 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726173AbgCFA2v (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 5 Mar 2020 19:28:51 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0260Kx2w110369
        for <kvm-ppc@vger.kernel.org>; Thu, 5 Mar 2020 19:28:50 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yhr4kvjb8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Thu, 05 Mar 2020 19:28:49 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <gromero@linux.ibm.com>;
        Fri, 6 Mar 2020 00:28:48 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 6 Mar 2020 00:28:46 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0260SjND38666658
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Mar 2020 00:28:45 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F39011C050;
        Fri,  6 Mar 2020 00:28:45 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF83911C04A;
        Fri,  6 Mar 2020 00:28:44 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Mar 2020 00:28:44 +0000 (GMT)
Received: from bran.ozlabs.ibm.com (haven.au.ibm.com [9.192.254.114])
        by ozlabs.au.ibm.com (Postfix) with ESMTP id 06BA3A011F;
        Fri,  6 Mar 2020 11:28:40 +1100 (AEDT)
Received: from oc6336877782.ibm.com (gustavo.ozlabs.ibm.com [10.61.2.143])
        by bran.ozlabs.ibm.com (Postfix) with ESMTP id CDA25E00FA;
        Fri,  6 Mar 2020 11:28:43 +1100 (AEDT)
From:   Gustavo Romero <gromero@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        Gustavo Romero <gromero@linux.ibm.com>
Subject: [PATCH] KVM: PPC: Book3S HV: Fix typos in comments
Date:   Fri,  6 Mar 2020 11:26:36 +1100
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
x-cbid: 20030600-0012-0000-0000-0000038D99C6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030600-0013-0000-0000-000021CA5A91
Message-Id: <1583454396-1424-1-git-send-email-gromero@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-05_08:2020-03-05,2020-03-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 mlxscore=0 phishscore=0 mlxlogscore=792 suspectscore=1 lowpriorityscore=0
 impostorscore=0 bulkscore=0 spamscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003060000
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Fix typos found in comments about the parameter passed
through r5 to kvmppc_{save,restore}_tm_hv functions.

Signed-off-by: Gustavo Romero <gromero@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index dbc2fec..a55dbe8 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -3121,7 +3121,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
  * Save transactional state and TM-related registers.
  * Called with r3 pointing to the vcpu struct and r4 containing
  * the guest MSR value.
- * r5 is non-zero iff non-volatile register state needs to be maintained.
+ * r5 is non-zero if non-volatile register state needs to be maintained.
  * If r5 == 0, this can modify all checkpointed registers, but
  * restores r1 and r2 before exit.
  */
@@ -3194,7 +3194,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_P9_TM_XER_SO_BUG)
  * Restore transactional state and TM-related registers.
  * Called with r3 pointing to the vcpu struct
  * and r4 containing the guest MSR value.
- * r5 is non-zero iff non-volatile register state needs to be maintained.
+ * r5 is non-zero if non-volatile register state needs to be maintained.
  * This potentially modifies all checkpointed registers.
  * It restores r1 and r2 from the PACA.
  */
-- 
1.8.3.1

