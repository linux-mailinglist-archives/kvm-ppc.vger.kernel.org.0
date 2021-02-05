Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52E53104D6
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Feb 2021 07:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhBEGIG (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Feb 2021 01:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhBEGIG (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Feb 2021 01:08:06 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26626C0613D6;
        Thu,  4 Feb 2021 22:07:26 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id t126so3355349qke.11;
        Thu, 04 Feb 2021 22:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c+rZMn81nItYMfTxQIYm4AJB4Em1cxJWX+xfGWskuj0=;
        b=M0eKd+0HHH/kMzKnq9rLYOT8HdhYTANkxRdXNs0vIEEhqlZiGB+mPBHx1Je1rGIl3Q
         D2+TfYASZwF5/FCGh3GAqas7MIWkmdU40IlNl5KlID2kjYHxZ4dLZ2DUTBJLlkOc27iW
         /XuMlH6I2lAbmCH+tx0QoAop3XZ6xWMyUdM810U4DThrqH4zUzvzE34bUNQJTRofsGiN
         a1Ebrv1yU0/0+08aucKtAzOSrmwrL5rh/kya1E8c4jJOiQnQVoz05VXFBfVIFz/6mhAv
         16GIb9/vouy/V4dHC3NjcOmTOlwEvy9GSk/VKyLbJiyifqsnNHyo6sxRWcs37Dmo1xzX
         9w7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c+rZMn81nItYMfTxQIYm4AJB4Em1cxJWX+xfGWskuj0=;
        b=tII/fUFBeXZYUbif74qb0y4bawOKkkdr4c+G676tytzjjEhNAuCiqeNGOH/aH6taUq
         EhwfrxZnWBX4dPS+Gx0KG3pDyhtQbZHlFVJ8JPtBCBMTT0Q8JZ5G7OzUEWIJ+5YuG+RU
         z1trTSjebONWjgLfzI1Alur63g3TRuX3csUfh5Ejcpk3fJEx+3xYLUgIsz75X0K8a6iH
         Qqh1sjX9f8iuaaBy/QBnKPp21S35jyk80nsnye4pdrQtVd5UIYyHkzI3Lw1D8JwaI8WN
         FrcgulglCke3WwoDfI/LgF4EI5UOsuB/e85aeFAXiFKhB+oj38NMK/tBjwNONMAarFnX
         bw0g==
X-Gm-Message-State: AOAM532jkBgcovBTSOpKsxFeDu9MxasF3aT/AJ/kZuej/5wND0SM2UKs
        3ipCFJ8qaXCuWQUnsGtLG4s=
X-Google-Smtp-Source: ABdhPJytFulfFj25v/hGN6HgQ33XEaNapQrRh0Va6HFsbKPJJRVrCk0eK4ifv0egqZk+weMhL6+mkQ==
X-Received: by 2002:a37:e217:: with SMTP id g23mr2885432qki.283.1612505245360;
        Thu, 04 Feb 2021 22:07:25 -0800 (PST)
Received: from li-908e0a4c-2250-11b2-a85c-f027e903211b.ibm.com.com (186-249-147-196.dynamic.desktop.com.br. [186.249.147.196])
        by smtp.gmail.com with ESMTPSA id q22sm4129436qki.51.2021.02.04.22.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 22:07:24 -0800 (PST)
From:   Leonardo Bras <leobras.c@gmail.com>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Leonardo Bras <leobras.c@gmail.com>,
        Jordan Niethe <jniethe5@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] powerpc/kvm: Save Timebase Offset to fix sched_clock() while running guest code.
Date:   Fri,  5 Feb 2021 03:06:44 -0300
Message-Id: <20210205060643.233481-1-leobras.c@gmail.com>
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
Suggested-by: Paul Mackerras <paulus@ozlabs.org>
---
Changes since v1:
- Subtracts offset only when CONFIG_KVM_BOOK3S_HANDLER and
  CONFIG_PPC_BOOK3S_64 are defined.
---
 arch/powerpc/include/asm/kvm_book3s_asm.h | 1 +
 arch/powerpc/kernel/asm-offsets.c         | 1 +
 arch/powerpc/kernel/time.c                | 8 +++++++-
 arch/powerpc/kvm/book3s_hv.c              | 2 ++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S   | 2 ++
 5 files changed, 13 insertions(+), 1 deletion(-)

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
index 67feb3524460..f27f0163792b 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -699,7 +699,13 @@ EXPORT_SYMBOL_GPL(tb_to_ns);
  */
 notrace unsigned long long sched_clock(void)
 {
-	return mulhdu(get_tb() - boot_tb, tb_to_ns_scale) << tb_to_ns_shift;
+	u64 tb = get_tb() - boot_tb;
+
+#if defined(CONFIG_PPC_BOOK3S_64) && defined(CONFIG_KVM_BOOK3S_HANDLER)
+	tb -= local_paca->kvm_hstate.tb_offset;
+#endif
+
+	return mulhdu(tb, tb_to_ns_scale) << tb_to_ns_shift;
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

