Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697FB3E9541
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbhHKQCh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhHKQCh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:02:37 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C81C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:13 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d1so3307518pll.1
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DKq8DJSxGhBXzYj1xzUohFIXvPf01oJFRn8nuM9P7p4=;
        b=lma6aBQNpLAl+jS3h8+vESjIcKgyn9gViolaxPgZ+neVXaOq/Tm52zDzZq2zQCKK/M
         BhFYNFSZppyaXcvmgmr8ema84WlMud1Vmhua00bA+/tZDu+Sccfo+I/wzv/QbI9O1ZhG
         uLvg+uV77Ye4vtGFz21ji5RuAdM+bglisqYk7Ndft/EpNpdDbxZ87iDt0QIpsHZ/1qyM
         ggfbWhnyzedtE98zjQbOLYm1NvPmL2NP5IhAukaI3lF5ZCJufSSjfAGro6K05SXERAFy
         jaQvB3AhF11YfpFMuFhI6O/ngMhXqzkQpI+Gx/dTWYNWW0iwudusnbIUCCShxzY3YncM
         WfIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DKq8DJSxGhBXzYj1xzUohFIXvPf01oJFRn8nuM9P7p4=;
        b=GDKc5iX4GM9tFT48/ZMYMjj2Twe+JIg4P7rqNd55zjI3fQwju+qctsLWZk+vMIeFL7
         ou2qLXwKwDR9R1/HqwsO40ZmQSAFf7KzyZVSvwR7xNWtLQXURJaL5gINGEo7YC7O2XYF
         ndGvk8s7nTXv8JxqcaclSyWTAxNKeCDNVAWyPtweaq2pppxBzTjhA0fbhqM0G1ixXJbi
         2JUR2gRfmTIpVxuLrXMSueVhEeDomgiJ7SvpoDZdE3w1tloPOR7rZrsgSKcrUbrOZr6t
         u6BuIvtPg6f6zigeVFv5+MguEjE0CWbxb/vdFm4AGNLoeWJamRWq0vuB4xUqAubvrGoJ
         oUzQ==
X-Gm-Message-State: AOAM532rnViisJjKwY8NP7NQPN1cdom+QYNJCVEP7p9yvuUvl7SPVmy5
        99ca1cF7b0fWHX8pMtnGjNAbjiogW7k=
X-Google-Smtp-Source: ABdhPJycpQsCjxqz5RVJTlxfpp/h1mcxCPlbQ4A5gGw9kh5PMpEuxbaTy7hWJkJJGorXl329MBvphw==
X-Received: by 2002:a17:90a:1a51:: with SMTP id 17mr10940798pjl.59.1628697733000;
        Wed, 11 Aug 2021 09:02:13 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:02:12 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v2 11/60] KMV: PPC: Book3S HV P9: Use set_dec to set decrementer to host
Date:   Thu, 12 Aug 2021 02:00:45 +1000
Message-Id: <20210811160134.904987-12-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The host Linux timer code arms the decrementer with the value
'decrementers_next_tb - current_tb' using set_dec(), which stores
val - 1 on Book3S-64, which is not quite the same as what KVM does
to re-arm the host decrementer when exiting the guest.

This shouldn't be a significant change, but it makes the logic match
and avoids this small extra change being brought into the next patch.

Suggested-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 3198f79572d8..b60a70177507 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4049,7 +4049,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
 
-	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - mftb());
+	set_dec(local_paca->kvm_hstate.dec_expires - mftb());
 	/* We may have raced with new irq work */
 	if (test_irq_work_pending())
 		set_dec(1);
-- 
2.23.0

