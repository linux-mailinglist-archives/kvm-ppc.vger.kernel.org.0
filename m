Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0A4D37B28
	for <lists+kvm-ppc@lfdr.de>; Thu,  6 Jun 2019 19:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730191AbfFFRg0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 6 Jun 2019 13:36:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39984 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730190AbfFFRg0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 6 Jun 2019 13:36:26 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56HTspx091805
        for <kvm-ppc@vger.kernel.org>; Thu, 6 Jun 2019 13:36:25 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sy4p8h2yd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Thu, 06 Jun 2019 13:36:25 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <cclaudio@linux.ibm.com>;
        Thu, 6 Jun 2019 18:36:24 +0100
Received: from b01cxnp22036.gho.pok.ibm.com (9.57.198.26)
        by e17.ny.us.ibm.com (146.89.104.204) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Jun 2019 18:36:22 +0100
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x56HaLAf41812282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jun 2019 17:36:21 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DB8EAC05F;
        Thu,  6 Jun 2019 17:36:21 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41063AC05E;
        Thu,  6 Jun 2019 17:36:19 +0000 (GMT)
Received: from rino.br.ibm.com (unknown [9.18.235.79])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu,  6 Jun 2019 17:36:19 +0000 (GMT)
From:   Claudio Carvalho <cclaudio@linux.ibm.com>
To:     linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauermann@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Claudio Carvalho <cclaudio@linux.ibm.com>
Subject: [PATCH v3 2/9] KVM: PPC: Ultravisor: Introduce the MSR_S bit
Date:   Thu,  6 Jun 2019 14:36:07 -0300
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190606173614.32090-1-cclaudio@linux.ibm.com>
References: <20190606173614.32090-1-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19060617-0040-0000-0000-000004F9A3F3
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011224; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01214149; UDB=6.00638204; IPR=6.00995229;
 MB=3.00027209; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-06 17:36:23
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060617-0041-0000-0000-00000905C3C6
Message-Id: <20190606173614.32090-3-cclaudio@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=722 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060117
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

The ultravisor processor mode is introduced in POWER platforms that
supports the Protected Execution Facility (PEF). Ultravisor is higher
privileged than hypervisor mode.

In PEF enabled platforms, the MSR_S bit is used to indicate if the
thread is in secure state. With the MSR_S bit, the privilege state of
the thread is now determined by MSR_S, MSR_HV and MSR_PR, as follows:

S   HV  PR
-----------------------
0   x   1   problem
1   0   1   problem
x   x   0   privileged
x   1   0   hypervisor
1   1   0   ultravisor
1   1   1   reserved

The hypervisor doesn't (and can't) run with the MSR_S bit set, but a
secure guest and the ultravisor firmware do.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
[Update the commit message]
Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
---
 arch/powerpc/include/asm/reg.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index 10caa145f98b..39b4c0a519f5 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -38,6 +38,7 @@
 #define MSR_TM_LG	32		/* Trans Mem Available */
 #define MSR_VEC_LG	25	        /* Enable AltiVec */
 #define MSR_VSX_LG	23		/* Enable VSX */
+#define MSR_S_LG	22		/* Secure VM bit */
 #define MSR_POW_LG	18		/* Enable Power Management */
 #define MSR_WE_LG	18		/* Wait State Enable */
 #define MSR_TGPR_LG	17		/* TLB Update registers in use */
@@ -71,11 +72,13 @@
 #define MSR_SF		__MASK(MSR_SF_LG)	/* Enable 64 bit mode */
 #define MSR_ISF		__MASK(MSR_ISF_LG)	/* Interrupt 64b mode valid on 630 */
 #define MSR_HV 		__MASK(MSR_HV_LG)	/* Hypervisor state */
+#define MSR_S		__MASK(MSR_S_LG)	/* Secure state */
 #else
 /* so tests for these bits fail on 32-bit */
 #define MSR_SF		0
 #define MSR_ISF		0
 #define MSR_HV		0
+#define MSR_S		0
 #endif
 
 /*
-- 
2.20.1

