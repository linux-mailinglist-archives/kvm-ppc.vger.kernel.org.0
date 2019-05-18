Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B508223A4
	for <lists+kvm-ppc@lfdr.de>; Sat, 18 May 2019 16:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbfEROZe (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 18 May 2019 10:25:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55598 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727594AbfEROZe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 18 May 2019 10:25:34 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4IEGXjC146113
        for <kvm-ppc@vger.kernel.org>; Sat, 18 May 2019 10:25:32 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sje84rtnv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Sat, 18 May 2019 10:25:32 -0400
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <cclaudio@linux.ibm.com>;
        Sat, 18 May 2019 15:25:31 +0100
Received: from b03cxnp07029.gho.boulder.ibm.com (9.17.130.16)
        by e33.co.us.ibm.com (192.168.1.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 18 May 2019 15:25:30 +0100
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4IEPSqi7078150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 May 2019 14:25:28 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C46AF7805C;
        Sat, 18 May 2019 14:25:28 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03CD27805E;
        Sat, 18 May 2019 14:25:25 +0000 (GMT)
Received: from rino.ibm.com (unknown [9.85.168.40])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 18 May 2019 14:25:25 +0000 (GMT)
From:   Claudio Carvalho <cclaudio@linux.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Cc:     Ram Pai <linuxram@us.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: [RFC PATCH v2 00/10] kvmppc: Paravirtualize KVM to support ultravisor
Date:   Sat, 18 May 2019 11:25:14 -0300
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19051814-0036-0000-0000-00000ABE1AB0
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011118; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01205121; UDB=6.00632701; IPR=6.00986061;
 MB=3.00026948; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-18 14:25:31
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051814-0037-0000-0000-00004BD7C8D2
Message-Id: <20190518142524.28528-1-cclaudio@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-18_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905180103
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

POWER platforms that supports the Protected Execution Facility (PEF)
introduce features that combine hardware facilities and firmware to
enable secure virtual machines. That includes a new processor mode
(ultravisor mode) and the ultravisor firmware.

In PEF enabled systems, the ultravisor firmware runs at a privilege
level above the hypervisor and also takes control over some system
resources. The hypervisor, though, can make system calls to access these
resources. Such system calls, a.k.a. ucalls, are handled by the
ultravisor firmware.

The processor allows part of the system memory to be configured as
secure memory, and introduces a a new mode, called secure mode, where
any software entity in that mode can access secure memory. The
hypervisor doesn't (and can't) run in secure mode, but a secure guest
and the ultravisor firmware do.

This patch set adds support for ultravisor calls and do some preparation
for running secure guests

---
Changelog:
---
v1->v2:
 - Addressed comments from Paul Mackerras:
     - Write the pate in HV's table before doing that in UV's
     - Renamed and better documented the ultravisor header files. Also added
       all possible return codes for each ucall
     - Updated the commit message that introduces the MSR_S bit
     - Moved ultravisor.c and ucall.S to arch/powerpc/kernel
     - Changed ucall.S to not save CR
 - Rebased
 - Changed the patches order
 - Updated several commit messages
 - Added FW_FEATURE_ULTRAVISOR to enable use of firmware_has_feature()
 - Renamed CONFIG_PPC_KVM_UV to CONFIG_PPC_UV and used it to ifdef the ucall
   handler and the code that populates the powerpc_firmware_features for 
   ultravisor
 - Exported the ucall symbol. KVM may be built as module.
 - Restricted LDBAR access if the ultravisor firmware is available
 - Dropped patches:
     "[PATCH 06/13] KVM: PPC: Ultravisor: UV_RESTRICTED_SPR_WRITE ucall"
     "[PATCH 07/13] KVM: PPC: Ultravisor: UV_RESTRICTED_SPR_READ ucall"
     "[PATCH 08/13] KVM: PPC: Ultravisor: fix mtspr and mfspr"
 - Squashed patches:
     "[PATCH 09/13] KVM: PPC: Ultravisor: Return to UV for hcalls from SVM"
     "[PATCH 13/13] KVM: PPC: UV: Have fast_guest_return check secure_guest"

Anshuman Khandual (1):
  KVM: PPC: Ultravisor: Add PPC_UV config option

Claudio Carvalho (1):
  powerpc: Introduce FW_FEATURE_ULTRAVISOR

Michael Anderson (2):
  KVM: PPC: Ultravisor: Use UV_WRITE_PATE ucall to register a PATE
  KVM: PPC: Ultravisor: Check for MSR_S during hv_reset_msr

Paul Mackerras (1):
  KVM: PPC: Book3S HV: Fixed for running secure guests

Ram Pai (3):
  KVM: PPC: Ultravisor: Add generic ultravisor call handler
  KVM: PPC: Ultravisor: Restrict flush of the partition tlb cache
  KVM: PPC: Ultravisor: Restrict LDBAR access

Sukadev Bhattiprolu (2):
  KVM: PPC: Ultravisor: Introduce the MSR_S bit
  KVM: PPC: Ultravisor: Return to UV for hcalls from SVM

 arch/powerpc/Kconfig                         | 20 ++++++
 arch/powerpc/include/asm/firmware.h          |  5 +-
 arch/powerpc/include/asm/kvm_host.h          |  1 +
 arch/powerpc/include/asm/reg.h               |  3 +
 arch/powerpc/include/asm/ultravisor-api.h    | 24 ++++++++
 arch/powerpc/include/asm/ultravisor.h        | 49 +++++++++++++++
 arch/powerpc/kernel/Makefile                 |  1 +
 arch/powerpc/kernel/asm-offsets.c            |  1 +
 arch/powerpc/kernel/prom.c                   |  6 ++
 arch/powerpc/kernel/ucall.S                  | 31 ++++++++++
 arch/powerpc/kernel/ultravisor.c             | 30 +++++++++
 arch/powerpc/kvm/book3s_64_mmu_hv.c          |  1 +
 arch/powerpc/kvm/book3s_hv.c                 |  4 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S      | 40 ++++++++++--
 arch/powerpc/mm/book3s64/hash_utils.c        |  3 +-
 arch/powerpc/mm/book3s64/pgtable.c           | 65 +++++++++++++++-----
 arch/powerpc/mm/book3s64/radix_pgtable.c     |  9 ++-
 arch/powerpc/perf/imc-pmu.c                  | 64 +++++++++++--------
 arch/powerpc/platforms/powernv/idle.c        |  6 +-
 arch/powerpc/platforms/powernv/subcore-asm.S |  4 ++
 20 files changed, 311 insertions(+), 56 deletions(-)
 create mode 100644 arch/powerpc/include/asm/ultravisor-api.h
 create mode 100644 arch/powerpc/include/asm/ultravisor.h
 create mode 100644 arch/powerpc/kernel/ucall.S
 create mode 100644 arch/powerpc/kernel/ultravisor.c

-- 
2.20.1

