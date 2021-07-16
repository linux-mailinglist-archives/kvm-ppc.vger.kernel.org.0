Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A21F3CB0CF
	for <lists+kvm-ppc@lfdr.de>; Fri, 16 Jul 2021 04:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhGPCqM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 15 Jul 2021 22:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbhGPCqM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 15 Jul 2021 22:46:12 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A883C06175F
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Jul 2021 19:43:18 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id p22so7602541pfh.8
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Jul 2021 19:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dSEHJbd1hey9lHxWnAlObrqe288gDj7m/QSLgChPhgE=;
        b=hOuzqHqFtvdC9hxpQPp5U1GyFTrRbpAW0C/rjfm0F3Ln0k63EjNK032ae3P4kZBLME
         lClk9UUT+g20AEA3B4m67QlEex6ty+DJLLPHB70lQrHM6QezcPkh33Uf2GN8+ji3Hzul
         hN2EyXlfm5i4D8T5vUd76/jD0cPfn114VQE1GcqA3+7OzUMnmXpRBlch+nUtX799CJFU
         qoTf92TemfjtYkXgCdmuI0Dh0v993jxbUim+hxRPMFN0IREk9bcZoX3WlrVZ4DzFMWLi
         FSBo1pCSaLIRINQxEHw+Z9LhH0u0jHnNQ+sT5s8zillbngJjWd72wxvCIQRlhJIkziFt
         1sTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dSEHJbd1hey9lHxWnAlObrqe288gDj7m/QSLgChPhgE=;
        b=BUAFxRTGMXutiG/bvIXECy4iCxTz0YeT9kFm3E/Ry36fAUOufe/qmeVXZyoI12E5YI
         kKJ2xag1GoosBbMDGTPnkjdCIRcvqijVpOq3iUm5Wjdio5pk6c/Yutc+Yzu58TeURuEM
         baWfY+XfnMuEfzz4a553mpbBn4xS1jeSF5czQLulOqIdqUGyNH9fetA2jCwT4g5JEgII
         hIKPs0I0rWKFmWhAvjhtda5oXv+Vmb2RqRbLHN/6fr5dHcE316u/JaV18hWb7VX1xRZ+
         tibnPKy7wUD8ytwu+2fJVWVA5wumgkcXetgWFkDxp9yZ1NqQp6mLNFHkZi0m6A4Gaiyt
         bdbw==
X-Gm-Message-State: AOAM531oWWDM+VD02h2zVkH1Q2GCpzdrrXAwzD9B/h+EdZedwhHXFirr
        FZPIR92eCV2XAhHIM2ytjGbyQ5743Ns=
X-Google-Smtp-Source: ABdhPJxcWKuA3kESqcvAKzDHcBRLi5yIGY0dr8pXIg8lx6f0l3oTrMKHYzhwjcqXrbzseApkyub3yg==
X-Received: by 2002:a63:f91a:: with SMTP id h26mr7585259pgi.234.1626403397395;
        Thu, 15 Jul 2021 19:43:17 -0700 (PDT)
Received: from bobo.ibm.com (27-33-83-114.tpgi.com.au. [27.33.83.114])
        by smtp.gmail.com with ESMTPSA id f3sm8298406pfk.206.2021.07.15.19.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 19:43:16 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH 1/2] KVM: PPC: Book3S: Fix CONFIG_TRANSACTIONAL_MEM=n crash
Date:   Fri, 16 Jul 2021 12:43:09 +1000
Message-Id: <20210716024310.164448-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

When running CPU_FTR_P9_TM_HV_ASSIST, HFSCR[TM] is set for the guest
even if the host has CONFIG_TRANSACTIONAL_MEM=n, which causes it to be
unprepared to handle guest exits while transactional.

Normal guests don't have a problem because the HTM capability will not
be advertised, but a rogue or buggy one could crash the host.

Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Fixes: 4bb3c7a0208f ("KVM: PPC: Book3S HV: Work around transactional memory bugs in POWER9")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 1d1fcc290fca..085fb8ecbf68 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2697,8 +2697,10 @@ static int kvmppc_core_vcpu_create_hv(struct kvm_vcpu *vcpu)
 		HFSCR_DSCR | HFSCR_VECVSX | HFSCR_FP | HFSCR_PREFIX;
 	if (cpu_has_feature(CPU_FTR_HVMODE)) {
 		vcpu->arch.hfscr &= mfspr(SPRN_HFSCR);
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 		if (cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
 			vcpu->arch.hfscr |= HFSCR_TM;
+#endif
 	}
 	if (cpu_has_feature(CPU_FTR_TM_COMP))
 		vcpu->arch.hfscr |= HFSCR_TM;
-- 
2.23.0

