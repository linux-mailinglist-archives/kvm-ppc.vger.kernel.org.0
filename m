Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA0E393F86
	for <lists+kvm-ppc@lfdr.de>; Fri, 28 May 2021 11:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbhE1JKv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 28 May 2021 05:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235925AbhE1JKr (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 28 May 2021 05:10:47 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CB1C06138D
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:09:12 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id m8-20020a17090a4148b029015fc5d36343so2167057pjg.1
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r5usDmW6ESlSNZYJloJenDWYeT5fTs1KfX9oWvwN0Tg=;
        b=T4l6vfKOzrTwgLtf4lwiNSgAdN7Ofkwn++hG1WFYmxPm5SM+XFBIrTYHqQXTl01vTM
         U7zPBEptuSnLPCdcH/cLXkyWZzBL7/xn6PTeESp0wTaTuoQzypo+2/XUfMnq8heVvMva
         MyvWK0eqDBWJkOVK1yNqCijufVZKAilnbwv4FHykZi4zQzfBmGzYqCxi4g216DfO51OQ
         fF6zOiQbCdN6vX1/5tAN3AelM1hOCX8BX6Z2Kbf4yOGHp5kM3hqb5krsbpZ0HovwGA81
         lqMNX1SMILIVzwCivCpkWXYg4kZzg/8ugA+hzrSXbSg1RHAEOA2R9ChDUlDgw3vw/cq8
         Cm4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r5usDmW6ESlSNZYJloJenDWYeT5fTs1KfX9oWvwN0Tg=;
        b=VQI9bxSDXTcFcdw0PscSHpw0pZoeRi+31p6irFM5Ck4ShWn/CJW4x5NuKm9xub75Xx
         OcCNwEM39BGj63I0zXwOj340pd/drSBK3FhHHxAxfLOaf0lIEr7IgLTUxkEUJCN8krh3
         2zQYJcflKfA8k4/HmrWahr6OM6m0AgQvxpKHqc38C6f5GhSgs625X8DbIY+in9xU3W57
         3ge22sVebvx2UpAf3k/AiR+0QxGT2Fmp537SyfGd2o2qFRJ+xTCxzwn/8qVLKKF1HTiw
         xpYfXxgdO6L4barnwSFe6p5o+22K9Wb8YYCyWvQg0e2iGGyTzm3wNxsv9PV3h5hINJng
         hjfg==
X-Gm-Message-State: AOAM530WN9wzk2fy6QK+kqldR7NuwWUZG1bfEo2uCHdwyX/CvUKhjwmy
        F8v9fm+apjS2Y+OBJLirF01hVjCHY+8=
X-Google-Smtp-Source: ABdhPJxg3py6r6PbIYgriPSH4VxMmO5Hz4JTIfPWk36XWCKecIn01YQwl8VGeTZO7cy61V8Emi8hRg==
X-Received: by 2002:a17:90a:ba07:: with SMTP id s7mr3290362pjr.129.1622192952110;
        Fri, 28 May 2021 02:09:12 -0700 (PDT)
Received: from bobo.ibm.com (124-169-110-219.tpgi.com.au. [124.169.110.219])
        by smtp.gmail.com with ESMTPSA id a2sm3624183pfv.156.2021.05.28.02.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 02:09:11 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v7 29/32] KVM: PPC: Book3S HV P9: Reflect userspace hcalls to hash guests to support PR KVM
Date:   Fri, 28 May 2021 19:07:49 +1000
Message-Id: <20210528090752.3542186-30-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210528090752.3542186-1-npiggin@gmail.com>
References: <20210528090752.3542186-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The reflection of sc 1 interrupts from guest PR=1 to the guest kernel is
required to support a hash guest running PR KVM where its guest is
making hcalls with sc 1.

In preparation for hash guest support, add this hcall reflection to the
P9 path. The P7/8 path does this in its realmode hcall handler
(sc_1_fast_return).

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index dee740a3ace9..493f67f27d06 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1457,13 +1457,23 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 			 * Guest userspace executed sc 1. This can only be
 			 * reached by the P9 path because the old path
 			 * handles this case in realmode hcall handlers.
-			 *
-			 * Radix guests can not run PR KVM or nested HV hash
-			 * guests which might run PR KVM, so this is always
-			 * a privilege fault. Send a program check to guest
-			 * kernel.
 			 */
-			kvmppc_core_queue_program(vcpu, SRR1_PROGPRIV);
+			if (!kvmhv_vcpu_is_radix(vcpu)) {
+				/*
+				 * A guest could be running PR KVM, so this
+				 * may be a PR KVM hcall. It must be reflected
+				 * to the guest kernel as a sc interrupt.
+				 */
+				kvmppc_core_queue_syscall(vcpu);
+			} else {
+				/*
+				 * Radix guests can not run PR KVM or nested HV
+				 * hash guests which might run PR KVM, so this
+				 * is always a privilege fault. Send a program
+				 * check to guest kernel.
+				 */
+				kvmppc_core_queue_program(vcpu, SRR1_PROGPRIV);
+			}
 			r = RESUME_GUEST;
 			break;
 		}
-- 
2.23.0

