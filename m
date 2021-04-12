Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5290D35B83B
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Apr 2021 03:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236231AbhDLBtW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 11 Apr 2021 21:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbhDLBtW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 11 Apr 2021 21:49:22 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25372C061574
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:49:05 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id x21-20020a17090a5315b029012c4a622e4aso6191057pjh.2
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uGMuXcs706W1WbX3G4YQ40n7ZTHeko237s34UogQXMQ=;
        b=VvzPE5UUHzeT7qXKTS5YzcuXeU6aLDKX4JEikAx22eH4s4ilVaqIhdRIRZ+VK4Dl+s
         zfzb3Eq0tzAxQ4/Nb1G6vzS1uHjfzWMLBzSlvWvQAegPa2OLEiNSwtQztnKx/aCglv9g
         uCIk7l67Un+mw0HtiGAP4UOMQA2qWsojBsyEoD0K5+SbtPjojdq9F+nBdmTBEVaAGxBt
         fPtg7kNcc5dpjrLaH/Kc0KvzCLZrTvAzBeyzntAckqHRLZ9Yj79PaK5sQJYcTx67ODkM
         RpPL0LFuhlQfOSITvdrSrTnBMcVnXfpbTcwKKRWJQUOzLJfk84Sq9/hFRORLbFMErfJj
         6InA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uGMuXcs706W1WbX3G4YQ40n7ZTHeko237s34UogQXMQ=;
        b=MjBOscXSctMGNXcaqI4dASV05y6I9+LqKnV8lTjR3aUvWKW3q7fM7wgg6ypOTj/bmy
         OqtUN9wcp27mf0rTpqau9yNYXxcshYHhjBApkS8wWWF6THo+hJe90s6NRB2+AMeGHQQ0
         fGtWuYay3hXoS4nGVcUiw/y/nPM2E0lEdpn+KXPwvSXGGz1cYsRoMW8CBbR/9/Nbs8wN
         48qCV4dJlQn8ZNqqhH9EQa9GyCuv09nXfUGHQH5RdNI/l8d2ykHWB8Gr+2CyHUO0naLj
         YULGAASBvAtiaMjQ3o3s6brpi2Pts1DSBs0uI0KmooYTCuibD/0WX19ez04yRd+ft/U7
         lbNw==
X-Gm-Message-State: AOAM532kDhEi0sQa3k36RaQzE5YRoenVQawXhKv2z5QnP9vlKYr9tFhv
        zqJbELgcVYCSmqgg78RLTZe0zSj3qBI=
X-Google-Smtp-Source: ABdhPJxowsYUEbRFMRe0mazdV/T9VA4uysRjEZ1Cu9bz/VPnPbSdw4JNr0uDSTPsboXRnc1kPjALeQ==
X-Received: by 2002:a17:902:e803:b029:e9:1f79:2427 with SMTP id u3-20020a170902e803b02900e91f792427mr24307901plg.21.1618192144662;
        Sun, 11 Apr 2021 18:49:04 -0700 (PDT)
Received: from bobo.ibm.com (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id m9sm9502345pgt.65.2021.04.11.18.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:49:04 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v1 04/12] KVM: PPC: Book3S HV: Disallow LPCR[AIL] to be set to 1 or 2
Date:   Mon, 12 Apr 2021 11:48:37 +1000
Message-Id: <20210412014845.1517916-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210412014845.1517916-1-npiggin@gmail.com>
References: <20210412014845.1517916-1-npiggin@gmail.com>
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
index 268e31c7e49c..3de8a1f89a7d 100644
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

