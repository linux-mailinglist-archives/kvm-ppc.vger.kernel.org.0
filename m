Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919F63E9540
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbhHKQCf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbhHKQCe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:02:34 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C8DC061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:10 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id w14so4172234pjh.5
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jCxdivQtSElLr5d9idnYO7f6LUBSBDiT6V+2D6aLUKg=;
        b=aDlRdsD4I51ZZcZxRl0CmF1zHn4RYxWsHJ4/iLOfOd8NbRtE2QUQg60i0d0dn6IaSf
         OHfNgTaHEh1+Zwo1ZuhciLciJua9HiZI+t7dR3KthS+vpzKhjvDV3V+j6iO11KMniFWO
         y95cThRmDMfOwBvQkTzrbjQBxBPBwBe2YckNxbDGA2ypVJO61Bcg9OE9MkLoDt8vB6jM
         9vxgiCduW63oudsTcY9h4a/lZwv/HWqdxfSNIYUsgTYksCvhch9IcYH1y8qPW/Yd0HhC
         C3qTG2E1WYWgayKHvqimfxuU00dNXFCe3QG2Nnz3quJpubM7fQ5Nt0U77ieT1iHsxe/h
         wJqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jCxdivQtSElLr5d9idnYO7f6LUBSBDiT6V+2D6aLUKg=;
        b=hEywnByEVoGWRZYOQmu6eO5m3JbTH8p5zxr/DCI9ILDraCZLfb3LM9DaFV08REFu2/
         DnR6BleVXLyCXH13/eF2o5l1QkJVtp5o0AX9eZyBePCkUJO5+q/CdEEE+IiSwA0juyrG
         VYD2zy9049UEzhc6ZUluDCb/+2SsOV+4v1UStLHDzKwKyIhsWHAuj9s9jErN09KSbhaa
         oxSSaZoLVRgO8HEQEpTDI2V9rx9MqqgmjM8B25b0a9OfOtulDHD78S+SZ343QJO3vm96
         rA/gkjPqb56s9oxgPEozbX5sNHA5eKlAqpi5g0zNdfQj4evGIz9w2hHQ5BigYSSsfrrF
         HVNg==
X-Gm-Message-State: AOAM533oK71vyukkIAR/EkbrGh1wm6obX2ssyXBX1Ef82CeB5PLOechV
        zZ5wzescOXqFEymJZUypy2Llb+xGYpw=
X-Google-Smtp-Source: ABdhPJwOe47kCVYD2CjJf/UNfti3v0EKt3Z98V8sfY0s93Cmt6jR9l3cIXm7nAZJRd6rLoInIll1YQ==
X-Received: by 2002:a17:902:c711:b029:12c:9b3c:9986 with SMTP id p17-20020a170902c711b029012c9b3c9986mr19502076plp.44.1628697730313;
        Wed, 11 Aug 2021 09:02:10 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:02:10 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v2 10/60] powerpc/64s: Remove WORT SPR from POWER9/10
Date:   Thu, 12 Aug 2021 02:00:44 +1000
Message-Id: <20210811160134.904987-11-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This register is not architected and not implemented in POWER9 or 10,
it just reads back zeroes for compatibility.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          | 3 ---
 arch/powerpc/platforms/powernv/idle.c | 2 --
 2 files changed, 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 1a3ea0ea7514..3198f79572d8 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3770,7 +3770,6 @@ static void load_spr_state(struct kvm_vcpu *vcpu)
 	mtspr(SPRN_EBBHR, vcpu->arch.ebbhr);
 	mtspr(SPRN_EBBRR, vcpu->arch.ebbrr);
 	mtspr(SPRN_BESCR, vcpu->arch.bescr);
-	mtspr(SPRN_WORT, vcpu->arch.wort);
 	mtspr(SPRN_TIDR, vcpu->arch.tid);
 	mtspr(SPRN_AMR, vcpu->arch.amr);
 	mtspr(SPRN_UAMOR, vcpu->arch.uamor);
@@ -3797,7 +3796,6 @@ static void store_spr_state(struct kvm_vcpu *vcpu)
 	vcpu->arch.ebbhr = mfspr(SPRN_EBBHR);
 	vcpu->arch.ebbrr = mfspr(SPRN_EBBRR);
 	vcpu->arch.bescr = mfspr(SPRN_BESCR);
-	vcpu->arch.wort = mfspr(SPRN_WORT);
 	vcpu->arch.tid = mfspr(SPRN_TIDR);
 	vcpu->arch.amr = mfspr(SPRN_AMR);
 	vcpu->arch.uamor = mfspr(SPRN_UAMOR);
@@ -3829,7 +3827,6 @@ static void restore_p9_host_os_sprs(struct kvm_vcpu *vcpu,
 				    struct p9_host_os_sprs *host_os_sprs)
 {
 	mtspr(SPRN_PSPB, 0);
-	mtspr(SPRN_WORT, 0);
 	mtspr(SPRN_UAMOR, 0);
 
 	mtspr(SPRN_DSCR, host_os_sprs->dscr);
diff --git a/arch/powerpc/platforms/powernv/idle.c b/arch/powerpc/platforms/powernv/idle.c
index 1e908536890b..df19e2ff9d3c 100644
--- a/arch/powerpc/platforms/powernv/idle.c
+++ b/arch/powerpc/platforms/powernv/idle.c
@@ -667,7 +667,6 @@ static unsigned long power9_idle_stop(unsigned long psscr)
 		sprs.purr	= mfspr(SPRN_PURR);
 		sprs.spurr	= mfspr(SPRN_SPURR);
 		sprs.dscr	= mfspr(SPRN_DSCR);
-		sprs.wort	= mfspr(SPRN_WORT);
 		sprs.ciabr	= mfspr(SPRN_CIABR);
 
 		sprs.mmcra	= mfspr(SPRN_MMCRA);
@@ -785,7 +784,6 @@ static unsigned long power9_idle_stop(unsigned long psscr)
 	mtspr(SPRN_PURR,	sprs.purr);
 	mtspr(SPRN_SPURR,	sprs.spurr);
 	mtspr(SPRN_DSCR,	sprs.dscr);
-	mtspr(SPRN_WORT,	sprs.wort);
 	mtspr(SPRN_CIABR,	sprs.ciabr);
 
 	mtspr(SPRN_MMCRA,	sprs.mmcra);
-- 
2.23.0

