Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C3C487DEC
	for <lists+kvm-ppc@lfdr.de>; Fri,  7 Jan 2022 22:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiAGVAo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 7 Jan 2022 16:00:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28834 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229670AbiAGVAo (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 7 Jan 2022 16:00:44 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 207JbGGm010994;
        Fri, 7 Jan 2022 21:00:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qtaNqPDSYFydYeEi3LEaETpbgGnOvp19fxiWthbmumQ=;
 b=B3OirdIEQqOjg9LKM8ExWjn302gzUeFBotwMxl5CB86j0XPr5Gn1CI+e46g53/ndTNpp
 u85AHD1JFyOvqcK1E5FfmskUSRe+3035BPaW4XUjMRKUlJSGfaBNzzxpaC5POpvH/IZ1
 cr/mrTJI1V72ySv8CuJmZ9qMiIz7RDAAoRD9hpCx6KekockeH8dwDjNw0nwcNvLs2qAw
 q0Z78sUwkOZDaPgkYneCaua+2BL2kKnVxmjsKMZfWFtN/j2pMlHEub7dlLZiK/yA6VXk
 iJLwZF035m/xdcH0kqvLawlU0TQ1FTmnYgitvsi2vmgrgOy0c2jSDEEpmwKnJss6rFG5 dQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3de4wxsn7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jan 2022 21:00:29 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 207KpeIv023447;
        Fri, 7 Jan 2022 21:00:28 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3de4wxsn78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jan 2022 21:00:28 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 207Kqof0002440;
        Fri, 7 Jan 2022 21:00:27 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma04dal.us.ibm.com with ESMTP id 3de53mn2ap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jan 2022 21:00:27 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 207L0QqK13173064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Jan 2022 21:00:26 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9289178060;
        Fri,  7 Jan 2022 21:00:26 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E212578066;
        Fri,  7 Jan 2022 21:00:24 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.211.59.174])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  7 Jan 2022 21:00:24 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v3 3/6] KVM: PPC: Don't use pr_emerg when mmio emulation fails
Date:   Fri,  7 Jan 2022 18:00:09 -0300
Message-Id: <20220107210012.4091153-4-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107210012.4091153-1-farosas@linux.ibm.com>
References: <20220107210012.4091153-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3cx9h0Ufmy0SCwhLb50NQpmx1Qs7r5Lj
X-Proofpoint-GUID: 34b3D2kWqwWwLp7TDkjEkbgjq8N3XfM_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-07_08,2022-01-07_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 spamscore=0 mlxlogscore=883 adultscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201070123
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

If MMIO emulation fails we deliver a Program interrupt to the
guest. This is a normal event for the host, so use pr_info.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/powerpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 92e552ab5a77..4d7d0d080232 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -308,7 +308,7 @@ int kvmppc_emulate_mmio(struct kvm_vcpu *vcpu)
 
 		kvmppc_get_last_inst(vcpu, INST_GENERIC, &last_inst);
 		/* XXX Deliver Program interrupt to guest. */
-		pr_emerg("%s: emulation failed (%08x)\n", __func__, last_inst);
+		pr_info("%s: emulation failed (%08x)\n", __func__, last_inst);
 		r = RESUME_HOST;
 		break;
 	}
-- 
2.33.1

