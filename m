Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABB93AF504
	for <lists+kvm-ppc@lfdr.de>; Mon, 21 Jun 2021 20:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhFUS2F (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 21 Jun 2021 14:28:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231740AbhFUS2E (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 21 Jun 2021 14:28:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDD606054E;
        Mon, 21 Jun 2021 18:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624299950;
        bh=xDbIiO2U9PPPDA8IGdGJB0YSQtthnxnEYlLcPl6LzZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GkIXifskbHUdNDMnLgqEC7yGxDgDNaOjFv4ijENR4xtQgB4IlqFLUhws3uDzaHCAe
         oe754NLbUUOcWj8kGxvcSm+XpWorxq6SUN6Ee14MNuAeX2JFP60a2iqEb+t//jGEEs
         exv5CxQf4pNUkVEwnLYWX7hYx/jD90o5aq2EYafYxfmvu+gl5Wpo47O7L067tHUti2
         85BH/cU89909Y7F8tI3r/ezdg6IUWHAyX1Y3QP47u0VdMtFy7G5y/YPtgSLbXOLNTC
         M7C78CmwvzltAta+/dJw/R5UIFidoUHlvBzsIGbsb/aex5Cd8wbwxxomH7JrUuoryt
         V8fro9fatTHoQ==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nicholas Piggin <npiggin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] KVM: PPC: Book3S HV: Workaround high stack usage with clang
Date:   Mon, 21 Jun 2021 11:24:40 -0700
Message-Id: <20210621182440.990242-1-nathan@kernel.org>
X-Mailer: git-send-email 2.32.0.93.g670b81a890
In-Reply-To: <YNDUEoanTqvayZ5P@archlinux-ax161>
References: <YNDUEoanTqvayZ5P@archlinux-ax161>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

LLVM does not emit optimal byteswap assembly, which results in high
stack usage in kvmhv_enter_nested_guest() due to the inlining of
byteswap_pt_regs(). With LLVM 12.0.0:

arch/powerpc/kvm/book3s_hv_nested.c:289:6: error: stack frame size of
2512 bytes in function 'kvmhv_enter_nested_guest' [-Werror,-Wframe-larger-than=]
long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
     ^
1 error generated.

While this gets fixed in LLVM, mark byteswap_pt_regs() as
noinline_for_stack so that it does not get inlined and break the build
due to -Werror by default in arch/powerpc/. Not inlining saves
approximately 800 bytes with LLVM 12.0.0:

arch/powerpc/kvm/book3s_hv_nested.c:290:6: warning: stack frame size of
1728 bytes in function 'kvmhv_enter_nested_guest' [-Wframe-larger-than=]
long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
     ^
1 warning generated.

Link: https://github.com/ClangBuiltLinux/linux/issues/1292
Link: https://bugs.llvm.org/show_bug.cgi?id=49610
Link: https://lore.kernel.org/r/202104031853.vDT0Qjqj-lkp@intel.com/
Link: https://gist.github.com/ba710e3703bf45043a31e2806c843ffd
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/powerpc/kvm/book3s_hv_nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 60724f674421..1b3ff0af1264 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -53,7 +53,8 @@ void kvmhv_save_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
 	hr->dawrx1 = vcpu->arch.dawrx1;
 }
 
-static void byteswap_pt_regs(struct pt_regs *regs)
+/* Use noinline_for_stack due to https://bugs.llvm.org/show_bug.cgi?id=49610 */
+static noinline_for_stack void byteswap_pt_regs(struct pt_regs *regs)
 {
 	unsigned long *addr = (unsigned long *) regs;
 

base-commit: 4a21192e2796c3338c4b0083b494a84a61311aaf
-- 
2.32.0.93.g670b81a890

