Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D05D336DF6
	for <lists+kvm-ppc@lfdr.de>; Thu, 11 Mar 2021 09:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhCKIkJ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 11 Mar 2021 03:40:09 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23752 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231539AbhCKIkF (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 11 Mar 2021 03:40:05 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12B8YbWt003477;
        Thu, 11 Mar 2021 03:39:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=jztkIdHOsOw4DVPaprgcAmTTsLqT3hiEKAAKB5wYfm4=;
 b=ZB01QdhAtxznlzNdfRsBsQdtwMaZIYw6kO6hNQLW35l7X3osu1WqUXxJWfF5W4bN35g0
 DP7jw3zRhjlxB3qlQV4do7lhLsmY0zMATbcUdyNyaEAceOTfCILf7aAchW+njR5kkdIj
 Uo9R138UIt7JcxQlr7bAwYBqJY/mS27z/sM539v4w83NIUDMuGK9hF9zp9pESDIJ6EKX
 RDa9BD1DoTVmp+jbEAyzWUwH2+HOA7I01kQXJ+y5rqeATXlaJOfGUw4M0zCnEPXA+9Cn
 S/dAth9VV30S5fE557Q/6EPhnmVS3ek7/b0lToyvvSTpylDXTmnljM/PWVnMo5Hl9B8b 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3774m7q2eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 03:39:56 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12B8YpwW004165;
        Thu, 11 Mar 2021 03:39:55 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3774m7q2du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 03:39:55 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12B8X0uS027919;
        Thu, 11 Mar 2021 08:39:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3768ursqx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 08:39:54 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12B8dpcD36766080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Mar 2021 08:39:51 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3237E52050;
        Thu, 11 Mar 2021 08:39:51 +0000 (GMT)
Received: from bharata.ibmuc.com (unknown [9.77.205.2])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7E9835204E;
        Thu, 11 Mar 2021 08:39:49 +0000 (GMT)
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     aneesh.kumar@linux.ibm.com, npiggin@gmail.com, paulus@ozlabs.org,
        mpe@ellerman.id.au, david@gibson.dropbear.id.au,
        farosas@linux.ibm.com, Bharata B Rao <bharata@linux.ibm.com>
Subject: [PATCH v6 2/6] powerpc/book3s64/radix: Add H_RPT_INVALIDATE pgsize encodings to mmu_psize_def
Date:   Thu, 11 Mar 2021 14:09:35 +0530
Message-Id: <20210311083939.595568-3-bharata@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210311083939.595568-1-bharata@linux.ibm.com>
References: <20210311083939.595568-1-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-11_02:2021-03-10,2021-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110047
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Add a field to mmu_psize_def to store the page size encodings
of H_RPT_INVALIDATE hcall. Initialize this while scanning the radix
AP encodings. This will be used when invalidating with required
page size encoding in the hcall.

Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
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
index 98f0b243c1ab..1b749899016b 100644
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

