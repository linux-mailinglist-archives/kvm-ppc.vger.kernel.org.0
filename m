Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9BE6533D3E
	for <lists+kvm-ppc@lfdr.de>; Wed, 25 May 2022 15:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbiEYNIU (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 25 May 2022 09:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238663AbiEYNIS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 25 May 2022 09:08:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E0EA0051
        for <kvm-ppc@vger.kernel.org>; Wed, 25 May 2022 06:08:17 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24PADnvO031016;
        Wed, 25 May 2022 13:08:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vv5w6BgrXAZq46Vi3QPC78EeVojY2aj9GVMeO0Lha7E=;
 b=Pmt0mds42cgvgAJX7uumc99b3Fs9UQhKSU5c7um7v9AJTpUu1PhBuzgKiWRBI8WEJYSY
 p3YBV62dpzuVI2HUccLRBH8xI3787/yXRldUUryOYtTeMY1ZDtisx7ITR77rrcIJxb6u
 mN2xhdLhch71YLNAMyASwUFJlCAHZdtkUAFRVTWPX7kcckxakpg95gqs/Lj8vG3M4/ld
 0Mfjz+OxsFmSJ9X/urMBm9eS55TXTDXByl3GPSCUfxttTRZG5kZm+1T7y570r/IxZBzp
 VYOtcPZiMMePpIPUsdAhMW865Ea0v+EFzDzWN8L3Ef1LIl5AN0SMndMcoeL0ABLYThNu hQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9jgxk6ft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 13:08:13 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24PChjSG006457;
        Wed, 25 May 2022 13:08:12 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9jgxk6f9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 13:08:12 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24PD23IA032221;
        Wed, 25 May 2022 13:08:11 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03dal.us.ibm.com with ESMTP id 3g93utfkwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 13:08:11 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24PD8BeK63963394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 13:08:11 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B052112064;
        Wed, 25 May 2022 13:08:11 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94995112061;
        Wed, 25 May 2022 13:08:09 +0000 (GMT)
Received: from li-4707e44c-227d-11b2-a85c-f336a85283d9.ibm.com.com (unknown [9.160.108.97])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 25 May 2022 13:08:09 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com
Subject: [PATCH 4/5] KVM: PPC: Book3S HV: Expose timing functions to module code
Date:   Wed, 25 May 2022 10:05:53 -0300
Message-Id: <20220525130554.2614394-5-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220525130554.2614394-1-farosas@linux.ibm.com>
References: <20220525130554.2614394-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DUvSat0oGC5fiGtf71zxhe8ILLGkl242
X-Proofpoint-ORIG-GUID: jGfmf8kyCqERUOX0_DXe_rcw6RSlC1H6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_03,2022-05-25_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 malwarescore=0 adultscore=0 bulkscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205250067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The next patch adds new timing points to the P9 entry path, some of
which are in the module code, so we need to export the timing
functions.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv.h          | 10 ++++++++++
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 11 ++---------
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.h b/arch/powerpc/kvm/book3s_hv.h
index 6b7f07d9026b..2f2e59d7d433 100644
--- a/arch/powerpc/kvm/book3s_hv.h
+++ b/arch/powerpc/kvm/book3s_hv.h
@@ -40,3 +40,13 @@ void switch_pmu_to_guest(struct kvm_vcpu *vcpu,
 			    struct p9_host_os_sprs *host_os_sprs);
 void switch_pmu_to_host(struct kvm_vcpu *vcpu,
 			    struct p9_host_os_sprs *host_os_sprs);
+
+#ifdef CONFIG_KVM_BOOK3S_HV_P9_TIMING
+void accumulate_time(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator *next);
+#define start_timing(vcpu, next) accumulate_time(vcpu, next)
+#define end_timing(vcpu) accumulate_time(vcpu, NULL)
+#else
+#define accumulate_time(vcpu, next) do {} while (0)
+#define start_timing(vcpu, next) do {} while (0)
+#define end_timing(vcpu) do {} while (0)
+#endif
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index f8ce473149b7..8b2a9a360e4e 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -438,7 +438,7 @@ void restore_p9_host_os_sprs(struct kvm_vcpu *vcpu,
 EXPORT_SYMBOL_GPL(restore_p9_host_os_sprs);
 
 #ifdef CONFIG_KVM_BOOK3S_HV_P9_TIMING
-static void __accumulate_time(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator *next)
+void accumulate_time(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator *next)
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	struct kvmhv_tb_accumulator *curr;
@@ -468,14 +468,7 @@ static void __accumulate_time(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator
 	smp_wmb();
 	curr->seqcount = seq + 2;
 }
-
-#define start_timing(vcpu, next) __accumulate_time(vcpu, next)
-#define end_timing(vcpu) __accumulate_time(vcpu, NULL)
-#define accumulate_time(vcpu, next) __accumulate_time(vcpu, next)
-#else
-#define start_timing(vcpu, next) do {} while (0)
-#define end_timing(vcpu) do {} while (0)
-#define accumulate_time(vcpu, next) do {} while (0)
+EXPORT_SYMBOL_GPL(accumulate_time);
 #endif
 
 static inline u64 mfslbv(unsigned int idx)
-- 
2.35.1

