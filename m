Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4E7373ED8
	for <lists+kvm-ppc@lfdr.de>; Wed,  5 May 2021 17:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbhEEPsD (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 5 May 2021 11:48:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4732 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232410AbhEEPsC (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 5 May 2021 11:48:02 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 145FZ31E083210;
        Wed, 5 May 2021 11:46:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=c4URpvSct/0Ts3g+9mkhOsIWZGR9aerE8MhHfU/29Jc=;
 b=QBvest29vVnEow9jMEwtvRJUJJ4FDFDAdCoc3aq/mH/vj+0itgJuf+Bu1DU3vBBeh8dc
 8qAlKD5i/mLbaf2UQ90jmk6r/UFYLhdZ4ygami6LM5TOeGF0nV0sMjBn/mKL3V8Vv2xO
 Oi7Sp5evwESmgfPCSTmvWBpiw1CQ47y/7BozWrEuxVkP+jv+4yR+E5BhwaRSTm3G7BqV
 kFPF+ekF7Al73qOX/20S64+udK8iS6dp4fvbq50p6YwSRTJjIuAx9PrBHd6uw5GkEdv6
 NduH2RYlyC3LuOsinVvbkm16pdJ21DRUQltinKMEGDAgaTK00yE1/6U89zy2HThTZsvR Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38bvymjxua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 11:46:58 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 145FZUWi085268;
        Wed, 5 May 2021 11:46:58 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38bvymjxtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 11:46:58 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 145FcGW1005765;
        Wed, 5 May 2021 15:46:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 38bedxrd0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 15:46:55 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 145FkqtV46334250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 May 2021 15:46:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3B61AE055;
        Wed,  5 May 2021 15:46:52 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AF33AE051;
        Wed,  5 May 2021 15:46:51 +0000 (GMT)
Received: from bharata.ibmuc.com (unknown [9.85.85.70])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 May 2021 15:46:50 +0000 (GMT)
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     aneesh.kumar@linux.ibm.com, npiggin@gmail.com, paulus@ozlabs.org,
        mpe@ellerman.id.au, david@gibson.dropbear.id.au,
        farosas@linux.ibm.com, Bharata B Rao <bharata@linux.ibm.com>
Subject: [PATCH v7 2/6] powerpc/book3s64/radix: Add H_RPT_INVALIDATE pgsize encodings to mmu_psize_def
Date:   Wed,  5 May 2021 21:16:38 +0530
Message-Id: <20210505154642.178702-3-bharata@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210505154642.178702-1-bharata@linux.ibm.com>
References: <20210505154642.178702-1-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QH_XyRMLJKZLIJFaqBhsdcUHQc4AmpM7
X-Proofpoint-GUID: BqlpT6w0kEQNoTPvnRq2bo1i-sfKR2er
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-05_09:2021-05-05,2021-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050112
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Add a field to mmu_psize_def to store the page size encodings
of H_RPT_INVALIDATE hcall. Initialize this while scanning the radix
AP encodings. This will be used when invalidating with required
page size encoding in the hcall.

Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
Reviewed-by: David Gibson <david@gibson.dropbear.id.au>
---
 arch/powerpc/include/asm/book3s/64/mmu.h | 1 +
 arch/powerpc/mm/book3s64/radix_pgtable.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/arch/powerpc/include/asm/book3s/64/mmu.h b/arch/powerpc/include/asm/book3s/64/mmu.h
index eace8c3f7b0a..c02f42d1031e 100644
--- a/arch/powerpc/include/asm/book3s/64/mmu.h
+++ b/arch/powerpc/include/asm/book3s/64/mmu.h
@@ -19,6 +19,7 @@ struct mmu_psize_def {
 	int		penc[MMU_PAGE_COUNT];	/* HPTE encoding */
 	unsigned int	tlbiel;	/* tlbiel supported for that page size */
 	unsigned long	avpnm;	/* bits to mask out in AVPN in the HPTE */
+	unsigned long   h_rpt_pgsize; /* H_RPT_INVALIDATE page size encoding */
 	union {
 		unsigned long	sllp;	/* SLB L||LP (exact mask to use in slbmte) */
 		unsigned long ap;	/* Ap encoding used by PowerISA 3.0 */
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 5fef8db3b463..637db10d841e 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -486,6 +486,7 @@ static int __init radix_dt_scan_page_sizes(unsigned long node,
 		def = &mmu_psize_defs[idx];
 		def->shift = shift;
 		def->ap  = ap;
+		def->h_rpt_pgsize = psize_to_rpti_pgsize(idx);
 	}
 
 	/* needed ? */
@@ -560,9 +561,13 @@ void __init radix__early_init_devtree(void)
 		 */
 		mmu_psize_defs[MMU_PAGE_4K].shift = 12;
 		mmu_psize_defs[MMU_PAGE_4K].ap = 0x0;
+		mmu_psize_defs[MMU_PAGE_4K].h_rpt_pgsize =
+			psize_to_rpti_pgsize(MMU_PAGE_4K);
 
 		mmu_psize_defs[MMU_PAGE_64K].shift = 16;
 		mmu_psize_defs[MMU_PAGE_64K].ap = 0x5;
+		mmu_psize_defs[MMU_PAGE_64K].h_rpt_pgsize =
+			psize_to_rpti_pgsize(MMU_PAGE_64K);
 	}
 
 	/*
-- 
2.26.2

