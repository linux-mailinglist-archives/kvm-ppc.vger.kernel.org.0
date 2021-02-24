Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C0A323896
	for <lists+kvm-ppc@lfdr.de>; Wed, 24 Feb 2021 09:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbhBXI0K (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 24 Feb 2021 03:26:10 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56200 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231154AbhBXI0K (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 24 Feb 2021 03:26:10 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11O8422d166054;
        Wed, 24 Feb 2021 03:25:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=zwA8g+tELIvR2uTx6Wcrbr0sBg/VS6TKhTNm4DBK1r8=;
 b=QzymCMiizS9Ywiz4FIsThgiL62JIptWSGuKPohbxY9l/zv2CPif2arC4gG43dmTDp3gD
 dPyfOXLRya5QqtUxJpdaIcKJrhFkcKd+QbZeeX2RqNZPW4oOOcgEa2A9SA7yg761WmMX
 e1DObNlTh6V/KAgEr4pf50DB0l/XEPKqUQXIuRtVs47856Fi5d5fosgcbb2HahYqykKA
 Wl5KWpipeYMNR90FFhhmZhdaiRffy601X5/acI4JnI113WFwKj85fPzwCpzLWmiCcXZo
 BHPt0JxCnM9+DGNmmdCksE/14/yxZeUWnfloHeV0oaWoTQyVoZiyEFGinLyEpzUi//ie Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vkn0512g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Feb 2021 03:25:20 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11O84GPB169982;
        Wed, 24 Feb 2021 03:25:19 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vkn0511j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Feb 2021 03:25:19 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11O8MNgL030979;
        Wed, 24 Feb 2021 08:25:17 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 36tt28bc4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Feb 2021 08:25:17 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11O8PE1343123162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 08:25:15 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A30EDA405C;
        Wed, 24 Feb 2021 08:25:14 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F8D3A4062;
        Wed, 24 Feb 2021 08:25:13 +0000 (GMT)
Received: from bharata.ibmuc.com (unknown [9.199.40.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 24 Feb 2021 08:25:12 +0000 (GMT)
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     aneesh.kumar@linux.ibm.com, npiggin@gmail.com, paulus@ozlabs.org,
        mpe@ellerman.id.au, david@gibson.dropbear.id.au,
        farosas@linux.ibm.com, Bharata B Rao <bharata@linux.ibm.com>
Subject: [PATCH v5 0/3] Support for H_RPT_INVALIDATE in PowerPC KVM
Date:   Wed, 24 Feb 2021 13:55:07 +0530
Message-Id: <20210224082510.3962423-1-bharata@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-24_02:2021-02-23,2021-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=764 malwarescore=0 impostorscore=0
 mlxscore=0 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102240062
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This patchset adds support for the new hcall H_RPT_INVALIDATE
and replaces the nested tlb flush calls with this new hcall
if support for the same exists.

Changes in v5:
-------------
- Included the h_rpt_invalidate page size information within
  mmu_pszie_defs[] as per David Gibson's suggestion.
- Redid nested exit changes as per Paul Mackerras' suggestion.
- Folded the patch that added tlbie primitives into the
  hcall implementation patch.

v4: https://lore.kernel.org/linuxppc-dev/20210215063542.3642366-1-bharata@linux.ibm.com/T/#t

Bharata B Rao (3):
  powerpc/book3s64/radix: Add H_RPT_INVALIDATE pgsize encodings to
    mmu_psize_def
  KVM: PPC: Book3S HV: Add support for H_RPT_INVALIDATE
  KVM: PPC: Book3S HV: Use H_RPT_INVALIDATE in nested KVM

 Documentation/virt/kvm/api.rst                |  18 +++
 arch/powerpc/include/asm/book3s/64/mmu.h      |   1 +
 .../include/asm/book3s/64/tlbflush-radix.h    |   4 +
 arch/powerpc/include/asm/kvm_book3s.h         |   3 +
 arch/powerpc/include/asm/mmu_context.h        |  11 ++
 arch/powerpc/kvm/book3s_64_mmu_radix.c        |  27 +++-
 arch/powerpc/kvm/book3s_hv.c                  |  90 +++++++++++
 arch/powerpc/kvm/book3s_hv_nested.c           |  89 ++++++++++-
 arch/powerpc/kvm/powerpc.c                    |   3 +
 arch/powerpc/mm/book3s64/radix_pgtable.c      |   5 +
 arch/powerpc/mm/book3s64/radix_tlb.c          | 147 +++++++++++++++++-
 include/uapi/linux/kvm.h                      |   1 +
 12 files changed, 388 insertions(+), 11 deletions(-)

-- 
2.26.2

