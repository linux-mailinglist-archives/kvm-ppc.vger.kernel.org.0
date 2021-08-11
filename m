Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1C53E9537
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbhHKQCL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbhHKQCL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:02:11 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0E2C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:01:47 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id a8so4180677pjk.4
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E8HC5KhjUlV41KsAAH26eBl3oXcWuvaOrNt60v4bxY0=;
        b=mV7UlH3DvLgMJ8Q4WElYlwvm7C5mdnCt9HgAQtZZc1cxirIowLROGpkT7TzbPvH0UD
         CvAWp7Dgg0cMgq4AUy2IdhTak631/ziDI7mUFyKWlsjMNySAUPZsSmrvt7YT5ec4alQk
         BbegHt3uvTJ2KPdlaCOROsSSths1BFcwXoiJI36BPx8pQNRW3u/xmN12tMHcYUDvf6i1
         36/WLAtiYuI0Jv2JjsylSemnD9f1S2+2h7imQ2DcDcUcnv+8N2+UdHjMwwdOOrhciBkK
         Tpn2bK5iv2c5aaWJriZlqvh6Fxa5T4necAZytQzY5qKko8ZuS6Cs7S6WljQdWr2ITefv
         yoQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E8HC5KhjUlV41KsAAH26eBl3oXcWuvaOrNt60v4bxY0=;
        b=OsUHgBUq/2ezV/M3en+2pO+lxrO5WQMv+8Iuk3mAWT6ai9HQtkwlKWJbXcd0xFDVcC
         HnNuf4dVgqFqUhvSxjWjPB494ycYnj+zmvfT7CZYWixMqq9IAD7MgBN0WdiV23TxHA0G
         4utSXVHsSRNy8naTsj/W3YyBvXNGBKjo1VPou9NJ3dGgVaSxl0iebf2B5Cx9qn/CUHy9
         J5OCivs8Zs9ef+r5XL6IC1zZs8ptrkUDhAk3d7NHwU5qgMW+o2c7eTaO1Vh2Y762R/RR
         AnKRXUaB4yxGowYj5nUPUCYXqLvO8zRnF/TuQ9tw0jYhHKx8MzsW1DqHG9cWNACt0MaZ
         CJEg==
X-Gm-Message-State: AOAM532/lNg06BEhOZW4VzVp6eFMj8gMxnlI+WAyjVMtofwl6s5Cjoh+
        jOVrLIv2pl361YZymsPAt9U/MBlRLMA=
X-Google-Smtp-Source: ABdhPJw0X/yXTqy7uK6o1fGg2KjFOhZPsyVwTsz7rRc0h/CWcZzi2VpYHfToAVfUywkDOv99bl9JHw==
X-Received: by 2002:a63:4b53:: with SMTP id k19mr345448pgl.3.1628697707077;
        Wed, 11 Aug 2021 09:01:47 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:01:46 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v2 01/60] KVM: PPC: Book3S HV: Initialise vcpu MSR with MSR_ME
Date:   Thu, 12 Aug 2021 02:00:35 +1000
Message-Id: <20210811160134.904987-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

It is possible to create a VCPU without setting the MSR before running
it, which results in a warning in kvmhv_vcpu_entry_p9() that MSR_ME is
not set. This is pretty harmless because the MSR_ME bit is added to
HSRR1 before HRFID to guest, and a normal qemu guest doesn't hit it.

Initialise the vcpu MSR with MSR_ME set.

Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index ce7ff12cfc03..2afe7a95fc9c 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2687,6 +2687,7 @@ static int kvmppc_core_vcpu_create_hv(struct kvm_vcpu *vcpu)
 	spin_lock_init(&vcpu->arch.vpa_update_lock);
 	spin_lock_init(&vcpu->arch.tbacct_lock);
 	vcpu->arch.busy_preempt = TB_NIL;
+	vcpu->arch.shregs.msr = MSR_ME;
 	vcpu->arch.intr_msr = MSR_SF | MSR_ME;
 
 	/*
-- 
2.23.0

