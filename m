Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36CD8353A8C
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbhDEBUf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbhDEBUc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:20:32 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FB9C061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:20:26 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so7635174pjb.0
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=akE4Bh1LcVOdXlv04bpZUL91EDUzw6Ofnv5OK5AoVW4=;
        b=fx6TdocBGKyQdc27E1MP56nhRztLfViwq3BfdM8VGfIXftWZABA+Q6lvINgWYNmV9x
         aziBchM584a8aqhbmu7wEQdg54s2bEjOJ79NwABJQ9Cu8dGe0AJF9GdIs+sfQG47m1ws
         Jgjfoq/FL3PFq6drpb97J2KLPptiJC0wVQMxdOyVeepfY8vZJ9XfQxqFaSO9p9OLmrAn
         xCONWeMESolgtslixD85tTAOJmAMh0qBaKbuwCv6Jcjk6nk1OKHcbE/RhluVjBUvtam4
         ov5cmCoOFr0dFD0HxGPStuj73wmophXwA1PdcMOzJzXy21RGiZ+Pva9+NrrTv3J37H1V
         gRNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=akE4Bh1LcVOdXlv04bpZUL91EDUzw6Ofnv5OK5AoVW4=;
        b=V4u5osC1yfpN+WH7pD/qaCOCO79RFQwEUoRfRiTefV705Ains+3HqYqcL5pH2pdZao
         j6HH7PtbFKcWpDNWgCR9PQaZKjHOOZ3spAScgKHYtCzyPcyZfDJ9WwS1/T+EBuD8AFFL
         7lllsGGLApAD0Jmn142tOZC1qiLzdIZ3xGV3z/VAM1WRgqlOHJelzY4gEsAbzx0KiHOx
         avp5D4d7nf608V1PYreZ3DJPCPCDxc3SOXNL24jQAFP0a5KSpJPVHu2zCaa+2dAJ5n3v
         q1muWg37k1B1uuQoFdltDG5L7vV+bRU87I4EoW8rYflTCCP87NvqOs/A8JNFTgb4pPI4
         Qc7Q==
X-Gm-Message-State: AOAM532+KRnQKfPW9l/4F24fyb7IHiEkYXy01w2Oo6cJdsntQprAam5r
        78MrGpvWZ0G+ELoYjb/zPrjfQLyUfKBmVA==
X-Google-Smtp-Source: ABdhPJxHQeAmERijeyNlHq0Dm/GtcKkz/yuE73BKtZcqomrio6nidKJ/aKwauhmBy2ZqUJTmiR71hQ==
X-Received: by 2002:a17:90b:4d0f:: with SMTP id mw15mr24359578pjb.92.1617585626383;
        Sun, 04 Apr 2021 18:20:26 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:20:26 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Daniel Axtens <dja@axtens.net>
Subject: [PATCH v6 07/48] KVM: PPC: Book3S HV: Fix CONFIG_SPAPR_TCE_IOMMU=n default hcalls
Date:   Mon,  5 Apr 2021 11:19:07 +1000
Message-Id: <20210405011948.675354-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
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
index 8bc2a5ee9ece..ed77aff9cdb6 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5409,8 +5409,10 @@ static unsigned int default_hcall_list[] = {
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

