Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F6B34547F
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhCWBEt (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbhCWBEX (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:04:23 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA56C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:23 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id l3so12539128pfc.7
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R0taHWtZ3E1sIBfZp7RKQEQllxmUlSeRTBhAMSD5/is=;
        b=PTWpeeYxlnMfWsdDiJJlLHjl6ItViJZRy90Tqw3WEN+dxEUICdZk8fUxrDKdvBYRv7
         pIHvBS6m8YhZmpKozfiQyYM0u+Or2aVUQAxSIahppr2nBOvFYnmQqgwlrLBVSo2s0ebh
         DGwXIEldXTE9wovTryzlWbxsd0JtMPxIxQC0jKnfpQiioYYU+aIA0BskYtJvH9swIxQL
         0kRdT4D7/wvJ/bEHOeaOfAxwOAMmMIHWZ0MlloxqPHSAON3WGk/e4sf/Dg0OnpvuQueu
         cx5fVqKJ4PyG1cE/uto/4/Iz5fPmOGchdN6xKBUPKH3sz7ucmoUVcWKaMzZo5zpYI634
         qjqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R0taHWtZ3E1sIBfZp7RKQEQllxmUlSeRTBhAMSD5/is=;
        b=JUqj3MURLFuVlLaxO1/NURErHyiCmNoz/aPeAiFbN4Iqvsq4vg5GvOFwb2f/kgvigh
         +jNThAnw1eANXQ7sDlSNECNfXUgWm55lTtoZWYaf0PtI759rmVHroFvpyiG/KUjUVgNS
         Z+RpIRuXa5D/Iq+dzxVs9f8FdkJbfVm3+z7ABoGwdSmJ3CKVujFC9wu7FVlaWXggruQy
         q3fH6Ozeor58OeXu1TWMkCYLIrpVI42v8x8DuMCmk0bMF17o6BlXFYyh3ULZ/5DLrB6O
         EVfFuKEpv3GUxKnLdrNnAvgl0UAbwrttjY2Xcz64idgFRaFmb0AoKRDkMq2xBhaG1Im3
         XIfQ==
X-Gm-Message-State: AOAM530Uach+NiPVng8xSaDMhFQWYwkY//D6Y3No+Km/RmK+BbLr32uh
        JXCVPFd0acGx7O0RljnWWg7Lt1cccBI=
X-Google-Smtp-Source: ABdhPJz6G+DNSChDQurd6Ngaqiw6IC125pC5Df6WNQiz+im5tFwF0fsEmXHtLWrjFU/SeuXpE4NZRg==
X-Received: by 2002:a17:902:8497:b029:e6:f01d:9c9f with SMTP id c23-20020a1709028497b02900e6f01d9c9fmr961709plo.7.1616461462559;
        Mon, 22 Mar 2021 18:04:22 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:04:22 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v4 21/46] KVM: PPC: Book3S HV P9: Move xive vcpu context management into kvmhv_p9_guest_entry
Date:   Tue, 23 Mar 2021 11:02:40 +1000
Message-Id: <20210323010305.1045293-22-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Move the xive management up so the low level register switching can be
pushed further down in a later patch. XIVE MMIO CI operations can run in
higher level code with machine checks, tracing, etc., available.

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index d28fb76b08e1..fa7614c37e08 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3592,15 +3592,11 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
 
-	kvmppc_xive_push_vcpu(vcpu);
-
 	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
 	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
 
 	trap = __kvmhv_vcpu_entry_p9(vcpu);
 
-	kvmppc_xive_pull_vcpu(vcpu);
-
 	/* Advance host PURR/SPURR by the amount used by guest */
 	purr = mfspr(SPRN_PURR);
 	spurr = mfspr(SPRN_SPURR);
@@ -3783,7 +3779,10 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			trap = 0;
 		}
 	} else {
+		kvmppc_xive_push_vcpu(vcpu);
 		trap = kvmhv_load_hv_regs_and_go(vcpu, time_limit, lpcr);
+		kvmppc_xive_pull_vcpu(vcpu);
+
 	}
 
 	vcpu->arch.slb_max = 0;
-- 
2.23.0

