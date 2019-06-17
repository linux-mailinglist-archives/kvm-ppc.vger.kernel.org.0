Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4D0747A97
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 Jun 2019 09:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfFQHQf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 17 Jun 2019 03:16:35 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40665 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfFQHQe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 17 Jun 2019 03:16:34 -0400
Received: by mail-pf1-f196.google.com with SMTP id p184so5151755pfp.7
        for <kvm-ppc@vger.kernel.org>; Mon, 17 Jun 2019 00:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d6N1vKgjivwyrr2s1CIAV9DQUrEfszhqiY+G/Xll5XY=;
        b=mCZ1E17/udh2Cwu4TclaZuF5WnXCcSIx/SQnj18rfXkF16RJ0hMYlqGdUVXSL8hfy/
         zutivL7ZLYkw8gQfHZ5xk5yk2ULQhZ+YzS5Bqile2rxtp7Y/GmlGJF8ePQEoc7N7nW6v
         KooRlUDXgS1rHqGWNvkh+S7ci4GSA7HzO4gN7mMoj/XLTsSgJgMaQHvLMu7U/vNFxuGv
         bb7P72GayLxrtoH+OfUT8cBWZT7vMII+S3n2DeVAgNOPC8y0zxB4BDKJfHz0qjf09a1h
         DmfqJpR0Ct9PqHNYksdr5mZKWtAiS093RRSYf99VpCzy0TZs/G2osg3YujvLyhbJnh31
         J0lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d6N1vKgjivwyrr2s1CIAV9DQUrEfszhqiY+G/Xll5XY=;
        b=MwpXcQ/ORuSeUKAJ0/hUtXmGUl4U45u2HoqVI026t0Q/qK6AczpkwqnTGQbV/KNmQH
         /pLrJerCctPo+w00IbYlC7EmC0q+WiHFuEyAxW/WDv2Vqi63pwwwVgCmdLiFWaNi/iP2
         bCIhw0VUXNl+1UVtDZewG8I7ibq7L0iIEsdkKdnivzmuhsAe7US8vkTyGzB40VqRtqP3
         Xtjdz1iu59KRa0jvituEMXD6gcMf7mAYR3hpvmB9YW0oZOgS41t0EkusElTfw0opepp2
         FTJByLNKcgH74uHGW29o9Z1RyW2UjmGZogVUsDWEX2L25LpPB1HNcLnlFrWKi23qmnhx
         oicQ==
X-Gm-Message-State: APjAAAVgvSqdrurQuLBlbsECT2DHQZ4QpxV+/H9E+rfQPBJ47lG26cOs
        mJQukK8uKSaWpRis1viKeuY=
X-Google-Smtp-Source: APXvYqz3/4BU/Wg1eEt44dMc4i+coQta9JxGCnqnFDI83lPJUpI3NzPzqtasxHl1CSljkr53a7oU2Q==
X-Received: by 2002:a17:90a:7107:: with SMTP id h7mr24294324pjk.38.1560755794236;
        Mon, 17 Jun 2019 00:16:34 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id m31sm22163663pjb.6.2019.06.17.00.16.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 17 Jun 2019 00:16:33 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mikey@neuling.org, mpe@ellerman.id.au,
        paulus@ozlabs.org, clg@kaod.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 2/2] KVM: PPC: Book3S HV: Only write DAWR[X] when handling h_set_dawr in real mode
Date:   Mon, 17 Jun 2019 17:16:19 +1000
Message-Id: <20190617071619.19360-3-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190617071619.19360-1-sjitindarsingh@gmail.com>
References: <20190617071619.19360-1-sjitindarsingh@gmail.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The hcall H_SET_DAWR is used by a guest to set the data address
watchpoint register (DAWR). This hcall is handled in the host in
kvmppc_h_set_dawr() which can be called in either real mode on the guest
exit path from hcall_try_real_mode() in book3s_hv_rmhandlers.S, or in
virtual mode when called from kvmppc_pseries_do_hcall() in book3s_hv.c.

The function kvmppc_h_set_dawr updates the dawr and dawrx fields in the
vcpu struct accordingly and then also writes the respective values into
the DAWR and DAWRX registers directly. It is necessary to write the
registers directly here when calling the function in real mode since the
path to re-enter the guest won't do this. However when in virtual mode
the host DAWR and DAWRX values have already been restored, and so writing
the registers would overwrite these. Additionally there is no reason to
write the guest values here as these will be read from the vcpu struct
and written to the registers appropriately the next time the vcpu is
run.

This also avoids the case when handling h_set_dawr for a nested guest
where the guest hypervisor isn't able to write the DAWR and DAWRX
registers directly and must rely on the real hypervisor to do this for
it when it calls H_ENTER_NESTED.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 703cd6cd994d..337e64468d78 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -2510,9 +2510,18 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
 	clrrdi	r4, r4, 3
 	std	r4, VCPU_DAWR(r3)
 	std	r5, VCPU_DAWRX(r3)
+	/*
+	 * If came in through the real mode hcall handler then it is necessary
+	 * to write the registers since the return path won't. Otherwise it is
+	 * sufficient to store then in the vcpu struct as they will be loaded
+	 * next time the vcpu is run.
+	 */
+	mfmsr	r6
+	andi.	r6, r6, MSR_DR		/* in real mode? */
+	bne	4f
 	mtspr	SPRN_DAWR, r4
 	mtspr	SPRN_DAWRX, r5
-	li	r3, 0
+4:	li	r3, 0
 	blr
 
 _GLOBAL(kvmppc_h_cede)		/* r3 = vcpu pointer, r11 = msr, r13 = paca */
-- 
2.13.6

