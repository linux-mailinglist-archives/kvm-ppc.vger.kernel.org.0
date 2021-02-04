Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB63830FDC6
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Feb 2021 21:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239962AbhBDUGt (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 4 Feb 2021 15:06:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6008 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239818AbhBDUGc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 4 Feb 2021 15:06:32 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 114K1J2g033196;
        Thu, 4 Feb 2021 15:05:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=kjgmLOqy2IHSMC4krSKZvVE2p3Tr66l0k7MC5Clqlj8=;
 b=Ni/yFHlCsslX/JkrpllvIEWkFqS9b6IKdXGTvHPL5WKYM5BIBVd8FAaMrXcrJJjjGnnw
 LyKaXF2wivncgmi7EOqWoXgyMtpkivT9cTZH1a2FxJUj9loKmkSzaGH6KtQIedKCQwsp
 wOsXBl8sYS43I0BB9gsyQxSWmVx+w0kMiiXu6BjiHja2n3O1Cem77ZamPeuSjCGeE5jN
 WoH+CbcfQN46RzsQAaSbWrfZ8LfxBpeERlPjM8v1ER35B9sL/ng/uS29Wtqn0pSH5+4B
 2o1kkVu1DVvqKMNp+TE/viN4zwl+cz328jb8HHEVpu2MqUrW8Jf3wl8xmWkJ7sPCFFse FA== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36gqb9rqk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Feb 2021 15:05:25 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 114K2A8M012565;
        Thu, 4 Feb 2021 20:05:22 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03wdc.us.ibm.com with ESMTP id 36f2nxcm3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Feb 2021 20:05:22 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 114K5Moc23790074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Feb 2021 20:05:22 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39B04AE05F;
        Thu,  4 Feb 2021 20:05:22 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69F6AAE062;
        Thu,  4 Feb 2021 20:05:20 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.163.38.10])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu,  4 Feb 2021 20:05:20 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au
Subject: [PATCH] KVM: PPC: Book3S HV: Save and restore FSCR in the P9 path
Date:   Thu,  4 Feb 2021 17:05:17 -0300
Message-Id: <20210204200517.1481811-1-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-04_10:2021-02-04,2021-02-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 suspectscore=0 mlxlogscore=881
 mlxscore=0 bulkscore=0 clxscore=1011 adultscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040118
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The Facility Status and Control Register is a privileged SPR that
defines the availability of some features in problem state. Since it
can be written by the guest, we must restore it to the previous host
value after guest exit.

This restoration is currently done by taking the value from
current->thread.fscr, which in the P9 path is not enough anymore
because the guest could context switch the QEMU thread, causing the
guest-current value to be saved into the thread struct.

The above situation manifested when running a QEMU linked against a
libc with System Call Vectored support, which causes scv
instructions to be run by QEMU early during the guest boot (during
SLOF), at which point the FSCR is 0 due to guest entry. After a few
scv calls (1 to a couple hundred), the context switching happens and
the QEMU thread runs with the guest value, resulting in a Facility
Unavailable interrupt.

This patch saves and restores the host value of FSCR in the inner
guest entry loop in a way independent of current->thread.fscr. The old
way of doing it is still kept in place because it works for the old
entry path.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 6f612d240392..f2ddf7139a2a 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3595,6 +3595,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	unsigned long host_tidr = mfspr(SPRN_TIDR);
 	unsigned long host_iamr = mfspr(SPRN_IAMR);
 	unsigned long host_amr = mfspr(SPRN_AMR);
+	unsigned long host_fscr = mfspr(SPRN_FSCR);
 	s64 dec;
 	u64 tb;
 	int trap, save_pmu;
@@ -3735,6 +3736,9 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (host_amr != vcpu->arch.amr)
 		mtspr(SPRN_AMR, host_amr);
 
+	if (host_fscr != vcpu->arch.fscr)
+		mtspr(SPRN_FSCR, host_fscr);
+
 	msr_check_and_set(MSR_FP | MSR_VEC | MSR_VSX);
 	store_fp_state(&vcpu->arch.fp);
 #ifdef CONFIG_ALTIVEC
-- 
2.29.2

