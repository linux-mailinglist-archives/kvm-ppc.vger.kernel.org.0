Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1480227D52
	for <lists+kvm-ppc@lfdr.de>; Tue, 21 Jul 2020 12:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgGUKma (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 21 Jul 2020 06:42:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51930 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726127AbgGUKma (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 21 Jul 2020 06:42:30 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06LAZcQN013846;
        Tue, 21 Jul 2020 06:42:09 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32dn0v76uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 06:42:09 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06LAYpvJ028918;
        Tue, 21 Jul 2020 10:42:07 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 32dbmn0hv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 10:42:07 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06LAg4x029360598
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jul 2020 10:42:04 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D00994C050;
        Tue, 21 Jul 2020 10:42:04 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72E204C04E;
        Tue, 21 Jul 2020 10:42:04 +0000 (GMT)
Received: from pomme.tlslab.ibm.com (unknown [9.145.36.105])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jul 2020 10:42:04 +0000 (GMT)
From:   Laurent Dufour <ldufour@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org
Cc:     linuxram@us.ibm.com, sukadev@linux.ibm.com, bauerman@linux.ibm.com,
        bharata@linux.ibm.com
Subject: [PATCH v2 0/2] Rework secure memslot dropping
Date:   Tue, 21 Jul 2020 12:42:00 +0200
Message-Id: <20200721104202.15727-1-ldufour@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-21_03:2020-07-21,2020-07-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=527 spamscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 phishscore=0 adultscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007210075
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

When doing memory hotplug on a secure VM, the secure pages are not well
cleaned from the secure device when dropping the memslot.  This silent
error, is then preventing the SVM to reboot properly after the following
sequence of commands are run in the Qemu monitor:

device_add pc-dimm,id=dimm1,memdev=mem1
device_del dimm1
device_add pc-dimm,id=dimm1,memdev=mem1

At reboot time, when the kernel is booting again and switching to the
secure mode, the page_in is failing for the pages in the memslot because
the cleanup was not done properly, because the memslot is flagged as
invalid during the hot unplug and thus the page fault mechanism is not
triggered.

To prevent that during the memslot dropping, instead of belonging on the
page fault mechanism to trigger the page out of the secured pages, it seems
simpler to directly call the function doing the page out. This way the
state of the memslot is not interfering on the page out process.

This series applies on top of the Ram's one titled:
"[v4 0/5] Migrate non-migrated pages of a SVM."
https://lore.kernel.org/linuxppc-dev/1594972827-13928-1-git-send-email-linuxram@us.ibm.com/

Changes since V1:
 - Rebase on top of Ram's V4 series
 - Address Bharata's comment to use mmap_read_*lock().

Laurent Dufour (2):
  KVM: PPC: Book3S HV: move kvmppc_svm_page_out up
  KVM: PPC: Book3S HV: rework secure mem slot dropping

 arch/powerpc/kvm/book3s_hv_uvmem.c | 220 +++++++++++++++++------------
 1 file changed, 127 insertions(+), 93 deletions(-)

-- 
2.27.0

