Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD5E353AAA
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbhDEBWC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbhDEBWB (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:22:01 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFEA7C061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:21:55 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id z12so863831plb.9
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S1/wLv6JH1sf1fLvgZJI8q0x4TVI1vTVyQKpt0OY8xU=;
        b=NWlVgz69yj6AWGgJ6H1qkeg0I17SG6FhY6bKCuPGszzvL8bcvL/M5+2KtsT6lcNMO+
         H0it5QvZ0jh8d4zObf/uupQXBA5VK+LR/dBQO9lloi3fXMdVvpBRQJY3aumB6zYM9rpn
         /86H4PlqdyAlIWHKGnhGQMMHM0NsdJIDjOYqPsiegRzoIS4Gh3NoMhkjB010vjXdVGqF
         HiCxuw6IJEWhTDZV+rxCGC5FedTtKu34W8IKLtGFR0b83jl6eILYquxil6JFJLV8/obd
         etuJABWBuOJGTGoKp1rHhrR/Sld9tmTzx4CkvA0RqTsT4eShLtpxO9pnL/LWEsMq2W9t
         AiAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S1/wLv6JH1sf1fLvgZJI8q0x4TVI1vTVyQKpt0OY8xU=;
        b=jPAsEd5VSZNKDBcGIEZwFGExeO5EqKiCoE13GnmNlPd9fPBBxpeQ62IT/3K0TQPwgl
         1QBCHYgK+MphxgwjmOU1gLEbrqg2HdQc8duNzJbWXQlw5DOKisqmXzbR63OzeYnlfuMp
         wn2w1+UvdSQXgraxEq1Crhi8DWF/U4/533wGYLmtmpx0tLIsuCjY5qx2fw+Il4xAGcaX
         qjHtIxy82tqIUN2D3MOFI4pX/K7+qQbIrDhtUe1AHrsc+htxKRptwiaGJhN6xmWMLKaM
         gpJOIouzKfVHy9s1uKqt+h4CfPKHCZ/I0DTnIQqDGEECM5LzncnSHRBDUN5sA1jfI5/L
         XNRw==
X-Gm-Message-State: AOAM533JEj4jsxGY0DvdfY1/UzaomneNKIW/FteuvmAD4VkvW105j98U
        yvY3wQqeHAqNJX4Tmxz/XAhjdrY0aam/Wg==
X-Google-Smtp-Source: ABdhPJxkEQxlb7eZ2ibgPEgugM6FftrbQed36RZUUwugq3af2SEZ/9DUcu58amm9JQIaj8nFxO/BVw==
X-Received: by 2002:a17:902:704b:b029:e9:b5e:5333 with SMTP id h11-20020a170902704bb02900e90b5e5333mr2890781plt.78.1617585715349;
        Sun, 04 Apr 2021 18:21:55 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:21:55 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v6 33/48] KVM: PPC: Book3S HV P9: Improve exit timing accounting coverage
Date:   Mon,  5 Apr 2021 11:19:33 +1000
Message-Id: <20210405011948.675354-34-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The C conversion caused exit timing to become a bit cramped. Expand it
to cover more of the entry and exit code.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_interrupt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/book3s_hv_interrupt.c
index e93d2a6456ff..44c77f907f91 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -154,6 +154,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	if (hdec < 0)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
 
+	start_timing(vcpu, &vcpu->arch.rm_entry);
+
 	if (vc->tb_offset) {
 		u64 new_tb = tb + vc->tb_offset;
 		mtspr(SPRN_TBU40, new_tb);
@@ -204,8 +206,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	 */
 	mtspr(SPRN_HDEC, hdec);
 
-	start_timing(vcpu, &vcpu->arch.rm_entry);
-
 	vcpu->arch.ceded = 0;
 
 	WARN_ON_ONCE(vcpu->arch.shregs.msr & MSR_HV);
@@ -349,8 +349,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	accumulate_time(vcpu, &vcpu->arch.rm_exit);
 
-	end_timing(vcpu);
-
 	/* Advance host PURR/SPURR by the amount used by guest */
 	purr = mfspr(SPRN_PURR);
 	spurr = mfspr(SPRN_SPURR);
@@ -415,6 +413,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	switch_mmu_to_host_radix(kvm, host_pidr);
 
+	end_timing(vcpu);
+
 	return trap;
 }
 EXPORT_SYMBOL_GPL(kvmhv_vcpu_entry_p9);
-- 
2.23.0

