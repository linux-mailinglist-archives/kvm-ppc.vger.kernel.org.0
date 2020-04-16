Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0661AB664
	for <lists+kvm-ppc@lfdr.de>; Thu, 16 Apr 2020 05:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391452AbgDPDyM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 15 Apr 2020 23:54:12 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:60685 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729245AbgDPDyK (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 15 Apr 2020 23:54:10 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 492lhT5D9zz9sSG; Thu, 16 Apr 2020 13:54:01 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1587009241;
        bh=N+Rkt9wuCYS4FEyEbyG/lYRvAzSD8Ldu8HQrt/sWwA8=;
        h=From:To:Cc:Subject:Date:From;
        b=bTVyTWXtJf65JlTGFZFv3iB72pyKSAPmL2me0VFJoGPEZnk+9bQ1QQoAV9qbOIevz
         OQr9Pzdpb+Hzls3faBa2n10igsRhrGJ8SBFlx0KGqMXNEAtnE/SWKEzRR4vC66uEdS
         RtKWixkTcV7ryq25/d09i2MrKURNbBB7gDQs6ggc=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     paulus@samba.org, mpe@ellerman.id.au
Cc:     clg@kaod.org, kvm-ppc@vger.kernel.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        groug@kaod.org, David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH] KVM: PPC: Handle non-present PTEs in kvmppc_book3s_hv_page_fault()
Date:   Thu, 16 Apr 2020 13:53:58 +1000
Message-Id: <20200416035358.261056-1-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Since cd758a9b57ee "KVM: PPC: Book3S HV: Use __gfn_to_pfn_memslot in HPT
page fault handler", it's been possible in fairly rare circumstances to
load a non-present PTE in kvmppc_book3s_hv_page_fault() when running a
guest on a POWER8 host.

Because that case wasn't checked for, we could misinterpret the non-present
PTE as being a cache-inhibited PTE.  That could mismatch with the
corresponding hash PTE, which would cause the function to fail with -EFAULT
a little further down.  That would propagate up to the KVM_RUN ioctl()
generally causing the KVM userspace (usually qemu) to fall over.

This addresses the problem by catching that case and returning to the guest
instead.

Fixes: cd758a9b57ee "KVM: PPC: Book3S HV: Use __gfn_to_pfn_memslot in HPT page fault handler"
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1820402
Suggested-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 arch/powerpc/kvm/book3s_64_mmu_hv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 6404df613ea3..394fca8e630a 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -616,6 +616,11 @@ int kvmppc_book3s_hv_page_fault(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	}
 	pte = *ptep;
 	local_irq_enable();
+	if (!pte_present(pte)) {
+		if (page)
+			put_page(page);
+		return RESUME_GUEST;
+	}
 	hpa = pte_pfn(pte) << PAGE_SHIFT;
 	pte_size = PAGE_SIZE;
 	if (shift)
-- 
2.25.2

