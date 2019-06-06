Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1A337B2E
	for <lists+kvm-ppc@lfdr.de>; Thu,  6 Jun 2019 19:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730194AbfFFRgf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 6 Jun 2019 13:36:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47878 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730192AbfFFRgf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 6 Jun 2019 13:36:35 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56HTvce019064
        for <kvm-ppc@vger.kernel.org>; Thu, 6 Jun 2019 13:36:34 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sy5c8ec1n-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Thu, 06 Jun 2019 13:36:34 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <cclaudio@linux.ibm.com>;
        Thu, 6 Jun 2019 18:36:33 +0100
Received: from b01cxnp23032.gho.pok.ibm.com (9.57.198.27)
        by e13.ny.us.ibm.com (146.89.104.200) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Jun 2019 18:36:30 +0100
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x56HaTW639190838
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jun 2019 17:36:29 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7654FAC05B;
        Thu,  6 Jun 2019 17:36:29 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAC9AAC059;
        Thu,  6 Jun 2019 17:36:27 +0000 (GMT)
Received: from rino.br.ibm.com (unknown [9.18.235.79])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu,  6 Jun 2019 17:36:27 +0000 (GMT)
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
Subject: [PATCH v3 6/9] KVM: PPC: Ultravisor: Restrict flush of the partition tlb cache
Date:   Thu,  6 Jun 2019 14:36:11 -0300
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190606173614.32090-1-cclaudio@linux.ibm.com>
References: <20190606173614.32090-1-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19060617-0064-0000-0000-000003EAB7F6
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011224; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01214150; UDB=6.00638204; IPR=6.00995229;
 MB=3.00027209; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-06 17:36:32
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060617-0065-0000-0000-00003DC76FA1
Message-Id: <20190606173614.32090-7-cclaudio@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060117
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Ram Pai <linuxram@us.ibm.com>

Ultravisor is responsible for flushing the tlb cache, since it manages
the PATE entries. Hence skip tlb flush, if the ultravisor firmware is
available.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
---
 arch/powerpc/mm/book3s64/pgtable.c | 33 +++++++++++++++++-------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
index 40a9fc8b139f..1eeb5fe87023 100644
--- a/arch/powerpc/mm/book3s64/pgtable.c
+++ b/arch/powerpc/mm/book3s64/pgtable.c
@@ -224,6 +224,23 @@ void __init mmu_partition_table_init(void)
 	powernv_set_nmmu_ptcr(ptcr);
 }
 
+static void flush_partition(unsigned int lpid, unsigned long dw0)
+{
+	if (dw0 & PATB_HR) {
+		asm volatile(PPC_TLBIE_5(%0, %1, 2, 0, 1) : :
+			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
+		asm volatile(PPC_TLBIE_5(%0, %1, 2, 1, 1) : :
+			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
+		trace_tlbie(lpid, 0, TLBIEL_INVAL_SET_LPID, lpid, 2, 0, 1);
+	} else {
+		asm volatile(PPC_TLBIE_5(%0, %1, 2, 0, 0) : :
+			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
+		trace_tlbie(lpid, 0, TLBIEL_INVAL_SET_LPID, lpid, 2, 0, 0);
+	}
+	/* do we need fixup here ?*/
+	asm volatile("eieio; tlbsync; ptesync" : : : "memory");
+}
+
 static void __mmu_partition_table_set_entry(unsigned int lpid,
 					    unsigned long dw0,
 					    unsigned long dw1)
@@ -238,20 +255,8 @@ static void __mmu_partition_table_set_entry(unsigned int lpid,
 	 * The type of flush (hash or radix) depends on what the previous
 	 * use of this partition ID was, not the new use.
 	 */
-	asm volatile("ptesync" : : : "memory");
-	if (old & PATB_HR) {
-		asm volatile(PPC_TLBIE_5(%0,%1,2,0,1) : :
-			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
-		asm volatile(PPC_TLBIE_5(%0,%1,2,1,1) : :
-			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
-		trace_tlbie(lpid, 0, TLBIEL_INVAL_SET_LPID, lpid, 2, 0, 1);
-	} else {
-		asm volatile(PPC_TLBIE_5(%0,%1,2,0,0) : :
-			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
-		trace_tlbie(lpid, 0, TLBIEL_INVAL_SET_LPID, lpid, 2, 0, 0);
-	}
-	/* do we need fixup here ?*/
-	asm volatile("eieio; tlbsync; ptesync" : : : "memory");
+	if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
+		flush_partition(lpid, old);
 }
 
 void mmu_partition_table_set_entry(unsigned int lpid, unsigned long dw0,
-- 
2.20.1

