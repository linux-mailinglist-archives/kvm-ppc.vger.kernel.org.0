Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2AC131F51D
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Feb 2021 07:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbhBSGgn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Feb 2021 01:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhBSGgm (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 Feb 2021 01:36:42 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBD0C06178A
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:36:02 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id d2so3550883pjs.4
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MUyPAZov5zQTnV51w9b67tKUx5lS5BqnjhtUfqOoQYw=;
        b=Po25tvx9obyveihZvKAQVz6emB+MZz+r16nFZv2QnLx85epXNG0mr68xSmKsY/15iT
         vZdqrb3VEY2b90qX9bc4Wa5NToOiSPdNmmNMatFWyiUhGv62rrebtxlp6AaWzbMLqr1e
         dX8qBBucDJnZ9NaFmPtQ4UXx/rT1XXXPH0ptUbl6QXs3OJ92dQIfaQqjkxA9aFXcOLYG
         OKcGZzoZKBv9RQ0C8T+L+UpTurrqeGvwRyNceG08vumRz2AT3ysJFq+AXtCWjMeprR5f
         to3EEkxixSy8/Ae3rUx+mDtpOj+GqpvjCmoud5u6E1if5FKh5RPN7IcPw1e7juCWokMq
         x57w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MUyPAZov5zQTnV51w9b67tKUx5lS5BqnjhtUfqOoQYw=;
        b=SgXU8Im9ddf2r8cpPYbT0+kZ0lN2+rxEg2grZ06RG4+HW7tQpW3Eo3IwnrzpNjM+Gs
         iAUMJtkI4hM17yc6iv8CV1OwZ2bYbTyxGLZJANjjju4mQUtczOPGEHivLmLF36pV/W4U
         njPFPCp6gshyC+nQHemu8Hi348GmL2yX9dO8yOR8WzxGVERSGAF02FVHrwageP2mFByG
         c6go5cPAtkFrGxVhn12BZYf0619JsyfRRLC9V7Quw9o4vt7GjJ7WiaCWbRMBjd7I7CrK
         bdRbPylichyQ9/EFQOd6w/uDMrogEm6hIdIZzXi00U1rWAyxl8iAjLO35TtNu8NcX96Q
         YQBA==
X-Gm-Message-State: AOAM530rsBxM37HZHmbCnMsmR8DBccy2uLhS2O34o1EInO4nnrWyzIqj
        qiyiaVfDk/PNm4rn9f/QfPAaX5cw2wY=
X-Google-Smtp-Source: ABdhPJyecnoYuWDxLso9pw/qesZLnH6rz6NAaN7IA1CH6YikLtJgcQydb/NU9cZqczVIn7juyRoyLg==
X-Received: by 2002:a17:90b:1805:: with SMTP id lw5mr7699203pjb.82.1613716561567;
        Thu, 18 Feb 2021 22:36:01 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (14-201-150-91.tpgi.com.au. [14.201.150.91])
        by smtp.gmail.com with ESMTPSA id v16sm7813099pfu.76.2021.02.18.22.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 22:36:01 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 04/13] KVM: PPC: Book3S 64: remove unused kvmppc_h_protect argument
Date:   Fri, 19 Feb 2021 16:35:33 +1000
Message-Id: <20210219063542.1425130-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210219063542.1425130-1-npiggin@gmail.com>
References: <20210219063542.1425130-1-npiggin@gmail.com>
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
index 0a056c64c317..45b7610773b1 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -765,8 +765,7 @@ long kvmppc_h_remove(struct kvm_vcpu *vcpu, unsigned long flags,
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
index f87237927096..956522b6ea15 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -667,8 +667,7 @@ long kvmppc_h_bulk_remove(struct kvm_vcpu *vcpu)
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

