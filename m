Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE3A6FA0ED
	for <lists+kvm-ppc@lfdr.de>; Mon,  8 May 2023 09:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbjEHHYc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 8 May 2023 03:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbjEHHYc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 8 May 2023 03:24:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F7459E9
        for <kvm-ppc@vger.kernel.org>; Mon,  8 May 2023 00:24:30 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3486rpfD001876;
        Mon, 8 May 2023 07:24:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=ov2xZAUL/bUB+2gIs5F5Pqf6TabCEJarH0hajbuZiSc=;
 b=SKQ59vkOssoyGVvYoPWqKsA5+nhpE/dwsFuAbkTprtkiUsMrORRqhcpFl96YIDmpW5Cf
 Z3bpPL//MZa1iHyaOB60asfKDGUJG0SKwBAqHys9R/+YTehEc6VH5eSb0ZMOjldC24FW
 inwKRMYocrYeTMK/RadYdauUivJrkZmp2mAq1DMFmgtvm5dCPt/R6iUPvUny67OoPlog
 kyAfcSjQVM+MW6j1aAoYxGaRgLbzGN52R43A5cqUC2ldEpW3zyQcaeJUPBdiXAOLKZXB
 keXuYM73hwNczSD9+l8KIoXJOrJ27lXiXTmPDFzWCOZ0CLoMbMI2nULdpMyRZ3Od7RBp QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qev7agxmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 07:24:21 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3487JAlH017934;
        Mon, 8 May 2023 07:24:21 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qev7agxme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 07:24:20 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3483uFRQ026602;
        Mon, 8 May 2023 07:24:19 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3qdeh6gsnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 07:24:19 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3487OFYB2097732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 May 2023 07:24:15 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D02A20043;
        Mon,  8 May 2023 07:24:15 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D28A20040;
        Mon,  8 May 2023 07:24:10 +0000 (GMT)
Received: from pwon.ibmuc.com (unknown [9.177.74.71])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  8 May 2023 07:24:09 +0000 (GMT)
From:   Jordan Niethe <jpn@linux.vnet.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, npiggin@gmail.com, mikey@neuling.org,
        paulus@ozlabs.org, kautuk.consul.1980@gmail.com,
        vaibhav@linux.ibm.com, sbhat@linux.ibm.com,
        Jordan Niethe <jpn@linux.vnet.ibm.com>
Subject: [RFC PATCH v1 0/5] KVM: PPC: Nested PAPR guests
Date:   Mon,  8 May 2023 17:23:27 +1000
Message-Id: <20230508072332.2937883-1-jpn@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: W1GJDL6quJjFD48OkYle-VwO8qvSqAVb
X-Proofpoint-GUID: _RqlZGItcbO3Ogtizf4YUZfsK6OHiJm3
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-08_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 clxscore=1011 suspectscore=0 mlxscore=0
 bulkscore=0 impostorscore=0 phishscore=0 mlxlogscore=558 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305080049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

There is existing support for nested guests on powernv hosts however the
hcall interface this uses is not support by other PAPR hosts. A set of
new hcalls will be added to PAPR to facilitate creating and managing
guests by a regular partition in the following way:

  - L1 and L0 negotiate capabilities with
    H_GUEST_{G,S}ET_CAPABILITIES

  - L1 requests the L0 create a L2 with
    H_GUEST_CREATE and receives a handle to use in future hcalls

  - L1 requests the L0 create a L2 vCPU with
    H_GUEST_CREATE_VCPU

  - L1 sets up the L2 using H_GUEST_SET and the
    H_GUEST_VCPU_RUN input buffer

  - L1 requests the L0 runs the L2 vCPU using H_GUEST_VCPU_RUN

  - L2 returns to L1 with an exit reason and L1 reads the
    H_GUEST_VCPU_RUN output buffer populated by the L0

  - L1 handles the exit using H_GET_STATE if necessary

  - L1 reruns L2 vCPU with H_GUEST_VCPU_RUN

  - L1 frees the L2 in the L0 with H_GUEST_DELETE

Further details are available in Documentation/powerpc/kvm-nested.rst.

This series adds KVM support for using this hcall interface as a regular
PAPR partition, i.e. the L1. It does not add support for running as the
L0.

The new hcalls have been implemented in the spapr qemu model for
testing.

This is available at https://github.com/mikey/qemu/tree/kvm-papr

There are scripts available to assist in setting up an environment for
testing nested guests at https://github.com/mikey/kvm-powervm-test

Thanks to Kautuk Consul, Vaibhav Jain, Michael Neuling, Shivaprasad
Bhat, Harsh Prateek Bora, Paul Mackerras and Nicholas Piggin. 

Jordan Niethe (5):
  KVM: PPC: Use getters and setters for vcpu register state
  KVM: PPC: Add fpr getters and setters
  KVM: PPC: Add vr getters and setters
  powerpc: Add helper library for Guest State Buffers
  KVM: PPC: Add support for nested PAPR guests

 Documentation/powerpc/index.rst               |    1 +
 Documentation/powerpc/kvm-nested.rst          |  636 +++++++++
 arch/powerpc/include/asm/guest-state-buffer.h | 1133 +++++++++++++++++
 arch/powerpc/include/asm/hvcall.h             |   30 +
 arch/powerpc/include/asm/kvm_book3s.h         |  203 ++-
 arch/powerpc/include/asm/kvm_book3s_64.h      |    6 +
 arch/powerpc/include/asm/kvm_booke.h          |   10 +
 arch/powerpc/include/asm/kvm_host.h           |   21 +
 arch/powerpc/include/asm/kvm_ppc.h            |   80 +-
 arch/powerpc/include/asm/plpar_wrappers.h     |  198 +++
 arch/powerpc/kvm/Makefile                     |    1 +
 arch/powerpc/kvm/book3s.c                     |   38 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c           |    4 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c        |    9 +-
 arch/powerpc/kvm/book3s_64_vio.c              |    4 +-
 arch/powerpc/kvm/book3s_hv.c                  |  337 +++--
 arch/powerpc/kvm/book3s_hv.h                  |   66 +
 arch/powerpc/kvm/book3s_hv_builtin.c          |   10 +-
 arch/powerpc/kvm/book3s_hv_nested.c           |   34 +-
 arch/powerpc/kvm/book3s_hv_p9_entry.c         |    4 +-
 arch/powerpc/kvm/book3s_hv_papr.c             |  947 ++++++++++++++
 arch/powerpc/kvm/book3s_hv_ras.c              |    5 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c           |    8 +-
 arch/powerpc/kvm/book3s_hv_rm_xics.c          |    4 +-
 arch/powerpc/kvm/book3s_xive.c                |    9 +-
 arch/powerpc/kvm/emulate_loadstore.c          |    6 +-
 arch/powerpc/kvm/powerpc.c                    |   76 +-
 arch/powerpc/lib/Makefile                     |    3 +-
 arch/powerpc/lib/guest-state-buffer.c         |  560 ++++++++
 arch/powerpc/lib/test-guest-state-buffer.c    |  334 +++++
 30 files changed, 4560 insertions(+), 217 deletions(-)
 create mode 100644 Documentation/powerpc/kvm-nested.rst
 create mode 100644 arch/powerpc/include/asm/guest-state-buffer.h
 create mode 100644 arch/powerpc/kvm/book3s_hv_papr.c
 create mode 100644 arch/powerpc/lib/guest-state-buffer.c
 create mode 100644 arch/powerpc/lib/test-guest-state-buffer.c

-- 
2.31.1

