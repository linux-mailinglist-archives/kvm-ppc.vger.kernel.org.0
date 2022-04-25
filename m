Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEBF50E2F5
	for <lists+kvm-ppc@lfdr.de>; Mon, 25 Apr 2022 16:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbiDYOZL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 25 Apr 2022 10:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234864AbiDYOZK (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 25 Apr 2022 10:25:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B8222BE7
        for <kvm-ppc@vger.kernel.org>; Mon, 25 Apr 2022 07:22:06 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PCDuoT024096;
        Mon, 25 Apr 2022 14:21:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=5nwqn+1wLNfQ/ritJn59V0hGyz5BJXg8lOeZ9n5/UcQ=;
 b=l8ugCNjuDuynuHA4872VKEooJm4aR7gdJOZJg58lXbbBcuRsnVZ33JfhrqpkS/nczVBm
 3kWphbl28A0oJ6V8nX/yD5Qw0WXtMNpDhiOrlSsyMclN+SH9WFL4fatbmP5aDm4JBnIv
 ui6uEuBii2Pxekjr0WOvdrrtB1d9lv5MSE5MSyQ4eoTC/HjYrLC80sXmh8zQxMoBqIq1
 G3za0bvxBv37SiJ3vemyvWbas2cc+L6ZjAyJWyykax3oT8whLT9tCVUNj0UlpydlsxO2
 pqAxRhn/gYsypeHmIs7FV7xtRS8KLgGnklfUBa0pqHNdYaSFWVaAKIv1VOkRaOLFb7GM lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fmuh63g8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Apr 2022 14:21:57 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23PDfNG7018620;
        Mon, 25 Apr 2022 14:21:57 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fmuh63g88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Apr 2022 14:21:57 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23PEAJ6N026341;
        Mon, 25 Apr 2022 14:21:56 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04dal.us.ibm.com with ESMTP id 3fm939sj81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Apr 2022 14:21:56 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23PELtxJ11666076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Apr 2022 14:21:55 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73D68C6061;
        Mon, 25 Apr 2022 14:21:55 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F24AFC6059;
        Mon, 25 Apr 2022 14:21:53 +0000 (GMT)
Received: from li-4707e44c-227d-11b2-a85c-f336a85283d9.ibm.com.com (unknown [9.77.158.173])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 25 Apr 2022 14:21:53 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com
Subject: [PATCH] KVM: PPC: Book3S HV: Initialize AMOR in nested entry
Date:   Mon, 25 Apr 2022 11:21:51 -0300
Message-Id: <20220425142151.1495142-1-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JfheAjWX2KeLZlZ-RgEV7eM9Fhr2Y4VU
X-Proofpoint-GUID: TYcwAVt3vgOseP1d7rzBzFtkuU-rj3EC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_08,2022-04-25_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 spamscore=0 mlxlogscore=753
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204250062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The hypervisor always sets AMOR to ~0, but let's ensure we're not
passing stale values around.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 6fa518f6501d..b5f504576765 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3967,6 +3967,7 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 
 	kvmhv_save_hv_regs(vcpu, &hvregs);
 	hvregs.lpcr = lpcr;
+	hvregs.amor = ~0;
 	vcpu->arch.regs.msr = vcpu->arch.shregs.msr;
 	hvregs.version = HV_GUEST_STATE_VERSION;
 	if (vcpu->arch.nested) {
-- 
2.35.1

