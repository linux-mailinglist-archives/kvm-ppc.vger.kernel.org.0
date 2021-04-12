Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C964C35B842
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Apr 2021 03:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236344AbhDLBte (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 11 Apr 2021 21:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236273AbhDLBtd (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 11 Apr 2021 21:49:33 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E37C061574
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:49:16 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id u11so2143125pjr.0
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qHa7loSaCaOe2yFractxh5MmgHLG7n6qdLPHRqtdv+o=;
        b=qTMiMu74C3cU7uIFkilT1+fdbkAhrt4ePW3vZD7pt2vGMQR63kuv9Y/ZyPOQh5i+Cp
         H6RJhtD9uB/idaD6j7WsiQYletAT4pRHb6pAt3DZX6uwAFPBlFV4rMPrR+TxojRhlhC2
         TF6PjjjCn81qqvIPxiTyi7GBlKY785mX6tmjSurLBA0PYE7OtxKuB6cn5QOfOW9MmzEp
         Dva4Z93i3Xyp/F/O4T7MsKcwMDLEdm323+FcteSrXO0W0aHZTp49XKGYejdXUgBWFD5x
         3wmZ47JVlKE5a2BCirGvQiCZfQBjgSByslE3923G24MNzVSRCaFPZOC0VnD9pi97EEhF
         bhqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qHa7loSaCaOe2yFractxh5MmgHLG7n6qdLPHRqtdv+o=;
        b=UNoYgLu//z9+BOIqHzarO+r8i+Vjs5ZYnffjm1Il8F7pgUQtLr0rQsVJ/AhfOxirwy
         J8dBErUEA6EWhfKrr5SRo960GNbzz0b07C0o17+xhruZXOQXqzObSlaG5dVOWMwNPifd
         YIXkX0T/CUx+QiP2gM/Kh/Y/3mEk5E4P/bdv5gpOmkREm7GvIs+zl4ZF/tnh8bjCGgNh
         JjqXRV5mY/kQF5cI/V8LIUpEqEzGWihTBoABdkVxv7//aidpknruqH5fpXeWUtCOi2bR
         TpqSjmvVEj9QZtZbHqrl7jnNT26fQdhM7QE5MUu+poYPAx8j2pwk69xGkKTif5eYvRiH
         eh5Q==
X-Gm-Message-State: AOAM530mnQs7jeoPrSodxGQ4ybkBTcpEp6HIkfW3Sjk80/DBAKB9Oy6k
        vnePstQBlceQWDkpX7bHK5D5ym2IIR0=
X-Google-Smtp-Source: ABdhPJxsRw68Kuw9UM06lABNNgAc4DSU7v570Xv3VuVAxUNmDP4QdjaKk9VHiw+fQkRyT7bibRSJlg==
X-Received: by 2002:a17:902:b483:b029:e9:eef4:4f16 with SMTP id y3-20020a170902b483b02900e9eef44f16mr14075893plr.38.1618192156440;
        Sun, 11 Apr 2021 18:49:16 -0700 (PDT)
Received: from bobo.ibm.com (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id m9sm9502345pgt.65.2021.04.11.18.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:49:16 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Daniel Axtens <dja@axtens.net>
Subject: [PATCH v1 08/12] KVM: PPC: Book3S HV: Fix CONFIG_SPAPR_TCE_IOMMU=n default hcalls
Date:   Mon, 12 Apr 2021 11:48:41 +1000
Message-Id: <20210412014845.1517916-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210412014845.1517916-1-npiggin@gmail.com>
References: <20210412014845.1517916-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This config option causes the warning in init_default_hcalls to fire
because the TCE handlers are in the default hcall list but not
implemented.

Acked-by: Paul Mackerras <paulus@ozlabs.org>
Reviewed-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index b88df175aa76..4a532410e128 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5412,8 +5412,10 @@ static unsigned int default_hcall_list[] = {
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

