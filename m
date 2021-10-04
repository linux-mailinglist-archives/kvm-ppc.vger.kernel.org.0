Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD97421349
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236222AbhJDQC7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236220AbhJDQC6 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:02:58 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8FB7C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:01:09 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id a73so14037716pge.0
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zf9+rzXTVi8plIkKJnOaRfuWZtrpNKxJ2kRRjgEz1l0=;
        b=IpCzKUboYsufQlqofbjtwHJ26a3gG3Udd35ZcUoXYGIJVrbHWS8NvVD8VY1vS4hVFt
         sYLpF35diFkfXr6amvzmSgtVKgKMP9nNvkVFGgeB7OulGx0Txo7lxIbQbW+YqS2iLy+L
         hnhcUKn9/NDSS1crCYK/xmmsLameS/uGYbpMgJlUyyNvqzfTWV2TqwAEOH/q1sbGuYqk
         l21kz9E1Y4xdQFGtqgrXS/wfPKBLMfe9jtNmOjpR1JtHSurlnL7hzkpsV+xlRE35ciDj
         3eRykrrY7essQHMZbJ4Tnjb9rpywFVpXvl2VcQpK2lFxQbNbvANPCPtao2i8zWeuHHSP
         p+Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zf9+rzXTVi8plIkKJnOaRfuWZtrpNKxJ2kRRjgEz1l0=;
        b=t2q0c0KOAJAJZhnR9uqQVnk/Mt0HzPfWBcWNohFy7q/5/aYuGUUZsT+VEoRo5J0t9V
         i2ftmptPRifoKw/ztGYFj0CWJRZnMbQ+FOizjuCOGkckGB5Ibedkle2h3xVwxryYW3+I
         eu58pn84aDyLUNvXEYljq+tiTX7+bYtHKbQ6bIJiZraUXVuYtOe1wrpiwsNS2PKgrvDO
         5sbWDVEjUPLbr0jGeSTenpzjVzcYS57DJkj47soryUPWRSpbm+9Q0rTkGiBL89rVn6YJ
         nwkXK45Yw/PgUOmANYnCUXpAXiCornwK6TeQFtIkbCLXQ0wBfDMer4/DQqwcZqJ54fqG
         qn5Q==
X-Gm-Message-State: AOAM5329+IWCM1hKyAPVys96YHlmqH4Oe/7o5h/nnyBLr4ZarJptIO5x
        /ZtrHGafeDGG6dRQjvicL5JA577eCW4=
X-Google-Smtp-Source: ABdhPJxkFM4brl+777k2MPuDMiwgYuONWj7Oh1/MWWHD9rxebdH1RhU/PvAkmMgOwL/wyQRhqGgKqg==
X-Received: by 2002:a62:5804:0:b0:44b:b75b:ec8f with SMTP id m4-20020a625804000000b0044bb75bec8fmr25399694pfb.63.1633363269208;
        Mon, 04 Oct 2021 09:01:09 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:01:08 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v3 03/52] KMV: PPC: Book3S HV P9: Use set_dec to set decrementer to host
Date:   Tue,  5 Oct 2021 02:00:00 +1000
Message-Id: <20211004160049.1338837-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
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
index f4a779fffd18..6a07a79f07d8 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4050,7 +4050,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
 
-	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - mftb());
+	set_dec(local_paca->kvm_hstate.dec_expires - mftb());
 	/* We may have raced with new irq work */
 	if (test_irq_work_pending())
 		set_dec(1);
-- 
2.23.0

