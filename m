Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D7340629A
	for <lists+kvm-ppc@lfdr.de>; Fri, 10 Sep 2021 02:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241800AbhIJApi (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 9 Sep 2021 20:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234480AbhIJAX2 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 9 Sep 2021 20:23:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3262C610A3;
        Fri, 10 Sep 2021 00:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233338;
        bh=ntTVX/VG1xsWVQRH3GIMSs5Y7Qxh0tYso/66ecFKUoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g7v/Ys1meHuVS6FZDzRLIbT98vjdpqOdpm/rksTcOtsJBC/Si63Gl6336VO51npmO
         oJLb2qlo9E8AQrQKW4w+x7xMNilCv4fu5osS8+6L9kCJZt/Nh12+ISm16nhSnK+mU6
         pSAVeZqkNxDUvxHEXlvwQXmDlxUr10dF4EJVDoyi1XtSwIc+ypLtWt4iqljhPuF+ZQ
         tlgBo95ewQ5I1Rs5KivyzhtfSi/AjjboalkSDbDmH/y+t7Xx1+Kma3y/FlwOWYlhFY
         +KkPXxDT8jqfYQaVVedxGrHsvuypoQc9B45tlbTtT60aqRa4IcxKty5miZuNX3exH/
         XPzE6/ozCsWkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 26/37] KVM: PPC: Book3S HV: Initialise vcpu MSR with MSR_ME
Date:   Thu,  9 Sep 2021 20:21:31 -0400
Message-Id: <20210910002143.175731-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002143.175731-1-sashal@kernel.org>
References: <20210910002143.175731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit fd42b7b09c602c904452c0c3e5955ca21d8e387a ]

It is possible to create a VCPU without setting the MSR before running
it, which results in a warning in kvmhv_vcpu_entry_p9() that MSR_ME is
not set. This is pretty harmless because the MSR_ME bit is added to
HSRR1 before HRFID to guest, and a normal qemu guest doesn't hit it.

Initialise the vcpu MSR with MSR_ME set.

Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210811160134.904987-2-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index dc897dff8eb9..4718313eddc9 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2293,6 +2293,7 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_hv(struct kvm *kvm,
 	spin_lock_init(&vcpu->arch.vpa_update_lock);
 	spin_lock_init(&vcpu->arch.tbacct_lock);
 	vcpu->arch.busy_preempt = TB_NIL;
+	vcpu->arch.shregs.msr = MSR_ME;
 	vcpu->arch.intr_msr = MSR_SF | MSR_ME;
 
 	/*
-- 
2.30.2

