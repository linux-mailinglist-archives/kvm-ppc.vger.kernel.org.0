Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E44596573
	for <lists+kvm-ppc@lfdr.de>; Wed, 17 Aug 2022 00:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237983AbiHPWZk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 16 Aug 2022 18:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238036AbiHPWZd (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 16 Aug 2022 18:25:33 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED6F8FD7E
        for <kvm-ppc@vger.kernel.org>; Tue, 16 Aug 2022 15:25:31 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GMLY9r009541;
        Tue, 16 Aug 2022 22:25:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=nxNtjvPEZphHAz0DmUAfW3aXtPU4aSS/vH72JfF0q+Y=;
 b=hlccLVEACCjjSeR9gY7rtz3z5DIvh6rg5YSloi1/yWamOiIxNiEMemCfPyOKovQzdd0Z
 LlRKz7MnCITkNRk7i1diEmD1qbLPYHOhar22RftJWFAafNRfRzuyfzTIjVbycSpnpSd/
 PWPIuYfWgBlnKfwASaw9eG/yvcqr5iOw6kqbgTgi/2yAZ3g4HlfJb62VP1SCf1UI5oWY
 zuVvaVQjgHuFpSgrZGiYHbiFFNFpb9bOCFnUUJvXtKlzGMu/vbD7rR8YkCuE1QHL6fhC
 zzqgNvy+xZHZ9Ok+bGFbaxmTKc9g+eyEJ4jkeMEiwdQEluFgVjLdIQjNNXZ+bkVRGaX5 zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j0ky9r2cv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 22:25:22 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27GMLvFC010189;
        Tue, 16 Aug 2022 22:25:21 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j0ky9r2cm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 22:25:21 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27GML5Wj015678;
        Tue, 16 Aug 2022 22:25:21 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03wdc.us.ibm.com with ESMTP id 3j0byfjdw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 22:25:21 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27GMPKri63176978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Aug 2022 22:25:20 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CE43112063;
        Tue, 16 Aug 2022 22:25:20 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91D75112061;
        Tue, 16 Aug 2022 22:25:19 +0000 (GMT)
Received: from li-4707e44c-227d-11b2-a85c-f336a85283d9.ibm.com.com (unknown [9.160.184.30])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 16 Aug 2022 22:25:19 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com
Subject: [PATCH] KVM: PPC: Book3S HV: Fix decrementer migration
Date:   Tue, 16 Aug 2022 19:25:17 -0300
Message-Id: <20220816222517.1916391-1-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rATaNNSObxVJIk7bOuDizzIk2Me9jy-v
X-Proofpoint-ORIG-GUID: 781lHB4SqGvjlQW4-c2joIPRIMv8q3RR
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 clxscore=1011 impostorscore=0 mlxscore=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208160080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

We used to have a workaround[1] for a hang during migration that was
made ineffective when we converted the decrementer expiry to be
relative to guest timebase.

The point of the workaround was that in the absence of an explicit
decrementer expiry value provided by userspace during migration, KVM
needs to initialize dec_expires to a value that will result in an
expired decrementer after subtracting the current guest timebase. That
stops the vcpu from hanging after migration due to a decrementer
that's too large.

If the dec_expires is now relative to guest timebase, its
initialization needs to be guest timebase-relative as well, otherwise
we end up with a decrementer expiry that is still larger than the
guest timebase.

1- https://git.kernel.org/torvalds/c/5855564c8ab2

Fixes: 3c1a4322bba7 ("KVM: PPC: Book3S HV: Change dec_expires to be relative to guest timebase")
Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv.c | 18 ++++++++++++++++--
 arch/powerpc/kvm/powerpc.c   |  1 -
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 57d0835e56fd..917abda9e5ce 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2517,10 +2517,24 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		r = set_vpa(vcpu, &vcpu->arch.dtl, addr, len);
 		break;
 	case KVM_REG_PPC_TB_OFFSET:
+	{
 		/* round up to multiple of 2^24 */
-		vcpu->arch.vcore->tb_offset =
-			ALIGN(set_reg_val(id, *val), 1UL << 24);
+		u64 tb_offset = ALIGN(set_reg_val(id, *val), 1UL << 24);
+
+		/*
+		 * Now that we know the timebase offset, update the
+		 * decrementer expiry with a guest timebase value. If
+		 * the userspace does not set DEC_EXPIRY, this ensures
+		 * a migrated vcpu at least starts with an expired
+		 * decrementer, which is better than a large one that
+		 * causes a hang.
+		 */
+		if (!vcpu->arch.dec_expires && tb_offset)
+			vcpu->arch.dec_expires = get_tb() + tb_offset;
+
+		vcpu->arch.vcore->tb_offset = tb_offset;
 		break;
+	}
 	case KVM_REG_PPC_LPCR:
 		kvmppc_set_lpcr(vcpu, set_reg_val(id, *val), true);
 		break;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index fb1490761c87..757491dd6b7b 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -786,7 +786,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	hrtimer_init(&vcpu->arch.dec_timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
 	vcpu->arch.dec_timer.function = kvmppc_decrementer_wakeup;
-	vcpu->arch.dec_expires = get_tb();
 
 #ifdef CONFIG_KVM_EXIT_TIMING
 	mutex_init(&vcpu->arch.exit_timing_lock);
-- 
2.35.3

