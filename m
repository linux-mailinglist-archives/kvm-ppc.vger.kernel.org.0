Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 249BB1086B0
	for <lists+kvm-ppc@lfdr.de>; Mon, 25 Nov 2019 04:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfKYDGp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 24 Nov 2019 22:06:45 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43138 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726910AbfKYDGp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 24 Nov 2019 22:06:45 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAP31x0b105834
        for <kvm-ppc@vger.kernel.org>; Sun, 24 Nov 2019 22:06:44 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wfjqxj6n2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Sun, 24 Nov 2019 22:06:43 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Mon, 25 Nov 2019 03:06:41 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 25 Nov 2019 03:06:38 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAP36atT46596332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Nov 2019 03:06:36 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6ACD34C046;
        Mon, 25 Nov 2019 03:06:36 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FA1E4C044;
        Mon, 25 Nov 2019 03:06:34 +0000 (GMT)
Received: from bharata.in.ibm.com (unknown [9.124.35.39])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Nov 2019 03:06:34 +0000 (GMT)
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org
Cc:     paulus@au1.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        jglisse@redhat.com, cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sukadev@linux.vnet.ibm.com, hch@lst.de,
        Bharata B Rao <bharata@linux.ibm.com>
Subject: [PATCH v11 0/7] KVM: PPC: Driver to manage pages of secure guest
Date:   Mon, 25 Nov 2019 08:36:24 +0530
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19112503-0008-0000-0000-000003371ECD
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112503-0009-0000-0000-00004A5651D5
Message-Id: <20191125030631.7716-1-bharata@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-24_04:2019-11-21,2019-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=2
 bulkscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0 mlxscore=0
 clxscore=1015 mlxlogscore=805 spamscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1911250026
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi,

This is the next version of the patchset that adds required support
in the KVM hypervisor to run secure guests on PEF-enabled POWER platforms.

This version includes the following changes:

- Ensure that any malicious calls to the 4 hcalls (init_start, init_done,
  page_in and page_out) are handled safely by returning appropriate
  errors (Paul Mackerras)
- init_start hcall should work for only radix guests.
- Fix the page-size-order argument in uv_page_inval (Ram Pai)
- Don't free up partition scoped page tables in HV when guest
  becomes secure (Paul Mackerras)
- During guest reset, when we unpin VPA pages, make sure that no vcpu
  is running and fail the SVM_OFF ioctl if any are running (Paul Mackerras)
- Dropped the patch that implemented init_abort hcall as it still has
  unresolved questions.

Anshuman Khandual (1):
  KVM: PPC: Ultravisor: Add PPC_UV config option

Bharata B Rao (6):
  mm: ksm: Export ksm_madvise()
  KVM: PPC: Support for running secure guests
  KVM: PPC: Shared pages support for secure guests
  KVM: PPC: Radix changes for secure guest
  KVM: PPC: Handle memory plug/unplug to secure VM
  KVM: PPC: Support reset of secure guest

 Documentation/virt/kvm/api.txt              |  18 +
 arch/powerpc/Kconfig                        |  17 +
 arch/powerpc/include/asm/hvcall.h           |   9 +
 arch/powerpc/include/asm/kvm_book3s_uvmem.h |  74 ++
 arch/powerpc/include/asm/kvm_host.h         |   6 +
 arch/powerpc/include/asm/kvm_ppc.h          |   1 +
 arch/powerpc/include/asm/ultravisor-api.h   |   6 +
 arch/powerpc/include/asm/ultravisor.h       |  36 +
 arch/powerpc/kvm/Makefile                   |   3 +
 arch/powerpc/kvm/book3s_64_mmu_radix.c      |  25 +
 arch/powerpc/kvm/book3s_hv.c                | 143 ++++
 arch/powerpc/kvm/book3s_hv_uvmem.c          | 774 ++++++++++++++++++++
 arch/powerpc/kvm/powerpc.c                  |  12 +
 include/uapi/linux/kvm.h                    |   1 +
 mm/ksm.c                                    |   1 +
 15 files changed, 1126 insertions(+)
 create mode 100644 arch/powerpc/include/asm/kvm_book3s_uvmem.h
 create mode 100644 arch/powerpc/kvm/book3s_hv_uvmem.c

-- 
2.21.0

