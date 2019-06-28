Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6311D5A5A3
	for <lists+kvm-ppc@lfdr.de>; Fri, 28 Jun 2019 22:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfF1UIj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 28 Jun 2019 16:08:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52746 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726762AbfF1UIi (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 28 Jun 2019 16:08:38 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5SK6qlP032895
        for <kvm-ppc@vger.kernel.org>; Fri, 28 Jun 2019 16:08:35 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tdr3ptye9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Fri, 28 Jun 2019 16:08:35 -0400
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <cclaudio@linux.ibm.com>;
        Fri, 28 Jun 2019 21:08:33 +0100
Received: from b03cxnp07028.gho.boulder.ibm.com (9.17.130.15)
        by e32.co.us.ibm.com (192.168.1.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 28 Jun 2019 21:08:30 +0100
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5SK8TKG21692774
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jun 2019 20:08:29 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C5BA78067;
        Fri, 28 Jun 2019 20:08:29 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9824378063;
        Fri, 28 Jun 2019 20:08:26 +0000 (GMT)
Received: from rino.br.ibm.com (unknown [9.18.235.108])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 28 Jun 2019 20:08:26 +0000 (GMT)
From:   Claudio Carvalho <cclaudio@linux.ibm.com>
To:     linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>
Subject: [PATCH v4 0/8] kvmppc: Paravirtualize KVM to support ultravisor
Date:   Fri, 28 Jun 2019 17:08:17 -0300
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19062820-0004-0000-0000-000015221C8C
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011348; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01224623; UDB=6.00644561; IPR=6.01005816;
 MB=3.00027511; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-28 20:08:32
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062820-0005-0000-0000-00008C421A18
Message-Id: <20190628200825.31049-1-cclaudio@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906280230
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
for running secure guests.

---
Changelog:
---

v3->v4:

- Patch "KVM: PPC: Ultravisor: Add PPC_UV config option":
  - Moved to the patchset "kvmppc: HMM driver to manage pages of secure
    guest" v5 that will be posted by Bharata Rao.

- Patch "powerpc: Introduce FW_FEATURE_ULTRAVISOR":
  - Changed to depend only on CONFIG_PPC_POWERNV.

- Patch "KVM: PPC: Ultravisor: Add generic ultravisor call handler":
  - Fixed whitespaces in ucall.S and in ultravisor-api.h.
  - Changed to depend only on CONFIG_PPC_POWERNV.
  - Changed the ucall wrapper to pass the ucall number in R3.

- Patch "KVM: PPC: Ultravisor: Use UV_WRITE_PATE ucall to register a
  PATE:
  - Changed to depend only on CONFIG_PPC_POWERNV.

- Patch "KVM: PPC: Ultravisor: Restrict LDBAR access":
  - Fixed comment in opal-imc.c to be "Disable IMC devices, when
    Ultravisor is enabled.
  - Fixed signed-off-by.

- Patch "KVM: PPC: Ultravisor: Enter a secure guest":
  - Changed the UV_RETURN assembly call to save the actual R3 in
    R0 for the ultravisor and pass the UV_RETURN call number in R3.

- Patch "KVM: PPC: Ultravisor: Check for MSR_S during hv_reset_msr":
  - Fixed commit message.

- Rebased to powerpc/next.

v2->v3:

- Squashed patches:
  - "KVM: PPC: Ultravisor: Return to UV for hcalls from SVM"
  - "KVM: PPC: Book3S HV: Fixed for running secure guests"
- Renamed patch from/to:
  - "KVM: PPC: Ultravisor: Return to UV for hcalls from SVM"
  - "KVM: PPC: Ultravisor: Enter a secure guest
- Rebased
- Addressed comments from Paul Mackerras
  - Dropped ultravisor checks made in power8 code
  - Updated the commit message for:
       "KVM: PPC: Ultravisor: Enter a secure guest"
- Addressed comments from Maddy
  - Dropped imc-pmu.c changes
- Changed opal-imc.c to fail the probe when the ultravisor is enabled
- Fixed "ucall defined but not used" issue when CONFIG_PPC_UV not set 

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
  - "[PATCH 06/13] KVM: PPC: Ultravisor: UV_RESTRICTED_SPR_WRITE ucall"
  - "[PATCH 07/13] KVM: PPC: Ultravisor: UV_RESTRICTED_SPR_READ ucall"
  - "[PATCH 08/13] KVM: PPC: Ultravisor: fix mtspr and mfspr"
- Squashed patches:
  - "[PATCH 09/13] KVM: PPC: Ultravisor: Return to UV for hcalls from SVM"
  - "[PATCH 13/13] KVM: PPC: UV: Have fast_guest_return check secure_guest"

Claudio Carvalho (2):
  powerpc: Introduce FW_FEATURE_ULTRAVISOR
  KVM: PPC: Ultravisor: Restrict LDBAR access

Michael Anderson (2):
  KVM: PPC: Ultravisor: Use UV_WRITE_PATE ucall to register a PATE
  KVM: PPC: Ultravisor: Check for MSR_S during hv_reset_msr

Ram Pai (2):
  KVM: PPC: Ultravisor: Add generic ultravisor call handler
  KVM: PPC: Ultravisor: Restrict flush of the partition tlb cache

Sukadev Bhattiprolu (2):
  KVM: PPC: Ultravisor: Introduce the MSR_S bit
  KVM: PPC: Ultravisor: Enter a secure guest

 arch/powerpc/include/asm/firmware.h       |  5 +-
 arch/powerpc/include/asm/kvm_host.h       |  1 +
 arch/powerpc/include/asm/reg.h            |  3 ++
 arch/powerpc/include/asm/ultravisor-api.h | 24 +++++++++
 arch/powerpc/include/asm/ultravisor.h     | 49 +++++++++++++++++
 arch/powerpc/kernel/Makefile              |  1 +
 arch/powerpc/kernel/asm-offsets.c         |  1 +
 arch/powerpc/kernel/prom.c                |  4 ++
 arch/powerpc/kernel/ucall.S               | 30 +++++++++++
 arch/powerpc/kernel/ultravisor.c          | 28 ++++++++++
 arch/powerpc/kvm/book3s_64_mmu_hv.c       |  1 +
 arch/powerpc/kvm/book3s_hv_rmhandlers.S   | 42 ++++++++++++---
 arch/powerpc/mm/book3s64/hash_utils.c     |  3 +-
 arch/powerpc/mm/book3s64/pgtable.c        | 65 +++++++++++++++++------
 arch/powerpc/mm/book3s64/radix_pgtable.c  |  9 ++--
 arch/powerpc/platforms/powernv/idle.c     |  6 ++-
 arch/powerpc/platforms/powernv/opal-imc.c |  4 ++
 17 files changed, 246 insertions(+), 30 deletions(-)
 create mode 100644 arch/powerpc/include/asm/ultravisor-api.h
 create mode 100644 arch/powerpc/include/asm/ultravisor.h
 create mode 100644 arch/powerpc/kernel/ucall.S
 create mode 100644 arch/powerpc/kernel/ultravisor.c

-- 
2.20.1

