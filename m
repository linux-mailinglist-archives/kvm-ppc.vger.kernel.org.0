Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6794C18CB93
	for <lists+kvm-ppc@lfdr.de>; Fri, 20 Mar 2020 11:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgCTK04 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 20 Mar 2020 06:26:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15412 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727178AbgCTK0z (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 20 Mar 2020 06:26:55 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02KA4Kmp185151
        for <kvm-ppc@vger.kernel.org>; Fri, 20 Mar 2020 06:26:54 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yu7aed6au-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Fri, 20 Mar 2020 06:26:53 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <ldufour@linux.ibm.com>;
        Fri, 20 Mar 2020 10:26:52 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 20 Mar 2020 10:26:48 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02KAQkZ956295592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Mar 2020 10:26:46 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4A12A405F;
        Fri, 20 Mar 2020 10:26:46 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56612A405B;
        Fri, 20 Mar 2020 10:26:46 +0000 (GMT)
Received: from pomme.tlslab.ibm.com (unknown [9.145.123.35])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 Mar 2020 10:26:46 +0000 (GMT)
From:   Laurent Dufour <ldufour@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc:     Bharata B Rao <bharata@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 2/2] KVM: PPC: Book3S HV: H_SVM_INIT_START must call UV_RETURN
Date:   Fri, 20 Mar 2020 11:26:43 +0100
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200320102643.15516-1-ldufour@linux.ibm.com>
References: <20200320102643.15516-1-ldufour@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20032010-0016-0000-0000-000002F46A89
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032010-0017-0000-0000-00003357F8D0
Message-Id: <20200320102643.15516-3-ldufour@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-20_02:2020-03-19,2020-03-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=2 clxscore=1015 adultscore=0 spamscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=851 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003200042
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

When the call to UV_REGISTER_MEM_SLOT is failing, for instance because
there is not enough free secured memory, the Hypervisor (HV) has to call
UV_RETURN to report the error to the Ultravisor (UV). Then the UV will call
H_SVM_INIT_ABORT to abort the securing phase and go back to the calling VM.

If the kvm->arch.secure_guest is not set, in the return path rfid is called
but there is no valid context to get back to the SVM since the Hcall has
been routed by the Ultravisor.

Move the setting of kvm->arch.secure_guest earlier in
kvmppc_h_svm_init_start() so in the return path, UV_RETURN will be called
instead of rfid.

Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 79b1202b1c62..68dff151315c 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -209,6 +209,8 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
 	int ret = H_SUCCESS;
 	int srcu_idx;
 
+	kvm->arch.secure_guest = KVMPPC_SECURE_INIT_START;
+
 	if (!kvmppc_uvmem_bitmap)
 		return H_UNSUPPORTED;
 
@@ -233,7 +235,6 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
 			goto out;
 		}
 	}
-	kvm->arch.secure_guest |= KVMPPC_SECURE_INIT_START;
 out:
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 	return ret;
-- 
2.25.2

