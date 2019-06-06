Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08DE237B2A
	for <lists+kvm-ppc@lfdr.de>; Thu,  6 Jun 2019 19:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbfFFRg1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 6 Jun 2019 13:36:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46418 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726863AbfFFRgZ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 6 Jun 2019 13:36:25 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56HTsRk018879
        for <kvm-ppc@vger.kernel.org>; Thu, 6 Jun 2019 13:36:24 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sy5c8ebtw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Thu, 06 Jun 2019 13:36:24 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <cclaudio@linux.ibm.com>;
        Thu, 6 Jun 2019 18:36:23 +0100
Received: from b01cxnp22034.gho.pok.ibm.com (9.57.198.24)
        by e11.ny.us.ibm.com (146.89.104.198) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Jun 2019 18:36:20 +0100
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x56HaJP323527908
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jun 2019 17:36:19 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0FF6AC05F;
        Thu,  6 Jun 2019 17:36:18 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3181DAC05B;
        Thu,  6 Jun 2019 17:36:17 +0000 (GMT)
Received: from rino.br.ibm.com (unknown [9.18.235.79])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu,  6 Jun 2019 17:36:17 +0000 (GMT)
From:   Claudio Carvalho <cclaudio@linux.ibm.com>
To:     linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauermann@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Claudio Carvalho <cclaudio@linux.ibm.com>
Subject: [PATCH v3 1/9] KVM: PPC: Ultravisor: Add PPC_UV config option
Date:   Thu,  6 Jun 2019 14:36:06 -0300
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190606173614.32090-1-cclaudio@linux.ibm.com>
References: <20190606173614.32090-1-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19060617-2213-0000-0000-0000039B1897
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011224; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01214150; UDB=6.00638204; IPR=6.00995229;
 MB=3.00027209; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-06 17:36:21
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060617-2214-0000-0000-00005EBEA878
Message-Id: <20190606173614.32090-2-cclaudio@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=972 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060117
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Anshuman Khandual <khandual@linux.vnet.ibm.com>

CONFIG_PPC_UV adds support for ultravisor.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
[Update config help and commit message]
Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
---
 arch/powerpc/Kconfig | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 8c1c636308c8..276c1857c335 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -439,6 +439,26 @@ config PPC_TRANSACTIONAL_MEM
        ---help---
          Support user-mode Transactional Memory on POWERPC.
 
+config PPC_UV
+	bool "Ultravisor support"
+	depends on KVM_BOOK3S_HV_POSSIBLE
+	select HMM_MIRROR
+	select HMM
+	select ZONE_DEVICE
+	select MIGRATE_VMA_HELPER
+	select DEV_PAGEMAP_OPS
+	select DEVICE_PRIVATE
+	select MEMORY_HOTPLUG
+	select MEMORY_HOTREMOVE
+	default n
+	help
+	  This option paravirtualizes the kernel to run in POWER platforms that
+	  supports the Protected Execution Facility (PEF). In such platforms,
+	  the ultravisor firmware runs at a privilege level above the
+	  hypervisor.
+
+	  If unsure, say "N".
+
 config LD_HEAD_STUB_CATCH
 	bool "Reserve 256 bytes to cope with linker stubs in HEAD text" if EXPERT
 	depends on PPC64
-- 
2.20.1

