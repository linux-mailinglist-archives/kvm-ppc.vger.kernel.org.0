Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4229E3D51DF
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbhGZDMN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbhGZDML (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:12:11 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759A4C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:40 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso5069958pjo.1
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uA8TbX3pYs2LbKbx2AqpBXWdMPxg/1XwQyLtHZ8k4pk=;
        b=q0zvUm3TdOgPeQLfr9sl7pSpHI3OiRrMO74Sa2ndO/muk12RQUeSUujFdcIE80IV7P
         F4gtTODUo9IguULkuthSrvAqvksQeHi9a2ud4K1wl9wPv5e31dnvzLQznN0gbEBWpZ4y
         8AZouMK2qFnGJkyFIeh/6kl3o8Z280aQ5Xx/burOJgp09wXcF/l4LnnVvK/dbXa6kB2B
         yMyxrW3DQjrEv6eybQeFtlsL83USLO/9JJRVpcH68YkMUm3HCSGT5phXnxq8t9ApUgRO
         /yJSOpFbSBYNQjTv2IwpcT20cz7LwuvTjrwSKf0r1NApVreyV0AYUk7F5nPiDnAR5y0q
         I5Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uA8TbX3pYs2LbKbx2AqpBXWdMPxg/1XwQyLtHZ8k4pk=;
        b=WKntqklP1Sg5bmX+i+iAnRyFOi7GhnAKDs1r1Bz1+KRJyWVRInYqN4+gjeZt65glAM
         ttwpqiRhaRN1IzY1N3OlXIfPFNEgm84vpU6aDVsxPrGjU+etrCCSeAEkkZYx6+s0Msm3
         LQo7Nhmj07S8HqeMjq/67ME6GZPwSk9h9i5WfgQdgOeOD4gJTPuDg3MoMM9XXOcgft4w
         UORiTlLFgB1XFv7q9kSUCeuq+2XuYQg9yJnOcffAOsgli2oy73J11n8BlHqx8Q0Rqv6u
         S/cbKuoz+a7DuTbq/nZneVNfQ3ndWQpKbEnVKIe+QXhFVodUJzzNEu+ge/Tlzs0EBp5N
         sy1Q==
X-Gm-Message-State: AOAM533Img/sXcBX3sJ0vHdc/28E/dBSOyqcf7LjZXMOLVZI9vc0T5JY
        JJlpT/xqzRGFtEngQs7Gy4Q4Rn+WY/4=
X-Google-Smtp-Source: ABdhPJyDzzba2kzswPB+YgoKplhqURknNv8gSWMDKpLSXONGI2J1wXWOnb44s6R5WiFC76hLE8jz6Q==
X-Received: by 2002:a63:f712:: with SMTP id x18mr16448939pgh.389.1627271559976;
        Sun, 25 Jul 2021 20:52:39 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:52:39 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 50/55] KVM: PPC: Book3S HV P9: Add unlikely annotation for !mmu_ready
Date:   Mon, 26 Jul 2021 13:50:31 +1000
Message-Id: <20210726035036.739609-51-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The mmu will almost always be ready.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index ee4e38cf5df4..2bd000e2c269 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4376,7 +4376,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->runner = vcpu;
 
 	/* See if the MMU is ready to go */
-	if (!kvm->arch.mmu_ready) {
+	if (unlikely(!kvm->arch.mmu_ready)) {
 		r = kvmhv_setup_mmu(vcpu);
 		if (r) {
 			run->exit_reason = KVM_EXIT_FAIL_ENTRY;
-- 
2.23.0

