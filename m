Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507423250C1
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhBYNr5 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:47:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhBYNr4 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:47:56 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF9CC061786
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:15 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id u12so3318670pjr.2
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PQ5MsB/7FGz/hp4mvby/IngotkcaBU3resUOZZYOYwQ=;
        b=HhY4kn+4A52rg4eUJqgs1XKXan9wsa8JPqLC3eA0f+yqOdX2ZpkIqvbuN/g77kpbkD
         sPosXd4uKndvPb0ihaPDv7+wXzvO7bTKNf4+YOQfFXFg7WlCjbNtZyLVMix4LhCNq1MS
         TcnJOg7D1xW1OLTdamucwA0lIJb4V5zOiCYse5gp17AH+N+61tdX5Ylnd9zCOKDnjtIK
         U+gPNs+IUnsZzg1XFxNslhW8ra5VO7msMCPm2/u+I8PgeXXbsQcKn8EE+J7UkvBAekM+
         WfsDSIr5hEQQd+35KEtOInM7B1WUn8lNrzuUDVox84JVfLnQjSyL5ih6W4WeXJfj0nJd
         1/UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PQ5MsB/7FGz/hp4mvby/IngotkcaBU3resUOZZYOYwQ=;
        b=fQ42iwRaLWHxNTnUxDJbwzpAC0o+YFas+K2gt69OFXaH3DjSXlBNHx4b7ArC8n5R/X
         BEM2PQZoEyZkr2taVBzqFl0gebhR97ED9lqmPkgm/n8tlIpE16016Q9N19++qyixoRNx
         5u9BcITnLoBWMOyP472qdH9/0kSFKrfl8/TEmqHC35Oq1qYhxz1a9bSHaBeQaGCHcWdO
         Hu436OoprObSS5ab+1TFvOtsS93UJaJiRWNOhQhACpGZhejc4kRGlyrToaN3R0IUTMxk
         0Ag4FWnfSGRsOj7f0/2bOIRXFZJh89o2B/iAtnZxqQAnlfvxj1xWonBr52U+7YI0OpNI
         0vAQ==
X-Gm-Message-State: AOAM533Mztuy8je6JfpGYroIf/dU0BXmUcuGFChmZev9+2FECQOQhJgT
        p7mW/VrV+39kv7scEKsn8NUTACGKUyU=
X-Google-Smtp-Source: ABdhPJysSqXiQZVbglCTK6LYw197cPu65igol+mtRJ9WMgCDydIOdFnpcLBayFgC7m+/QntFqOgZKQ==
X-Received: by 2002:a17:90a:5302:: with SMTP id x2mr3506949pjh.232.1614260835067;
        Thu, 25 Feb 2021 05:47:15 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:47:14 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v2 03/37] powerpc/64s: Remove KVM handler support from CBE_RAS interrupts
Date:   Thu, 25 Feb 2021 23:46:18 +1000
Message-Id: <20210225134652.2127648-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Cell does not support KVM.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/exceptions-64s.S | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 60d3051a8bc8..a027600beeb1 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -2530,8 +2530,6 @@ EXC_VIRT_NONE(0x5100, 0x100)
 INT_DEFINE_BEGIN(cbe_system_error)
 	IVEC=0x1200
 	IHSRR=1
-	IKVM_SKIP=1
-	IKVM_REAL=1
 INT_DEFINE_END(cbe_system_error)
 
 EXC_REAL_BEGIN(cbe_system_error, 0x1200, 0x100)
@@ -2701,8 +2699,6 @@ EXC_COMMON_BEGIN(denorm_exception_common)
 INT_DEFINE_BEGIN(cbe_maintenance)
 	IVEC=0x1600
 	IHSRR=1
-	IKVM_SKIP=1
-	IKVM_REAL=1
 INT_DEFINE_END(cbe_maintenance)
 
 EXC_REAL_BEGIN(cbe_maintenance, 0x1600, 0x100)
@@ -2754,8 +2750,6 @@ EXC_COMMON_BEGIN(altivec_assist_common)
 INT_DEFINE_BEGIN(cbe_thermal)
 	IVEC=0x1800
 	IHSRR=1
-	IKVM_SKIP=1
-	IKVM_REAL=1
 INT_DEFINE_END(cbe_thermal)
 
 EXC_REAL_BEGIN(cbe_thermal, 0x1800, 0x100)
-- 
2.23.0

