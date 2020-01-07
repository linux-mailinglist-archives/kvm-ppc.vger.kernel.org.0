Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2186131D64
	for <lists+kvm-ppc@lfdr.de>; Tue,  7 Jan 2020 03:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbgAGCCv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 6 Jan 2020 21:02:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15770 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727250AbgAGCCv (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 6 Jan 2020 21:02:51 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 007226oO134646;
        Mon, 6 Jan 2020 21:02:41 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xb8s86myt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jan 2020 21:02:41 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 00721PEa014553;
        Tue, 7 Jan 2020 02:02:40 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04dal.us.ibm.com with ESMTP id 2xajb6d09r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jan 2020 02:02:40 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00722dOK54985126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Jan 2020 02:02:39 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3285A6E04C;
        Tue,  7 Jan 2020 02:02:39 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F9286E04E;
        Tue,  7 Jan 2020 02:02:38 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.70.94.45])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  7 Jan 2020 02:02:38 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 64C672E0EE6; Mon,  6 Jan 2020 18:02:37 -0800 (PST)
Date:   Mon, 6 Jan 2020 18:02:37 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>, bharata@linux.ibm.com,
        linuxppc-dev@ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v4 2/2] KVM: PPC: Implement H_SVM_INIT_ABORT hcall
Message-ID: <20200107020237.GA29843@us.ibm.com>
References: <20191219215146.27278-1-sukadev@linux.ibm.com>
 <20191219215146.27278-2-sukadev@linux.ibm.com>
 <20200103203712.GG5556@oc0525413822.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200103203712.GG5556@oc0525413822.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.10.1 (2018-07-13)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2020-01-06_08:2020-01-06,2020-01-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001070014
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Ram Pai [linuxram@us.ibm.com] wrote:
>
> One small comment.. H_STATE is a better return code than H_UNSUPPORTED.
> 

Here is the updated patch - we now return H_STATE if the abort call is
made after the VM has gone secure.
---
From 73fe1fa5aff2829f2fae6a339169e56dc0bbae06 Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Date: Fri, 27 Sep 2019 14:30:36 -0500
Subject: [PATCH 2/2] KVM: PPC: Implement H_SVM_INIT_ABORT hcall

Implement the H_SVM_INIT_ABORT hcall which the Ultravisor can use to
abort an SVM after it has issued the H_SVM_INIT_START and before the
H_SVM_INIT_DONE hcalls. This hcall could be used when Ultravisor
encounters security violations or other errors when starting an SVM.

Note that this hcall is different from UV_SVM_TERMINATE ucall which
is used by HV to terminate/cleanup an VM that has becore secure.

The H_SVM_INIT_ABORT should basically undo operations that were done
since the H_SVM_INIT_START hcall - i.e page-out all the VM pages back
to normal memory, and terminate the SVM.

(If we do not bring the pages back to normal memory, the text/data
of the VM would be stuck in secure memory and since the SVM did not
go secure, its MSR_S bit will be clear and the VM wont be able to
access its pages even to do a clean exit).

Based on patches and discussion with Paul Mackerras, Ram Pai and
Bharata Rao.

Signed-off-by: Ram Pai <linuxram@linux.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
---
Changelog[v4]:
	- [Bharata Rao] Add missing rcu locking
	- [Paul Mackerras] simplify code that walks memslots
	- Add a check to ensure that H_SVM_INIT_ABORT is called before
	  H_SVM_INIT_DONE hcall (i.e the SVM is not already secure).
	- [Ram Pai] Return H_STATE if hcall is called after *INIT_DONE.

Changelog[v3]:
	- Rather than pass the NIP/MSR as parameters, load them into
	  SRR0/SRR1 (like we do with other registers) and terminate
	  the VM after paging out pages
	- Move the code to add a skip_page_out parameter into a
	  separate patch.

Changelog[v2]:
	[Paul Mackerras] avoid returning to UV "one last time" after
	the state is cleaned up.  So, we now have H_SVM_INIT_ABORT:
	- take the VM's NIP/MSR register states as parameters
	- inherit the state of other registers as at UV_ESM call.
	After cleaning up the partial state, HV uses these to return
	directly to the VM with a failed UV_ESM call.
---
 Documentation/powerpc/ultravisor.rst        | 60 +++++++++++++++++++++
 arch/powerpc/include/asm/hvcall.h           |  1 +
 arch/powerpc/include/asm/kvm_book3s_uvmem.h |  6 +++
 arch/powerpc/include/asm/kvm_host.h         |  1 +
 arch/powerpc/kvm/book3s_hv.c                |  3 ++
 arch/powerpc/kvm/book3s_hv_uvmem.c          | 28 ++++++++++
 6 files changed, 99 insertions(+)

diff --git a/Documentation/powerpc/ultravisor.rst b/Documentation/powerpc/ultravisor.rst
index 730854f73830..363736d7fd36 100644
--- a/Documentation/powerpc/ultravisor.rst
+++ b/Documentation/powerpc/ultravisor.rst
@@ -948,6 +948,66 @@ Use cases
     up its internal state for this virtual machine.
 
 
+H_SVM_INIT_ABORT
+----------------
+
+    Abort the process of securing an SVM.
+
+Syntax
+~~~~~~
+
+.. code-block:: c
+
+	uint64_t hypercall(const uint64_t H_SVM_INIT_ABORT)
+
+Return values
+~~~~~~~~~~~~~
+
+    One of the following values:
+
+	* H_PARAMETER 		on successfully cleaning up the state,
+				Hypervisor will return this value to the
+				**guest**, to indicate that the underlying
+				UV_ESM ultracall failed.
+
+	* H_STATE		if called after a VM has gone secure (i.e
+				H_SVM_INIT_DONE hypercall was successful).
+
+	* H_UNSUPPORTED		if called from a wrong context (e.g. from a
+				normal VM).
+
+Description
+~~~~~~~~~~~
+
+    Abort the process of securing a virtual machine. This call must
+    be made after a prior call to ``H_SVM_INIT_START`` hypercall and
+    before a call to ``H_SVM_INIT_DONE``.
+
+    On entry into this hypercall the non-volatile GPRs and FPRs are
+    expected to contain the values they had at the time the VM issued
+    the UV_ESM ultracall. Further ``SRR0`` is expected to contain the
+    address of the instruction after the ``UV_ESM`` ultracall and ``SRR1``
+    the MSR value with which to return to the VM.
+
+    This hypercall will cleanup any partial state that was established for
+    the VM since the prior ``H_SVM_INIT_START`` hypercall, including paging
+    out pages that were paged-into secure memory, and issue the
+    ``UV_SVM_TERMINATE`` ultracall to terminate the VM.
+
+    After the partial state is cleaned up, control returns to the VM
+    (**not Ultravisor**), at the address specified in ``SRR0`` with the
+    MSR values set to the value in ``SRR1``.
+
+Use cases
+~~~~~~~~~
+
+    If after a successful call to ``H_SVM_INIT_START``, the Ultravisor
+    encounters an error while securing a virtual machine, either due
+    to lack of resources or because the VM's security information could
+    not be validated, Ultravisor informs the Hypervisor about it.
+    Hypervisor should use this call to clean up any internal state for
+    this virtual machine and return to the VM.
+
 H_SVM_PAGE_IN
 -------------
 
diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
index 13bd870609c3..e90c073e437e 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -350,6 +350,7 @@
 #define H_SVM_PAGE_OUT		0xEF04
 #define H_SVM_INIT_START	0xEF08
 #define H_SVM_INIT_DONE		0xEF0C
+#define H_SVM_INIT_ABORT	0xEF14
 
 /* Values for 2nd argument to H_SET_MODE */
 #define H_SET_MODE_RESOURCE_SET_CIABR		1
diff --git a/arch/powerpc/include/asm/kvm_book3s_uvmem.h b/arch/powerpc/include/asm/kvm_book3s_uvmem.h
index 3cf8425b9838..5a9834e0e2d1 100644
--- a/arch/powerpc/include/asm/kvm_book3s_uvmem.h
+++ b/arch/powerpc/include/asm/kvm_book3s_uvmem.h
@@ -19,6 +19,7 @@ unsigned long kvmppc_h_svm_page_out(struct kvm *kvm,
 unsigned long kvmppc_h_svm_init_start(struct kvm *kvm);
 unsigned long kvmppc_h_svm_init_done(struct kvm *kvm);
 int kvmppc_send_page_to_uv(struct kvm *kvm, unsigned long gfn);
+unsigned long kvmppc_h_svm_init_abort(struct kvm *kvm);
 void kvmppc_uvmem_drop_pages(const struct kvm_memory_slot *free,
 			     struct kvm *kvm, bool skip_page_out);
 #else
@@ -62,6 +63,11 @@ static inline unsigned long kvmppc_h_svm_init_done(struct kvm *kvm)
 	return H_UNSUPPORTED;
 }
 
+static inline unsigned long kvmppc_h_svm_init_abort(struct kvm *kvm)
+{
+	return H_UNSUPPORTED;
+}
+
 static inline int kvmppc_send_page_to_uv(struct kvm *kvm, unsigned long gfn)
 {
 	return -EFAULT;
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 577ca95fac7c..8310c0407383 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -278,6 +278,7 @@ struct kvm_resize_hpt;
 /* Flag values for kvm_arch.secure_guest */
 #define KVMPPC_SECURE_INIT_START 0x1 /* H_SVM_INIT_START has been called */
 #define KVMPPC_SECURE_INIT_DONE  0x2 /* H_SVM_INIT_DONE completed */
+#define KVMPPC_SECURE_INIT_ABORT 0x4 /* H_SVM_INIT_ABORT issued */
 
 struct kvm_arch {
 	unsigned int lpid;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 66d5312be16b..1b22f2c7ad1b 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1099,6 +1099,9 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 	case H_SVM_INIT_DONE:
 		ret = kvmppc_h_svm_init_done(vcpu->kvm);
 		break;
+	case H_SVM_INIT_ABORT:
+		ret = kvmppc_h_svm_init_abort(vcpu->kvm);
+		break;
 
 	default:
 		return RESUME_HOST;
diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 9a5bbad7d87e..522b57be0d45 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -287,6 +287,34 @@ void kvmppc_uvmem_drop_pages(const struct kvm_memory_slot *free,
 	}
 }
 
+unsigned long kvmppc_h_svm_init_abort(struct kvm *kvm)
+{
+	int srcu_idx;
+	struct kvm_memory_slot *memslot;
+
+	/*
+	 * Expect to be called only after INIT_START and before INIT_DONE.
+	 * If INIT_DONE was completed, use normal VM termination sequence.
+	 */
+	if (!(kvm->arch.secure_guest & KVMPPC_SECURE_INIT_START))
+		return H_UNSUPPORTED;
+
+	if (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE)
+		return H_STATE;
+
+	srcu_idx = srcu_read_lock(&kvm->srcu);
+
+	kvm_for_each_memslot(memslot, kvm_memslots(kvm))
+		kvmppc_uvmem_drop_pages(memslot, kvm, false);
+
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+
+	kvm->arch.secure_guest = 0;
+	uv_svm_terminate(kvm->arch.lpid);
+
+	return H_PARAMETER;
+}
+
 /*
  * Get a free device PFN from the pool
  *
-- 
2.17.2

