Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618BF3CFB01
	for <lists+kvm-ppc@lfdr.de>; Tue, 20 Jul 2021 15:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237279AbhGTNFC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm-ppc@lfdr.de>); Tue, 20 Jul 2021 09:05:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31210 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238734AbhGTNCp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 20 Jul 2021 09:02:45 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16KDdFag090871;
        Tue, 20 Jul 2021 09:42:27 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39wv47nyrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 09:42:27 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16KDRZEj005377;
        Tue, 20 Jul 2021 13:42:25 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 39upu88s94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 13:42:24 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16KDgM1418022838
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jul 2021 13:42:22 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B520AE045;
        Tue, 20 Jul 2021 13:42:22 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E88DAE057;
        Tue, 20 Jul 2021 13:42:22 +0000 (GMT)
Received: from smtp.tlslab.ibm.com (unknown [9.101.4.1])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue, 20 Jul 2021 13:42:22 +0000 (GMT)
Received: from yukon.ibmuc.com (unknown [9.171.24.171])
        by smtp.tlslab.ibm.com (Postfix) with ESMTP id 445AD220144;
        Tue, 20 Jul 2021 15:42:21 +0200 (CEST)
From:   =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [PATCH 0/2] KVM: PPC: Book3S HV: XIVE: Improve guest entries and exits 
Date:   Tue, 20 Jul 2021 15:42:07 +0200
Message-Id: <20210720134209.256133-1-clg@kaod.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fD1lCTBMRVYVVCfZy5NcnQsy3DsL6sfi
X-Proofpoint-GUID: fD1lCTBMRVYVVCfZy5NcnQsy3DsL6sfi
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-20_07:2021-07-19,2021-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=9 malwarescore=0 spamscore=9
 adultscore=0 impostorscore=0 mlxscore=9 suspectscore=0 mlxlogscore=100
 bulkscore=0 lowpriorityscore=0 clxscore=1034 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107200087
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The XIVE interrupt controller on P10 can automatically save and
restore the state of the interrupt registers under the internal NVP
structure representing the VCPU. This saves a costly store/load in
guest entries and exits.

Thanks,

C. 


Cédric Le Goater (2):
  KVM: PPC: Book3S HV: XIVE: Add a 'flags' field
  KVM: PPC: Book3S HV: XIVE: Add support for automatic save-restore

 arch/powerpc/include/asm/xive-regs.h  |  3 ++
 arch/powerpc/include/asm/xive.h       |  1 +
 arch/powerpc/kvm/book3s_xive.h        | 11 +++++-
 arch/powerpc/kvm/book3s_xive.c        | 53 +++++++++++++++++++++------
 arch/powerpc/kvm/book3s_xive_native.c | 21 ++++++++---
 arch/powerpc/sysdev/xive/native.c     | 10 +++++
 6 files changed, 82 insertions(+), 17 deletions(-)

-- 
2.31.1

