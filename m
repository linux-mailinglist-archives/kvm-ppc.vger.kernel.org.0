Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD955AFC03
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Sep 2019 13:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbfIKL7Z (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Sep 2019 07:59:25 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:46265 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727121AbfIKL7Z (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 11 Sep 2019 07:59:25 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 46T0n70WYmz9sNx; Wed, 11 Sep 2019 21:59:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1568203163;
        bh=Ug7u/HQGkSwDLHWHp5/4EK9Pu+ixbz3YSDtnNvf3jWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nccu4sUwdhEKYvPd/IPsMifrzVggF7dmEuU7ayhTa133cgCYNB+r+6CXapgygLw/e
         Rt9I64+NfjhvACXvuxDlJTXZWhzFkA00weUOK/Uvv67t3NGV6qYbicm8lwUzPJGnV/
         vx+BiFANmLQQSctTtg+TxQJRcMWR2hzqeUlKk1tLrLY/4EExZBOfqx48Gn9wHemCNQ
         b/k8N32+UPSrxJ9UPC43r6C8X5bbPT3NaJ/qAugUkORrNP4XM5YSWHxtK16jZal1bU
         YXW9grLmYAVj1ulgTgO9RAdFtB130mSIR6VDe5/tfj0WDwgdiiJTLc1/GGZao9liTS
         PqvS0pLNRnc2g==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     linuxppc-dev@ozlabs.org
Cc:     cai@lca.pw, kvm-ppc@vger.kernel.org
Subject: [PATCH 4/4] powerpc/kvm: Add ifdefs around template code
Date:   Wed, 11 Sep 2019 21:57:46 +1000
Message-Id: <20190911115746.12433-4-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190911115746.12433-1-mpe@ellerman.id.au>
References: <20190911115746.12433-1-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Some of the templates used for KVM patching are only used on certain
platforms, but currently they are always built-in, fix that.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/kernel/kvm_emul.S | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/powerpc/kernel/kvm_emul.S b/arch/powerpc/kernel/kvm_emul.S
index 9dd17dce10a1..7af6f8b50c5d 100644
--- a/arch/powerpc/kernel/kvm_emul.S
+++ b/arch/powerpc/kernel/kvm_emul.S
@@ -192,6 +192,8 @@
 kvm_emulate_mtmsr_len:
 	.long (kvm_emulate_mtmsr_end - kvm_emulate_mtmsr) / 4
 
+#ifdef CONFIG_BOOKE
+
 /* also used for wrteei 1 */
 .global kvm_emulate_wrtee
 kvm_emulate_wrtee:
@@ -285,6 +287,10 @@
 kvm_emulate_wrteei_0_len:
 	.long (kvm_emulate_wrteei_0_end - kvm_emulate_wrteei_0) / 4
 
+#endif /* CONFIG_BOOKE */
+
+#ifdef CONFIG_PPC_BOOK3S_32
+
 .global kvm_emulate_mtsrin
 kvm_emulate_mtsrin:
 
@@ -334,6 +340,8 @@
 kvm_emulate_mtsrin_len:
 	.long (kvm_emulate_mtsrin_end - kvm_emulate_mtsrin) / 4
 
+#endif /* CONFIG_PPC_BOOK3S_32 */
+
 	.balign 4
 	.global kvm_tmp
 kvm_tmp:
-- 
2.21.0

