Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44C73CB0D0
	for <lists+kvm-ppc@lfdr.de>; Fri, 16 Jul 2021 04:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbhGPCqO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 15 Jul 2021 22:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbhGPCqO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 15 Jul 2021 22:46:14 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C249C06175F
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Jul 2021 19:43:20 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id o4so3961144pgs.6
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Jul 2021 19:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dgv35F0XGHEdY1CvtkrxQlnoalQMMI8wR2LzajycnMA=;
        b=pG7BChhlBdYYSyjrFwwqLogfRRcC2vYp7G4mdTUb6AlqbLezFtTBiZbmiAVLBu1ItX
         iUnhu5iaB10HxJE7Y0o7NhEv4MZgWQLe7Luqx8eXjfsFD/sUOa6BczzCE0N6W8eH8DQO
         ZTzXytFtRsuXVpoNBnNJ0H92ml6cMBxhQT7eHwNuHryOpShDBaG52wA6m1Y1V45cqaae
         ghEuwirHsXZhgmeBzjzeKTg+XyvNjJbM4Rwcsi2n969/1NzjdoB2Ozr4f8A01DtiRsHb
         WDy0lGG4I+2L9bCULEgscPjXRCA9Xk0TQIH615WRdzMjhZfnSvbI7Yn/MzyY77TVi+fi
         X9vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dgv35F0XGHEdY1CvtkrxQlnoalQMMI8wR2LzajycnMA=;
        b=baehjRZG60+KSyVJ0qQeJsYEj+vWk5+P8ZrQInY+X1pWz3CRtCLVvHDMNzqiMCBArw
         xrPcsgzkuuyOoM3YpN8graPn9ZLkI1FU/a0QoBdxkWranCFUrCbEXZS4qSvVvV7iBzbl
         R1bLaifm6le9fhaiaoB8GvBA0XbwHey5CqHdxsuBPTPDVZnJmvnsju+26TClpA0Qcw1V
         hqNKUbvZ+0rowPhbBYFnVO0Pa37o2aXFpEMEvECQ3+Nv1fW7ilnH6VxX4K2KhXnRF4Gm
         vCcTlZE9f9qEW1m9qEO1VT/UDPz45eRiHh9vfUtYlkVjlgJZrIpghCIuw4SMO3D2E2F0
         nhVg==
X-Gm-Message-State: AOAM533jiJjaWod68CBbnM8EKuh+Wg9TOaiINefSPpfFMKgq0Un38H6U
        SDDoaPyYTiVXoZZNqhAu/vtmQoQDD8k=
X-Google-Smtp-Source: ABdhPJzMnUQRrmTDO8DdrYzLJ5ZbfwShPiH4t804ABkzx0ELRlEfwLmlhWpTTp4TG1R1iG5XofClyw==
X-Received: by 2002:a63:e0c:: with SMTP id d12mr5843650pgl.386.1626403399969;
        Thu, 15 Jul 2021 19:43:19 -0700 (PDT)
Received: from bobo.ibm.com (27-33-83-114.tpgi.com.au. [27.33.83.114])
        by smtp.gmail.com with ESMTPSA id f3sm8298406pfk.206.2021.07.15.19.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 19:43:19 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH 2/2] KVM: PPC: Fix kvm_arch_vcpu_ioctl vcpu_load leak
Date:   Fri, 16 Jul 2021 12:43:10 +1000
Message-Id: <20210716024310.164448-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210716024310.164448-1-npiggin@gmail.com>
References: <20210716024310.164448-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

vcpu_put is not called if the user copy fails. This can result in preempt
notifier corruption and crashes, among other issues.

Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Fixes: b3cebfe8c1ca ("KVM: PPC: Move vcpu_load/vcpu_put down to each ioctl case in kvm_arch_vcpu_ioctl")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/powerpc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index be33b5321a76..b4e6f70b97b9 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -2048,9 +2048,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	{
 		struct kvm_enable_cap cap;
 		r = -EFAULT;
-		vcpu_load(vcpu);
 		if (copy_from_user(&cap, argp, sizeof(cap)))
 			goto out;
+		vcpu_load(vcpu);
 		r = kvm_vcpu_ioctl_enable_cap(vcpu, &cap);
 		vcpu_put(vcpu);
 		break;
@@ -2074,9 +2074,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_DIRTY_TLB: {
 		struct kvm_dirty_tlb dirty;
 		r = -EFAULT;
-		vcpu_load(vcpu);
 		if (copy_from_user(&dirty, argp, sizeof(dirty)))
 			goto out;
+		vcpu_load(vcpu);
 		r = kvm_vcpu_ioctl_dirty_tlb(vcpu, &dirty);
 		vcpu_put(vcpu);
 		break;
-- 
2.23.0

