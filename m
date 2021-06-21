Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7B23AE65C
	for <lists+kvm-ppc@lfdr.de>; Mon, 21 Jun 2021 11:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhFUJsZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 21 Jun 2021 05:48:25 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:50343 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230232AbhFUJsW (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 21 Jun 2021 05:48:22 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G7l5p14q7z9sWl;
        Mon, 21 Jun 2021 19:46:06 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1624268767;
        bh=zDzQjEJQlnW0AJBiTTf601+r5jzUK+G3QgDwx54BkK0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=qjIZKqzuVKzDihFui4DV1KheP3BPWR56Q/6p+6qiZi+vnedd/MECR/fXTc9tK4mYx
         IpRIjW+7+tbXx828oIQigq98zGkLFzLdzks7imElRprN544FHncgm+IvOX1shLi6He
         P/6jcowPWkv0csld3wtXJcNRseiLg/6J5OYDIXTZPUnFTX+uc0nDTk+aSbo8LSv9RH
         nxH7t+y8JRxeZVRX6G3v7ZADUzZropfsglV42NGb32U9ibhh5SiStFHbYYLlGCrm0L
         2O/HtwWgYlhRdA8sCSramN5Qs5jJ65ODMxkj4WzU4ry8DU84wtGg8rAG3CnyguPorv
         OCHI1jXgTb2rg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Nathan Chancellor <nathan@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        kernel test robot <lkp@intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        clang-built-linux@googlegroups.com, kbuild-all@lists.01.org,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: arch/powerpc/kvm/book3s_hv_nested.c:264:6: error: stack frame
 size of 2304 bytes in function 'kvmhv_enter_nested_guest'
In-Reply-To: <e6167885-30e5-d149-bcde-3e9ad9f5d381@kernel.org>
References: <202104031853.vDT0Qjqj-lkp@intel.com>
 <1624232938.d90brlmh3p.astroid@bobo.none>
 <e6167885-30e5-d149-bcde-3e9ad9f5d381@kernel.org>
Date:   Mon, 21 Jun 2021 19:46:03 +1000
Message-ID: <87im273604.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nathan Chancellor <nathan@kernel.org> writes:
> On 6/20/2021 4:59 PM, Nicholas Piggin wrote:
>> Excerpts from kernel test robot's message of April 3, 2021 8:47 pm:
>>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>>> head:   d93a0d43e3d0ba9e19387be4dae4a8d5b175a8d7
>>> commit: 97e4910232fa1f81e806aa60c25a0450276d99a2 linux/compiler-clang.h: define HAVE_BUILTIN_BSWAP*
>>> date:   3 weeks ago
>>> config: powerpc64-randconfig-r006-20210403 (attached as .config)
>>> compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project 0fe8af94688aa03c01913c2001d6a1a911f42ce6)
>>> reproduce (this is a W=1 build):
>>>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>>>          chmod +x ~/bin/make.cross
>>>          # install powerpc64 cross compiling tool for clang build
>>>          # apt-get install binutils-powerpc64-linux-gnu
>>>          # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=97e4910232fa1f81e806aa60c25a0450276d99a2
>>>          git remote add linus https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>>>          git fetch --no-tags linus master
>>>          git checkout 97e4910232fa1f81e806aa60c25a0450276d99a2
>>>          # save the attached .config to linux build tree
>>>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=powerpc64
>>>
>>> If you fix the issue, kindly add following tag as appropriate
>>> Reported-by: kernel test robot <lkp@intel.com>
>>>
>>> All errors (new ones prefixed by >>):
>>>
>>>>> arch/powerpc/kvm/book3s_hv_nested.c:264:6: error: stack frame size of 2304 bytes in function 'kvmhv_enter_nested_guest' [-Werror,-Wframe-larger-than=]
>>>     long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
>>>          ^
>>>     1 error generated.
>>>
>>>
>>> vim +/kvmhv_enter_nested_guest +264 arch/powerpc/kvm/book3s_hv_nested.c
>> 
>> Not much changed here recently. It's not that big a concern because it's
>> only called in the KVM ioctl path, not in any deep IO paths or anything,
>> and doesn't recurse. Might be a bit of inlining or stack spilling put it
>> over the edge.
>
> It appears to be the fact that LLVM's PowerPC backend does not emit 
> efficient byteswap assembly:
>
> https://github.com/ClangBuiltLinux/linux/issues/1292
>
> https://bugs.llvm.org/show_bug.cgi?id=49610
>
>> powerpc does make it an error though, would be good to avoid that so the
>> robot doesn't keep tripping over.
>
> Marking byteswap_pt_regs as 'noinline_for_stack' drastically reduces the 
> stack usage. If that is an acceptable solution, I can send it along 
> tomorrow.

Yeah that should be OK. Can you post the before/after disassembly when
you post the patch?

It should just be two extra function calls, which shouldn't be enough
overhead to be measurable.

cheers
