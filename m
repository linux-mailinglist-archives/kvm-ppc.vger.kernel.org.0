Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60812AA669
	for <lists+kvm-ppc@lfdr.de>; Sat,  7 Nov 2020 16:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgKGPto (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 7 Nov 2020 10:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgKGPto (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 7 Nov 2020 10:49:44 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5583EC0613CF
        for <kvm-ppc@vger.kernel.org>; Sat,  7 Nov 2020 07:49:44 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id r9so929489pjl.5
        for <kvm-ppc@vger.kernel.org>; Sat, 07 Nov 2020 07:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7/TyYiy/5YMk+mjNioNCBNSjuP8QdrV8gyWB7vm7Ee4=;
        b=avtEcUhNqqjSLS+EfsY67zoE0Imvh3Z3/y6Wsw5xHsCv73Hd4peccJ36/5aVb323I3
         5oCoomgspQUWmEb13n/G5tmvMcW8WmJiGjld9PjBt26OZW1EnEB6GwI9Ns3qufY4ufVp
         ErvInhBCZgV6lxRIa1lDHBn4upauaOGfb0xU7sadmgK3Rq7fPIs6+tXrJXQo2J+bxs25
         LhUAq70ib5Ym486IWNzK0x1y2ed2HwM8DlQF/GAIpJycqGs+yQ0DbQNGA+Dy+pBLWFpU
         1pkpONzVXpA2FmeoZYAU3W3s5/Rcij4bt92aLCZ9FoB8qRXWUDOFMkMkmmvr98tAJ+pB
         vjKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7/TyYiy/5YMk+mjNioNCBNSjuP8QdrV8gyWB7vm7Ee4=;
        b=G8bpg61Xi2/OekX0esoZmf2D1yCMA0xoPo2vEfCr/lPovNIKDIW3XxF/02LaQv4eva
         NBLRaJJnGL63EugB2z1NERF4Aue+UlK5vjtdmdxXRRGlP3YUfMvmTsGZpGHfzdVYIGQq
         0a+lNWGlLxuI+1AaluO2vIlKF9dxbxYTh728/IeR2QP/8WjeK7En+CdyHzJVHfEnQ3u5
         POmqpH/dxxoCCPp1NF/kt3qzgdrSdKxhgGb6ur/mjsrxq5KGG9Wg8j8O0xhtjnv3SZ9m
         Ulae+c8yPXCObSlOcxGFd6KKJ41L5v9tEZ0F/CeoOV15uUFj9FHPQTv6a+GU0xhmCnGK
         cFFQ==
X-Gm-Message-State: AOAM530J8E5v3Hn7LPqzEuVSNn5pLR3hkfPpj6InI9Ve5kgTk8darGET
        yK+xgVibDYBwgobuabefkKEqx7ZtE6G2
X-Google-Smtp-Source: ABdhPJyPrKkZuv82wY4VNPDIZFDkA2Whl8MeIKe3R/fJUILTiZOJueiDHikEWqrDBbQdM+Gv0T8rxA==
X-Received: by 2002:a17:902:724c:b029:d5:c1de:e34e with SMTP id c12-20020a170902724cb02900d5c1dee34emr5947456pll.71.1604764183921;
        Sat, 07 Nov 2020 07:49:43 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id u24sm6317375pfm.81.2020.11.07.07.49.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Nov 2020 07:49:43 -0800 (PST)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     paulus@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] KVM: PPC: fix comparison to bool warning
Date:   Sat,  7 Nov 2020 23:49:38 +0800
Message-Id: <1604764178-8087-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Fix the following coccicheck warning:

./arch/powerpc/kvm/booke.c:503:6-16: WARNING: Comparison to bool
./arch/powerpc/kvm/booke.c:505:6-17: WARNING: Comparison to bool
./arch/powerpc/kvm/booke.c:507:6-16: WARNING: Comparison to bool

Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 arch/powerpc/kvm/booke.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index b1abcb816439..288a9820ec01 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -500,11 +500,11 @@ static int kvmppc_booke_irqprio_deliver(struct kvm_vcpu *vcpu,
 
 		vcpu->arch.regs.nip = vcpu->arch.ivpr |
 					vcpu->arch.ivor[priority];
-		if (update_esr == true)
+		if (update_esr)
 			kvmppc_set_esr(vcpu, vcpu->arch.queued_esr);
-		if (update_dear == true)
+		if (update_dear)
 			kvmppc_set_dar(vcpu, vcpu->arch.queued_dear);
-		if (update_epr == true) {
+		if (update_epr) {
 			if (vcpu->arch.epr_flags & KVMPPC_EPR_USER)
 				kvm_make_request(KVM_REQ_EPR_EXIT, vcpu);
 			else if (vcpu->arch.epr_flags & KVMPPC_EPR_KERNEL) {
-- 
2.20.0

