Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAF64EA360
	for <lists+kvm-ppc@lfdr.de>; Tue, 29 Mar 2022 01:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiC1XBv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 28 Mar 2022 19:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiC1XBs (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 28 Mar 2022 19:01:48 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2123A240AB
        for <kvm-ppc@vger.kernel.org>; Mon, 28 Mar 2022 16:00:01 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22SLsOsB027195;
        Mon, 28 Mar 2022 21:58:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=UY86goFnF0Gj4iIqrrsYyWGWYsTERdVG0myVbGGPb4k=;
 b=YVlWymAfSiRIvgYx4XsDlFvBWZAJ4n+4KaKyusghjTR1YTaofYsRTKnbWOEMZ9BvCYfu
 3B5omo/lUV6N4YaPm4YeaSz0omsP10zbYAzNJ1cmP0UW8z0hgq13SmWlyEGa3YtZohjK
 PhUsi9MGGBEQRSsRTuuIEfAespvMmmeJo+coI47wD7rLJOZ3c9b3llIp1Z0PRosE62cQ
 cek+7XgV1Lu6HejyvlBHTEFxrcZWorV0c/iZyfFIh8800n0GBBAZTAabLmnZ2QLZlMU3
 /qpxTkPOTGwKUcBS7ZxZlZRmkL7pyZ0i9U7t0AxeYQHRRmY7WEdfkrwhW/VTiaCGGBpN 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f3nbk81vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 21:58:36 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22SLveDd006019;
        Mon, 28 Mar 2022 21:58:35 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f3nbk81vp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 21:58:35 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22SLhacC022831;
        Mon, 28 Mar 2022 21:58:35 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02wdc.us.ibm.com with ESMTP id 3f1tf983m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 21:58:35 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22SLwYsA7274822
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Mar 2022 21:58:34 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC18FAE066;
        Mon, 28 Mar 2022 21:58:34 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B345AE05C;
        Mon, 28 Mar 2022 21:58:33 +0000 (GMT)
Received: from li-4707e44c-227d-11b2-a85c-f336a85283d9.ibm.com.com (unknown [9.160.110.254])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 28 Mar 2022 21:58:33 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com
Subject: [PATCH] KVM: PPC: Book3S HV: Fix vcore_blocked tracepoint
Date:   Mon, 28 Mar 2022 18:58:31 -0300
Message-Id: <20220328215831.320409-1-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: e3zgWKn2IGwM4h8epjkDe_AHKNgPfF_7
X-Proofpoint-GUID: wN3pgk_2AuplFalMYCnl_2xmgG8W1uHO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-28_10,2022-03-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 mlxlogscore=999 suspectscore=0 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203280116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

We removed most of the vcore logic from the P9 path but there's still
a tracepoint that tried to dereference vc->runner.

Fixes: ecb6a7207f92 ("KVM: PPC: Book3S HV P9: Remove most of the vcore logic")
Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv.c | 8 ++++----
 arch/powerpc/kvm/trace_hv.h  | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index c886557638a1..5f5b2d0dee8c 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4218,13 +4218,13 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 	start_wait = ktime_get();
 
 	vc->vcore_state = VCORE_SLEEPING;
-	trace_kvmppc_vcore_blocked(vc, 0);
+	trace_kvmppc_vcore_blocked(vc->runner, 0);
 	spin_unlock(&vc->lock);
 	schedule();
 	finish_rcuwait(&vc->wait);
 	spin_lock(&vc->lock);
 	vc->vcore_state = VCORE_INACTIVE;
-	trace_kvmppc_vcore_blocked(vc, 1);
+	trace_kvmppc_vcore_blocked(vc->runner, 1);
 	++vc->runner->stat.halt_successful_wait;
 
 	cur = ktime_get();
@@ -4596,9 +4596,9 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 			if (kvmppc_vcpu_check_block(vcpu))
 				break;
 
-			trace_kvmppc_vcore_blocked(vc, 0);
+			trace_kvmppc_vcore_blocked(vcpu, 0);
 			schedule();
-			trace_kvmppc_vcore_blocked(vc, 1);
+			trace_kvmppc_vcore_blocked(vcpu, 1);
 		}
 		finish_rcuwait(wait);
 	}
diff --git a/arch/powerpc/kvm/trace_hv.h b/arch/powerpc/kvm/trace_hv.h
index 38cd0ed0a617..32e2cb5811cc 100644
--- a/arch/powerpc/kvm/trace_hv.h
+++ b/arch/powerpc/kvm/trace_hv.h
@@ -409,9 +409,9 @@ TRACE_EVENT(kvmppc_run_core,
 );
 
 TRACE_EVENT(kvmppc_vcore_blocked,
-	TP_PROTO(struct kvmppc_vcore *vc, int where),
+	TP_PROTO(struct kvm_vcpu *vcpu, int where),
 
-	TP_ARGS(vc, where),
+	TP_ARGS(vcpu, where),
 
 	TP_STRUCT__entry(
 		__field(int,	n_runnable)
@@ -421,8 +421,8 @@ TRACE_EVENT(kvmppc_vcore_blocked,
 	),
 
 	TP_fast_assign(
-		__entry->runner_vcpu = vc->runner->vcpu_id;
-		__entry->n_runnable  = vc->n_runnable;
+		__entry->runner_vcpu = vcpu->vcpu_id;
+		__entry->n_runnable  = vcpu->arch.vcore->n_runnable;
 		__entry->where       = where;
 		__entry->tgid	     = current->tgid;
 	),
-- 
2.35.1

