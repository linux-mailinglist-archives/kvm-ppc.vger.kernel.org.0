Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224EE3D67FE
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 22:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhGZThC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 26 Jul 2021 15:37:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11350 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229646AbhGZThB (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 26 Jul 2021 15:37:01 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16QK6ZOc184140;
        Mon, 26 Jul 2021 16:17:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=THLNBzErXmgvcbqtLURu006pI/FzQrcVNE1dOLEUfAE=;
 b=XhfRAlWCYZpox65fq75KYgxgXC1w9fGH6Jp6SIJ4bYgH9KgZgDYJOVOiF15iaiCtkuh/
 iiKtBqZF3pU9Zw3XoaimzW5kufiJi3Eh+yyHg/jQJtD8du/6diErthoS+tW0d/bV+kPK
 M8DlLdDODMShu9VdyVuw11ALq2SzgzCZ28B+5hnnr8w4425eQPL5I/Qfr5SlSe9vxc97
 mgtxF6O85JtI5a+pcxSDyJKodHp5cJNDB+hSXrNXzhe0oZwb7KmqKAOvPgJ59P/uIvHY
 9leDhqBNutZ1VReYEEq4W67oqtpYMCp0dXhd9tNIkDqE6GH/n4qEAzlePwK+l8wDhz+6 tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a23t0890b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jul 2021 16:17:18 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16QK6sRN184896;
        Mon, 26 Jul 2021 16:17:17 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a23t088yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jul 2021 16:17:17 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16QKCQf8028284;
        Mon, 26 Jul 2021 20:17:17 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02wdc.us.ibm.com with ESMTP id 3a235jhdce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jul 2021 20:17:16 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16QKHGHR38076742
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 20:17:16 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03EC9BE059;
        Mon, 26 Jul 2021 20:17:16 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89ADABE058;
        Mon, 26 Jul 2021 20:17:14 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.211.57.103])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 26 Jul 2021 20:17:14 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com
Subject: [PATCH v5 0/2] KVM: PPC: Book3S HV: Nested guest state sanitising changes
Date:   Mon, 26 Jul 2021 17:17:08 -0300
Message-Id: <20210726201710.2432874-1-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8csxEGbE7O05fx4jWBHVob81gNMFITiQ
X-Proofpoint-ORIG-GUID: Ma7cv6T0a1XBI6sNPHKTiMQ91jeoXY-2
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-26_14:2021-07-26,2021-07-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=818
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107260118
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

Changes since v4:
- moved setting of the Cause bits under BOOK3S_INTERRUPT_H_FAC_UNAVAIL.

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

 arch/powerpc/kvm/book3s_hv_nested.c | 118 ++++++++++++++++------------
 1 file changed, 68 insertions(+), 50 deletions(-)

-- 
2.29.2

