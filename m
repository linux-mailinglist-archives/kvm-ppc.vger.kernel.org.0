Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243A431F51E
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Feb 2021 07:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhBSGge (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Feb 2021 01:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhBSGgd (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 Feb 2021 01:36:33 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7A1C061756
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:35:53 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id z68so3063768pgz.0
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PrFlMcs7Ybnsn02EnHS92bPPaWqalxkG7oX5C7Pez8g=;
        b=IfVW3ZfBDzz55MElYRD11Rr20onopgcWUSLxiyFBb+3qfeQiP4cVeU8WTZvUL13TUQ
         YK/K6NwXaegOFe26eMIAobzMcEFYLq6iAh+n/7//xmEXoRhHcqROTNkmjr5xQJavRdog
         BJSFLudpscWm+skO4D/vDbQpRQDbmjN6XygEPZIiSPV0XDOVKt2soTGWLV1JOxn5YhJ4
         5zYJzHdT+24WqFSQa8t/ofgiSXjiMi5TuWzBpkGa6o5XbSw1wWU/o5dB3SA5k3ZJYynQ
         tEqfnSdpj+HsE/uVhxgt9vkWrM2rHanyyqoHxPmdQ+B5ufIIWZmOuyUwUc7T5wuoWitU
         AQ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PrFlMcs7Ybnsn02EnHS92bPPaWqalxkG7oX5C7Pez8g=;
        b=lZv6ye7cl0YBC8SQYe9XpitkZ4sjscVcTD9R4raE11E6mTABzUSllcCBMYV01e5gZY
         DCMzaRbdCxsaRHh3YY+PdKY/zPsDU0i41ncxUU42zzH5NlPQAbR0TCRbcbb6fSW3fGOb
         o2pwtZEeozbAtYBkTM7lRWEzvP5LO+JSc263MrEdmB5qRL4Sp6wtvSBNRAehC3SuexCj
         hLQew0Bgxlikm9KQPY5j53Q+US5yy9zbzdVEhrAEaDMLuBIeyCybpAE7vQqYhZyeWMz+
         9/2Ek3p+spCgRz2RWvLDb8QtaN13oohhano2HAF4HUkq5Ef71pl3aBGpfQU98M+iL0oK
         WrIw==
X-Gm-Message-State: AOAM530eg63OPi374rleCuDe9KOMoO0pcQUS9IxRBzGMGHhbyi/07pn5
        GYskf+E9MCsaCfoa8m0Ln70p5Kg8GUQ=
X-Google-Smtp-Source: ABdhPJxZnk4f0418KNqQnX3lXby2C82pRAFFA5vIDjprt2dOjZxUCuS3S/9M+qNXQYf3inmOYUKcSw==
X-Received: by 2002:a63:155b:: with SMTP id 27mr7092919pgv.269.1613716552746;
        Thu, 18 Feb 2021 22:35:52 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (14-201-150-91.tpgi.com.au. [14.201.150.91])
        by smtp.gmail.com with ESMTPSA id v16sm7813099pfu.76.2021.02.18.22.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 22:35:52 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 01/13] powerpc/64s: Remove KVM handler support from CBE_RAS interrupts
Date:   Fri, 19 Feb 2021 16:35:30 +1000
Message-Id: <20210219063542.1425130-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210219063542.1425130-1-npiggin@gmail.com>
References: <20210219063542.1425130-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Cell does not support KVM.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/exceptions-64s.S | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 39cbea495154..5d0ad3b38e90 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -2574,8 +2574,6 @@ EXC_VIRT_NONE(0x5100, 0x100)
 INT_DEFINE_BEGIN(cbe_system_error)
 	IVEC=0x1200
 	IHSRR=1
-	IKVM_SKIP=1
-	IKVM_REAL=1
 INT_DEFINE_END(cbe_system_error)
 
 EXC_REAL_BEGIN(cbe_system_error, 0x1200, 0x100)
@@ -2745,8 +2743,6 @@ EXC_COMMON_BEGIN(denorm_exception_common)
 INT_DEFINE_BEGIN(cbe_maintenance)
 	IVEC=0x1600
 	IHSRR=1
-	IKVM_SKIP=1
-	IKVM_REAL=1
 INT_DEFINE_END(cbe_maintenance)
 
 EXC_REAL_BEGIN(cbe_maintenance, 0x1600, 0x100)
@@ -2798,8 +2794,6 @@ EXC_COMMON_BEGIN(altivec_assist_common)
 INT_DEFINE_BEGIN(cbe_thermal)
 	IVEC=0x1800
 	IHSRR=1
-	IKVM_SKIP=1
-	IKVM_REAL=1
 INT_DEFINE_END(cbe_thermal)
 
 EXC_REAL_BEGIN(cbe_thermal, 0x1800, 0x100)
-- 
2.23.0

