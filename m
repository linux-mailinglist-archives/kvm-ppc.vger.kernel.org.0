Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DAD351C9A
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237034AbhDASSx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 14:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235979AbhDASM4 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 14:12:56 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574DCC0F26DB
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:03:56 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id l1so1143132plg.12
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kcMSsKOd9XJdn7alZvC43Pwxot302AJo0nnXaxeTFDs=;
        b=X42s5iMIZ8VJmYhLjDMQ1fG68+zbh1OZGwNj581LTwHnZyFso7dfXWP5kG2pehaXKf
         cc1Aev+HMViY+WgaOyBKv2QBEtiz4/CK1/hPgBuOnn8jDCkA/LrLDs4CVZMOLGdT9y/I
         m7P3ku5KL4BFRoNG1JBoiaA8HR00t4FwR8cBBgjfxio2ObTrEjGVCgZBt35BIHNh08/E
         TirvTq6DEmXzU6dFW7XhBm0pWc4ttCH0S2a3EwbKwu8V6XvnUmQbf+4MfQnL9gFOvTRG
         DGPigADvIi27D9Eegmo+GHPYyXQt1BEuudpIbWtMEYL2vxz8hLQhCahA4H2YHy1eHAte
         89sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kcMSsKOd9XJdn7alZvC43Pwxot302AJo0nnXaxeTFDs=;
        b=q446+9YwSnZiwtSsOOxVOqKxpu12k//WH6yWhNZbcm3TFmSizGL6LVBH/Da+o5X6pU
         MWpU3n/GY+n88HKdlS8fcAEdiNMeCXUkh87FaXvtxM7+6eJVTGKf80aHHdhXDVV9VXEr
         NRFGNu8Qz0ViWL7jEC1ILw/RmzsMqpcGNhSxg1VUSwM2ntr077Tyg/Ax2glTMlmNgy1r
         xdQHeE6wySrj8nVx/rVMCmlEg37cuyR0zhj62muywInOA3/ZcF0qEL6rwtlGsH3joMgM
         2q09kDm+FieWAY3hgaOk456+/bMIpmKG4Gmm8sKCrpPSULmJr8Pi8h8+3I1gI6lK4BeU
         v2pA==
X-Gm-Message-State: AOAM533EODUaqRgQHJd8g0Z5X1eB84Yzp80AMZITyFO+NF5LAVlpNPx7
        WIKPjuaw1zcgoknWV8K3WCuSgccIzWU=
X-Google-Smtp-Source: ABdhPJzucCzWJyJxZ6llO8KDm+Iua3MGa/eX4OL0JhjyB/Zj+t6yc4J+MGXAJy02ZMDFx+UaSbesrQ==
X-Received: by 2002:a17:903:22c2:b029:e7:1f02:434c with SMTP id y2-20020a17090322c2b02900e71f02434cmr8391810plg.73.1617289435762;
        Thu, 01 Apr 2021 08:03:55 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:03:55 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Daniel Axtens <dja@axtens.net>
Subject: [PATCH v5 06/48] KVM: PPC: Book3S HV: remove unused kvmppc_h_protect argument
Date:   Fri,  2 Apr 2021 01:02:43 +1000
Message-Id: <20210401150325.442125-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
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

