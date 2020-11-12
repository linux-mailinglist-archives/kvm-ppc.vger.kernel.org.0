Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058962AFCC6
	for <lists+kvm-ppc@lfdr.de>; Thu, 12 Nov 2020 02:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgKLBdx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Nov 2020 20:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728227AbgKLBTm (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Nov 2020 20:19:42 -0500
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694C5C0613D1;
        Wed, 11 Nov 2020 17:19:42 -0800 (PST)
Received: by mail-qv1-xf41.google.com with SMTP id g19so2017141qvy.2;
        Wed, 11 Nov 2020 17:19:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t6O0sYxJBUgk9V8FqRpsvwNNwz5ipQ+AansIawZja9I=;
        b=VfLxL9U/SBb06NU26ZQg3mLeQ4YU1vURENNOX5o9q82sPjjgQlOfM1ZNu2MEX8cf13
         HiYQalcws2knOoe8K/KgYewmysQ8XDLjytyJ8Lj9gBheD0Bkl2D+PJIGAJlHwq3P0Jul
         LZrPQncH0vQobnEM1JMY88RpxSVE3r7lG47hHG5WmhT2Yiw+NisM+btts8lhN4bJuRk9
         pgEAtMLaELZYognagwPWUCKr52rDSoRc9Hk/TipywE70ue8nFy0R0/Z+wRYQwX5H1vI7
         MU5hAswXktl9GHH4aJsXmWx0TRKsirtCqDa7tWPiyikBYgQZj4a0OIMOCvOQ3zHmNcGY
         9Hfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t6O0sYxJBUgk9V8FqRpsvwNNwz5ipQ+AansIawZja9I=;
        b=bSoNwVmoh94Qs4uSElACDIQ7p9xiuV5WxLyWS9EVZrlz27LH6L3GCwjccGx1a5I2Zt
         tBTZyHzllM32C+Q6QaMFOHlsObQZoAieEBaACRHP6NZOXLlI4V6S1hs83cYDBSCAAe3O
         vinpcuqambpLA8wTbWYDlPoiT7zT5QTrcdIDyYeAfyFxvqlvaMVvzAbpKEhR9u+Msn7h
         75jdJ+9gQXeuPPPRqzHpd4IqRRMVELFFBFJj8mXBGfX3KWMGUnfsskvT6XGlzY652EIQ
         xJD6js6EuwiXrzxPzoIsPVVWJM23f0pAYKfkOBViz5TcVHfnGkQMvUQJMTrkBZcWI58g
         QDgQ==
X-Gm-Message-State: AOAM532EgPHLh+15bydVIgOzZwSO4HAZV4zXRDV8lPEio+cyy8u1vPNM
        wQll9JLWeRO+wFojYiZR3P0=
X-Google-Smtp-Source: ABdhPJyjsvg9C4SUokM73BG6LLbH3Hup8iycj/2InNMean/F6Boq/HwoUQ1KVzkfw4ArHsGv4r+FTA==
X-Received: by 2002:a0c:a5a2:: with SMTP id z31mr29221656qvz.15.1605143981548;
        Wed, 11 Nov 2020 17:19:41 -0800 (PST)
Received: from LeoBras.ibmuc.com (179-125-145-97.dynamic.desktop.com.br. [179.125.145.97])
        by smtp.gmail.com with ESMTPSA id e10sm4153867qkn.126.2020.11.11.17.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 17:18:17 -0800 (PST)
From:   Leonardo Bras <leobras.c@gmail.com>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     Leonardo Bras <leobras.c@gmail.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] powerpc/kvm: Fix mask size for emulated msgsndp
Date:   Wed, 11 Nov 2020 22:16:55 -0300
Message-Id: <20201112011655.382866-1-leobras.c@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

According to ISAv3.1 and ISAv3.0b, the msgsndp is described to split RB in:
msgtype <- (RB) 32:36
payload <- (RB) 37:63
t       <- (RB) 57:63

The current way of getting 'msgtype', and 't' is missing their LSB:
msgtype: ((arg >> 27) & 0xf) : Gets (RB) 33:36, missing bit 32
t:       (arg &= 0x3f)       : Gets (RB) 58:63, missing bit 57

Fixes this by applying the correct mask.

Signed-off-by: Leonardo Bras <leobras.c@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index e3b1839fc251..5af0a429cee8 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1241,9 +1241,9 @@ static int kvmppc_emulate_doorbell_instr(struct kvm_vcpu *vcpu)
 	switch (get_xop(inst)) {
 	case OP_31_XOP_MSGSNDP:
 		arg = kvmppc_get_gpr(vcpu, rb);
-		if (((arg >> 27) & 0xf) != PPC_DBELL_SERVER)
+		if (((arg >> 27) & 0x1f) != PPC_DBELL_SERVER)
 			break;
-		arg &= 0x3f;
+		arg &= 0x7f;
 		if (arg >= kvm->arch.emul_smt_mode)
 			break;
 		tvcpu = kvmppc_find_vcpu(kvm, vcpu->vcpu_id - thr + arg);
@@ -1256,7 +1256,7 @@ static int kvmppc_emulate_doorbell_instr(struct kvm_vcpu *vcpu)
 		break;
 	case OP_31_XOP_MSGCLRP:
 		arg = kvmppc_get_gpr(vcpu, rb);
-		if (((arg >> 27) & 0xf) != PPC_DBELL_SERVER)
+		if (((arg >> 27) & 0x1f) != PPC_DBELL_SERVER)
 			break;
 		vcpu->arch.vcore->dpdes = 0;
 		vcpu->arch.doorbell_request = 0;
-- 
2.25.4

