Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB253B01F8
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhFVLAf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbhFVLAf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:00:35 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFC0C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:18 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id i6so123467pfq.1
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TOgK6BlAze2BcucFCieXN1hKi5wN+ldytx7JCdHOUdg=;
        b=MMHFcRRmIE9RNoqPDXHnDQQn5ucROGkcLBEShz8o6YgvrvmqYtgphxHV0IWNR3cCLH
         e1VesQaAHz63UDg4Earjb+j8ivfGVxD+XKPMomsSz4VXd92mT9XGRumMrf/fjdXRDYSZ
         B15yfHfa+2bcZMGk03S2nGVwqMEF7oP5ZTXXjRBR3atKeWmI3+KEAJLyL/3ht3DgLxHs
         go6CVnRz+OvofjPKwxIC4/vKq9u+436EagpgPFmDzpM3V+YbwstOYjqbBgfXZnqndn5A
         a0B45G1MFGTabOI83B8lbwrsOaPI3g4rYUaW5ja8kWmZ0+rF7MrdcsrZ59IVsVMVzXaM
         Y/MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TOgK6BlAze2BcucFCieXN1hKi5wN+ldytx7JCdHOUdg=;
        b=VGAID/TEARaDXPxVFnIZHq0vUNsWjQNLnllNvE98jFzqjI+cwKlBD6U2lYcDgQpG9e
         NJk/ISSUSrVoBuoClyjqsPgnQcorxMLU6EFT54qwquUuYlH5nPajl4Mey+2KXabh9ydG
         /gigC0W0lAq/xCuKkvOAGRsIrX84hhpfPvP4j9gHoPwduuTV4b9OxCJqvXtGi2Npbj1c
         U5IWFls81EJVX7LxP1jyWWPB44NQ3Iz6GtyKX2GgbAD6K/PGs1IHkGiOES3+BfC8YcOY
         rEitC4GwG5eRD89nOZxqu0gXGggYOoJzRnbp1x1qwkeTLAhhibSi0ZJ4fOfmgXYdHmfM
         LX9g==
X-Gm-Message-State: AOAM531JXX5sQXPmIU6Zyr3xtvgHwUdubdIuLU8aFr9CVuNNsPaY3+KH
        f4OHan+tOzX/nN9SXcral8fm56jZNmk=
X-Google-Smtp-Source: ABdhPJwuAMoJs+c5XDRoWPfmNkv/W71tj/1vIHnEkXP+9d0D9ac9ZE7bx69VsLQbDmqvfQQq+EdUTA==
X-Received: by 2002:a62:ea1a:0:b029:2ec:9146:30be with SMTP id t26-20020a62ea1a0000b02902ec914630bemr3101893pfh.29.1624359498306;
        Tue, 22 Jun 2021 03:58:18 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:58:18 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 09/43] KVM: PPC: Book3S HV: Don't always save PMU for guest capable of nesting
Date:   Tue, 22 Jun 2021 20:57:02 +1000
Message-Id: <20210622105736.633352-10-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Revert the workaround added by commit 63279eeb7f93a ("KVM: PPC: Book3S
HV: Always save guest pmu for guest capable of nesting").

Nested capable guests running with the earlier commit ("KVM: PPC: Book3S
HV Nested: Indicate guest PMU in-use in VPA") will now indicate the PMU
in-use status of their guests, which means the parent does not need to
unconditionally save the PMU for nested capable guests.

This will cause the PMU to break for nested guests when running older
nested hypervisor guests under a kernel with this change. It's unclear
there's an easy way to avoid that, so this could wait for a release or
so for the fix to filter into stable kernels.

-134 cycles (8982) POWER9 virt-mode NULL hcall

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index ed713f49fbd5..1f30f98b09d1 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3901,8 +3901,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		vcpu->arch.vpa.dirty = 1;
 		save_pmu = lp->pmcregs_in_use;
 	}
-	/* Must save pmu if this guest is capable of running nested guests */
-	save_pmu |= nesting_enabled(vcpu->kvm);
 
 	kvmhv_save_guest_pmu(vcpu, save_pmu);
 #ifdef CONFIG_PPC_PSERIES
-- 
2.23.0

