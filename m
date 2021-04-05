Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219E5353A90
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhDEBUq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbhDEBUp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:20:45 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F201C061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:20:39 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so5050608pjg.5
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XTwV9xVlVat7TnR+O83IRQJ050ZVGX6uPq2CbLxvr5s=;
        b=qTRhikcrH3/Zr5oPLdE032U6xMCvjUoB2lQbn3pBzdNA8pUickLMGYU+EAnbuWNfzp
         d2iHtGkbT17COc9zuTF8Pa8ZjtQmqjlnYOv82MZeiMdZUAa0cxSYZjbANgpuJIn+JAfT
         T6PqvzrwNVOc4Dof4q3M6q7132zigQ6FZS3FkSjpXZoLXVXUMqkVuaaDNO8IjS/MfpKO
         pRQ+bWDhgF9BEy5sejWNIomclwZSvXZwhf6aFhN38W4+pPkQD7OSnX6aJu59SNMQBdOr
         WBmgQht11OQ39pMwN/sJnL+Zyn9OnsO+bleVjpr3xBdpPClru15mepLsv2bSPTZ6IC1l
         ExzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XTwV9xVlVat7TnR+O83IRQJ050ZVGX6uPq2CbLxvr5s=;
        b=Y5Q0FybOFIuBb+XGOEwGBMn9l56nRC9vUmLGR2kX11KyDFSvnOE8OAc2RcGOdcQlIN
         xhLpYp7TgmDOBZEWtiLOF8hAw7YhKV+F5m9gUjucTH7NnLum/QcY7lR9aqU3vjWny0Bx
         6xIljyaX5Oi39TB7bbTRzKweQ/Ix+EVAbRuoOIO4Pp5ONkDRyBiT+V0Dd7xCLmCCxDv4
         61mefwDCwpSkb1ATGkGrX+yDIBZq6eQw+HjgjJqdlHqH/9u8NKiUeY8ePCvBxwunFqUH
         KtKT30jXlX3KRDp9hJOhyQ+fIVUdra1vMvgiRgsX1JiaLGaf0GHwFXT7V9Kv0vU9hyTO
         86cQ==
X-Gm-Message-State: AOAM531x9JjHs5ET2+UddKsgneRyCjEGTj8nobTbbHKik+agVIzs3ggr
        bQb70+kWS/0p2c8NpYEIdogtx8/4UQW0TQ==
X-Google-Smtp-Source: ABdhPJy8auehRG8QDvzXYfOdTM5XuOLcXu7jGgckCm/ditqcjEDm6KvS5q1GHun2vfRijGIqczyzqw==
X-Received: by 2002:a17:902:263:b029:e7:35d8:4554 with SMTP id 90-20020a1709020263b02900e735d84554mr21591735plc.83.1617585638854;
        Sun, 04 Apr 2021 18:20:38 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:20:38 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Daniel Axtens <dja@axtens.net>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v6 10/48] KVM: PPC: Book3S HV: Ensure MSR[ME] is always set in guest MSR
Date:   Mon,  5 Apr 2021 11:19:10 +1000
Message-Id: <20210405011948.675354-11-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Rather than add the ME bit to the MSR at guest entry, make it clear
that the hypervisor does not allow the guest to clear the bit.

The ME set is kept in guest entry for now, but a future patch will
warn if it's not present.

Acked-by: Paul Mackerras <paulus@ozlabs.org>
Reviewed-by: Daniel Axtens <dja@axtens.net>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_builtin.c | 3 +++
 arch/powerpc/kvm/book3s_hv_nested.c  | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 158d309b42a3..41cb03d0bde4 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -662,6 +662,9 @@ static void kvmppc_end_cede(struct kvm_vcpu *vcpu)
 
 void kvmppc_set_msr_hv(struct kvm_vcpu *vcpu, u64 msr)
 {
+	/* Guest must always run with ME enabled. */
+	msr = msr | MSR_ME;
+
 	/*
 	 * Check for illegal transactional state bit combination
 	 * and if we find it, force the TS field to a safe state.
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index d14fe32f167b..fb03085c902b 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -343,7 +343,9 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	vcpu->arch.nested = l2;
 	vcpu->arch.nested_vcpu_id = l2_hv.vcpu_token;
 	vcpu->arch.regs = l2_regs;
-	vcpu->arch.shregs.msr = vcpu->arch.regs.msr;
+
+	/* Guest must always run with ME enabled. */
+	vcpu->arch.shregs.msr = vcpu->arch.regs.msr | MSR_ME;
 
 	sanitise_hv_regs(vcpu, &l2_hv);
 	restore_hv_regs(vcpu, &l2_hv);
-- 
2.23.0

