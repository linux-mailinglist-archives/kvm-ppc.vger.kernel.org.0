Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6A52BF8B
	for <lists+kvm-ppc@lfdr.de>; Tue, 28 May 2019 08:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfE1Gtv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 28 May 2019 02:49:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46774 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726305AbfE1Gtv (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 28 May 2019 02:49:51 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4S6cg8p078394
        for <kvm-ppc@vger.kernel.org>; Tue, 28 May 2019 02:49:50 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2srxxjtaeg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Tue, 28 May 2019 02:49:49 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Tue, 28 May 2019 07:49:48 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 28 May 2019 07:49:46 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4S6niUS47316996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 May 2019 06:49:44 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7242C11C04A;
        Tue, 28 May 2019 06:49:44 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA5F011C04C;
        Tue, 28 May 2019 06:49:42 +0000 (GMT)
Received: from bharata.in.ibm.com (unknown [9.124.35.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 May 2019 06:49:42 +0000 (GMT)
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com, Bharata B Rao <bharata@linux.ibm.com>
Subject: [PATCH v4 0/6] kvmppc: HMM driver to manage pages of secure guest
Date:   Tue, 28 May 2019 12:19:27 +0530
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19052806-0020-0000-0000-000003411FD2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052806-0021-0000-0000-0000219419A1
Message-Id: <20190528064933.23119-1-bharata@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905280045
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi,

A pseries guest can be run as a secure guest on Ultravisor-enabled
POWER platforms. On such platforms, this driver will be used to manage
the movement of guest pages between the normal memory managed by
hypervisor (HV) and secure memory managed by Ultravisor (UV).

Private ZONE_DEVICE memory equal to the amount of secure memory
available in the platform for running secure guests is created
via a HMM device. The movement of pages between normal and secure
memory is done by ->alloc_and_copy() callback routine of migrate_vma().

The page-in or page-out requests from UV will come to HV as hcalls and
HV will call back into UV via uvcalls to satisfy these page requests.

These patches apply and work on top of the base Ultravisor patches
posted by Claudio Carvalho at:
https://lists.ozlabs.org/pipermail/linuxppc-dev/2019-May/190694.html

In this version, the last two patches are the new additions.

Changes in v4
=============
- Handling HV side page invalidations by issuing UV_PAGE_INVAL ucall
- Handling HV side radix page faults by sending the page to UV
- Support for rebooting a secure guest
- Some cleanups and code reorgs

v3: https://lists.ozlabs.org/pipermail/linuxppc-dev/2019-January/184731.html

Bharata B Rao (6):
  kvmppc: HMM backend driver to manage pages of secure guest
  kvmppc: Shared pages support for secure guests
  kvmppc: H_SVM_INIT_START and H_SVM_INIT_DONE hcalls
  kvmppc: Handle memory plug/unplug to secure VM
  kvmppc: Radix changes for secure guest
  kvmppc: Support reset of secure guest

 arch/powerpc/include/asm/hvcall.h         |   9 +
 arch/powerpc/include/asm/kvm_book3s_hmm.h |  41 ++
 arch/powerpc/include/asm/kvm_host.h       |  37 ++
 arch/powerpc/include/asm/kvm_ppc.h        |   4 +
 arch/powerpc/include/asm/ultravisor-api.h |   6 +
 arch/powerpc/include/asm/ultravisor.h     |  47 ++
 arch/powerpc/kvm/Makefile                 |   3 +
 arch/powerpc/kvm/book3s_64_mmu_radix.c    |  19 +
 arch/powerpc/kvm/book3s_hv.c              |  69 +++
 arch/powerpc/kvm/book3s_hv_hmm.c          | 666 ++++++++++++++++++++++
 arch/powerpc/kvm/powerpc.c                |  12 +
 include/uapi/linux/kvm.h                  |   1 +
 tools/include/uapi/linux/kvm.h            |   1 +
 13 files changed, 915 insertions(+)
 create mode 100644 arch/powerpc/include/asm/kvm_book3s_hmm.h
 create mode 100644 arch/powerpc/kvm/book3s_hv_hmm.c

-- 
2.17.1

