Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2D7351BB6
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234718AbhDASKw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 14:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbhDASGn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 14:06:43 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F82C00F7CD
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:05:43 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id t20so1144236plr.13
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IJEvM9Y0R5fJ4PQtNl58AGya3n8tEM4D8HRDtgMTjFU=;
        b=T9kUlkqWDb/nXLcrousYt/NW/TzNk3XUjpCSLg/sHkNR2JwOIf54mk8rdsopmYzAdt
         1zFZH0+78dPyQmBB/Uqg4Pm826/tjXGCeBHVWl+4HcvOIqTfTXwPsewrigchORMpSK/8
         4XKgjFpIVD9D5VyzrX2yi+ilGbz4KgFT3CXN9+hZ1wv9Klyp9nlr+9HOUtu3a/MPAUBh
         LNHFdr4JiHhRid3q/tHcO32pAoVqQIC/S0zkgUz52aw5+GpZ8cXg5iR9y3lXlSDb0Z6U
         J7dLLvz1HZqo+W0Ti+ZxtbWlRl97fYKOXWiefATLFFeVKhubQEj5snlkNHct6iWd2bqG
         F9Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IJEvM9Y0R5fJ4PQtNl58AGya3n8tEM4D8HRDtgMTjFU=;
        b=X8UjRXVWyiFU30Chv5njFrEnxOeFFr7shcaGY12KA9CHPPj2gNk8SraRk/5PX98PVc
         fdCGNI6jtRR0gJ4iot/W8gvWC5eUkzbdQ6eEZbL3NspyiMuJjc5+Yz6z5uZCoyK/1KVy
         tXQvalfdBsPwU4CyCCVgx5iw/2D30L9cddbc4RZYXmGMTjRbcd3sSOAF5OOmuLX8XYpa
         ThbteNsXjyW2nK+IxZBrHNYQDqkdFkoXpYvRZLHhXqDL6P3Ln6EL754m3nQrtaOhP5F5
         tlP/PkX2010wW18nm7p88B9wbXuHpSUdwOIj34fiULT14dCeresJ+/hwMNYdvvqWWC7Y
         NIKA==
X-Gm-Message-State: AOAM533HFgTJXhftBwRhGEV4ZRVkv9HrtlJj/gnmpQ5lWdBiyIxQy2ee
        T750sw3tl4nONTpuiGiKGGAZuh99zB8=
X-Google-Smtp-Source: ABdhPJxPEwsgOyPs2T5PvbzFgO/8a1P4XdC7Uk6GoRvFgIxVlYoP+7h+QRj553dcVSnuw8Rpllab9A==
X-Received: by 2002:a17:90a:8a8b:: with SMTP id x11mr9217633pjn.151.1617289543199;
        Thu, 01 Apr 2021 08:05:43 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:05:42 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v5 42/48] KVM: PPC: Book3S HV: Radix guests should not have userspace hcalls reflected to them
Date:   Fri,  2 Apr 2021 01:03:19 +1000
Message-Id: <20210401150325.442125-43-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The reflection of sc 1 hcalls from PR=1 userspace is required to support
PR KVM. Radix guests don't support PR KVM nor do they support nested
hash guests, so this sc 1 reflection can be removed from radix guests.
Cause a privileged program check instead, which is less surprising.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index ae5ad93a623f..f4d6ec6c4710 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1403,11 +1403,20 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 		int i;
 
 		if (unlikely(vcpu->arch.shregs.msr & MSR_PR)) {
-			/*
-			 * Guest userspace executed sc 1, reflect it back as a
-			 * syscall as it may be a PR KVM hcall.
-			 */
-			kvmppc_core_queue_syscall(vcpu);
+			if (!kvmhv_vcpu_is_radix(vcpu)) {
+				/*
+				 * Guest userspace executed sc 1, reflect it
+				 * back as a syscall as it may be a PR KVM
+				 * hcall.
+				 */
+				kvmppc_core_queue_syscall(vcpu);
+			} else {
+				/*
+				 * radix guests can not run PR KVM so send a
+				 * program check.
+				 */
+				kvmppc_core_queue_program(vcpu, SRR1_PROGPRIV);
+			}
 			r = RESUME_GUEST;
 			break;
 		}
-- 
2.23.0

