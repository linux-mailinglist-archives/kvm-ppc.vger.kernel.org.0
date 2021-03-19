Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C124B3422C4
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Mar 2021 18:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhCSRCI (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Mar 2021 13:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230319AbhCSRB7 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 19 Mar 2021 13:01:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F51E61957;
        Fri, 19 Mar 2021 17:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616173319;
        bh=ImJ7NjjGCPlZokQB3RH+hBE4XrmgjZ3pX+lrjICInmY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EZjC4EUQqojgUbpm9ey6k8xabzOi8GzCd+175xrM+TaWfDx2n3DtZ9PXIOHlW/fRm
         ts5GuTm3zXmsj5+gFQFUU+BuPwv701r6pl+8FsZ3NxpMVQor/HQEEf1Q9WG8+pgcEw
         3CjMadwyadoQ8Jz40KUaGx2WEs9XoXPCEV3J3D38JE0dx9UdAx+Fv1pYCkkT5/WQ0r
         JjxbgPGioA/FVjj2QKb9SkZtFCQ5lh1dSVkkeamOAO4zyMtldrt0lykY17fNTu4Qsw
         KlgmOoXESM2sb357PrF5DPa6tdUsZI1LtVCVRuo3sFrWDOvD8v8z7AB16sA1pHZ9kN
         XCYAhlcQPXjbg==
Date:   Fri, 19 Mar 2021 10:01:54 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     clang-built-linux <clang-built-linux@googlegroups.com>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        kvm-ppc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: Clang: powerpc: kvm/book3s_hv_nested.c:264:6: error: stack frame
 size of 2480 bytes in function 'kvmhv_enter_nested_guest'
Message-ID: <20210319170154.oe5sa6ohjbyucbws@archlinux-ax161>
References: <CA+G9fYu=a0pk79He2DoQ9NGHkbG58PMhqJsEk=xiQv+v495Dmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYu=a0pk79He2DoQ9NGHkbG58PMhqJsEk=xiQv+v495Dmw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Naresh,

Thank you for the testing and report.

On Fri, Mar 19, 2021 at 12:50:42PM +0530, Naresh Kamboju wrote:
> Linux mainline master build breaks for powerpc defconfig.
> There are multiple errors / warnings with clang-12 and clang-11 and 10.
>  - powerpc (defconfig) with clang-12
>  - powerpc (defconfig) with clang-11
>  - powerpc (defconfig) with clang-10
> 
> The following build errors / warnings triggered with clang-12.
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp LLVM=1 ARCH=powerpc
> CROSS_COMPILE=powerpc64le-linux-gnu- 'HOSTCC=sccache clang'
> 'CC=sccache clang'
> /builds/linux/arch/powerpc/kvm/book3s_hv_nested.c:264:6: error: stack
> frame size of 2480 bytes in function 'kvmhv_enter_nested_guest'
> [-Werror,-Wframe-larger-than=]
> long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
>      ^
> 1 error generated.
> make[3]: *** [/builds/linux/scripts/Makefile.build:271:
> arch/powerpc/kvm/book3s_hv_nested.o] Error 1
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Yes, unfortunately, this is a clang-12 regression that was exposed by
commit 97e4910232fa ("linux/compiler-clang.h: define HAVE_BUILTIN_BSWAP*")
and it is being tracked on both our GitHub issue tracker and LLVM's
bugzilla:

https://github.com/ClangBuiltLinux/linux/issues/1292
https://bugs.llvm.org/show_bug.cgi?id=49610

Once it has been sorted out, we can potentially work around that by just
raising the limit for that particular file (not sure what the PowerPC
maintainers will want to do).

> The following build errors / warnings triggered with clang-10 and clang-11.
>  - powerpc (defconfig) with clang-11
>  - powerpc (defconfig) with clang-10
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp LLVM=1 ARCH=powerpc
> CROSS_COMPILE=powerpc64le-linux-gnu- 'HOSTCC=sccache clang'
> 'CC=sccache clang'
> 
> /usr/bin/powerpc64le-linux-gnu-ld:
> arch/powerpc/kernel/vdso32/sigtramp.o: compiled for a little endian
> system and target is big endian
> /usr/bin/powerpc64le-linux-gnu-ld: failed to merge target specific
> data of file arch/powerpc/kernel/vdso32/sigtramp.o
> /usr/bin/powerpc64le-linux-gnu-ld:
> arch/powerpc/kernel/vdso32/gettimeofday.o: compiled for a little
> endian system and target is big endian
> /usr/bin/powerpc64le-linux-gnu-ld: failed to merge target specific
> data of file arch/powerpc/kernel/vdso32/gettimeofday.o
> /usr/bin/powerpc64le-linux-gnu-ld:
> arch/powerpc/kernel/vdso32/datapage.o: compiled for a little endian
> system and target is big endian
> /usr/bin/powerpc64le-linux-gnu-ld: failed to merge target specific
> data of file arch/powerpc/kernel/vdso32/datapage.o
> /usr/bin/powerpc64le-linux-gnu-ld:
> arch/powerpc/kernel/vdso32/cacheflush.o: compiled for a little endian
> system and target is big endian
> /usr/bin/powerpc64le-linux-gnu-ld: failed to merge target specific
> data of file arch/powerpc/kernel/vdso32/cacheflush.o
> /usr/bin/powerpc64le-linux-gnu-ld: arch/powerpc/kernel/vdso32/note.o:
> compiled for a little endian system and target is big endian
> /usr/bin/powerpc64le-linux-gnu-ld: failed to merge target specific
> data of file arch/powerpc/kernel/vdso32/note.o
> /usr/bin/powerpc64le-linux-gnu-ld:
> arch/powerpc/kernel/vdso32/getcpu.o: compiled for a little endian
> system and target is big endian
> /usr/bin/powerpc64le-linux-gnu-ld: failed to merge target specific
> data of file arch/powerpc/kernel/vdso32/getcpu.o
> /usr/bin/powerpc64le-linux-gnu-ld:
> arch/powerpc/kernel/vdso32/vgettimeofday.o: compiled for a little
> endian system and target is big endian
> /usr/bin/powerpc64le-linux-gnu-ld: failed to merge target specific
> data of file arch/powerpc/kernel/vdso32/vgettimeofday.o
> clang: error: unable to execute command: Segmentation fault (core dumped)
> clang: error: linker command failed due to signal (use -v to see invocation)
> make[2]: *** [/builds/linux/arch/powerpc/kernel/vdso32/Makefile:51:
> arch/powerpc/kernel/vdso32/vdso32.so.dbg] Error 254
> make[2]: Target 'include/generated/vdso32-offsets.h' not remade
> because of errors.
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> 
> build link,
> https://gitlab.com/Linaro/lkft/mirrors/torvalds/linux-mainline/-/jobs/1110841371#L59
> 

This is a deficiency in clang that has been fixed in clang-12:

https://github.com/llvm/llvm-project/commit/0a23fbd28c7509f2f980946091e6055bf27164d2

but tuxmake can resolve it by using a more appropriate CROSS_COMPILE
variable for powerpc64 big-endian (powerpc64-linux-gnu-):

https://gitlab.com/Linaro/tuxmake/-/issues/108

Cheers,
Nathan
