Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205C332EDC3
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhCEPHK (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhCEPHH (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:07:07 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB1DC061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:07:07 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id h4so1563140pgf.13
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PQ5MsB/7FGz/hp4mvby/IngotkcaBU3resUOZZYOYwQ=;
        b=g6iPpnT3ZliKnw0w6cz92mKIrL8aw6JwK+q2GVt7lxPOwftQzvxewShVGuN0iCzLXn
         0uxNoLUQegMaGJi+FGYPD5NGylufFt3+jHZawy1ohPPxLxkB7namy49vy9Eg4asZekJz
         MK8OJ8GmkBbcGxdJWTYt/PNXWhY9sFaln8DVDLxU3/9LEiNEM2Ry6JHKIO/ZAQGR5R1y
         RgrKMWiumzb62COXn3iL8UoPt92wloaNte3OtlWq7BCV3uVToGz0KWq0d9AT0oBHQXKu
         O2Ng50RpRjTQzB7gqnWc+144QTXyxPshz0+ZeOu7TofbPx+vtTNU1Uf7OKzEgZNdbxOT
         LILA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PQ5MsB/7FGz/hp4mvby/IngotkcaBU3resUOZZYOYwQ=;
        b=P5BbCO4T0+NRQKIxj+EY+s94qEcklTFXM2uFqNy4rD4vFRxKjFSDMl3jDiJ8I7X6jP
         8qdRktFnPkmavHP410FijDbFtu0XLRXfgVPBHBgcyn4Luj9dtdqHfHqSnxuV+az0Gk/U
         aNDqypAm2yNbTCPLTe7qPe1Z5xOGEFP5LHLvyEFNV1STNECX7gwDG8D6znPZjT9QPzZV
         tYeFY4WpVLJP/u/CeTyKXGct5kRTUrnlJ9ZZOout2DBptCWNoWcdXYujLL3pamw4bBRK
         J3b2os3CIl5lDukosn8lphogSiwn9UsihjHm8ZUollDVskREput5rwonvN5oene9MqCu
         VBRg==
X-Gm-Message-State: AOAM530KnckQUgVQYBQ7AwccQw6f56NjQCL6upimYVJSxrQ3r2loEasL
        9FKTSQ0bWJufHtLeLEIuiV7IguGkSxc=
X-Google-Smtp-Source: ABdhPJwkpXMOZq43eVLRLidmAU5jRNlIb4XlQX89k2Sz3a5jSgGBvsZSRCkjgdu4PHsKYlBAk6Pbig==
X-Received: by 2002:aa7:84cb:0:b029:1ed:9b6f:1b6f with SMTP id x11-20020aa784cb0000b02901ed9b6f1b6fmr9377212pfn.57.1614956826862;
        Fri, 05 Mar 2021 07:07:06 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.07.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:07:06 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v3 06/41] powerpc/64s: Remove KVM handler support from CBE_RAS interrupts
Date:   Sat,  6 Mar 2021 01:06:03 +1000
Message-Id: <20210305150638.2675513-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
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

