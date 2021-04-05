Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8C6353AB4
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhDEBWa (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbhDEBW2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:22:28 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BDBC061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:22:23 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id j25so7208437pfe.2
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vFMMQgThsUAc2S0LaT7h9p9PH0nf5CHdrn+oC6qHpCo=;
        b=t7RQa1AAPbICBHtL8E70gqsHEBscLP9xgAq9L4rDfPNtEPV/RQgBJ9S/DH4OmSdp1+
         PFyah3EPxGggyNqvxja+hPRdFokmnWm/yVj4+gOOoyQHwNut/JxFa0dYq1tU7PTA4x2u
         D7L5vAy+m7IroXLg4/GHcw7zDPvKdG3Q+QQR9Um+H1LB4DceerKeucxt8FthR60FiYk1
         I2A0L3/E9wD8Jl4OePJ7G/X6dfwxEkLi9zLNZfNbSAqE4vJ5lOzsvbJuvoY1fpd6CjsZ
         mSEq1mygCHkNZW/W18HAsvGd+zd8HunASvkcReeradGU37kHChRyfg9i1KMhyJK+vVAm
         +IAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vFMMQgThsUAc2S0LaT7h9p9PH0nf5CHdrn+oC6qHpCo=;
        b=n1952pYOVgXyhX/+sakxqi+GMS5Q5AdHASnh6Gtj+S1FYePhwJMCiQItIkARFKWspq
         e2g7MufFz0zENU0SinffLXxv8R/g/mRwfiWZfNTKkGbYT8nyzQso6rkpRrPeYHz1+XE8
         qnoRbwK9ZVB9JXzow1z2D0nKQY4r/Gvk0IdtUKDzhYsKxgcKqhVe5LOFsfmR3UAuYZIT
         B4sXdW/UOm6rpsnZlAG0P60S3a7v1wR1D/XSWqQjRLf2AKzJ94gf+Te/vw0Qr0DMQsAJ
         JmQKVrivBg0/Ck+vitwRjsFS8BLTUEcyCUGhuOJcyOcn5+84dEWMVPyRAXHKBeS8iUUe
         vP2w==
X-Gm-Message-State: AOAM5335qqUVBhtvqLdU8/zD/JFotxdxBzX90mB7EVqQi4SdSFcVh8Mg
        IiI5qQRTlWztzCMEZzMXuE7tZLHrsdPAxg==
X-Google-Smtp-Source: ABdhPJw8R1k5TWI9uLfaH0DflPKY0792pji+A58QORsoUYVY/k19haFzvL7nlhHgJF/feZXhIgIMbA==
X-Received: by 2002:a65:610f:: with SMTP id z15mr20974993pgu.360.1617585742986;
        Sun, 04 Apr 2021 18:22:22 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:22:22 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v6 42/48] KVM: PPC: Book3S HV P9: Allow all P9 processors to enable nested HV
Date:   Mon,  5 Apr 2021 11:19:42 +1000
Message-Id: <20210405011948.675354-43-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

All radix guests go via the P9 path now, so there is no need to limit
nested HV to processors that support "mixed mode" MMU. Remove the
restriction.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 20ced6c5edfd..5ef43d9b19bc 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5443,7 +5443,7 @@ static int kvmhv_enable_nested(struct kvm *kvm)
 {
 	if (!nested)
 		return -EPERM;
-	if (!cpu_has_feature(CPU_FTR_ARCH_300) || no_mixing_hpt_and_radix)
+	if (!cpu_has_feature(CPU_FTR_ARCH_300))
 		return -ENODEV;
 
 	/* kvm == NULL means the caller is testing if the capability exists */
-- 
2.23.0

