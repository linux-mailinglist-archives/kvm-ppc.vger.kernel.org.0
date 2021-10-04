Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C536642136B
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbhJDQD6 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236275AbhJDQD5 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:03:57 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C9DC061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:02:08 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id g184so16988973pgc.6
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cHcJEgGt4n//rNMwXrbb2Y/Mu7D+Fv1X8CuV0T7O8Vs=;
        b=ZCX0inXv0MrSy7yOTcot9uSY5rrJGLIWLiBIXdPGSJF6ASQUYWsaU0/w5uKPzWV+Ui
         aWfbjTapfvTvkn+PALykkkqrRyOv/scTGMbD5fEwq+W5rMZbInywp1Dn9azhGAp1YIen
         /FpV4zfB6u8JxhpreDlufSAvb/j4qRtndFI0tdpYHxL7zXKpkWsj+j/EW17Jm+e+A3U4
         QGOirG8ta+hzx3mjWOglhvMyO7nLfkdft/8yORz23dTBVkFcpNtO1FLCMJ+B2xeidln4
         aC0wqJAXZlM/AiwblHZ5c9GUvpTN4oNxT9jTwhI+cQDv1RdxF0okXw9n2KEUXP+rVlxW
         wp1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cHcJEgGt4n//rNMwXrbb2Y/Mu7D+Fv1X8CuV0T7O8Vs=;
        b=CDjmGTEG99rxyaR6lITl3QNp5cOle5WA8qDysVNPRR2Zf23w8IysC2h/W2N9rbIJWq
         ErN+9rUlIUCWbCuw4qDLaoMhvpS1DYztkW6w7DCQroHDKpx5RRyWF2SjAjYa14gMAN91
         IIb63rYeqeqJBRTvb3vH+92VBJ0H6XIq1j7ykfZ+3074XGDdECx8wqFRu9ReM9Ohy5F/
         l8PfijcG8Fms6wtZCB1oTIwDQhi9Crc2FAbXl+SMTeTnlDZqgpYirF2cZmc4wvQmc8nG
         Mh5DhDULUSltn/3Xb4XXLROjvEZC/Puszg2akkJd+du7sTvzHSGDJhoWknuKz71tV0lp
         HbdQ==
X-Gm-Message-State: AOAM532YGJapZUTUHu9I58J3/1YS9nhvDYFU2RFlUFZldxhvJzIHmEoc
        8fb8FEI1UIoFcB0x6qvJPALz8VaTncE=
X-Google-Smtp-Source: ABdhPJyMLdF78dTzsR3aMr2JFmPBHAVM6pfQ4cZXRuCnk2nN9vfsDlg5NOECIMknwDtpoTpN83YdPg==
X-Received: by 2002:a63:4003:: with SMTP id n3mr11399906pga.413.1633363328192;
        Mon, 04 Oct 2021 09:02:08 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:02:08 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 28/52] KVM: PPC: Book3S HV P9: Move vcpu register save/restore into functions
Date:   Tue,  5 Oct 2021 02:00:25 +1000
Message-Id: <20211004160049.1338837-29-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This should be no functional difference but makes the caller easier
to read.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 65 +++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 24 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index e817159cd53f..8d721baf8c6b 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4095,6 +4095,44 @@ static void store_spr_state(struct kvm_vcpu *vcpu)
 	vcpu->arch.ctrl = mfspr(SPRN_CTRLF);
 }
 
+/* Returns true if current MSR and/or guest MSR may have changed */
+static bool load_vcpu_state(struct kvm_vcpu *vcpu,
+			   struct p9_host_os_sprs *host_os_sprs)
+{
+	bool ret = false;
+
+	if (cpu_has_feature(CPU_FTR_TM) ||
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
+		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
+		ret = true;
+	}
+
+	load_spr_state(vcpu, host_os_sprs);
+
+	load_fp_state(&vcpu->arch.fp);
+#ifdef CONFIG_ALTIVEC
+	load_vr_state(&vcpu->arch.vr);
+#endif
+	mtspr(SPRN_VRSAVE, vcpu->arch.vrsave);
+
+	return ret;
+}
+
+static void store_vcpu_state(struct kvm_vcpu *vcpu)
+{
+	store_spr_state(vcpu);
+
+	store_fp_state(&vcpu->arch.fp);
+#ifdef CONFIG_ALTIVEC
+	store_vr_state(&vcpu->arch.vr);
+#endif
+	vcpu->arch.vrsave = mfspr(SPRN_VRSAVE);
+
+	if (cpu_has_feature(CPU_FTR_TM) ||
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
+		kvmppc_save_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
+}
+
 static void save_p9_host_os_sprs(struct p9_host_os_sprs *host_os_sprs)
 {
 	host_os_sprs->dscr = mfspr(SPRN_DSCR);
@@ -4203,19 +4241,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	vcpu_vpa_increment_dispatch(vcpu);
 
-	if (cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
-		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
-		msr = mfmsr(); /* TM restore can update msr */
-	}
-
-	load_spr_state(vcpu, &host_os_sprs);
-
-	load_fp_state(&vcpu->arch.fp);
-#ifdef CONFIG_ALTIVEC
-	load_vr_state(&vcpu->arch.vr);
-#endif
-	mtspr(SPRN_VRSAVE, vcpu->arch.vrsave);
+	if (unlikely(load_vcpu_state(vcpu, &host_os_sprs)))
+		msr = mfmsr(); /* MSR may have been updated */
 
 	switch_pmu_to_guest(vcpu, &host_os_sprs);
 
@@ -4319,17 +4346,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	switch_pmu_to_host(vcpu, &host_os_sprs);
 
-	store_spr_state(vcpu);
-
-	store_fp_state(&vcpu->arch.fp);
-#ifdef CONFIG_ALTIVEC
-	store_vr_state(&vcpu->arch.vr);
-#endif
-	vcpu->arch.vrsave = mfspr(SPRN_VRSAVE);
-
-	if (cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
-		kvmppc_save_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
+	store_vcpu_state(vcpu);
 
 	vcpu_vpa_increment_dispatch(vcpu);
 
-- 
2.23.0

