Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42841351821
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 19:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbhDARoF (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 13:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234597AbhDARiT (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 13:38:19 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85374C0F26DC
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:03:59 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id c204so1682594pfc.4
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=akE4Bh1LcVOdXlv04bpZUL91EDUzw6Ofnv5OK5AoVW4=;
        b=PqNK0pVt7bPqUnrKo8LLjI9pB0RsY2a1c7s/OXW+RZzwrUkItn02jrF4xZM27CdTMj
         R8naDz+Ld535BrKABlCh1n61+lJkegIbeDRPYAClGkb6VDGaQWY4euWFzvu3xb+JAUXM
         Z2Yh4Q1oT/wlukteOCuuC9qo3hLNndhepc4MK/puGOzrjOximNnsDa/88UElk6JCdvup
         huan8wOPV53/F2vPSEhLGJMuzqFx5U6AU5ywze+tLnv2rLSrH3qJsT2t4Q3p8IIj7FQw
         2+2ZBHTD2P074MwXvPdyeKaXw8aYebFe3iPmahErDZsrEgdw+k0x2pKKIA4jor+EKZ3f
         Yxyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=akE4Bh1LcVOdXlv04bpZUL91EDUzw6Ofnv5OK5AoVW4=;
        b=CRWVDugtQC3BGjkteZ6tNEsqW36MVLj9BdU+ylR8FqQilpW+jF9+2yIU6rtUbmT+Bp
         sQ7f+gtgZz++ITmaU4bgmfqCaY9z9xnmRe9zcg1rTaSdqaA2fK9Zt372++qc5D/cN41l
         NUEu8QeVCpc0Jr/bH9TTCduxwv3dvCZHiANNWSjdSfij3cHfufeFpPGjoYnH1DDotTRx
         xCuGOSgUpEl8++7DS2oYuUx3MDSAXqaWk+zur+f73UaPGXeZNJmJ2qnD0RhysVEPNcPe
         q0qvnEj7X+iocaVv28uDlgx4zLlH4Uk+yipt4jfWGaRZsEQsZBTSqsvwm5jpf0UaLG8b
         78BQ==
X-Gm-Message-State: AOAM530iSxFZOPGVyj/ewQnQjnl9nPO/ThM18tKDNFqSMRNRGCOs/8r2
        zqKhV0HCxFgBejtNES4smxYVlFpcKAk=
X-Google-Smtp-Source: ABdhPJy1nERcXRk7g7oDC/QQgNRKAGxmpIwfbGVPpWK/ujVaLR7b8+e0LWqQRrvAiDGc95rL93ysPA==
X-Received: by 2002:a62:2c12:0:b029:22b:2c97:15a0 with SMTP id s18-20020a622c120000b029022b2c9715a0mr8114703pfs.77.1617289439018;
        Thu, 01 Apr 2021 08:03:59 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:03:58 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Daniel Axtens <dja@axtens.net>
Subject: [PATCH v5 07/48] KVM: PPC: Book3S HV: Fix CONFIG_SPAPR_TCE_IOMMU=n default hcalls
Date:   Fri,  2 Apr 2021 01:02:44 +1000
Message-Id: <20210401150325.442125-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
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

