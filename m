Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE8EBC1B2
	for <lists+kvm-ppc@lfdr.de>; Tue, 24 Sep 2019 08:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391418AbfIXGUn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 24 Sep 2019 02:20:43 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:44233 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387676AbfIXGUn (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 24 Sep 2019 02:20:43 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46crfJ3PvXz9sDB; Tue, 24 Sep 2019 16:20:40 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1569306040; bh=zIUz0AqwzPQYcFgIkPZiOJd0EZVYEzrjLiQQNvFyYGg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h51cmhb0Ei/K/eSdPWW+l0WfsPmZgAfkBSpCVoPjR2vP+IPUv2+wcX26DFEtp2m3O
         OnbVIFAl03Kx0iZGHM6NzHesNTmbmP/X74o9eSfX9qe7MSxZajaeSff3w/mN8m7qrG
         wJclw13kxEh1BNh82Hcw7KTiXXksdCXu6YqujC6pFE1SUhBoewp7a+1316gsTjdsvo
         fhcVp8hnBqc9MlSiGS6ctxZagJjQ1v1oS80L8GFM7naQMoBEXiCj/xFEtAVShdX9la
         KUuT+zVbFkcV4LqWeVypw6Ab5NpoFFDJn6BElAc59Bo6C3E98qQk6GRGOFDyXCOVUl
         36UD7+qxaWh+A==
Date:   Tue, 24 Sep 2019 16:20:20 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Fix LPCR[AIL]=3 implementation and reject
Message-ID: <20190924062020.GA2642@oak.ozlabs.ibm.com>
References: <20190916073108.3256-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190916073108.3256-1-npiggin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Sep 16, 2019 at 05:31:03PM +1000, Nicholas Piggin wrote:
> This is an update of the series with comments addressed. Most of them
> were relatively minor details except patch 3, which incorrectly added
> end_cede to guest entry interrupt injection, now fixed.

With this series, compiling a pmac32_defconfig with PR KVM turned on,
I get compile errors as follows:

make[1]: Entering directory '/home/paulus/kernel/test-pmac-kvm'
  Using /home/paulus/kernel/kvm as source for kernel
  GEN     Makefile
  CALL    /home/paulus/kernel/kvm/scripts/checksyscalls.sh
<stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
  CALL    /home/paulus/kernel/kvm/scripts/atomic/check-atomics.sh
  CHK     include/generated/compile.h
  CALL    /home/paulus/kernel/kvm/arch/powerpc/kernel/prom_init_check.sh
  CC [M]  arch/powerpc/kvm/book3s_pr.o
In file included from /home/paulus/kernel/kvm/arch/powerpc/include/asm/processor.h:9:0,
                 from /home/paulus/kernel/kvm/arch/powerpc/include/asm/thread_info.h:22,
                 from /home/paulus/kernel/kvm/include/linux/thread_info.h:38,
                 from /home/paulus/kernel/kvm/include/asm-generic/preempt.h:5,
                 from ./arch/powerpc/include/generated/asm/preempt.h:1,
                 from /home/paulus/kernel/kvm/include/linux/preempt.h:78,
                 from /home/paulus/kernel/kvm/include/linux/hardirq.h:5,
                 from /home/paulus/kernel/kvm/include/linux/kvm_host.h:7,
                 from /home/paulus/kernel/kvm/arch/powerpc/kvm/book3s_pr.c:19:
/home/paulus/kernel/kvm/arch/powerpc/kvm/book3s_pr.c: In function ‘kvmppc_inject_interrupt_pr’:
/home/paulus/kernel/kvm/arch/powerpc/include/asm/reg.h:67:23: error: left shift count >= width of type [-Werror=shift-count-overflow]
 #define __MASK(X) (1UL<<(X))
                       ^
/home/paulus/kernel/kvm/arch/powerpc/include/asm/reg.h:119:18: note: in expansion of macro ‘__MASK’
 #define MSR_TS_T __MASK(MSR_TS_T_LG) /*  Transaction Transactional */
                  ^
/home/paulus/kernel/kvm/arch/powerpc/include/asm/reg.h:120:22: note: in expansion of macro ‘MSR_TS_T’
 #define MSR_TS_MASK (MSR_TS_T | MSR_TS_S)   /* Transaction State bits */
                      ^
/home/paulus/kernel/kvm/arch/powerpc/include/asm/reg.h:122:41: note: in expansion of macro ‘MSR_TS_MASK’
 #define MSR_TM_TRANSACTIONAL(x) (((x) & MSR_TS_MASK) == MSR_TS_T)
                                         ^
/home/paulus/kernel/kvm/arch/powerpc/kvm/book3s_pr.c:118:6: note: in expansion of macro ‘MSR_TM_TRANSACTIONAL’
  if (MSR_TM_TRANSACTIONAL(msr))
      ^
/home/paulus/kernel/kvm/arch/powerpc/include/asm/reg.h:67:23: error: left shift count >= width of type [-Werror=shift-count-overflow]
 #define __MASK(X) (1UL<<(X))
                       ^
/home/paulus/kernel/kvm/arch/powerpc/include/asm/reg.h:118:18: note: in expansion of macro ‘__MASK’
 #define MSR_TS_S __MASK(MSR_TS_S_LG) /*  Transaction Suspended */
                  ^
/home/paulus/kernel/kvm/arch/powerpc/include/asm/reg.h:120:33: note: in expansion of macro ‘MSR_TS_S’
 #define MSR_TS_MASK (MSR_TS_T | MSR_TS_S)   /* Transaction State bits */
                                 ^
/home/paulus/kernel/kvm/arch/powerpc/include/asm/reg.h:122:41: note: in expansion of macro ‘MSR_TS_MASK’
 #define MSR_TM_TRANSACTIONAL(x) (((x) & MSR_TS_MASK) == MSR_TS_T)
                                         ^
/home/paulus/kernel/kvm/arch/powerpc/kvm/book3s_pr.c:118:6: note: in expansion of macro ‘MSR_TM_TRANSACTIONAL’
  if (MSR_TM_TRANSACTIONAL(msr))
      ^
/home/paulus/kernel/kvm/arch/powerpc/include/asm/reg.h:67:23: error: left shift count >= width of type [-Werror=shift-count-overflow]
 #define __MASK(X) (1UL<<(X))
                       ^
/home/paulus/kernel/kvm/arch/powerpc/include/asm/reg.h:119:18: note: in expansion of macro ‘__MASK’
 #define MSR_TS_T __MASK(MSR_TS_T_LG) /*  Transaction Transactional */
                  ^
/home/paulus/kernel/kvm/arch/powerpc/include/asm/reg.h:122:57: note: in expansion of macro ‘MSR_TS_T’
 #define MSR_TM_TRANSACTIONAL(x) (((x) & MSR_TS_MASK) == MSR_TS_T)
                                                         ^
/home/paulus/kernel/kvm/arch/powerpc/kvm/book3s_pr.c:118:6: note: in expansion of macro ‘MSR_TM_TRANSACTIONAL’
  if (MSR_TM_TRANSACTIONAL(msr))
      ^
/home/paulus/kernel/kvm/arch/powerpc/include/asm/reg.h:67:23: error: left shift count >= width of type [-Werror=shift-count-overflow]
 #define __MASK(X) (1UL<<(X))
                       ^
/home/paulus/kernel/kvm/arch/powerpc/include/asm/reg.h:118:18: note: in expansion of macro ‘__MASK’
 #define MSR_TS_S __MASK(MSR_TS_S_LG) /*  Transaction Suspended */
                  ^
/home/paulus/kernel/kvm/arch/powerpc/kvm/book3s_pr.c:119:14: note: in expansion of macro ‘MSR_TS_S’
   new_msr |= MSR_TS_S;
              ^
/home/paulus/kernel/kvm/arch/powerpc/include/asm/reg.h:67:23: error: left shift count >= width of type [-Werror=shift-count-overflow]
 #define __MASK(X) (1UL<<(X))
                       ^
/home/paulus/kernel/kvm/arch/powerpc/include/asm/reg.h:119:18: note: in expansion of macro ‘__MASK’
 #define MSR_TS_T __MASK(MSR_TS_T_LG) /*  Transaction Transactional */
                  ^
/home/paulus/kernel/kvm/arch/powerpc/include/asm/reg.h:120:22: note: in expansion of macro ‘MSR_TS_T’
 #define MSR_TS_MASK (MSR_TS_T | MSR_TS_S)   /* Transaction State bits */
                      ^
/home/paulus/kernel/kvm/arch/powerpc/kvm/book3s_pr.c:121:20: note: in expansion of macro ‘MSR_TS_MASK’
   new_msr |= msr & MSR_TS_MASK;
                    ^
/home/paulus/kernel/kvm/arch/powerpc/include/asm/reg.h:67:23: error: left shift count >= width of type [-Werror=shift-count-overflow]
 #define __MASK(X) (1UL<<(X))
                       ^
/home/paulus/kernel/kvm/arch/powerpc/include/asm/reg.h:118:18: note: in expansion of macro ‘__MASK’
 #define MSR_TS_S __MASK(MSR_TS_S_LG) /*  Transaction Suspended */
                  ^
/home/paulus/kernel/kvm/arch/powerpc/include/asm/reg.h:120:33: note: in expansion of macro ‘MSR_TS_S’
 #define MSR_TS_MASK (MSR_TS_T | MSR_TS_S)   /* Transaction State bits */
                                 ^
/home/paulus/kernel/kvm/arch/powerpc/kvm/book3s_pr.c:121:20: note: in expansion of macro ‘MSR_TS_MASK’
   new_msr |= msr & MSR_TS_MASK;
                    ^
cc1: all warnings being treated as errors
make[3]: *** [/home/paulus/kernel/kvm/scripts/Makefile.build:274: arch/powerpc/kvm/book3s_pr.o] Error 1
make[2]: *** [/home/paulus/kernel/kvm/scripts/Makefile.build:490: arch/powerpc/kvm] Error 2
make[1]: *** [/home/paulus/kernel/kvm/Makefile:1079: arch/powerpc] Error 2
make[1]: Leaving directory '/home/paulus/kernel/test-pmac-kvm'
make: *** [Makefile:179: sub-make] Error 2

I think this is attributable to patch 2 of your series.

Paul.
