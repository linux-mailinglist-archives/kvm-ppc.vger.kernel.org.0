Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF91373ED6
	for <lists+kvm-ppc@lfdr.de>; Wed,  5 May 2021 17:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbhEEPsB (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 5 May 2021 11:48:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42332 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229797AbhEEPsA (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 5 May 2021 11:48:00 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 145Fan3h035719;
        Wed, 5 May 2021 11:46:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=bjz0D+dyoNUijWoLP3EIMpTRfNvW0o6rDQrR5crAExc=;
 b=ncbaJFVZPAc+B3SmVRqwEKC/NKYCGSKztaHHNP+/p+VRl5LaHfjHfI0BsNBRx5gnehNM
 9GDloemceANIFJSA8KbExPzo7K+WWe7HaSSNlIKflGcNaaAwtCBq+ugSs+r8jVNCdm/m
 zJ5Izyq8JKvVKi/9UDMyrma8rTZ3pz39YiQsnRxMB6088kuHeD9+ChGp4pwsAXmKVyWh
 zm4W7ZNu4g0FE9/UL2sa6aR4RPnaihGxZlqkVZwCoVVYeHdCwmlEXzlhh9zBCtLX99mV
 Od2HUM6UgmkDIr7Y20R2cVXI0zV+S2tgV6m2TCuvb5KyibEuq6zteR1oak4eJwcTEQ43 /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38bwnm17tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 11:46:54 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 145Fb4Ii039973;
        Wed, 5 May 2021 11:46:53 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38bwnm17sr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 11:46:53 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 145Fc18C005701;
        Wed, 5 May 2021 15:46:52 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 38bedxrd0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 15:46:51 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 145FkNvq22413730
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 May 2021 15:46:23 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9020AE045;
        Wed,  5 May 2021 15:46:48 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10962AE04D;
        Wed,  5 May 2021 15:46:47 +0000 (GMT)
Received: from bharata.ibmuc.com (unknown [9.85.85.70])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 May 2021 15:46:46 +0000 (GMT)
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     aneesh.kumar@linux.ibm.com, npiggin@gmail.com, paulus@ozlabs.org,
        mpe@ellerman.id.au, david@gibson.dropbear.id.au,
        farosas@linux.ibm.com, Bharata B Rao <bharata@linux.ibm.com>
Subject: [PATCH v7 0/6] Support for H_RPT_INVALIDATE in PowerPC KVM
Date:   Wed,  5 May 2021 21:16:36 +0530
Message-Id: <20210505154642.178702-1-bharata@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: emvM_ZSY_xJaC1ezJTn3bqKA0J6OD7YQ
X-Proofpoint-ORIG-GUID: DfLJh-1De-GEUROqED1vpo08e4peA5__
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-05_09:2021-05-05,2021-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1011
 lowpriorityscore=0 adultscore=0 spamscore=0 bulkscore=0 phishscore=0
 mlxlogscore=790 suspectscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050112
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This patchset adds support for the new hcall H_RPT_INVALIDATE
and replaces the nested tlb flush calls with this new hcall
if support for the same exists.

Changes in v7:
-------------
- Fixed a bug where LPID of nested guest was being fetched
  wrongly in the process scoped invalidation part of nested
  guest exit handler.
  (In kvmppc_nested_h_rpt_invalidate() of patch 4/6)
- Moved the movement of RIC_FLUSH_ definitions to appropriate
  patch.

v6: https://lore.kernel.org/linuxppc-dev/20210311083939.595568-1-bharata@linux.ibm.com/

Aneesh Kumar K.V (1):
  KVM: PPC: Book3S HV: Fix comments of H_RPT_INVALIDATE arguments

Bharata B Rao (5):
  powerpc/book3s64/radix: Add H_RPT_INVALIDATE pgsize encodings to
    mmu_psize_def
  KVM: PPC: Book3S HV: Add support for H_RPT_INVALIDATE
  KVM: PPC: Book3S HV: Nested support in H_RPT_INVALIDATE
  KVM: PPC: Book3S HV: Add KVM_CAP_PPC_RPT_INVALIDATE capability
  KVM: PPC: Book3S HV: Use H_RPT_INVALIDATE in nested KVM

 Documentation/virt/kvm/api.rst                |  18 +++
 arch/powerpc/include/asm/book3s/64/mmu.h      |   1 +
 .../include/asm/book3s/64/tlbflush-radix.h    |   4 +
 arch/powerpc/include/asm/hvcall.h             |   4 +-
 arch/powerpc/include/asm/kvm_book3s.h         |   3 +
 arch/powerpc/include/asm/mmu_context.h        |  11 ++
 arch/powerpc/kvm/book3s_64_mmu_radix.c        |  27 +++-
 arch/powerpc/kvm/book3s_hv.c                  | 106 ++++++++++++
 arch/powerpc/kvm/book3s_hv_nested.c           | 116 ++++++++++++-
 arch/powerpc/kvm/powerpc.c                    |   3 +
 arch/powerpc/mm/book3s64/radix_pgtable.c      |   5 +
 arch/powerpc/mm/book3s64/radix_tlb.c          | 152 +++++++++++++++++-
 include/uapi/linux/kvm.h                      |   1 +
 13 files changed, 438 insertions(+), 13 deletions(-)

-- 
2.26.2

