Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AB849B818
	for <lists+kvm-ppc@lfdr.de>; Tue, 25 Jan 2022 16:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1582779AbiAYP7Y (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 25 Jan 2022 10:59:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52590 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1582816AbiAYP5y (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 25 Jan 2022 10:57:54 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PFm5Mq026165;
        Tue, 25 Jan 2022 15:57:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=K5VYV6WqCszK7ENSzIKYTfjFyMqznZDJesWgOB5E/4g=;
 b=MUH7YzrXw0mrZgaZv1sZgfVRPly5dX74MKBg279VD08xduXOyRBWEzmDhRzCn1nkrbnl
 TgEogQLPRrUvfkpCOz1UhEtmfbI27GmJUXq6o25MrZhW936bKOBkDrmWO9JdRkk7Azo1
 AUA06YNzOUAU+eM+U6MB9cOzNh55qcbEqDm7dPje4Ca95UrFCudoVxNPHvRrD0S5XM0e
 FcM475vgdgbYRQQuTaIjMIbBsHh79ZF+/00FnsLfowunR6L4tZbARFwYLfNnvkMvKGDy
 u/ithCgxHIXfu1K0GnavUwYQvLCPwM9wtEIkDP7y0orrQMDx1IqMMvGdYn/roV+VXWZN fQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtm5k87jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 15:57:45 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20PFpfru038613;
        Tue, 25 Jan 2022 15:57:44 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtm5k87j4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 15:57:44 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20PFpldM019322;
        Tue, 25 Jan 2022 15:57:43 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma05wdc.us.ibm.com with ESMTP id 3dtbch1x30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 15:57:43 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20PFvgI436503808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 15:57:42 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CE85C6066;
        Tue, 25 Jan 2022 15:57:42 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F70FC6074;
        Tue, 25 Jan 2022 15:57:40 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.163.21.20])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jan 2022 15:57:40 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v3 0/4] KVM: PPC: KVM module exit fixes
Date:   Tue, 25 Jan 2022 12:57:31 -0300
Message-Id: <20220125155735.1018683-1-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tqtfzLMPD7g0E8i71Do5nBv4wK41LB5S
X-Proofpoint-ORIG-GUID: 32gy_yZEVgEtLucHIl5brR0pNOnbC5rV
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_03,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=910
 malwarescore=0 suspectscore=0 adultscore=0 clxscore=1015 mlxscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201250100
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

changes from v2:

- patch 4: Matched module_put() to try_module_get()

v2:
https://lore.kernel.org/r/20220124220803.1011673-1-farosas@linux.ibm.com

v1:
https://lore.kernel.org/r/20211223211931.3560887-1-farosas@linux.ibm.com

Fabiano Rosas (4):
  KVM: PPC: Book3S HV: Check return value of kvmppc_radix_init
  KVM: PPC: Book3S HV: Delay setting of kvm ops
  KVM: PPC: Book3S HV: Free allocated memory if module init fails
  KVM: PPC: Decrement module refcount if init_vm fails

 arch/powerpc/kvm/book3s_hv.c | 28 ++++++++++++++++++++--------
 arch/powerpc/kvm/powerpc.c   |  9 +++++++--
 2 files changed, 27 insertions(+), 10 deletions(-)

-- 
2.34.1

