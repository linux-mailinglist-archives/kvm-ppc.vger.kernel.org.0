Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1D542134B
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbhJDQDF (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236224AbhJDQDD (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:03:03 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68556C061749
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:01:14 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id r201so11050237pgr.4
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hMnfSI9yoYDLSGnaeQ8njs+W5jZFdB15MADSAiJvUEw=;
        b=ppT4rhgi7tPQR7SsM3YfqL0KOJuWrKrQIQq4bPVblWzLiWoU6a5KgtfI+83w7lMmOJ
         0ZIDs7yUqSUYm1VePY8xY9LyBvV5MlnUEeCVyKuFc2xsK5iPQkFoAWc27QQReluVGnsH
         sp9Chm5oeI1JjqJfWD7IqDgTOND2W2OP71rFxeHtQLv6m44NtBl34uaJeCJ5z3n/GYDQ
         6uqeh+P8N06eOsogFVjBKKnyja0OFayl76vqjygyFpdOunQ/hIvQcf+1Ud5gREGY6hxf
         ZpEW/I6zmXxUdY8UHu1FGGmMdtXkQdZ012Skp2nl2ZdtFSW82t49YUW7LjCr7Z1gc6ni
         VeVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hMnfSI9yoYDLSGnaeQ8njs+W5jZFdB15MADSAiJvUEw=;
        b=A6uakDvWXQkGyMwmowDEviVrBc7t6sDFelttChAd3X9F6VVF/QxB9PkJR4nSFEZDFO
         QJT+Bdl94dGDhSRfaRcmkPu2WacxMCGfhejE4zj/N33ZvQ243OoLvs+L2ClT1BW0+jxn
         r4Kn7BHCvc36aoc0n7o5kmzYeScK7K/HJSq7uHd2S/l6oCMCoNfS3KX3igUv2QryFErm
         g0uuUKC8hxyZyT7JpxHjNdJx0h1f9eOvzcyNCz3euJRcSbrQzF93T8M5EPh9FvbuN5Jm
         5Dy+rtZZEE9d7AUBjaAdKMVPghGJHJbiZPMyYzAih/zdCSbCJ/XTK5nP7MxyRSsYQdru
         4qtA==
X-Gm-Message-State: AOAM533WdBQuVBVzlZJAbVJDdYEKn/U9S/jjVDxOP8pdMwiG9BEb3Q9D
        ZCDHNOZdNrhW2T1hSDd4WWsXMriXVfI=
X-Google-Smtp-Source: ABdhPJwBEERy2/Zuis0y01OsZytQQuADMZSXP9p0pINGWMFGJT+ZQ3gK+36xzer61qzfNvLJPYZGug==
X-Received: by 2002:a63:131f:: with SMTP id i31mr11631459pgl.207.1633363273842;
        Mon, 04 Oct 2021 09:01:13 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:01:13 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v3 05/52] KVM: PPC: Book3S HV P9: Use large decrementer for HDEC
Date:   Tue,  5 Oct 2021 02:00:02 +1000
Message-Id: <20211004160049.1338837-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On processors that don't suppress the HDEC exceptions when LPCR[HDICE]=0,
this could help reduce needless guest exits due to leftover exceptions on
entering the guest.

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/time.h       | 2 ++
 arch/powerpc/kernel/time.c            | 1 +
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 3 ++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index fd09b4797fd7..69b6be617772 100644
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
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index e84a087223ce..6ce40d2ac201 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -88,6 +88,7 @@ static struct clocksource clocksource_timebase = {
 
 #define DECREMENTER_DEFAULT_MAX 0x7FFFFFFF
 u64 decrementer_max = DECREMENTER_DEFAULT_MAX;
+EXPORT_SYMBOL_GPL(decrementer_max); /* for KVM HDEC */
 
 static int decrementer_set_next_event(unsigned long evt,
 				      struct clock_event_device *dev);
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 961b3d70483c..0ff9ddb5e7ca 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -504,7 +504,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		vc->tb_offset_applied = 0;
 	}
 
-	mtspr(SPRN_HDEC, 0x7fffffff);
+	/* HDEC must be at least as large as DEC, so decrementer_max fits */
+	mtspr(SPRN_HDEC, decrementer_max);
 
 	save_clear_guest_mmu(kvm, vcpu);
 	switch_mmu_to_host(kvm, host_pidr);
-- 
2.23.0

