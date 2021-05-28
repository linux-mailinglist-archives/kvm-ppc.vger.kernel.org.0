Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA499393F71
	for <lists+kvm-ppc@lfdr.de>; Fri, 28 May 2021 11:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhE1JKX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 28 May 2021 05:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235999AbhE1JJ7 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 28 May 2021 05:09:59 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7167C061763
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:23 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d16so2731978pfn.12
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mQleErudL7LlSeeWLywYowKU3q8rCRmoPGtYQA3+M6c=;
        b=S27WD7+Z5zk2CvpIGLQmGAAYSJP2LkALG7/uGpO8U5ZMu21EAze8cXe0bXE16L/9Tg
         W74cQn9v2XE65HAEbcOSJna4onm5zuj2EibQil7ebvYZ+3lezrRamH2+rxX8aLsLNh3p
         HGo1bUFHUAMRVHDTCVed5iDDlRAMYKcuMbs0lrFYL+o1RPcxVE0MLpwQcwXW0uqH0aon
         /OH1mTq4ZX0CZwfvhITWH+XB/JIHzpPHySaF8hmuLrigw8d9+djdpqIzb4h6ixOI6PW5
         RPOrrF1XQDTu1ZR/S3mcsociGioYlwvO0s0Sh1cnU26gXahjZGWkNMzZIOUprMiYLzUs
         NawQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mQleErudL7LlSeeWLywYowKU3q8rCRmoPGtYQA3+M6c=;
        b=NfRTfcOhXWqkNFkd0vyo1M67IZRQ5HPAX1mPJDeEi+kDxtQLRILydi2f3BXpBioNHC
         27vapqr3Q0MQZWKYLhla9UGtMakJ9TmCX45/qCW3Vd89NWoDRZK+93cn/H7di6noMcvu
         x6S4Pw9k2lMUffYEw08tXrobS9gLHLjUFbFv+oD9xoJLgHjcD7znYVy2tEYdnSvL1EfK
         RRAQDyKBO2kaBAM8/jAgCvRdSm6Xi7+nH2Z38PEuaq71zUkybE9SB21IMKbKMJxVtg+3
         QyscfAVODSDPS2d2nbOJQlxXl4LTNU3t0aChD/L7DiYWk11jqEkJzeucLxxaBYyuPd1Z
         FoQw==
X-Gm-Message-State: AOAM531IMMkmVXkP1HYwjKD2ocOnKkTRjYq0kwyqON9Fe+SYeJiOBpJg
        jaNkzAMjTN7+VNomN8aAsRAU1D5sKCU=
X-Google-Smtp-Source: ABdhPJwrzWvrZxNJb7pqq8f0jddC79WWo0mHiH82Jx/72GOGrjLrk6dYpGqSAGiNbHIuW6FqIESYfA==
X-Received: by 2002:a63:ba03:: with SMTP id k3mr7934502pgf.81.1622192903256;
        Fri, 28 May 2021 02:08:23 -0700 (PDT)
Received: from bobo.ibm.com (124-169-110-219.tpgi.com.au. [124.169.110.219])
        by smtp.gmail.com with ESMTPSA id a2sm3624183pfv.156.2021.05.28.02.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 02:08:23 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v7 09/32] KVM: PPC: Book3S HV P9: Move setting HDEC after switching to guest LPCR
Date:   Fri, 28 May 2021 19:07:29 +1000
Message-Id: <20210528090752.3542186-10-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210528090752.3542186-1-npiggin@gmail.com>
References: <20210528090752.3542186-1-npiggin@gmail.com>
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
index 907963b174e1..466d62b35b6a 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3502,20 +3502,9 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 		host_dawrx1 = mfspr(SPRN_DAWRX1);
 	}
 
-	/*
-	 * P8 and P9 suppress the HDEC exception when LPCR[HDICE] = 0,
-	 * so set HDICE before writing HDEC.
-	 */
-	mtspr(SPRN_LPCR, vcpu->kvm->arch.host_lpcr | LPCR_HDICE);
-	isync();
-
 	hdec = time_limit - mftb();
-	if (hdec < 0) {
-		mtspr(SPRN_LPCR, vcpu->kvm->arch.host_lpcr);
-		isync();
+	if (hdec < 0)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
-	}
-	mtspr(SPRN_HDEC, hdec);
 
 	if (vc->tb_offset) {
 		u64 new_tb = mftb() + vc->tb_offset;
@@ -3563,6 +3552,12 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	mtspr(SPRN_LPCR, lpcr);
 	isync();
 
+	/*
+	 * P9 suppresses the HDEC exception when LPCR[HDICE] = 0,
+	 * so set guest LPCR (with HDICE) before writing HDEC.
+	 */
+	mtspr(SPRN_HDEC, hdec);
+
 	kvmppc_xive_push_vcpu(vcpu);
 
 	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
-- 
2.23.0

