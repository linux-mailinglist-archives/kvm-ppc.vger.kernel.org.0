Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573B542136A
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236245AbhJDQD5 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236284AbhJDQDz (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:03:55 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1569C061749
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:02:06 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id s11so16966848pgr.11
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NfJOjCJ/v6ZV2LFYZwsNEIjww7KBaxYWLhodjyZWfLI=;
        b=kmBFcBfvDyvkYTfWJeoHR03tCDT3ZOvbzr+qWLrNctK8phXRCA4yZzY8DwHkmVpl6i
         5/XNkLmZFL63Fsi2Rz5F42PGAJtQiKWSWOCxC8I4BLay4Xdt85+FcnrhuR3EjhCcqBJe
         XiJgZzPs5Zbiv+HrSlLHNzZTlxfwwKrSOhK5MvsadscXOrPA/IxRiWS8ZCRMvWDa4YG/
         WeabSMO8r+b29nCzB94Y4h3TE9R+59KMVsWxuWQINYGZeP161FBwW8FAhd8HteK2SzGN
         WmQ8dtpkG3z0kaY4w5k3ZKuaTAMYoIosxCv/XdhuwA4kiLB9EK2tq23h/XPOeoWYHrME
         5AIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NfJOjCJ/v6ZV2LFYZwsNEIjww7KBaxYWLhodjyZWfLI=;
        b=fOtYCzii4gwy2tUSfDm5qapLcfvRl+5HU9SiMuWYWnQxoBaTn0YQ3uHnXRq/NkYl8n
         DC6BPArdnoO5lss80Uler6Wy+inBRM6HycxsYp3kyiqKgCADXADtYJLsZiYkHyPxSvkk
         j9E+6wKSt2EGm9gRI6Axw4axgZEpfEDqhqd7jbH9XvoSkYYtT8Z9SaQZborJTty1P7DC
         0C6qhMJHJQg62ObvlQua8Syum4f612yYGV6wVFQw7QPG9d7eWDAUpO2/uWKfRGP18gYi
         NUwqduQo/9w1VaqXiR5Y2NUcPM3tMZPOFfbwrf1VnkmjwBydO65O8LliF0K9u/qhetjj
         BHTA==
X-Gm-Message-State: AOAM532KGNUn8C+ReTOFevMQxKFT/MIWDETxP6lbkuhYNHe7j188mdEH
        d9MjX7G5HuhO7oNoKZOfVwyChKHW4zA=
X-Google-Smtp-Source: ABdhPJwHfQ82qhsj2MZOiN/a0Ys0BngjnAHpeoAK+RJN54quEMc+t27HX7MeBOnqe7l83lNwt3N9uQ==
X-Received: by 2002:a63:6e02:: with SMTP id j2mr11581304pgc.157.1633363326090;
        Mon, 04 Oct 2021 09:02:06 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:02:05 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 27/52] KVM: PPC: Book3S HV P9: Juggle SPR switching around
Date:   Tue,  5 Oct 2021 02:00:24 +1000
Message-Id: <20211004160049.1338837-28-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This juggles SPR switching on the entry and exit sides to be more
symmetric, which makes the next refactoring patch possible with no
functional change.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 460290cc79af..e817159cd53f 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4209,7 +4209,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		msr = mfmsr(); /* TM restore can update msr */
 	}
 
-	switch_pmu_to_guest(vcpu, &host_os_sprs);
+	load_spr_state(vcpu, &host_os_sprs);
 
 	load_fp_state(&vcpu->arch.fp);
 #ifdef CONFIG_ALTIVEC
@@ -4217,7 +4217,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 #endif
 	mtspr(SPRN_VRSAVE, vcpu->arch.vrsave);
 
-	load_spr_state(vcpu, &host_os_sprs);
+	switch_pmu_to_guest(vcpu, &host_os_sprs);
 
 	if (kvmhv_on_pseries()) {
 		/*
@@ -4317,6 +4317,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			vcpu->arch.slb_max = 0;
 	}
 
+	switch_pmu_to_host(vcpu, &host_os_sprs);
+
 	store_spr_state(vcpu);
 
 	store_fp_state(&vcpu->arch.fp);
@@ -4331,8 +4333,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	vcpu_vpa_increment_dispatch(vcpu);
 
-	switch_pmu_to_host(vcpu, &host_os_sprs);
-
 	timer_rearm_host_dec(*tb);
 
 	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
-- 
2.23.0

