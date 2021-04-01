Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EF335182D
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 19:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbhDARoP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 13:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234676AbhDARjH (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 13:39:07 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FE5C00F7C3
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:05:18 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id y32so1681692pga.11
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aeSz2UYkwPYdoW0B1VQ6zrxPMp46nIsZCAH44O8XJ84=;
        b=YX/oyqVOl9TLJI/M8N6dyYXSttgxmMfM6jvoC2xj0WfaY73yiiDGHAdn6OEpjqoo7Y
         l4Rvq4DHFFEcymlmQQcbRhqwXabdM0DCZ4WYhQttG1/7cUUT6alaEY94AOb8pLv5doqz
         h7A5zKqo6A3bY7DumqIYavVO15sEGX+X8HzbqM4OxdVwNL/7hGY6y9Xs8pJqPETHllHd
         JLRgtS7WERYrsJ/t9YyVD87QUkPkeoeuifrJ1lcfNDV4tq4jqFTLi62z5OW/Fs3skU0B
         Il6EqiRGmO/uvbzFnPXI+ELyYftNxTwdR8iir2tbeGHEKV/vB0eCmEd3yw0ySZXJUnLJ
         IG1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aeSz2UYkwPYdoW0B1VQ6zrxPMp46nIsZCAH44O8XJ84=;
        b=rOX8tatKzOnEgyNA5C2SWBpzJzdQXXumWfGuXfBcO2ErwzrgTVSMyq74kwlwJjEDiB
         wPwsG0advXYj7KActqAcoMI2yE94iK6GPzBSRExi9M1UV/OpzvCXrZTYPhBTzYJsJWCN
         2Ov4/XLpMO0hO++ki7N0dfmAirnytIuPLQfL/Nd0q16ddOcQivaFTJbMbgmuDBk4BpAh
         BEfkMlKIS0AKEd7Hr4DjW/WjdJ6NOY47Y6SZV3OHEMdj6g+5BB613XS0uPHZ2qYpEnqc
         JZU3P7mZJMYySDdkOrtdsfv9kic84Hnsvo36onFdwS0Olex5OHzB+XctHtb/4Ot93qm5
         x1/Q==
X-Gm-Message-State: AOAM533XAFXAPIIjzx83CgCXoYCv5DX124+kZ6oM9Qbwh1PLJM4pwHxh
        N6MA0tEFVKxKhTusQeH2xD39DVWW1JM=
X-Google-Smtp-Source: ABdhPJzSmVhqQGkO+CsjlirMUx9DKYORF+Wj+FR2Wb5j9FMRqGJZdkw0r1GKs/ZtpwuTJgVxMMbPqA==
X-Received: by 2002:a62:170e:0:b029:1fa:7161:fd71 with SMTP id 14-20020a62170e0000b02901fa7161fd71mr7741392pfx.35.1617289518056;
        Thu, 01 Apr 2021 08:05:18 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:05:17 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v5 33/48] KVM: PPC: Book3S HV P9: Improve exit timing accounting coverage
Date:   Fri,  2 Apr 2021 01:03:10 +1000
Message-Id: <20210401150325.442125-34-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
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
index e419b23faa16..62cf0907e2a1 100644
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

