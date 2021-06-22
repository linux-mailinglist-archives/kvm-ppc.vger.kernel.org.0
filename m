Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212B63B0200
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhFVLAw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhFVLAv (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:00:51 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8CCC061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:35 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id p13so16164063pfw.0
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ggokmDItKSM+r98aPBZE1WlhVjHNg7ei24yZFkvVe/w=;
        b=KvAilNvPuB1NHnIS4L5QkckqxSNAVGThELvM/RdW66IUG7W/ZNK2EhyWW/uYEpqO/Z
         647eyfGORdKouYt3HoPrERb+ljSpZL2s1+IBVu0yedmwMaVsuVeUxWlklzMzcQPoZuea
         vvhoZnNiWJdAA/dWV3JJ3HqNqwYNxOClVX/mESh1HrNbDaLrFa6giMMePycN8zQyVYJS
         rsst7nK7a1JqeQqTqDtrcqkSS3UosIEP9XtWmAza6eP2Zl5m14WrjQ5yc473cv4gCzem
         VpC1JmrfA3oJQaCc9ZA4z0q7U/ayt1wABSpuvili7HjMYwpq6thUgAaVYTiHN8cLLFm1
         x0zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ggokmDItKSM+r98aPBZE1WlhVjHNg7ei24yZFkvVe/w=;
        b=Fp+X9RgPXsCZ0meyWZJ2zXmscbtqkDxpOfuIVAxup+N0n5s8LnBPbBVVFhBcjQI9Tm
         EFfeX8ivlQSFK0PwWdyGz/3tahvTqAevRF7WtrYUmWiOASchHAt3P4aCPVEeGDZs3pdO
         XWsFV+/tSiQQ2F+T1DUJ48c6U0Gd0fPBOZARxe/8bsXXgFyzVEgm9xAaHe8sKOKEZmsg
         iudemhVpgNOA2O7FehxvMWCVatX7j2OBHmTTOBSflgR18Cdn228jPNzEjeUsnAphr5Hu
         8fAcmymMaW453xHnosCGAImaTu1nYpFb4sueWL06t5KR0IwHI7Fzya/6ZCbwKe7nleBf
         G2pg==
X-Gm-Message-State: AOAM531DD5BPYXfLAUOmtKQ5FGAiGrwAR9rw33/Mb12TQSLoXcIV9lAn
        K2wui5EwG54GuNh8xdVfWmW5WvlG8yc=
X-Google-Smtp-Source: ABdhPJy1gmQjMJdmMrzCLhjkBXRnRxrSGH8rAMVd14jqCbsGIPAFP/oVbtxa0SkQCjlcOMn5cw7/FA==
X-Received: by 2002:a62:2ec7:0:b029:301:fe50:7d4b with SMTP id u190-20020a622ec70000b0290301fe507d4bmr3090154pfu.78.1624359515245;
        Tue, 22 Jun 2021 03:58:35 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:58:35 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 16/43] KVM: PPC: Book3S HV P9: Move SPRG restore to restore_p9_host_os_sprs
Date:   Tue, 22 Jun 2021 20:57:09 +1000
Message-Id: <20210622105736.633352-17-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Move the SPR update into its relevant helper function. This will
help with SPR scheduling improvements in later changes.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index f0298b286c42..73a8b45249e8 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3953,6 +3953,8 @@ static void save_p9_host_os_sprs(struct p9_host_os_sprs *host_os_sprs)
 static void restore_p9_host_os_sprs(struct kvm_vcpu *vcpu,
 				    struct p9_host_os_sprs *host_os_sprs)
 {
+	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
+
 	mtspr(SPRN_PSPB, 0);
 	mtspr(SPRN_UAMOR, 0);
 
@@ -4152,8 +4154,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	timer_rearm_host_dec(tb);
 
-	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
-
 	kvmppc_subcore_exit_guest();
 
 	return trap;
-- 
2.23.0

