Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D8442135E
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236240AbhJDQDf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236129AbhJDQDf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:03:35 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22868C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:01:46 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t11so185356plq.11
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BSpAfqkgDPepZQ3GfNve5U7U5lObdzccs8al+a/vxj0=;
        b=IqCkpfAb746JTjXXOlrU9/9XyZ4v5/VseeUrceuibJEaNgm38bLE/QJzcDgX+Z+vpW
         EfsuTtW6qMhx/+zfMB3Dn7+FDGPe8CxYFVzcppylROPglw322XQAmYHc+ScHArFgFU3F
         Ve5kOplnwKdqR/YxFuP4jfFddEuZqKzM62+iXLAhSQOZaZvrxKV04Ji16tO0TSUT8f50
         1UjjSTBaA54EI2pOQii8/Coo/BAltJlEi0UdK++n9oKTXfcrFuTGp2wBtaiAlSPsHjx9
         duxaxbtVtxD4ngVn/cSB5trDFNkvlTp4J2EOMXJFEvVNMDfjke1w8h5Cj8Bb/Ed4pJ7I
         c+fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BSpAfqkgDPepZQ3GfNve5U7U5lObdzccs8al+a/vxj0=;
        b=x/vnuBwhyNEhcb7VMk7RMxu/Af9hn7aCf0IJFeIHuz6oz5PijfjGDn4rNpY1u3J8O0
         fVJFUQpu2x91Goahe/s6UG96lpc+DYa8dpri6IpEK5XgV39lxM6q5+bMx5bN0gnoxmT4
         2aBA1cUa8kWgCBdFzbL3EttPkXRdwZgqdJn7TOvOD0k3NPDB6v6/rM/LiyLCDr9u5r0f
         g+Y3dP+6uVwYlLAeG7IPxoqjRE/jzUMDVg+HUCNN0pPQHdmWZvVmgCguAyM++XARH47u
         I+KowqhTwkfLqzNkJeJjN+VMypYyRjMUVsQpnwmUEZimXZEnJrPsq8zL85TqExM038Uk
         IX6g==
X-Gm-Message-State: AOAM532zkvUrV5B3IDtzmH4d+V/LEuqz/dQM0K5vfEgbT4dW3rq8gsYJ
        wAXWNoAiARVt8ux/923BqCYB/fX+ZGw=
X-Google-Smtp-Source: ABdhPJy7cR2TZgBjVDra3SULaeyL51sytbKil2sKTuW6jFcSH9HYTe/YDMGM7AUNc0n6mmrOs2JYeA==
X-Received: by 2002:a17:903:2283:b0:13e:acd8:86c2 with SMTP id b3-20020a170903228300b0013eacd886c2mr427722plh.78.1633363305523;
        Mon, 04 Oct 2021 09:01:45 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:01:45 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 18/52] KVM: PPC: Book3S HV P9: Move SPRG restore to restore_p9_host_os_sprs
Date:   Tue,  5 Oct 2021 02:00:15 +1000
Message-Id: <20211004160049.1338837-19-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
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
index 1c5b81bd02c1..fca89ed2244f 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4093,6 +4093,8 @@ static void save_p9_host_os_sprs(struct p9_host_os_sprs *host_os_sprs)
 static void restore_p9_host_os_sprs(struct kvm_vcpu *vcpu,
 				    struct p9_host_os_sprs *host_os_sprs)
 {
+	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
+
 	mtspr(SPRN_PSPB, 0);
 	mtspr(SPRN_UAMOR, 0);
 
@@ -4293,8 +4295,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	timer_rearm_host_dec(tb);
 
-	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
-
 	kvmppc_subcore_exit_guest();
 
 	return trap;
-- 
2.23.0

