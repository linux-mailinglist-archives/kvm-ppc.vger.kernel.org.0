Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2B95DAA4
	for <lists+kvm-ppc@lfdr.de>; Wed,  3 Jul 2019 03:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfGCBUi (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 2 Jul 2019 21:20:38 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42406 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGCBUi (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 2 Jul 2019 21:20:38 -0400
Received: by mail-pl1-f195.google.com with SMTP id ay6so239441plb.9
        for <kvm-ppc@vger.kernel.org>; Tue, 02 Jul 2019 18:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OT+iSlP7qQxjao2KtTY/wuAA4aL+nqDFMX6/v/uNdu4=;
        b=eE9NuW60m15qwsjWlt+lK0mLNp+ZuO3yidTHutB9QGlwHs815nBPtwK3wKBDLwWOGd
         Txaa5TVWA64GJHXRg65hvqw14cbZhnm0035A4Vq4XU5pbjM/YYmEBPrzaPnHIARjzHn2
         fVilXLh/wJYHl/Zao7bK3hqeSywIeWQJ+CDu0tIM295inos+mE8DuNzyZm4kZ0R3oeFi
         D2961o3zGGlef3sNPnvL/x0B46zGnfYJ/kr3C7nHBCj1kmc6nEFhHdBY+JMGHu9owJSB
         N8/pwgcCVBRsZyt3RZwqZq/zEDun9qKdgKigNJt0nv58nVsaCyQSyp3mkMe0bfP2POFw
         Zp0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OT+iSlP7qQxjao2KtTY/wuAA4aL+nqDFMX6/v/uNdu4=;
        b=t/+5gXVASonD+dn4y7EJYwxDmYqA/V3xeq+iHDviuqU70kbGeTOjV2DQW61ZBaF432
         ZylRQVjMB2EX28HAxsXFvvRDlTxB1g1MHdOzkYvzPmJWxGXSoN9fD2lC7Y0eJsQZ1L14
         2ipa+Zxy4aYaSWl0qoA9i8Ss9o/UDcT+CEj5/4Pk1vic/jVrtLuPZKD0UAd0eYoc19rX
         IDTTmDVbjNsu8RT+DCyc+4m+7SmQ62QBJ+Fho4PdTujxLO4BbZsOOQeOm5eMk/RahOST
         fkkXtfwa59YpQzWd4NiQ2thnpBIIrSxkjrZW/dKio8Y0WHLnABhS9NSosIOBEKes43GJ
         UOGQ==
X-Gm-Message-State: APjAAAWF+a9ckZ5d/IYRemLNOO29KZhd1TI6+qbz9EPbpQN2nQl2Jovm
        T5lSU9Z6dZv+izPtdOL+4hg=
X-Google-Smtp-Source: APXvYqxICivvyS9zvkcXp4qDw3wHK9lxCyuN+p62quvHg5No7Hz1ZHyE+PQInv9p7TP3BKnA+kzhSA==
X-Received: by 2002:a17:902:8d92:: with SMTP id v18mr39141154plo.211.1562116837371;
        Tue, 02 Jul 2019 18:20:37 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id j11sm318058pfa.2.2019.07.02.18.20.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Jul 2019 18:20:36 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mpe@ellerman.id.au, paulus@ozlabs.org,
        sjitindarsingh@gmail.com
Subject: [PATCH 2/3] PPC: PMC: Set pmcregs_in_use in paca when running as LPAR
Date:   Wed,  3 Jul 2019 11:20:21 +1000
Message-Id: <20190703012022.15644-2-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190703012022.15644-1-sjitindarsingh@gmail.com>
References: <20190703012022.15644-1-sjitindarsingh@gmail.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The ability to run nested guests under KVM means that a guest can also
act as a hypervisor for it's own nested guest. Currently
ppc_set_pmu_inuse() assumes that either FW_FEATURE_LPAR is set,
indicating a guest environment, and so sets the pmcregs_in_use flag in
the lppaca, or that it isn't set, indicating a hypervisor environment,
and so sets the pmcregs_in_use flag in the paca.

The pmcregs_in_use flag in the lppaca is used to communicate this
information to a hypervisor and so must be set in a guest environment.
The pmcregs_in_use flag in the paca is used by KVM code to determine
whether the host state of the performance monitoring unit (PMU) must be
saved and restored when running a guest.

Thus when a guest also acts as a hypervisor it must set this bit in both
places since it needs to ensure both that the real hypervisor saves it's
pmu registers when it runs (requires pmcregs_in_use flag in lppaca), and
that it saves it's own pmu registers when running a nested guest
(requires pmcregs_in_use flag in paca).

Modify ppc_set_pmu_inuse() so that the pmcregs_in_use bit is set in both
the lppaca and the paca when a guest (LPAR) is running with the
capability of running it's own guests (CONFIG_KVM_BOOK3S_HV_POSSIBLE).

Fixes: 95a6432ce903 "KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests"

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/include/asm/pmc.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/pmc.h b/arch/powerpc/include/asm/pmc.h
index dc9a1ca70edf..c6bbe9778d3c 100644
--- a/arch/powerpc/include/asm/pmc.h
+++ b/arch/powerpc/include/asm/pmc.h
@@ -27,11 +27,10 @@ static inline void ppc_set_pmu_inuse(int inuse)
 #ifdef CONFIG_PPC_PSERIES
 		get_lppaca()->pmcregs_in_use = inuse;
 #endif
-	} else {
+	}
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
-		get_paca()->pmcregs_in_use = inuse;
+	get_paca()->pmcregs_in_use = inuse;
 #endif
-	}
 #endif
 }
 
-- 
2.13.6

