Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373303AF42F
	for <lists+kvm-ppc@lfdr.de>; Mon, 21 Jun 2021 20:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbhFUSHF (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 21 Jun 2021 14:07:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234355AbhFUSFI (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 21 Jun 2021 14:05:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53FC560698;
        Mon, 21 Jun 2021 18:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298519;
        bh=kkst86FkoHM+pRUOoeZDPqsO3ZnzxMS988/ImEZ57Lo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QODfhnKyo0ngjkOIeYBrnKGsMkqNVm66f1zG/7m94jOrmv659GzDGw6t+QxZxuCL8
         L6viQNkCYFvFeTQjdurCYqOJ13GPbxi26WAo+TV3zgmU9+tgLG1b/zWE8hPfXY9T9z
         LE4XiZOpSFQXrjvNKG63mr03i2MiN6fIOPkmjjt1boDFTfsx422lNGAcTqeQDrnWVj
         4mYPzAyTeWuUgRwTy1mMRB7syGJOh1pXyn6/+wMa0aD4Rd6piDnm+WaxFB28ohbUMk
         16F5DZk63cE0D8oQ/fPeqYQp7wE37tE5A3AS7T7TlRKNVzeP6JZCpZqNalFB66i3kv
         3ddJI7/xTyoBQ==
Date:   Mon, 21 Jun 2021 11:01:54 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Nicholas Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        kernel test robot <lkp@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        clang-built-linux@googlegroups.com, kbuild-all@lists.01.org,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: arch/powerpc/kvm/book3s_hv_nested.c:264:6: error: stack frame
 size of 2304 bytes in function 'kvmhv_enter_nested_guest'
Message-ID: <YNDUEoanTqvayZ5P@archlinux-ax161>
References: <202104031853.vDT0Qjqj-lkp@intel.com>
 <1624232938.d90brlmh3p.astroid@bobo.none>
 <e6167885-30e5-d149-bcde-3e9ad9f5d381@kernel.org>
 <87im273604.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87im273604.fsf@mpe.ellerman.id.au>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Jun 21, 2021 at 07:46:03PM +1000, Michael Ellerman wrote:
> Nathan Chancellor <nathan@kernel.org> writes:
> > On 6/20/2021 4:59 PM, Nicholas Piggin wrote:
> >> Excerpts from kernel test robot's message of April 3, 2021 8:47 pm:
> >>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> >>> head:   d93a0d43e3d0ba9e19387be4dae4a8d5b175a8d7
> >>> commit: 97e4910232fa1f81e806aa60c25a0450276d99a2 linux/compiler-clang.h: define HAVE_BUILTIN_BSWAP*
> >>> date:   3 weeks ago
> >>> config: powerpc64-randconfig-r006-20210403 (attached as .config)
> >>> compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project 0fe8af94688aa03c01913c2001d6a1a911f42ce6)
> >>> reproduce (this is a W=1 build):
> >>>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >>>          chmod +x ~/bin/make.cross
> >>>          # install powerpc64 cross compiling tool for clang build
> >>>          # apt-get install binutils-powerpc64-linux-gnu
> >>>          # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=97e4910232fa1f81e806aa60c25a0450276d99a2
> >>>          git remote add linus https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> >>>          git fetch --no-tags linus master
> >>>          git checkout 97e4910232fa1f81e806aa60c25a0450276d99a2
> >>>          # save the attached .config to linux build tree
> >>>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=powerpc64
> >>>
> >>> If you fix the issue, kindly add following tag as appropriate
> >>> Reported-by: kernel test robot <lkp@intel.com>
> >>>
> >>> All errors (new ones prefixed by >>):
> >>>
> >>>>> arch/powerpc/kvm/book3s_hv_nested.c:264:6: error: stack frame size of 2304 bytes in function 'kvmhv_enter_nested_guest' [-Werror,-Wframe-larger-than=]
> >>>     long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
> >>>          ^
> >>>     1 error generated.
> >>>
> >>>
> >>> vim +/kvmhv_enter_nested_guest +264 arch/powerpc/kvm/book3s_hv_nested.c
> >> 
> >> Not much changed here recently. It's not that big a concern because it's
> >> only called in the KVM ioctl path, not in any deep IO paths or anything,
> >> and doesn't recurse. Might be a bit of inlining or stack spilling put it
> >> over the edge.
> >
> > It appears to be the fact that LLVM's PowerPC backend does not emit 
> > efficient byteswap assembly:
> >
> > https://github.com/ClangBuiltLinux/linux/issues/1292
> >
> > https://bugs.llvm.org/show_bug.cgi?id=49610
> >
> >> powerpc does make it an error though, would be good to avoid that so the
> >> robot doesn't keep tripping over.
> >
> > Marking byteswap_pt_regs as 'noinline_for_stack' drastically reduces the 
> > stack usage. If that is an acceptable solution, I can send it along 
> > tomorrow.
> 
> Yeah that should be OK. Can you post the before/after disassembly when
> you post the patch?
> 
> It should just be two extra function calls, which shouldn't be enough
> overhead to be measurable.

The diff is pretty large so I have attached it here along with the full
disassembly of the files before and after the patch I am about to send.
I will reply to this message so the history is there.

Cheers,
Nathan
