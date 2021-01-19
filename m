Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7FF2FB4C5
	for <lists+kvm-ppc@lfdr.de>; Tue, 19 Jan 2021 10:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbhASJEi (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 19 Jan 2021 04:04:38 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:17536 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730612AbhASJEO (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 19 Jan 2021 04:04:14 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4DKjP81Cfjz9txSb;
        Tue, 19 Jan 2021 10:03:24 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id XQKW7MRXoPXn; Tue, 19 Jan 2021 10:03:24 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4DKjP74myHz9txSZ;
        Tue, 19 Jan 2021 10:03:23 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id A46158B7B8;
        Tue, 19 Jan 2021 10:03:24 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id FrUXJlyGBR-b; Tue, 19 Jan 2021 10:03:24 +0100 (CET)
Received: from po16121vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 4E0728B7B7;
        Tue, 19 Jan 2021 10:03:24 +0100 (CET)
Received: by po16121vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id D4B716639E; Tue, 19 Jan 2021 06:36:52 +0000 (UTC)
Message-Id: <74461a99fa1466f361532ca794ca0753be3d9f86.1611038044.git.christophe.leroy@csgroup.eu>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH] powerpc/kvm: Force selection of CONFIG_PPC_FPU
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org
Date:   Tue, 19 Jan 2021 06:36:52 +0000 (UTC)
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

book3s/32 kvm is designed with the assumption that
an FPU is always present.

Force selection of FPU support in the kernel when
build KVM.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 7d68c8916950 ("powerpc/32s: Allow deselecting CONFIG_PPC_FPU on mpc832x")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 arch/powerpc/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 549591d9aaa2..e45644657d49 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -54,6 +54,7 @@ config KVM_BOOK3S_32
 	select KVM
 	select KVM_BOOK3S_32_HANDLER
 	select KVM_BOOK3S_PR_POSSIBLE
+	select PPC_FPU
 	help
 	  Support running unmodified book3s_32 guest kernels
 	  in virtual machines on book3s_32 host processors.
-- 
2.25.0

