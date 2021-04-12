Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158F435B843
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Apr 2021 03:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236345AbhDLBtg (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 11 Apr 2021 21:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236273AbhDLBtg (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 11 Apr 2021 21:49:36 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B94C061574
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:49:19 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id l76so8173189pga.6
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z2fLHBAlH6bMHiwD8ZSE8QbPd3NRupfIKb21fqNXnZg=;
        b=p7hMf2tYA10VOWRMIzi44LqFQ2CoDByIZfx56TEpJUgd1gHL6CCsQmXTE8FTsgaMvD
         peH4lGHU6CvfW++H+LD1R4Y7k46i028/OVBscxf8tOIz5zUnPnIsbDUPdLlkRYqIEVgf
         ZHcTaGlworvRlmEnIQmfgYP7SDjFMeoymNAIVAU8pK+7JIQDMc34nYCjvT0+Ktpa8Q+I
         aVGufIrDy3waGFh8SKgnbJpa6FWYQGfXX2UfMUdqBEjqQnnYsZrdVBBrJtZ2reVrxLiX
         LMDm+Kou92cHhc2MmYao3uJCCkaoA/piS/1DpgTkc/X9ZnINTvg7afHtw9QjOUAEZmq0
         ie9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z2fLHBAlH6bMHiwD8ZSE8QbPd3NRupfIKb21fqNXnZg=;
        b=JL4nhVEjOvBV7q8ISEHJQaG4Eb6UziTKUN5vhPHyqW9vFYypavE8feDO9UayXPf3Vf
         R2TbiPeeoK3zCOsU6kpd83DHt4uMeUMtbGlVE3ghxBsHHB+FF0mWjjgjAsIeCZUBoaIN
         aXnFhRhXJXua8kFqkWnxrFj2YZ9H5/aAZ49EExWTyjybjxOcO42LOeuI204uFdB3Gol4
         metgoaBFjgyB07Hdz41ecA0Ql2jb8QGxSGtCGOHIWApEY5KN4gFwF/k7jX460tEHPBwT
         SiqR3HS/CGCdZaQ7AIFk9/KVmXtvGcJipnFf/Led/gwKjoZGb/Whg4AVdF7M3vrDH1X3
         o3ew==
X-Gm-Message-State: AOAM531U05taXYaGEeFCaCpJxie2FEN4vnHnxsmVKw+cfnUcT9XxQIHz
        osN3McuLFLK/lOCeQ0oNJn+iYa0I6lg=
X-Google-Smtp-Source: ABdhPJyGwKQHQ40lX6Tr0ZUdfWy4PrLWq/Nc/fBvKNzpneGC8SGnH8UVYCjX+1KZbFLpfw+CAVlbMQ==
X-Received: by 2002:a63:6682:: with SMTP id a124mr15283236pgc.363.1618192159275;
        Sun, 11 Apr 2021 18:49:19 -0700 (PDT)
Received: from bobo.ibm.com (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id m9sm9502345pgt.65.2021.04.11.18.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:49:19 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v1 09/12] powerpc/64s: Remove KVM handler support from CBE_RAS interrupts
Date:   Mon, 12 Apr 2021 11:48:42 +1000
Message-Id: <20210412014845.1517916-10-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210412014845.1517916-1-npiggin@gmail.com>
References: <20210412014845.1517916-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Cell does not support KVM.

Acked-by: Paul Mackerras <paulus@ozlabs.org>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/exceptions-64s.S | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 8082b690e874..a0515cb829c2 100644
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

