Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA13B345470
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhCWBDq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbhCWBDj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:03:39 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5220C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:03:39 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so9407204pjv.1
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ig9Ay39viYeapYXuSo6uIf6+TrFfALVUiHXjNAwZBl8=;
        b=GqUpKfE+k22T4VuGRSYX0R8lhDX2hGuJ3WusYa9g7r+0QVceCKe+50oXzHwBFtHtAE
         LqGc0gr5Dq6bNNd5MqKAyLHf0BH4wjzuLRuRRyXiLLi5i0rn79LTVcUUKD5CcQsoNHHY
         mla30zWznzsNZifbJVVLhYQMv1/RlJ2SNXIslyA9ZvyRJb/brRf5gOFp4Sqe7ciDoTDO
         ocoNhpUAqSCJLBX7skBuYJw9rIYfbvrLCk7bINNC+sboEhDvxOKRnKHCC/5Z1JOYZFAr
         s67qHCwO35XtN7dT4VWMhTcxV5AFe3SsgyhEdovqQHuOPWytUjFLUSsQcd2lXaZRYPWn
         67Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ig9Ay39viYeapYXuSo6uIf6+TrFfALVUiHXjNAwZBl8=;
        b=nnQgmlF9qkD5RwSjbp9gw+dDqqQqbPRQe48leva34Tqoh5u+wW4MgjuVmQnARNVOul
         Wxs47p9JpNGMOU46PHUuvzBGO4MmU0tbzMy1xCKu1OHI26ck8aiVHzmYNpREPumRuou7
         08j8FV2uNOL2Y8f4ZBRMyLobxti2g2HWuqoJ9YH70Anm5SlWCQMEBHyUiePEY+6NZdGa
         7Dcxg8q/yp+dKpyKoVe/KDxSar1DiH1TgZsZgKWg6afWqXqCVQ/PxfR0ipoU2R79dsrr
         x72qFu36UhwLD/cImY0n2V30zH6rccpaZPNtEWvjMMN///cOVT1RljtPhOCcz2g8wOBY
         a34g==
X-Gm-Message-State: AOAM531DL1zxjs5coZ3+U9cK/Yk3sGWz6In5NR0vkd88gJxPRO32sUxb
        qyVxf+1EoPwLre4iEQKua71OizkAnAA=
X-Google-Smtp-Source: ABdhPJy/wcnQr9WSn52efZDkznWF4y+UCQZKiwB7oVTMlEKIXMj/jyW39aHj/uAxRgSrYzYStwZ+uA==
X-Received: by 2002:a17:90a:2b4a:: with SMTP id y10mr1750162pjc.143.1616461419241;
        Mon, 22 Mar 2021 18:03:39 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:03:38 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Daniel Axtens <dja@axtens.net>
Subject: [PATCH v4 07/46] KVM: PPC: Book3S HV: Fix CONFIG_SPAPR_TCE_IOMMU=n default hcalls
Date:   Tue, 23 Mar 2021 11:02:26 +1000
Message-Id: <20210323010305.1045293-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This config option causes the warning in init_default_hcalls to fire
because the TCE handlers are in the default hcall list but not
implemented.

Reviewed-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 7cfaabab2c20..7bb4222729b0 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5401,8 +5401,10 @@ static unsigned int default_hcall_list[] = {
 	H_READ,
 	H_PROTECT,
 	H_BULK_REMOVE,
+#ifdef CONFIG_SPAPR_TCE_IOMMU
 	H_GET_TCE,
 	H_PUT_TCE,
+#endif
 	H_SET_DABR,
 	H_SET_XDABR,
 	H_CEDE,
-- 
2.23.0

