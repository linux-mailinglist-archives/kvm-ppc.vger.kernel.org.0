Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D61849A4F4
	for <lists+kvm-ppc@lfdr.de>; Tue, 25 Jan 2022 03:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358380AbiAYAXr (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 24 Jan 2022 19:23:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8260 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1838402AbiAXWqc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 24 Jan 2022 17:46:32 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20OLmm0c013752;
        Mon, 24 Jan 2022 22:08:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dP4z4YU7L62darS+kabz/nlYvJcXkoro8oc/W5CdQho=;
 b=aeyYRMZa3Cjkm7FcZzIunSvGeGhBXZbRoimYudXAVY4PWYZg3mhpTusnJWRuwH5NS1LT
 BPhA/DSw+nWYDRwPNw01P4RsOyuHxfuIqqM46koWpOsnZRBBscYNS8gTc1xYI6z57b1a
 gxamxfKBmpnLD2ikOwU5dFSGCYBpRlgSdCGk2g/YrwKWJvqJ+ehgUUg09wy2A+U0AWfg
 1Z9LXhNZMBswiMCwEhZlyjP3OiX6ADiYXP3ukf2Wjx5Qvn1OAVfLz0TfNb+dlfo/G+0m
 S5zq+TIBt3RdDa39ayUCnvsinrYFJOHFafqr2LFEVQIpOiaLHxpgHvY9zJFwpsNDhgHx TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dt1m5uy1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 22:08:22 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20OLxfGI015787;
        Mon, 24 Jan 2022 22:08:21 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dt1m5uy1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 22:08:21 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20OM2v8t002311;
        Mon, 24 Jan 2022 22:08:20 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02dal.us.ibm.com with ESMTP id 3dt1x8uqw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 22:08:20 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20OM8JJM32440646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jan 2022 22:08:19 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB1F278067;
        Mon, 24 Jan 2022 22:08:19 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 042EB7806E;
        Mon, 24 Jan 2022 22:08:18 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.163.24.67])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 24 Jan 2022 22:08:17 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v2 4/4] KVM: PPC: Decrement module refcount if init_vm fails
Date:   Mon, 24 Jan 2022 19:08:03 -0300
Message-Id: <20220124220803.1011673-5-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124220803.1011673-1-farosas@linux.ibm.com>
References: <20220124220803.1011673-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nohRpn2q5ZHOVLEtjAAX4HDkT7ejghjw
X-Proofpoint-GUID: gFsl5y_F-GZxc6JjT2a-udEA47FyJSNw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-24_09,2022-01-24_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 malwarescore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201240143
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

We increment the reference count for KVM-HV/PR before the call to
kvmppc_core_init_vm. If that function fails we need to decrement the
refcount.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
Caught this while testing Nick's LPID patches by looking at
/sys/module/kvm_hv/refcnt
---
 arch/powerpc/kvm/powerpc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 2ad0ccd202d5..4285d0eac900 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -431,6 +431,8 @@ int kvm_arch_check_processor_compat(void *opaque)
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	struct kvmppc_ops *kvm_ops = NULL;
+	int r;
+
 	/*
 	 * if we have both HV and PR enabled, default is HV
 	 */
@@ -456,7 +458,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		return -ENOENT;
 
 	kvm->arch.kvm_ops = kvm_ops;
-	return kvmppc_core_init_vm(kvm);
+	r = kvmppc_core_init_vm(kvm);
+	if (r)
+		module_put(kvm->arch.kvm_ops->owner);
+	return r;
 err_out:
 	return -EINVAL;
 }
-- 
2.34.1

