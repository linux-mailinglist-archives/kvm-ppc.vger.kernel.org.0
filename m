Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185AC37F7BD
	for <lists+kvm-ppc@lfdr.de>; Thu, 13 May 2021 14:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbhEMMXb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 13 May 2021 08:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbhEMMX3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 13 May 2021 08:23:29 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54739C061574
        for <kvm-ppc@vger.kernel.org>; Thu, 13 May 2021 05:22:19 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id i13so21697423pfu.2
        for <kvm-ppc@vger.kernel.org>; Thu, 13 May 2021 05:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eGM6R89PIkkLJyjMzOWuMBkIHDUaBOLuaplgVGCT/7E=;
        b=E9KfwotHdvYEjj2A4qq8ORGAqRkO7GXAq0tT3p/PX/YzRcMvf1pqk577U+KLoGQrQv
         b5tsigYWaJ85KKNokHfFH1gPvNXvjYm3Lw2ddrXVDJXwNx+zC/YKkrWdzilG2WynLAeh
         Itf9f/7kBHpibqwCNsIgjhaCiioOrApaSOmB6TyXTg/rXeMf9PrgECMnls2BOFzZ5KX+
         JQJ2YtBZ7kDbHM20PCmnFmj4caLYrweEa0JPhLt83oZyeqC6G0R/lg9mpjXAKmNaCm13
         dIaUeq1r7GD++TBpHxLZ1XvwIswUoABNrDt5XlZQ9rqBKKOy7F6ULI3sX5yFnVDPPawJ
         2h2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eGM6R89PIkkLJyjMzOWuMBkIHDUaBOLuaplgVGCT/7E=;
        b=QhbmZtdtyn2MJadI/J8R32iVOm5S4MMaqDvwnfrgUPq108OpjctkLKS5cG4xaYKMue
         iV4Y5P5I5OHKfroFxhAT55INTLvu9v++EsBM7WzdYBqm6hZRpqyef6xezreaG48iT/OX
         VXw+99LAQM2OiiiS3GXy8onUHC5cWOtgGyUdpugvErlCbb4NPAQvv9NRKQQbgrmtBlN3
         fb9Hbqsx+Xbk8Qiy1w8DuA71gEP8viJpEcq/VEWnDAHnPlasRegHlxdzy9svqEJ+sD7e
         dBlFDAQVPpBVRINSt3rM90R6l//WokvKm5CYOkl7oyiO489rwK2NnQ3NAEykBDmxOTfK
         3qLQ==
X-Gm-Message-State: AOAM532AuRUdB/99M7ZlUNJAMipplPyScmu61O8OXAvN1poeG6rK80Ih
        /PywsQkoIyNx6RqP/VAa6uf1RKLGqnm+vA==
X-Google-Smtp-Source: ABdhPJxAyTpU+8Q758bSn1GYBTv27JgQt2JQCrXyBX7dfbC28sizZ0ltNivT6CCp0329moU3l6ERbA==
X-Received: by 2002:a05:6a00:1c63:b029:2a8:b80a:1244 with SMTP id s35-20020a056a001c63b02902a8b80a1244mr33088578pfw.72.1620908538849;
        Thu, 13 May 2021 05:22:18 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (14-201-155-8.tpgi.com.au. [14.201.155.8])
        by smtp.gmail.com with ESMTPSA id mp21sm6892416pjb.50.2021.05.13.05.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 05:22:18 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH 1/4] KVM: PPC: Book3S HV P9: Move xive vcpu context management into kvmhv_p9_guest_entry
Date:   Thu, 13 May 2021 22:22:04 +1000
Message-Id: <20210513122207.1897664-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210513122207.1897664-1-npiggin@gmail.com>
References: <20210513122207.1897664-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Move the xive management up so the low level register switching can be
pushed further down in a later patch. XIVE MMIO CI operations can run in
higher level code with machine checks, tracing, etc., available.

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 8a31df067c65..68914b26017b 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3558,15 +3558,11 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	 */
 	mtspr(SPRN_HDEC, hdec);
 
-	kvmppc_xive_push_vcpu(vcpu);
-
 	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
 	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
 
 	trap = __kvmhv_vcpu_entry_p9(vcpu);
 
-	kvmppc_xive_pull_vcpu(vcpu);
-
 	/* Advance host PURR/SPURR by the amount used by guest */
 	purr = mfspr(SPRN_PURR);
 	spurr = mfspr(SPRN_SPURR);
@@ -3764,7 +3760,10 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			trap = 0;
 		}
 	} else {
+		kvmppc_xive_push_vcpu(vcpu);
 		trap = kvmhv_load_hv_regs_and_go(vcpu, time_limit, lpcr);
+		kvmppc_xive_pull_vcpu(vcpu);
+
 	}
 
 	vcpu->arch.slb_max = 0;
-- 
2.23.0

