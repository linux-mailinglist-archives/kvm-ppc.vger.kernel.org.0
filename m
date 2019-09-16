Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1562B35AA
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Sep 2019 09:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfIPHbc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Sep 2019 03:31:32 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40189 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfIPHbc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 16 Sep 2019 03:31:32 -0400
Received: by mail-pg1-f195.google.com with SMTP id w10so19320725pgj.7
        for <kvm-ppc@vger.kernel.org>; Mon, 16 Sep 2019 00:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/lCqkMTgr399H14LYWc02DFsAJ40PfT78woR5enr/2w=;
        b=j4oedHGPIvB6SosXRUyCELfhrTYUk9APtySHZ9sR77ilhTCpr4ZbP36LegmG/6YuKW
         Y4QROjiR8AOBO6/8FCPMlwGlxm9kE6I/zTtxu3hWAInjOQuV1ahLeG59rDeH8sLmfVpg
         AjI2CCHqS+bVqmsOTDZQ7tAyAxkG1LwcI6ElLd/IAuQMXXqpZt2+r7dt7HyWYP3RV9Pt
         kFuAhA4aT8RePUelVhzerTdrGFf/HQn4wuMGA469Y/9qoFXHdjBF1d8H0Zlrj9QmIlpt
         4Bii2HI+XfohODaivuKCFRmilqh2KhuTECtnYmsTL+3aHWHm7K21ragfWLiAmcbzk9XK
         mNeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/lCqkMTgr399H14LYWc02DFsAJ40PfT78woR5enr/2w=;
        b=qDn6IpX0qw1MlXcYfPyPa/JMa9GsTKwO3MwfZLzdZWU0ZKuSiQgjz6FrcPOXuliMki
         3vXouGVY+QkwCpkWG156gdNyS3tn2EF/1zzCbjxSqCYTNGeTcl46+K8pDKc6VOES3JI3
         MRLorp6H4onjsvUcXly2ACUuGqLOzy6fFGFMysEvq+Zidx8ChiHotanYc2THJk/46+2L
         Tjuyh98taCUnmhIsycb0Qs+B90DzCTTVPV9v3TyThrq6Hw1zKrg1n1iZDX5KKmHG/f+u
         8Q0tbDw6G4pmK5zFdEjcZBlQ5KbJopmzT0jwZ/uiJjVhaq6zgWvI0R5xhEflGHic3UhI
         Wg1Q==
X-Gm-Message-State: APjAAAWUkoEbCQZXNDHRwifroUzvS+0+4gp6Ai6ltcU7qLSqdJkWoJxK
        dqZeU98O78RVhwh/V0bjJ5yneUdf
X-Google-Smtp-Source: APXvYqyLQt9tlVtFKQKkvnkfpCznP9HikAYEU9A58A/hU3elfALuWI1V9qQsqqzlJ3mGSkLntq/d9A==
X-Received: by 2002:a17:90a:22b0:: with SMTP id s45mr19159075pjc.22.1568619091660;
        Mon, 16 Sep 2019 00:31:31 -0700 (PDT)
Received: from bobo.local0.net ([203.63.189.78])
        by smtp.gmail.com with ESMTPSA id 195sm12484964pfz.103.2019.09.16.00.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 00:31:31 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH v2 5/5] KVM: PPC: Book3S HV: Reject mflags=2 (LPCR[AIL]=2) ADDR_TRANS_MODE mode
Date:   Mon, 16 Sep 2019 17:31:08 +1000
Message-Id: <20190916073108.3256-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190916073108.3256-1-npiggin@gmail.com>
References: <20190916073108.3256-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

AIL=2 mode has no known users, so is not well tested or supported.
Disallow guests from selecting this mode because it may become
deprecated in future versions of the architecture.

This policy decision is not left to QEMU because KVM support is
required for AIL=2 (when injecting interrupts).

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index ed2eeda202b9..8f322112f0a3 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -776,6 +776,11 @@ static int kvmppc_h_set_mode(struct kvm_vcpu *vcpu, unsigned long mflags,
 		vcpu->arch.dawr  = value1;
 		vcpu->arch.dawrx = value2;
 		return H_SUCCESS;
+	case H_SET_MODE_RESOURCE_ADDR_TRANS_MODE:
+		/* KVM does not support mflags=2 (AIL=2) */
+		if (mflags != 0 && mflags != 3)
+			return H_UNSUPPORTED_FLAG_START;
+		return H_TOO_HARD;
 	default:
 		return H_TOO_HARD;
 	}
-- 
2.23.0

