Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4507F345498
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhCWBFd (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbhCWBFR (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:05:17 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DC5C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:05:17 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so11451782pjh.1
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3HOlzMOQTyMx3+oJJcmS0eDxUvWov/rK0Ppdfq9k4uM=;
        b=k1lc0eiPw3tpV/7pFHwxf8llaTStIBB1onC3gyCxio3XhdBXYN4ECk1ttrgEOsKnAK
         liFQjQ5SeHTEQzXLZKFTiXFcRfmg6D3QZ3TUCEq5S8bhGK2rCG9NwVC3Flp1XwXPsSZA
         N/4JbP2uFCBN+f+A9lofvw//p6KvkDW/Wt772RHP3yCso13EOqXGOa63vX8FF+uECa+A
         dAckUB1CaBl/hWj1KImteVlspTJFAhfg1esqhyH7csF7G1RjSf3luqiTR37QPxRA+njv
         toFrA7FHKbXhmHstj1ABu6Ypz2CCoGWsGFsypni8TbIgOCjaVb240pMQ0NIA+vXsCcMp
         +Wzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3HOlzMOQTyMx3+oJJcmS0eDxUvWov/rK0Ppdfq9k4uM=;
        b=PwLUTrH0tTpPDm4Vy/MuRuO6QiRZ+3XIGCPqbSC46mukaKwtZszXLJ22VEqkg9zwKQ
         L1TpFnhXlqOrWeHwizjKpEavNFjlTA7F4IuNNZ4gN+GrNunxNr6PNanStkk4QXFq6C8p
         bfFU3mmYDpPNjLh78Gz952bQgQis1ExbwvhyDVlqEWJAKjS2+RQ0Nk56GPeJNWsUHQH0
         /3q2e9ddueRG1XxAU8/e3s2RBIO7MiQsggcXm5Rnyr1TX+HB7/G9VqnmFkXx+u4g1fDC
         709FwsafTnlei/12jK1BOvibb3EJlVLgFRP3VXMDKuAjRGsJjlfzNJiCSkXqJSJBsugl
         WDNQ==
X-Gm-Message-State: AOAM530KyXzp4IFfZxYuBMfMBpE0TVUQ261fSd396p7mKXQza/ST9Atj
        OwfvmZWoi7K1WD+nxIKT3z6UTex82sk=
X-Google-Smtp-Source: ABdhPJyteIdH4M5PV71IhIZ7DJUhfYQnBfviAaAtPx0jfh7eSevP5rjryXeXQrWDt+Zak4sIzQF1dw==
X-Received: by 2002:a17:90a:1642:: with SMTP id x2mr1883961pje.88.1616461515524;
        Mon, 22 Mar 2021 18:05:15 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:05:15 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 41/46] KVM: PPC: Book3S HV P9: Allow all P9 processors to enable nested HV
Date:   Tue, 23 Mar 2021 11:03:00 +1000
Message-Id: <20210323010305.1045293-42-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
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
index 85a14ce0ea0e..0f3c1792ab86 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5420,7 +5420,7 @@ static int kvmhv_enable_nested(struct kvm *kvm)
 {
 	if (!nested)
 		return -EPERM;
-	if (!cpu_has_feature(CPU_FTR_ARCH_300) || no_mixing_hpt_and_radix)
+	if (!cpu_has_feature(CPU_FTR_ARCH_300))
 		return -ENODEV;
 
 	/* kvm == NULL means the caller is testing if the capability exists */
-- 
2.23.0

