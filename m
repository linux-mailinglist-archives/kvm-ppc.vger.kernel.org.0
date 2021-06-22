Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC6B3B01F3
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhFVLA0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbhFVLAX (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:00:23 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8E8C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:06 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id m15-20020a17090a5a4fb029016f385ffad0so2050579pji.0
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YQJWOtbVkwPNfO/EI9YLyg8Eje9VJUdj6/oFZO50+yM=;
        b=CttVOXAEieVfIWAjlLClXAP/Yt9dIqUR+19jk3zfIdCRQ65EB9WOBwqJp7Vj3R7sjn
         9ZV/SyoEtdYKzpIGDyQR7xD7l+NMIeSx/6Waa5akn7ioeJ5s5d8ODHqLVIuctxot+HcZ
         y7qM/ZXeTrR1mLbbHyuXBqUN2gTWgjQC9IlxdZELWqYrfSWznlVZJWWPfqzLJ3OtDcz2
         ehKDO2ovDki3u3zF3AO/N+3huo71ABX7Zgjj1Sya+8yTmHa7aC0vQOynvDQNq42TAf/f
         VLboVnvjM5v/bxBbu6dWKeoUGWNKPNtwUySgO9siNAMQygSOya9dM9F5NWo1Z1BdXVBX
         a0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YQJWOtbVkwPNfO/EI9YLyg8Eje9VJUdj6/oFZO50+yM=;
        b=my0O5JlMEfY4McBsedssnO6KgY1FkHLdxoRf9B+QjNWgDZg07JAghWwWKQ67yS91dy
         w97B/V0YCuGsPCqHglAED6M4pp3nafuMgcxe75rkHI12BGat90tmnyorQsWchv62DZtb
         G/hbDA+hrixqNqg6VH+G5shEMP36YeW2X0xdamEqhw7j9Yd+P2fplGl5hRTbuavBKqed
         MjNeDyy//KomzD93zZ4JuxV8Z4k64Q75pleA5QYAJBOMGXNTZb7861TNckd6Q0/aiq2G
         HTu/qCXekYOqtgeEW86Gr43iVLhY84vhi4bSDLO2/OJ1V24yzXzOnmNpp/6AV/IMuZMp
         NlUA==
X-Gm-Message-State: AOAM530j3FwhzTmp6BKg4oPnL8cqUAthYGLmDub5LE1bLmUhDBdjZ0Dw
        e8RDgPFZ333J5BZXg8SgtVnV/ht4EVM=
X-Google-Smtp-Source: ABdhPJz7ui0cU6tQe5H0CFwHQ5+WG98e9YSqOP6tcADVcEZhM8JvVDHp7Q54ImYjDIG0Zp1QW5C+DQ==
X-Received: by 2002:a17:90a:8804:: with SMTP id s4mr3262818pjn.200.1624359486446;
        Tue, 22 Jun 2021 03:58:06 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:58:06 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [RFC PATCH 04/43] KVM: PPC: Book3S HV P9: Use large decrementer for HDEC
Date:   Tue, 22 Jun 2021 20:56:57 +1000
Message-Id: <20210622105736.633352-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
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
index 98bdd96141f2..026b3c0b648c 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -89,6 +89,7 @@ static struct clocksource clocksource_timebase = {
 
 #define DECREMENTER_DEFAULT_MAX 0x7FFFFFFF
 u64 decrementer_max = DECREMENTER_DEFAULT_MAX;
+EXPORT_SYMBOL_GPL(decrementer_max); /* for KVM HDEC */
 
 static int decrementer_set_next_event(unsigned long evt,
 				      struct clock_event_device *dev);
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 83f592eadcd2..63afd277c5f3 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -489,7 +489,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		vc->tb_offset_applied = 0;
 	}
 
-	mtspr(SPRN_HDEC, 0x7fffffff);
+	/* HDEC must be at least as large as DEC, so decrementer_max fits */
+	mtspr(SPRN_HDEC, decrementer_max);
 
 	save_clear_guest_mmu(kvm, vcpu);
 	switch_mmu_to_host(kvm, host_pidr);
-- 
2.23.0

