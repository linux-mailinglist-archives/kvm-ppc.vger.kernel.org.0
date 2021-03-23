Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4FA34546F
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhCWBDq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbhCWBDm (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:03:42 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8218DC061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:03:42 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id b184so12525832pfa.11
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E62+LHQ2c3n0CwfIPm7B0azJ78zQw1H69t0RKah36K8=;
        b=FGNL+DDji348jx19Mn83RQEvXoK9PZX4LHGN9OB2tifdm1iiqaskd8lLQexxSs6rD3
         y426id3egK9kMx4AQ+2GW2Uj1255cPwJKv/3qmX90KYu9XCYsk5gjMNdh9Lv0gzUXXCn
         htQY2xlf1gUDU6u9w1ZqVMNdL3w1E/XW+0K6rCY/NRtDGbmHCT3KBPoTWrNXnpUirLrp
         JEc6MjDJ0AbcALi1vICljpBLpOcoHwxev8rY43IRn4bcFjkQdMZWzRtFC8YG6s+RBjGl
         zRgMV1ASZ2iZiaPN2WhlNwufKDe7uQYgUPYYYc+mc5QDdjiHxW82PqDxkWEZJQalqaK+
         63Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E62+LHQ2c3n0CwfIPm7B0azJ78zQw1H69t0RKah36K8=;
        b=cq6x0g4HmyH5IliFPw9SNqoX6RFcBvcqZBmit/fvwN2hDtIJpZCpjhvt7K3I5dDQPH
         s9eEI+ieLBaqj01JKZFvjE6QdeNL0JV9KpXq8CDPe2dTYtXXtlwvKDvhyCAbJoT2Rnnh
         FJI0jzxg+smC7g/gDNEv6atTigTpuKRMdYyOHPxxxTpetYfinKledV4nkWaqzmolQDD+
         AJLHw0buWcZsmTIq4e7OVzdpEerBtzbRGnWGRyAnP7fGk+KfbtRLwBYhtBxM2Z7dg0QH
         xyzIHOfDgrXhTSLORHnjao7PbA2B2C86kePuYs5Ojjqf/yuT4tmVYS6HhK/sLM5NMiJS
         cNqg==
X-Gm-Message-State: AOAM533T0FEePvMnyhdpzO5NeYF5//zoNMlf9FFhf1H2GWfaIZWB7ob/
        I1hV0hnxyEKc8u7iDh7xmjAdEj6VeOs=
X-Google-Smtp-Source: ABdhPJzBWL1NGfct+hRKcUIZhRgaHW3RPyLNqSI7XuEWacyfeZMw/kip0J0vuVktC8LArrMpXMrQag==
X-Received: by 2002:aa7:9984:0:b029:1f8:b0ed:e423 with SMTP id k4-20020aa799840000b02901f8b0ede423mr1976227pfh.81.1616461421971;
        Mon, 22 Mar 2021 18:03:41 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:03:41 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v4 08/46] powerpc/64s: Remove KVM handler support from CBE_RAS interrupts
Date:   Tue, 23 Mar 2021 11:02:27 +1000
Message-Id: <20210323010305.1045293-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
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

