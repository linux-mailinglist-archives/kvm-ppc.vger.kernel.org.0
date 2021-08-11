Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30B13E953E
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbhHKQC3 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbhHKQC2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:02:28 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E74BC061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:05 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id m24-20020a17090a7f98b0290178b1a81700so5725085pjl.4
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FIn8UyB5857Vdy2BoINpCb9wuJq8s9gPoZz4Xu4yDfU=;
        b=sSj9xBVDl75/eJWzEvk+K430dQ484klUIfLlSJKCUM1/+lrQKcMJPCTQTFxMuqCrqf
         0tAmVtq9PfSgsGNX6X3ijzEQ7OI47EQqkDf85Fncb3jV4M+bOskM8vE6x1iKCdEn9qCB
         pHQICgZZO+usoUGkpxXcBhUzBaMgemEjTzLFm7j8b2EDCEmEe+gHXGXbXhQSObpxKrHS
         HdWd3Mr+X8+izi79Q/uPgfOvN4U9nIM/9D6YQHXvkwoUiwCGNJZpISRDszeUhZBm90I+
         Jhr5kMApD/D9VgdDPI5IGxTQTiAEa7FvTH+0W/ErEB/pgNCODbZ8+ebCb3GYcz6Tbv9s
         Zo5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FIn8UyB5857Vdy2BoINpCb9wuJq8s9gPoZz4Xu4yDfU=;
        b=aYCGA5xcO5+G3L9ijC0CNz4NW3e9QispFSGZ7pIFlrR8MeUtJuLFqED1ZWNPKePBrf
         tKh4tVXC6941wVo+HH6YCgky9Wsw7w1qVfrgk2Yxg9INJG9OgLohi+DDy1/nfh5QOllF
         mOIWCMHd+QG/qzunP2Ob5NUfwUSftMleK8H5BOqIeuN/5ZsG3RGqTwpq8doIvqRiKeCS
         mLCqMv74FSOSc4LHaqmVWctzr1fo/Ij50YywzDZbqInDVp2knGKhAIPhpXYIhxXcxZj2
         YrwY/Ml91NXyUcAiJxzrDxleEizGMTBfsV9C0rT9gWgn3vJCmpAXcfR7RKABilnnECRA
         ibaw==
X-Gm-Message-State: AOAM530yXLwxLkPPa7CCgMFmMrbJ0W9EUpLh8yfqp8q8LyGo5CtI0j6v
        BHCU6vcJX/aGSXJSi/RoOZeDXpK+kTg=
X-Google-Smtp-Source: ABdhPJyR4mhpDw1Ja1VVLy+V8qMCP6gtA2e92qPYuBlNIGCJ5bpg8E8h/gEebz/mYvoPFSpW5/uZYw==
X-Received: by 2002:a63:788e:: with SMTP id t136mr1275639pgc.374.1628697724765;
        Wed, 11 Aug 2021 09:02:04 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:02:04 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v2 08/60] KVM: PPC: Book3S HV Nested: save_hv_return_state does not require trap argument
Date:   Thu, 12 Aug 2021 02:00:42 +1000
Message-Id: <20210811160134.904987-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Fabiano Rosas <farosas@linux.ibm.com>

vcpu is already anargument so vcpu->arch.trap can be used directly.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_nested.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 5ad5014c6f68..ed8a2c9f5629 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -99,7 +99,7 @@ static void byteswap_hv_regs(struct hv_guest_state *hr)
 	hr->dawrx1 = swab64(hr->dawrx1);
 }
 
-static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
+static void save_hv_return_state(struct kvm_vcpu *vcpu,
 				 struct hv_guest_state *hr)
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
@@ -118,7 +118,7 @@ static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
 	hr->pidr = vcpu->arch.pid;
 	hr->cfar = vcpu->arch.cfar;
 	hr->ppr = vcpu->arch.ppr;
-	switch (trap) {
+	switch (vcpu->arch.trap) {
 	case BOOK3S_INTERRUPT_H_DATA_STORAGE:
 		hr->hdar = vcpu->arch.fault_dar;
 		hr->hdsisr = vcpu->arch.fault_dsisr;
@@ -389,7 +389,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	delta_spurr = vcpu->arch.spurr - l2_hv.spurr;
 	delta_ic = vcpu->arch.ic - l2_hv.ic;
 	delta_vtb = vc->vtb - l2_hv.vtb;
-	save_hv_return_state(vcpu, vcpu->arch.trap, &l2_hv);
+	save_hv_return_state(vcpu, &l2_hv);
 
 	/* restore L1 state */
 	vcpu->arch.nested = NULL;
-- 
2.23.0

