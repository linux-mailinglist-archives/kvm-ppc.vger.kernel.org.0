Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4F149B81A
	for <lists+kvm-ppc@lfdr.de>; Tue, 25 Jan 2022 16:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354011AbiAYP7f (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 25 Jan 2022 10:59:35 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17446 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1582821AbiAYP54 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 25 Jan 2022 10:57:56 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PF7EED012519;
        Tue, 25 Jan 2022 15:57:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gCgJ6gJJ9qprIe3Yz88OrLeUA7q370d6LKfJqUBgWLo=;
 b=qdj/pQt2lD/XQZJLCr9S5f3Rt2vKWdfUK9S1j82HzUjL6Db/LcpqHKUA6NQfqzemFVic
 xYQjdSXDASSeidzI5o8gYbBRYNm/xYsjbDdpJ03vxcRn2Lxm82nQPkmxPuSfLzB3ajMS
 DJJpzEbQs2AlPtN64iQoNV8Xnk6SQmTUNqeu2CquZkmmL7MRKVmo6KiiylIV96cc4Rdr
 ebXD39qKJytVAqlUnM9775NbbYFgKI1O5njvdpqB3n4mM8Rc3kK1IAghG6G2YCe0bDdz
 kDVgLWkiMAmMrN+txMn5oygYjdnV/aBLTNZ+D8CVsDJeJOJpuq1VQhBPP/r2F8sPJnhX GQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dtjrtaf07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 15:57:47 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20PFMwC0025250;
        Tue, 25 Jan 2022 15:57:46 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dtjrtaeyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 15:57:46 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20PFplk7019331;
        Tue, 25 Jan 2022 15:57:45 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma05wdc.us.ibm.com with ESMTP id 3dtbch1x4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 15:57:45 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20PFviC728311898
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 15:57:44 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C11AC6082;
        Tue, 25 Jan 2022 15:57:44 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80D54C608B;
        Tue, 25 Jan 2022 15:57:42 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.163.21.20])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jan 2022 15:57:42 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v3 1/4] KVM: PPC: Book3S HV: Check return value of kvmppc_radix_init
Date:   Tue, 25 Jan 2022 12:57:32 -0300
Message-Id: <20220125155735.1018683-2-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125155735.1018683-1-farosas@linux.ibm.com>
References: <20220125155735.1018683-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Zv7qOF0XQJBfmRYWjoz4cFBirM1D4-la
X-Proofpoint-GUID: r4otU4bAACgeKyai8Qlul76TrdTqeM0F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_03,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 mlxscore=0 spamscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 bulkscore=0 clxscore=1015 mlxlogscore=859 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201250100
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The return of the function is being shadowed by the call to
kvmppc_uvmem_init.

Fixes: ca9f4942670c ("KVM: PPC: Book3S HV: Support for running secure guests")
Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index d1817cd9a691..3a3845f366d4 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -6138,8 +6138,11 @@ static int kvmppc_book3s_init_hv(void)
 	if (r)
 		return r;
 
-	if (kvmppc_radix_possible())
+	if (kvmppc_radix_possible()) {
 		r = kvmppc_radix_init();
+		if (r)
+			return r;
+	}
 
 	r = kvmppc_uvmem_init();
 	if (r < 0)
-- 
2.34.1

