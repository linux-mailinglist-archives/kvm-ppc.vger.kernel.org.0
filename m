Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5663250B9
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhBYNrt (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:47:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhBYNrs (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:47:48 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD56C06174A
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:08 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id b15so3542430pjb.0
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cO00I9izdaV4ZgywXXN1ZhPvhTZLsxjfozyqUloYMJs=;
        b=i3qCvJVzCcy802+nvTxBiHekWsPWWkwBLd4OSSo9Y5NMCgrCrskQQfjoKVRNw5HivF
         S/c7t1ymihEz2eEWtuJtIaiONYmuAZxUVbZD3ztWfuitdn/E63hdnaR+rEV+naH1tg5U
         NHOEkMIsTXeOEuqsEvvtOzA10v83xTArUnMoq+o5hgii+5vEHAuD37XP3d7JpOvcRU8F
         fda7X6oj3xHFTnsm8jttHHil1BWy1jc9jDohcO77l2dCxc6eFQmR4laYrAytNn1zyid1
         5WmIVXHAOoBhV4xcAwpOo7VB96ATJIeWs4IoEXi9CZAc0i0rS9nX00gnac8dysrxIUyU
         cgPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cO00I9izdaV4ZgywXXN1ZhPvhTZLsxjfozyqUloYMJs=;
        b=Ua24tjlgIX1qsji73VSINlhBDctIr+dbXXX01r/XGjJvQSRCx/3iecF73WAunsW0YL
         JFHEcWL2cQyqoN4/KjtladPIV8Df+j8PSHlvAkKbwdCXKZ6jB8loepsuMKMitlfF/jqZ
         YQ43n2ByCBJV0r6mIV4Gevuwo88Mv5jHcXQR2byNhR4Y2ChIp9H8SwRuT7NeXXJMTBII
         sMByYKP6ngB1Y3DBeVpdPIY6FOe5HlVku9jXuWXvG5gZRXFV9BCphdFwW3dNbHZRt0gp
         0n46en0G6pQ9svDNWHEcUB136ANcNvaUsOXPnMgDh9/C1e79UvoEmYafgqwTsjiDfMZH
         egpQ==
X-Gm-Message-State: AOAM5325AB04+Sh8QimXkK/aFBT3anZSsOYW3c+xwvWmJawQquXi+BFe
        t2LvIHRu8x4KQbUFGva90PVStcB69bc=
X-Google-Smtp-Source: ABdhPJxXmN8PHnlMQg/qlEiR4RRkwJOHlBHBokTevTL+jVA25EQK2114P/4WHlVjDdD4tMGFMIHhkA==
X-Received: by 2002:a17:90b:1290:: with SMTP id fw16mr3369002pjb.99.1614260827569;
        Thu, 25 Feb 2021 05:47:07 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:47:07 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 01/37] KVM: PPC: Book3S 64: remove unused kvmppc_h_protect argument
Date:   Thu, 25 Feb 2021 23:46:16 +1000
Message-Id: <20210225134652.2127648-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The va argument is not used in the function or set by its asm caller,
so remove it to be safe.

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

