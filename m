Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C86F2C721E
	for <lists+kvm-ppc@lfdr.de>; Sat, 28 Nov 2020 23:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389947AbgK1Vu0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 28 Nov 2020 16:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733135AbgK1TFf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 28 Nov 2020 14:05:35 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7459C094253
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Nov 2020 23:07:52 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id w4so5987944pgg.13
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Nov 2020 23:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4hsbV9WTjMt7nZtZJaSJ1Z2j4r46XROS78uy2HuICb8=;
        b=LRGZCBGaSS0w37y+qBkTudJGUdXhwbeixTJMVO0+ofjtdeBbmI/3FRlEkjAgdKsvuO
         r7WDtIRJdhTwoVFmg9xeRDsFhoc+ryMR6zbMh3UuO88llTXZ3VFo5aum4GiM8xx7uTN7
         JIhFsDj9Pm7w8BxZHb4J3nNe+MT53k09goapKBTZi84SwbPCzDlJ58uC0VAzIeKhT88J
         h3tu41aS+4uY8EWSGXaZNzwrzxWe2gl317T5yXpI/pzOrAuC8+FSu/iJ2t6s8tEBEOAp
         8/uLoiC4AHbzfJc2vpZUozefZj34jKANawQXNfMNh1eJVJi2yVz4UKe9X+vnaMRp3JXn
         jkBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4hsbV9WTjMt7nZtZJaSJ1Z2j4r46XROS78uy2HuICb8=;
        b=tmQ6CKfxjgfXlQ3d3McetMnl1tcRNZuuD+hQikE/CY+/EB8TpXrB4R2fcxYpCKW0pV
         j79dU+TdqctDtRfEb8FAIG71STnbK3/FWDArvspy3Swjn4szo6/jUsdcOV2YUu+k980t
         KDAKClJKu4XOVHSLtpOt+5sJh32+PqxFClNhUNkCQ3XHYiItHfz2OoiWd3D3KqS0Q4mE
         FIsvcDj2PgxPOaFLkRqsJsUt/qttXaOjlTIEaY7PEC81S/3NspqAp71AwdMgQmHAhvMj
         gTKxWjeMe6jph7luxNo2BNt2HRbbAi+/3og+1Q+k1BV6EPICBEczoI3V56aF89us35Fj
         qwKQ==
X-Gm-Message-State: AOAM533j+806hZkQdhSj+yFzMoeUyTEm0hRtv+miZydRdh3nOF7XWnS1
        BcJjwgYltjWFkCZWAFwoIjY=
X-Google-Smtp-Source: ABdhPJzaGShDY2Gq4eORt0NVOarw+k6MNYM36qhjKb9ZBYvKwpnUsV+/FcTpf/+hi1XAcRKwlSs+TQ==
X-Received: by 2002:a63:83:: with SMTP id 125mr9782638pga.423.1606547272372;
        Fri, 27 Nov 2020 23:07:52 -0800 (PST)
Received: from bobo.ibm.com (193-116-103-132.tpgi.com.au. [193.116.103.132])
        by smtp.gmail.com with ESMTPSA id e31sm9087329pgb.16.2020.11.27.23.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 23:07:52 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org,
        Mahesh Salgaonkar <mahesh@linux.ibm.com>
Subject: [PATCH 5/8] powerpc/64s/powernv: ratelimit harmless HMI error printing
Date:   Sat, 28 Nov 2020 17:07:25 +1000
Message-Id: <20201128070728.825934-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201128070728.825934-1-npiggin@gmail.com>
References: <20201128070728.825934-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Harmless HMI errors can be triggered by guests in some cases, and don't
contain much useful information anyway. Ratelimit these to avoid
flooding the console/logs.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/platforms/powernv/opal-hmi.c | 27 +++++++++++++----------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/opal-hmi.c b/arch/powerpc/platforms/powernv/opal-hmi.c
index 3e1f064a18db..959da6df0227 100644
--- a/arch/powerpc/platforms/powernv/opal-hmi.c
+++ b/arch/powerpc/platforms/powernv/opal-hmi.c
@@ -240,19 +240,22 @@ static void print_hmi_event_info(struct OpalHMIEvent *hmi_evt)
 		break;
 	}
 
-	printk("%s%s Hypervisor Maintenance interrupt [%s]\n",
-		level, sevstr,
-		hmi_evt->disposition == OpalHMI_DISPOSITION_RECOVERED ?
-		"Recovered" : "Not recovered");
-	error_info = hmi_evt->type < ARRAY_SIZE(hmi_error_types) ?
-			hmi_error_types[hmi_evt->type]
-			: "Unknown";
-	printk("%s Error detail: %s\n", level, error_info);
-	printk("%s	HMER: %016llx\n", level, be64_to_cpu(hmi_evt->hmer));
-	if ((hmi_evt->type == OpalHMI_ERROR_TFAC) ||
-		(hmi_evt->type == OpalHMI_ERROR_TFMR_PARITY))
-		printk("%s	TFMR: %016llx\n", level,
+	if (hmi_evt->severity != OpalHMI_SEV_NO_ERROR || printk_ratelimit()) {
+		printk("%s%s Hypervisor Maintenance interrupt [%s]\n",
+			level, sevstr,
+			hmi_evt->disposition == OpalHMI_DISPOSITION_RECOVERED ?
+			"Recovered" : "Not recovered");
+		error_info = hmi_evt->type < ARRAY_SIZE(hmi_error_types) ?
+				hmi_error_types[hmi_evt->type]
+				: "Unknown";
+		printk("%s Error detail: %s\n", level, error_info);
+		printk("%s	HMER: %016llx\n", level,
+					be64_to_cpu(hmi_evt->hmer));
+		if ((hmi_evt->type == OpalHMI_ERROR_TFAC) ||
+			(hmi_evt->type == OpalHMI_ERROR_TFMR_PARITY))
+			printk("%s	TFMR: %016llx\n", level,
 						be64_to_cpu(hmi_evt->tfmr));
+	}
 
 	if (hmi_evt->version < OpalHMIEvt_V2)
 		return;
-- 
2.23.0

