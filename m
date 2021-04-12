Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B4F35B837
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Apr 2021 03:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbhDLBtO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 11 Apr 2021 21:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbhDLBtO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 11 Apr 2021 21:49:14 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4391AC061574
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:48:57 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id w8so4701996pfn.9
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aLyKsyw9sIoArVGBtYw5cRtydAgVXgDSKIe0OwzaCV4=;
        b=jXw/0pSPTFSGWIdK+HT4jurvmUaZzcuX7h66cpcjF3Sjg5rO7ma6aElWYfxb6fA2EK
         xHRHvjFCi8716ayxrFTXzww59CY1hpcGiLrRG4WMUxzupX81p1L0ZZega/toc1mEa8t/
         AAjBj1TbZTOAgWui7684KS5z4NXThpRjzCkHj24xtPH4oApe9+wbgkT5VKPCy0Eiad30
         LU5nn8u96bG/YPJo53hTmZW7lbuglZ+r6ak2avNU6CAWhKLpvJ6AJ2EZkY6p5whrUuy5
         02Tu4rSZjlMEZOLgB3vUrTJEfpuLtBOt2Ce32+Pmc0S9LwB3LSlRWMauQNLHnFxRS5RU
         SMFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aLyKsyw9sIoArVGBtYw5cRtydAgVXgDSKIe0OwzaCV4=;
        b=N+qoqWVsGwwHo/a5HefsorI7BlFgUy7ZP32MtKsFXNH2GITp2sAb2EVqViHObh9Cdi
         K4Lb3UZ6RZhXRwhD6rgy1c0NiMw81yzjvjbDnnWCQO2w6qj6RM5tGrR9GEGMBcQxUceq
         4/0TrO6v3FCpyNz5bdyQI4Rke9xWrG+5edyILurjvLEadw/7B8drUBRtvjPVjK3V9cVj
         wi6aZlWeZuBhIUZ1VVC9uYrL7SDjPHNwPXS30pyBK2U0PPeb6D9L6DFlqlPHa6DKguaK
         5laeDrDA1G/splnlKRb+3K2f7ovuOjspY36g86GzURTzhTAuV/0HJ/AirZ0kK7TqXxiR
         poag==
X-Gm-Message-State: AOAM533ntqLnZLNBaFgyiEpYhMMbnla2UvwNldnSuPifWigZQj5EQ7/R
        5BgqlbRSCHxwVtsc/TT25hT6nudIRW4=
X-Google-Smtp-Source: ABdhPJwVVgyG2pNezNnGPNdHbgDY56uIPCUnZowGZA2eA7iggYrIDec+aRlb9vDLZxXwYU/wXMudRg==
X-Received: by 2002:a62:5cc7:0:b029:24b:3525:9dbd with SMTP id q190-20020a625cc70000b029024b35259dbdmr5561696pfb.3.1618192136638;
        Sun, 11 Apr 2021 18:48:56 -0700 (PDT)
Received: from bobo.ibm.com (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id m9sm9502345pgt.65.2021.04.11.18.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:48:56 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 01/12] KVM: PPC: Book3S HV P9: Restore host CTRL SPR after guest exit
Date:   Mon, 12 Apr 2021 11:48:34 +1000
Message-Id: <20210412014845.1517916-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210412014845.1517916-1-npiggin@gmail.com>
References: <20210412014845.1517916-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The host CTRL (runlatch) value is not restored after guest exit. The
host CTRL should always be 1 except in CPU idle code, so this can result
in the host running with runlatch clear, and potentially switching to
a different vCPU which then runs with runlatch clear as well.

This has little effect on P9 machines, CTRL is only responsible for some
PMU counter logic in the host and so other than corner cases of software
relying on that, or explicitly reading the runlatch value (Linux does
not appear to be affected but it's possible non-Linux guests could be),
there should be no execution correctness problem, though it could be
used as a covert channel between guests.

There may be microcontrollers, firmware or monitoring tools that sample
the runlatch value out-of-band, however since the register is writable
by guests, these values would (should) not be relied upon for correct
operation of the host, so suboptimal performance or incorrect reporting
should be the worst problem.

Fixes: 95a6432ce9038 ("KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 13bad6bf4c95..208a053c9adf 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3728,7 +3728,10 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vcpu->arch.dec_expires = dec + tb;
 	vcpu->cpu = -1;
 	vcpu->arch.thread_cpu = -1;
+	/* Save guest CTRL register, set runlatch to 1 */
 	vcpu->arch.ctrl = mfspr(SPRN_CTRLF);
+	if (!(vcpu->arch.ctrl & 1))
+		mtspr(SPRN_CTRLT, vcpu->arch.ctrl | 1);
 
 	vcpu->arch.iamr = mfspr(SPRN_IAMR);
 	vcpu->arch.pspb = mfspr(SPRN_PSPB);
-- 
2.23.0

