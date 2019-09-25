Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB146BD790
	for <lists+kvm-ppc@lfdr.de>; Wed, 25 Sep 2019 07:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442283AbfIYFHF (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 25 Sep 2019 01:07:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44564 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437141AbfIYFHF (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 25 Sep 2019 01:07:05 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8P52iuG118409
        for <kvm-ppc@vger.kernel.org>; Wed, 25 Sep 2019 01:07:04 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v7mfqb5g3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Wed, 25 Sep 2019 01:07:04 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Wed, 25 Sep 2019 06:07:01 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 25 Sep 2019 06:06:58 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8P56uRu33292520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 05:06:56 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54F52A4053;
        Wed, 25 Sep 2019 05:06:56 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB66BA404D;
        Wed, 25 Sep 2019 05:06:53 +0000 (GMT)
Received: from bharata.ibmuc.com (unknown [9.199.52.56])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 25 Sep 2019 05:06:53 +0000 (GMT)
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com, hch@lst.de,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Subject: [PATCH v9 1/8] KVM: PPC: Book3S HV: Define usage types for rmap array in guest memslot
Date:   Wed, 25 Sep 2019 10:36:42 +0530
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190925050649.14926-1-bharata@linux.ibm.com>
References: <20190925050649.14926-1-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19092505-0028-0000-0000-000003A22EF9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19092505-0029-0000-0000-000024644708
Message-Id: <20190925050649.14926-2-bharata@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-25_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909250050
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

The rmap array in the guest memslot is an array of size number of guest
pages, allocated at memslot creation time. Each rmap entry in this array
is used to store information about the guest page to which it
corresponds. For example for a hpt guest it is used to store a lock bit,
rc bits, a present bit and the index of a hpt entry in the guest hpt
which maps this page. For a radix guest which is running nested guests
it is used to store a pointer to a linked list of nested rmap entries
which store the nested guest physical address which maps this guest
address and for which there is a pte in the shadow page table.

As there are currently two uses for the rmap array, and the potential
for this to expand to more in the future, define a type field (being the
top 8 bits of the rmap entry) to be used to define the type of the rmap
entry which is currently present and define two values for this field
for the two current uses of the rmap array.

Since the nested case uses the rmap entry to store a pointer, define
this type as having the two high bits set as is expected for a pointer.
Define the hpt entry type as having bit 56 set (bit 7 IBM bit ordering).

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
		[Added rmap type KVMPPC_RMAP_UVMEM_PFN]
Reviewed-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 arch/powerpc/include/asm/kvm_host.h | 28 ++++++++++++++++++++++++----
 arch/powerpc/kvm/book3s_hv_rm_mmu.c |  2 +-
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 4bb552d639b8..81cd221ccc04 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -232,11 +232,31 @@ struct revmap_entry {
 };
 
 /*
- * We use the top bit of each memslot->arch.rmap entry as a lock bit,
- * and bit 32 as a present flag.  The bottom 32 bits are the
- * index in the guest HPT of a HPTE that points to the page.
+ * The rmap array of size number of guest pages is allocated for each memslot.
+ * This array is used to store usage specific information about the guest page.
+ * Below are the encodings of the various possible usage types.
  */
-#define KVMPPC_RMAP_LOCK_BIT	63
+/* Free bits which can be used to define a new usage */
+#define KVMPPC_RMAP_TYPE_MASK	0xff00000000000000
+#define KVMPPC_RMAP_NESTED	0xc000000000000000	/* Nested rmap array */
+#define KVMPPC_RMAP_HPT		0x0100000000000000	/* HPT guest */
+#define KVMPPC_RMAP_UVMEM_PFN	0x0200000000000000	/* Secure GPA */
+
+static inline unsigned long kvmppc_rmap_type(unsigned long *rmap)
+{
+	return (*rmap & KVMPPC_RMAP_TYPE_MASK);
+}
+
+/*
+ * rmap usage definition for a hash page table (hpt) guest:
+ * 0x0000080000000000	Lock bit
+ * 0x0000018000000000	RC bits
+ * 0x0000000100000000	Present bit
+ * 0x00000000ffffffff	HPT index bits
+ * The bottom 32 bits are the index in the guest HPT of a HPTE that points to
+ * the page.
+ */
+#define KVMPPC_RMAP_LOCK_BIT	43
 #define KVMPPC_RMAP_RC_SHIFT	32
 #define KVMPPC_RMAP_REFERENCED	(HPTE_R_R << KVMPPC_RMAP_RC_SHIFT)
 #define KVMPPC_RMAP_PRESENT	0x100000000ul
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 63e0ce91e29d..7186c65c61c9 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -99,7 +99,7 @@ void kvmppc_add_revmap_chain(struct kvm *kvm, struct revmap_entry *rev,
 	} else {
 		rev->forw = rev->back = pte_index;
 		*rmap = (*rmap & ~KVMPPC_RMAP_INDEX) |
-			pte_index | KVMPPC_RMAP_PRESENT;
+			pte_index | KVMPPC_RMAP_PRESENT | KVMPPC_RMAP_HPT;
 	}
 	unlock_rmap(rmap);
 }
-- 
2.21.0

