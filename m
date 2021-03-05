Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0996932EDBF
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhCEPHK (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbhCEPHE (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:07:04 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024DBC061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:07:04 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id t29so2212515pfg.11
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qc0nUYDLvwQRwFOs9WtkYR1nP7DQW4PKRkHGFNnJEpE=;
        b=oW8f6TYrCImZoVKsQ8e6LRkxGAc5+pLTQfoXGydCc2QMQeWku89SMXq3SnkQMDnnC+
         XXgifMIU/3tJsSR7CGeJtxA8iX0Jje4/f4v06IG9IkU+7iGfQi7YAulUZmS8EoZGRWFT
         +/luePBjnZsnqPVixw4G9/IbWUP6c58rPVMzEDjvqk9MKWjkoFG5zSwLv4WFeCeG3ufP
         JfEUhK4MK2tZ2gpHeFBJ+u7JQ5qk4ohdZ7aOUQ6RqiXLx1qQfFqYzO4CrvfRbqsR8rfz
         nTUyxfuuA0m1nbbfxPxBDleVsvWFsnJ4vJKbEKL+t2atNPwfhooYK0XeYDiGWMFZaql3
         ypDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qc0nUYDLvwQRwFOs9WtkYR1nP7DQW4PKRkHGFNnJEpE=;
        b=JlVLFYuXUfKzw7GjGwC70Wzw0Gedg45Bsq5tSq4Vn9Fex0OehQeOh17+J3L0FiXAU4
         UOUN6Ui1DkKsrHwT8TeYpSLv36JQ2vnbdMu263ntLm3bVI+PSyuAI5If9Y8SRjJS0U10
         ANZK5ZJqFC/vmjnhmwW3iDBG2LV1h+bgFOlsjQ+Uhf8fljgRJ7/vD/IGkEquOdOfK1rA
         8YZawqeRdCZxchH6i41FCPzqQ8hgoHsxX2qXvRutEqFiS1BXDROPLsKfyJKratWAOXbm
         EAnubkDLh6BQm88RvZps3Qv7QSUMaTPT+8FsAtLSwmafZVtZaUlwIwz8HczWrPW820Y/
         ZNMQ==
X-Gm-Message-State: AOAM531yHWi/0rIMOPwwf9YB8jnellMUBAtgGslSJ0Rcn/hHVulB09Q4
        C4XkEuXBfcKBB3Ym75rvDfpyVP6YVcE=
X-Google-Smtp-Source: ABdhPJwX6ulUpxaBlIKwg0Z8Rcf1A2H8sn5EvZWB3Lz7EmI8nnFFp72xD7e2nOTkBiG+OmmaqR0Z3Q==
X-Received: by 2002:a63:50a:: with SMTP id 10mr8919091pgf.89.1614956823275;
        Fri, 05 Mar 2021 07:07:03 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:07:02 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Daniel Axtens <dja@axtens.net>
Subject: [PATCH v3 05/41] KVM: PPC: Book3S HV: Fix CONFIG_SPAPR_TCE_IOMMU=n default hcalls
Date:   Sat,  6 Mar 2021 01:06:02 +1000
Message-Id: <20210305150638.2675513-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
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
index 0542d7f17dc3..f1230f9d98ba 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5377,8 +5377,10 @@ static unsigned int default_hcall_list[] = {
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

