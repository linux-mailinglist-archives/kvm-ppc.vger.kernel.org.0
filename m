Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263D52C722B
	for <lists+kvm-ppc@lfdr.de>; Sat, 28 Nov 2020 23:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732013AbgK1VuY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 28 Nov 2020 16:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732077AbgK1S5f (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 28 Nov 2020 13:57:35 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A1DC094255
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Nov 2020 23:07:58 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id y7so6346050pfq.11
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Nov 2020 23:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RE0535OC1P2LDrGbQpaiLP7+snTRDOWBeWRNCwF421I=;
        b=kEPVVXvMUZrllW5PL0LlJocK8K5CopAhZfRJ6p2/m2QB6OvRj8LpBWdJbWR/doJ1PE
         AiG6z1pXlsOilXe1QIujaPWqKyg4a0WFD4TMqGmAjraTti5iJk8pPPIO7wxtzE2OAn3T
         S2RXVYzTeV+S3FuO3hXqRcgaxgTcAXFLo8BCfq8MfVYZfoWnxk8qlFDhi97rw9I94F6/
         fwed2CAY4WmHM8L0+NQJO4TeAz8rn30DRsWEC7JCjeGbu0qJY+Ij2LVYekiIo5BAj+/3
         aa5yVKxdd2zYzvanYOD39bvSBgVu/KwbPOpHYLsFCcfZ3uh/WcT6IzW7gkfqCnm0HNQA
         6I7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RE0535OC1P2LDrGbQpaiLP7+snTRDOWBeWRNCwF421I=;
        b=N/bZPIyVgp1L1wVq1W/I4o2iLE1FMq1DG7+Dnx+IhSvZ8xnRwWDQ5JP43Olh14Fsex
         MXv7hhj9bsSzjoAnkd1F2L4b1xWdl7/ia1JOheae1g2AjwgSuD/FWJc7/JY3b218vBcv
         z2ASXLJfmXzPH1UeTxO55oS1EYSfD12pGcIFCigunQ3QRZBgx4NS6k6nEFpSkxieJ113
         Ns6sHgROa1cttazXa9pWErwVi5zHBsF9SZlxFPEw1XfLFHzBZ02aqbAS8gRAKzA8ABdN
         q9TzjfV+RrEyGJV/5CjM53mL9L+dEBZ46g0u63Eq1EgCHyoAkhxfNpQ0NOH497aKFgoL
         y73g==
X-Gm-Message-State: AOAM533sDHZMZ5oXfaqwD9YHvfNu9cD4Wlw124m0RjlolpGqxoP59vvI
        0CxBJDQ1CfXrL6HAzBjOLsI=
X-Google-Smtp-Source: ABdhPJz6JT2bUHFa0tJ4DVKSilozsNR3sInaVbpeaGJV/XSotUNLKJTDD2QeZs+MbOXEf88qsOjUPg==
X-Received: by 2002:a17:90a:f485:: with SMTP id bx5mr15072182pjb.190.1606547278505;
        Fri, 27 Nov 2020 23:07:58 -0800 (PST)
Received: from bobo.ibm.com (193-116-103-132.tpgi.com.au. [193.116.103.132])
        by smtp.gmail.com with ESMTPSA id e31sm9087329pgb.16.2020.11.27.23.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 23:07:58 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org,
        Mahesh Salgaonkar <mahesh@linux.ibm.com>
Subject: [PATCH 7/8] powerpc/64s: Remove "Host" from MCE logging
Date:   Sat, 28 Nov 2020 17:07:27 +1000
Message-Id: <20201128070728.825934-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201128070728.825934-1-npiggin@gmail.com>
References: <20201128070728.825934-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

"Host" caused machine check is printed when the kernel sees a MCE
hit in this kernel or userspace, and "Guest" if it hit one of its
guests. This is confusing when a guest kernel handles a hypervisor-
delivered MCE, it also prints "Host".

Just remove "Host". "Guest" is adequate to make the distinction.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/mce.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/mce.c b/arch/powerpc/kernel/mce.c
index 8afe8d37b983..9f3e133b57b7 100644
--- a/arch/powerpc/kernel/mce.c
+++ b/arch/powerpc/kernel/mce.c
@@ -555,7 +555,7 @@ void machine_check_print_event_info(struct machine_check_event *evt,
 	}
 
 	printk("%sMCE: CPU%d: machine check (%s) %s %s %s %s[%s]\n",
-		level, evt->cpu, sevstr, in_guest ? "Guest" : "Host",
+		level, evt->cpu, sevstr, in_guest ? "Guest" : "",
 		err_type, subtype, dar_str,
 		evt->disposition == MCE_DISPOSITION_RECOVERED ?
 		"Recovered" : "Not recovered");
-- 
2.23.0

