Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A472D3519ED
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234651AbhDAR47 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 13:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234914AbhDARwe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 13:52:34 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF5DC00F7CE
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:05:46 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id c17so1672906pfn.6
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=puIw6o5we11S+Q3MLTh61PKAuyf9CU/jVlPkn7xSoS8=;
        b=SKiBiR/2Q2aiA23Dorrvkz3EPlAAZXWfclRRRM2Cd0B13XSSR4Gtrwzr00tLhdsPAl
         TdE8bg3tMoLUwUMo1jGiGSmxmtqhSQmZTbWYD8wHES48mQWlWwrBBX3Qx8N7JAsCIRBx
         akuyOsS+wRLQBClogC79ET71nmP8Ww70igHQ9drMUJYW7biWEqpTsOMrN+wO2gRUp4wR
         Icnu/siWxO0tSJn7tPZZcY7oCLVr/a2QgmInrQbJMOZC3VYtEha4sV23bnKxCSp6Z1BX
         jthn7qnHiu/Esnxd3IW1UTlOwF3mj24tHn0zw3FjtnyrILcxSgjUMxbBboEZEXlAHItO
         JCfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=puIw6o5we11S+Q3MLTh61PKAuyf9CU/jVlPkn7xSoS8=;
        b=CMjfi8TVvlzCI7Hhd2mSh3hrO0U996+7hnRxDVD9LHVH4mwdcUO9o9SY4nC6aOv9Z/
         GsyD/Ww0flMFOBlSrZbN1lFXwmRDpBrn2yblzitOowyPmnIrQGVZU5Y6ZVZqbSkwnX9C
         6fdOfej34vyKuiDG6MzczASzGZHFpWwV4XCrhZY+RdZ2+WSOsULp/rlY6fZWvRUXMRj8
         CvvRCp/wUV20V6Bt0InGj47/VOVcJ/WBIISck65oYTUqXozuvNf2C8MR/W77e2EUFI/O
         CXHXM1flHwUbqVZZ2faKvK7pFDJUM65j4Svz3FHCthD69y0eMjseH44eynVwTC1h0seU
         yZgA==
X-Gm-Message-State: AOAM530JyaGxG8RzX5dyPf+KV8jkuvHTM0wg6lu2RFq7aRZLMg2HnGG+
        GKw5f5yeO1pbrTIM8uDEZJS3a1z0OgM=
X-Google-Smtp-Source: ABdhPJwhJblL2WhYBcTqAUUegpI7fKr0iy5JjeM+fGae2o4TbxvLVtKqnTlovtm2SnJqIEpazVFqnQ==
X-Received: by 2002:a62:190a:0:b029:221:cd7d:7927 with SMTP id 10-20020a62190a0000b0290221cd7d7927mr7762455pfz.27.1617289545724;
        Thu, 01 Apr 2021 08:05:45 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:05:45 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v5 43/48] KVM: PPC: Book3S HV P9: Allow all P9 processors to enable nested HV
Date:   Fri,  2 Apr 2021 01:03:20 +1000
Message-Id: <20210401150325.442125-44-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
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
index f4d6ec6c4710..f4fa39f4cd4c 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5446,7 +5446,7 @@ static int kvmhv_enable_nested(struct kvm *kvm)
 {
 	if (!nested)
 		return -EPERM;
-	if (!cpu_has_feature(CPU_FTR_ARCH_300) || no_mixing_hpt_and_radix)
+	if (!cpu_has_feature(CPU_FTR_ARCH_300))
 		return -ENODEV;
 
 	/* kvm == NULL means the caller is testing if the capability exists */
-- 
2.23.0

