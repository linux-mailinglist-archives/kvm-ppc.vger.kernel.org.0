Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E301B858DC
	for <lists+kvm-ppc@lfdr.de>; Thu,  8 Aug 2019 06:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbfHHEGJ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 8 Aug 2019 00:06:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21526 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725270AbfHHEGI (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 8 Aug 2019 00:06:08 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7842KMM105994;
        Thu, 8 Aug 2019 00:06:05 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2u8a23vu88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 00:06:04 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7844Z8J032135;
        Thu, 8 Aug 2019 04:06:03 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 2u51w6ug0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 04:06:03 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x78462Jq49086940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Aug 2019 04:06:02 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3593C6057;
        Thu,  8 Aug 2019 04:06:01 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 627DCC6055;
        Thu,  8 Aug 2019 04:05:57 +0000 (GMT)
Received: from rino.ibm.com (unknown [9.85.135.60])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  8 Aug 2019 04:05:57 +0000 (GMT)
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
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>,
        Guerney Hunt <gdhh@linux.ibm.com>
Subject: [PATCH v5 0/7] kvmppc: Paravirtualize KVM to support ultravisor
Date:   Thu,  8 Aug 2019 01:05:48 -0300
Message-Id: <20190808040555.2371-1-cclaudio@linux.ibm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080042
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Protected Execution Facility (PEF) is an architectural change for POWER 9
that enables Secure Virtual Machines (SVMs). When enabled, PEF adds a new
higher privileged mode, called Ultravisor mode, to POWER architecture.
Along with the new mode there is new firmware called the Protected
Execution Ultravisor (or Ultravisor for short). Ultravisor mode is the
highest privileged mode in POWER architecture.

The Ultravisor calls allow the SVMs and Hypervisor to request services from
the Ultravisor such as accessing a register or memory region that can only
be accessed when running in Ultravisor-privileged mode.

This patch set adds support for Ultravisor calls and do some preparation
for running secure guests.

---
Changelog:
---

v4->v5:

- New patch "Documentation/powerpc: Ultravisor API"

- Patch "v4: KVM: PPC: Ultravisor: Add generic ultravisor call handler":
  - Made global the ucall_norets symbol without adding it to the TOC.
  - Implemented ucall_norets() rather than ucall().
  - Defined the ucall_norets in "asm/asm-prototypes.h" for symbol
    versioning.
  - Renamed to "powerpc/kernel: Add ucall_norets() ultravisor call
    handler".
  - Updated the commit message.

- Patch "v4: powerpc: Introduce FW_FEATURE_ULTRAVISOR":
  - Changed to scan for a node that is compatible with "ibm,ultravisor"
  - Renamed to "powerpc/powernv: Introduce FW_FEATURE_ULTRAVISOR".
  - Updated the commit message.

- Patch "v4: KVM: PPC: Ultravisor: Restrict flush of the partition tlb
  cache":
  - Merged into "v4: ... Use UV_WRITE_PATE ucall to register a PATE".

- Patch "v4: KVM: PPC: Ultravisor: Use UV_WRITE_PATE ucall to register a
  PATE":
  - Added back the missing "ptesync" instruction in flush_partition().
  - Updated source code comments for the partition table creation.
  - Factored out "powerpc/mm: Write to PTCR only if ultravisor disabled".
  - Cleaned up the code a bit.
  - Renamed to "powerpc/mm: Use UV_WRITE_PATE ucall to register a PATE".
  - Updated the commit message.

- Patch "v4: KVM: PPC: Ultravisor: Restrict LDBAR access":
  - Dropped the change that skips loading the IMC driver if ultravisor
    enabled because skiboot will remove the IMC devtree nodes if
    ultravisor enabled.
  - Dropped the BEGIN_{END_}FW_FTR_SECTION_NESTED in power8 code.
  - Renamed to "powerpc/powernv: Access LDBAR only if ultravisor
    disabled".
  - Updated the commit message.

- Patch "v4: KVM: PPC: Ultravisor: Enter a secure guest":
  - Openned "LOAD_REG_IMMEDIATE(r3, UV_RETURN)" to save instructions
  - Used R2, rather than R11, to pass synthesized interrupts in
    UV_RETURN ucall.
  - Dropped the change that preserves the MSR[S] bit in
    "kvmppc_msr_interrupt" because that is done by the ultravisor.
  - Hoisted up the load of R6 and R7 to before "bne ret_to_ultra".
  - Cleaned up the code a bit.
  - Renamed to "powerpc/kvm: Use UV_RETURN ucall to return to ultravisor".
  - Updated the commit message.

- Patch "v4: KVM: PPC: Ultravisor: Check for MSR_S during hv_reset_msr":
  - Dropped from the patch set because "kvm_arch->secure_guest" rather
    than MSR[S] is used to determine if we need to return to the
    ultravisor.

- Patch "v4: KVM: PPC: Ultravisor: Introduce the MSR_S bit":
  - Moved to the patch set "Secure Virtual Machine Enablement" posted by
    Thiago Bauermann. MSR[S] is no longer needed in this patch set.

- Rebased to powerpc/next

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

Claudio Carvalho (4):
  powerpc/kernel: Add ucall_norets() ultravisor call handler
  powerpc/powernv: Introduce FW_FEATURE_ULTRAVISOR
  powerpc/mm: Write to PTCR only if ultravisor disabled
  powerpc/powernv: Access LDBAR only if ultravisor disabled

Michael Anderson (1):
  powerpc/mm: Use UV_WRITE_PATE ucall to register a PATE

Sukadev Bhattiprolu (2):
  Documentation/powerpc: Ultravisor API
  powerpc/kvm: Use UV_RETURN ucall to return to ultravisor

 Documentation/powerpc/ultravisor.rst        | 1055 +++++++++++++++++++
 arch/powerpc/include/asm/asm-prototypes.h   |   11 +
 arch/powerpc/include/asm/firmware.h         |    5 +-
 arch/powerpc/include/asm/kvm_host.h         |    1 +
 arch/powerpc/include/asm/reg.h              |   13 +
 arch/powerpc/include/asm/ultravisor-api.h   |   29 +
 arch/powerpc/include/asm/ultravisor.h       |   22 +
 arch/powerpc/kernel/Makefile                |    1 +
 arch/powerpc/kernel/asm-offsets.c           |    1 +
 arch/powerpc/kernel/prom.c                  |    4 +
 arch/powerpc/kernel/ucall.S                 |   20 +
 arch/powerpc/kvm/book3s_hv_rmhandlers.S     |   39 +-
 arch/powerpc/mm/book3s64/hash_utils.c       |    4 +-
 arch/powerpc/mm/book3s64/pgtable.c          |   62 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c    |    6 +-
 arch/powerpc/platforms/powernv/Makefile     |    1 +
 arch/powerpc/platforms/powernv/idle.c       |    6 +-
 arch/powerpc/platforms/powernv/ultravisor.c |   24 +
 18 files changed, 1271 insertions(+), 33 deletions(-)
 create mode 100644 Documentation/powerpc/ultravisor.rst
 create mode 100644 arch/powerpc/include/asm/ultravisor-api.h
 create mode 100644 arch/powerpc/include/asm/ultravisor.h
 create mode 100644 arch/powerpc/kernel/ucall.S
 create mode 100644 arch/powerpc/platforms/powernv/ultravisor.c

-- 
2.20.1

