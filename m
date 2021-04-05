Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248FD353A8A
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbhDEBUZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231823AbhDEBUY (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:20:24 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E220BC0613E6
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:20:18 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso5057532pjb.3
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r+tYArWWu4RNguNhduAefXr3uYY9Yl8n8bH2Jfs1pRM=;
        b=a4aZwsMyJMu0C2njYTAugBqlrA3Wtd9fBeEXZbaMVzQOqhS+VRBfLESrOHM1kj2r7H
         vmFtmrCzQ31NDpX0fzyY8EKDYYaGe0+1w0ED3QEeMuCZzW7SknzsWnHvnnrLircpqAwc
         rPb6x6I0KwMLWFWLAPmPH04RzAGG2S0niXJJ1rOF4EQb/fLFRPVKwtjOVAk821DfMJsB
         onLP78tagVcZCDjvieZJYCvfh8XDODx6koYytXN/NuEYRrHTTdKXn/lOD8h8CsFRFZGA
         YjVtgegcvRsVuG4w1KsIoqxxBPOiQNOPo8cVC7xY39RYeZ5Ovu+CPGAA3AHFlMCVJ1bM
         GiXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r+tYArWWu4RNguNhduAefXr3uYY9Yl8n8bH2Jfs1pRM=;
        b=A85s3/+r3yEKE4fS1Y7AqCdFZLmaWcM1obHL3CN9rdFZJPHsQ69fafPDBQ5lSHUZvx
         j80AtQU6WYbb/T4v6kcEFzCHAxwtQ2ems/jkTh3ZV9ccW1CfLc8RXvdA2l260141yNu4
         e63f0dZY+9VHxlt343Qpg2qi3ZxT9hAesqcsFKDa4ZLgZzWybZ9DN3hSTbtCIYy8asWe
         NmfyZW3EP2cezBjEsimnhm/uB30TUzBiPNbShHdKz8AO+WGg0wKEfTRji+NWD/r6vB2c
         Kr5vadQSfiyG+MQ6QuFxpN866Ko9h6ihIoxzGKBQfTeOfUymsdeHt60JECkEMhcMxGhY
         iWcg==
X-Gm-Message-State: AOAM5335e9SScvBnYGj9Zc/AE74dpNKJzKPOlQmUChGXKr6PRoXnw/Gr
        AwxSgkgtAUv/SyRGjIisZiSJxWu5WnbtSQ==
X-Google-Smtp-Source: ABdhPJxO8avvP6Fy4tA7YQlADYX9ZQy7YGylbO9U124A+gY/JoOQkUkjK0BQQdv2Uk4srQBOb+VDMw==
X-Received: by 2002:a17:90a:4309:: with SMTP id q9mr12625678pjg.40.1617585618454;
        Sun, 04 Apr 2021 18:20:18 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:20:18 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Daniel Axtens <dja@axtens.net>
Subject: [PATCH v6 05/48] KVM: PPC: Book3S HV: Remove redundant mtspr PSPB
Date:   Mon,  5 Apr 2021 11:19:05 +1000
Message-Id: <20210405011948.675354-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This SPR is set to 0 twice when exiting the guest.

Acked-by: Paul Mackerras <paulus@ozlabs.org>
Suggested-by: Fabiano Rosas <farosas@linux.ibm.com>
Reviewed-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index a6b5d79d9306..8bc2a5ee9ece 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3787,7 +3787,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	mtspr(SPRN_DSCR, host_dscr);
 	mtspr(SPRN_TIDR, host_tidr);
 	mtspr(SPRN_IAMR, host_iamr);
-	mtspr(SPRN_PSPB, 0);
 
 	if (host_amr != vcpu->arch.amr)
 		mtspr(SPRN_AMR, host_amr);
-- 
2.23.0

