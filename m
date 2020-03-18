Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C39C218A1DE
	for <lists+kvm-ppc@lfdr.de>; Wed, 18 Mar 2020 18:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbgCRRne (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 18 Mar 2020 13:43:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34414 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727236AbgCRRnd (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 18 Mar 2020 13:43:33 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02IHWjnC062836
        for <kvm-ppc@vger.kernel.org>; Wed, 18 Mar 2020 13:43:32 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yu98tg8xu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Wed, 18 Mar 2020 13:43:31 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <groug@kaod.org>;
        Wed, 18 Mar 2020 17:43:30 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Mar 2020 17:43:26 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02IHhPI351183854
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 17:43:25 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47E6BA405B;
        Wed, 18 Mar 2020 17:43:25 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 030D9A4054;
        Wed, 18 Mar 2020 17:43:25 +0000 (GMT)
Received: from bahia.lan (unknown [9.145.41.106])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Mar 2020 17:43:24 +0000 (GMT)
Subject: [PATCH 0/3] KVM: PPC: Fix host kernel crash with PR KVM
From:   Greg Kurz <groug@kaod.org>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date:   Wed, 18 Mar 2020 18:43:24 +0100
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20031817-0008-0000-0000-0000035F7AD2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031817-0009-0000-0000-00004A80D601
Message-Id: <158455340419.178873.11399595021669446372.stgit@bahia.lan>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_07:2020-03-18,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1034
 adultscore=0 mlxlogscore=713 suspectscore=2 impostorscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180076
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Recent cleanup from Sean Christopherson introduced a use-after-free
condition that crashes the kernel when shutting down the VM with
PR KVM. It went unnoticed so far because PR isn't tested/used much
these days (mostly used for nested on POWER8, not supported on POWER9
where HV should be used for nested), and other KVM implementations for
ppc are unaffected.

This all boils down to the fact that the path that frees the per-vCPU
MMU data goes through a complex set of indirections. This obfuscates
the code to the point that we didn't realize that the MMU data was
now being freed too early. And worse, most of the indirection isn't
needed because only PR KVM has some MMU data to free when the vCPU is
destroyed.

Fix the issue (patch 1) and simplify the code (patch 2 and 3).

--
Greg

---

Greg Kurz (3):
      KVM: PPC: Fix kernel crash with PR KVM
      KVM: PPC: Move kvmppc_mmu_init() PR KVM
      KVM: PPC: Kill kvmppc_ops::mmu_destroy() and kvmppc_mmu_destroy()


 arch/powerpc/include/asm/kvm_ppc.h    |    3 ---
 arch/powerpc/kvm/book3s.c             |    5 -----
 arch/powerpc/kvm/book3s.h             |    1 +
 arch/powerpc/kvm/book3s_32_mmu_host.c |    2 +-
 arch/powerpc/kvm/book3s_64_mmu_host.c |    2 +-
 arch/powerpc/kvm/book3s_hv.c          |    6 ------
 arch/powerpc/kvm/book3s_pr.c          |    4 ++--
 arch/powerpc/kvm/booke.c              |    5 -----
 arch/powerpc/kvm/booke.h              |    2 --
 arch/powerpc/kvm/e500.c               |    1 -
 arch/powerpc/kvm/e500_mmu.c           |    4 ----
 arch/powerpc/kvm/e500mc.c             |    1 -
 arch/powerpc/kvm/powerpc.c            |    2 --
 13 files changed, 5 insertions(+), 33 deletions(-)

