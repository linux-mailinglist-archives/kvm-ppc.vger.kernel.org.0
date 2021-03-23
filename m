Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0559E345483
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhCWBEv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbhCWBEc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:04:32 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6420AC061762
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:31 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso9391489pjb.4
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wnGO8xVitDb3sZlW1fnEu9cbFCdMiIUqXAxi4DxQqcE=;
        b=IfMVxfC5TUUKvoa+98PhuQkakBklyxWExpsMmTKLIVEH5ApXWj7xWEGyw8XDzYjqpA
         f7OwirFOz9Cs8irOyrSdBQ3EJs+KyvbBzqeGPLC57nZUgPylI+c824Bv5vpawstX5H65
         N7XsMEY14J69MDaBLV5apJidS1LfCJl9YY3KvBtz9dCB4Z+bX5AkoigyhZh38fML8xk1
         K/OmRCgCxIXE4FSVrZjCTBSSVQPuf15O/acHbin1UpWGPuLx2T5Q7elBK9tKUbQ6QuRF
         ixoiw7QhvlsTvmruH2NY31m56KRjQz4aKIdOWkYTeeUvzZPDKdVPtXGx5YbcDUsJhFLv
         7VOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wnGO8xVitDb3sZlW1fnEu9cbFCdMiIUqXAxi4DxQqcE=;
        b=moYhvKz+nOkAqqyRN7ILbPx/dEGyX8DJC2WeEBfyq+nGI5EECLCw36q/2P+OcORl89
         eF/jqplewvk6O/pwndDZnPItLajD3+CHul+NWvZMVkWx8fx2W1qIOOpIRHGNnYlmEzbF
         OnZRLNjDMVAR5br9oGMnFlY3N4ddEzkpS8GC1d/aUX7YgW8KlHSSZASqejKlU4Be5Yra
         7D1yxeGqTv4IC2n4zJORAiQ/pGOO1G60T1gM+47MhvD4m7kWX1WwSOUcKF88g3s4Vf5n
         jYSug+ufgk8ZC5SttmFRrkbs4gAbA7dc/cLEVU1QME17SGCqfiz//ubFd6kEHd5ki0sE
         Y9Tg==
X-Gm-Message-State: AOAM532NRly6vDlCMgwmJ7OsuEnRBXDxD0BPImhdlWyNnyFsoZ19Sa7Q
        HjMsjKBVEtnxoTbOr2RGoeYpgiy0ByE=
X-Google-Smtp-Source: ABdhPJwWxMXVrBMUiFwhDtZgryG8fMnzrxe6dwx7W5KFvJC+S847hqeoueuHrO5pOte0vOhS12L1HQ==
X-Received: by 2002:a17:90a:5284:: with SMTP id w4mr1697194pjh.29.1616461470914;
        Mon, 22 Mar 2021 18:04:30 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:04:30 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v4 24/46] KVM: PPC: Book3S HV P9: Use large decrementer for HDEC
Date:   Tue, 23 Mar 2021 11:02:43 +1000
Message-Id: <20210323010305.1045293-25-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On processors that don't suppress the HDEC exceptions when LPCR[HDICE]=0,
this could help reduce needless guest exits due to leftover exceptions on
entering the guest.

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/time.h | 2 ++
 arch/powerpc/kvm/book3s_hv.c    | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index 8dd3cdb25338..68d94711811e 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -18,6 +18,8 @@
 #include <asm/vdso/timebase.h>
 
 /* time.c */
+extern u64 decrementer_max;
+
 extern unsigned long tb_ticks_per_jiffy;
 extern unsigned long tb_ticks_per_usec;
 extern unsigned long tb_ticks_per_sec;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 8215430e6d5e..bb30c5ab53d1 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3658,7 +3658,8 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 		vc->tb_offset_applied = 0;
 	}
 
-	mtspr(SPRN_HDEC, 0x7fffffff);
+	/* HDEC must be at least as large as DEC, so decrementer_max fits */
+	mtspr(SPRN_HDEC, decrementer_max);
 
 	switch_mmu_to_host_radix(kvm, host_pidr);
 
-- 
2.23.0

