Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D763E9556
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbhHKQDS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhHKQDS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:03:18 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77582C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:54 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id hv22-20020a17090ae416b0290178c579e424so5721018pjb.3
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HcmzAMOblnFfBcnkC6E3lPv/DD88a8O4ehbqoWdwBuU=;
        b=Pd2qjHpS1RhttRymMp3KomvQpWIMnZCD8zlv5xyohfqa1X9sxUgMjoSHZFUuNRHmqR
         DYFRkVtXj84gCL+eBV17X5oanb6ZRkK16ElOGMcpaU9unbLSleHC2JWSDPuQkhAxLume
         xfceMY0v73942AMbAug3Bq9th6xSs+/6qra+F+NtHpf4W4+f28DOgW3vkQQQjSMpdNr0
         ZMYFRWqhIG6qz6B9ngqXihLJdCUnEifog/C4zq0aFxEjkoqnQatTr0TIM5hC10935xWU
         gRkPzOk8dqF3aMRbC13LfpHTN+4dsgkuTT2xDPH5KqlMeNWZOF25lOGK15Y3yhexr0WD
         TVbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HcmzAMOblnFfBcnkC6E3lPv/DD88a8O4ehbqoWdwBuU=;
        b=mdMxT4Oal5ygguKTFPbRC8N6GaVQ22fwfQcFUrRsTByq9ItCSDWe0/3pS58dU2cOZ4
         VhieasKrs+9pXYgdeNtD5hwEFIVJDjktnGIF5hDZmVUv6ZsHc9nvBKUDomqnBJXXtjHd
         qCctkA8bbZ36qdmAC77r6y9AOY4C4NljvL0H25Xki45lmupPWm+Tfb8HJ82dXzaFgBaD
         SRbcevicGbBF4MtsJQrl+s4nq0i9JUj04phl91xuOM3R2d2ppeOgsf42Gzej0owgJGZs
         wIbCswFPjHiKW07vJ20fXPWCGeLIoqzu7MRlNWuP6rszBQlAeAxZFBiXpiRP5kcrpAOl
         RrpQ==
X-Gm-Message-State: AOAM533Mi5XLBnAcwSJ3CkQ6OCPyShXNumW3DNrvpYBGMW2yZYOdOqy9
        y7kGJELITa5QzyvKDeNR8V25JcSHUno=
X-Google-Smtp-Source: ABdhPJyPrzD2/ExAIrif/iw8efaaUMRHK8sWQ01m3JyACJBG7euhxP5u3TlZybgCnr2Sq0hBG1XMuw==
X-Received: by 2002:a17:902:7611:b029:12b:e55e:6ee8 with SMTP id k17-20020a1709027611b029012be55e6ee8mr4874557pll.4.1628697773972;
        Wed, 11 Aug 2021 09:02:53 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:02:53 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 26/60] KVM: PPC: Book3S HV P9: Move SPRG restore to restore_p9_host_os_sprs
Date:   Thu, 12 Aug 2021 02:01:00 +1000
Message-Id: <20210811160134.904987-27-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
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
index f9942eeaefd3..ef8c41396883 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4093,6 +4093,8 @@ static void save_p9_host_os_sprs(struct p9_host_os_sprs *host_os_sprs)
 static void restore_p9_host_os_sprs(struct kvm_vcpu *vcpu,
 				    struct p9_host_os_sprs *host_os_sprs)
 {
+	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
+
 	mtspr(SPRN_PSPB, 0);
 	mtspr(SPRN_UAMOR, 0);
 
@@ -4292,8 +4294,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	timer_rearm_host_dec(tb);
 
-	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
-
 	kvmppc_subcore_exit_guest();
 
 	return trap;
-- 
2.23.0

