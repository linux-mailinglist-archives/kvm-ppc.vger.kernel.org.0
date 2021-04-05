Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42230353AA4
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhDEBVs (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbhDEBVr (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:21:47 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93F2C061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:21:39 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id q5so7186063pfh.10
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+yz3nCHgncTH1iYxogo/O0czpRYa7H+0gjI15C0SIns=;
        b=tTgscvMkNalSwwTNq71/3p8BkL40aWAK/vQgyTG0WMQCn5gWjt9K6vG0CmxuIDZr/e
         1etwZED7jEAYE7P5CChqkKaLiEYM+Jn+990O4da6mdvImhCuvSMu+pMjDGq9CX6LNzxy
         urBXqWrP5l43MRHkctsoxSPuFKRKk617Bo0WfySnBQLK8IJ0b1X9oZO/zvV7v7OkUF4q
         rZCwKXPlmDony8iIiegr9MmEO129bxBlpQxW08twke97y1uEUGd7+XB+zh/ysKGCOI+p
         fq4iV+GhdPk/C1oX/ySjB13HfTilsZS2ZISqv+FoAfM1lqBMwrU47TXYneKvUloeHUz+
         ZFTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+yz3nCHgncTH1iYxogo/O0czpRYa7H+0gjI15C0SIns=;
        b=gX977CVXcIjrS+ayS1KS/Ooh03LWYG6uQuRe0VnUBAFThthjT2oSceAxmhFsGv9fL/
         jGeP/Xp31B34Y61qMc0bIAK8+bNgtn2FA0AxPmI6yLfZe2KVko6t73CMOqs+eT5YtZt4
         UCfdhMbnadMqhEVfJHSHN3SWgemwegSFQHwNOOfRwWBjhKdvdeay+BaIYVPwPSeANSPa
         CupV1LPkJKAxKlRbjlvktu4EEFfPvxAoOalbGaydrTby0Ja4/ec9U/E7UVp79jzOtEPT
         fUhsZ21idaP0b4rvUxUd8RRUdPsllGEaEv2LrnEjAyY8pkGLtdCrbYwK5WV0x3nJi7J9
         SgxQ==
X-Gm-Message-State: AOAM531qRgTMgu1LX6SwqtMFQflX27qXWEU5DYAh38BeUQJ9kswKaBzr
        fTrACkxLbh7n9UJTDOwgo4eXJK88Zi/MQg==
X-Google-Smtp-Source: ABdhPJxG/XX78xpw1PSF9I438oh7eHsSm3t8WDghRmuYLmmb29ptdu+WOVjzBD9Zt2FgGGlgszJo1Q==
X-Received: by 2002:a62:8f4a:0:b029:20a:448e:7018 with SMTP id n71-20020a628f4a0000b029020a448e7018mr21215419pfd.62.1617585699303;
        Sun, 04 Apr 2021 18:21:39 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:21:39 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v6 28/48] KMV: PPC: Book3S HV: Use set_dec to set decrementer to host
Date:   Mon,  5 Apr 2021 11:19:28 +1000
Message-Id: <20210405011948.675354-29-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The host Linux timer code arms the decrementer with the value
'decrementers_next_tb - current_tb' using set_dec(), which stores
val - 1 on Book3S-64, which is not quite the same as what KVM does
to re-arm the host decrementer when exiting the guest.

This shouldn't be a significant change, but it makes the logic match
and avoids this small extra change being brought into the next patch.

Suggested-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index dae59f05ef50..65ddae3958ab 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3908,7 +3908,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->in_guest = 0;
 
 	next_timer = timer_get_next_tb();
-	mtspr(SPRN_DEC, next_timer - tb);
+	set_dec(next_timer - tb);
 	/* We may have raced with new irq work */
 	if (test_irq_work_pending())
 		set_dec(1);
-- 
2.23.0

