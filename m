Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF0E351835
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 19:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236303AbhDARoS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 13:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234792AbhDARkM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 13:40:12 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29579C0F26DA
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:03:53 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso1164851pjb.4
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r+tYArWWu4RNguNhduAefXr3uYY9Yl8n8bH2Jfs1pRM=;
        b=VBkna4kkyqlOTVRMgKF4wmiF3WwKUdpT/xha9N6ca0URPtut5wAKSfIBUID14tPokJ
         W1yMN11rSq0H0644AfNzzDeV0jviSkwHz4AubJMOwl9V8u4sTiKea1/tuUPQUkhPi/yT
         DBDoiANI8a7Wx1jNJI03p/pZf8URD+w7Qut0jTGmV4HNgP4WggdUpnuQ+ZMvtXB1oqZB
         OpDSd67O8s+JjtDam3W6rFHjzYE1LCw7j2FLXwcsx5RaTuzyX2P1AwF2rwQehTiVxpxk
         OnPl57Ur7h/TesIH4TJEhHVz/UUNi2SeBUOEQqLYHoe66RuZewTAnxx7Md0KQhNldEmV
         QYPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r+tYArWWu4RNguNhduAefXr3uYY9Yl8n8bH2Jfs1pRM=;
        b=sVcftrib4ycaAgYY9yf0O8mR7shcZUoPE03wTSDBqkNXv9IJaahEe8LwFMuC9IYS8X
         Xpn0gl3qtahD7Qw6ME3B4+Odl4jQpeCpBMWCyCQcvgY5aLIOFqsZYFspGtme3oO7gB2O
         jRgItRihRwdJD9b9rb3UA2DCV/IFuaZT3UTcOCPfTyO1jSKYcsk1tF1l1kqhL4xB9jPP
         6UfzLllgGojr7GGS3y4ibMwdT0tg1twkun0tvBmvuOKMK6Sc9D+9MPl+cpIAzXyd/F65
         dbLmjw5/kHFupZZcaSIRuSy+1ztDOFXaPXExtb/Pmu0D8uDWOnHLuqIRAw+RQtnq94VL
         //Ag==
X-Gm-Message-State: AOAM532gtEcF4Hi6S/LWD8uQP2vBdwOMu2VOW3j7zfTsY7Jnw4+kcdZV
        lQdaii/yuEhfAFd6b0ldu3Afxm1mE8k=
X-Google-Smtp-Source: ABdhPJwV1HvN2FZK5S5m1TUvt71OYmZ8lXk95guSMCslbNZbtY3l7TpNajNyRzeGx+m8gZbEYr9thQ==
X-Received: by 2002:a17:902:bd8f:b029:e6:ec5a:3a6 with SMTP id q15-20020a170902bd8fb02900e6ec5a03a6mr8575548pls.31.1617289432661;
        Thu, 01 Apr 2021 08:03:52 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:03:52 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Daniel Axtens <dja@axtens.net>
Subject: [PATCH v5 05/48] KVM: PPC: Book3S HV: Remove redundant mtspr PSPB
Date:   Fri,  2 Apr 2021 01:02:42 +1000
Message-Id: <20210401150325.442125-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This SPR is set to 0 twice when exiting the guest.

Acked-by: Paul Mackerras <paulus@ozlabs.org>
Suggested-by: Fabiano Rosas <farosas@linux.ibm.com>
Reviewed-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index a6b5d79d9306..8bc2a5ee9ece 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3787,7 +3787,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	mtspr(SPRN_DSCR, host_dscr);
 	mtspr(SPRN_TIDR, host_tidr);
 	mtspr(SPRN_IAMR, host_iamr);
-	mtspr(SPRN_PSPB, 0);
 
 	if (host_amr != vcpu->arch.amr)
 		mtspr(SPRN_AMR, host_amr);
-- 
2.23.0

