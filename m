Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2F219EA1C
	for <lists+kvm-ppc@lfdr.de>; Sun,  5 Apr 2020 11:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgDEJKr (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 5 Apr 2020 05:10:47 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38153 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbgDEJKr (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 5 Apr 2020 05:10:47 -0400
Received: by mail-pl1-f195.google.com with SMTP id w3so4686920plz.5;
        Sun, 05 Apr 2020 02:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mnpDuNSJf4idjQMWn0+0VKn4i4vrRg7dKql4TPPMlww=;
        b=asQpikoMB82WzIe7GCp4O0VKa70l4WeL+s/v9JvBYQaJWfpC4mJWFGdAEXW7zu6igJ
         mD6Os/OfXnCRrVHiNtnfLuS9Dykz6Z9rHgNa8hl/PyErwapnwyGDHcNGXS2bJICl4LS8
         7lTu/QMA7LIatT2XBk04vAcCndyCfSodER7nvq2idhslZskq0q4nncpthYcIELGDxlvd
         hxI+FP74xm4xnRLGnk0c6r9TmbmnJkeyRl8Ui8isozExNmjl62+ft9fonIFdqK8yWldH
         gbu6kUlxoLHGozZLjsMiz/GuMKHkKvX1f6xqzTzVSRTxArhOotCBq2ACE7aNK00wxL6L
         3j6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mnpDuNSJf4idjQMWn0+0VKn4i4vrRg7dKql4TPPMlww=;
        b=kINcCz3UcQgV6QK089x7+dH3xKvm+sCJ3WBBns426SDpaYXfSlrs0rRtmeaOLvr93Z
         b8ZyAQXVAsL6r1lEfeCNSUvnlwAdhcVzA358Z+K82a0Ug8cxibG+uoXouHLpMB/a6Aig
         SnC2uLYpOWAw86323IPOzozM0cLE9prBbpnevYdDEGIMgZ7+dZubSf8lMLdfF+4ScepM
         XOhffQKqBcgOMVjwurbnbwsj6YP0sTaruJHb6MswYLTIUkxH8I4Cy82slO0eXxia1xIx
         0XLvqX/xu/tZURTeJMx+hAI7BgYv62ubv2cdfl/TdENoaESdllHfLQuCjq+Q8JyzFNB6
         RDqw==
X-Gm-Message-State: AGi0PuY/CQWlqfzG36NJkX+hC9eBMLkiYnHieCleUw4nzzIUD1yIlWh5
        mbBrB2/onLX2zJZPqIij3n4=
X-Google-Smtp-Source: APiQypLWzVuUDtIGQ8G2eOA23S2vzFYjQ4vp/WxwKYnPXILzs4mehmugr4FB+E2gNti3ySSEdBZvtQ==
X-Received: by 2002:a17:902:ee53:: with SMTP id 19mr15486190plo.173.1586077844496;
        Sun, 05 Apr 2020 02:10:44 -0700 (PDT)
Received: from localhost (n112120135125.netvigator.com. [112.120.135.125])
        by smtp.gmail.com with ESMTPSA id t27sm411518pgn.53.2020.04.05.02.10.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 05 Apr 2020 02:10:44 -0700 (PDT)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH] KVM: PPC: Book3S HV: Remove NULL check before kfree
Date:   Sun,  5 Apr 2020 17:10:38 +0800
Message-Id: <20200405091038.29822-1-hqjagain@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

NULL check before kfree is unnecessary, so remove it.

This issue was detected by using the Coccinelle software.

Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_nested.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index dc97e5be76f6..cad324312040 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -1416,8 +1416,7 @@ static long int __kvmhv_nested_page_fault(struct kvm_run *run,
 	rmapp = &memslot->arch.rmap[gfn - memslot->base_gfn];
 	ret = kvmppc_create_pte(kvm, gp->shadow_pgtable, pte, n_gpa, level,
 				mmu_seq, gp->shadow_lpid, rmapp, &n_rmap);
-	if (n_rmap)
-		kfree(n_rmap);
+	kfree(n_rmap);
 	if (ret == -EAGAIN)
 		ret = RESUME_GUEST;	/* Let the guest try again */
 
-- 
2.17.1

