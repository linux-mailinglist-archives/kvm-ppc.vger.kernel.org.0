Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E947990B8
	for <lists+kvm-ppc@lfdr.de>; Thu, 22 Aug 2019 12:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731752AbfHVK0k (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 22 Aug 2019 06:26:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30688 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730918AbfHVK0k (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 22 Aug 2019 06:26:40 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7MAMcRm043912
        for <kvm-ppc@vger.kernel.org>; Thu, 22 Aug 2019 06:26:39 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uhs2q0m1p-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Thu, 22 Aug 2019 06:26:39 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Thu, 22 Aug 2019 11:26:37 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 22 Aug 2019 11:26:35 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7MAQCv340894940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 10:26:12 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85CDBAE045;
        Thu, 22 Aug 2019 10:26:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F07A9AE055;
        Thu, 22 Aug 2019 10:26:30 +0000 (GMT)
Received: from bharata.ibmuc.com (unknown [9.199.57.57])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 22 Aug 2019 10:26:30 +0000 (GMT)
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com, hch@lst.de,
        Bharata B Rao <bharata@linux.ibm.com>
Subject: [PATCH v7 0/7] KVMPPC driver to manage secure guest pages
Date:   Thu, 22 Aug 2019 15:56:13 +0530
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19082210-4275-0000-0000-0000035BD3F9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082210-4276-0000-0000-0000386DF9B4
Message-Id: <20190822102620.21897-1-bharata@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-22_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908220112
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi,

A pseries guest can be run as a secure guest on Ultravisor-enabled
POWER platforms. On such platforms, this driver will be used to manage
the movement of guest pages between the normal memory managed by
hypervisor(HV) and secure memory managed by Ultravisor(UV).

Private ZONE_DEVICE memory equal to the amount of secure memory
available in the platform for running secure guests is created.
Whenever a page belonging to the guest becomes secure, a page from
this private device memory is used to represent and track that secure
page on the HV side. The movement of pages between normal and secure
memory is done via migrate_vma_pages(). The reverse movement is driven
via pagemap_ops.migrate_to_ram().

The page-in or page-out requests from UV will come to HV as hcalls and
HV will call back into UV via uvcalls to satisfy these page requests.

These patches are against hmm.git
(https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/log/?h=hmm)

plus

Claudio Carvalho's base ultravisor enablement patchset v6
(https://lore.kernel.org/linuxppc-dev/20190822034838.27876-1-cclaudio@linux.ibm.com/T/#t)

These patches along with Claudio's above patches are required to
run a secure pseries guest on KVM. This patchset is based on hmm.git
because hmm.git has migrate_vma cleanup and not-device memremap_pages
patchsets that are required by this patchset.

Changes in v7
=============
- The major change in this version is to not create a char device but
  instead use the not device versions of memremap_pages and
  request_free_mem_region (Christoph Hellwig)
- Other changes
  * Addressed all the changes suggested by Christoph Hellwig for v6.
  * Removed MIGRATE_VMA_HELPER dependency
  * Switched to using of_find_compatible_node() and not doing
    find by path (Thiago Jung Bauermann)
  * Moved kvmppc_rmap_is_devm_pfn to kvm_host.h
  * Updated comments
  * use @page_shift argument in H_SVM_PAGE_OUT instead of PAGE_SHIFT
  * Proper handling of return val from kvmppc_devm_fault_migrate_alloc_and_copy

v6: https://lore.kernel.org/linuxppc-dev/20190809084108.30343-1-bharata@linux.ibm.com/T/#t

Anshuman Khandual (1):
  KVM: PPC: Ultravisor: Add PPC_UV config option

Bharata B Rao (6):
  kvmppc: Driver to manage pages of secure guest
  kvmppc: Shared pages support for secure guests
  kvmppc: H_SVM_INIT_START and H_SVM_INIT_DONE hcalls
  kvmppc: Handle memory plug/unplug to secure VM
  kvmppc: Radix changes for secure guest
  kvmppc: Support reset of secure guest

 Documentation/virtual/kvm/api.txt          |  19 +
 arch/powerpc/Kconfig                       |  17 +
 arch/powerpc/include/asm/hvcall.h          |   9 +
 arch/powerpc/include/asm/kvm_book3s_devm.h |  47 ++
 arch/powerpc/include/asm/kvm_host.h        |  39 ++
 arch/powerpc/include/asm/kvm_ppc.h         |   2 +
 arch/powerpc/include/asm/ultravisor-api.h  |   6 +
 arch/powerpc/include/asm/ultravisor.h      |  36 ++
 arch/powerpc/kvm/Makefile                  |   3 +
 arch/powerpc/kvm/book3s_64_mmu_radix.c     |  22 +
 arch/powerpc/kvm/book3s_hv.c               | 113 ++++
 arch/powerpc/kvm/book3s_hv_devm.c          | 614 +++++++++++++++++++++
 arch/powerpc/kvm/powerpc.c                 |  12 +
 include/uapi/linux/kvm.h                   |   1 +
 14 files changed, 940 insertions(+)
 create mode 100644 arch/powerpc/include/asm/kvm_book3s_devm.h
 create mode 100644 arch/powerpc/kvm/book3s_hv_devm.c

-- 
2.21.0

