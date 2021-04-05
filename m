Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21CC353AB7
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbhDEBWr (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbhDEBWk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:22:40 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08339C061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:22:32 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso5060109pjb.3
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cVXXJ3+5eVqba9QwRIR5tmg1j34fukVhUGM2jj9knwc=;
        b=UxFd1TiplL4W9TdnF/sfU53l0ZIm0lAMZUDx586IddSoDglNkbBjurTTb2jD/AhcfF
         vPb2ju32VhDtbAvA+TL1CP9eFFhmD4qdRlPCOySJBjm5pyCe1EReVkS2pgAgGRz1qXBd
         5/nuhxcWK1a8BLblxevjuX4oo7lbaSoRd+vF6VOMM3vU9aoVrHHugjzCFLk64Oav63TZ
         CoBdFzIA02joFVcbOzrnwUeqLKUsdJBMSnsBhME+dMk/sMSIS3V+1MQ54vHiqTyNH1BG
         cZOojORn6+0CnoOvhdRsoA5nVccISmXsg/xuRARGeZxG78jfk4Nmlb4gGEADtLgXm7a1
         w0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cVXXJ3+5eVqba9QwRIR5tmg1j34fukVhUGM2jj9knwc=;
        b=ew81iKyHKtFcHmE4wEXkAujnn6YMTQA65W6bTRetuqMc0R7+w+zzl6+heF7+e7McPi
         aSYwEa66dDjxBurhEcAAvqOCXH8QEvpON38yx2wOJ1I9sPP/kGM6PzqFS4Gfmi0kwADj
         Jg50z2WhEO9Evlnj9rgtXX+JLF4DkrAO2/FhOPDdRmAWlRgpZeXiq1LokweSuw9qaVW5
         3a01wPoGRNNfFUBEV49YzPeY6nIdLSGmHD0vwSeOF2r7C87ei3QNVxqR5CtB1oSXO5V2
         1HwNUitbDLryCu81G2dtlY2/wNEmIJrG21msnPquaaf/vbUmpTlNON3h2dYw+EuxNrop
         M3rQ==
X-Gm-Message-State: AOAM530euBEMKvBTF6Cd+Om7EFKTz+l9aOylejtTnDw5v6twYQsMCS3O
        nuxEz0RsBissEkb3qdLdEiVOVGX5Sa14HQ==
X-Google-Smtp-Source: ABdhPJyiPcFFg3gpUzlKShVVdy22TWMQoFv79DmwmX+Zci1OAOGbGS+7VdZgO1zPtQU9sdcmg3FtzA==
X-Received: by 2002:a17:90b:1b42:: with SMTP id nv2mr24097499pjb.190.1617585751512;
        Sun, 04 Apr 2021 18:22:31 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:22:31 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v6 45/48] KVM: PPC: Book3S HV P9: Reflect userspace hcalls to hash guests to support PR KVM
Date:   Mon,  5 Apr 2021 11:19:45 +1000
Message-Id: <20210405011948.675354-46-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
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
index d8e36f1ea66d..7cd97e6757e5 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1455,13 +1455,23 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
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

