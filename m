Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B93532EDC0
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhCEPHK (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbhCEPHA (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:07:00 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C816C061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:07:00 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id l7so2364800pfd.3
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jg3hJJ3AY2PRkc+v0V7qcNrjz/l+y41Urd3AyMqPGgM=;
        b=ozRaWqyOXFZZIe1oKZ09TVdVMyI8dCsWfXfxYwP23i67RR8WLxy4ZKssAd0HkvE2En
         VzF4XioeJeg2CQzz1VdNqYjEqnHx5/7OWH6i6nCg96t9Pb+MOyYuG683mVRTq2gK6bs/
         gbCkBMVU5IZ4Vd1MWCIszhZc57wpxyF+ImiPgrgL8RCndp3W+81BVDFGR/h8bdrAiCV9
         3hNm7PF+iYbKnjEwtAv5q8GWqHJvGv9rA0m5yXnIS1WRL/FEj99JDcQ9GytMqoX01EbC
         LOVKO9C1Lb643BPkaWWcag0kXzZxHrsaLSEilTzUFt8Y2OXQhjTivC7OvKAsHsFRrHzg
         6kHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jg3hJJ3AY2PRkc+v0V7qcNrjz/l+y41Urd3AyMqPGgM=;
        b=NPkEZI4IIipEdxKiuRi+tcXZx2Rp3wuVD+ZWNMQqDbRa+Q9eIBK0sxk4+EiDbbgcgL
         WeYLWk9HV1FgcpltOK4FxCM7M6xSJy5GMhL3+5TXlMNA5NGXt/BMRWS0l1/MX7ESR4I2
         vj7WRcsftix0emvzNXuub+4tIY3JKR19DdXfDTuE0nu735gjFvKT34u6OCOlIPyEit71
         Vf+q++4JXrIRcy4GWa42KkI7llPGGSKPkfh1LrknLtWeIpr8aZZ+JuKmgFPOX+Fkz7+k
         56gvoYFRXFKGYDoeoCYdufcGWjV6r6gpaoinnZahD0jGf+iMr9yQPomc8gkABKo6JyK0
         RMmQ==
X-Gm-Message-State: AOAM532cWzkj7zDoPs6BOZh03IsdfaDQOMvmFiIvV3c1xnkGeYHrWafS
        sNkaRgTpLJATxu1CPLFQ+HSJDEiiCus=
X-Google-Smtp-Source: ABdhPJzegQq0tsMJ2CKEU1yp/D4gqtyXoE40J4UK9COw6KOPhttFwmKagBrbcYSrwEIGWEnWBOlbhQ==
X-Received: by 2002:a65:52c6:: with SMTP id z6mr9126628pgp.132.1614956819808;
        Fri, 05 Mar 2021 07:06:59 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:06:59 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Daniel Axtens <dja@axtens.net>
Subject: [PATCH v3 04/41] KVM: PPC: Book3S HV: remove unused kvmppc_h_protect argument
Date:   Sat,  6 Mar 2021 01:06:01 +1000
Message-Id: <20210305150638.2675513-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The va argument is not used in the function or set by its asm caller,
so remove it to be safe.

Reviewed-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_ppc.h  | 3 +--
 arch/powerpc/kvm/book3s_hv_rm_mmu.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 8aacd76bb702..9531b1c1b190 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -767,8 +767,7 @@ long kvmppc_h_remove(struct kvm_vcpu *vcpu, unsigned long flags,
                      unsigned long pte_index, unsigned long avpn);
 long kvmppc_h_bulk_remove(struct kvm_vcpu *vcpu);
 long kvmppc_h_protect(struct kvm_vcpu *vcpu, unsigned long flags,
-                      unsigned long pte_index, unsigned long avpn,
-                      unsigned long va);
+                      unsigned long pte_index, unsigned long avpn);
 long kvmppc_h_read(struct kvm_vcpu *vcpu, unsigned long flags,
                    unsigned long pte_index);
 long kvmppc_h_clear_ref(struct kvm_vcpu *vcpu, unsigned long flags,
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 88da2764c1bb..7af7c70f1468 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -673,8 +673,7 @@ long kvmppc_h_bulk_remove(struct kvm_vcpu *vcpu)
 }
 
 long kvmppc_h_protect(struct kvm_vcpu *vcpu, unsigned long flags,
-		      unsigned long pte_index, unsigned long avpn,
-		      unsigned long va)
+		      unsigned long pte_index, unsigned long avpn)
 {
 	struct kvm *kvm = vcpu->kvm;
 	__be64 *hpte;
-- 
2.23.0

