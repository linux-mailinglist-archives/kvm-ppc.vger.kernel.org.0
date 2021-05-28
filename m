Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97D0393F83
	for <lists+kvm-ppc@lfdr.de>; Fri, 28 May 2021 11:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235526AbhE1JKt (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 28 May 2021 05:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235106AbhE1JKm (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 28 May 2021 05:10:42 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCD5C06138C
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:09:05 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id t193so2064931pgb.4
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GSMIrgysRSkOkp4L4aVB8mc4VHaDXOZCGHsPewIvbA8=;
        b=LedHizTroFgRR5ywA8cOg3uA2Y0eDCVNHPpf17QPUlkvxRWVcF+cHJwz3q3Hu3D+rQ
         3OmCCa98eny05JCxZkvU+B+5TSe1XGrUrUpGqARS4YyzjTs0d0Rf4rwQs234DA2Xe0Jj
         /CpUfIM6jpzZXN/2J9jfioL9b95WlPkA6qFHrmOzFxP5POEtsm2nM56vfvjjMrSRTugP
         tSHar+YQ0vJbFBaufc68+YVSatZo/yEM9iNFcfLJWSRYLx0iiYNQAiwqYiKpoJ1/V0Ct
         E1pW43rX8UZD8qrC07dz4Kpj0uj0MT40Vn4y7pWU5sZVl89CueATS6n6/CbARflJu4WT
         fTdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GSMIrgysRSkOkp4L4aVB8mc4VHaDXOZCGHsPewIvbA8=;
        b=nbClGGuHRx3Qaoqyfwuhr2qoWntgHGM5Ys2j2HpZcHmYb09yv85HYSOarDR8d0k1tA
         S33o+TDHHcmvGdbUKpKOW6eRhsO9GHM4FHXsSG4ElbtyQugRFSwFUP+dKc4kF9u7dAT4
         /DOwqLdUpyxFg7LX0K1Rrf7caAEj0EDT2f5Xny+F/tENNgYK9ZhXJpkEqVFLe9B/OYCu
         1fSi3ARvaQY30n/Hh5ibKuAewtUoUpjssF/ezKE51QS/cvYSW1gIrWe9iD074+a0AuI8
         dmr9wHYxloeOJf6YSgqP3P0lLdGeMb3cwuVdcWysx4SIRH/XflVVqduGglAgZTj40j/R
         NgCg==
X-Gm-Message-State: AOAM530W19M3XUO/0ivkfZhpIK/lZudZ7mkR/U3mU6s1eOOChkn1Ellw
        LjBG/yG9JIqOZ4UXhnO7LjpqwmzjjFg=
X-Google-Smtp-Source: ABdhPJwSE4XnFc6bO85yhCiAtiHvPZnVJy2QSVEZNx5HtLjHrU6fXQRn1uB5xW7tuW9K8P1/mAiM0w==
X-Received: by 2002:a63:3dc5:: with SMTP id k188mr7894694pga.140.1622192945167;
        Fri, 28 May 2021 02:09:05 -0700 (PDT)
Received: from bobo.ibm.com (124-169-110-219.tpgi.com.au. [124.169.110.219])
        by smtp.gmail.com with ESMTPSA id a2sm3624183pfv.156.2021.05.28.02.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 02:09:04 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v7 26/32] KVM: PPC: Book3S HV P9: Allow all P9 processors to enable nested HV
Date:   Fri, 28 May 2021 19:07:46 +1000
Message-Id: <20210528090752.3542186-27-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210528090752.3542186-1-npiggin@gmail.com>
References: <20210528090752.3542186-1-npiggin@gmail.com>
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
index acb0c72ea900..cf403280b199 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5451,7 +5451,7 @@ static int kvmhv_enable_nested(struct kvm *kvm)
 {
 	if (!nested)
 		return -EPERM;
-	if (!cpu_has_feature(CPU_FTR_ARCH_300) || no_mixing_hpt_and_radix)
+	if (!cpu_has_feature(CPU_FTR_ARCH_300))
 		return -ENODEV;
 
 	/* kvm == NULL means the caller is testing if the capability exists */
-- 
2.23.0

