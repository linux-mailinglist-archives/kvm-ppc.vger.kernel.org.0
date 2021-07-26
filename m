Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4AA3D51AE
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhGZDKz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhGZDKy (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:10:54 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C990C061760
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:19 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n10so2352931plc.2
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=shePQEuLHDgx7Ejl/VppXX+u34JQZkGKzR8cfPeQyKk=;
        b=MHfKxkF55s08XB75KxHKhdcaY5/fpLsPhhoMr0Wk4mmzkck0NIX6A04iWbCL0qy4vP
         vqyNVPXL3ULhDFHj7hjhE1K8DRg/EINisFXAdmuCcWea/3JG5XZHxdA8hbdAOjdm96ml
         T5rnyPRHKdCaCyDuFK8tHsQQ9DOFM6KjWsu3dXYei/FM1rfUw4+TaBCwwIZUBxWZqKjx
         zRraE7uZB4gm+cZ5wpg/03GfZsLWJJuKzwolXfW32s16b8ogttyx5LcPhVFUN7ZVOaZ0
         VshU77xzlPiwpi5A8qXEzjNCJZebgM+qab78CAm33neuN5ixq0nxVsLDbZYcpFDUgUlh
         4+3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=shePQEuLHDgx7Ejl/VppXX+u34JQZkGKzR8cfPeQyKk=;
        b=fdMsHe0wUY7EfPRug/bXAaPlf9xJ7b8Nvow1u3H+dkBcXIOqiXfzXCE2PNPPI+QVAj
         1oFfEPO/yU4JSV4bUdElvBHO9vNzmK8SpGvdUJK3x0+v1RJEXq6FVKJ0n7sOtAoaml91
         JmYkJNX6S0zJrD1CbiP2/bQHVToUpScHs0EqoDRfUMD3beBAak7C2bMJRyuh527of65H
         Df0r7/s6Q95IhVW2x9ScoNq79azv2DJSJ99rMdP2si3+1wCrqWG3AM0J+cw1FdDLv+Tc
         45OUVbkI+6Bvg5qn1GYG5o8NhHyNcMbLsz3irEWUD4RqoPKF6Dkctr1OgnRQdXnCzj3i
         VOBQ==
X-Gm-Message-State: AOAM5336HeKcAm5RD/8MOP4Mf/pLa9Im+vMxKW2eoceVQawi16EZcxyi
        Zy46gLQbaDKDMskfzou6oX8qZeffhH0=
X-Google-Smtp-Source: ABdhPJxukfXi22mn2P1qUJcY5oYKgsPpb+58bBenCrGHt4BbANGyK8mJ1f5SFPmFlcI5ZbBGxNxY+w==
X-Received: by 2002:a17:902:c20c:b029:12a:edee:a7fa with SMTP id 12-20020a170902c20cb029012aedeea7famr13124967pll.2.1627271478693;
        Sun, 25 Jul 2021 20:51:18 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:51:18 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 14/55] KVM: PPC: Book3S HV: Don't always save PMU for guest capable of nesting
Date:   Mon, 26 Jul 2021 13:49:55 +1000
Message-Id: <20210726035036.739609-15-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Revert the workaround added by commit 63279eeb7f93a ("KVM: PPC: Book3S
HV: Always save guest pmu for guest capable of nesting").

Nested capable guests running with the earlier commit ("KVM: PPC: Book3S
HV Nested: Indicate guest PMU in-use in VPA") will now indicate the PMU
in-use status of their guests, which means the parent does not need to
unconditionally save the PMU for nested capable guests.

This will cause the PMU to break for nested guests when running older
nested hypervisor guests under a kernel with this change. It's unclear
there's an easy way to avoid that, so this could wait for a release or
so for the fix to filter into stable kernels.

-134 cycles (8982) POWER9 virt-mode NULL hcall

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index e7f8cc04944b..ab89db561c85 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4003,8 +4003,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		vcpu->arch.vpa.dirty = 1;
 		save_pmu = lp->pmcregs_in_use;
 	}
-	/* Must save pmu if this guest is capable of running nested guests */
-	save_pmu |= nesting_enabled(vcpu->kvm);
 
 	kvmhv_save_guest_pmu(vcpu, save_pmu);
 #ifdef CONFIG_PPC_PSERIES
-- 
2.23.0

