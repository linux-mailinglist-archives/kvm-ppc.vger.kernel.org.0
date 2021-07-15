Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAD33C9F37
	for <lists+kvm-ppc@lfdr.de>; Thu, 15 Jul 2021 15:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236799AbhGONSV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 15 Jul 2021 09:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbhGONSV (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 15 Jul 2021 09:18:21 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F753C06175F
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Jul 2021 06:15:28 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id y4so5194366pfi.9
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Jul 2021 06:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dg+kECwAuBShufULtVDvhwFWlxHBpA5vuIilKUWCHKw=;
        b=NG2gZrORvpOx1ukjrrzSAx3vIGo65+AokhbSqsqCW+ATo/Fc3r3a8483nr08C+CKNm
         T4heEkQjD+3daIkQKXPGMMSFXPdBy/aIfzuBbeKRg2h9bRzXKe1zGJNSWL3Mne/fEEBu
         HApJ0QcRVqS9vf52yr2VJrTsJChSvAh1wFwRt6BYBN8EoqjEAWfEiCFU7/TkZT6UgCR/
         xaAcjH7QATyIohzEZKdM1arlHoh3CKrCiNr32iEf+j/a4khT6qgfp/nHv/IE+ZTdVGc0
         FGOx+Y8ryfIlrSpkYm0/1l9SVORCAxxhe9rRPUNc8LyPaRj8sdFV8G8qFdSMuTxFLxGf
         IEyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dg+kECwAuBShufULtVDvhwFWlxHBpA5vuIilKUWCHKw=;
        b=MtTU+tXPPvEl76sDhbtkvA17ZROF2FPRKCy0yXlSrR5AIQpX/RxS4ijCa1nhue7iBk
         c3zWIz1/7RSn3GzOpRXp3NQ/qobaY+N4HwanttVqeQavh6daALgTSEb+nqQrWyr4/I6O
         npjL67XwI58+CAtFbQwJAfFloUqwb3sfH9rAKCUDS2pnGpm2Jszmbx2Iw9z6Y82VAWXV
         LCr7uobsMvsS1dAdnS6viXILvrbIHU4lDUEL+wgMddDJDOqQcqGFJR3ICdh4cAaqrAPY
         ZgT4U0UnWEsv2TJ4BmNEo+A3b48qk18S+X98F5OE18Feag2h71V2XW9+RwziMIq7+YS5
         f+YA==
X-Gm-Message-State: AOAM5308/cATW1GEa2/zEK+gU1gw72C4jxDegkFJu5huYl0OFdYKtZny
        yYoTLg6CUVGk9c9NGlLuTQ1KBly7L59qiw==
X-Google-Smtp-Source: ABdhPJwTuWAXRw7sa81YbVR8I3Tp1EmxpLH90UEDYGKD0GbKrm+IKtLnyiBgmLCRrYOaPmHlNwVg6g==
X-Received: by 2002:a05:6a00:1713:b029:332:7eca:41a1 with SMTP id h19-20020a056a001713b02903327eca41a1mr4694625pfc.26.1626354927624;
        Thu, 15 Jul 2021 06:15:27 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (27-33-83-114.tpgi.com.au. [27.33.83.114])
        by smtp.gmail.com with ESMTPSA id k6sm4864216pju.8.2021.07.15.06.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 06:15:27 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 1/6] KVM: PPC: Book3S HV P9: Add unlikely annotation for !mmu_ready
Date:   Thu, 15 Jul 2021 23:15:13 +1000
Message-Id: <20210715131518.146917-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210715131518.146917-1-npiggin@gmail.com>
References: <20210715131518.146917-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The mmu will almost always be ready.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 9d15bbafe333..27a7a856eed1 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4367,7 +4367,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->runner = vcpu;
 
 	/* See if the MMU is ready to go */
-	if (!kvm->arch.mmu_ready) {
+	if (unlikely(!kvm->arch.mmu_ready)) {
 		r = kvmhv_setup_mmu(vcpu);
 		if (r) {
 			run->exit_reason = KVM_EXIT_FAIL_ENTRY;
-- 
2.23.0

