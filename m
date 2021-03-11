Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90B9336DF9
	for <lists+kvm-ppc@lfdr.de>; Thu, 11 Mar 2021 09:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhCKIkK (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 11 Mar 2021 03:40:10 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54128 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231394AbhCKIkK (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 11 Mar 2021 03:40:10 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12B8Xke7135030;
        Thu, 11 Mar 2021 03:40:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=odvhrIjhuqtsSsHjBS70A6/4Y51QX/ExUUXrsPYIzTE=;
 b=aiS5D5xH22013pPNhTRNhhNu7i6GZ1ibzCkAq6o0CK6F/0V2XtOfFssWj/JH7D1Xx+fM
 ceG6XPqz1Sn5FxL6oPzq+n5j9tJRV9K48LSlzf48OMw63erkXGRmn3sDxiczAbjG6sqL
 pngPa2iz30KFIjtIlry4x4BjtibzBBLNOmHWiPu11S591R19QmfRRdGs83p3UC5BLvFC
 JwxxFLUATsK3cCedQMxt6UDYGQveAWRzRNviUeJf1oimhaW3/AUXtBUaDmHjs67gykE/
 CEIz/WmGJt6kjyIuNtZVRdG9y37naOtVRHK2STjs+BOeiVeooxhVotYfUeIaN/HfCFF6 KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3774m0fvnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 03:40:03 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12B8YBwd135989;
        Thu, 11 Mar 2021 03:40:02 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3774m0fvkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 03:39:59 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12B8XNsH028376;
        Thu, 11 Mar 2021 08:39:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3768ursqx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 08:39:58 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12B8ddds31326706
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Mar 2021 08:39:39 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3405D5204F;
        Thu, 11 Mar 2021 08:39:55 +0000 (GMT)
Received: from bharata.ibmuc.com (unknown [9.77.205.2])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8434352052;
        Thu, 11 Mar 2021 08:39:53 +0000 (GMT)
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     aneesh.kumar@linux.ibm.com, npiggin@gmail.com, paulus@ozlabs.org,
        mpe@ellerman.id.au, david@gibson.dropbear.id.au,
        farosas@linux.ibm.com, Bharata B Rao <bharata@linux.ibm.com>
Subject: [PATCH v6 4/6] KVM: PPC: Book3S HV: Nested support in H_RPT_INVALIDATE
Date:   Thu, 11 Mar 2021 14:09:37 +0530
Message-Id: <20210311083939.595568-5-bharata@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210311083939.595568-1-bharata@linux.ibm.com>
References: <20210311083939.595568-1-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-11_02:2021-03-10,2021-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 phishscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103110047
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Enable support for process-scoped invalidations from nested
guests and partition-scoped invalidations for nested guests.

Process-scoped invalidations for any level of nested guests
are handled by implementing H_RPT_INVALIDATE handler in the
nested guest exit path in L0.

Partition-scoped invalidation requests are forwarded to the
right nested guest, handled there and passed down to L0
for eventual handling.

Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
	[Nested guest partition-scoped invalidation changes]
---
 arch/powerpc/include/asm/kvm_book3s.h |   3 +
 arch/powerpc/kvm/book3s_hv.c          |  71 +++++++++++++++++-
 arch/powerpc/kvm/book3s_hv_nested.c   | 104 ++++++++++++++++++++++++++
 3 files changed, 175 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index 2f5f919f6cd3..de8fc5a4d19c 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -305,6 +305,9 @@ void kvmhv_set_ptbl_entry(unsigned int lpid, u64 dw0, u64 dw1);
 void kvmhv_release_all_nested(struct kvm *kvm);
 long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu);
 long kvmhv_do_nested_tlbie(struct kvm_vcpu *vcpu);
+long do_h_rpt_invalidate_pat(struct kvm_vcpu *vcpu, unsigned long lpid,
+			     unsigned long type, unsigned long pg_sizes,
+			     unsigned long start, unsigned long end);
 int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu,
 			  u64 time_limit, unsigned long lpcr);
 void kvmhv_save_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr);
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 5d008468347c..03755389efd1 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -922,6 +922,46 @@ static int kvmppc_get_yield_count(struct kvm_vcpu *vcpu)
 	return yield_count;
 }
 
+/*
+ * H_RPT_INVALIDATE hcall handler for nested guests.
+ *
+ * Handles only nested process-scoped invalidation requests in L0.
+ */
+static int kvmppc_nested_h_rpt_invalidate(struct kvm_vcpu *vcpu)
+{
+	unsigned long type = kvmppc_get_gpr(vcpu, 6);
+	unsigned long pid, pg_sizes, start, end, psize;
+	struct kvm_nested_guest *gp;
+	struct mmu_psize_def *def;
+
+	/*
+	 * The partition-scoped invalidations aren't handled here in L0.
+	 */
+	if (type & H_RPTI_TYPE_NESTED)
+		return RESUME_HOST;
+
+	pid = kvmppc_get_gpr(vcpu, 4);
+	pg_sizes = kvmppc_get_gpr(vcpu, 7);
+	start = kvmppc_get_gpr(vcpu, 8);
+	end = kvmppc_get_gpr(vcpu, 9);
+
+	gp = kvmhv_get_nested(vcpu->kvm, vcpu->kvm->arch.lpid, false);
+	if (!gp)
+		goto out;
+
+	for (psize = 0; psize < MMU_PAGE_COUNT; psize++) {
+		def = &mmu_psize_defs[psize];
+		if (pg_sizes & def->h_rpt_pgsize)
+			do_h_rpt_invalidate_prt(pid, gp->shadow_lpid, type,
+						(1UL << def->shift), psize,
+						start, end);
+	}
+	kvmhv_put_nested(gp);
+out:
+	kvmppc_set_gpr(vcpu, 3, H_SUCCESS);
+	return RESUME_GUEST;
+}
+
 static long kvmppc_h_rpt_invalidate(struct kvm_vcpu *vcpu,
 				    unsigned long id, unsigned long target,
 				    unsigned long type, unsigned long pg_sizes,
@@ -938,10 +978,18 @@ static long kvmppc_h_rpt_invalidate(struct kvm_vcpu *vcpu,
 
 	/*
 	 * Partition-scoped invalidation for nested guests.
-	 * Not yet supported
 	 */
-	if (type & H_RPTI_TYPE_NESTED)
-		return H_P3;
+	if (type & H_RPTI_TYPE_NESTED) {
+		if (!nesting_enabled(vcpu->kvm))
+			return H_FUNCTION;
+
+		/* Support only cores as target */
+		if (target != H_RPTI_TARGET_CMMU)
+			return H_P2;
+
+		return do_h_rpt_invalidate_pat(vcpu, id, type, pg_sizes,
+					       start, end);
+	}
 
 	/*
 	 * Process-scoped invalidation for L1 guests.
@@ -1636,6 +1684,23 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
 		if (!xics_on_xive())
 			kvmppc_xics_rm_complete(vcpu, 0);
 		break;
+	case BOOK3S_INTERRUPT_SYSCALL:
+	{
+		unsigned long req = kvmppc_get_gpr(vcpu, 3);
+
+		/*
+		 * The H_RPT_INVALIDATE hcalls issued by nested
+		 * guests for process-scoped invalidations when
+		 * GTSE=0, are handled here in L0.
+		 */
+		if (req == H_RPT_INVALIDATE) {
+			r = kvmppc_nested_h_rpt_invalidate(vcpu);
+			break;
+		}
+
+		r = RESUME_HOST;
+		break;
+	}
 	default:
 		r = RESUME_HOST;
 		break;
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 0cd0e7aad588..adcc8e26ef22 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -1191,6 +1191,110 @@ long kvmhv_do_nested_tlbie(struct kvm_vcpu *vcpu)
 	return H_SUCCESS;
 }
 
+static long do_tlb_invalidate_nested_tlb(struct kvm_vcpu *vcpu,
+					 unsigned long lpid,
+					 unsigned long page_size,
+					 unsigned long ap,
+					 unsigned long start,
+					 unsigned long end)
+{
+	unsigned long addr = start;
+	int ret;
+
+	do {
+		ret = kvmhv_emulate_tlbie_tlb_addr(vcpu, lpid, ap,
+						   get_epn(addr));
+		if (ret)
+			return ret;
+		addr += page_size;
+	} while (addr < end);
+
+	return ret;
+}
+
+static long do_tlb_invalidate_nested_all(struct kvm_vcpu *vcpu,
+					 unsigned long lpid, unsigned long ric)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_nested_guest *gp;
+
+	gp = kvmhv_get_nested(kvm, lpid, false);
+	if (gp) {
+		kvmhv_emulate_tlbie_lpid(vcpu, gp, ric);
+		kvmhv_put_nested(gp);
+	}
+	return H_SUCCESS;
+}
+
+/*
+ * Performs partition-scoped invalidations for nested guests
+ * as part of H_RPT_INVALIDATE hcall.
+ */
+long do_h_rpt_invalidate_pat(struct kvm_vcpu *vcpu, unsigned long lpid,
+			     unsigned long type, unsigned long pg_sizes,
+			     unsigned long start, unsigned long end)
+{
+	struct kvm_nested_guest *gp;
+	long ret;
+	unsigned long psize, ap;
+
+	/*
+	 * If L2 lpid isn't valid, we need to return H_PARAMETER.
+	 *
+	 * However, nested KVM issues a L2 lpid flush call when creating
+	 * partition table entries for L2. This happens even before the
+	 * corresponding shadow lpid is created in HV which happens in
+	 * H_ENTER_NESTED call. Since we can't differentiate this case from
+	 * the invalid case, we ignore such flush requests and return success.
+	 */
+	gp = kvmhv_find_nested(vcpu->kvm, lpid);
+	if (!gp)
+		return H_SUCCESS;
+
+	/*
+	 * A flush all request can be handled by a full lpid flush only.
+	 */
+	if ((type & H_RPTI_TYPE_NESTED_ALL) == H_RPTI_TYPE_NESTED_ALL)
+		return do_tlb_invalidate_nested_all(vcpu, lpid, RIC_FLUSH_ALL);
+
+#if 0
+	/*
+	 * We don't need to handle a PWC flush like process table here,
+	 * because intermediate partition scoped table in nested guest doesn't
+	 * really have PWC. Only level we have PWC is in L0 and for nested
+	 * invalidate at L0 we always do kvm_flush_lpid() which does
+	 * radix__flush_all_lpid(). For range invalidate at any level, we
+	 * are not removing the higher level page tables and hence there is
+	 * no PWC invalidate needed.
+	 */
+	if (type & H_RPTI_TYPE_PWC) {
+		ret = do_tlb_invalidate_nested_all(vcpu, lpid, RIC_FLUSH_PWC);
+		if (ret)
+			return H_P4;
+	}
+#endif
+
+	if (start == 0 && end == -1)
+		return do_tlb_invalidate_nested_all(vcpu, lpid, RIC_FLUSH_TLB);
+
+	if (type & H_RPTI_TYPE_TLB) {
+		struct mmu_psize_def *def;
+
+		for (psize = 0; psize < MMU_PAGE_COUNT; psize++) {
+			def = &mmu_psize_defs[psize];
+			if (!(pg_sizes & def->h_rpt_pgsize))
+				continue;
+
+			ret = do_tlb_invalidate_nested_tlb(vcpu, lpid,
+							   (1UL << def->shift),
+							   ap, start, end);
+			if (ret)
+				return H_P4;
+		}
+	}
+	return H_SUCCESS;
+}
+
 /* Used to convert a nested guest real address to a L1 guest real address */
 static int kvmhv_translate_addr_nested(struct kvm_vcpu *vcpu,
 				       struct kvm_nested_guest *gp,
-- 
2.26.2

