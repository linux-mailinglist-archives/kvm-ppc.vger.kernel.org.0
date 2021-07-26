Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A8E3D51D1
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbhGZDLp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbhGZDLk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:11:40 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FC1C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:09 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n10so10141462plf.4
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I/TJyOnmABEE9AkNTcVjeb806PCZeTTaeMWQWBzIZXw=;
        b=SX6rBbXmeohLYDiGBmdYikgQxBkPOKkSixP00Rb1Nm7DLPofm/Hn7FVKh7zTRTvoug
         gJiw4ubHPfOde/XFILOW6YdWCSjHCoeh4IjxHnyqoRan0zxBrNnTB7aZN/mNw0EkLBph
         M3x4gSvR6KGwLwgPnzioW3xibNHcBnzsXAm73pJmANcQBwlbOx/YgACZGm32NkMrYxkk
         L2ghSu4xOzJ1W0h5SYnPIuToFvt4MTf56IJXxbLHDcDKSr5S0n4N+OOtjVEdohQY0FCm
         W5t7YlpWo/QZpadXlWIb0dBsLmB2IPBYNwl4CeXOEeVz2AlNGSHZNQbKbYHQYOTlb6+a
         RNoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I/TJyOnmABEE9AkNTcVjeb806PCZeTTaeMWQWBzIZXw=;
        b=TKFN8hK5H6O7WL6Yzf2BXU3pUj5EUOEU2+8Ezqp9xOhiYnNnhUeVJi+VKtB19NHypR
         iNcdgKGbjEYPpD3Vu3CbQw5nItdkmvMiutyzq0JN9iM99W5p7Zk/WVhSk/gwWZWPJMVt
         9Tm34s6jeO4bE+7+gGdov8nwTYY30B54p1Q3zQ5fU4GjsCwBv4gmzqEXEsNcoHcQFNz8
         YzqZL+SFs7BGSZrZApWQU0TKNcXrp3gSZ67sK7cpNDH6aZjZqyuaqyIbyJmh0e7PXKxc
         tBQkGz7jpMUkmkVhX6TCw9JqjjMAAshoKSTUcSTh7y/qMkOqYjhubKKJaVOFrAiswC+D
         9jSw==
X-Gm-Message-State: AOAM532UYBG1T3s3gmj8fQInURuJjDju5zowG0W2DZxIUjtd+66F7J/+
        7yDi2ZjgyrkbV5eYMfWKp5ne1Y18I70=
X-Google-Smtp-Source: ABdhPJwbjlo5VbE7IwK1qAiTSiFySOjd7sqAjrEDnb5ZUOg4q6E0ClnLPxIIyKgTP3ns+CZ23MwUqA==
X-Received: by 2002:a62:cfc4:0:b029:2fe:eaf8:8012 with SMTP id b187-20020a62cfc40000b02902feeaf88012mr15654662pfg.45.1627271528553;
        Sun, 25 Jul 2021 20:52:08 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:52:08 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 36/55] KVM: PPC: Book3S HV P9: Implement TM fastpath for guest entry/exit
Date:   Mon, 26 Jul 2021 13:50:17 +1000
Message-Id: <20210726035036.739609-37-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

If TM is not active, only TM register state needs to be saved.

-348 cycles (7218) POWER9 virt-mode NULL hcall

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index ea531f76f116..2e7498817b2e 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -281,8 +281,15 @@ bool load_vcpu_state(struct kvm_vcpu *vcpu,
 
 	if (cpu_has_feature(CPU_FTR_TM) ||
 	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
-		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
-		ret = true;
+		unsigned long guest_msr = vcpu->arch.shregs.msr;
+		if (MSR_TM_ACTIVE(guest_msr)) {
+			kvmppc_restore_tm_hv(vcpu, guest_msr, true);
+			ret = true;
+		} else {
+			mtspr(SPRN_TEXASR, vcpu->arch.texasr);
+			mtspr(SPRN_TFHAR, vcpu->arch.tfhar);
+			mtspr(SPRN_TFIAR, vcpu->arch.tfiar);
+		}
 	}
 
 	load_spr_state(vcpu, host_os_sprs);
@@ -308,8 +315,16 @@ void store_vcpu_state(struct kvm_vcpu *vcpu)
 	vcpu->arch.vrsave = mfspr(SPRN_VRSAVE);
 
 	if (cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
-		kvmppc_save_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
+		unsigned long guest_msr = vcpu->arch.shregs.msr;
+		if (MSR_TM_ACTIVE(guest_msr)) {
+			kvmppc_save_tm_hv(vcpu, guest_msr, true);
+		} else {
+			vcpu->arch.texasr = mfspr(SPRN_TEXASR);
+			vcpu->arch.tfhar = mfspr(SPRN_TFHAR);
+			vcpu->arch.tfiar = mfspr(SPRN_TFIAR);
+		}
+	}
 }
 EXPORT_SYMBOL_GPL(store_vcpu_state);
 
-- 
2.23.0

