Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B68723B01F1
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhFVLAS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhFVLAS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:00:18 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA204C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:01 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id t13so4953906pgu.11
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iddhQBveGl5GMDnvF6dAQD+fqfJW5WKS3bJd2eWY3p8=;
        b=JYGIHwvIcA3Vp1Z971XQwzD37vNZp521vekR0rBE7WPnri7kxzyjbafXsPgZMEJjPK
         Z8Q8m0Uv3af0nvRFsADRt5IafS/yhiB36PqufDCnPvBhFi0BQIWVmt6zNT3TR8/MiYwN
         swR3SULzwgXvWN0kKy85TFfM51uG5FY1xHvZWoBwJVkqKuKEiRYN+rTw1sxz6IeAg9Qe
         d5ZoYcFKpDilUCAiXBveNHXMt75XhAS+ZtBBHHWAI5vMJ4JOA51gPKUgjAH0RANp2nsB
         3CUE0gNiu9wPszFWLWNRgnLFo2D6OlNqQu0/yzGbcPUudR59LGWFU2TSeaRaujUJ1hEY
         bvuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iddhQBveGl5GMDnvF6dAQD+fqfJW5WKS3bJd2eWY3p8=;
        b=S3NdnyCTeOY7aFk4KV/RBFgUZtv33eFwwgFyQvSQ9t0b2MpMZJgzoBOJHPQ14LSvC0
         Tir99W9uxalOMS+O5HXgRGeQsHNNnNkQ+bWXtrUDgC9KXteLtpVhAYUpDp0VJ1CUFh7D
         T1d5GuMWJJnH8N7uOUNwsrn4O1M+M6hqjlkohgOU1VUN6Cgn45rQDxNRkGJB69jCvRrx
         ImFUGAR+7Mb2i13Rmm3/ywds6063FFpxafN/aXKc5tfSnR1yYSyCOXkBfUsXb07eD2IP
         DaTkL2EV+OMlDK9I2dLeNsoyHHAhjm6yNhAH+5zdaEC7EvVlvs2fUK5QzrOIIpeVtnCj
         xtIA==
X-Gm-Message-State: AOAM533I7MF3iPCzLobgJAkJ2FebyrEdIkMjfDjE5w6169ttsfOt1jbO
        zklU8uyVPplHlrXObyPfCUMsKJd6bJw=
X-Google-Smtp-Source: ABdhPJwh0OlsptuYnAUfsQYgL8AFiiAVQnUuIpUMie2bSbbSLcWCTZFeKXn3rxMUGQEHOEWO35SjZA==
X-Received: by 2002:a62:62c2:0:b029:2fb:af56:f1c5 with SMTP id w185-20020a6262c20000b02902fbaf56f1c5mr3158491pfb.30.1624359481470;
        Tue, 22 Jun 2021 03:58:01 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:58:01 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [RFC PATCH 02/43] KMV: PPC: Book3S HV P9: Use set_dec to set decrementer to host
Date:   Tue, 22 Jun 2021 20:56:55 +1000
Message-Id: <20210622105736.633352-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
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
index 97f3d6d54b61..d19b4ae01642 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3914,7 +3914,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
 
-	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - mftb());
+	set_dec(local_paca->kvm_hstate.dec_expires - mftb());
 	/* We may have raced with new irq work */
 	if (test_irq_work_pending())
 		set_dec(1);
-- 
2.23.0

