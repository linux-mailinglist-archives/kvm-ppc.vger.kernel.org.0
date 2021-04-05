Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE59353A8D
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbhDEBUg (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbhDEBUf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:20:35 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9472BC061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:20:30 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id w10so1675739pgh.5
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z2fLHBAlH6bMHiwD8ZSE8QbPd3NRupfIKb21fqNXnZg=;
        b=e8CUUZP4iaV+gW+BtowJx1AyJ3m/Ri0uxOf/sCp9zB7xk7RBRD6Uza50KgP3YgvzB1
         mpUvJj9rSjaxtYn1V1J4eEbJbEKHHDaK02sGf8IiJbGHEVsevUs+siSc1gPbvf8uehVV
         PcnvbSfIr2qAze0h4EZKr++J9GDyd21pREMud5dnakft0jBNwi1159pp56AUovUwKJiX
         3tetKg4XAqeWRWb6a6obmaLAzvxtstMzFDDa2deF9dtdT9lIYCKawxmjZkyvABD1XBar
         CXwKuvM7aBUBpIjTOQ6UkHUpyyAxU4B2HwZUB6QL0Eod+oicIS5ea9ElrtlvlVPFblZ4
         lqUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z2fLHBAlH6bMHiwD8ZSE8QbPd3NRupfIKb21fqNXnZg=;
        b=DeIHEu2pHQ5sWhRy2i84KuSooiJecLsVMF0PM93udJf6oukAJ2iTIA0PDlS+cuOt2Q
         WxJikREGbSUIjUcrp93MiEwNiU916wNOCuprNouKrpvlNMOIld4hMWUy7AAxW+yWcnb+
         nW4ZVUJ4ngugD/vXc1R3eGj75wQmjT24S22m5E89t+0rq4304yzaanNXJKa/ayEjrH2V
         iA6/0uVrCIxZVrQ87G8ktrR/47h3bkb6zUEVLlNwC7qCmD64XCy+cgEl4/ZbvueCyrAV
         g7IN5h8yL5cFR4azfAoRKOqSi7v9W/9KI75USMDOqg7gNr6XWB/uQ74ALu/h6R1pdXNk
         Ow1w==
X-Gm-Message-State: AOAM531ZlGVXDZPGs1YdsNTW80+Xv2acoGlxB0uq5cX1VAyMSSvKP6Ok
        /iaU5RU4R2RKVr9DibcApyFE/9gSPCctSw==
X-Google-Smtp-Source: ABdhPJxv/d+H/pav+GLr07qdpRh1R0m5IeEnIE0Oey9cIjcnLA8r9QXq7CzegkEoEWf0qP+uaGdaqA==
X-Received: by 2002:a63:43c2:: with SMTP id q185mr20716518pga.41.1617585630041;
        Sun, 04 Apr 2021 18:20:30 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:20:29 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v6 08/48] powerpc/64s: Remove KVM handler support from CBE_RAS interrupts
Date:   Mon,  5 Apr 2021 11:19:08 +1000
Message-Id: <20210405011948.675354-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
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

