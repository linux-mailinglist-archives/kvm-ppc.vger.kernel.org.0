Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52F6318CB95
	for <lists+kvm-ppc@lfdr.de>; Fri, 20 Mar 2020 11:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgCTK0w (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 20 Mar 2020 06:26:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38656 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726602AbgCTK0w (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 20 Mar 2020 06:26:52 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02KA8pnD011064
        for <kvm-ppc@vger.kernel.org>; Fri, 20 Mar 2020 06:26:51 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yvq65y3pp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Fri, 20 Mar 2020 06:26:51 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <ldufour@linux.ibm.com>;
        Fri, 20 Mar 2020 10:26:48 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 20 Mar 2020 10:26:46 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02KAQj7p49348614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Mar 2020 10:26:45 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C229EA4054;
        Fri, 20 Mar 2020 10:26:45 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86143A405B;
        Fri, 20 Mar 2020 10:26:45 +0000 (GMT)
Received: from pomme.tlslab.ibm.com (unknown [9.145.123.35])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 Mar 2020 10:26:45 +0000 (GMT)
From:   Laurent Dufour <ldufour@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: [PATCH 0/2] Fix SVM hang at startup
Date:   Fri, 20 Mar 2020 11:26:41 +0100
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20032010-0016-0000-0000-000002F46A86
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032010-0017-0000-0000-00003357F8CD
Message-Id: <20200320102643.15516-1-ldufour@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-20_02:2020-03-20,2020-03-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=839 impostorscore=0 spamscore=0
 phishscore=0 clxscore=1011 malwarescore=0 suspectscore=2 bulkscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003200044
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This series is fixing a SVM hang occurring when starting a SVM requiring
more secure memory than available. The hang happens in the SVM when calling
UV_ESM.

The following is happening:

1. SVM calls UV_ESM
2. Ultravisor (UV) calls H_SVM_INIT_START
3. Hypervisor (HV) calls UV_REGISTER_MEM_SLOT
4. UV returns error because there is not enough free secure memory
5. HV enter the error path in kvmppc_h_svm_init_start()
6. In the return path, since kvm->arch.secure_guest is not yet set hrfid is
   called
7. As the HV doesn't know the SVM calling context hrfid is jumping to
   unknown address in the SVM leading to various expections.

This series fixes the setting of kvm->arch.secure_guest in
kvmppc_h_svm_init_start() to ensure that UV_RETURN is called on the return
path to get back to the UV.

In addition to ensure that a malicious VM will not call UV reserved Hcall,
a check of the Secure bit in the calling MSR is addded to reject such a
call.

It is assumed that the UV will filtered out such Hcalls made by a malicious
SVM.

Laurent Dufour (2):
  KVM: PPC: Book3S HV: check caller of H_SVM_* Hcalls
  KVM: PPC: Book3S HV: H_SVM_INIT_START must call UV_RETURN

 arch/powerpc/kvm/book3s_hv.c       | 32 ++++++++++++++++++++----------
 arch/powerpc/kvm/book3s_hv_uvmem.c |  3 ++-
 2 files changed, 23 insertions(+), 12 deletions(-)

-- 
2.25.2

