Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F15E1B0B2C
	for <lists+kvm-ppc@lfdr.de>; Mon, 20 Apr 2020 14:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbgDTMyK (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 20 Apr 2020 08:54:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50050 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728393AbgDTMq3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 20 Apr 2020 08:46:29 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03KCXVRr039298;
        Mon, 20 Apr 2020 08:46:07 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30ggxnsgyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 08:46:07 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03KCbDWn050664;
        Mon, 20 Apr 2020 08:46:07 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30ggxnsgy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 08:46:07 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03KCjMgn017579;
        Mon, 20 Apr 2020 12:46:06 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04dal.us.ibm.com with ESMTP id 30fs664pw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 12:46:06 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03KCk4l726018208
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 12:46:04 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 522F0136051;
        Mon, 20 Apr 2020 12:46:04 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BA8D136055;
        Mon, 20 Apr 2020 12:46:00 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.199.51.43])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 20 Apr 2020 12:46:00 +0000 (GMT)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc:     npiggin@gmail.com, paulus@ozlabs.org, leonardo@linux.ibm.com,
        kirill@shutemov.name,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v3 17/22] powerpc/kvm/book3s: use find_kvm_host_pte in kvmppc_book3s_instantiate_page
Date:   Mon, 20 Apr 2020 18:14:29 +0530
Message-Id: <20200420124434.47330-18-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420124434.47330-1-aneesh.kumar@linux.ibm.com>
References: <20200420124434.47330-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-20_04:2020-04-20,2020-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=715 bulkscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200110
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 7b18b298f513..8ce3191cc801 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -813,20 +813,20 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 	 * Read the PTE from the process' radix tree and use that
 	 * so we get the shift and attribute bits.
 	 */
-	local_irq_disable();
-	ptep = __find_linux_pte(vcpu->arch.pgdir, hva, NULL, &shift);
+	spin_lock(&kvm->mmu_lock);
+	ptep = find_kvm_host_pte(kvm, mmu_seq, hva, &shift);
 	/*
 	 * If the PTE disappeared temporarily due to a THP
 	 * collapse, just return and let the guest try again.
 	 */
 	if (!ptep) {
-		local_irq_enable();
+		spin_unlock(&kvm->mmu_lock);
 		if (page)
 			put_page(page);
 		return RESUME_GUEST;
 	}
-	pte = *ptep;
-	local_irq_enable();
+	pte = READ_ONCE(*ptep);
+	spin_unlock(&kvm->mmu_lock);
 
 	/* If we're logging dirty pages, always map single pages */
 	large_enable = !(memslot->flags & KVM_MEM_LOG_DIRTY_PAGES);
-- 
2.25.3

