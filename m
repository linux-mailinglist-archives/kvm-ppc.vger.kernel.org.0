Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6553533D3A
	for <lists+kvm-ppc@lfdr.de>; Wed, 25 May 2022 15:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237356AbiEYNIN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 25 May 2022 09:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234333AbiEYNIN (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 25 May 2022 09:08:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97DA9CC98
        for <kvm-ppc@vger.kernel.org>; Wed, 25 May 2022 06:08:12 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24PCuCLs012732;
        Wed, 25 May 2022 13:08:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0L33c6g0GQWV7gW17Cj0IY59ozT/8dn9OTbImbxEqQk=;
 b=pMd52i5Nja9YZCG8hmuwSHzeda6VJ+96z9q1Ht4xhlr7+o2JDSG+g5UGkO75UZpLH2fF
 95ClrQgLNw5OhNVl+JLok9s9w55s8ryr+7KULtdhqwjGLF5Ix11XUcu6J79aPLanbPvB
 3dBYkkmKY6hZAa0+vpaOSzM1elJ2MgQ/9sWWBZ/DLR4FM7fc1eCE+5qsScwalDy8X3Yr
 UDz/qZmsB+Fk1Nz+uZOac3mSBj9ZpH1S7wK0tbP4PKgrbBz6/E9DpOA6Vi7EY3TA0drb
 orlM72JDH2PCheA+40kv7K270W3aJy48dwPT5x2756Tm3XGSCeAjftpZR71bBRhIQ8El BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9fxjxcyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 13:08:08 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24PCUZWB008600;
        Wed, 25 May 2022 13:08:07 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9fxjxcxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 13:08:07 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24PD23P5032216;
        Wed, 25 May 2022 13:08:06 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03dal.us.ibm.com with ESMTP id 3g93utfkvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 13:08:06 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24PD85dZ20185402
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 13:08:05 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7938112061;
        Wed, 25 May 2022 13:08:05 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F9B4112072;
        Wed, 25 May 2022 13:08:04 +0000 (GMT)
Received: from li-4707e44c-227d-11b2-a85c-f336a85283d9.ibm.com.com (unknown [9.160.108.97])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 25 May 2022 13:08:04 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com
Subject: [PATCH 1/5] KVM: PPC: Book3S HV: Fix "rm_exit" entry in debugfs timings
Date:   Wed, 25 May 2022 10:05:50 -0300
Message-Id: <20220525130554.2614394-2-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220525130554.2614394-1-farosas@linux.ibm.com>
References: <20220525130554.2614394-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1RvV0unNp6m10SJB5w5tYEPqgnUOp6qm
X-Proofpoint-GUID: ORZ9zninTQfhA56zgaLqpZ8Sra3UyOxV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_03,2022-05-25_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 adultscore=0 mlxscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205250067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

At debugfs/kvm/<pid>/vcpu0/timings we show how long each part of the
code takes to run:

$ cat /sys/kernel/debug/kvm/*-*/vcpu0/timings
rm_entry: 123785 49398892 118 4898
rm_intr: 123780 6075890 22 390
rm_exit: 0 0 0 0                     <-- NOK
guest: 123780 46732919988 402 9997638
cede: 0 0 0 0                        <-- OK, no cede napping in P9

The "rm_exit" is always showing zero because it is the last one and
end_timing does not increment the counter of the previous entry.

We can fix it by calling accumulate_time again instead of
end_timing. That way the counter gets incremented. The rest of the
arithmetic can be ignored because there are no timing points after
this and the accumulators are reset before the next round.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index a28e5b3daabd..f7591b6c92d1 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -438,15 +438,6 @@ void restore_p9_host_os_sprs(struct kvm_vcpu *vcpu,
 EXPORT_SYMBOL_GPL(restore_p9_host_os_sprs);
 
 #ifdef CONFIG_KVM_BOOK3S_HV_EXIT_TIMING
-static void __start_timing(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator *next)
-{
-	struct kvmppc_vcore *vc = vcpu->arch.vcore;
-	u64 tb = mftb() - vc->tb_offset_applied;
-
-	vcpu->arch.cur_activity = next;
-	vcpu->arch.cur_tb_start = tb;
-}
-
 static void __accumulate_time(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator *next)
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
@@ -478,8 +469,8 @@ static void __accumulate_time(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator
 	curr->seqcount = seq + 2;
 }
 
-#define start_timing(vcpu, next) __start_timing(vcpu, next)
-#define end_timing(vcpu) __start_timing(vcpu, NULL)
+#define start_timing(vcpu, next) __accumulate_time(vcpu, next)
+#define end_timing(vcpu) __accumulate_time(vcpu, NULL)
 #define accumulate_time(vcpu, next) __accumulate_time(vcpu, next)
 #else
 #define start_timing(vcpu, next) do {} while (0)
-- 
2.35.1

