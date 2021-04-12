Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DD935B83E
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Apr 2021 03:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236250AbhDLBtb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 11 Apr 2021 21:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbhDLBtb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 11 Apr 2021 21:49:31 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24350C061574
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:49:14 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id b8-20020a17090a5508b029014d0fbe9b64so7912572pji.5
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kcMSsKOd9XJdn7alZvC43Pwxot302AJo0nnXaxeTFDs=;
        b=oaMIqZMuF9h46PXHq2w5frutdhjVdbzFQ/RgtRuTZVsNH25Sql/BRImfJpf2DppH+j
         qrcUl+hm7A4MnjXqL07G7TbJAe3kwQG0DBJiDVNrEKZhFisbJOV3/48725lnxI6lQ80t
         6uBV3yhMmdYlqlJNvozEpRvCtdmlzMNOZhbynxjhOy9PyZk0wvkLGwGdopOE3aRadKrj
         3aGzBNzvLnoZfH4ZVkZPWzHDVOLcYF5+B1w21OsesRB0Ui0mJ5GRqYGGEwYJDbetXO/w
         DSIT9c5rrwu4Co2c88/CeDFnYFS9es9laG7oVlLkEdfb3rNNNpvDGR4Zy9cgzsB75oMG
         FtaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kcMSsKOd9XJdn7alZvC43Pwxot302AJo0nnXaxeTFDs=;
        b=pMJIHGRdVeeW6meJAyIXQPv6TWHqxqilU9pomJTHHGunKqSH0JLYcUomYI8xGYSpXG
         qjeyNZ/JhqCxjAbTO1FCpIqSUpRAXfhFWSU9US1fTxaELFtyz2TfDKIUJxFntN0l1QP/
         6mhpk931kYad7oIlJEmK/Ftp9Cqpz2LaFucYU9tqtCacsQKF5Y+e8BGejxSFdTkHrJ7E
         YY6RcunUyaELXfe0tb+ncbIO1vl/kRZJJ/0mmcJJMTaDnjZWnFh2dvbg8krhK8EQIue7
         kFu190L/OVICKv1Y/HOsnQxNhr82mFCxYyiIoROjwGlCuFXYJ0b7wWpfs83Deii8pTAM
         l3Rg==
X-Gm-Message-State: AOAM530j6SNlz4+ey30yX4L+OrDtDm6rezRZDftcTSqIb0NPCFYlx3KB
        wKAhrl7COZl03mfVv5jbMWOfSEMpU88=
X-Google-Smtp-Source: ABdhPJxkVMeKqonbtISJdYvssi+IxOxmxROFHYyGS5xTROxGG3Onv78B4DAmhk+vPzuVS+H+r0AYLQ==
X-Received: by 2002:a17:902:e886:b029:e7:386b:1b30 with SMTP id w6-20020a170902e886b02900e7386b1b30mr24255037plg.42.1618192153584;
        Sun, 11 Apr 2021 18:49:13 -0700 (PDT)
Received: from bobo.ibm.com (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id m9sm9502345pgt.65.2021.04.11.18.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:49:13 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Daniel Axtens <dja@axtens.net>
Subject: [PATCH v1 07/12] KVM: PPC: Book3S HV: remove unused kvmppc_h_protect argument
Date:   Mon, 12 Apr 2021 11:48:40 +1000
Message-Id: <20210412014845.1517916-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210412014845.1517916-1-npiggin@gmail.com>
References: <20210412014845.1517916-1-npiggin@gmail.com>
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

