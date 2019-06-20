Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C98A54C519
	for <lists+kvm-ppc@lfdr.de>; Thu, 20 Jun 2019 03:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731172AbfFTBrU (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 19 Jun 2019 21:47:20 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40738 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfFTBrU (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 19 Jun 2019 21:47:20 -0400
Received: by mail-pg1-f195.google.com with SMTP id w10so657488pgj.7
        for <kvm-ppc@vger.kernel.org>; Wed, 19 Jun 2019 18:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Qzjpioy/P2IPckje2dj/C4MHof6bcToLS3p/Qy08+Dc=;
        b=UkFBpkHnaDzJ4EEr/gPxr3tB5VD3Lt6Sack+HpwPgZWu93UMoqsvLt3ySpWYJ1u+1o
         9zlwxLM4Xo8bksXVPtVDp3gAm1SozhQxFWLe9i8u+VzmeNAaYXq3GqnueIJgh8wR4JVo
         Q759N28xmebe3thpfTU2dey91XPLNRBpXYbc6Rft+ZpV4DhdbEpH1xyct1APfOEtv2M8
         x8h2dli7Wzyp5UTdf6r2VAkvX9UYsn4yxka7OSBhHmGqTBANYM7kMH7XE5key0GiGxSM
         O8QBmiPI4HXHEMLM/qMZJaIy2VC/kYviJQ7VyTtmGb1DrLsrGlIDm4+ku5eJ4uFsPgIa
         pt6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Qzjpioy/P2IPckje2dj/C4MHof6bcToLS3p/Qy08+Dc=;
        b=VeWleb8ooxxhpKPMrYgRbnACuCkjVpMaqvfgRcuUpaWf6OaC9c1L/++uupdo1NWOLR
         4EYeVx6cFfbpcTxSOt4WKMR1oxF18VSFYr67J7zpEr9x7IujZo/7SioBxDfsbBRP81dL
         lP42wseNe6CzcKe/u6qAQRGogBr6/mspa8UbmX2heuM986USYi74Ytq1rKMjI9MrQOJT
         BneFBWzpcmV5HHCmfiuP0W7vBQ7QzwpTMbFpEG6OLW74oxWrNzPcwFD6UXa7hLhSSRuU
         I90rbHtOWPmDIQH/igVm0v5W9WixyhLELkg7fjEHOA5OVupyxJZXztkhk6PsXqW2m1dT
         TJ0Q==
X-Gm-Message-State: APjAAAVkLOJ+P0+nPgrxFOD9Ait4N1op1FgN7EZBpdXmtkPrjjiJQCKv
        kng14EncbXHQrENFMDmgbTZU9TJ8
X-Google-Smtp-Source: APXvYqx+2IXeF0bK9VkWnbmx9WmhqjJFeWbAoAZDCTeAWgYBWnohz9q3fIehN5XzGYXsgtu+dH0rtw==
X-Received: by 2002:a63:5a4b:: with SMTP id k11mr10562073pgm.143.1560995239808;
        Wed, 19 Jun 2019 18:47:19 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id 23sm20763528pfn.176.2019.06.19.18.47.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Jun 2019 18:47:19 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mpe@ellerman.id.au, paulus@ozlabs.org,
        clg@kaod.org, sjitindarsingh@gmail.com
Subject: [PATCH 3/3] KVM: PPC: Book3S HV: Clear pending decr exceptions on nested guest entry
Date:   Thu, 20 Jun 2019 11:46:51 +1000
Message-Id: <20190620014651.7645-3-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190620014651.7645-1-sjitindarsingh@gmail.com>
References: <20190620014651.7645-1-sjitindarsingh@gmail.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

If we enter an L1 guest with a pending decrementer exception then this
is cleared on guest exit if the guest has writtien a positive value into
the decrementer (indicating that it handled the decrementer exception)
since there is no other way to detect that the guest has handled the
pending exception and that it should be dequeued. In the event that the
L1 guest tries to run a nested (L2) guest immediately after this and the
L2 guest decrementer is negative (which is loaded by L1 before making
the H_ENTER_NESTED hcall), then the pending decrementer exception
isn't cleared and the L2 entry is blocked since L1 has a pending
exception, even though L1 may have already handled the exception and
written a positive value for it's decrementer. This results in a loop of
L1 trying to enter the L2 guest and L0 blocking the entry since L1 has
an interrupt pending with the outcome being that L2 never gets to run
and hangs.

Fix this by clearing any pending decrementer exceptions when L1 makes
the H_ENTER_NESTED hcall since it won't do this if it's decrementer has
gone negative, and anyway it's decrementer has been communicated to L0
in the hdec_expires field and L0 will return control to L1 when this
goes negative by delivering an H_DECREMENTER exception.

Fixes: 95a6432ce903 "KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests"

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 719fd2529eec..4a5eb29b952f 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4128,8 +4128,15 @@ int kvmhv_run_single_vcpu(struct kvm_run *kvm_run,
 
 	preempt_enable();
 
-	/* cancel pending decrementer exception if DEC is now positive */
-	if (get_tb() < vcpu->arch.dec_expires && kvmppc_core_pending_dec(vcpu))
+	/*
+	 * cancel pending decrementer exception if DEC is now positive, or if
+	 * entering a nested guest in which case the decrementer is now owned
+	 * by L2 and the L1 decrementer is provided in hdec_expires
+	 */
+	if (kvmppc_core_pending_dec(vcpu) &&
+			((get_tb() < vcpu->arch.dec_expires) ||
+			 (trap == BOOK3S_INTERRUPT_SYSCALL &&
+			  kvmppc_get_gpr(vcpu, 3) == H_ENTER_NESTED)))
 		kvmppc_core_dequeue_dec(vcpu);
 
 	trace_kvm_guest_exit(vcpu);
-- 
2.13.6

