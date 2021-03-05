Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9745A32EDD9
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhCEPIN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbhCEPHu (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:07:50 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E3FC061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:07:50 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id kx1so2030230pjb.3
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7TPF87YTW7YGVHVLwo0wUO5dl3wgobw0Nak1TU/F9P8=;
        b=Em3psAKrIqQlU3lDAGlNM8gM51JXHrhyy4bTjQAI5Ood4ot+gIwtBM0hL2ANv4Vcc7
         h1UtiBZgdlEOxLHW+TSgH2wo2yrhhA9MkKCH59oR2DKmnOl/nTciSSqf7T6Z5IvVcFG4
         gbOEsf4uoDfVD1mRUKA9rePvKxXPP34194isKc/PJzmkO5DrKToMaa/YJm6Wl8FQA/kC
         hwH8xWKjKVNB9ebLoNTk1D2fFU2eNebu2jcCF7AMi+sJAsmErdBLDrN9ROW+q2taR3An
         9DFzLsNMgXK4q5KjX34u+6rau0DlsJtRDB/FBQxbHieKVUIPUk07IyZ+r8g9Tl7OhtFY
         yWsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7TPF87YTW7YGVHVLwo0wUO5dl3wgobw0Nak1TU/F9P8=;
        b=AS7g6aWsa/Hbj2rKNct2hKhl80Uhyf3mYxiWzEAUru85rFzr9t3x10any/2pO7kbju
         b0WG2IzZB7dGHc7NYr9i08UtYfw50P5oXuYrcdxjI040Zr2Qf+t7P+I/IZeex9p/tdiC
         /jvmOjNxNlZwxd1RIWg1/69DEnkDvQM01idv7eMov7RR820Nha0I63z54mgppwIBKZuh
         XudeF7qj+X/lejBruCbwkhIJKs5GaVlvsLOGfixecljkRChq4khSsvubCNRLEC2gs4Yp
         5IMYbZ9l1KeJE8htg5TQjtjlN71Oifz4dXYiw2XSucs7zKduYiBLWnjxCV7LpmW+2qqa
         /LAw==
X-Gm-Message-State: AOAM531e0DkBkpAbfZaRQZ4efuZKr47HJKNTaQ4mWbqv6eE3tmvriTFj
        6wmQehak0OGnV3kYR1CR0A6h5feNYdg=
X-Google-Smtp-Source: ABdhPJz+chvdDAoKuwF3H4QkCEEIbKUSDW2p6SFR3qX8M48pWTcQEadUhR9Ys1/imbjV4A8Q5yp5dQ==
X-Received: by 2002:a17:90a:e614:: with SMTP id j20mr10506464pjy.184.1614956868920;
        Fri, 05 Mar 2021 07:07:48 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:07:48 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 18/41] KVM: PPC: Book3S HV P9: Move xive vcpu context management into kvmhv_p9_guest_entry
Date:   Sat,  6 Mar 2021 01:06:15 +1000
Message-Id: <20210305150638.2675513-19-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Move the xive management up so the low level register switching can be
pushed further down in a later patch. XIVE MMIO CI operations can run in
higher level code with machine checks, tracing, etc., available.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index b265522fc467..497f216ad724 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3558,15 +3558,11 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
 
-	kvmppc_xive_push_vcpu(vcpu);
-
 	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
 	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
 
 	trap = __kvmhv_vcpu_entry_p9(vcpu);
 
-	kvmppc_xive_pull_vcpu(vcpu);
-
 	/* Advance host PURR/SPURR by the amount used by guest */
 	purr = mfspr(SPRN_PURR);
 	spurr = mfspr(SPRN_SPURR);
@@ -3749,7 +3745,10 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			trap = 0;
 		}
 	} else {
+		kvmppc_xive_push_vcpu(vcpu);
 		trap = kvmhv_load_hv_regs_and_go(vcpu, time_limit, lpcr);
+		kvmppc_xive_pull_vcpu(vcpu);
+
 	}
 
 	vcpu->arch.slb_max = 0;
-- 
2.23.0

