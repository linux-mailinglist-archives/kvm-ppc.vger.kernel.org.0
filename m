Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF0E201E27
	for <lists+kvm-ppc@lfdr.de>; Sat, 20 Jun 2020 00:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729523AbgFSWoT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Jun 2020 18:44:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28374 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726900AbgFSWoT (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 Jun 2020 18:44:19 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05JMVwZc112148;
        Fri, 19 Jun 2020 18:44:07 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31s2p4npdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Jun 2020 18:44:07 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05JMZrBZ008838;
        Fri, 19 Jun 2020 22:44:05 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 31quaxbpy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Jun 2020 22:44:05 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05JMi29T64684474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jun 2020 22:44:02 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74AB6AE087;
        Fri, 19 Jun 2020 22:44:02 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10EE6AE05D;
        Fri, 19 Jun 2020 22:43:59 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.211.71.42])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Jun 2020 22:43:58 +0000 (GMT)
From:   Ram Pai <linuxram@us.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        bharata@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, ldufour@linux.ibm.com,
        bauerman@linux.ibm.com, david@gibson.dropbear.id.au,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sathnaga@linux.vnet.ibm.com
Subject: [PATCH v3 0/4] Migrate non-migrated pages of a SVM.
Date:   Fri, 19 Jun 2020 15:43:38 -0700
Message-Id: <1592606622-29884-1-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-19_22:2020-06-19,2020-06-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 cotscore=-2147483648 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006190155
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The time taken to switch a VM to Secure-VM, increases by the size of the VM.  A
100GB VM takes about 7minutes. This is unacceptable.  This linear increase is
caused by a suboptimal behavior by the Ultravisor and the Hypervisor.  The
Ultravisor unnecessarily migrates all the GFN of the VM from normal-memory to
secure-memory. It has to just migrate the necessary and sufficient GFNs.

However when the optimization is incorporated in the Ultravisor, the Hypervisor
starts misbehaving. The Hypervisor has a inbuilt assumption that the Ultravisor
will explicitly request to migrate, each and every GFN of the VM. If only
necessary and sufficient GFNs are requested for migration, the Hypervisor
continues to manage the remaining GFNs as normal GFNs. This leads of memory
corruption, manifested consistently when the SVM reboots.

The same is true, when a memory slot is hotplugged into a SVM. The Hypervisor
expects the ultravisor to request migration of all GFNs to secure-GFN.  But at
the same time, the hypervisor is unable to handle any H_SVM_PAGE_IN requests
from the Ultravisor, done in the context of UV_REGISTER_MEM_SLOT ucall.  This
problem manifests as random errors in the SVM, when a memory-slot is
hotplugged.

This patch series automatically migrates the non-migrated pages of a SVM,
     and thus solves the problem.

Testing: Passed rigorous SVM test using various sized SVMs.

Changelog:

v2: . fixed a bug observed by Laurent. The state of the GFN's associated
	with Secure-VMs were not reset during memslot flush.
    . Re-organized the code, for easier review.
    . Better description of the patch series.

v1: fixed a bug observed by Bharata. Pages that where paged-in and later
paged-out must also be skipped from migration during H_SVM_INIT_DONE.

Laurent Dufour (1):
  KVM: PPC: Book3S HV: migrate hot plugged memory

Ram Pai (3):
  KVM: PPC: Book3S HV: Fix function definition in book3s_hv_uvmem.c
  KVM: PPC: Book3S HV: track the state GFNs associated with secure VMs
  KVM: PPC: Book3S HV: migrate remaining normal-GFNs to secure-GFNs in
    H_SVM_INIT_DONE

 Documentation/powerpc/ultravisor.rst        |   2 +
 arch/powerpc/include/asm/kvm_book3s_uvmem.h |   2 +
 arch/powerpc/kvm/book3s_hv.c                |  10 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c          | 360 +++++++++++++++++++++++-----
 4 files changed, 315 insertions(+), 59 deletions(-)

-- 
1.8.3.1

