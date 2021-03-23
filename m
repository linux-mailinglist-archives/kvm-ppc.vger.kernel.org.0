Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482FF345471
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhCWBDq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbhCWBDh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:03:37 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E7BC061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:03:36 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id k24so10038027pgl.6
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jg3hJJ3AY2PRkc+v0V7qcNrjz/l+y41Urd3AyMqPGgM=;
        b=SWE1QWI10AhCc9y8qwD3x90YQGTmiIud1M4CAKj9C7wM66nPX9am8/nrcs5BlBX8lX
         /ict70IatbGRWiIh36ZjP+T0s7w6sjHFyWNgm68Dl2U8J+FBCTUFuoHu7lQIhqbou7hR
         ml+IYIvvuuCNjfuTvBF+ObvQNpBpJQ66ltGM10FegddIjwqcK/WhXOo+VB4ams6KnQ4M
         lg07VIck/JOCj/XZryRQ9W/KnlXK92sy8SZZwv+MsgI8wCl7nMTDRgDK6wXBE/gGpNBa
         Tv+KsGYpwR6yijKqgCqFYuwYjS/EEwTzOOokhzMXBgYvy5v4/hq5sCh8GO5oamnbr91H
         19og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jg3hJJ3AY2PRkc+v0V7qcNrjz/l+y41Urd3AyMqPGgM=;
        b=jjwxKjhW1ntIui66qGD63PeMWhCIyvPyMk++vhSSVOkwmM95ChJqhPVBSCfRouWudk
         q4GXT2q3DEB0CAiDbn9uDJQ4QcBEisNVlHKI9tYHmgo9tjwse6wXO95k5N9bqD3VG6Vd
         YdSgL69LYaeIPGW7NRnPGWr8c6fNyeZ5KJ1kCTAsipt4FLgSXyjZGDA5DHJXngSNUrJF
         pRIFZTAknPH9VDlYHUj+2pH0vJEpL6UjqGqn6dipyweSs9PtUfG1zFODZ35LUYuUuj8P
         imb5gBsQe07XI0J9jU99aCjlK2pDyixQc4YRbWbD6QaoSWUrrMdLpoDMkI+3ufxYgfNT
         /3nA==
X-Gm-Message-State: AOAM533Q37UpkbdC07RuapcofpCSzuxzW3mryqcbP8qIIEidnSppidSU
        0vZwQ7as0etCkXLFyCBHaHsIlcT0OII=
X-Google-Smtp-Source: ABdhPJzvuQhaH04pDc6YtgQ6MnkZPXqQZrr/Zhyytlbcus36SAz7DmWu8xFjZacz4nCnY+mwoVMu7Q==
X-Received: by 2002:a17:902:820e:b029:e6:f006:fcff with SMTP id x14-20020a170902820eb02900e6f006fcffmr1229901pln.60.1616461416065;
        Mon, 22 Mar 2021 18:03:36 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:03:35 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Daniel Axtens <dja@axtens.net>
Subject: [PATCH v4 06/46] KVM: PPC: Book3S HV: remove unused kvmppc_h_protect argument
Date:   Tue, 23 Mar 2021 11:02:25 +1000
Message-Id: <20210323010305.1045293-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
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

