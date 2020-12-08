Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588332D35AF
	for <lists+kvm-ppc@lfdr.de>; Tue,  8 Dec 2020 23:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbgLHV73 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 8 Dec 2020 16:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727958AbgLHV72 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 8 Dec 2020 16:59:28 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9FBC061794;
        Tue,  8 Dec 2020 13:58:48 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id y18so126517qki.11;
        Tue, 08 Dec 2020 13:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G/NMXMjSBkeIHnho7dTPVvi7pj5oBgIZnaCU/I3zMQ0=;
        b=A+ZPhYYidA+pxagEZ71U9PLXKR2ENZsU2cAPqf/cWywzna9sleFqTCgNsklgCl2m2K
         v3ywjeGYg8PvoHfYdt9NBbcoD9MsPMTfetUuqRIz7A4tYrMV+U5kez6ouFsyf70yIdcU
         EYptzInGQ2B9gw3CSzTCgAqHsYMdBXLFeZi/YhENnT73SvXs8JJmVmF0FTtM4Qt8Eb45
         NLs3u4j3l0E4+cf/t6DRoBLRWXUzjUpYSTsXHW7nJsLiwg96mqnLY2fAmV/voeHte4vH
         y7NYTqblDdJYPoA0iKzESYeBuBi5BQSxL2+Xm6TIk4AYf1Ibh2anA9qzix4Od2KvsKX+
         XD5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G/NMXMjSBkeIHnho7dTPVvi7pj5oBgIZnaCU/I3zMQ0=;
        b=kbtchNeM0c7tQ16D+lf0FscQfsarOnHxLIxxxhtZyO66XLzpOiDCTSmkx9MBVRfzoG
         Ecsh/u0n3J8so8Jr90YM80ILiqLXLRcNukQVDnjCrGNJ3axbai8QiSocIOMw7QcsPRV2
         V7x8t20VFNlRFd9WTHjXeOQkcrVeZHhhaXUcZUQa0ZSWvrpmE1oKYODlDdig9Qoiq0ag
         683xBeRtYttO2WLR6Em/U/aeuTz/HesgpTDm2lA8SRZWdeMa9TyerQCJSSbvmE+bjW7q
         /echx5QKcE7aYMuBhujIxaJ/I8JTfOWQX3r2Tfnxikw9NiSY1toAi6Rd50NznzmrYI3C
         18dA==
X-Gm-Message-State: AOAM532YQRRG2yl7BJEGqgmtPY2ENrRyEEXTLKLZed0Qjx6TulC76HqS
        ZJZnx3TLNym2DcetJFGbZT+IdI0WZpc=
X-Google-Smtp-Source: ABdhPJwO4H460UEGuYPNbcYEti5OdjUPd0UKdYp6/7QoqZbPWMUfoX+ZeAyy5sfrywJGz3eB0Pep1A==
X-Received: by 2002:a05:620a:622:: with SMTP id 2mr32323807qkv.436.1607464727640;
        Tue, 08 Dec 2020 13:58:47 -0800 (PST)
Received: from LeoBras.ibmuc.com ([2804:14d:8084:8e41:9b0d:571e:a65:b5d8])
        by smtp.gmail.com with ESMTPSA id w22sm35819qtt.76.2020.12.08.13.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 13:58:46 -0800 (PST)
From:   Leonardo Bras <leobras.c@gmail.com>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     Leonardo Bras <leobras.c@gmail.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] powerpc/kvm: Fix mask size for emulated msgsndp
Date:   Tue,  8 Dec 2020 18:57:08 -0300
Message-Id: <20201208215707.31149-1-leobras.c@gmail.com>
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

The current way of getting 'msgtype', and 't' is missing their MSB:
msgtype: ((arg >> 27) & 0xf) : Gets (RB) 33:36, missing bit 32
t:       (arg &= 0x3f)       : Gets (RB) 58:63, missing bit 57

Fixes this by applying the correct mask.

Signed-off-by: Leonardo Bras <leobras.c@gmail.com>
---
Changes since v1:
- Commit message 's/LSB/MSB/', because ISA ordering is big-endian.

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

