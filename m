Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA6D3E1DFD
	for <lists+kvm-ppc@lfdr.de>; Thu,  5 Aug 2021 23:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhHEV06 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 5 Aug 2021 17:26:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39563 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229729AbhHEV06 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 5 Aug 2021 17:26:58 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175L444W132940;
        Thu, 5 Aug 2021 17:26:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=JoGy5yoHcJTp5C4m3UqKOyLRWSEw5jL/u+xcwHfgf2Q=;
 b=rVOCOVStIs7r/nfBgC7HSEQvuefTiCvBz8CXhm/EBmryfNfUcJUtOBY/9Wmh6/0l1U3D
 tyQVnEPgQJPxQs9aFKLQLHd+TxCJZ7aMAx2RojMZJxGkAu5Z+YYVdlvJC2NfChhQ8sPa
 aQVQa3ljoHX/UsLjXsr+luzVVhp8S9PXDGw2Rbp827FMmGSqnTQ+2SPwnEMFMSodYi5F
 eedS056PEHQ03W2z6g8pQUhnoo9OZCp9HaKERHBDbilN9K6VTBD2Nw/mgfyoUw7s6jhC
 oKOlkgx2rneVCeg9NoPEIBa/WH93ExeMHcnB4y3As24lF3KH0Hg3TD7CNBtHYk7dB3cv 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a83gq8bea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 17:26:33 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 175L5kHK145705;
        Thu, 5 Aug 2021 17:26:33 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a83gq8bdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 17:26:33 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 175LNP4V005101;
        Thu, 5 Aug 2021 21:26:32 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03wdc.us.ibm.com with ESMTP id 3a77h539js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 21:26:32 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 175LQVYW17629448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Aug 2021 21:26:31 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6A1D112072;
        Thu,  5 Aug 2021 21:26:31 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A0D711207C;
        Thu,  5 Aug 2021 21:26:29 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.163.18.4])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu,  5 Aug 2021 21:26:29 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@c-s.fr
Subject: [PATCH v2 3/3] KVM: PPC: Book3S HV: Stop exporting symbols from book3s_64_mmu_radix
Date:   Thu,  5 Aug 2021 18:26:16 -0300
Message-Id: <20210805212616.2641017-4-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210805212616.2641017-1-farosas@linux.ibm.com>
References: <20210805212616.2641017-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UOHeF9WmSWWGHC-lOiIxwopRIz37pdM9
X-Proofpoint-GUID: 0N-CJxMgXLcKzyc2RzhjEfG-QzOTQdbk
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-05_10:2021-08-05,2021-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 phishscore=0 suspectscore=0 impostorscore=0 spamscore=0 adultscore=0
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108050124
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The book3s_64_mmu_radix.o object is not part of the KVM builtins and
all the callers of the exported symbols are in the same kvm-hv.ko
module so we should not need to export any symbols.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 1b1c9e9e539b..16359525a40f 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -86,7 +86,6 @@ unsigned long __kvmhv_copy_tofrom_guest_radix(int lpid, int pid,
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(__kvmhv_copy_tofrom_guest_radix);
 
 static long kvmhv_copy_tofrom_guest_radix(struct kvm_vcpu *vcpu, gva_t eaddr,
 					  void *to, void *from, unsigned long n)
@@ -122,14 +121,12 @@ long kvmhv_copy_from_guest_radix(struct kvm_vcpu *vcpu, gva_t eaddr, void *to,
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(kvmhv_copy_from_guest_radix);
 
 long kvmhv_copy_to_guest_radix(struct kvm_vcpu *vcpu, gva_t eaddr, void *from,
 			       unsigned long n)
 {
 	return kvmhv_copy_tofrom_guest_radix(vcpu, eaddr, NULL, from, n);
 }
-EXPORT_SYMBOL_GPL(kvmhv_copy_to_guest_radix);
 
 int kvmppc_mmu_walk_radix_tree(struct kvm_vcpu *vcpu, gva_t eaddr,
 			       struct kvmppc_pte *gpte, u64 root,
-- 
2.29.2

