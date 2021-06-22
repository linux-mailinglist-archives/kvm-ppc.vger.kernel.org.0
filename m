Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842D93B0210
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhFVLB0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhFVLB0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:01:26 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0353CC061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:10 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id l11so7528474pji.5
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vsu3dIydt3f5nT2j6TrGrwAAXR/s/7OmUGaERVcQdoM=;
        b=pnczJJxKHMB7ThmLHpWXmBKWj5JvA9KrbMi6qAFy77U08FHlIDStN5+Z/UIOq7gY06
         m2AUtvXnZIR+LAs4Xn0VQ65nxIzvG0vUXjryi9DU7r44gk2mhbBOyry2irl+FMEVfj7o
         +GVjqjkDlPEA4KRHundYZ2EotDgv0inTnwHM7NhjOmQUdKvTt+oS6myS8jw8CvR4tTmC
         FsqbU2bGG7VSXwjNp2YU/YUCT0CIsnUHpaXDSy/U0Ak4E04RGCkAD6aX+zBl9utfUuLe
         WEUaNUMj0juPy+CBJc5maFfVBypC/0KJKMPufWW8zwQuOxoP/ohqRzd6HuE87dPUkUDP
         heFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vsu3dIydt3f5nT2j6TrGrwAAXR/s/7OmUGaERVcQdoM=;
        b=W0lyyiuFoy3xbTOoAHTlmqVoyu5Uc0DQMYZGDT6tQ/i6BcsWd0NglgP5zk1Gg5f+Or
         dCUsXJfR370B3O2Kl2JXDlEIgh9mO43tyk8nFvjbUmwTTggcilyW1YqYV5N+qlUJPOY5
         mrDYnIlHbrFB6CcAzbjnY3EjfD9VJ9qIE6uy1o+3jxmEd/67Ikkd/FQd1uCLUlVjxH46
         ninVuMn099pC8ndMmuuLGH0PULECWhRwncrCrJkNQu9nkK+bIbePySO/fvZ+KqV74MS0
         gQtFLooL4gJfkAazYQDb7RGMrEk+izLDGNCNs6Q3DY3e/lGB42paOLx4UGjsTQyXfqWL
         5g4Q==
X-Gm-Message-State: AOAM530FkV9rY4yNzKY8xdBHOUcXxXgL4lrqrb5NU5Jpyi2dOG0UMLnE
        HHFFVh6AxWkVnEylt8YXl6lMyCZiu5Y=
X-Google-Smtp-Source: ABdhPJxq9mUJQfgQvdt01Ubbhiq6oulm382r6AR+kdY4/sRCNsQW49Q+58Nm8XyVfUOf/kOSWjhdfA==
X-Received: by 2002:a17:90a:5d83:: with SMTP id t3mr3395224pji.195.1624359549482;
        Tue, 22 Jun 2021 03:59:09 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:59:09 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 30/43] KVM: PPC: Book3S HV P9: Implement TM fastpath for guest entry/exit
Date:   Tue, 22 Jun 2021 20:57:23 +1000
Message-Id: <20210622105736.633352-31-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

If TM is not active, only TM register state needs to be saved.

-348 cycles (7218) POWER9 virt-mode NULL hcall

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index f5098995f5cb..81ff8479ac32 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -271,8 +271,16 @@ void load_vcpu_state(struct kvm_vcpu *vcpu,
 			   struct p9_host_os_sprs *host_os_sprs)
 {
 	if (cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
-		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
+		unsigned long msr = vcpu->arch.shregs.msr;
+		if (MSR_TM_ACTIVE(msr)) {
+			kvmppc_restore_tm_hv(vcpu, msr, true);
+		} else {
+			mtspr(SPRN_TEXASR, vcpu->arch.texasr);
+			mtspr(SPRN_TFHAR, vcpu->arch.tfhar);
+			mtspr(SPRN_TFIAR, vcpu->arch.tfiar);
+		}
+	}
 
 	load_spr_state(vcpu, host_os_sprs);
 
@@ -295,8 +303,16 @@ void store_vcpu_state(struct kvm_vcpu *vcpu)
 	vcpu->arch.vrsave = mfspr(SPRN_VRSAVE);
 
 	if (cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
-		kvmppc_save_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
+		unsigned long msr = vcpu->arch.shregs.msr;
+		if (MSR_TM_ACTIVE(msr)) {
+			kvmppc_save_tm_hv(vcpu, msr, true);
+		} else {
+			vcpu->arch.texasr = mfspr(SPRN_TEXASR);
+			vcpu->arch.tfhar = mfspr(SPRN_TFHAR);
+			vcpu->arch.tfiar = mfspr(SPRN_TFIAR);
+		}
+	}
 }
 EXPORT_SYMBOL_GPL(store_vcpu_state);
 
-- 
2.23.0

