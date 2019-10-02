Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 177E3C4753
	for <lists+kvm-ppc@lfdr.de>; Wed,  2 Oct 2019 08:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfJBGBA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 2 Oct 2019 02:01:00 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33916 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbfJBGBA (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 2 Oct 2019 02:01:00 -0400
Received: by mail-pg1-f196.google.com with SMTP id y35so11300861pgl.1
        for <kvm-ppc@vger.kernel.org>; Tue, 01 Oct 2019 23:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wGkCziIraBf0K2OQ69gCFDuWSmrxe04DD64QjeXrGeY=;
        b=mSEzN+94Y5U0W68FCr/mdoQYCuMHkMAU6wsSkV+sT2ZU9sYNKtVKR+E+ZBIrClwP6i
         /moQAnqL8ePsHcW94ijKZ+kNZD2lJiKWiKnV2eaVvTQtjeWBYmIDXvzSiUZizlvaxJm/
         s470+l+QlAutrLqbZW9QYBRfn4e/1Ndg0otr5GcuOUAvnP2UZVe+qumfK0+wDBKkpoaM
         cNLpwpnZ3bgVpcN6gEPRKb1MmuVG/WIwlLxarN2H7+znJ+x8ImJB7WY5OXiIbhOc2snW
         zZDYhsO8EMWQkDxh9/CKRQHCPIZH56hSTz+uR+MRVaX4o5LIstxo6/7s5O8b1WoyP832
         Lg0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wGkCziIraBf0K2OQ69gCFDuWSmrxe04DD64QjeXrGeY=;
        b=d5dyREoEkig2B/OdQTYZ7jD6UhSXEmYHFPf4+mq1ctEKpLh7lcLkujr/eneHxvdFj7
         nkiqowQHGfc0Mh0OoaTHPiBlA66GJDYIzk5QC/TQ4kaYLj1JqKQwnnfVL3LL58Q9Iw2d
         qx33C5GZwY+KnTFdNyct1MmFXrB5TZ9KKRcXSC/Es9TmqrEuRy/9yflStp/RUofYy4Qb
         BZjo2WVuLJZJ977Osftj0i+TFpkayrA/cDf586VZalJ+/F7ynrbGTF4aGFGhP+59FdfA
         dWHhyK7Jo7HQQ/qiKVwNeiTBxnxIAN71oVUrAz/94V8UBhNjQaSrQR1lVFJnog/LniTN
         2hWA==
X-Gm-Message-State: APjAAAWhoU4joTtBWV3JFSwg7olQoTevI0Kcps8zdVsP2cXQ29Yd58Mw
        BIJcNZ8PO5EDZYyxILgLnIEJD4CY
X-Google-Smtp-Source: APXvYqzUk96RZmeSqmbaXBWxPVxoeHdPLYp7RMicR/WOJZdbJjU8AiIPNI4vu0i4WgMeqGeblQU5lg==
X-Received: by 2002:a63:f20d:: with SMTP id v13mr1884584pgh.175.1569996059556;
        Tue, 01 Oct 2019 23:00:59 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id v12sm18660749pgr.31.2019.10.01.23.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 23:00:59 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v2 4/5] KVM: PPC: Book3S HV: Implement LPCR[AIL]=3 mode for injected interrupts
Date:   Wed,  2 Oct 2019 16:00:24 +1000
Message-Id: <20191002060025.11644-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002060025.11644-1-npiggin@gmail.com>
References: <20191002060025.11644-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

kvmppc_inject_interrupt does not implement LPCR[AIL]!=0 modes, which
can result in the guest receiving interrupts as if LPCR[AIL]=0
contrary to the ISA.

In practice, Linux guests cope with this deviation, but it should be
fixed.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_builtin.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 068bee941a71..7cd3cf3d366b 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -792,6 +792,21 @@ static void inject_interrupt(struct kvm_vcpu *vcpu, int vec, u64 srr1_flags)
 	else
 		new_msr |= msr & MSR_TS_MASK;
 
+	/*
+	 * Perform MSR and PC adjustment for LPCR[AIL]=3 if it is set and
+	 * applicable. AIL=2 is not supported.
+	 *
+	 * AIL does not apply to SRESET, MCE, or HMI (which is never
+	 * delivered to the guest), and does not apply if IR=0 or DR=0.
+	 */
+	if (vec != BOOK3S_INTERRUPT_SYSTEM_RESET &&
+	    vec != BOOK3S_INTERRUPT_MACHINE_CHECK &&
+	    (vcpu->arch.vcore->lpcr & LPCR_AIL) == LPCR_AIL_3 &&
+	    (msr & (MSR_IR|MSR_DR)) == (MSR_IR|MSR_DR) ) {
+		new_msr |= MSR_IR | MSR_DR;
+		new_pc += 0xC000000000004000ULL;
+	}
+
 	kvmppc_set_srr0(vcpu, pc);
 	kvmppc_set_srr1(vcpu, (msr & SRR1_MSR_BITS) | srr1_flags);
 	kvmppc_set_pc(vcpu, new_pc);
-- 
2.23.0

