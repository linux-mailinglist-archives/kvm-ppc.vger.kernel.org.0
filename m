Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5A0499F6E
	for <lists+kvm-ppc@lfdr.de>; Tue, 25 Jan 2022 00:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382075AbiAXW6H (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 24 Jan 2022 17:58:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36716 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1587949AbiAXWaQ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 24 Jan 2022 17:30:16 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20OMBfkJ013216;
        Mon, 24 Jan 2022 22:30:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=JEKskfy7MMeY60uvfbdDvEG2CUPcJC0iPZQsUdTJDn4=;
 b=hPWnMyFfhHMu58Njowu+IT5Cj0AUH5clY1trtKnLkC5gH3RIPFthiDp7DioZeleNzKbP
 y929ydEjxqSS0siz/LsoSDd8Sh0B3DboqhBJdR4Nv6g7BVSeIxRJ8tfZ5/it5LQfyIld
 LKkMyCU1A1uLenyB0dGtZ6EgzLKdCh1hA3vRjsZBc0HUeGFLRiZBq29DMjYUOrKeTgOi
 Jc9yozmM2dOSYpWK44myqQBtuRdKiVKHy3K7hQ1vAYKf8UEt92P4hdGOFLlFYrW74wgE
 3O6OomYEh3Ila0edkPypJ47rpgjRBwiWKy7SknQOTNXA9kAVMZ4Kb3kXcRmxOtMXlN2B xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dt4pfg929-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 22:30:06 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20OMU6BR012526;
        Mon, 24 Jan 2022 22:30:06 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dt4pfg8y5-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 22:30:06 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20OM7SWr016616;
        Mon, 24 Jan 2022 22:08:12 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 3dr9ja9n0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 22:08:12 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20OM8BVp15204840
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jan 2022 22:08:11 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10C757807D;
        Mon, 24 Jan 2022 22:08:11 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A37E78067;
        Mon, 24 Jan 2022 22:08:09 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.163.24.67])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 24 Jan 2022 22:08:08 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com, aik@ozlabs.ru
Subject: [PATCH v2 0/4] KVM: PPC: KVM module exit fixes
Date:   Mon, 24 Jan 2022 19:07:59 -0300
Message-Id: <20220124220803.1011673-1-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nh1JxCTDAdQFaxWnn1YgWMQh03ZY4XOS
X-Proofpoint-ORIG-GUID: sKKTOAlDESd2P1lNyrBeguayvJwGSjwu
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-24_09,2022-01-24_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=861
 malwarescore=0 clxscore=1015 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201240143
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

I stumbled upon another issue with our module exit so I'm sending
another version to add a fix for it.

- patches 1 and 3 are already reviewed;

- patch 2 lacks a Reviewed-by. Nick asked about an issue Alexey might
  have encountered. I haven't heard of any issues with the module exit
  aside from the ones that this series fixes;

- patch 4 is new. It fixes an issue with module refcounting.

v1:
https://lore.kernel.org/r/20211223211931.3560887-1-farosas@linux.ibm.com

Fabiano Rosas (4):
  KVM: PPC: Book3S HV: Check return value of kvmppc_radix_init
  KVM: PPC: Book3S HV: Delay setting of kvm ops
  KVM: PPC: Book3S HV: Free allocated memory if module init fails
  KVM: PPC: Decrement module refcount if init_vm fails

 arch/powerpc/kvm/book3s_hv.c | 28 ++++++++++++++++++++--------
 arch/powerpc/kvm/powerpc.c   |  7 ++++++-
 2 files changed, 26 insertions(+), 9 deletions(-)

-- 
2.34.1

