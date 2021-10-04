Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45829421385
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhJDQEo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234670AbhJDQEn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:04:43 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D98C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:02:54 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id s16so14946880pfk.0
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nuVTSGJxHnIlv0kTLuX5DnMA5uRT7Y6LvkwGWm5jYwY=;
        b=PQ/QJx0lA7uR3YdVgf0IYhBobUcA59zS103cQx4nivXznPw0uOZyQu55O9Q6Qlo5Bh
         r/1Uf+N2GlqO7B/DW1oqqp+ogZvr61O720EVf+l3GlHUyXHKafz+YDcgQuK85HChktPi
         M3Wi6vgWw9OE6IQuhU1vxufXL8ALTMwpHyWmWqjDF++xoqa+lsrQr5L+tAfGBXQDhbJa
         ubR4gu6sBYkMB0TZsqZnqw1dkSLCQBOmOlQxwz36cU159cb3OTV1pCsOFaOpFB+lTmq4
         HGEdKOp7j1ErL+bgnufMcneP4iAwLiGcC9uC9bMEFBZLERRM2jsYdRBGwyxJQVhmbVw5
         ScLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nuVTSGJxHnIlv0kTLuX5DnMA5uRT7Y6LvkwGWm5jYwY=;
        b=lm4XDxcgjkmkCUIUxixX5KW+IFIUxFAP0H4wks4sxRzqeh0vtz6W9cYLZpU6nG2ZV2
         SS7amHugeYUiFzaUrRKrqgKE4H95N4RasnqyeMfOQZ+px4dQTreGZOu2TCGBEZIJRlqy
         YLUZYI6qlvuOtLC/RMXyHrv0RU9nYNRUZ/SGeOXbRJ2UVmMbP0SuIIYhU2q8CFnogg2E
         JZIQDbrlzb6++q310bJsYHjtvRrcVwVRNU+MlT1DZllOMxUaa7m5GCtyW+myH2mkpIaz
         rVeaBq5AbHbF0KsmNNtu8b0xg5y3NjGNNjGR/mWbJ1s5AW1V+6iwndpLkBiClPXTSp8T
         VHwQ==
X-Gm-Message-State: AOAM5320FJ37GDAjO5U9nVz997w2Cc38LHJWpWhr7vjVrdmZcisES/Nd
        pOzcgIsfNeCCWkns4y0iqyAoEAdHe7o=
X-Google-Smtp-Source: ABdhPJwtq6ifviyS0m2a4kL00d7vB9BI9GC3qc5G52IEgsAUrkqJgvUOBLf/09hb57HFJQypT02h3g==
X-Received: by 2002:aa7:80d1:0:b029:399:ce3a:d617 with SMTP id a17-20020aa780d10000b0290399ce3ad617mr26833434pfn.16.1633363373616;
        Mon, 04 Oct 2021 09:02:53 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:02:53 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 47/52] KVM: PPC: Book3S HV P9: Add unlikely annotation for !mmu_ready
Date:   Tue,  5 Oct 2021 02:00:44 +1000
Message-Id: <20211004160049.1338837-48-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The mmu will almost always be ready.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 0bbef4587f41..6e072e2e130a 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4408,7 +4408,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->runner = vcpu;
 
 	/* See if the MMU is ready to go */
-	if (!kvm->arch.mmu_ready) {
+	if (unlikely(!kvm->arch.mmu_ready)) {
 		r = kvmhv_setup_mmu(vcpu);
 		if (r) {
 			run->exit_reason = KVM_EXIT_FAIL_ENTRY;
-- 
2.23.0

