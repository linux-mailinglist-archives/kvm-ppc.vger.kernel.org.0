Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D706547E8F1
	for <lists+kvm-ppc@lfdr.de>; Thu, 23 Dec 2021 22:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233835AbhLWVPw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 23 Dec 2021 16:15:52 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61360 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234130AbhLWVPw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 23 Dec 2021 16:15:52 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BNKu61e031484;
        Thu, 23 Dec 2021 21:15:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=IpIC73MytuAgOqJcPQKpx5l+wZPAAosydHwjRx1tXPE=;
 b=K0Fdq/d0J4KFSilgfz+So0t8zvyi1vrNsqtcmBf2b8m1/ONQ0z+uyEeyXBfJPvOgh6bu
 pZHmd9K2kozidZI6ll5XVPDQHlDlkfBjP/He/mZcy56/7UG6Oe+TBnDxAwAWZ3xQF6ZN
 abbzISgEsUD2wOjdT/7lDF/o0prkLtImtKIl9LB6axeLeGd8/9DadIS45RUfwpbX8Vvl
 bhqFuVWFLBAeDellv2GRxtjY4Bdosml1fsHNxSolRFSAKTpVVAQO2LKUbOnkRMMN4hbo
 SJIm/ZHLoVOX5v2jvDPrhVtVcZQs6YD+b6FmgxjjvqS+Mt7B6Of1ewoVAWES2q2Ch/KZ zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d4yg91fr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Dec 2021 21:15:39 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BNL0UvJ016968;
        Thu, 23 Dec 2021 21:15:39 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d4yg91fqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Dec 2021 21:15:39 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BNL7Oxt012716;
        Thu, 23 Dec 2021 21:15:38 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01dal.us.ibm.com with ESMTP id 3d179cy9pq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Dec 2021 21:15:38 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BNLFZ7q8782670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 21:15:35 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9443EAC06D;
        Thu, 23 Dec 2021 21:15:35 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEC12AC075;
        Thu, 23 Dec 2021 21:15:33 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.163.19.83])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 23 Dec 2021 21:15:33 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH 0/3] KVM: PPC: Minor fixes
Date:   Thu, 23 Dec 2021 18:15:25 -0300
Message-Id: <20211223211528.3560711-1-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xHDlItkkEdKUlUyTVLAer96_6nUgzw0F
X-Proofpoint-GUID: o23DAOUxOeAWIDvQags0OzenFMuigl1O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-23_04,2021-12-22_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1011
 suspectscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 impostorscore=0 mlxscore=0 mlxlogscore=674
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112230106
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Two fixes for MMIO emulation code that don't really affect anything.

One fix for ioctl return code that is a prerequisite for the selftests
enablement.

Fabiano Rosas (3):
  KVM: PPC: Book3S HV: Stop returning internal values to userspace
  KVM: PPC: Fix vmx/vsx mixup in mmio emulation
  KVM: PPC: Fix mmio length message

 arch/powerpc/kvm/powerpc.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

-- 
2.33.1

