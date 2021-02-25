Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D013250B8
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbhBYNsA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhBYNr7 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:47:59 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428B1C061788
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:19 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id o22so5063271pjs.1
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eJhojtxV4qkzw509yP6Eq/ZPkxtU7/fUkZd3OCkgR3c=;
        b=OPHu1jGz9QvQ28B3ue7zbnd81xaCapKmz+ha0rh06dZZFqf6JHdholBZwFdPYXZuSi
         QJyFsGVusNacpanQWnLBFrpXQieY/L2gm9N/DQ1PCGTpgFgunUCRBE7f3Fsu4lZrnA73
         RHHANpxa1j9t/WQdLs1KurNglGkt8wH0HNQcFWkgk4b+5IRpv+N402x8YH9lwnatE00V
         uztsvC/8Jo59deOsARo6I/XKl4SbnJABkrQvKWhOEotTC/7/iE1hYVYpuRd7/LO8rl9A
         hmR31ce1LT94V7wuB3CJKOHaFmdzppfgQSpkt6RRtX51Q27OXmbv9S1dB8zduUBVNvO1
         ixLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eJhojtxV4qkzw509yP6Eq/ZPkxtU7/fUkZd3OCkgR3c=;
        b=mHevcUg1x459YqLHxKZsAqlRN5xz+BHqrYj+pWs4cAW6LXDehT+6WgK/EVHMkXGiT6
         Ype0rQKGUiPXQSLjdcxPU8PX0zX9CjvAh5RNlNFny3a6CxBsrKFgLuPraYOZGKlT6lVH
         +pvAjWuJDNronTOhLpDKcnXzXamOZQ8RNjrcR/VrS59QNQ3XhJsVFs6Pe/CTe4K8eRmS
         yuoacgnedhyRLPxTIp8vjgIt9uTg/0XI3XGE+KR+Dqt0X+bPGFT+IU8DSndCy8X0nhvQ
         T7p0zxTQrsXdHf+98XkUAnXWuBeZQ6moHPZsWSbIkCMW/I1WWkBT60c3yqoJiWQcbGeg
         GTiA==
X-Gm-Message-State: AOAM532Qk9YKA3gsayAJPJJJjwABCjvAIf17WauYqEC9tsrByCp4gXnI
        pZ2NAbmZirdwDAOKJj14X6uQWdIEtYw=
X-Google-Smtp-Source: ABdhPJyED+odZHpmKwwIYH5DXmA56S7BR1QQijuJXU5K+rDhmPiyYkAyb/pfD9IzVSieJVFjAaUYyw==
X-Received: by 2002:a17:902:e54e:b029:de:8c70:2ec4 with SMTP id n14-20020a170902e54eb02900de8c702ec4mr3260154plf.56.1614260838408;
        Thu, 25 Feb 2021 05:47:18 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:47:17 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v2 04/37] powerpc/64s: remove KVM SKIP test from instruction breakpoint handler
Date:   Thu, 25 Feb 2021 23:46:19 +1000
Message-Id: <20210225134652.2127648-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
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

