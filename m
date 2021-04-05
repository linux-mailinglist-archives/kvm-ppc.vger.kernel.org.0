Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419DB353A88
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhDEBUQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231823AbhDEBUQ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:20:16 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78FFC061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:20:10 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id il9-20020a17090b1649b0290114bcb0d6c2so7100798pjb.0
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OfjZBYhIkDtimAOFPQqSOyFCP6WGylRgGDnOYsNsrRY=;
        b=Ia1SRBaNSSim5ddLtX57Kg+v5iFWsYO3Uoyt8Cwc/KA7JJ4DsJCpGkOxQ8Uau4m+8U
         bvpiz+9xI+6am6uHbDy01kyJnbLHE+DdeWkByXrlVxqgBbgmvRcBOJzewToKrPE6cQud
         nBwob2tEPStDffdYMeTktHNm+FmE8JZ3NWAeY/Okf9hgscz5ASZNbeKMxOYDfuxriHdU
         Dgya82Ib0V0yoVlRI+Wz+R8pbWOwWLSD+frSh5dG94y41MP+pGTmYaJjOdBUssx5Q+4P
         Lf1VGjKyprF443OeOEA2YJIh3OtS+6TvwUyRIMANUR8P5DH3H7lIv7WWyzbreJv5/UKU
         7ujA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OfjZBYhIkDtimAOFPQqSOyFCP6WGylRgGDnOYsNsrRY=;
        b=KQeSsfD8j/bejtS5Y7YtZgqMrhfXiQF4L2POT1YbuOksZISKHbRzjmh3oQ/aZJIMUp
         fjwlonFl1e3j+Kq7xEedJ969ig5jd+5uVx6eqcrM/OHUy9dgyCdjxK+gqIUMqxwtpq31
         ODuM2caKF5omAquk6oXW/HgNAM3UBAhG21ceBA20i9b1pXNhPqMGrFJQU77VpCcZXyq4
         TGE9jAm+ojrbMI2cGgdp9NUotXUGN6MPy9dIcvUnVkU3JK59OV8LrtMTJNwOaB2cPVKN
         frszNAbOzmtQsfpPnp2evg7HT1CicShM0zJj88ho6IrytSd9nsE3uY+XMbXV0IrSskO7
         /nyQ==
X-Gm-Message-State: AOAM5323MGIz9BqUcikuloCx/3b0NvZZyOYiQRAhxdc0lN3FTWUWCQJ2
        LXWYKRvubrkdHL7gwxU9a+PgpZ4ndmps1A==
X-Google-Smtp-Source: ABdhPJwLOBc7+aa0W2w927sGnl26UcGB/vIhK+cm1ecZtNxEWHUlVlipg0jT1jyE22ABhG826u6aVw==
X-Received: by 2002:a17:90a:f2cf:: with SMTP id gt15mr7466893pjb.49.1617585610438;
        Sun, 04 Apr 2021 18:20:10 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:20:10 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v6 03/48] KVM: PPC: Book3S HV: Disallow LPCR[AIL] to be set to 1 or 2
Date:   Mon,  5 Apr 2021 11:19:03 +1000
Message-Id: <20210405011948.675354-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

These are already disallowed by H_SET_MODE from the guest, also disallow
these by updating LPCR directly.

AIL modes can affect the host interrupt behaviour while the guest LPCR
value is set, so filter it here too.

Acked-by: Paul Mackerras <paulus@ozlabs.org>
Suggested-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index d2c7626cb960..daded8949a39 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -803,7 +803,10 @@ static int kvmppc_h_set_mode(struct kvm_vcpu *vcpu, unsigned long mflags,
 		vcpu->arch.dawrx1 = value2;
 		return H_SUCCESS;
 	case H_SET_MODE_RESOURCE_ADDR_TRANS_MODE:
-		/* KVM does not support mflags=2 (AIL=2) */
+		/*
+		 * KVM does not support mflags=2 (AIL=2) and AIL=1 is reserved.
+		 * Keep this in synch with kvmppc_filter_guest_lpcr_hv.
+		 */
 		if (mflags != 0 && mflags != 3)
 			return H_UNSUPPORTED_FLAG_START;
 		return H_TOO_HARD;
@@ -1645,6 +1648,8 @@ unsigned long kvmppc_filter_lpcr_hv(struct kvm *kvm, unsigned long lpcr)
 	/* On POWER8 and above, userspace can modify AIL */
 	if (!cpu_has_feature(CPU_FTR_ARCH_207S))
 		lpcr &= ~LPCR_AIL;
+	if ((lpcr & LPCR_AIL) != LPCR_AIL_3)
+		lpcr &= ~LPCR_AIL; /* LPCR[AIL]=1/2 is disallowed */
 
 	/*
 	 * On POWER9, allow userspace to enable large decrementer for the
-- 
2.23.0

