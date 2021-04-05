Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AE6353A91
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhDEBUu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbhDEBUs (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:20:48 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3503C061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:20:42 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id g15so7213570pfq.3
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SrGG57sCJsQ8pkpP+3mT7sg63D+3Ca06l9D6kjJ6tqw=;
        b=fkn24Rh2tyMJgoiBgroeRaOOeOSmiyQVTA0fzz3q95rUSWykaTwmGQminD86aIMeDU
         BSnh5WFaTpl24rJpdr4rtRad3UlGzeJCTotJXnsR7N5/PJgHa5xZTX1hMxOnwFHnLRdQ
         9If6gh8tfJFomgZ9eSyTk74iuCxqhxrQLxmGO9pw+8qazYi74R+O+qlBaGRh3avm/Fw7
         yJ7JGRS1+E7AAs7evVIuqfbWe4wRMVib31VrZqvEzlq34HoXGOKMK4euguZQj8CPsfk9
         RwQE6Ht4KHgZjnEMtWQytvVs4oJCIq+oiZTzD9AzMQP2hL+ewe5nJ49MpOB5ePse6t2P
         9a1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SrGG57sCJsQ8pkpP+3mT7sg63D+3Ca06l9D6kjJ6tqw=;
        b=J+g9snq1Idc3RhGrzyBxBrbtGzVs9wDsFNtJiIkY3WvDU9zD+CT/p3v0TntJsnIREO
         Rj8AKQsZvZwJfVbBnOOS+xyJSENFqwxNKmFqm0xfshJfJvmFhmru4XPJ5rqrYTvmMFRI
         Tj6z9T9XOdMKoPEKaa2VJGsMQIPr+bo4T6IeQD10BmG0CC8WKr4NgMhsv5426V2NZPy9
         u2T2WcIUnBe/cwnn7bChYPKUxDdPIUMXYNCQUkJY/EeofMx9HOZVLYsEtnXceun30e+u
         zfxaQWyTCLV50mAnuEphDDGkWqXi1tE41TUD4Tpizi5ziFr/rEphzBpXoMhivlDrsQh1
         dJDw==
X-Gm-Message-State: AOAM533b5+cdoYyFOPoPXLAqJBkdK34YWQUFWunt8awVMm1Pjp8Rj445
        VvZbGyk16ymAYaFOTAqm3VaZUe4eROkYwA==
X-Google-Smtp-Source: ABdhPJxUmMVnw9SMhnzSH8lJv1BCZinDTTVcYhWlb0rPal1HJ/KI5N2aqfXMKeJdqDoqhtDwgPbkxg==
X-Received: by 2002:a62:8811:0:b029:1ef:2105:3594 with SMTP id l17-20020a6288110000b02901ef21053594mr21701500pfd.70.1617585642156;
        Sun, 04 Apr 2021 18:20:42 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:20:41 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH v6 11/48] KVM: PPC: Book3S HV: Ensure MSR[HV] is always clear in guest MSR
Date:   Mon,  5 Apr 2021 11:19:11 +1000
Message-Id: <20210405011948.675354-12-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Rather than clear the HV bit from the MSR at guest entry, make it clear
that the hypervisor does not allow the guest to set the bit.

The HV clear is kept in guest entry for now, but a future patch will
warn if it is set.

Acked-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_builtin.c | 4 ++--
 arch/powerpc/kvm/book3s_hv_nested.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 41cb03d0bde4..7a0e33a9c980 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -662,8 +662,8 @@ static void kvmppc_end_cede(struct kvm_vcpu *vcpu)
 
 void kvmppc_set_msr_hv(struct kvm_vcpu *vcpu, u64 msr)
 {
-	/* Guest must always run with ME enabled. */
-	msr = msr | MSR_ME;
+	/* Guest must always run with ME enabled, HV disabled. */
+	msr = (msr | MSR_ME) & ~MSR_HV;
 
 	/*
 	 * Check for illegal transactional state bit combination
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index fb03085c902b..60724f674421 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -344,8 +344,8 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	vcpu->arch.nested_vcpu_id = l2_hv.vcpu_token;
 	vcpu->arch.regs = l2_regs;
 
-	/* Guest must always run with ME enabled. */
-	vcpu->arch.shregs.msr = vcpu->arch.regs.msr | MSR_ME;
+	/* Guest must always run with ME enabled, HV disabled. */
+	vcpu->arch.shregs.msr = (vcpu->arch.regs.msr | MSR_ME) & ~MSR_HV;
 
 	sanitise_hv_regs(vcpu, &l2_hv);
 	restore_hv_regs(vcpu, &l2_hv);
-- 
2.23.0

