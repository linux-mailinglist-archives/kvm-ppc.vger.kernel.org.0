Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F8D559B80
	for <lists+kvm-ppc@lfdr.de>; Fri, 24 Jun 2022 16:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbiFXO1f (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 24 Jun 2022 10:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbiFXO10 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 24 Jun 2022 10:27:26 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3C852524
        for <kvm-ppc@vger.kernel.org>; Fri, 24 Jun 2022 07:27:26 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25ODhtS0032116;
        Fri, 24 Jun 2022 14:27:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=3s2werSzBpyD9ixvIprRXla0SDNajBSOl191TnrWcrE=;
 b=Yi8Tg6uX/RkPJj+iRBBdMYppWIWkdA5iziXMQ8EpUa2lioNLRbkDRlVBOdtCDdD4aCmk
 KGoAHPQFy1dY07p13QXeXPUwkbU5sbLufjHWD9JWfSgTKPr0VNV/T2L1JKrt74e4kAoZ
 wsKE/yO24IUsAjz1RY0jW9R3FTVnPBI/rvD2F5HuGSQ5j2J7s/IT0NFJXSyKoiovTNO9
 0CBtwL3YW7aANR/RypYMDukErcnxGc2YnMUrXoA8sKuKkz4XyZDK0sdplbOhL5Mls30L
 wpPClkV98wHpCY0KOE0aOpcdTk3dEk2OBvzppAN7uA7qUBAbZxHHwj+h4uIsCmdhiKwE Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gwedes4d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 14:27:18 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25ODkVQb013540;
        Fri, 24 Jun 2022 14:27:18 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gwedes4cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 14:27:18 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25OEKlj5014734;
        Fri, 24 Jun 2022 14:27:17 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01wdc.us.ibm.com with ESMTP id 3gv5ck73cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 14:27:17 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25OERHn423593404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 14:27:17 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 022CEAC05E;
        Fri, 24 Jun 2022 14:27:17 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BCCDAC059;
        Fri, 24 Jun 2022 14:27:15 +0000 (GMT)
Received: from li-4707e44c-227d-11b2-a85c-f336a85283d9.ibm.com.com (unknown [9.65.252.72])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 24 Jun 2022 14:27:15 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
        muriloo@linux.ibm.com
Subject: [PATCH v2] KVM: PPC: Align pt_regs in kvm_vcpu_arch structure
Date:   Fri, 24 Jun 2022 11:27:12 -0300
Message-Id: <20220624142712.790491-1-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QS_1CdzuygmIBxckVtfve2bveW3ZaZuo
X-Proofpoint-GUID: nckPdKUv9osNJfC6N2M2fjAnFf6NrDXs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-24_07,2022-06-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206240055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The H_ENTER_NESTED hypercall receives as second parameter the address
of a region of memory containing the values for the nested guest
privileged registers. We currently use the pt_regs structure contained
within kvm_vcpu_arch for that end.

Most hypercalls that receive a memory address expect that region to
not cross a 4K page boundary. We would want H_ENTER_NESTED to follow
the same pattern so this patch ensures the pt_regs structure sits
within a page.

Note: the pt_regs structure is currently 384 bytes in size, so
aligning to 512 is sufficient to ensure it will not cross a 4K page
and avoids punching too big a hole in struct kvm_vcpu_arch.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Murilo Opsfelder Araújo <muriloo@linux.ibm.com>
---
v2:
 - updated commit message to inform the rationale for aligning to 512;

 - added Murilo's sign-off which I had forgotten, we worked on this
   together.
---
 arch/powerpc/include/asm/kvm_host.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 2909a88acd16..2c7219cef4ec 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -523,7 +523,11 @@ struct kvm_vcpu_arch {
 	struct kvmppc_book3s_shadow_vcpu *shadow_vcpu;
 #endif
 
-	struct pt_regs regs;
+	/*
+	 * This is passed along to the HV via H_ENTER_NESTED. Align to
+	 * prevent it crossing a real 4K page.
+	 */
+	struct pt_regs regs __aligned(512);
 
 	struct thread_fp_state fp;
 
-- 
2.35.3

