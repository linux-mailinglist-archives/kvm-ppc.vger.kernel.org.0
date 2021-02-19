Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF0C31F528
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Feb 2021 07:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhBSGhP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Feb 2021 01:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhBSGhN (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 Feb 2021 01:37:13 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524E3C061793
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:36:11 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 75so3022943pgf.13
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W8+XAwDLitHtpqcBz+UUYGvTU1Jz8hxN7d0VpM28oVU=;
        b=R2hUk36PrZk+m5BANR8/YzGsIlBdWeLlYg5XcMruyqBTrf+vAScarBWzJe6quESSuH
         6swDVacpXEwdogAuxy9L4IFlGnYI17va0J6vBb00M1KyeE0Q3Ogh+xpUMaFE1clLBfaV
         BG97j79aiw5HQKx3TizhtmMp+Wemm0rG8fCL7QK/t3BRVnW5VvnKte0kkb7zSoe9bBXC
         r7zm17JJYZIBu/Vq6drxHp6mNz5bz/GI1BCw+ByVCBMmkzrfiDPDyEN0EEtUHjfF5jQE
         s85N+zy8Or+1pyaWJKWyjn/H235N1OrOjYTtdch8gL52C039o0W2bSZIE5w5Xjm/3j1E
         1QLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W8+XAwDLitHtpqcBz+UUYGvTU1Jz8hxN7d0VpM28oVU=;
        b=eHEYfhH7MvvpEa70Ruqe09zAt0etAxCjA8msmTuY4yjE0KXgBQ5yzU6K8VDSvvl4Ja
         YTDnbRUsUl/q9k18MxqHruhjFwr0FXbk4Q2CXat4ZW+j2YBEuuWcFU7aJQijTthaftH5
         f6H2f8BxbZpR79EFQiecxfEcCzo4Z8tOoqaGyCplMaGqXn/lU/c9Airxok8KjI5esaG9
         AfpuziHY9AYBBRusXiOc94tiPueFGY7P3YEwTfl9u5ymefdHZl2v+Th7c4aQIxqJjorw
         zafUL1cH0McYR6vCdrIAUv23hUV7QKvwmCWomZG9OrYrmrHjBGqCpdYwt37npIDQ1Lg5
         jiQA==
X-Gm-Message-State: AOAM531SE4Y+Cqm7FpucVUG5bYukDKKOOjjWS0RqFoVuxuEhpN73PeQX
        TSAUclq0DfdOW6KcBZYJWVL/cgyNYnc=
X-Google-Smtp-Source: ABdhPJwRpbNptHrj1QsJwW4+zC4Ap7NkG+9wYHmeCiZXxziC9W0JbnZRZ9DnUkrClDmZ7PLHwIaxwQ==
X-Received: by 2002:a65:654e:: with SMTP id a14mr7402331pgw.265.1613716570533;
        Thu, 18 Feb 2021 22:36:10 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (14-201-150-91.tpgi.com.au. [14.201.150.91])
        by smtp.gmail.com with ESMTPSA id v16sm7813099pfu.76.2021.02.18.22.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 22:36:09 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH 07/13] KVM: PPC: Book3S 64: add hcall interrupt handler
Date:   Fri, 19 Feb 2021 16:35:36 +1000
Message-Id: <20210219063542.1425130-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210219063542.1425130-1-npiggin@gmail.com>
References: <20210219063542.1425130-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Add a separate hcall entry point. This can be used to deal with the
different calling convention.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/exceptions-64s.S | 4 ++--
 arch/powerpc/kvm/book3s_64_entry.S   | 6 +++++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 96f22c582213..a61a45704925 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -2023,13 +2023,13 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	 * Requires __LOAD_FAR_HANDLER beause kvmppc_interrupt lives
 	 * outside the head section.
 	 */
-	__LOAD_FAR_HANDLER(r10, kvmppc_interrupt)
+	__LOAD_FAR_HANDLER(r10, kvmppc_hcall)
 	mtctr   r10
 	ld	r10,PACA_EXGEN+EX_R10(r13)
 	bctr
 #else
 	ld	r10,PACA_EXGEN+EX_R10(r13)
-	b       kvmppc_interrupt
+	b       kvmppc_hcall
 #endif
 #endif
 
diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
index 820d103e5f50..53addbbe7b1a 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -7,9 +7,13 @@
 #include <asm/reg.h>
 
 /*
- * This is branched to from interrupt handlers in exception-64s.S which set
+ * These are branched to from interrupt handlers in exception-64s.S which set
  * IKVM_REAL or IKVM_VIRT, if HSTATE_IN_GUEST was found to be non-zero.
  */
+.global	kvmppc_hcall
+.balign IFETCH_ALIGN_BYTES
+kvmppc_hcall:
+
 .global	kvmppc_interrupt
 .balign IFETCH_ALIGN_BYTES
 kvmppc_interrupt:
-- 
2.23.0

