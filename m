Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147C6421367
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236266AbhJDQDy (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236275AbhJDQDx (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:03:53 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90269C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:02:04 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id kk10so2602865pjb.1
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8AxVO/grgzWXIBf5o+D+hI/Dho5dubgQSTSKv2Waw1o=;
        b=gFr9aUUeYrVK4tRDw1ipvrotNBm+76TE4YJj7slaVaSut8Rf6KuoLLzDBTP8BRAcwx
         N/w3WAXg/Q0fRwbrEvIENOX3uSxu2UNrANDfwdFS4PB/WDf+ZsjNIz3mCh/xmOWDZImk
         383Bhr4EHQ/v+nF0bt/A5NRoZwlk3fTOQjAun+/D2F01+2arwI4bp3TPaXgDAbKyL0uZ
         xgDXbXrM7WyLmIM+HF4VHPgcOxKE+0FyBC+smgpIHCfd8ocirVFNlylv3WvB/r2qWvRV
         2aOA06fRzczSAceNW7v9BQW5057FSoc49b6u1jk5px3UmCEgdhnI2CW/YSSavJvO8xfN
         6eJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8AxVO/grgzWXIBf5o+D+hI/Dho5dubgQSTSKv2Waw1o=;
        b=35JTjnNeFAroM1YJYHayRRPnEHpXeWCC2gZWs0AQsNBUG2WjH1R1mOq3JhmL/STvcx
         S+nToorWFS6vnQFLaWav+f/LABU6/+W6knrEzPuPN7+w9Dry+jZDU6MYksYWmqlOlLbx
         84M4EeKiNyBQrYGIFYoJLh4ANbEyuOyG8/RF8BaX0F4f3X32ojS1cPv9oDNdHUlqChWX
         rMjwcipt6WUAhjh6Jhx/dNIN+wZG2rTdk1jdRKGtFkQzL+xmf/6rkRa9PK2fAmTz7pwD
         Jcbc1tMx6iA4sausUxau7p6Pje7gkdqc16+CTbO73ExSIbnpBN9mWriFxTQMlJngNGqr
         jzQQ==
X-Gm-Message-State: AOAM5305POtyhELpzoUSTqSqoxJrFMVcWgt5VNj/gZ9E2/Xc0o38SPiL
        V/MvRYm80zPcavl5LBQNCGrLau3KkNQ=
X-Google-Smtp-Source: ABdhPJyGBm0Nvq7K+JRWjMHxSMiuVauRE5/0AInNGV/sjMf31pMTCo1eNr3DbMUPq9wxiF6uNbjvOg==
X-Received: by 2002:a17:90b:1b03:: with SMTP id nu3mr5377951pjb.76.1633363323713;
        Mon, 04 Oct 2021 09:02:03 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:02:03 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 26/52] KVM: PPC: Book3S HV P9: Only execute mtSPR if the value changed
Date:   Tue,  5 Oct 2021 02:00:23 +1000
Message-Id: <20211004160049.1338837-27-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Keep better track of the current SPR value in places where
they are to be loaded with a new context, to reduce expensive
mtSPR operations.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 51 ++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 823d64047d01..460290cc79af 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4042,20 +4042,28 @@ static void switch_pmu_to_host(struct kvm_vcpu *vcpu,
 	}
 }
 
-static void load_spr_state(struct kvm_vcpu *vcpu)
+static void load_spr_state(struct kvm_vcpu *vcpu,
+				struct p9_host_os_sprs *host_os_sprs)
 {
-	mtspr(SPRN_DSCR, vcpu->arch.dscr);
-	mtspr(SPRN_IAMR, vcpu->arch.iamr);
-	mtspr(SPRN_PSPB, vcpu->arch.pspb);
-	mtspr(SPRN_FSCR, vcpu->arch.fscr);
 	mtspr(SPRN_TAR, vcpu->arch.tar);
 	mtspr(SPRN_EBBHR, vcpu->arch.ebbhr);
 	mtspr(SPRN_EBBRR, vcpu->arch.ebbrr);
 	mtspr(SPRN_BESCR, vcpu->arch.bescr);
+
 	if (cpu_has_feature(CPU_FTR_P9_TIDR))
 		mtspr(SPRN_TIDR, vcpu->arch.tid);
-	mtspr(SPRN_AMR, vcpu->arch.amr);
-	mtspr(SPRN_UAMOR, vcpu->arch.uamor);
+	if (host_os_sprs->iamr != vcpu->arch.iamr)
+		mtspr(SPRN_IAMR, vcpu->arch.iamr);
+	if (host_os_sprs->amr != vcpu->arch.amr)
+		mtspr(SPRN_AMR, vcpu->arch.amr);
+	if (vcpu->arch.uamor != 0)
+		mtspr(SPRN_UAMOR, vcpu->arch.uamor);
+	if (host_os_sprs->fscr != vcpu->arch.fscr)
+		mtspr(SPRN_FSCR, vcpu->arch.fscr);
+	if (host_os_sprs->dscr != vcpu->arch.dscr)
+		mtspr(SPRN_DSCR, vcpu->arch.dscr);
+	if (vcpu->arch.pspb != 0)
+		mtspr(SPRN_PSPB, vcpu->arch.pspb);
 
 	/*
 	 * DAR, DSISR, and for nested HV, SPRGs must be set with MSR[RI]
@@ -4070,20 +4078,21 @@ static void load_spr_state(struct kvm_vcpu *vcpu)
 
 static void store_spr_state(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.ctrl = mfspr(SPRN_CTRLF);
-
-	vcpu->arch.iamr = mfspr(SPRN_IAMR);
-	vcpu->arch.pspb = mfspr(SPRN_PSPB);
-	vcpu->arch.fscr = mfspr(SPRN_FSCR);
 	vcpu->arch.tar = mfspr(SPRN_TAR);
 	vcpu->arch.ebbhr = mfspr(SPRN_EBBHR);
 	vcpu->arch.ebbrr = mfspr(SPRN_EBBRR);
 	vcpu->arch.bescr = mfspr(SPRN_BESCR);
+
 	if (cpu_has_feature(CPU_FTR_P9_TIDR))
 		vcpu->arch.tid = mfspr(SPRN_TIDR);
+	vcpu->arch.iamr = mfspr(SPRN_IAMR);
 	vcpu->arch.amr = mfspr(SPRN_AMR);
 	vcpu->arch.uamor = mfspr(SPRN_UAMOR);
+	vcpu->arch.fscr = mfspr(SPRN_FSCR);
 	vcpu->arch.dscr = mfspr(SPRN_DSCR);
+	vcpu->arch.pspb = mfspr(SPRN_PSPB);
+
+	vcpu->arch.ctrl = mfspr(SPRN_CTRLF);
 }
 
 static void save_p9_host_os_sprs(struct p9_host_os_sprs *host_os_sprs)
@@ -4094,6 +4103,7 @@ static void save_p9_host_os_sprs(struct p9_host_os_sprs *host_os_sprs)
 	host_os_sprs->iamr = mfspr(SPRN_IAMR);
 	host_os_sprs->amr = mfspr(SPRN_AMR);
 	host_os_sprs->fscr = mfspr(SPRN_FSCR);
+	host_os_sprs->dscr = mfspr(SPRN_DSCR);
 }
 
 /* vcpu guest regs must already be saved */
@@ -4102,19 +4112,20 @@ static void restore_p9_host_os_sprs(struct kvm_vcpu *vcpu,
 {
 	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
 
-	mtspr(SPRN_PSPB, 0);
-	mtspr(SPRN_UAMOR, 0);
-
-	mtspr(SPRN_DSCR, host_os_sprs->dscr);
 	if (cpu_has_feature(CPU_FTR_P9_TIDR))
 		mtspr(SPRN_TIDR, host_os_sprs->tidr);
-	mtspr(SPRN_IAMR, host_os_sprs->iamr);
-
+	if (host_os_sprs->iamr != vcpu->arch.iamr)
+		mtspr(SPRN_IAMR, host_os_sprs->iamr);
+	if (vcpu->arch.uamor != 0)
+		mtspr(SPRN_UAMOR, 0);
 	if (host_os_sprs->amr != vcpu->arch.amr)
 		mtspr(SPRN_AMR, host_os_sprs->amr);
-
 	if (host_os_sprs->fscr != vcpu->arch.fscr)
 		mtspr(SPRN_FSCR, host_os_sprs->fscr);
+	if (host_os_sprs->dscr != vcpu->arch.dscr)
+		mtspr(SPRN_DSCR, host_os_sprs->dscr);
+	if (vcpu->arch.pspb != 0)
+		mtspr(SPRN_PSPB, 0);
 
 	/* Save guest CTRL register, set runlatch to 1 */
 	if (!(vcpu->arch.ctrl & 1))
@@ -4206,7 +4217,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 #endif
 	mtspr(SPRN_VRSAVE, vcpu->arch.vrsave);
 
-	load_spr_state(vcpu);
+	load_spr_state(vcpu, &host_os_sprs);
 
 	if (kvmhv_on_pseries()) {
 		/*
-- 
2.23.0

