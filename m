Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F426487DEA
	for <lists+kvm-ppc@lfdr.de>; Fri,  7 Jan 2022 22:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiAGVAm (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 7 Jan 2022 16:00:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40886 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229597AbiAGVAm (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 7 Jan 2022 16:00:42 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 207Jcdx9023301;
        Fri, 7 Jan 2022 21:00:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wD4zBz7ceE3nF6N56fksA4s74A/6n/yNWPqocBinGng=;
 b=W4kSiRll9NhZ2nyxkaKMdmkzbSwcOf1GL3asbIAZtl8/6Tgw4mdkpHmhGKmsKkxCriDD
 MUrrgzzFg/NSQ7+KlOaTvDZio4BEGwUahaJZGhzSZUgm3z8mrLXY5TgxnzZM/Zeak9sm
 fbbGYKu62YwVC0IaDI3p5nft6QyiMXIeCKAK1tIFFZZu9UW3SKzaJlDwilCHIxNWTK0K
 IQ6yTDBVL5tD5uPNhZ33h9B0phiabYebd4g15GN/qqKYD1+Ke+PnBSqyJ2STZIfcsHrG
 vYvtWfBHZinnqLHhbOhkNElbKfAEs/seiNGHCvbQxmO0LSs/9wVm5LFw2WadKEUwfdbt RA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3de4x3hhfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jan 2022 21:00:35 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 207L0Ywd014084;
        Fri, 7 Jan 2022 21:00:34 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3de4x3hhfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jan 2022 21:00:34 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 207KqpO4019907;
        Fri, 7 Jan 2022 21:00:33 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 3de5k9euxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jan 2022 21:00:33 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 207L0WNF22348082
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Jan 2022 21:00:32 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD0F178068;
        Fri,  7 Jan 2022 21:00:32 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1950E7805F;
        Fri,  7 Jan 2022 21:00:31 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.211.59.174])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  7 Jan 2022 21:00:30 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v3 6/6] KVM: PPC: mmio: Reject instructions that access more than mmio.data size
Date:   Fri,  7 Jan 2022 18:00:12 -0300
Message-Id: <20220107210012.4091153-7-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107210012.4091153-1-farosas@linux.ibm.com>
References: <20220107210012.4091153-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TK1-G93RxeT-xG12UwVcHib_sEreEhOl
X-Proofpoint-GUID: dNaOKskcXVxlZpMN9_MgIVA5J1XPOxX8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-07_08,2022-01-07_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 mlxlogscore=912 suspectscore=0
 malwarescore=0 phishscore=0 mlxscore=0 clxscore=1015 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201070123
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The MMIO interface between the kernel and userspace uses a structure
that supports a maximum of 8-bytes of data. Instructions that access
more than that need to be emulated in parts.

We currently don't have generic support for splitting the emulation in
parts and each set of instructions needs to be explicitly included.

There's already an error message being printed when a load or store
exceeds the mmio.data buffer but we don't fail the emulation until
later at kvmppc_complete_mmio_load and even then we allow userspace to
make a partial copy of the data, which ends up overwriting some fields
of the mmio structure.

This patch makes the emulation fail earlier at kvmppc_handle_load|store,
which will send a Program interrupt to the guest. This is better than
allowing the guest to proceed with partial data.

Note that this was caught in a somewhat artificial scenario using
quadword instructions (lq/stq), there's no account of an actual guest
in the wild running instructions that are not properly emulated.

(While here, fix the error message to check against 'bytes' and not
'run->mmio.len' which at this point has an old value.)

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/kvm/powerpc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 56b0faab7a5f..a1643ca988e0 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -1246,7 +1246,8 @@ static int __kvmppc_handle_load(struct kvm_vcpu *vcpu,
 
 	if (bytes > sizeof(run->mmio.data)) {
 		printk(KERN_ERR "%s: bad MMIO length: %d\n", __func__,
-		       run->mmio.len);
+		       bytes);
+		return EMULATE_FAIL;
 	}
 
 	run->mmio.phys_addr = vcpu->arch.paddr_accessed;
@@ -1335,7 +1336,8 @@ int kvmppc_handle_store(struct kvm_vcpu *vcpu,
 
 	if (bytes > sizeof(run->mmio.data)) {
 		printk(KERN_ERR "%s: bad MMIO length: %d\n", __func__,
-		       run->mmio.len);
+		       bytes);
+		return EMULATE_FAIL;
 	}
 
 	run->mmio.phys_addr = vcpu->arch.paddr_accessed;
-- 
2.33.1

