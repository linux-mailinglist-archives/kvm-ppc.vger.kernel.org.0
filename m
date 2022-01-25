Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F1D49BE0C
	for <lists+kvm-ppc@lfdr.de>; Tue, 25 Jan 2022 22:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbiAYV5R (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 25 Jan 2022 16:57:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45772 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232925AbiAYV5Q (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 25 Jan 2022 16:57:16 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PJkO8n015006;
        Tue, 25 Jan 2022 21:57:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=0mrf7Qomld2WUjTZeBMh2VC+njJpP1+no3VInVyTuKk=;
 b=AZfRyI0Zz/QxJE1EvOAUkw2Wmx77lTmZWr3o1t1X5rqiN6DO1jCmZYyMVYBKPvCjMhn1
 Vzv3QtMwu6lfeVUS+UrghF8oxK05VQCI1P9UD62cGBnrTYmrt2j5D99nOEb2dZBKI2Lz
 FEthWNu3OO9EMwXBQTS6ydvYYqXi55qHkrIyaSFlbhe6CRb39N2gF4Qp/5yAtxrrugpv
 J7KdNVQzANr4COkfw332FhH2oJZRyveZWI9+kcFDtKWjycZawaHhqBfj5JxUWmS+SjCB
 IG2ypeZUSBOtjj035jfgXnWK9xHBjKR27pgO+/6BfQulbWb95Rnm3gYNGkZ0Mfrh1J0h Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtqnjt33n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 21:57:04 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20PLV5uZ028290;
        Tue, 25 Jan 2022 21:57:04 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtqnjt33g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 21:57:04 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20PLroSk028544;
        Tue, 25 Jan 2022 21:57:03 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 3dr9ja6cee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 21:57:03 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20PLv2xQ18743602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 21:57:02 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C768C605D;
        Tue, 25 Jan 2022 21:57:02 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39A19C6057;
        Tue, 25 Jan 2022 21:57:01 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.163.21.20])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jan 2022 21:57:00 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v5 0/5] KVM: PPC: MMIO fixes
Date:   Tue, 25 Jan 2022 18:56:50 -0300
Message-Id: <20220125215655.1026224-1-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bT3wk8G56S32zlJZ2DPkY9hRRt07eqT8
X-Proofpoint-GUID: kP2AqJEw6Hai4ndAo4YLZaNor1J8hHZn
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_05,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=635 bulkscore=0 phishscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201250128
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Changes from v4:

-patch 4: switched to kvm_debug_ratelimited.

-patch 5: kept the Program interrupt for BookE.

v4:
https://lore.kernel.org/r/20220121222626.972495-1-farosas@linux.ibm.com

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
  KVM: PPC: Book3s: mmio: Deliver DSI after emulation failure

 arch/powerpc/kvm/emulate_loadstore.c | 10 ++---
 arch/powerpc/kvm/powerpc.c           | 56 ++++++++++++++++++++--------
 2 files changed, 43 insertions(+), 23 deletions(-)

-- 
2.34.1

