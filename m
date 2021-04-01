Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B4B351828
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 19:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbhDARoM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 13:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234666AbhDARjD (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 13:39:03 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9C6C0F26D9
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:03:49 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso3224836pji.3
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2ljQ2o/1KJXmV5budvf2xHhIW20DBRLuADvMqiJ21X0=;
        b=nSmDau+w/+aVDhTXw35u1WBNcdKzf7qo9PmSZIT/XQ4+Yj1NafR3w7D3COAcOUcbsJ
         M3a8kec/zBYQSfxBoxR/Z8MaZ7qa16uQLbXUGTQy1tZ76DtCibMwpeLiFe7PNUTcXfVp
         MuzKMg/oCYbLeK8SIO2LuGS/eAIuWF+3niQDgwnTcoT2ypKBhER6uiXCIm3fyBy7nodN
         51h1VT2XC23AACqUDIyvA1XOmcPJGWJJJD0umcoSkUJy3twtBLTBYIbaJ8A7W3aP6EYn
         JXmcjaVyeYBWgrUjcXftxi0/A5M2wt4/D6Y7ahHh5btWwVbmNJvbCR8eiDsE4TXGIp7b
         Djzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2ljQ2o/1KJXmV5budvf2xHhIW20DBRLuADvMqiJ21X0=;
        b=KUgc68By67lzSWToz1EvxpNlNdfFg7+gLYl+sdCfYvl8Vzvqrryre9TJg38QlneWIH
         EHHz5T7aZ8YFOP7JKlfuFWcek/gKbX3oAcVLl+h23I85z8r8NkqxxW00bgCwxWl322wf
         0VciD+ruQvbij/in/kQjCG0tlfQ+vGyYVUuOvF72cUiAGUhkxZZnom2XZUh4r+GEpGr1
         pFIHPKbtdonJo6A04CQQxbeceR/cevSbWP8JWs9p3rjwNTuAh4iGKgrrDFHwRFysP5iW
         FuSR3Uwetl7teF06kRZvewStJfCN5Zk2Bu990zwdYg+/RE41rhCxOogHSOZQ+/P8xrB8
         psWg==
X-Gm-Message-State: AOAM531YaVNNP+sz8fd8YG98SpDf2RYVWg06eEkoi5ref03wK0WWTLM0
        MjjWkJM4buiAO6atTZYFO5BhK6aWUYA=
X-Google-Smtp-Source: ABdhPJxqgIwpjVBmqEUJt/5rZZ2PMe1ApS0YwaeZMy7M/s+ccTi4enhWYVUkmtmbKM+OTKLDzSGPQg==
X-Received: by 2002:a17:902:c48d:b029:e6:f7d:a76d with SMTP id n13-20020a170902c48db02900e60f7da76dmr8340029plx.66.1617289429147;
        Thu, 01 Apr 2021 08:03:49 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:03:48 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v5 04/48] KVM: PPC: Book3S HV: Prevent radix guests setting LPCR[TC]
Date:   Fri,  2 Apr 2021 01:02:41 +1000
Message-Id: <20210401150325.442125-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Prevent radix guests setting LPCR[TC]. This bit only applies to hash
partitions.

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index daded8949a39..a6b5d79d9306 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1645,6 +1645,10 @@ static int kvm_arch_vcpu_ioctl_set_sregs_hv(struct kvm_vcpu *vcpu,
  */
 unsigned long kvmppc_filter_lpcr_hv(struct kvm *kvm, unsigned long lpcr)
 {
+	/* LPCR_TC only applies to HPT guests */
+	if (kvm_is_radix(kvm))
+		lpcr &= ~LPCR_TC;
+
 	/* On POWER8 and above, userspace can modify AIL */
 	if (!cpu_has_feature(CPU_FTR_ARCH_207S))
 		lpcr &= ~LPCR_AIL;
-- 
2.23.0

