Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A2C213D4B
	for <lists+kvm-ppc@lfdr.de>; Fri,  3 Jul 2020 18:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgGCQI1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 3 Jul 2020 12:08:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54824 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726236AbgGCQI1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 3 Jul 2020 12:08:27 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 063G53N1062422;
        Fri, 3 Jul 2020 12:08:15 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3224f162f3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 12:08:15 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 063Fsr7e028220;
        Fri, 3 Jul 2020 15:59:19 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 31wwr83gt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 15:59:19 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 063FxGSv55771310
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jul 2020 15:59:16 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65FD04203F;
        Fri,  3 Jul 2020 15:59:16 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05CEA42042;
        Fri,  3 Jul 2020 15:59:16 +0000 (GMT)
Received: from pomme.tlslab.ibm.com (unknown [9.145.68.59])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jul 2020 15:59:15 +0000 (GMT)
From:   Laurent Dufour <ldufour@linux.ibm.com>
To:     linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au, paulus@samba.org
Cc:     bharata@linux.ibm.com, bauerman@linux.ibm.com,
        sukadev@linux.ibm.com, sathnaga@linux.vnet.ibm.com
Subject: [PATCH 0/2] Rework secure memslot dropping
Date:   Fri,  3 Jul 2020 17:59:12 +0200
Message-Id: <20200703155914.40262-1-ldufour@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-03_13:2020-07-02,2020-07-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=409 suspectscore=0 phishscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 malwarescore=0 spamscore=0
 cotscore=-2147483648 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007030110
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
"PATCH v3 0/4] Migrate non-migrated pages of a SVM."
https://lore.kernel.org/linuxppc-dev/1592606622-29884-1-git-send-email-linuxram@us.ibm.com/#r

Laurent Dufour (2):
  KVM: PPC: Book3S HV: move kvmppc_svm_page_out up
  KVM: PPC: Book3S HV: rework secure mem slot dropping

 arch/powerpc/kvm/book3s_hv_uvmem.c | 220 +++++++++++++++++------------
 1 file changed, 127 insertions(+), 93 deletions(-)

-- 
2.27.0

