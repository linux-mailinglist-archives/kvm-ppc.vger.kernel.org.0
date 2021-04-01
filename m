Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1293518DD
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 19:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236469AbhDARsA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 13:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234946AbhDARlc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 13:41:32 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4F5C0F26F2
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:04:58 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id k8so1707331pgf.4
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ka7Kgc46wNYVciwtrqBRiw3Ky/NlQuIKvsqrbXsH90U=;
        b=bi5PsOGvlpcCcOnrJi+B+I3ZXuDFDBRpvVkJ6G+mCchbMA2y9cWl3nU5KvHSEd0LkP
         i4wi0pqwBi+7LoH9L9goiFRug3OFw0hZMSSmqSr5QlAsI0OZBbJrdBnWz2GRYmLXgbKM
         22fvil8A7gpoeRz6ZKsKv7DNGCNZvKSxMaFsONnXOTh4uUECt5h/wY8gKvlOxLlQZzUL
         gimua5szjO8FgqNEavOe2uRCepHPLwAyBJqNeGqZJjiO/N3/A2aRC1DF3XiRYoz/543t
         pyuLE+2vvb9G/CFzR38vddZ+jq7UE/Xag3i94B3gefEyXtdS0SAHH+nzVLwbVSTegPl+
         nHFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ka7Kgc46wNYVciwtrqBRiw3Ky/NlQuIKvsqrbXsH90U=;
        b=l/ksZDrYr9y501ALRckTslqP77rUbl/HKvWp6M7s7FBLNQ6k4LBfZzwyYNTD6jZNKC
         ILiY6gCnCRKRDGq91FvvI1LZ8d9hZkBimQQgttuYRJsit4lGBaRPYECb1HA+4bxjoqzS
         gu8Msmgwz+xOkJqMZNFikp/kqvcpMb3DDkflrul2N0+brJu97oXa9K7V8NG/aet8fdZg
         ZQum+rwfpMzuHoCKiIGpP/qMfHVbu6J5TSoAZ0xBqC9Ok2+1tWqELH+BDVioEsoeWXtR
         r+Ir4iWYMInSxAAqo8DVFo49PdsYJNB9095gD2pXbt+OekL4Qx8Mn1GFRrmNYpI6nIG4
         vXNA==
X-Gm-Message-State: AOAM531J2zsB1pS16zzN5SZk8CjCsM90MDNicCi0cbvr36kyOh8FXc9Q
        1U65ozv/kMJgH6Y4kbRt+XILlow3sws=
X-Google-Smtp-Source: ABdhPJxrwqZxpqC53SQ7FKtTymSCdW6gFAJmUDQ27OqlbsVKzilP1g/WoG+WeK2n7B9/MNwfibmsHQ==
X-Received: by 2002:a63:d143:: with SMTP id c3mr7707131pgj.99.1617289498187;
        Thu, 01 Apr 2021 08:04:58 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:04:57 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v5 26/48] KVM: PPC: Book3S HV P9: Reduce mftb per guest entry/exit
Date:   Fri,  2 Apr 2021 01:03:03 +1000
Message-Id: <20210401150325.442125-27-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

mftb is serialising (dispatch next-to-complete) so it is heavy weight
for a mfspr. Avoid reading it multiple times in the entry or exit paths.
A small number of cycles delay to timers is tolerable.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index dc1232d2a198..46f457c3b828 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3551,12 +3551,13 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 		host_dawrx1 = mfspr(SPRN_DAWRX1);
 	}
 
-	hdec = time_limit - mftb();
+	tb = mftb();
+	hdec = time_limit - tb;
 	if (hdec < 0)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
 
 	if (vc->tb_offset) {
-		u64 new_tb = mftb() + vc->tb_offset;
+		u64 new_tb = tb + vc->tb_offset;
 		mtspr(SPRN_TBU40, new_tb);
 		tb = mftb();
 		if ((tb & 0xffffff) < (new_tb & 0xffffff))
@@ -3754,7 +3755,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (!(vcpu->arch.ctrl & 1))
 		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
 
-	mtspr(SPRN_DEC, vcpu->arch.dec_expires - mftb());
+	mtspr(SPRN_DEC, vcpu->arch.dec_expires - tb);
 
 	if (kvmhv_on_pseries()) {
 		/*
@@ -3889,7 +3890,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->in_guest = 0;
 
 	next_timer = timer_get_next_tb();
-	mtspr(SPRN_DEC, next_timer - mftb());
+	mtspr(SPRN_DEC, next_timer - tb);
 	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
 
 	kvmhv_load_host_pmu();
-- 
2.23.0

