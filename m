Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7EB43AE870
	for <lists+kvm-ppc@lfdr.de>; Mon, 21 Jun 2021 13:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhFUL5o (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 21 Jun 2021 07:57:44 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:54957 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFUL5n (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 21 Jun 2021 07:57:43 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]) by
 mrelayeu.kundenserver.de (mreue010 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MC2o9-1m7cr70jAD-00CUOX; Mon, 21 Jun 2021 13:55:28 +0200
Received: by mail-wm1-f50.google.com with SMTP id p10-20020a05600c430ab02901df57d735f7so1532904wme.3;
        Mon, 21 Jun 2021 04:55:28 -0700 (PDT)
X-Gm-Message-State: AOAM532FMSGGgyOOKbSNXYo3PW1K6IZ3xtgsow1fiDbsm6ti0m+7Xpia
        zMkvTS6IhlQyRDj0mF+Ix7MB4lAQwgu+aqfL/hc=
X-Google-Smtp-Source: ABdhPJwhA2TM2PcFJQYCB+5Xx/XGY7m3KHuH6Z6RgJYL0awTBlZGuL5U6Qz/NGecGMIJ16WwJfYhY5QqBMGyQv9kk+c=
X-Received: by 2002:a1c:c90f:: with SMTP id f15mr26864111wmb.142.1624276527837;
 Mon, 21 Jun 2021 04:55:27 -0700 (PDT)
MIME-Version: 1.0
References: <202104031853.vDT0Qjqj-lkp@intel.com> <1624232938.d90brlmh3p.astroid@bobo.none>
 <e6167885-30e5-d149-bcde-3e9ad9f5d381@kernel.org> <87im273604.fsf@mpe.ellerman.id.au>
In-Reply-To: <87im273604.fsf@mpe.ellerman.id.au>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 21 Jun 2021 13:53:10 +0200
X-Gmail-Original-Message-ID: <CAK8P3a37Pj24WqSvMKnwSS74W+WMAsmk+-kXX5qE7fCZ=QBL0g@mail.gmail.com>
Message-ID: <CAK8P3a37Pj24WqSvMKnwSS74W+WMAsmk+-kXX5qE7fCZ=QBL0g@mail.gmail.com>
Subject: Re: arch/powerpc/kvm/book3s_hv_nested.c:264:6: error: stack frame
 size of 2304 bytes in function 'kvmhv_enter_nested_guest'
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        kbuild-all@lists.01.org, Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        kvm-ppc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:Y+mfW4xhH5X8RHYe/AsstC3IpSynQFWAwEXO8InZjsrHQZW/2b+
 1UBV4MoB+URF2gxOJlrS+s7s9NmurjL0uik9e/uCqns1W+izKReAmE9+e0gcZ/v0gPfwFos
 HQGd2ZNDi02jfP881HwfccIz0dM1fqw2ngr+DLhjoUVFaQyRX8jwoHurWm3Yzzm1gHwfid1
 MC/tdA5pFaFrn4ASUjVMg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:iX2r2V5/dms=:kPoXN4bzb0sO7xYLrvrwtd
 ZKOC2F5GdbxBziZ5vV4wblLQ3kaQGw8j3jVypvlSLqI2Jhs3O2Gx6MVTT+mCLxiqxMYuwIb2B
 a+a+vjwrfjBOJDRomOSprQ+Ulv9CjH3bYP6TOKmkoCzsQmMszR53TCH4WjtAcFcRfR9SMVsGI
 wqGdL8rt/EP1uhASSWXChbDGEnRYFyeGWmlOsWFfgUvZw9lQ1UvXhdh1BbGJtLte7eABX0Uov
 0JhRcgi5I7JjQXq8tS8zTjw1683LLuhSEBjSxP5szpXkare/9uSmIL7fjeq2mGmU0zGV3JFuN
 8soHN7jmrVmpkq9LULUSBqL7iS50K1FiG4LWBNnWyi8HcluLkhPUz9xO+7F4p/I7zmSDrWcOq
 NRP+TNlrKAlPvzhWVFDHuacHxLLWlNAMDjUxUJ1W7Yt8rLSw+i6SDCMlwGZwfXCL3Pc/n2pat
 kL85KhC2LJZDG/TqKDico5sHs0+j6lEwQHjU8v60LfWjPyKC9y6zLjlISJ5JOjEAEJC7X4Jyy
 CWXFsQHqsJRfIn0/YhXOBqpy8cTv/ALRDRJZ/TAONbMrd7h6F8+4g0AdR9jWSIfF+NCwyiymg
 8A6BCtJiriKOQjs/3doVU7bjEPBdmZ7WwYko6hiYvtLBmeVAin/GaLc5vge59T/n6wZPDwTrA
 pHVE=
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Jun 21, 2021 at 11:46 AM Michael Ellerman <mpe@ellerman.id.au> wrote:
> Nathan Chancellor <nathan@kernel.org> writes:
> > On 6/20/2021 4:59 PM, Nicholas Piggin wrote:
> >> Excerpts from kernel test robot's message of April 3, 2021 8:47 pm:
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
> Yeah that should be OK.

That's fine with me as well.

> Can you post the before/after disassembly when
> you post the patch?
>
> It should just be two extra function calls, which shouldn't be enough
> overhead to be measurable.

The thing I remember is that the 'before' code here is some seriously bad
output from llvm, and it would be helpful to have someone get the compiler
to emit the correct powerpc byteswap instructions and avoid the excessive
stack spilling.

The warning here is just a symptom of a missed optimization and the
same thing probably happens elsewhere on powerpc, even if it doesn't
exceed the stack warning limit.

        Arnd
