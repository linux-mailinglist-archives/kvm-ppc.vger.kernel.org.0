Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6F94D2749
	for <lists+kvm-ppc@lfdr.de>; Wed,  9 Mar 2022 05:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiCIBZK (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 8 Mar 2022 20:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiCIBZK (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 8 Mar 2022 20:25:10 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7206729CB7
        for <kvm-ppc@vger.kernel.org>; Tue,  8 Mar 2022 17:24:02 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2290uMKL007900;
        Wed, 9 Mar 2022 01:23:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=lOTmQlCRUmcoW8PwOeHvgAUjYbbv+uP78u9ku8Y/wKs=;
 b=Mw1b8S2P4nk/8/HClVgCoy3I3E/H2YPwAZ39+o7SOJtKtbCsmc/kPfFUBmgIxkMrMPw3
 OYAidGa7OLuxMOuDGRgr/8qsuB1KwoO4LWPYxnhBhAwx1XUGHVx1CFhxJSXpX1Mp8HYx
 4rvZU0c6Lp0gjZUmbe9fmAoUujhAFh9rledvTVvn+sUn4TtfLL/JQXP7LUGjK9Ag8Y8s
 JvN3spHYgNBAOqjPfqwOZQJPEQL2vZMI72Smr0ff6CK0kVaBnlI5TyCKngxwiOBo8nX5
 Q1on0n2IUBCAe8IZWIiArBOYumIeQvYwnwjPuJFswnLA90kER/yvo5dv+FfQ7QI6R7CF 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eny18r9c0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Mar 2022 01:23:49 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22918bBB026203;
        Wed, 9 Mar 2022 01:23:48 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eny18r9bp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Mar 2022 01:23:48 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2291CfdL016744;
        Wed, 9 Mar 2022 01:23:47 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 3emy8h4t8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Mar 2022 01:23:47 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2291NkEE39453162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Mar 2022 01:23:46 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 075A57805C;
        Wed,  9 Mar 2022 01:23:46 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A42DE7805F;
        Wed,  9 Mar 2022 01:23:43 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.211.148.106])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  9 Mar 2022 01:23:43 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        aneesh.kumar@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
        david@gibson.dropbear.id.au, clg@kaod.org, danielhb413@gmail.com
Subject: [RFC PATCH] KVM: PPC: Book3S HV: Add KVM_CAP_PPC_GTSE
Date:   Tue,  8 Mar 2022 22:23:38 -0300
Message-Id: <20220309012338.2527143-1-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DzijlCT9TcaGoPGc_cQLGzSf3hFoNWR6
X-Proofpoint-ORIG-GUID: M_f2-IvAeabATHK4MAc9PPpOUBQ9AJS5
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
 clxscore=1011 priorityscore=1501 impostorscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203090003
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This patch adds a new KVM capability to address a crash we're
currently having inside the nested guest kernel when running with
GTSE disabled in the nested hypervisor.

The summary is:

We allow any guest a cmdline override of GTSE for migration
purposes. The nested guest does not know it needs to use the option
and tries to run 'tlbie' with LPCR_GTSE=0.

The details are a bit more intricate:

QEMU always sets GTSE=1 in OV5 even before calling KVM. At prom_init,
guests use the OV5 value to set MMU_FTR_GTSE. This setting can be
overridden by 'radix_hcall_invalidate=on' in the kernel cmdline. The
option itself depends on the availability of
FW_FEATURE_RPT_INVALIDATE, which is tied to QEMU's cap-rpt-invalidate
capability.

The MMU_FTR_GTSE flag leads guests to set PROC_TABLE_GTSE in their
process tables and after H_REGISTER_PROC_TBL, both QEMU and KVM will
set LPCR_GTSE=1 for that guest. Unless the guest uses the cmdline
override, in which case:

  MMU_FTR_GTSE=0 -> PROC_TABLE_GTSE=0 -> LPCR_GTSE=0

We don't allow the nested hypervisor to set some LPCR bits for its
nested guests, so if the nested HV has LPCR_GTSE=0, its nested guests
will also have LPCR_GTSE=0. But since the only thing that can really
flip GTSE is the cmdline override, if a nested guest runs without it,
then the sequence goes:

  MMU_FTR_GTSE=1 -> PROC_TABLE_GTSE=1 -> LPCR_GTSE=0.

With LPCR_GTSE=0 the HW will treat 'tlbie' as HV privileged.

How the new capability helps:

By having QEMU consult KVM on what the correct GTSE value is, we can
have the nested hypervisor return the same value that it is currently
using. QEMU will then put the correct value in the device-tree for the
nested guest and MMU_FTR_GTSE will match LPCR_GTSE.

Fixes: b87cc116c7e1 ("KVM: PPC: Book3S HV: Add KVM_CAP_PPC_RPT_INVALIDATE capability")
Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
This supersedes the previous RFC: "KVM: PPC: Book3s HV: Allow setting
GTSE for the nested guest"*. Aneesh explained to me that we don't want
to allow L1 and L2 GTSE values to differ.

*- https://lore.kernel.org/r/20220304182657.2489303-1-farosas@linux.ibm.com
---
 arch/powerpc/kvm/powerpc.c | 3 +++
 include/uapi/linux/kvm.h   | 1 +
 2 files changed, 4 insertions(+)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 2ad0ccd202d5..dd08b3b729cd 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -677,6 +677,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_PPC_RPT_INVALIDATE:
 		r = 1;
 		break;
+	case KVM_CAP_PPC_GTSE:
+		r = mmu_has_feature(MMU_FTR_GTSE);
+		break;
 #endif
 	default:
 		r = 0;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 507ee1f2aa96..cc581e345d2a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1135,6 +1135,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
 #define KVM_CAP_PPC_AIL_MODE_3 210
+#define KVM_CAP_PPC_GTSE 211
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.34.1

