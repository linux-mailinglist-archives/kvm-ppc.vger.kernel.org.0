Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8313332EDC9
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhCEPHl (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbhCEPHM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:07:12 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4C1C061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:07:11 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id bj7so2203784pjb.2
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M/9pLvHjgsuLCE6pHCPiCdL1oBObGuiPVVUyPiGkWZU=;
        b=ueRkePuvqOezhSuwk/Ngsf9NT32sJ20qRbVioCWiJZJGbtfAP4zSuVZu0a3qwwE2Ni
         3PyVllKl9JUr8CAMd2q18ybLjua8QblZGFVTo9laatS9uL1eb+qUqN8kxOdCu1sK3hS/
         MGzW6t7FN1HrStwbkVfSqSgb7PFWaOlhtLBqgbTkqB9g5IeGyp56vIa0DO846/nEn1hl
         3QnJuFDpNFceWF3wdfPJP+8EFCT+pak9RutnT05Wr8q3xu8oyVbFIfMxhz/FgKIO2ihK
         EVExM7Jg4+6e6aXKHs1qTpzhpMwMgiL0cIYx+JZD+u58fxoJkeekJSCl5x95h37LPf0F
         llNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M/9pLvHjgsuLCE6pHCPiCdL1oBObGuiPVVUyPiGkWZU=;
        b=nI9X+4f+eEF2lRxv+SobhgSW3fR9qf6nnyMmqlnI5VxON/pay0FVsdRW/YrUOJXrA4
         42mbqEX5DwGyDSkBO9y48s8ZWBl7SfaYJwFPoRpkhXgXZO1w6pPP618HvY2rcriEj/A0
         nRP8HtXWHv9u5T7mUtwv4/8mDzhK4L4xbaL80DmLG/KumSLF5ahW0/0EetMytRp1E3/Z
         kx2VKtQl7xDgN/q2lwgDl3YmjrSY4yxsPjrtxa+2OCfV5ead7vOXWPKZodt7EQkO07I/
         zUeUlKvd4phD+5w+s3YzJ2+tfsy3Bq0hfGwLjpujYkVYRRh6VCzT8Iqgn9v99h86PDSU
         fyEw==
X-Gm-Message-State: AOAM533SIyHUHG/8xC5QWJKD9XREE0RWWNxrNH233EnnmENrXT0iJdXh
        /icYdjWcXK6Rt44kxZreeGxntRxtRkU=
X-Google-Smtp-Source: ABdhPJyGfRrSfR4JvRpTQwHxApWefn7VHhJj5tBlCD623Uy/vrh8l4AdA0O6qs1tiVwrz+GS2lWK2g==
X-Received: by 2002:a17:902:9b93:b029:e0:a40b:cbd7 with SMTP id y19-20020a1709029b93b02900e0a40bcbd7mr8885799plp.16.1614956831173;
        Fri, 05 Mar 2021 07:07:11 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:07:10 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Daniel Axtens <dja@axtens.net>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v3 07/41] powerpc/64s: remove KVM SKIP test from instruction breakpoint handler
Date:   Sat,  6 Mar 2021 01:06:04 +1000
Message-Id: <20210305150638.2675513-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The code being executed in KVM_GUEST_MODE_SKIP is hypervisor code with
MSR[IR]=0, so the faults of concern are the d-side ones caused by access
to guest context by the hypervisor.

Instruction breakpoint interrupts are not a concern here. It's unlikely
any good would come of causing breaks in this code, but skipping the
instruction that caused it won't help matters (e.g., skip the mtmsr that
sets MSR[DR]=0 or clears KVM_GUEST_MODE_SKIP).

Reviewed-by: Daniel Axtens <dja@axtens.net>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/exceptions-64s.S | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index a027600beeb1..0097e0676ed7 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -2553,7 +2553,6 @@ EXC_VIRT_NONE(0x5200, 0x100)
 INT_DEFINE_BEGIN(instruction_breakpoint)
 	IVEC=0x1300
 #ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
-	IKVM_SKIP=1
 	IKVM_REAL=1
 #endif
 INT_DEFINE_END(instruction_breakpoint)
-- 
2.23.0

