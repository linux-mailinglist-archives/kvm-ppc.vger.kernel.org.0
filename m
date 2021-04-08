Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA89357D6A
	for <lists+kvm-ppc@lfdr.de>; Thu,  8 Apr 2021 09:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhDHHeI (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 8 Apr 2021 03:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhDHHeI (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 8 Apr 2021 03:34:08 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DFCC061760
        for <kvm-ppc@vger.kernel.org>; Thu,  8 Apr 2021 00:33:57 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id nh5so654675pjb.5
        for <kvm-ppc@vger.kernel.org>; Thu, 08 Apr 2021 00:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=b1oLjlIsgitDb5EJtnbTFGlBtjw+XjDzzBBpX2iJwBY=;
        b=VPzMe9QUBkn9qJfqHorOnyqESfqCO0bxrO4dY1yt3RWimBcpjEbEgWdGImU3j0BR3w
         yDEbpzzGqut4358jwhL5xaUnYJaOGYymHonVBB0jNlYsI4H0aodFCLTajF6Ijnba35PA
         k4owITnJswQslKK15oBLvoWmsU5XIu1kynuvvqG5guLzoRS8jqiUJURz2uGd6NG0r2R+
         nous2z5+BTgYscnfh7cbOQhPm16B5HWbJOrJC2lrfJNEaeYMDijNKmwfK4JC+Hx8m9of
         wj9TXgZAaZiyhRAmkH9zW+lfu5c6aMIA9o+4o5jbQ+xsyQYIPq0Ne+4+xV5pMrCq3BsK
         Bc4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=b1oLjlIsgitDb5EJtnbTFGlBtjw+XjDzzBBpX2iJwBY=;
        b=FPb/ihP0c492BzjI29STw0yklVWa4la0Oew07zzNNjcTSOYTDM0GFY5oPj/hCIDCH0
         RdQqzirLRVjMBPOPmfYhtlX9mFhjVWA8OJrQSezVE6/3gnxMxQEIKSIIc3U1+2pYudC+
         ssPCapfk4GFxZJ7Zb3nbJSTAoR9mgVIvw3xCI/qTzOLmBpc+GA2gPCEWHUUxUQreLJUn
         ioFw7tSHqWKaUgRJm42OIDMqOKQ2A/20JG7c90uN0qio62xFGRTYoqZqMG96AWkitBZZ
         G+7nNvWjCp+EYNxH9WQIkJDMMJznvQDg+gWTF4hTA7PEaIYlk4j2khDMFe/ax6ZYpVKD
         OtEA==
X-Gm-Message-State: AOAM531xp5RMkv+ZU2ADo/MmFr3+1ZwcihDlT9sr1YDzVY97fTCKWf4Q
        vOTJ4gyYHEl30XRJUmLL3voSHMv6ALm6wA==
X-Google-Smtp-Source: ABdhPJwxD3KihNbb56pJTvytWfoled7A0JyKnIF/FN3FEKfLz1VZiF9auQQMyIIqyJ3zgG76Gh24Kw==
X-Received: by 2002:a17:90a:d350:: with SMTP id i16mr7158192pjx.226.1617867237041;
        Thu, 08 Apr 2021 00:33:57 -0700 (PDT)
Received: from localhost (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id d13sm24310988pgb.6.2021.04.08.00.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 00:33:56 -0700 (PDT)
Date:   Thu, 08 Apr 2021 17:33:50 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v6 00/48] KVM: PPC: Book3S: C-ify the P9 entry/exit code
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210405011948.675354-1-npiggin@gmail.com>
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
MIME-Version: 1.0
Message-Id: <1617865149.sj1ljwsvhh.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Nicholas Piggin's message of April 5, 2021 11:19 am:
> Git tree here
>=20
> https://github.com/npiggin/linux/tree/kvm-in-c-v6
>=20

In the interest of making things more managable, I would like to submit=20
some initial things for merge, which have mostly had pretty good review
(I'll repost them in a new series or set of series if there is no
objection, rather than pick from this series).

> Nicholas Piggin (48):
>   KVM: PPC: Book3S HV: Nested move LPCR sanitising to sanitise_hv_regs
>   KVM: PPC: Book3S HV: Add a function to filter guest LPCR bits
>   KVM: PPC: Book3S HV: Disallow LPCR[AIL] to be set to 1 or 2
>   KVM: PPC: Book3S HV: Prevent radix guests setting LPCR[TC]
>   KVM: PPC: Book3S HV: Remove redundant mtspr PSPB
>   KVM: PPC: Book3S HV: remove unused kvmppc_h_protect argument
>   KVM: PPC: Book3S HV: Fix CONFIG_SPAPR_TCE_IOMMU=3Dn default hcalls
>   powerpc/64s: Remove KVM handler support from CBE_RAS interrupts
>   powerpc/64s: remove KVM SKIP test from instruction breakpoint handler
>   KVM: PPC: Book3S HV: Ensure MSR[ME] is always set in guest MSR
>   KVM: PPC: Book3S HV: Ensure MSR[HV] is always clear in guest MSR

1-11 are pretty small, mostly isolated improvements.

>   KVM: PPC: Book3S 64: move KVM interrupt entry to a common entry point
>   KVM: PPC: Book3S 64: Move GUEST_MODE_SKIP test into KVM
>   KVM: PPC: Book3S 64: add hcall interrupt handler
>   KVM: PPC: Book3S 64: Move hcall early register setup to KVM
>   KVM: PPC: Book3S 64: Move interrupt early register setup to KVM
>   KVM: PPC: Book3S 64: move bad_host_intr check to HV handler
>   KVM: PPC: Book3S 64: Minimise hcall handler calling convention
>     differences

12-18 includes all the exception-64s.S <-> KVM API changes required. I=20
think these changes are improvements in their own right, certainly the=20
exception-64s.S side is far nicer.

>   KVM: PPC: Book3S HV P9: Move radix MMU switching instructions together

19 I would like to include because these MMU SPRs have a special=20
relationship that can't just be set in any order. This code is also much=20
better suited to sim and prototyping work for proposed changes to the=20
MMU context switching architecture.

>   KVM: PPC: Book3S HV P9: implement kvmppc_xive_pull_vcpu in C
>   KVM: PPC: Book3S HV P9: Move xive vcpu context management into
>     kvmhv_p9_guest_entry

20-21 are stand-alone, I think they're good. Existing asm is duplicated=20
in C but the C documents it and anyway matches its inverse which is=20
already in C.

And I think it's better to be doing CI MMIOs while we're still mostly in=20
host context.

>   KVM: PPC: Book3S HV P9: Stop handling hcalls in real-mode in the P9
>     path

22 move down together with Implement the rest of the P9 path in C.

>   KVM: PPC: Book3S HV P9: Move setting HDEC after switching to guest
>     LPCR
>   KVM: PPC: Book3S HV P9: Use large decrementer for HDEC
>   KVM: PPC: Book3S HV P9: Use host timer accounting to avoid decrementer
>     read
>   KVM: PPC: Book3S HV P9: Reduce mftb per guest entry/exit
>   KVM: PPC: Book3S HV P9: Reduce irq_work vs guest decrementer races
>   KMV: PPC: Book3S HV: Use set_dec to set decrementer to host
>   powerpc/time: add API for KVM to re-arm the host timer/decrementer

23-29 try to get all these timekeeping things in. They ended up being=20
mostly unrelated to the C conversion but the way I started out writing=20
the C conversion, these changes fell out and ended up collecting here. I=20
think they're generally improvements.

That leaves about 20 patches remaining. Of those, only about the first 5=20
are necessary to reimplement the existing P9 path functionality in C,=20
which is a lot less scary than nearly 50.

Thanks,
Nick

>   KVM: PPC: Book3S HV P9: Implement the rest of the P9 path in C
>   KVM: PPC: Book3S HV P9: inline kvmhv_load_hv_regs_and_go into
>     __kvmhv_vcpu_entry_p9
>   KVM: PPC: Book3S HV P9: Read machine check registers while MSR[RI] is
>     0
>   KVM: PPC: Book3S HV P9: Improve exit timing accounting coverage
>   KVM: PPC: Book3S HV P9: Move SPR loading after expiry time check
>   KVM: PPC: Book3S HV P9: Add helpers for OS SPR handling
>   KVM: PPC: Book3S HV P9: Switch to guest MMU context as late as
>     possible
>   KVM: PPC: Book3S HV: Implement radix prefetch workaround by disabling
>     MMU
>   KVM: PPC: Book3S HV: Remove support for dependent threads mode on P9
>   KVM: PPC: Book3S HV: Remove radix guest support from P7/8 path
>   KVM: PPC: Book3S HV: Remove virt mode checks from real mode handlers
>   KVM: PPC: Book3S HV: Remove unused nested HV tests in XICS emulation
>   KVM: PPC: Book3S HV P9: Allow all P9 processors to enable nested HV
>   KVM: PPC: Book3S HV: small pseries_do_hcall cleanup
>   KVM: PPC: Book3S HV: add virtual mode handlers for HPT hcalls and page
>     faults
>   KVM: PPC: Book3S HV P9: Reflect userspace hcalls to hash guests to
>     support PR KVM
>   KVM: PPC: Book3S HV P9: implement hash guest support
>   KVM: PPC: Book3S HV P9: implement hash host / hash guest support
>   KVM: PPC: Book3S HV: remove ISA v3.0 and v3.1 support from P7/8 path
>=20
>  arch/powerpc/include/asm/asm-prototypes.h |   3 +-
>  arch/powerpc/include/asm/exception-64s.h  |  13 +
>  arch/powerpc/include/asm/kvm_asm.h        |   3 +-
>  arch/powerpc/include/asm/kvm_book3s.h     |   2 +
>  arch/powerpc/include/asm/kvm_book3s_64.h  |   8 +
>  arch/powerpc/include/asm/kvm_host.h       |   8 +-
>  arch/powerpc/include/asm/kvm_ppc.h        |  21 +-
>  arch/powerpc/include/asm/mmu_context.h    |   6 -
>  arch/powerpc/include/asm/time.h           |  11 +
>  arch/powerpc/kernel/asm-offsets.c         |   1 -
>  arch/powerpc/kernel/exceptions-64s.S      | 257 ++-----
>  arch/powerpc/kernel/security.c            |   5 +-
>  arch/powerpc/kernel/time.c                |  43 +-
>  arch/powerpc/kvm/Makefile                 |   4 +
>  arch/powerpc/kvm/book3s.c                 |  17 +-
>  arch/powerpc/kvm/book3s_64_entry.S        | 409 +++++++++++
>  arch/powerpc/kvm/book3s_64_vio_hv.c       |  12 -
>  arch/powerpc/kvm/book3s_hv.c              | 782 ++++++++++++----------
>  arch/powerpc/kvm/book3s_hv_builtin.c      | 138 +---
>  arch/powerpc/kvm/book3s_hv_interrupt.c    | 529 +++++++++++++++
>  arch/powerpc/kvm/book3s_hv_interrupts.S   |   9 +-
>  arch/powerpc/kvm/book3s_hv_nested.c       |  37 +-
>  arch/powerpc/kvm/book3s_hv_ras.c          |   2 +
>  arch/powerpc/kvm/book3s_hv_rm_mmu.c       |  15 +-
>  arch/powerpc/kvm/book3s_hv_rm_xics.c      |  15 -
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S   | 682 +------------------
>  arch/powerpc/kvm/book3s_segment.S         |   3 +
>  arch/powerpc/kvm/book3s_xive.c            | 113 +++-
>  arch/powerpc/kvm/book3s_xive.h            |   7 -
>  arch/powerpc/kvm/book3s_xive_native.c     |  10 -
>  arch/powerpc/mm/book3s64/radix_pgtable.c  |  27 +-
>  arch/powerpc/mm/book3s64/radix_tlb.c      |  46 --
>  arch/powerpc/mm/mmu_context.c             |   4 +-
>  arch/powerpc/platforms/powernv/idle.c     |  52 +-
>  34 files changed, 1735 insertions(+), 1559 deletions(-)
>  create mode 100644 arch/powerpc/kvm/book3s_64_entry.S
>  create mode 100644 arch/powerpc/kvm/book3s_hv_interrupt.c
>=20
> --=20
> 2.23.0
>=20
>=20
