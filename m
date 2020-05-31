Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A101E94FA
	for <lists+kvm-ppc@lfdr.de>; Sun, 31 May 2020 04:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbgEaC2h (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 30 May 2020 22:28:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55812 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728867AbgEaC2h (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 30 May 2020 22:28:37 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04V22nGJ035813;
        Sat, 30 May 2020 22:28:26 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31bkmwhaxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 30 May 2020 22:28:25 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04V2Q9ob026119;
        Sun, 31 May 2020 02:28:23 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 31bf47rm5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 May 2020 02:28:23 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04V2SKXo7799220
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 31 May 2020 02:28:20 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 924AEAE051;
        Sun, 31 May 2020 02:28:20 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8887BAE056;
        Sun, 31 May 2020 02:28:17 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.211.70.118])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 31 May 2020 02:28:17 +0000 (GMT)
From:   Ram Pai <linuxram@us.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        bharata@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, ldufour@linux.ibm.com,
        bauerman@linux.ibm.com, david@gibson.dropbear.id.au,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com
Subject: [PATCH v1 0/4] Migrate non-migrated pages of a SVM.
Date:   Sat, 30 May 2020 19:27:47 -0700
Message-Id: <1590892071-25549-1-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-30_21:2020-05-28,2020-05-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 malwarescore=0 cotscore=-2147483648 spamscore=0 priorityscore=1501
 clxscore=1011 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=276
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005310014
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This patch series migrates the non-migrate pages of a SVM.
This is required when the UV calls H_SVM_INIT_DONE, and
when a memory-slot is hotplugged to a Secure VM.

Laurent Dufour (1):
  KVM: PPC: Book3S HV: migrate hot plugged memory

Ram Pai (3):
  KVM: PPC: Book3S HV: Fix function definition in book3s_hv_uvmem.c
  KVM: PPC: Book3S HV: track shared GFNs of secure VMs
  KVM: PPC: Book3S HV: migrate remaining normal-GFNs to secure-GFNs in
    H_SVM_INIT_DONE

 Documentation/powerpc/ultravisor.rst        |   2 +
 arch/powerpc/include/asm/kvm_book3s_uvmem.h |  10 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c      |   2 +-
 arch/powerpc/kvm/book3s_hv.c                |  13 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c          | 348 +++++++++++++++++++++-------
 5 files changed, 284 insertions(+), 91 deletions(-)

-- 
1.8.3.1

