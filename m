Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C3A3D51B7
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhGZDLJ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhGZDLJ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:11:09 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B01C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:37 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j1so11099426pjv.3
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TlyaSEq0t+PRD6ftzOjtBOST1TcfxMZ4B/R2htdQQDg=;
        b=g+HajHr1SO9Bsn/F4YCZmiWqX6zSkdUF1UemGJUPQoZqwW0CMXOzECMOG5Xq89mtGM
         9XDq3crVgP8t3JwF+1RlJQWBph82iwHg3E+KAQvy6DfiHm+KnCqKe/aL+GsDXV9sxCiZ
         DXmkQAdY2JKrJZyuHD9BngEPY3aBKJpL9gv8swydw7i9pqEbHnsUJbUuGWN7ESGVmNtu
         3m9IZU9BII2G25kuXl7ap56cWYqmYHEJGsqV6K+cBAeayglVb//oQ7Y7gzDhiRrQJpqQ
         VBh2rGBWNNLNhHiAmoofkBs4lBxmGAZI3qJOXUrqbQNKiYzQWpu6BoOwW+1Eh8iT9TXK
         E7wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TlyaSEq0t+PRD6ftzOjtBOST1TcfxMZ4B/R2htdQQDg=;
        b=eLrnIhDKbQ8KijQXBoIYJW3ToNan+cffc9dLofncMVbT3mqN5NvIB6NWDw83i3N+jS
         iM8ehwWY0yZOf3a+n03lMO5K2hiC7HaNHdAygTFcV5/C921DFNCP5TZ7R0g/S4DgzfbD
         GMtDUbL2+tYZj3vnnPY9hFL3LEzyzMe4gI4Go6xILMfR4XfsCEtRzC5fyoir/7S6fdPf
         ZJ6ZglLRKgn4i8wx/By7MtMNU5+g3PMYdRXYfAOhPefI7jg0sQIMdouISoz5C+XSLVPV
         hyaCEb5zm/W/okTwEh5HZuHmaFosVIiwFHMI9yIrlZNTz6uwqj6oOBPN3YoL7ySoqnlE
         BUxg==
X-Gm-Message-State: AOAM532CfL5SDC83yhzQBF2OFTozPsJa4M1PNcmABifKkj7tPGJF543w
        2pXxjKfqrU+wHs5YQZ7Ai43BLes/Q6E=
X-Google-Smtp-Source: ABdhPJzDx+e6KcW+rc1cBJfLlZ9+HLdDjj/ZOf3LfPcyJbtU7eVuwRkC9WAFWEqtFw5wkpez6U4NcA==
X-Received: by 2002:a17:902:a9c1:b029:12b:8ae3:e077 with SMTP id b1-20020a170902a9c1b029012b8ae3e077mr12921049plr.75.1627271497200;
        Sun, 25 Jul 2021 20:51:37 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:51:37 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 22/55] KVM: PPC: Book3S HV P9: Move SPRG restore to restore_p9_host_os_sprs
Date:   Mon, 26 Jul 2021 13:50:03 +1000
Message-Id: <20210726035036.739609-23-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Move the SPR update into its relevant helper function. This will
help with SPR scheduling improvements in later changes.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index f212d5013622..2e966d62a583 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4057,6 +4057,8 @@ static void save_p9_host_os_sprs(struct p9_host_os_sprs *host_os_sprs)
 static void restore_p9_host_os_sprs(struct kvm_vcpu *vcpu,
 				    struct p9_host_os_sprs *host_os_sprs)
 {
+	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
+
 	mtspr(SPRN_PSPB, 0);
 	mtspr(SPRN_UAMOR, 0);
 
@@ -4256,8 +4258,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	timer_rearm_host_dec(tb);
 
-	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
-
 	kvmppc_subcore_exit_guest();
 
 	return trap;
-- 
2.23.0

