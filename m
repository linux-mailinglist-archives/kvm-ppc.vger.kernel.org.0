Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F3A3250D6
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbhBYNtO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhBYNtI (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:49:08 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6942C0617AA
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:05 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id u12so3320002pjr.2
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q3MbbxrELn+TwojMnsr2Dw3fkqeHU+FUDlPMBwDlaCY=;
        b=mpNscLPSdgLzWsUAfE8EpRXRIM51BpyecMaKWajFv1yfnBmWJ17F6txO5IPVjUJ74L
         r5jJWJYgkwBGx10hHRj2advd8SPjai+3tWj3jnG48SQiYw/bHkdJ9czxHN8BWWnZjOI7
         7mfMQ/xwvhiz8ckx974mi2t3H1AhMbmjYI+XXPpXkt8OY6hz+g+dnCRT1MjHu5NvIy/v
         WTM4NrDFeV/p3R/4FF912bryse8S5F6W1CUXn/BKF5hnuUHMY0vcga/zvSXtyTfyWZDZ
         UguZpSvU4Q2Pdys1uOaG6Hf0aQxhBJp8qoqJJhGhNp500fCOdNpdYP3N1NKzOmt7P5GH
         md6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q3MbbxrELn+TwojMnsr2Dw3fkqeHU+FUDlPMBwDlaCY=;
        b=n0bsOgpD55eMNd5R23I6PQffP53pq9juoVVpX/8aZwz/PfPc40iK62vGPi7PBvc5P8
         jQix8mF0jsH3u2VM56QDYrM9J88ZjsdYc3h7MZOqjqLerYYCI1em/TcfdVJpaeiyJrAn
         xSjy08M91yzjp8PMrl/BJ3aLi4rnlja/lNHBrNkWYZqsYzZT0dP8HqoaXsuVXs07yM7t
         kFJjqPM/+kFOntZAYi2IZYIOffqS7ekCOs+TJNRRV7mPN6x3sDoHQSZ07jiY4FHRWaP9
         nag68Xx5gwy4YiitTqp2oRRQv4/9DpcifR1Ue6OokGaXQyez62k/Csnb9OJrG1mr6Zdr
         1cVg==
X-Gm-Message-State: AOAM532u7nTo3G7kU/QaMLhV2IAnjYomF53RAcb4bxvO3Gu5JoEAOOm6
        JXmQUNjd2aie8KXr329IaTTV2vp88ME=
X-Google-Smtp-Source: ABdhPJxmjVYicu31+Ovtl+bVMxJEtCuzruCMimQ9v0cIdWxEQisZVMGiS7vRy4ElZuhl5mATjEWgpA==
X-Received: by 2002:a17:90a:3804:: with SMTP id w4mr3468161pjb.189.1614260885095;
        Thu, 25 Feb 2021 05:48:05 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:48:04 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 18/37] KVM: PPC: Book3S HV P9: Use large decrementer for HDEC
Date:   Thu, 25 Feb 2021 23:46:33 +1000
Message-Id: <20210225134652.2127648-19-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On processors that don't suppress the HDEC exceptions when LPCR[HDICE]=0,
this could help reduce needless guest exits due to leftover exceptions on
entering the guest.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/time.h | 2 ++
 arch/powerpc/kvm/book3s_hv.c    | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index 8dd3cdb25338..68d94711811e 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -18,6 +18,8 @@
 #include <asm/vdso/timebase.h>
 
 /* time.c */
+extern u64 decrementer_max;
+
 extern unsigned long tb_ticks_per_jiffy;
 extern unsigned long tb_ticks_per_usec;
 extern unsigned long tb_ticks_per_sec;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 63cc92c45c5d..913582bd848f 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3609,7 +3609,8 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 		vc->tb_offset_applied = 0;
 	}
 
-	mtspr(SPRN_HDEC, 0x7fffffff);
+	/* HDEC must be at least as large as DEC, so decrementer_max fits */
+	mtspr(SPRN_HDEC, decrementer_max);
 
 	switch_mmu_to_host_radix(kvm, host_pidr);
 
-- 
2.23.0

