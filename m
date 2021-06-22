Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EAB3B01F0
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhFVLAQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbhFVLAP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:00:15 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63818C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:57:59 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id i6so122880pfq.1
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R1r0yBx8/sK5LQ18aCWWTuc9FFGjRmrTUBS3fruxffU=;
        b=btO1uKTEn9ovopnl0DTLnYDbAt8HHpDHNc+Qs7IQg1kkexesWbKyPuKp/OioVZSXR1
         IDYqzJzHTMejFlakxU4JDXveIdcro4XDztb4f95kmmkBmjnmgkTxRQ9/BB70ldp0mKw5
         +n/c1Jj4gXgSIp2Pq2dM26a2Bpb6neF0l7mpd3UEz2ZaeulWtp26+FNNs6IC3k6S7vtH
         MpoLO2X23dQImufEhnjPbLSNekucbW6vqioV1IA2yxfF3zHIh/3tDsON+Y+VMqHjVnMI
         k71dqu1+8E4/O1KYUyp9XrIm66ytIurQrSIHxTSrvS0+nnKsyT0Cdh19UNml5HbL4d19
         Yn1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R1r0yBx8/sK5LQ18aCWWTuc9FFGjRmrTUBS3fruxffU=;
        b=CDGZ2npyoSE7UM/xy8ETETGJVwO7/uKgWCVB1FXKTU2yW3UHwU1KabRmZrxBua0L3l
         yWaMVO4b5vY+Xbrj6LJ2X1B9PdrtRbXRdtcDPwubUrX9WTJ+ORuqjNEjb7eE0QXp5f/f
         TFib2pv7lkJt+1Bk7vLg4kTPHatA+JQPJJ2IiiujknxviXawpv8LUju1vXodJJYKkyHn
         kHWSJ7n949utwb0+Y46525hDKy51Crozcxq/akp2AEgekmfbLKu2MrIo2jQemrpQd+Ez
         QHhQJEYig9p9s/tbviL7+IIZM6z5zw6hcx40b1hWKoU6tmmOV3cKuF80UyGFDT5sM7aU
         xztQ==
X-Gm-Message-State: AOAM532/brDcNTB9tiiHpjMOH0Qla4BLQ9IIOEANzfX5hcl++OLBdXko
        v0mTrp/mzX3ao7g/jEsiPj2GkJy4PGs=
X-Google-Smtp-Source: ABdhPJwFCrG04fca8X3mHR68HCK+JemVsnFZXy2tatH6SRRos0P64vvC5pjDvqQEy1A5q6YIg/3jGQ==
X-Received: by 2002:a63:5d5c:: with SMTP id o28mr3256953pgm.22.1624359478911;
        Tue, 22 Jun 2021 03:57:58 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:57:58 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 01/43] powerpc/64s: Remove WORT SPR from POWER9/10
Date:   Tue, 22 Jun 2021 20:56:54 +1000
Message-Id: <20210622105736.633352-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This register is not architected and not implemented in POWER9 or 10,
it just reads back zeroes for compatibility.

-78 cycles (9255) cycles POWER9 virt-mode NULL hcall

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          | 3 ---
 arch/powerpc/platforms/powernv/idle.c | 2 --
 2 files changed, 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 9228042bd54f..97f3d6d54b61 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3640,7 +3640,6 @@ static void load_spr_state(struct kvm_vcpu *vcpu)
 	mtspr(SPRN_EBBHR, vcpu->arch.ebbhr);
 	mtspr(SPRN_EBBRR, vcpu->arch.ebbrr);
 	mtspr(SPRN_BESCR, vcpu->arch.bescr);
-	mtspr(SPRN_WORT, vcpu->arch.wort);
 	mtspr(SPRN_TIDR, vcpu->arch.tid);
 	mtspr(SPRN_AMR, vcpu->arch.amr);
 	mtspr(SPRN_UAMOR, vcpu->arch.uamor);
@@ -3667,7 +3666,6 @@ static void store_spr_state(struct kvm_vcpu *vcpu)
 	vcpu->arch.ebbhr = mfspr(SPRN_EBBHR);
 	vcpu->arch.ebbrr = mfspr(SPRN_EBBRR);
 	vcpu->arch.bescr = mfspr(SPRN_BESCR);
-	vcpu->arch.wort = mfspr(SPRN_WORT);
 	vcpu->arch.tid = mfspr(SPRN_TIDR);
 	vcpu->arch.amr = mfspr(SPRN_AMR);
 	vcpu->arch.uamor = mfspr(SPRN_UAMOR);
@@ -3699,7 +3697,6 @@ static void restore_p9_host_os_sprs(struct kvm_vcpu *vcpu,
 				    struct p9_host_os_sprs *host_os_sprs)
 {
 	mtspr(SPRN_PSPB, 0);
-	mtspr(SPRN_WORT, 0);
 	mtspr(SPRN_UAMOR, 0);
 
 	mtspr(SPRN_DSCR, host_os_sprs->dscr);
diff --git a/arch/powerpc/platforms/powernv/idle.c b/arch/powerpc/platforms/powernv/idle.c
index 528a7e0cf83a..180baecad914 100644
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

