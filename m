Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04D6353A9F
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhDEBVb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbhDEBVa (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:21:30 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE75C061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:21:23 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id g35so2419218pgg.9
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QxLOBUUPsmcmYWvGNUQT+fwEBAPKT3eRXC/liKQ+kU0=;
        b=ZQRdDF6EbQOyNCo2zPq1E2pCr0+B8MsLkIjMQRtf6WbrZ0Po7KCFMt1nmNoACL2avU
         8e+hk1fm+9hkq1LPlnBagOsPE/bPA/0Q8zhs26l98BU9CJjRSmh1dUXzuv8xu7noVZuU
         SH5yLQnqTkKArt25FSbMarOwHxnOG/52J2IG8jPeMazwrepy3XiA4IG54mx6nfWho9Xx
         j6T6zwgrEL0zxbz9+OpjYc+BFVXSA/ZKVpyiMLxqxXtGC7mevF0eFZiqiZeczt77ceDs
         WMaMU+ZizByZ6S8FSp22KmN0qIG32dClDL9AQ9RB2CkjRP0lP6Yr97DONk/zQ/xaRU2x
         Dxlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QxLOBUUPsmcmYWvGNUQT+fwEBAPKT3eRXC/liKQ+kU0=;
        b=r34yKCgtyEFrYtNy2fO93L/bTFivbstdId6Yk7VBR3xmgBLERAdJrPGYWYgLv2zMHN
         h5tY5vBYtaYUrTc6dC5Sy1xS5lkvpHxwZs1/dw8OM6R8JPDa3VEBGKXlZ+tPQdRyn/tR
         FLaWM0WFfM4VXiuBQ9ipHG3X35eCJse+lIEEXvxjjmoHKJSuoVyEyXX4uJlYNFrIWJWI
         JAhRMOwVO2uYD2+mHoYBF7Ua2BMXWaNRRkGPfEsncq0kANJmFDyNfY7tOuuNMk2y+iQf
         GssBLxFKGX2yIHGjUguzUqYskAIN53Zfuprhejg7bpLSLbpEGHoEXakbVAs4Pq+y58rk
         A0bw==
X-Gm-Message-State: AOAM532tf+a9Hw81ytkWfrunrCUzxTZJfsm3fCDbWrba5k38mmJjr52o
        eVW2Vy97bepUWJ4f+gMMqXeqKVdpT6A5YQ==
X-Google-Smtp-Source: ABdhPJyRe3Q+W1HOZzcCNDB6XF/GW8hCGHQBzfUis/17lKiAuhfokV8UwfRPKqEosOvGmtFJyJLO3Q==
X-Received: by 2002:a62:82cb:0:b029:1f6:213b:6590 with SMTP id w194-20020a6282cb0000b02901f6213b6590mr21258088pfd.17.1617585683327;
        Sun, 04 Apr 2021 18:21:23 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:21:23 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v6 23/48] KVM: PPC: Book3S HV P9: Move setting HDEC after switching to guest LPCR
Date:   Mon,  5 Apr 2021 11:19:23 +1000
Message-Id: <20210405011948.675354-24-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

LPCR[HDICE]=0 suppresses hypervisor decrementer exceptions on some
processors, so it must be enabled before HDEC is set.

Rather than set it in the host LPCR then setting HDEC, move the HDEC
update to after the guest MMU context (including LPCR) is loaded.
There shouldn't be much concern with delaying HDEC by some 10s or 100s
of nanoseconds by setting it a bit later.

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 782c02520741..f2aefd478d8c 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3557,20 +3557,9 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 		host_dawrx1 = mfspr(SPRN_DAWRX1);
 	}
 
-	/*
-	 * P8 and P9 suppress the HDEC exception when LPCR[HDICE] = 0,
-	 * so set HDICE before writing HDEC.
-	 */
-	mtspr(SPRN_LPCR, kvm->arch.host_lpcr | LPCR_HDICE);
-	isync();
-
 	hdec = time_limit - mftb();
-	if (hdec < 0) {
-		mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
-		isync();
+	if (hdec < 0)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
-	}
-	mtspr(SPRN_HDEC, hdec);
 
 	if (vc->tb_offset) {
 		u64 new_tb = mftb() + vc->tb_offset;
@@ -3616,6 +3605,12 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
 
+	/*
+	 * P9 suppresses the HDEC exception when LPCR[HDICE] = 0,
+	 * so set guest LPCR (with HDICE) before writing HDEC.
+	 */
+	mtspr(SPRN_HDEC, hdec);
+
 	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
 	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
 
-- 
2.23.0

