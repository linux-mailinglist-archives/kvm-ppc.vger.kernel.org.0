Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D50345486
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhCWBEw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbhCWBEh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:04:37 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4AFC061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:36 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so9408013pjv.1
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aS79WqcCihfONt9Rv6M8EC39yeudySssdM2xa8KPEFw=;
        b=I89KPln9q/1DT1IRXUIa+aSNrejoOM8vyZGox4SbR0cXapKasygle64lqtWZE5Ejmh
         OabwJcTUxvBPj1pklCMvsKxCMwdC+x2AfDPwBiotSk6AYL1xlCuV86rYVBAguS1dmhx0
         aaoL9iVsox4SLxJhDqc9oHYTcC1MzS3V7t/tkmkSjiMYtUNsN74n4LpMnToLRyTsjhUG
         LAhE/w1BytArOeTh8hlOwrDxnGsKTYbpCF7Gqc7ujt56UFfMkBGSbdMKtvFdObNfJ4Vi
         8mhhj1+GJcBw5ijVmwJrP5kB6vu0qTGZTYz9uYJor3esIKQZFfhRQqvvX/eJgrQUyXb7
         OeSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aS79WqcCihfONt9Rv6M8EC39yeudySssdM2xa8KPEFw=;
        b=Rsd9tiVUXNsqCjnm3d96qNoioxNex5LhEDeMhOZUegYDYKVaGK4B7kMhqRX65OLiB1
         Xa8JZq0aQvKdJvgq5B/MbaKfJZxmtTcIlp1ntD147pzaiK5AidEWTLuaJ6LQigLA5Hg0
         aO+t3TZPCh8Nj2+iGVmT0mMubPopATYi3yBi8Mp1ppkB84pg9uXguCQid7MNLQPy4z3e
         ZNZNjkIP+/nSMDFjM5nL8q4hll8cwzhhAOx2ibUh7+Jk0XhwiFvH43GzK4JlutW0jLul
         KEVhYTxPP5lmL5VHWHTEJ9hIYppUABW5uvvvQBBqUYNAfezcspLuqc4S6n+lBVWWrzhj
         xz+w==
X-Gm-Message-State: AOAM532FLJY+1eBezDhKMEJysSN079Oa5YXS0YJayYXhPeenR8CJGHRH
        Fksb520xvaekcPth7Z3Mb3AZSfbxtuQ=
X-Google-Smtp-Source: ABdhPJzfFNIuxjTs/RynVEa0UYHIxWTj3OjTJO6BziTB2XjQzZUErW7lb+7sWaIh3Gy/rT8vAVURmA==
X-Received: by 2002:a17:90b:344c:: with SMTP id lj12mr1814326pjb.208.1616461476066;
        Mon, 22 Mar 2021 18:04:36 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:04:35 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v4 26/46] KVM: PPC: Book3S HV P9: Reduce mftb per guest entry/exit
Date:   Tue, 23 Mar 2021 11:02:45 +1000
Message-Id: <20210323010305.1045293-27-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

mftb is serialising (dispatch next-to-complete) so it is heavy weight
for a mfspr. Avoid reading it multiple times in the entry or exit paths.
A small number of cycles delay to timers is tolerable.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index db807eebb3bd..1f38a0abc611 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3540,12 +3540,13 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 		host_dawrx1 = mfspr(SPRN_DAWRX1);
 	}
 
-	hdec = time_limit - mftb();
+	tb = mftb();
+	hdec = time_limit - tb;
 	if (hdec < 0)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
 
 	if (vc->tb_offset) {
-		u64 new_tb = mftb() + vc->tb_offset;
+		u64 new_tb = tb + vc->tb_offset;
 		mtspr(SPRN_TBU40, new_tb);
 		tb = mftb();
 		if ((tb & 0xffffff) < (new_tb & 0xffffff))
@@ -3744,7 +3745,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (!(vcpu->arch.ctrl & 1))
 		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
 
-	mtspr(SPRN_DEC, vcpu->arch.dec_expires - mftb());
+	mtspr(SPRN_DEC, vcpu->arch.dec_expires - tb);
 
 	if (kvmhv_on_pseries()) {
 		/*
@@ -3878,7 +3879,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
 
-	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - mftb());
+	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - tb);
 	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
 
 	kvmhv_load_host_pmu();
-- 
2.23.0

