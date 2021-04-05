Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9443353A8B
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhDEBUc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbhDEBU2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:20:28 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E70C061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:20:23 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id g10so4917157plt.8
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kcMSsKOd9XJdn7alZvC43Pwxot302AJo0nnXaxeTFDs=;
        b=oFuGn8uX+ROQHvXOx9JhZf+MLrC6LVCvFmuGEVKre8zV53rMFZFlLyFkqKvEA8ZnGP
         bqIT3G31WiEYLEOKfDo/DpHuT9SoQrqcXnMI5U6n3tXaleXSBO8ARK/SVPWFRVciRGft
         VoxiJ7SVLJM8DXFqm2pnSRp0bpKeizMkh++ZVQLPeDpI0hZ6P1PP/ePO8VaemLvmww+Z
         07h5qNP6YFA6R+Q4oJftIcT8xlMN7ed+OEZR3SKciXmMAD6xoPqGbvYWgoZjGHBLqlN1
         7YpYmiQEsz0KBBP02dr0kXBE1zoQlD+Q2NKTDK9M44NBanc1JhVBc1jcwh7NDnK3akkH
         BkVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kcMSsKOd9XJdn7alZvC43Pwxot302AJo0nnXaxeTFDs=;
        b=PXG1uesfEpRwqbIb/d1d7T+9HYh+ms8fx2kJFxovyL9yaubpXC/zTxjWYo3APyKRt8
         pZcFRJIo7zJ7t1BWC1w8mpaSq2hhjUDiVYIQcfnowZTHphkniEyhU9WByWlSBS7S6SBv
         vhsDlyu4ZMFARfAaAZRlbyxg8/XA3mQUdB93kbtm/G7V6G4Pgo6FEGeUFUweepBi1NgZ
         VMQ3dqsMn8rLXaZR22YLI8Iu/do8HP+ruFl5Y8iazySITRXcBo3muaYC5keMTlufFCgx
         IlIH6NwW9YpTuNR4GSrYxzf8FV/dRpDc3tmYNqKU7BmHv6+xRUU49gZ9DKWhNoAQXNb8
         tjEw==
X-Gm-Message-State: AOAM531GOa7lgoTx0GkM6PPGuLWRk22ilw0lWoaZNhWh6qcIBgOcPaF+
        KO3Nojt/OwWXgkdqLWXv1vCHgftErjC5Jg==
X-Google-Smtp-Source: ABdhPJzu6OWLDH6qzyRrj0OWZN7Ppb3avbojcT1MReb+hAokjIRNAbh9i0Xlz//auLea/i8zqZPdSg==
X-Received: by 2002:a17:90a:5d14:: with SMTP id s20mr24453563pji.6.1617585622570;
        Sun, 04 Apr 2021 18:20:22 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:20:22 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Daniel Axtens <dja@axtens.net>
Subject: [PATCH v6 06/48] KVM: PPC: Book3S HV: remove unused kvmppc_h_protect argument
Date:   Mon,  5 Apr 2021 11:19:06 +1000
Message-Id: <20210405011948.675354-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The va argument is not used in the function or set by its asm caller,
so remove it to be safe.

Acked-by: Paul Mackerras <paulus@ozlabs.org>
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

