Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210883D51A7
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbhGZDKe (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhGZDKd (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:10:33 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3741BC061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:02 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id k4-20020a17090a5144b02901731c776526so17810726pjm.4
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=inYRnRg2NKqvIr+mMkG5hJldbNhI6GosEIHyZNPewnI=;
        b=h/yBtb1lxuYcIdeaW8xJeYIeiRd/mC2XLmTXR4L1yqExrTFFrhi1W+pLsi/XEmUSX+
         FeK4TVSsOuHXwKa/LWG5HIiCka/eZ37gzNvSIelcTKY1DRJJOuZKcbSuYykF2GgEuJUv
         qRkUFsjtewgMdAlJcaBmyHvVMVeGpxuM/pXlzH8Nxy9yfHsS7eTRYRfBiftpm/KvsivE
         ZLc/3tjQFYRFhtMRgvWcdTrnUrzrFW2bv5T7mwxRBkgq356eo8FtD8tFkRc8PmOf5DPE
         H1x8HLD8WAnafTXjt0fFxfdaHXkPoHQRQa6juZ0cLYvlKnJHQz20yozSk5l7CSJkvmeA
         FohQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=inYRnRg2NKqvIr+mMkG5hJldbNhI6GosEIHyZNPewnI=;
        b=PkZZrJF3ZJAbud3Qxtz4BfujQhmv9TUrNcKzfVpISqicIwf48VDMQw+zG9ajWrD2YD
         7fo2ISt9pAk99oq5l5FYiGw1PXl8BVJpOY3ZNlD3Ru6zTVXQETLRneSaQgXQGifrEZAj
         1NnLOMqsIbMAznqg9vz8alB2t9y5Vm8PnxVyiaduz8ZKR7WXYsA7nLye3HQkzdryIgfm
         I67YbrQ1zt2BAs9fNkteBwz04Kq+Qlws2bROxVQZgJtvWt9kwSHCLYgNo3/Ttzs4S2hC
         NmUdGDbR/3Z2cCfeIlt3WzMeZ7KU001XyIXTCV3gqwAMEOUwqZqP8yMqRvmi9CGLLaws
         /+tQ==
X-Gm-Message-State: AOAM530S+BuO25SMtcLAwFgI02w/LLGuGKdrumGLUh2MZXoWgLLapP+S
        lLOAWgz8NZGraIBjb6OWU2baMjzPMI4=
X-Google-Smtp-Source: ABdhPJwKZUlDXjIvGIVIblAM1sFF3K9m6X/SqDI+cAiv+fYwhbh5Z51Mm+dYXV8beBhKuYVBxJwyXw==
X-Received: by 2002:a63:ed47:: with SMTP id m7mr16427295pgk.194.1627271461747;
        Sun, 25 Jul 2021 20:51:01 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:51:01 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v1 07/55] KMV: PPC: Book3S HV P9: Use set_dec to set decrementer to host
Date:   Mon, 26 Jul 2021 13:49:48 +1000
Message-Id: <20210726035036.739609-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
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
index 905bf29940ea..7020cbbf3aa1 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4019,7 +4019,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
 
-	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - mftb());
+	set_dec(local_paca->kvm_hstate.dec_expires - mftb());
 	/* We may have raced with new irq work */
 	if (test_irq_work_pending())
 		set_dec(1);
-- 
2.23.0

