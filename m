Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C63C3E9539
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbhHKQCQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbhHKQCQ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:02:16 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA61BC061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:01:52 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so10303945pji.5
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VBST8AqhrKncX0fAkXnrZxL4xRtwbCPCtY6hZhbOAns=;
        b=fzedp2iNkDVZSFJUEZt6rIf9covcWofEVp1wWIULIKSSUOVdlFVNuLfSNf4xKeuh2o
         v8Coq9zLeVfMstaCGb1dtmQ5AQjV/NwYE4PzNEgj458CHi1DoxfVuobkQoQnyYfOj2Ly
         29qW/yAllHoEk0sWTpZWL4VA5l19XWEq9vSJJiPXijMTHDdzZi+tfnrLd9h4f51qX/Ok
         GFZfPrBIX70JfowjVRl7CqCZis0EKOaUvy4/u8soIMpXGTRCRutpr40BuZ3NGHdl5+RA
         qyH/T2rNAKRq5qh6amY5W4MoNrQNCSEQSKUJkzSFmWPAU4O29H8obTyV7w/Gs8OXopTL
         oWQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VBST8AqhrKncX0fAkXnrZxL4xRtwbCPCtY6hZhbOAns=;
        b=pA+kkpKVSOtfOiCNikYYL+bW32wPiSmsHZnq8HXFYAhmfXIKn5/YnW8WtYAfRFF0dz
         DQM1Gp4er8MBvjLZkgELfoixQ3fotHsx6ob5H9TyhIrapHc89MtO2VQLVrd4bISZdT+5
         Ay8nfvcoYIZWPSXITglkxIJI0GatGToRlrLu2V+YbFeIc9WdjwWFA+S6QxRfo27OAz90
         O8h3ADPUVPImYp8RFRIzSiMDwhYnH6wlx17noxALmvRpv7+lAkRxAohBQofNBr7xB+52
         z7ZthWGFEDo3orxGNby7L/aadrv4EK7ygAKh3YQc6d+qVhsWKeHLzXZ+6xrOJ4HC5ayf
         s8Gg==
X-Gm-Message-State: AOAM531jvIgqxhF2I1D/lNOQkMdCIvtu+n1Jl9qcCpvFt/+X5QizFeed
        xNlfifF7vg2vi5PEuDkDhytJD6gM+/Y=
X-Google-Smtp-Source: ABdhPJxDqfy9grce4lnzimGRNfvr4PUNGpKbtsfaYfR4JnNRxSKDAXUDCmTdm9bVnXKMY1zZcYdtxg==
X-Received: by 2002:a17:903:4094:b029:12d:242e:a68e with SMTP id z20-20020a1709034094b029012d242ea68emr4810396plc.82.1628697712145;
        Wed, 11 Aug 2021 09:01:52 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:01:51 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 03/60] KVM: PPC: Book3S HV P9: Fixes for TM softpatch interrupt NIP
Date:   Thu, 12 Aug 2021 02:00:37 +1000
Message-Id: <20210811160134.904987-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The softpatch interrupt sets HSRR0 to the faulting instruction +4, so
it should subtract 4 for the faulting instruction address in the case
it is a TM softpatch interrupt (the instruction was not executed) and
it was not emulated.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_tm.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_tm.c b/arch/powerpc/kvm/book3s_hv_tm.c
index cc90b8b82329..e7c36f8bf205 100644
--- a/arch/powerpc/kvm/book3s_hv_tm.c
+++ b/arch/powerpc/kvm/book3s_hv_tm.c
@@ -46,6 +46,15 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 	u64 newmsr, bescr;
 	int ra, rs;
 
+	/*
+	 * The TM softpatch interrupt sets NIP to the instruction following
+	 * the faulting instruction, which is not executed. Rewind nip to the
+	 * faulting instruction so it looks like a normal synchronous
+	 * interrupt, then update nip in the places where the instruction is
+	 * emulated.
+	 */
+	vcpu->arch.regs.nip -= 4;
+
 	/*
 	 * rfid, rfebb, and mtmsrd encode bit 31 = 0 since it's a reserved bit
 	 * in these instructions, so masking bit 31 out doesn't change these
@@ -67,7 +76,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 			       (newmsr & MSR_TM)));
 		newmsr = sanitize_msr(newmsr);
 		vcpu->arch.shregs.msr = newmsr;
-		vcpu->arch.cfar = vcpu->arch.regs.nip - 4;
+		vcpu->arch.cfar = vcpu->arch.regs.nip;
 		vcpu->arch.regs.nip = vcpu->arch.shregs.srr0;
 		return RESUME_GUEST;
 
@@ -100,7 +109,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 		vcpu->arch.bescr = bescr;
 		msr = (msr & ~MSR_TS_MASK) | MSR_TS_T;
 		vcpu->arch.shregs.msr = msr;
-		vcpu->arch.cfar = vcpu->arch.regs.nip - 4;
+		vcpu->arch.cfar = vcpu->arch.regs.nip;
 		vcpu->arch.regs.nip = vcpu->arch.ebbrr;
 		return RESUME_GUEST;
 
@@ -116,6 +125,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 		newmsr = (newmsr & ~MSR_LE) | (msr & MSR_LE);
 		newmsr = sanitize_msr(newmsr);
 		vcpu->arch.shregs.msr = newmsr;
+		vcpu->arch.regs.nip += 4;
 		return RESUME_GUEST;
 
 	/* ignore bit 31, see comment above */
@@ -152,6 +162,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 				msr = (msr & ~MSR_TS_MASK) | MSR_TS_S;
 		}
 		vcpu->arch.shregs.msr = msr;
+		vcpu->arch.regs.nip += 4;
 		return RESUME_GUEST;
 
 	/* ignore bit 31, see comment above */
@@ -189,6 +200,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 		vcpu->arch.regs.ccr = (vcpu->arch.regs.ccr & 0x0fffffff) |
 			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 29);
 		vcpu->arch.shregs.msr &= ~MSR_TS_MASK;
+		vcpu->arch.regs.nip += 4;
 		return RESUME_GUEST;
 
 	/* ignore bit 31, see comment above */
@@ -220,6 +232,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 		vcpu->arch.regs.ccr = (vcpu->arch.regs.ccr & 0x0fffffff) |
 			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 29);
 		vcpu->arch.shregs.msr = msr | MSR_TS_S;
+		vcpu->arch.regs.nip += 4;
 		return RESUME_GUEST;
 	}
 
-- 
2.23.0

