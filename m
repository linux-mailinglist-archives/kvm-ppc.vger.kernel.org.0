Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE43351BB5
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbhDASKv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 14:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234804AbhDASGk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 14:06:40 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9093C0F26F4
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:05:04 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id x126so1652841pfc.13
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q4fgmV/3XV+48nC3cNxw1X5+GU534mYi5sD1C83lc+s=;
        b=TDEwc9YeeBBmqq7MEN1e/fuAml2ZZjFA7LGujh1rLMDTt+hQnMgwU9RUmNq9rAKUBX
         DODeq7+m050gJUW9gceGC4R26aVrcKNA3jLBjOESoelObyAqp4WlqVtlmVnUCR0vGi1t
         G2nuIjdOfv0MkBmSn/wQ8IzOQTUwUZP6YOqNl2JP5j0bviZv/hC7aX1m6OA80b0O2SqY
         OHrIlgQwa2a6Q6zPsUbhSNBNtZ02wyCyLlqeYA3XrZwbVoRjId40Gs5H9q+26ilBcNLr
         VjTH1Er+J06z9BWiKeQuMB50wS6cT+6913J2aRv2l7QRjQzJE55IvTQazM/1pJzst3Xd
         6anA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q4fgmV/3XV+48nC3cNxw1X5+GU534mYi5sD1C83lc+s=;
        b=LrJNr3XXL50vd9/JRX7WQtr5jY2GOivuvSUKd3FXWoNJsGxVdkvmjGWKk/SUzAqEDB
         2dw1JzIAwDOztay+F/XbcAjEixfGEq2h24o8QqKs/iH9stUdj9+0VUMd7ojr8Ogy0XUZ
         imEVztoF+1N3qvrQS7n2V6Mq0StV7k/geTXjx811LJ1PYO6gTRh8wm6DNbFtaZDAgZJe
         uWyVg5uWHHgXvFAeKlsqFq62USDgIyZcfJTwlQsLbFmObw4tTG3qm6VaQMNKuQxdDRXO
         MAkeuf5GmaZ5+slkXUc8vxhnw2qU4DW0ZMuUvtlLwyn5gnG07hpqwQRgUZt7k1V38PjN
         7SOQ==
X-Gm-Message-State: AOAM5304h1NLI5GQmjbV73in8q5vAQWHrIo1H7kBXS3JqiRlHLgWh8IP
        MhNxDnzynOs6EPtp9Q9/ludJWH9cv5g=
X-Google-Smtp-Source: ABdhPJwPoTXLdkt/dX23LTNqkNvKDKBJwh3bcHsDIxILvPa0jaQCii3N9KRxEZoV4OX84UPLlTkl6g==
X-Received: by 2002:a05:6a00:2b4:b029:1f6:6f37:ef92 with SMTP id q20-20020a056a0002b4b02901f66f37ef92mr7872629pfs.56.1617289504093;
        Thu, 01 Apr 2021 08:05:04 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:05:03 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v5 28/48] KMV: PPC: Book3S HV: Use set_dec to set decrementer to host
Date:   Fri,  2 Apr 2021 01:03:05 +1000
Message-Id: <20210401150325.442125-29-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
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
index 6cfac8f553f6..8c8df88eec8c 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3902,7 +3902,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->in_guest = 0;
 
 	next_timer = timer_get_next_tb();
-	mtspr(SPRN_DEC, next_timer - tb);
+	set_dec(next_timer - tb);
 	/* We may have raced with new irq work */
 	if (test_irq_work_pending())
 		set_dec(1);
-- 
2.23.0

