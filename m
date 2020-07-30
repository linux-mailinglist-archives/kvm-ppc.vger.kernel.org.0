Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508EC233C14
	for <lists+kvm-ppc@lfdr.de>; Fri, 31 Jul 2020 01:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730332AbgG3XVc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm-ppc@lfdr.de>); Thu, 30 Jul 2020 19:21:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61860 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730291AbgG3XVc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 30 Jul 2020 19:21:32 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06UN3D0C190878;
        Thu, 30 Jul 2020 19:21:16 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32m16t24f0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jul 2020 19:21:15 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06UNBSLS003044;
        Thu, 30 Jul 2020 23:21:11 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 32gcpwc2hd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jul 2020 23:21:11 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06UNL8RE62587292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jul 2020 23:21:08 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BA86A405B;
        Thu, 30 Jul 2020 23:21:08 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11F6AA405F;
        Thu, 30 Jul 2020 23:21:05 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.211.129.132])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 30 Jul 2020 23:21:04 +0000 (GMT)
Date:   Thu, 30 Jul 2020 16:21:01 -0700
From:   Ram Pai <linuxram@us.ibm.com>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     sukadev@linux.ibm.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulus@ozlabs.org, mpe@ellerman.id.au, bharata@linux.ibm.com,
        benh@kernel.crashing.org, ldufour@linux.ibm.com,
        david@gibson.dropbear.id.au, sathnaga@linux.vnet.ibm.com
Subject: [PATCH] KVM: PPC: Book3S HV: Define H_PAGE_IN_NONSHARED for
 H_SVM_PAGE_IN hcall
Message-ID: <20200730232101.GB5882@oc0525413822.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <alpine.DEB.2.22.394.2007301231140.2548@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.DEB.2.22.394.2007301231140.2548@hadrien>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_18:2020-07-30,2020-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxscore=0 bulkscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007300162
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

H_SVM_PAGE_IN hcall takes a flag parameter. This parameter specifies the
way in which a page will be treated.  H_PAGE_IN_NONSHARED indicates
that the page will be shared with the Secure VM, and H_PAGE_IN_SHARED
indicates that the page will not be shared but its contents will
be copied.

However H_PAGE_IN_NONSHARED is not defined in the header file, though
it is defined and documented in the API captured in
Documentation/powerpc/ultravisor.rst

Define H_PAGE_IN_NONSHARED in the header file.

Reported-by: Julia Lawall <julia.lawall@inria.fr>
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 arch/powerpc/include/asm/hvcall.h  | 4 +++-
 arch/powerpc/kvm/book3s_hv_uvmem.c | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
index e90c073..43e3f8d 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -343,7 +343,9 @@
 #define H_COPY_TOFROM_GUEST	0xF80C
 
 /* Flags for H_SVM_PAGE_IN */
-#define H_PAGE_IN_SHARED        0x1
+#define H_PAGE_IN_NONSHARED	0x0  /* Page is not shared with the UV */
+#define H_PAGE_IN_SHARED	0x1  /* Page is shared with UV */
+#define H_PAGE_IN_MASK		0x1
 
 /* Platform-specific hcalls used by the Ultravisor */
 #define H_SVM_PAGE_IN		0xEF00
diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 2dde0fb..2806983 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -947,12 +947,13 @@ unsigned long kvmppc_h_svm_page_in(struct kvm *kvm, unsigned long gpa,
 	if (page_shift != PAGE_SHIFT)
 		return H_P3;
 
-	if (flags & ~H_PAGE_IN_SHARED)
+	if (flags & ~H_PAGE_IN_MASK)
 		return H_P2;
 
 	if (flags & H_PAGE_IN_SHARED)
 		return kvmppc_share_page(kvm, gpa, page_shift);
 
+	/* handle H_PAGE_IN_NONSHARED */
 	ret = H_PARAMETER;
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 	mmap_read_lock(kvm->mm);
-- 
1.8.3.1

-- 
Ram Pai
