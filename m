Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6DE341655
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Mar 2021 08:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbhCSHVI (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Mar 2021 03:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233936AbhCSHUz (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 Mar 2021 03:20:55 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7126C06175F
        for <kvm-ppc@vger.kernel.org>; Fri, 19 Mar 2021 00:20:54 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id va9so8009534ejb.12
        for <kvm-ppc@vger.kernel.org>; Fri, 19 Mar 2021 00:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Qm1M+9iwmqug094Ij1+/BFzpWH81JqUDY9n0PrAzHc4=;
        b=g3ngt0UmUgqJer6ViP+FowVeNeFkFrqOxBsDz+jDSgMDOIUSyI7ffJiYdGH9jmD9G9
         08L4O6bZwNh/c95d7bu/BHFcJgzmi5Ek4tBmED1dVVj11ElITX/OiiAbP6Xa4eaUrrnG
         /SCi+lYvQ7aq1VsQH01ZG4MYn7BK1T1Tdr2bkpmwYHw5uIQJIahkV+KMymc7KTFUrohC
         9KPlXDDfPvLVuTgBGaNldy7WgKxAL1wC3pfB1BQBZEQYQoZdtUXXGvcshe5EhO2efQHW
         hoX2KHaIlwYB+sdN/PhyHdizguTyMMfVZHOHKtqgmkU9htGBEtdPARnuRJAx1OOf1wxP
         MLyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Qm1M+9iwmqug094Ij1+/BFzpWH81JqUDY9n0PrAzHc4=;
        b=Stnc2p4mvpMOhur9SF7P/eV0mBnsQhZUPfABL7U2vThr+CczUKavPRGHcTDl7Qb7RI
         eMTY+Tf4nVjiST6rLXWlcmD5WiLLhatJ1Kot+yvI1f/BP7/RVy8e8EZ/e80o7BB/vt3L
         zPUOejNOpICPXeuVB11TN2c6Fst5fhBXSR5ts+F3IJzejkV+pW6VEKbJptaTCGovfHSZ
         nbDiQgZfAmbTUZC7kR5DdwFtEj0O1XDNxRuKU2GOU3ZfKdShvvK9DvAFQ8HEngh8sCPn
         6zppLCJOIXZLOu/FJblD0t3vJhWgY1jEzShDcAG5gvct571ssd9IgPiubU+6uMx2l1Pi
         Cmxg==
X-Gm-Message-State: AOAM532O51hbFyt2t2rYRSlZfI2pqkHCJnj5yw6JsFiFQ1lL3RpejUMJ
        T6lv/4+m0n/9C35xB1ISiKYY0h5q9xgeb9A/Eofb/g==
X-Google-Smtp-Source: ABdhPJz2ps/x+IiYH/UpKiBHMnKmG6F64vEm6r0pzp2mHWOW5Xd7CNWXzol+hk3UHSVR0Dl/9dllUT844kiXDLfIeEM=
X-Received: by 2002:a17:906:70d:: with SMTP id y13mr2728501ejb.170.1616138453152;
 Fri, 19 Mar 2021 00:20:53 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 19 Mar 2021 12:50:42 +0530
Message-ID: <CA+G9fYu=a0pk79He2DoQ9NGHkbG58PMhqJsEk=xiQv+v495Dmw@mail.gmail.com>
Subject: Clang: powerpc: kvm/book3s_hv_nested.c:264:6: error: stack frame size
 of 2480 bytes in function 'kvmhv_enter_nested_guest'
To:     clang-built-linux <clang-built-linux@googlegroups.com>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        kvm-ppc@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Linux mainline master build breaks for powerpc defconfig.
There are multiple errors / warnings with clang-12 and clang-11 and 10.
 - powerpc (defconfig) with clang-12
 - powerpc (defconfig) with clang-11
 - powerpc (defconfig) with clang-10

The following build errors / warnings triggered with clang-12.
make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp LLVM=1 ARCH=powerpc
CROSS_COMPILE=powerpc64le-linux-gnu- 'HOSTCC=sccache clang'
'CC=sccache clang'
/builds/linux/arch/powerpc/kvm/book3s_hv_nested.c:264:6: error: stack
frame size of 2480 bytes in function 'kvmhv_enter_nested_guest'
[-Werror,-Wframe-larger-than=]
long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
     ^
1 error generated.
make[3]: *** [/builds/linux/scripts/Makefile.build:271:
arch/powerpc/kvm/book3s_hv_nested.o] Error 1

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

The following build errors / warnings triggered with clang-10 and clang-11.
 - powerpc (defconfig) with clang-11
 - powerpc (defconfig) with clang-10
make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp LLVM=1 ARCH=powerpc
CROSS_COMPILE=powerpc64le-linux-gnu- 'HOSTCC=sccache clang'
'CC=sccache clang'

/usr/bin/powerpc64le-linux-gnu-ld:
arch/powerpc/kernel/vdso32/sigtramp.o: compiled for a little endian
system and target is big endian
/usr/bin/powerpc64le-linux-gnu-ld: failed to merge target specific
data of file arch/powerpc/kernel/vdso32/sigtramp.o
/usr/bin/powerpc64le-linux-gnu-ld:
arch/powerpc/kernel/vdso32/gettimeofday.o: compiled for a little
endian system and target is big endian
/usr/bin/powerpc64le-linux-gnu-ld: failed to merge target specific
data of file arch/powerpc/kernel/vdso32/gettimeofday.o
/usr/bin/powerpc64le-linux-gnu-ld:
arch/powerpc/kernel/vdso32/datapage.o: compiled for a little endian
system and target is big endian
/usr/bin/powerpc64le-linux-gnu-ld: failed to merge target specific
data of file arch/powerpc/kernel/vdso32/datapage.o
/usr/bin/powerpc64le-linux-gnu-ld:
arch/powerpc/kernel/vdso32/cacheflush.o: compiled for a little endian
system and target is big endian
/usr/bin/powerpc64le-linux-gnu-ld: failed to merge target specific
data of file arch/powerpc/kernel/vdso32/cacheflush.o
/usr/bin/powerpc64le-linux-gnu-ld: arch/powerpc/kernel/vdso32/note.o:
compiled for a little endian system and target is big endian
/usr/bin/powerpc64le-linux-gnu-ld: failed to merge target specific
data of file arch/powerpc/kernel/vdso32/note.o
/usr/bin/powerpc64le-linux-gnu-ld:
arch/powerpc/kernel/vdso32/getcpu.o: compiled for a little endian
system and target is big endian
/usr/bin/powerpc64le-linux-gnu-ld: failed to merge target specific
data of file arch/powerpc/kernel/vdso32/getcpu.o
/usr/bin/powerpc64le-linux-gnu-ld:
arch/powerpc/kernel/vdso32/vgettimeofday.o: compiled for a little
endian system and target is big endian
/usr/bin/powerpc64le-linux-gnu-ld: failed to merge target specific
data of file arch/powerpc/kernel/vdso32/vgettimeofday.o
clang: error: unable to execute command: Segmentation fault (core dumped)
clang: error: linker command failed due to signal (use -v to see invocation)
make[2]: *** [/builds/linux/arch/powerpc/kernel/vdso32/Makefile:51:
arch/powerpc/kernel/vdso32/vdso32.so.dbg] Error 254
make[2]: Target 'include/generated/vdso32-offsets.h' not remade
because of errors.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

build link,
https://gitlab.com/Linaro/lkft/mirrors/torvalds/linux-mainline/-/jobs/1110841371#L59

--
Linaro LKFT
https://lkft.linaro.org
