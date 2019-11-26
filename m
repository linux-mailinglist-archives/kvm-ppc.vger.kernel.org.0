Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEC4310A6A4
	for <lists+kvm-ppc@lfdr.de>; Tue, 26 Nov 2019 23:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfKZWg7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 26 Nov 2019 17:36:59 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42716 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727072AbfKZWg6 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 26 Nov 2019 17:36:58 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAQMXBo0085666;
        Tue, 26 Nov 2019 17:36:48 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2whcxqr335-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Nov 2019 17:36:48 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xAQMYsqk029720;
        Tue, 26 Nov 2019 22:36:47 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02dal.us.ibm.com with ESMTP id 2wevd6q426-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Nov 2019 22:36:47 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAQMal2v50528600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Nov 2019 22:36:47 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26B36AC05B;
        Tue, 26 Nov 2019 22:36:47 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AB73AC05E;
        Tue, 26 Nov 2019 22:36:46 +0000 (GMT)
Received: from LeoBras.aus.stglabs.ibm.com (unknown [9.18.235.137])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 26 Nov 2019 22:36:45 +0000 (GMT)
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Leonardo Bras <leonardo@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] powerpc/kvm/book3e: Replace current->mm by kvm->mm
Date:   Tue, 26 Nov 2019 19:36:31 -0300
Message-Id: <20191126223631.389779-3-leonardo@linux.ibm.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191126223631.389779-1-leonardo@linux.ibm.com>
References: <20191126223631.389779-1-leonardo@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-26_07:2019-11-26,2019-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 spamscore=0 clxscore=1015
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911260191
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Given that in kvm_create_vm() there is:
kvm->mm = current->mm;

And that on every kvm_*_ioctl we have:
if (kvm->mm != current->mm)
	return -EIO;

I see no reason to keep using current->mm instead of kvm->mm.

By doing so, we would reduce the use of 'global' variables on code, relying
more in the contents of kvm struct.

Signed-off-by: Leonardo Bras <leonardo@linux.ibm.com>
---
 arch/powerpc/kvm/booke.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index be9a45874194..fd7bdb4f8f87 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -775,7 +775,7 @@ int kvmppc_vcpu_run(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 	debug = current->thread.debug;
 	current->thread.debug = vcpu->arch.dbg_reg;
 
-	vcpu->arch.pgdir = current->mm->pgd;
+	vcpu->arch.pgdir = vcpu->kvm->mm->pgd;
 	kvmppc_fix_ee_before_entry();
 
 	ret = __kvmppc_vcpu_run(kvm_run, vcpu);
-- 
2.23.0

