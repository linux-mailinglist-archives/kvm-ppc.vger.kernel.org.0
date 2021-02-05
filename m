Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F025310365
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Feb 2021 04:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhBEDRZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 4 Feb 2021 22:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhBEDRY (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 4 Feb 2021 22:17:24 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9A7C0613D6;
        Thu,  4 Feb 2021 19:16:44 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id n15so5641156qkh.8;
        Thu, 04 Feb 2021 19:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8WTNk9Xbw6EghApIXQgl/ogYtRuCwBqSCPnWZ2LdagU=;
        b=kl220autwj+PrnjrQxTlb2/j43lozhddaVtEdxeo3Eb1olxxUNrgM27SIT2VuHAEbQ
         UtZypHI/rURy1bC9zu6yyd6rgCtEaseSa8e/f8tSCV9L/AvOaA6Q1NquI0/7bcwOBvo/
         n/Br77ExjxcR1sTUsdJL1mY9250CfUvUypKT4l50J0xQYcfMF4ezP8p3Sho80IY07Unz
         dVX9H9NNI1dk35W20/lmJlEqpF19WFZQSdg7MBDLXFq0gnskmB8iH/spt3+RF0wOmCfd
         LMEiRVaQbuURxJ5lxjaIywwxstP2rNwlDJd/ij7rSS/AKPWJxIsfEXzpynwp1jSAsYA5
         YTTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8WTNk9Xbw6EghApIXQgl/ogYtRuCwBqSCPnWZ2LdagU=;
        b=ArGB/OMvKF/grLkMx0TP6dNYfZ+sxX0eaY+qMbRpDVFWjQs92p1PZZqHGQ6AOAbvPr
         nRDQdrBB5HeHbfIiPLONwjebNJ+vq1dkyyYIPSaqNyhG7MiggWvUBwChftN67DmLQI3y
         QOs370aFu93XrjYNI85bKy4DoQI6LhNgqIqvYiE9Kb9/5I3VuHCEwL3VU9cEdDigcC7D
         PyCmOXIc/mPWHTpNOC0VpDZK+EVI5IDyGT/cfFuTPJ2+q8D+138k2nZj3uWqUse0O/Zn
         Llzjwk/GrxNUtuQ3GvfmlD0+gNklywVSkeBEHrARIH2z15f3n4D0WCAr0ilywOpm/ZEP
         QPpA==
X-Gm-Message-State: AOAM531PxAUvpsQhcr0zqctDzVmCOF3poUH/UIWdcRUntV+69tte6WGR
        ujvxGEvN/HEKb4i7AmGsr08=
X-Google-Smtp-Source: ABdhPJzquNM+md70FmybygGiqQluF5m3/Rm/hLyrOyr5Kt5Vk91Zinjx4QN+Nlm3uwB6RKvlBAe5dw==
X-Received: by 2002:a37:455:: with SMTP id 82mr2590683qke.490.1612495003118;
        Thu, 04 Feb 2021 19:16:43 -0800 (PST)
Received: from li-908e0a4c-2250-11b2-a85c-f027e903211b.ibm.com.com (186-249-147-196.dynamic.desktop.com.br. [186.249.147.196])
        by smtp.gmail.com with ESMTPSA id o45sm6842587qto.91.2021.02.04.19.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 19:16:42 -0800 (PST)
From:   Leonardo Bras <leobras.c@gmail.com>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Gustavo Romero <gromero@linux.ibm.com>,
        Jordan Niethe <jniethe5@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Frederic Weisbecker <frederic@kernel.org>
Cc:     Leonardo Bras <leobras.c@gmail.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] powerpc/kvm: Save Timebase Offset to fix sched_clock() while running guest code.
Date:   Fri,  5 Feb 2021 00:16:24 -0300
Message-Id: <20210205031623.222730-1-leobras.c@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Before guest entry, TBU40 register is changed to reflect guest timebase.
After exitting guest, the register is reverted to it's original value.

If one tries to get the timestamp from host between those changes, it
will present an incorrect value.

An example would be trying to add a tracepoint in
kvmppc_guest_entry_inject_int(), which depending on last tracepoint
acquired could actually cause the host to crash.

Save the Timebase Offset to PACA and use it on sched_clock() to always
get the correct timestamp.

Signed-off-by: Leonardo Bras <leobras.c@gmail.com>
---
 arch/powerpc/include/asm/kvm_book3s_asm.h | 1 +
 arch/powerpc/kernel/asm-offsets.c         | 1 +
 arch/powerpc/kernel/time.c                | 3 ++-
 arch/powerpc/kvm/book3s_hv.c              | 2 ++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S   | 2 ++
 5 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s_asm.h b/arch/powerpc/include/asm/kvm_book3s_asm.h
index 078f4648ea27..e2c12a10eed2 100644
--- a/arch/powerpc/include/asm/kvm_book3s_asm.h
+++ b/arch/powerpc/include/asm/kvm_book3s_asm.h
@@ -131,6 +131,7 @@ struct kvmppc_host_state {
 	u64 cfar;
 	u64 ppr;
 	u64 host_fscr;
+	u64 tb_offset;		/* Timebase offset: keeps correct timebase while on guest */
 #endif
 };
 
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index b12d7c049bfe..0beb8fdc6352 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -706,6 +706,7 @@ int main(void)
 	HSTATE_FIELD(HSTATE_CFAR, cfar);
 	HSTATE_FIELD(HSTATE_PPR, ppr);
 	HSTATE_FIELD(HSTATE_HOST_FSCR, host_fscr);
+	HSTATE_FIELD(HSTATE_TB_OFFSET, tb_offset);
 #endif /* CONFIG_PPC_BOOK3S_64 */
 
 #else /* CONFIG_PPC_BOOK3S */
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 67feb3524460..adf6648e3572 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -699,7 +699,8 @@ EXPORT_SYMBOL_GPL(tb_to_ns);
  */
 notrace unsigned long long sched_clock(void)
 {
-	return mulhdu(get_tb() - boot_tb, tb_to_ns_scale) << tb_to_ns_shift;
+	return mulhdu(get_tb() - boot_tb - local_paca->kvm_hstate.tb_offset, tb_to_ns_scale)
+			<< tb_to_ns_shift;
 }
 
 
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index b3731572295e..c08593c63353 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3491,6 +3491,7 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 		if ((tb & 0xffffff) < (new_tb & 0xffffff))
 			mtspr(SPRN_TBU40, new_tb + 0x1000000);
 		vc->tb_offset_applied = vc->tb_offset;
+		local_paca->kvm_hstate.tb_offset = vc->tb_offset;
 	}
 
 	if (vc->pcr)
@@ -3594,6 +3595,7 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 		if ((tb & 0xffffff) < (new_tb & 0xffffff))
 			mtspr(SPRN_TBU40, new_tb + 0x1000000);
 		vc->tb_offset_applied = 0;
+		local_paca->kvm_hstate.tb_offset = 0;
 	}
 
 	mtspr(SPRN_HDEC, 0x7fffffff);
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index b73140607875..8f7a9f7f4ee6 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -632,6 +632,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
 	cmpdi	r8,0
 	beq	37f
 	std	r8, VCORE_TB_OFFSET_APPL(r5)
+	std	r8, HSTATE_TB_OFFSET(r13)
 	mftb	r6		/* current host timebase */
 	add	r8,r8,r6
 	mtspr	SPRN_TBU40,r8	/* update upper 40 bits */
@@ -1907,6 +1908,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
 	beq	17f
 	li	r0, 0
 	std	r0, VCORE_TB_OFFSET_APPL(r5)
+	std	r0, HSTATE_TB_OFFSET(r13)
 	mftb	r6			/* current guest timebase */
 	subf	r8,r8,r6
 	mtspr	SPRN_TBU40,r8		/* update upper 40 bits */
-- 
2.29.2

