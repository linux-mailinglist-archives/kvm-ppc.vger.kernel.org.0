Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBC747E8FF
	for <lists+kvm-ppc@lfdr.de>; Thu, 23 Dec 2021 22:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350330AbhLWVTq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 23 Dec 2021 16:19:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65074 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233222AbhLWVTo (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 23 Dec 2021 16:19:44 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BNJfcra013473;
        Thu, 23 Dec 2021 21:19:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=n7QC9KPx0EVWIF8oX62NKqQNiUvUZY4sfYuzmvckQrQ=;
 b=aPYwd4ky6Yojrjt8N2O4znvI9cjtGFaD2Ll8CU2MBbCo8V/szThLdwROMhGdLZ09jSfu
 wVy2MH3lqKp8g2ZxJGWI6WbXxHjMmuHQRxpTfbjgPxHgXc724nVRWbNdotYoLm6NKt4i
 MHNwbk0KO+2910OZhAziUcFc1NBQB8QOFns8vUUeOxRfS90juKha57pZF0ztZhnr97Ss
 AGUN02hGOVdFrwLAJBa1YKXR62APrNwZ0D5zgDvmZSZb87Hyc8CutyVu/UkNv353IttS
 bFo2lbBxbD8wsw9hOVdsDxYM9qmh5VCPWHfVCndYo4V6AdiwQyq2LRBLkUZOUz7l5ej6 NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d4yg6hghc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Dec 2021 21:19:36 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BNLD0Ib003696;
        Thu, 23 Dec 2021 21:19:36 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d4yg6hgh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Dec 2021 21:19:36 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BNLILLW019476;
        Thu, 23 Dec 2021 21:19:35 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma05wdc.us.ibm.com with ESMTP id 3d179cg4hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Dec 2021 21:19:35 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BNLJYJ425362874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 21:19:34 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D78ABE05D;
        Thu, 23 Dec 2021 21:19:34 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B793BE05F;
        Thu, 23 Dec 2021 21:19:32 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.163.19.83])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 23 Dec 2021 21:19:32 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com
Subject: [PATCH 0/3] KVM: PPC: KVM module exit fixes
Date:   Thu, 23 Dec 2021 18:19:28 -0300
Message-Id: <20211223211931.3560887-1-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: R_vplOgVhBfGPpJRKV2P-BZS9mez--dG
X-Proofpoint-ORIG-GUID: CbqZrPJlHzIHKVx9cMrmPBQemwet1Dw9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-23_04,2021-12-22_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 malwarescore=0 clxscore=1015 mlxscore=0 spamscore=0 mlxlogscore=786
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112230106
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This is a resend the module cleanup fixes but this time without the
HV/PR merge.

Fabiano Rosas (1):
  KVM: PPC: Book3S HV: Check return value of kvmppc_radix_init
  KVM: PPC: Book3S HV: Delay setting of kvm ops
  KVM: PPC: Book3S HV: Free allocated memory if module init fails

 arch/powerpc/kvm/book3s_hv.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

-- 
2.33.1

