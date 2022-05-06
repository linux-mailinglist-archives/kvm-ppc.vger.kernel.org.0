Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13BDA51D268
	for <lists+kvm-ppc@lfdr.de>; Fri,  6 May 2022 09:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237297AbiEFHlc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 6 May 2022 03:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389626AbiEFHlb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 6 May 2022 03:41:31 -0400
Received: from ozlabs.ru (ozlabs.ru [107.174.27.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4739C66C9B
        for <kvm-ppc@vger.kernel.org>; Fri,  6 May 2022 00:37:49 -0700 (PDT)
Received: from fstn1-p1.ozlabs.ibm.com. (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 1E6A280152;
        Fri,  6 May 2022 03:37:44 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm-ppc@vger.kernel.org
Subject: [PATCH kernel] KVM: PPC: Book3s: PR: Enable default TCE hypercalls
Date:   Fri,  6 May 2022 17:37:37 +1000
Message-Id: <20220506073737.3823347-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

When KVM_CAP_PPC_ENABLE_HCALL was introduced, H_GET_TCE and H_PUT_TCE
were already implemented and enabled by default; however H_GET_TCE
was missed out on PR KVM (probably because the handler was in
the real mode code at the time).

This enables H_GET_TCE by default. While at this, this wraps
the checks in ifdef CONFIG_SPAPR_TCE_IOMMU just like HV KVM.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/kvm/book3s_pr_papr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_pr_papr.c b/arch/powerpc/kvm/book3s_pr_papr.c
index dc4f51ac84bc..a1f2978b2a86 100644
--- a/arch/powerpc/kvm/book3s_pr_papr.c
+++ b/arch/powerpc/kvm/book3s_pr_papr.c
@@ -433,9 +433,12 @@ int kvmppc_hcall_impl_pr(unsigned long cmd)
 	case H_REMOVE:
 	case H_PROTECT:
 	case H_BULK_REMOVE:
+#ifdef CONFIG_SPAPR_TCE_IOMMU
+	case H_GET_TCE:
 	case H_PUT_TCE:
 	case H_PUT_TCE_INDIRECT:
 	case H_STUFF_TCE:
+#endif
 	case H_CEDE:
 	case H_LOGICAL_CI_LOAD:
 	case H_LOGICAL_CI_STORE:
@@ -464,7 +467,10 @@ static unsigned int default_hcall_list[] = {
 	H_REMOVE,
 	H_PROTECT,
 	H_BULK_REMOVE,
+#ifdef CONFIG_SPAPR_TCE_IOMMU
+	H_GET_TCE,
 	H_PUT_TCE,
+#endif
 	H_CEDE,
 	H_SET_MODE,
 #ifdef CONFIG_KVM_XICS
-- 
2.30.2

