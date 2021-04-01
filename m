Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A439C351C9B
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237076AbhDASSz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 14:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235590AbhDASNj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 14:13:39 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57309C0F26D8
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:03:46 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id v186so1692673pgv.7
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OfjZBYhIkDtimAOFPQqSOyFCP6WGylRgGDnOYsNsrRY=;
        b=tprXuQLgWDQklGD50nq7ZUDNKKLwZv0i+8AryyOQh6xyzb+tjU4kwjVdjhKRVy5gCr
         t5b+L4Cqf4TXkI6lYpyyBB9qa+7B4qJtnXGDG3GTPA40S2dccDRfsk1s05I1PBCRMPo4
         RJjkS5cAVfWzcbOZOqh3KvVUaVlKRodORrtrEtqRKF1NZPEfKivgjrjHG/nCRX80w07J
         j97j0BFueEPofKA9lYS9La1Rtx9po23576TiciLVZbnDcr3PxwwXiRbu/bvAfQAl+QLz
         YNvAtNIYz+ELpseCn3a4B/ByZLDR/7fzbJUvOdj5WUXbT9MbowqkqI4McN9clT38R9Mw
         VJLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OfjZBYhIkDtimAOFPQqSOyFCP6WGylRgGDnOYsNsrRY=;
        b=tOgDSrr4nZRJiFAHkPQ3y2Jl5gSuop+i1se/IGOPPahKFGrfCPpZ2pYX9n+TGoy4VI
         rPshNw+HqNRnmsE920Dmlgdl20Ilm+IWErv54ltbMC53s/oh3oTg4yBnNXRYKMZPlX5P
         QOpVS2GdzwTttbXG1uA1QrrBOObJ+kDCwxx4yxrMyz6RukchfCGgaS4MIGMt41EdtNQY
         oALONG2+zQaDDVpoxaUpFjHBMAVr9FFOy/DQdgvaiMmCKCypY+HaWZif6lJe9yLYuvAf
         eFkyILRyfvevzn3Oa+RrhXv5Y5xoKQY3CWeH2nC2YiV7bJSUYQYh9jxWBM1pRCqkmHaq
         Hhhw==
X-Gm-Message-State: AOAM533/YZ/1qyx4ERcvYw61O1Ef1v57TwF9e5i4/teag4BAOzRfDlPu
        yAcxnkGfAvz6TyzXkRQgZlg3MJ6WmoI=
X-Google-Smtp-Source: ABdhPJzs0UlyFwDFMt3FjD0G2fSEclhD0mxu6JjKz2Qgc4OR/aOkIg3t3i7Z3dYzutqwNo6anmlF1g==
X-Received: by 2002:a63:e906:: with SMTP id i6mr7811406pgh.132.1617289425060;
        Thu, 01 Apr 2021 08:03:45 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:03:44 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v5 03/48] KVM: PPC: Book3S HV: Disallow LPCR[AIL] to be set to 1 or 2
Date:   Fri,  2 Apr 2021 01:02:40 +1000
Message-Id: <20210401150325.442125-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
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

