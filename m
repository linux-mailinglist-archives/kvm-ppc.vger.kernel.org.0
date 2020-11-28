Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6F92C7237
	for <lists+kvm-ppc@lfdr.de>; Sat, 28 Nov 2020 23:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733076AbgK1VuX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 28 Nov 2020 16:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731477AbgK1Sw6 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 28 Nov 2020 13:52:58 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF67C094256
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Nov 2020 23:08:01 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id t21so6023596pgl.3
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Nov 2020 23:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qAGXGhZOkIdFFBO04RIdpG9EnNWWB0bGWD/He/uQeSM=;
        b=dxuJANHv9DbG/4V/byjc0cuJwNoQCGJeyHowxFT8FN67M0jXr/b6cJzxr9rEFPrmOz
         HxFEA55Cn8becjEnNzqMfu8Ven8hzKuxrPFe6pyTfIYkYMelduCrLgkywlTMO4if7sEw
         DlsvSf62i1IvDwUOovgUSVGcaec1Ig3ztuLiaeUq8uoRaRfvNyaUGDtr9wFShhgNfkn3
         vARwC4NVbA9CejtOhV36joH/1FGW0q/eKrgM7/5N1C5uMcPrAdaYpv+vt9aBzlJZYtDj
         IWGGX0PhrRXPMAVWpZd40+kS25aNo8pWpjlgUzwnQP4gCN4X4LzZxyoERvTWWofatn6r
         FGLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qAGXGhZOkIdFFBO04RIdpG9EnNWWB0bGWD/He/uQeSM=;
        b=jpqGhTB77r/1nlXRNYgmG7PHriJoN3u1R3bCrK6QvDfG270Bgw8O6O3Nm5vp+fzE/o
         a2dHS5OU24Eb4L8waqx56Zef7la2ApmWU5UGnw01mPJfWLnfwO2j6xE4FszHonYaX1Xs
         sqyRYVx93vXDDSmKH2Paqo1rZZNItWWLFptLZnydVSwD9pKMgP1qvZReOWMtI6iHFWlz
         3Rx+rYAIj2O5k3+XO+iE4p/l3N4Lt41Q1NyOZwXIlSej1wT74Ya78LMcMFpWnyp90NaI
         QyKFOW9f9ak3hfy1bbia+o/EZTkNpLPt56Bt4kVXqcyZU8TewzMH9nsN8igiT441uBSo
         nnHw==
X-Gm-Message-State: AOAM532A9zCp7yl8kaMCy4r8PRDg54TPwH3cWq4VNLS2Z6m4gpr6bDMP
        FE5/kHZvRuiKpVMpQI+Rr18=
X-Google-Smtp-Source: ABdhPJyUPNrZD/lDiwp46hqVhHnI5BcdXLkMk+aAYn7uh4NFPxCof92TEaMkzHmMS0FJCo5QsBxdKA==
X-Received: by 2002:a17:90b:88b:: with SMTP id bj11mr14632617pjb.229.1606547281596;
        Fri, 27 Nov 2020 23:08:01 -0800 (PST)
Received: from bobo.ibm.com (193-116-103-132.tpgi.com.au. [193.116.103.132])
        by smtp.gmail.com with ESMTPSA id e31sm9087329pgb.16.2020.11.27.23.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 23:08:01 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org,
        Mahesh Salgaonkar <mahesh@linux.ibm.com>
Subject: [PATCH 8/8] powerpc/64s: tidy machine check SLB logging
Date:   Sat, 28 Nov 2020 17:07:28 +1000
Message-Id: <20201128070728.825934-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201128070728.825934-1-npiggin@gmail.com>
References: <20201128070728.825934-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Since ISA v3.0, SLB no longer uses the slb_cache, and stab_rr is no
longer correlated with SLB allocation. Move those to pre-3.0.

While here, improve some alignments and reduce whitespace.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/mm/book3s64/slb.c | 39 ++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/slb.c b/arch/powerpc/mm/book3s64/slb.c
index c30fcbfa0e32..6d720c1c08a4 100644
--- a/arch/powerpc/mm/book3s64/slb.c
+++ b/arch/powerpc/mm/book3s64/slb.c
@@ -255,7 +255,6 @@ void slb_dump_contents(struct slb_entry *slb_ptr)
 		return;
 
 	pr_err("SLB contents of cpu 0x%x\n", smp_processor_id());
-	pr_err("Last SLB entry inserted at slot %d\n", get_paca()->stab_rr);
 
 	for (i = 0; i < mmu_slb_size; i++) {
 		e = slb_ptr->esid;
@@ -265,34 +264,38 @@ void slb_dump_contents(struct slb_entry *slb_ptr)
 		if (!e && !v)
 			continue;
 
-		pr_err("%02d %016lx %016lx\n", i, e, v);
+		pr_err("%02d %016lx %016lx %s\n", i, e, v,
+				(e & SLB_ESID_V) ? "VALID" : "NOT VALID");
 
-		if (!(e & SLB_ESID_V)) {
-			pr_err("\n");
+		if (!(e & SLB_ESID_V))
 			continue;
-		}
+
 		llp = v & SLB_VSID_LLP;
 		if (v & SLB_VSID_B_1T) {
-			pr_err("  1T  ESID=%9lx  VSID=%13lx LLP:%3lx\n",
+			pr_err("     1T ESID=%9lx VSID=%13lx LLP:%3lx\n",
 			       GET_ESID_1T(e),
 			       (v & ~SLB_VSID_B) >> SLB_VSID_SHIFT_1T, llp);
 		} else {
-			pr_err(" 256M ESID=%9lx  VSID=%13lx LLP:%3lx\n",
+			pr_err("   256M ESID=%9lx VSID=%13lx LLP:%3lx\n",
 			       GET_ESID(e),
 			       (v & ~SLB_VSID_B) >> SLB_VSID_SHIFT, llp);
 		}
 	}
-	pr_err("----------------------------------\n");
-
-	/* Dump slb cache entires as well. */
-	pr_err("SLB cache ptr value = %d\n", get_paca()->slb_save_cache_ptr);
-	pr_err("Valid SLB cache entries:\n");
-	n = min_t(int, get_paca()->slb_save_cache_ptr, SLB_CACHE_ENTRIES);
-	for (i = 0; i < n; i++)
-		pr_err("%02d EA[0-35]=%9x\n", i, get_paca()->slb_cache[i]);
-	pr_err("Rest of SLB cache entries:\n");
-	for (i = n; i < SLB_CACHE_ENTRIES; i++)
-		pr_err("%02d EA[0-35]=%9x\n", i, get_paca()->slb_cache[i]);
+
+	if (!early_cpu_has_feature(CPU_FTR_ARCH_300)) {
+		/* RR is not so useful as it's often not used for allocation */
+		pr_err("SLB RR allocator index %d\n", get_paca()->stab_rr);
+
+		/* Dump slb cache entires as well. */
+		pr_err("SLB cache ptr value = %d\n", get_paca()->slb_save_cache_ptr);
+		pr_err("Valid SLB cache entries:\n");
+		n = min_t(int, get_paca()->slb_save_cache_ptr, SLB_CACHE_ENTRIES);
+		for (i = 0; i < n; i++)
+			pr_err("%02d EA[0-35]=%9x\n", i, get_paca()->slb_cache[i]);
+		pr_err("Rest of SLB cache entries:\n");
+		for (i = n; i < SLB_CACHE_ENTRIES; i++)
+			pr_err("%02d EA[0-35]=%9x\n", i, get_paca()->slb_cache[i]);
+	}
 }
 
 void slb_vmalloc_update(void)
-- 
2.23.0

