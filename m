Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3101F3B3099
	for <lists+kvm-ppc@lfdr.de>; Thu, 24 Jun 2021 15:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhFXOCN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 24 Jun 2021 10:02:13 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:38331 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229878AbhFXOCN (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 24 Jun 2021 10:02:13 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4G9hbD5jzzz9sVt; Thu, 24 Jun 2021 23:59:52 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nathan Chancellor <nathan@kernel.org>
Cc:     kernel test robot <lkp@intel.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        clang-built-linux@googlegroups.com, kvm-ppc@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nick Desaulniers <ndesaulniers@google.com>
In-Reply-To: <20210621182440.990242-1-nathan@kernel.org>
References: <YNDUEoanTqvayZ5P@archlinux-ax161> <20210621182440.990242-1-nathan@kernel.org>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Workaround high stack usage with clang
Message-Id: <162454315620.2927609.2836123364412705213.b4-ty@ellerman.id.au>
Date:   Thu, 24 Jun 2021 23:59:16 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, 21 Jun 2021 11:24:40 -0700, Nathan Chancellor wrote:
> LLVM does not emit optimal byteswap assembly, which results in high
> stack usage in kvmhv_enter_nested_guest() due to the inlining of
> byteswap_pt_regs(). With LLVM 12.0.0:
> 
> arch/powerpc/kvm/book3s_hv_nested.c:289:6: error: stack frame size of
> 2512 bytes in function 'kvmhv_enter_nested_guest' [-Werror,-Wframe-larger-than=]
> long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
>      ^
> 1 error generated.
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/1] KVM: PPC: Book3S HV: Workaround high stack usage with clang
      https://git.kernel.org/powerpc/c/51696f39cbee5bb684e7959c0c98b5f54548aa34

cheers
