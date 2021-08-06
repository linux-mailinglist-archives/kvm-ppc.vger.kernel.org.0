Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C423E2BD5
	for <lists+kvm-ppc@lfdr.de>; Fri,  6 Aug 2021 15:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344410AbhHFNpn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 6 Aug 2021 09:45:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62696 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1344329AbhHFNpm (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 6 Aug 2021 09:45:42 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 176DWnCr044328;
        Fri, 6 Aug 2021 09:45:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=uVWQ22JxyyRCMnyzhTFX72gZ9oDJeNKqCp5Zt9oGekM=;
 b=G56m7B8SasXlncs6UMD0lYp+WP/hIeRtUEaaldst0s5DqTyhWUjKFw6HgRY4dTOfg/Jt
 IUTT3We16s+eM119db3ZvdaKRjDITezgCBFjFP9KZkuDyKC3ZXoSQ36YbUtvmck76Ixh
 /vUefE8h2TAnK8KbN0ZSIxi/O77i1FPNeX3qCan0xOf7EnLv29VhRvg0U6jh79pT6NKX
 CgtgOk7ktN9dvTJlDO4fJbzGwI2T1Iaofn5p1B5Zbyh/Lm5s5KTelP33DxQOoq2fBJP/
 GBxUXrcB4L8BQBQp0IVZz95/ABbFwOCS+se1uy0pRCED8INGrMkowijg9uMyG8mUvkrH lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a859e5cyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 09:45:15 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 176DWsYO044966;
        Fri, 6 Aug 2021 09:45:15 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a859e5cyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 09:45:15 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 176DcICU007969;
        Fri, 6 Aug 2021 13:45:14 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma05wdc.us.ibm.com with ESMTP id 3a8mq9qvet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 13:45:14 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 176DjDG337290354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Aug 2021 13:45:13 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1876BE06F;
        Fri,  6 Aug 2021 13:45:12 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76EC7BE056;
        Fri,  6 Aug 2021 13:45:11 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.211.46.8])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  6 Aug 2021 13:45:11 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com
Subject: [PATCH v6 0/2] KVM: PPC: Book3S HV: Nested guest state sanitising changes
Date:   Fri,  6 Aug 2021 10:45:04 -0300
Message-Id: <20210806134506.2649735-1-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aQNTtt5JB4Ehu5R14HDpBBOPW5Kbk_Wa
X-Proofpoint-ORIG-GUID: GumLVMZ166Im7ICaUNTwQ1F7qHkQqAw6
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-06_04:2021-08-05,2021-08-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=774
 clxscore=1015 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0
 mlxscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060094
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This series aims to stop contaminating the l2_hv structure with bits
that might have come from L1 state.

Patch 1 makes l2_hv read-only (mostly). It is now only changed when we
explicitly want to pass information to L1.

Patch 2 makes sure that L1 is not forwarded HFU interrupts when the
host has decided to disable any facilities (theoretical for now, since
HFSCR bits are always the same between L1/Ln).

Changes since v5:

- patch 2 now reads the instruction earlier at the nested exit handler
  to allow the guest to retry if the load fails.

v5:

- moved setting of the Cause bits under BOOK3S_INTERRUPT_H_FAC_UNAVAIL.

https://lkml.kernel.org/r/20210726201710.2432874-1-farosas@linux.ibm.com

v4:

- now passing lpcr separately into load_l2_hv_regs to solve the
  conflict with commit a19b70abc69a ("KVM: PPC: Book3S HV: Nested move
  LPCR sanitising to sanitise_hv_regs");

- patch 2 now forwards a HEAI instead of injecting a Program.

https://lkml.kernel.org/r/20210722221240.2384655-1-farosas@linux.ibm.com

v3:

- removed the sanitise functions;
- moved the entry code into a new load_l2_hv_regs and the exit code
  into the existing save_hv_return_state;
- new patch: removes the cause bits when L0 has disabled the
  corresponding facility.

https://lkml.kernel.org/r/20210415230948.3563415-1-farosas@linux.ibm.com

v2:

- made the change more generic, not only applies to hfscr anymore;
- sanitisation is now done directly on the vcpu struct, l2_hv is left
  unchanged.

https://lkml.kernel.org/r/20210406214645.3315819-1-farosas@linux.ibm.com

v1:
https://lkml.kernel.org/r/20210305231055.2913892-1-farosas@linux.ibm.com

Fabiano Rosas (2):
  KVM: PPC: Book3S HV: Sanitise vcpu registers in nested path
  KVM: PPC: Book3S HV: Stop forwarding all HFUs to L1

 arch/powerpc/kvm/book3s_hv.c        |  13 ++++
 arch/powerpc/kvm/book3s_hv_nested.c | 117 ++++++++++++++++------------
 2 files changed, 79 insertions(+), 51 deletions(-)

-- 
2.29.2

