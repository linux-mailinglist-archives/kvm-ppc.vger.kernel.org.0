Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB87351975
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbhDARxn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 13:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236548AbhDARp3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 13:45:29 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82F5C0F26DE
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:04:02 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id l123so156842pfl.8
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z2fLHBAlH6bMHiwD8ZSE8QbPd3NRupfIKb21fqNXnZg=;
        b=OE5ChnAoOVVJ2ov7mowsCNwKR9BskeD7oSKGrMX1lwNya0CAOBUzt7EbGzbH590EP3
         qhtR+REJGQbwoY+cOWdyv6bLLZ/BxOXMX4MxgH8TVd0Dw//fBRiMMTLzAiG99xET6QgV
         xPJTfeiOTqx/ecsiiSKwE8G+gKaps9ElWimURHsZs/2uWZSB1i5HeAzBdlN6MkhTmHKH
         0xFPHxsvo12FYDrex/KhH0O9uv3guhc6pIxO8jxspKGhKNHJHrsaOidML/BFDY90M5i3
         PwyvMJ8LSBAvrn/MYK48E/rrnxxpUZvO015giVJWoSft/UQ7I3qSxiE02EWfZlee9PkD
         qPkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z2fLHBAlH6bMHiwD8ZSE8QbPd3NRupfIKb21fqNXnZg=;
        b=AdkO3zkeVdsav+LeDjitOcUR8t8DxRBLzdkGgat0/xZnl+zraAvfs3Vc5ScPQbgCOw
         n1qRmSmBkeaIcK91gI/PFVWfCQc9f/EOQdYOoTAR9xv0fqtmbfs9djZRZ0Fx75mlCl1Z
         ZqBcUScC+FviOJk+bA9JElvPvD7DA4EcOsfj5OjT8iz4k1BnuVfrqju7Z1Lkxc70CWLQ
         SG1bQO7Ig8Lbq+YxLZtAVMQe48sxPBdkbm6bj6bKOVjL1kM6H/IOtJgR7+GKk/BFco4B
         Ld5p4yus/C4DEC+YcIf8R8pcQUggLmhHIxc2I27JTItoKMz9vOBc/yl1CH7GBdIBN2pk
         12Fg==
X-Gm-Message-State: AOAM531YyWMYiRkXXCdHf1IA5DIt7iJUF4kfbFRzFnzj5SPLxBs49UDn
        inY9djWXVH1tOLRGKKJ8/Esq61z58TA=
X-Google-Smtp-Source: ABdhPJzxz+vr9AekQuDBEXARJJpGopwD6xZpfUbbYoAp6aU5449vGg1be08WoKVdmpMWbPmnVzjRiw==
X-Received: by 2002:a62:6883:0:b029:220:4426:449c with SMTP id d125-20020a6268830000b02902204426449cmr7826099pfc.14.1617289442265;
        Thu, 01 Apr 2021 08:04:02 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:04:02 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v5 08/48] powerpc/64s: Remove KVM handler support from CBE_RAS interrupts
Date:   Fri,  2 Apr 2021 01:02:45 +1000
Message-Id: <20210401150325.442125-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
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

