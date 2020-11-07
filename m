Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A702AA2BA
	for <lists+kvm-ppc@lfdr.de>; Sat,  7 Nov 2020 07:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbgKGG03 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 7 Nov 2020 01:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727738AbgKGG03 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 7 Nov 2020 01:26:29 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6095C0613CF;
        Fri,  6 Nov 2020 22:26:29 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id c20so3739767pfr.8;
        Fri, 06 Nov 2020 22:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=C4lftI3jjKtV0YPJpfDM7T7PI8bPMBY4WAPtMXGKPTQ=;
        b=pbhFpHUj/V75ectClm9ghdNvCryoMyQfDPSQmx+Y4A6ihEx5NR8AqX2nA6s9RG4o2K
         7pues3/1m0otmnSw7QNHyfkThYO1Z94iv7W6BAMDm1YP7W3lBY+X1Z5fIeRgeK8MxU+2
         Dcba8hvxPTw+9b0LmYgvqQI+vOBSTaqvcY0nE8Es7TyNGHkxyTSxHGdJUGzCmyW8LqoC
         QDj9HszIZX6u8kAnMcXdA8UrFlTtdtAuZCiQ2G747WMQEp3Qk8EmpMWerDu7bX9KkX58
         tE3Ocqok2YnmPkbtIyYqE6hBblfmOPun0tLQQecxytmnzOYNCvehX2D5d9Np7gF5iZqX
         1C6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=C4lftI3jjKtV0YPJpfDM7T7PI8bPMBY4WAPtMXGKPTQ=;
        b=dYQ088BfM+gsTdEts+cUq1aBep9pB6wTEPOPsuygpstdcLDpqR+S7gf0by1znDa8PJ
         3tRl6f0pSgMqka2cy+Js3Uv203lVMpWufQrSIhyV6v+WT5QCrr5oKw5PEM1PxfCNMUQj
         xzpJHY68/vUFPaQvL867xvBqF8PXPwo0VV5j4i67ZeIIqnegstND5hHUE2MEuxAgSsGO
         qMM4BH0NZv4If5w7PpgCZU+1zIpaMtFELfhszlPZ4zZgQcIjvegQ046DDWHmXg/KPsxM
         8CybqmrLvjJC3l6ZcqTEfnD8HR7GNpZ5nOBsa13DbHaIhCm9UCR1SYu3sTbsFrXX10kZ
         SI/Q==
X-Gm-Message-State: AOAM5312RiGQeWmsUhqhei+h/RmtBfHr1nEH23GPGKoteRYTf7bPuWe9
        lIWs7VSI5ffmfMalAi3goCifko+FMf4OAb4=
X-Google-Smtp-Source: ABdhPJzsrhuSEE///ScJ3QwAorHPL91XbpaZNC9/mvUmP+XANlnyfOzlq6TsFfm4ijBHYFyvfc5SwQ==
X-Received: by 2002:aa7:80c9:0:b029:164:4ca1:fff with SMTP id a9-20020aa780c90000b02901644ca10fffmr5103575pfn.11.1604730389045;
        Fri, 06 Nov 2020 22:26:29 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id y124sm4039019pfy.28.2020.11.06.22.26.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Nov 2020 22:26:28 -0800 (PST)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     paulus@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] KVM: PPC: Book3S: Assign boolean values to a bool variable
Date:   Sat,  7 Nov 2020 14:26:22 +0800
Message-Id: <1604730382-5810-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Fix the following coccinelle warnings:

./arch/powerpc/kvm/book3s_xics.c:476:3-15: WARNING: Assignment of 0/1 to bool variable
./arch/powerpc/kvm/book3s_xics.c:504:3-15: WARNING: Assignment of 0/1 to bool variable

Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 arch/powerpc/kvm/book3s_xics.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_xics.c b/arch/powerpc/kvm/book3s_xics.c
index 5fee5a11550d..303e3cb096db 100644
--- a/arch/powerpc/kvm/book3s_xics.c
+++ b/arch/powerpc/kvm/book3s_xics.c
@@ -473,7 +473,7 @@ static void icp_deliver_irq(struct kvmppc_xics *xics, struct kvmppc_icp *icp,
 			arch_spin_unlock(&ics->lock);
 			local_irq_restore(flags);
 			new_irq = reject;
-			check_resend = 0;
+			check_resend = false;
 			goto again;
 		}
 	} else {
@@ -501,7 +501,7 @@ static void icp_deliver_irq(struct kvmppc_xics *xics, struct kvmppc_icp *icp,
 			state->resend = 0;
 			arch_spin_unlock(&ics->lock);
 			local_irq_restore(flags);
-			check_resend = 0;
+			check_resend = false;
 			goto again;
 		}
 	}
-- 
2.20.0

