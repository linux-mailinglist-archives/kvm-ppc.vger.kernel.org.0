Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD0554B6DA
	for <lists+kvm-ppc@lfdr.de>; Tue, 14 Jun 2022 18:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346279AbiFNQw6 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 14 Jun 2022 12:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351200AbiFNQwe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 14 Jun 2022 12:52:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E746A44A0F
        for <kvm-ppc@vger.kernel.org>; Tue, 14 Jun 2022 09:52:17 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25EGa9rw013125;
        Tue, 14 Jun 2022 16:52:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=0eAsSNUYSiefScn/pnbMFbEAuCEU7PTyAzwa9GMdCOo=;
 b=UuV9SterCJ7+62hGRyExUpFXHu7KvwKQz3cG779P5T9js0xqpkcQ89GT+QrUtNeie16g
 jeW3w9ab/wE531kgmgytYELj7OjWZQDE8VSqMc91mmBcOfbQNAGY/KYGwr9Oh2VVEzOr
 3al442xNy/eUMA07no5id8zeKYhwyLCK8jNVVeGUj5EYK7D2UCcSS7y+twkePwb1aWFb
 2ozZF7PjxEkJh57sQnLiRveZ6tYOw7KFVSTAwtPxkDDEPB+WZ0EWTHDOac7ld+spjR72
 kw3eo6HJMPzVArgYvMKLv19OaWv3Ccyvqb+xVYpxbOMvEPho/4wS05AFwCHzv4Cy4nVs KQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gppa67qxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 16:52:09 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25EGZ20j021916;
        Tue, 14 Jun 2022 16:52:08 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01dal.us.ibm.com with ESMTP id 3gmjp9txy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 16:52:08 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25EGq7l017367462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 16:52:07 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92D3FBE061;
        Tue, 14 Jun 2022 16:52:07 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70A4CBE05D;
        Tue, 14 Jun 2022 16:52:06 +0000 (GMT)
Received: from li-4707e44c-227d-11b2-a85c-f336a85283d9.ibm.com.com (unknown [9.160.61.78])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jun 2022 16:52:06 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mpe@ellerman.id.au
Subject: [PATCH] KVM: PPC: Book3S HV: tracing: Add missing hcall names
Date:   Tue, 14 Jun 2022 13:52:04 -0300
Message-Id: <20220614165204.549229-1-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ncJ5-otZoWPNn5W8c4qjwcYYVRWeEa32
X-Proofpoint-ORIG-GUID: ncJ5-otZoWPNn5W8c4qjwcYYVRWeEa32
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-14_06,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1011
 suspectscore=0 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206140063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The kvm_trace_symbol_hcall macro is missing several of the hypercalls
defined in hvcall.h.

Add the most common ones that are issued during guest lifetime,
including the ones that are only used by QEMU and SLOF.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/include/asm/hvcall.h |  8 ++++++++
 arch/powerpc/kvm/trace_hv.h       | 21 ++++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
index d92a20a85395..1d454c70e7c6 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -350,6 +350,14 @@
 /* Platform specific hcalls, used by KVM */
 #define H_RTAS			0xf000
 
+/*
+ * Platform specific hcalls, used by QEMU/SLOF. These are ignored by
+ * KVM and only kept here so we can identify them during tracing.
+ */
+#define H_LOGICAL_MEMOP  0xF001
+#define H_CAS            0XF002
+#define H_UPDATE_DT      0XF003
+
 /* "Platform specific hcalls", provided by PHYP */
 #define H_GET_24X7_CATALOG_PAGE	0xF078
 #define H_GET_24X7_DATA		0xF07C
diff --git a/arch/powerpc/kvm/trace_hv.h b/arch/powerpc/kvm/trace_hv.h
index 32e2cb5811cc..8d57c8428531 100644
--- a/arch/powerpc/kvm/trace_hv.h
+++ b/arch/powerpc/kvm/trace_hv.h
@@ -94,6 +94,7 @@
 	{H_GET_HCA_INFO,		"H_GET_HCA_INFO"}, \
 	{H_GET_PERF_COUNT,		"H_GET_PERF_COUNT"}, \
 	{H_MANAGE_TRACE,		"H_MANAGE_TRACE"}, \
+	{H_GET_CPU_CHARACTERISTICS,	"H_GET_CPU_CHARACTERISTICS"}, \
 	{H_FREE_LOGICAL_LAN_BUFFER,	"H_FREE_LOGICAL_LAN_BUFFER"}, \
 	{H_QUERY_INT_STATE,		"H_QUERY_INT_STATE"}, \
 	{H_POLL_PENDING,		"H_POLL_PENDING"}, \
@@ -125,7 +126,25 @@
 	{H_COP,				"H_COP"}, \
 	{H_GET_MPP_X,			"H_GET_MPP_X"}, \
 	{H_SET_MODE,			"H_SET_MODE"}, \
-	{H_RTAS,			"H_RTAS"}
+	{H_REGISTER_PROC_TBL,		"H_REGISTER_PROC_TBL"}, \
+	{H_QUERY_VAS_CAPABILITIES,	"H_QUERY_VAS_CAPABILITIES"}, \
+	{H_INT_GET_SOURCE_INFO,		"H_INT_GET_SOURCE_INFO"}, \
+	{H_INT_SET_SOURCE_CONFIG,	"H_INT_SET_SOURCE_CONFIG"}, \
+	{H_INT_GET_QUEUE_INFO,		"H_INT_GET_QUEUE_INFO"}, \
+	{H_INT_SET_QUEUE_CONFIG,	"H_INT_SET_QUEUE_CONFIG"}, \
+	{H_INT_ESB,			"H_INT_ESB"}, \
+	{H_INT_RESET,			"H_INT_RESET"}, \
+	{H_RPT_INVALIDATE,		"H_RPT_INVALIDATE"}, \
+	{H_RTAS,			"H_RTAS"}, \
+	{H_LOGICAL_MEMOP,		"H_LOGICAL_MEMOP"}, \
+	{H_CAS,				"H_CAS"}, \
+	{H_UPDATE_DT,			"H_UPDATE_DT"}, \
+	{H_GET_PERF_COUNTER_INFO,	"H_GET_PERF_COUNTER_INFO"}, \
+	{H_SET_PARTITION_TABLE,		"H_SET_PARTITION_TABLE"}, \
+	{H_ENTER_NESTED,		"H_ENTER_NESTED"}, \
+	{H_TLB_INVALIDATE,		"H_TLB_INVALIDATE"}, \
+	{H_COPY_TOFROM_GUEST,		"H_COPY_TOFROM_GUEST"}
+
 
 #define kvm_trace_symbol_kvmret \
 	{RESUME_GUEST,			"RESUME_GUEST"}, \
-- 
2.35.3

