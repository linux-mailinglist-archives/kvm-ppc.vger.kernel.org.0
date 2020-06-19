Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9577B201E2B
	for <lists+kvm-ppc@lfdr.de>; Sat, 20 Jun 2020 00:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729532AbgFSWoe (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Jun 2020 18:44:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14688 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726900AbgFSWod (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 Jun 2020 18:44:33 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05JMXQUc086954;
        Fri, 19 Jun 2020 18:44:23 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31rwwu71dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Jun 2020 18:44:23 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05JMYuM9018162;
        Fri, 19 Jun 2020 22:44:21 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 31r1kq19ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Jun 2020 22:44:21 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05JMh0o353412330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jun 2020 22:43:00 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26B6AAE089;
        Fri, 19 Jun 2020 22:44:18 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3F69AE05D;
        Fri, 19 Jun 2020 22:44:14 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.211.71.42])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Jun 2020 22:44:14 +0000 (GMT)
From:   Ram Pai <linuxram@us.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        bharata@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, ldufour@linux.ibm.com,
        bauerman@linux.ibm.com, david@gibson.dropbear.id.au,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sathnaga@linux.vnet.ibm.com
Subject: [PATCH v3 4/4] KVM: PPC: Book3S HV: migrate hot plugged memory
Date:   Fri, 19 Jun 2020 15:43:42 -0700
Message-Id: <1592606622-29884-5-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592606622-29884-1-git-send-email-linuxram@us.ibm.com>
References: <1592606622-29884-1-git-send-email-linuxram@us.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-19_22:2020-06-19,2020-06-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 cotscore=-2147483648
 clxscore=1015 mlxscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 phishscore=0 bulkscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006190157
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Laurent Dufour <ldufour@linux.ibm.com>

When a memory slot is hot plugged to a SVM, PFNs associated with the
GFNs in that slot must be migrated to the secure-PFNs, aka device-PFNs.

kvmppc_uv_migrate_mem_slot() is called to accomplish this. UV_PAGE_IN
ucall is skipped, since the ultravisor does not trust the content of
those pages and hence ignores it.

Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
	[resolved conflicts, and modified the commit log]
---
 arch/powerpc/kvm/book3s_hv.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 6717d24..fcea41c 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4531,10 +4531,12 @@ static void kvmppc_core_commit_memory_region_hv(struct kvm *kvm,
 	case KVM_MR_CREATE:
 		if (kvmppc_uvmem_slot_init(kvm, new))
 			return;
-		uv_register_mem_slot(kvm->arch.lpid,
-				     new->base_gfn << PAGE_SHIFT,
-				     new->npages * PAGE_SIZE,
-				     0, new->id);
+		if (uv_register_mem_slot(kvm->arch.lpid,
+					 new->base_gfn << PAGE_SHIFT,
+					 new->npages * PAGE_SIZE,
+					 0, new->id))
+			return;
+		kvmppc_uv_migrate_mem_slot(kvm, new);
 		break;
 	case KVM_MR_DELETE:
 		uv_unregister_mem_slot(kvm->arch.lpid, old->id);
-- 
1.8.3.1

