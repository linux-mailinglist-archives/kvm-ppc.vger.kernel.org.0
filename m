Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AD3340EFF
	for <lists+kvm-ppc@lfdr.de>; Thu, 18 Mar 2021 21:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbhCRUWf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 18 Mar 2021 16:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhCRUW2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 18 Mar 2021 16:22:28 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4351C06174A
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Mar 2021 13:22:27 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id w3so5987219ejc.4
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Mar 2021 13:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X4/oRS2uhr/kEz6E06uYpR+t10AKIcb1LUPQvdMGgwA=;
        b=Vb2F2JRHQqypycRLbm1gwyGbVsXBae9t91ApKmpCP/DhxsGrzN4LPaGdv/9TeW2UAI
         aJvWG/TDnwhTkPbjd9S+44k/kl+NFNQUOnyXvVLlYBM0oxfarHFZW7FMa9kjtY55I/fe
         mvxU3sjLD5107a8FY0w9dGUudqKFdtsaHmznk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X4/oRS2uhr/kEz6E06uYpR+t10AKIcb1LUPQvdMGgwA=;
        b=mqmjiBpBwqE9JSjgaRTgF3Krfyi+PVkPkboKDOfHIC421bFTqZENcG+L8z9AwXhd/r
         1+drpw7EcSqX926kkua/a+l74Pr0vKLWMsci+DI/ls22rJDrn0DiZjat3abPeoscgdAN
         UP3cxqjII+D1Xdr9N7MWfuZJgT6DNko6B9fePWDbImJmrqSlwKxZShl5jo+k1lDUoZTP
         0+ViZNqDMRpxtHNbTHKVbROaBZrgKO0IBOJVKsOhlzxxQ5xb5t9+LHimULt+jn+JaGXP
         5CyLuZWcXdi7a0Mdv7u03uhIbPH2pi+tUKX5aqFmAlZUDfuLVl8ZGekpXaxxjVe6V41X
         25xg==
X-Gm-Message-State: AOAM530iktLvdoYRuBB70IZrpqezTTHlNow047dpuJJ++s15aEfCUWRE
        OR3dCxGVBqXWFERk/eFA57JS7C4MRX0kfpCKIOQ=
X-Google-Smtp-Source: ABdhPJzfcxkSGuaUBoAgfWt88lzQlz2R7EaVmZtrEsGic9XZeQ6Dfw2yxh1gXv9yshRdAgq1+W4Aww==
X-Received: by 2002:a17:906:4d96:: with SMTP id s22mr365856eju.189.1616098946551;
        Thu, 18 Mar 2021 13:22:26 -0700 (PDT)
Received: from alco.lan ([80.71.134.83])
        by smtp.gmail.com with ESMTPSA id e16sm2481120ejc.63.2021.03.18.13.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 13:22:26 -0700 (PDT)
From:   Ricardo Ribalda <ribalda@chromium.org>
To:     trivial@kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>, kvm-ppc@vger.kernel.org
Subject: [PATCH 3/9] KVM: PPC: Fix typo "accesible"
Date:   Thu, 18 Mar 2021 21:22:17 +0100
Message-Id: <20210318202223.164873-3-ribalda@chromium.org>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
In-Reply-To: <20210318202223.164873-1-ribalda@chromium.org>
References: <20210318202223.164873-1-ribalda@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Trivial fix.

Cc: kvm-ppc@vger.kernel.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 84e5a2dc8be5..5f75de54b147 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -118,7 +118,7 @@ static DEFINE_SPINLOCK(kvmppc_uvmem_bitmap_lock);
  *	content is un-encrypted.
  *
  * (c) Normal - The GFN is a normal. The GFN is associated with
- *	a normal VM. The contents of the GFN is accesible to
+ *	a normal VM. The contents of the GFN is accessible to
  *	the Hypervisor. Its content is never encrypted.
  *
  * States of a VM.
-- 
2.31.0.rc2.261.g7f71774620-goog

