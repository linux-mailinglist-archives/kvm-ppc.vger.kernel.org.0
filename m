Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23FB23D51A6
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhGZDKb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhGZDKb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:10:31 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB32C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:50:59 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so12346711pji.5
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vHJ3Y57b/rviJNEhgVpmV6ko0RmXjy00ajwevlOD5SA=;
        b=gKo0r927juWtn87EJD51DvWI4ge3OKVYVlJ47/NJoPokPbSZgOB/+DRqsxLYuXjUYK
         hv4xG5T9lG71vhan1HwU4OzE05X+jZ32zcX44IYT4g8SHsrxmYbeaS4+Os3TpntUyux4
         W4ZaPFTgNpYedMqhIdRu2iEHsYsUrDH/4aGS6H1Qi/T5SXIL4Xay0qYxImdlOXUkibgi
         ntQA27hZ1aX6edF4E/RsYl8p75kllhHCMzA+HOsFnE4IQvQ1mcvClvsEPnpZmj5P8H5A
         qAih5HXzFfIxN4p6R9jQCDkLrKSIaHSIrJRpd2UkDMXmsX3vSlXLZGVd+uzZ5mUr8ttL
         1xAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vHJ3Y57b/rviJNEhgVpmV6ko0RmXjy00ajwevlOD5SA=;
        b=FzNIo03nfewf+CNRFerlJNmmaKYkITnTXaAwbZUQwNPgr9/cnA/EYkNPxInVPmtIqa
         yeowNaGLx2a1BIuZe6T5myshHt7i0KzNEBjKLEjdpjfeblRQC0vo/cNfzcpWpUjoGHay
         aSCmoAP+oqEb5UCld+U/Sv0mtHdbnDnwyfz57cdfum3t01nHCgwZsvJ80LJXzSsg14uv
         OXiLp5bYGBA6BjsKS8rDuI+cbi840wa47XymN5lTONQc0hj0ScbvY5TGxUgYEy/eTiYj
         vlZqp6z3kNMTn8aqjqNhxb6Hk+eE7dd5c1KMO6ceOZKYbfi5LCAa97h+G4VEX9GVCrhB
         uXug==
X-Gm-Message-State: AOAM533dhtpGNgfJwpXfyTzouuBBnBE58PxYf4lKf/ZrmvlPfpxaWodq
        JK5YDEm/z5Htyb66TNoZ4uCbyMjbYVE=
X-Google-Smtp-Source: ABdhPJyi4OmcTEciC/UAfHaN9YcU4R53EcBKSJmalI+W2dfBSIAvevoR8WwjBXxrrO6bu7KO+muLNQ==
X-Received: by 2002:a62:584:0:b029:32e:3b57:a1c6 with SMTP id 126-20020a6205840000b029032e3b57a1c6mr15624560pff.13.1627271459222;
        Sun, 25 Jul 2021 20:50:59 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:50:59 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v1 06/55] powerpc/64s: Remove WORT SPR from POWER9/10
Date:   Mon, 26 Jul 2021 13:49:47 +1000
Message-Id: <20210726035036.739609-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This register is not architected and not implemented in POWER9 or 10,
it just reads back zeroes for compatibility.

-78 cycles (9255) cycles POWER9 virt-mode NULL hcall

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          | 3 ---
 arch/powerpc/platforms/powernv/idle.c | 2 --
 2 files changed, 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index c743020837e7..905bf29940ea 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3740,7 +3740,6 @@ static void load_spr_state(struct kvm_vcpu *vcpu)
 	mtspr(SPRN_EBBHR, vcpu->arch.ebbhr);
 	mtspr(SPRN_EBBRR, vcpu->arch.ebbrr);
 	mtspr(SPRN_BESCR, vcpu->arch.bescr);
-	mtspr(SPRN_WORT, vcpu->arch.wort);
 	mtspr(SPRN_TIDR, vcpu->arch.tid);
 	mtspr(SPRN_AMR, vcpu->arch.amr);
 	mtspr(SPRN_UAMOR, vcpu->arch.uamor);
@@ -3767,7 +3766,6 @@ static void store_spr_state(struct kvm_vcpu *vcpu)
 	vcpu->arch.ebbhr = mfspr(SPRN_EBBHR);
 	vcpu->arch.ebbrr = mfspr(SPRN_EBBRR);
 	vcpu->arch.bescr = mfspr(SPRN_BESCR);
-	vcpu->arch.wort = mfspr(SPRN_WORT);
 	vcpu->arch.tid = mfspr(SPRN_TIDR);
 	vcpu->arch.amr = mfspr(SPRN_AMR);
 	vcpu->arch.uamor = mfspr(SPRN_UAMOR);
@@ -3799,7 +3797,6 @@ static void restore_p9_host_os_sprs(struct kvm_vcpu *vcpu,
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

