Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C266363434
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Jul 2019 12:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbfGIK0F (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Jul 2019 06:26:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42336 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726018AbfGIK0E (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 9 Jul 2019 06:26:04 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x69ANCCi131779
        for <kvm-ppc@vger.kernel.org>; Tue, 9 Jul 2019 06:26:03 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tmptgnqtt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Tue, 09 Jul 2019 06:26:02 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Tue, 9 Jul 2019 11:25:59 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 9 Jul 2019 11:25:57 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x69APtHU49479782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Jul 2019 10:25:55 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EC45AE045;
        Tue,  9 Jul 2019 10:25:55 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98CD1AE051;
        Tue,  9 Jul 2019 10:25:53 +0000 (GMT)
Received: from bharata.ibmuc.com (unknown [9.85.81.51])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Jul 2019 10:25:53 +0000 (GMT)
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com, Bharata B Rao <bharata@linux.ibm.com>
Subject: [PATCH v5 0/7] kvmppc: HMM driver to manage pages of secure guest
Date:   Tue,  9 Jul 2019 15:55:38 +0530
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19070910-4275-0000-0000-0000034A7EDF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070910-4276-0000-0000-0000385AA8D4
Message-Id: <20190709102545.9187-1-bharata@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907090127
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

These patches apply and work on top of the base Ultravisor v4 patches
posted by Claudio Carvalho at:
https://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg152842.html

Changes in v5
=============
- Hold kvm->srcu lock until we are done migrating the page.
- Ensure we take heavier lock mmap_sem first before taking kvm->srcu
  lock.
- Code reorgs, comments updates and commit messages updates.
- Ensure we don't lookup HV side partition scoped page tables from
  memslot flush code, this is required for memory unplug to make
  progress.
- Fix reboot of secure SMP guests by unpinng the VPA pages during
  reboot (Ram Pai).
- Added documentation for the new KVM_PP_SVM_OFF ioctl.
- Using different bit slot to differentiate HMM PFN from other uses
  of rmap entries.
- Remove kvmppc_hmm_release_pfns() as releasing of HMM PFNs will be
  done by unmap_vmas() and its callers during VM shutdown.
- Carrying the patch that adds CONFIG_PPC_UV with this patchset.

v4: https://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg151156.html

Anshuman Khandual (1):
  KVM: PPC: Ultravisor: Add PPC_UV config option

Bharata B Rao (6):
  kvmppc: HMM backend driver to manage pages of secure guest
  kvmppc: Shared pages support for secure guests
  kvmppc: H_SVM_INIT_START and H_SVM_INIT_DONE hcalls
  kvmppc: Handle memory plug/unplug to secure VM
  kvmppc: Radix changes for secure guest
  kvmppc: Support reset of secure guest

 Documentation/virtual/kvm/api.txt         |  19 +
 arch/powerpc/Kconfig                      |  20 +
 arch/powerpc/include/asm/hvcall.h         |   9 +
 arch/powerpc/include/asm/kvm_book3s_hmm.h |  48 ++
 arch/powerpc/include/asm/kvm_host.h       |  28 +
 arch/powerpc/include/asm/kvm_ppc.h        |   2 +
 arch/powerpc/include/asm/ultravisor-api.h |   6 +
 arch/powerpc/include/asm/ultravisor.h     |  47 ++
 arch/powerpc/kvm/Makefile                 |   3 +
 arch/powerpc/kvm/book3s_64_mmu_radix.c    |  22 +
 arch/powerpc/kvm/book3s_hv.c              | 115 ++++
 arch/powerpc/kvm/book3s_hv_hmm.c          | 656 ++++++++++++++++++++++
 arch/powerpc/kvm/powerpc.c                |  12 +
 include/uapi/linux/kvm.h                  |   1 +
 tools/include/uapi/linux/kvm.h            |   1 +
 15 files changed, 989 insertions(+)
 create mode 100644 arch/powerpc/include/asm/kvm_book3s_hmm.h
 create mode 100644 arch/powerpc/kvm/book3s_hv_hmm.c

-- 
2.21.0

