Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4596822F74C
	for <lists+kvm-ppc@lfdr.de>; Mon, 27 Jul 2020 20:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgG0SHu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 27 Jul 2020 14:07:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41910 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728545AbgG0SHu (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 27 Jul 2020 14:07:50 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RI1eCY123752;
        Mon, 27 Jul 2020 14:07:33 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32hs0scby0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 14:07:33 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06RI57bW009618;
        Mon, 27 Jul 2020 18:07:32 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 32gcy4jh71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 18:07:31 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06RI7T3J34275606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jul 2020 18:07:29 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE925A4040;
        Mon, 27 Jul 2020 18:07:28 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB895A4057;
        Mon, 27 Jul 2020 18:07:25 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.163.69.7])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jul 2020 18:07:25 +0000 (GMT)
From:   Ram Pai <linuxram@us.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        bharata@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, ldufour@linux.ibm.com,
        bauerman@linux.ibm.com, david@gibson.dropbear.id.au,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sathnaga@linux.vnet.ibm.com
Subject: [PATCH v6 0/5] Migrate non-migrated pages of a SVM.
Date:   Mon, 27 Jul 2020 11:07:13 -0700
Message-Id: <1595873238-26184-1-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_12:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270118
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The time to switch a VM to Secure-VM, increases by the size of the VM.
A 100GB VM takes about 7minutes. This is unacceptable.  This linear
increase is caused by a suboptimal behavior by the Ultravisor and the
Hypervisor.  The Ultravisor unnecessarily migrates all the GFN of the
VM from normal-memory to secure-memory. It has to just migrate the
necessary and sufficient GFNs.

However when the optimization is incorporated in the Ultravisor, the
Hypervisor starts misbehaving. The Hypervisor has a inbuilt assumption
that the Ultravisor will explicitly request to migrate, each and every
GFN of the VM. If only necessary and sufficient GFNs are requested for
migration, the Hypervisor continues to manage the remaining GFNs as
normal GFNs. This leads to memory corruption; manifested
consistently when the SVM reboots.

The same is true, when a memory slot is hotplugged into a SVM. The
Hypervisor expects the ultravisor to request migration of all GFNs to
secure-GFN.  But the hypervisor cannot handle any H_SVM_PAGE_IN
requests from the Ultravisor, done in the context of
UV_REGISTER_MEM_SLOT ucall.  This problem manifests as random errors
in the SVM, when a memory-slot is hotplugged.

This patch series automatically migrates the non-migrated pages of a
SVM, and thus solves the problem.

Testing: Passed rigorous testing using various sized SVMs.

Changelog:

v6:     . rearrangement of functions in book3s_hv_uvmem.c. No functional
		change.
	. decoupling this patch series from Laurent's memory-hotplug/unplug,
		since the memhotplug/unplug/hotplug/reboot test is failing.

v5:  .  This patch series includes Laurent's fix for memory hotplug/unplug
	  . drop pages first and then delete the memslot. Otherwise
	  	the memslot does not get cleanly deleted, causing
		problems during reboot.
	  . recreatable through the following set of commands
	     . device_add pc-dimm,id=dimm1,memdev=mem1
	     . device_del dimm1
	     . device_add pc-dimm,id=dimm1,memdev=mem1
	Further incorporates comments from Bharata:
	. fix for off-by-one while disabling migration.
	. code-reorganized to maximize sharing in init_start path
       		and in memory-hotplug path
	. locking adjustments in mass-page migration during H_SVM_INIT_DONE.
	. improved recovery on error paths.
	. additional comments in the code for better understanding.
	. removed the retry-on-migration-failure code.
	. re-added the initial patch that adjust some prototype to overcome
	   a git problem, where it messes up the code context. Had
		accidently dropped the patch in the last version.

v4:  .  Incorported Bharata's comments:
	- Optimization -- replace write mmap semaphore with read mmap semphore.
	- disable page-merge during memory hotplug.
	- rearranged the patches. consolidated the page-migration-retry logic
		in a single patch.

v3: . Optimized the page-migration retry-logic. 
    . Relax and relinquish the cpu regularly while bulk migrating
    	the non-migrated pages. This issue was causing soft-lockups.
	Fixed it.
    . Added a new patch, to retry page-migration a couple of times
    	before returning H_BUSY in H_SVM_PAGE_IN. This issue was
	seen a few times in a 24hour continuous reboot test of the SVMs.

v2: . fixed a bug observed by Laurent. The state of the GFN's associated
	with Secure-VMs were not reset during memslot flush.
    . Re-organized the code, for easier review.
    . Better description of the patch series.

v1: . fixed a bug observed by Bharata. Pages that where paged-in and later
	paged-out must also be skipped from migration during H_SVM_INIT_DONE.


Laurent Dufour (1):
  KVM: PPC: Book3S HV: migrate hot plugged memory

Ram Pai (4):
  KVM: PPC: Book3S HV: Fix function definition in book3s_hv_uvmem.c
  KVM: PPC: Book3S HV: Disable page merging in H_SVM_INIT_START
  KVM: PPC: Book3S HV: track the state GFNs associated with secure VMs
  KVM: PPC: Book3S HV: in H_SVM_INIT_DONE, migrate remaining normal-GFNs
    to secure-GFNs.

 Documentation/powerpc/ultravisor.rst        |   3 +
 arch/powerpc/include/asm/kvm_book3s_uvmem.h |  14 +
 arch/powerpc/kvm/book3s_hv.c                |  14 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c          | 498 +++++++++++++++++++++++-----
 4 files changed, 437 insertions(+), 92 deletions(-)

-- 
1.8.3.1

