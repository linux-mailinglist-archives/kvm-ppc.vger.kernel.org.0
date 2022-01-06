Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8275486ACC
	for <lists+kvm-ppc@lfdr.de>; Thu,  6 Jan 2022 21:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243535AbiAFUDY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 6 Jan 2022 15:03:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34190 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235093AbiAFUDY (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 6 Jan 2022 15:03:24 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 206I273a017439;
        Thu, 6 Jan 2022 20:03:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=UW1FZZAZKvib7NGd5fTiystFDvCdih0oBRGSC7Wa60Y=;
 b=ROTl+voLUauhM4XbR5KuoLrkunRqKH3HYZF7X7Y063e2Cu/sfthw6Com52Zu0f4j1Zbe
 LmFQjQanM4zPgA8k+YqNyLuz6ADBXkqJUNbVTPoUBvck/15hJJpmXM3iTxxoWqd9zh7Z
 0ci0Y/0Y1xGYdCZDFMnSQBiEz+Q39fzeO2gNKq5qD6AhCGB4zeycNast7PIElrKemsAG
 nSMGafjF1QTp1y3jLq6DDcIYTjoWZ9LTdO0ajht7BploE2j+PQODNHg6bNqjRvadoI9c
 gGVWfVpBpsFcc+nxIilVx+L3GrXZ9TCJrATqa00UqRX8ivB5ZJiMqyW/+W0Id35chSsV WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3de5bq9yc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 20:03:15 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 206JsK7L015339;
        Thu, 6 Jan 2022 20:03:14 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3de5bq9ybq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 20:03:14 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 206JwEda004324;
        Thu, 6 Jan 2022 20:03:13 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma04dal.us.ibm.com with ESMTP id 3de53ktmwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 20:03:13 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 206K3CBK34865598
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jan 2022 20:03:12 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A654BE05A;
        Thu,  6 Jan 2022 20:03:12 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9BCF7BE054;
        Thu,  6 Jan 2022 20:03:10 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.211.150.192])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  6 Jan 2022 20:03:10 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v2 0/7] KVM: PPC: MMIO fixes
Date:   Thu,  6 Jan 2022 17:02:57 -0300
Message-Id: <20220106200304.4070825-1-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.33.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8Qg7x-HxFdyHmqsJTNrksX_5DzjBemKG
X-Proofpoint-ORIG-GUID: ahb4xfURu4oi00pzKtckTVJpOlRenMsc
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-06_08,2022-01-06_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 impostorscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 clxscore=1015 bulkscore=0 adultscore=0 phishscore=0
 mlxlogscore=997 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201060126
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The change from v1 is that I have altered the MMIO size check to fail
the emulation in case the size exceeds 8 bytes. That brought some
cleanups and another fix along with it, we were returning to userspace
in case of failure instead of the guest.

This has now become an MMIO series, but since the first commit has
been reviewed already, I'm leaving it here.

v1:
https://lore.kernel.org/r/20211223211528.3560711-1-farosas@linux.ibm.com

Fabiano Rosas (7):
  KVM: PPC: Book3S HV: Stop returning internal values to userspace
  KVM: PPC: Fix vmx/vsx mixup in mmio emulation
  KVM: PPC: Fix mmio length message
  KVM: PPC: Don't use pr_emerg when mmio emulation fails
  KVM: PPC: mmio: Queue interrupt at kvmppc_emulate_mmio
  KVM: PPC: mmio: Return to guest after emulation failure
  KVM: PPC: mmio: Reject instructions that access more than mmio.data
    size

 arch/powerpc/kvm/emulate_loadstore.c |  4 +---
 arch/powerpc/kvm/powerpc.c           | 24 +++++++++++++++++-------
 2 files changed, 18 insertions(+), 10 deletions(-)

-- 
2.33.1

