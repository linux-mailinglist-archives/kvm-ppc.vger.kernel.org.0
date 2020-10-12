Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9DA28AF07
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Oct 2020 09:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgJLH20 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 12 Oct 2020 03:28:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15938 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726413AbgJLH2Z (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 12 Oct 2020 03:28:25 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09C73i5t136077;
        Mon, 12 Oct 2020 03:28:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=MV10Bu4IT96mlbyfXjgvHbCX1OVkXR5VOhKmyKvOBtQ=;
 b=DHBhZ54f+yGpNCtPDur9eu9wbSnZryPDp26NbG+vTpmrK3lxfuOf77VBvPrWP/+vpUQM
 jJHOmRDlivWw8lJn725uFBcOcmh8B/HA3fSzY01KzKowB/Mn2Ox/V6e/VvFKKcL932RU
 5gi7qQtRLrsYmifBlvqNt25kIfcuxxJol5+oBv+fp9bQmmu7UoMEKyJBfYwu1/mTCyz4
 xTTjm8Ispb8imkHuI7EinXGgefEdMpeajxsfwW7zgsVBu7zMOmagV4cX4KrQs7WMwZUF
 f0TKXHWbTF3h7AwMnlgY6KINhjeL6da8anKWCiQ+F+FT9X+tsKOaf41Jd1LygSOIjshd dQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 344jcdrmwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Oct 2020 03:28:10 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09C7MYIn017156;
        Mon, 12 Oct 2020 07:28:07 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3434k81s8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Oct 2020 07:28:07 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09C7S4UC25035080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Oct 2020 07:28:04 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C619BA406F;
        Mon, 12 Oct 2020 07:28:04 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33A10A405E;
        Mon, 12 Oct 2020 07:28:03 +0000 (GMT)
Received: from ram-ibm-com.ibm.com (unknown [9.85.204.94])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 12 Oct 2020 07:28:02 +0000 (GMT)
From:   Ram Pai <linuxram@us.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     paulus@ozlabs.org, linuxram@us.ibm.com, bharata@linux.ibm.com,
        farosas@linux.ibm.com
Subject: [RFC v1 0/2] Plumbing to support multiple secure memory backends.
Date:   Mon, 12 Oct 2020 00:27:41 -0700
Message-Id: <1602487663-7321-1-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-12_03:2020-10-12,2020-10-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 spamscore=0 adultscore=0 mlxscore=0 mlxlogscore=812
 bulkscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010120061
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Secure VMs are currently supported by the Ultravisor backend.

Enhance the plumbing to support multiple backends. Each backend shall
provide the implementation for the necessary and sufficient calls
in order to support secure VM.

Also as part of this change, modify the ultravisor implementation to
be a plugin that provides an implementation of the backend.

Ram Pai (2):
  KVM: PPC: Book3S HV: rename all variables in book3s_hv_uvmem.c
  KVM: PPC: Book3S HV: abstract secure VM related calls.

 arch/powerpc/include/asm/kvm_book3s_uvmem.h   | 100 ---------
 arch/powerpc/include/asm/kvmppc_svm_backend.h | 250 ++++++++++++++++++++++
 arch/powerpc/kvm/book3s_64_mmu_radix.c        |   6 +-
 arch/powerpc/kvm/book3s_hv.c                  |  28 +--
 arch/powerpc/kvm/book3s_hv_uvmem.c            | 288 +++++++++++++++-----------
 5 files changed, 432 insertions(+), 240 deletions(-)
 delete mode 100644 arch/powerpc/include/asm/kvm_book3s_uvmem.h
 create mode 100644 arch/powerpc/include/asm/kvmppc_svm_backend.h

-- 
1.8.3.1

