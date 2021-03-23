Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FC734548D
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhCWBFV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbhCWBEy (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:04:54 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E0CC061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:53 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id c17so5628401pfn.6
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6Bs7XHUMbIVuw7QkJEX6gwpyVXR4AO2//Bxh2Wns9Vc=;
        b=HuOsbnzoWSo5wPcaNBAbd+S9V/AFZxTBfRCDdRl4NHB7haqnRXMZaQG/K5jaj/mTcN
         SNWFCa7wjXWXp3DTyRMrC0cdsQWPduJbtDImFxC+5RXR1jTM3kXEHVRV+jfUq50M9zfW
         THWSbSeSCuOXbq4ANET5KlfbSODBAok8bLrlGWPoOxBsaFM6qX4OhQbixjaBm0Na+izH
         1lbxKVzc9IE3OyI9DLRfDOKaVQAmzURLpXriqj2vBkrgqtjW5BksVbPSsTv3PEJ7UAR9
         XTYIivrYDYZxryHUUFAg9jkkeXqj/9ig2sOaw7T/RbhdKQe3+uWYoJ6kuWvVFt86ergV
         K2/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6Bs7XHUMbIVuw7QkJEX6gwpyVXR4AO2//Bxh2Wns9Vc=;
        b=bUHXdw3Hy9cXpQ4z9P2AU81Dk391lG9YCo+Y3xITht1Vg3rQ73zkqFoLLAtPhnsXgL
         +CpNUVb9ON0qAZ9c1uTm7cx4+N/cNCwhCLibua3/clzfFCGiZHzNlZmM466OPvUTJ88U
         OJDkFd6ji6KQtiwcBEeKLIKbeyqPB+D/9KvAOZmFLPYxrRKXXHXsrUI7XiK8URGjUOs5
         FoMymP50ycN7ctqx2Kht/gfuyQgNusm9FPyQlNwc3LIKCEGd4t9Ma8qlfn1CBTNXwjnk
         7pgqmY0GkLPUJfB35aGKfR8AlarU5VxvyMSpZvuEYVxRREAmL2+Slfc5AUxwhl1+765O
         0BWQ==
X-Gm-Message-State: AOAM532CuEV0+1bc8ypF4KXiKZcesjSgkFXpAUvxfZZM6jUASUNzw6eD
        IxU/iMf5f1remXesrUm1MjTId7NeEco=
X-Google-Smtp-Source: ABdhPJy9ia9LiBiNlH+5PtjdyP/GaYHOKYdX4afOPn6Zs/CGfDOOVAW6b2TeBm2rMl/CoOxQDmQlLw==
X-Received: by 2002:a62:2a8b:0:b029:21c:3016:3a9f with SMTP id q133-20020a622a8b0000b029021c30163a9fmr1565590pfq.38.1616461492867;
        Mon, 22 Mar 2021 18:04:52 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:04:51 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 32/46] KVM: PPC: Book3S HV P9: Improve exit timing accounting coverage
Date:   Tue, 23 Mar 2021 11:02:51 +1000
Message-Id: <20210323010305.1045293-33-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
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
index a7e5628ac36c..4058a325a7f0 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -159,6 +159,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	if (hdec < 0)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
 
+	start_timing(vcpu, &vcpu->arch.rm_entry);
+
 	if (vc->tb_offset) {
 		u64 new_tb = tb + vc->tb_offset;
 		mtspr(SPRN_TBU40, new_tb);
@@ -209,8 +211,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	 */
 	mtspr(SPRN_HDEC, hdec);
 
-	start_timing(vcpu, &vcpu->arch.rm_entry);
-
 	vcpu->arch.ceded = 0;
 
 	WARN_ON_ONCE(vcpu->arch.shregs.msr & MSR_HV);
@@ -354,8 +354,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	accumulate_time(vcpu, &vcpu->arch.rm_exit);
 
-	end_timing(vcpu);
-
 	/* Advance host PURR/SPURR by the amount used by guest */
 	purr = mfspr(SPRN_PURR);
 	spurr = mfspr(SPRN_SPURR);
@@ -420,6 +418,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	switch_mmu_to_host_radix(kvm, host_pidr);
 
+	end_timing(vcpu);
+
 	return trap;
 }
 EXPORT_SYMBOL_GPL(kvmhv_vcpu_entry_p9);
-- 
2.23.0

