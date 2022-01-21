Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1614967D3
	for <lists+kvm-ppc@lfdr.de>; Fri, 21 Jan 2022 23:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbiAUW0r (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 21 Jan 2022 17:26:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26450 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233179AbiAUW0r (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 21 Jan 2022 17:26:47 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20LL5jqv014002;
        Fri, 21 Jan 2022 22:26:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=8P7wAY09X+BVf2wim9UBW3uBkkcx+9UnV4jleV893ng=;
 b=M67MhyzBp12Upkr9/iMXBvWrM5wpClyrPHXnMkEqAyhFmNsIGw+nz7HRUQI8htGoluT5
 8ZwPcsqH05EKdjOXnippjgqxHrfOA+fmcoql1uwbMhPhKBsg1Na+N9tAv+NvAt6frjOg
 ZQe6+Pcpcho26OQrUjkvL/O8I4lI78kwUvuD4ouY+ExJFoZ/ltyU6WWsERZxgnp6xJM5
 ED04+q6EPm5LNOQGogYPlRQhSQiJfqr3PskXV/ExzS3BxO4eYQwHCMi/IHZPwKEcbsTM
 fZglKyxZMbYJqOmspFqm80JFk9jovP/WXd7ya6bLGZ3PhMxmPQ6O6Tn0L8pu6q0rNqgb Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dr1w3vhhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 22:26:38 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20LMLISp018235;
        Fri, 21 Jan 2022 22:26:37 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dr1w3vhha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 22:26:37 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20LMM8V0012802;
        Fri, 21 Jan 2022 22:26:36 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04wdc.us.ibm.com with ESMTP id 3dqj1fcb1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 22:26:36 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20LMQZrB33816832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 22:26:35 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63D19AE05C;
        Fri, 21 Jan 2022 22:26:35 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BABACAE060;
        Fri, 21 Jan 2022 22:26:32 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.211.81.234])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jan 2022 22:26:32 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v4 0/5] KVM: PPC: MMIO fixes
Date:   Fri, 21 Jan 2022 19:26:21 -0300
Message-Id: <20220121222626.972495-1-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WPDT0p4l-s74_7NS-mFEuW0oyDcmSHo2
X-Proofpoint-ORIG-GUID: qSJB_kzWe_zl36AwxTEmczcyr7tr7Wr-
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_10,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 mlxscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 mlxlogscore=519
 lowpriorityscore=0 bulkscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210140
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Changes from v3:

Removed all of the low level messages and altered the pr_emerg in the
emulate_mmio to a more descriptive message.

Changed the Program interrupt to a Data Storage. There's an ifdef
needed because this code is shared by HV, PR and booke.

v3:
https://lore.kernel.org/r/20220107210012.4091153-1-farosas@linux.ibm.com

v2:
https://lore.kernel.org/r/20220106200304.4070825-1-farosas@linux.ibm.com

v1:
https://lore.kernel.org/r/20211223211528.3560711-1-farosas@linux.ibm.com

Fabiano Rosas (5):
  KVM: PPC: Book3S HV: Stop returning internal values to userspace
  KVM: PPC: Fix vmx/vsx mixup in mmio emulation
  KVM: PPC: mmio: Reject instructions that access more than mmio.data
    size
  KVM: PPC: mmio: Return to guest after emulation failure
  KVM: PPC: mmio: Deliver DSI after emulation failure

 arch/powerpc/kvm/emulate_loadstore.c | 10 ++----
 arch/powerpc/kvm/powerpc.c           | 46 ++++++++++++++++++----------
 2 files changed, 33 insertions(+), 23 deletions(-)

-- 
2.34.1

