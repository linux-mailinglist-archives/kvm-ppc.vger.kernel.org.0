Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA113250B5
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhBYNrr (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhBYNrq (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:47:46 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BD0C061574
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:05 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id i14so1909511pjz.4
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jxlGxs02fmoqT3rYGeYc0ninZ01gUUly0vhllPhQfno=;
        b=ZY6RLdhKyt4+D9nFgqWvYBWxqWeEgu+5V9zG7HvrQaS9JM8x4guSsbSh3aN3qnSo5+
         GdNt8YRE5WTMLOtWM5GOan7ssmBqkAT/S73X/fOZzlC6ztq140z71jDs5Bdnv6jKzGAO
         JnAdqEPf9Ni6+wHZN/LhdfxFRcYFFBXMEm03OuEOdNP1duM2aE796bSsNu9fsDRVrGEf
         XrPWeEjrCF3j0Jn01SV+eDXu6ZdH7N+DYnCa5fAbwaXoDVEzGPkJuHYERID6edMD9qe7
         bpD37j9VoFVE66bxmoVl0XVvqalnVruGOjEiCQ1PJovc4/3txGQLGneh8fytu5PurCDz
         3+Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jxlGxs02fmoqT3rYGeYc0ninZ01gUUly0vhllPhQfno=;
        b=fU9MVws8Dj5I1LxqkCIewwP20JQk9H/+tcJ1nYews9ZUkOvYuuNEerz6B6BAy+p21W
         KxXc0soy8vIIKDvnvhXIqqRDi8Q3+KlaS6akQqOyx+ilBPUzBCewT3vj1bSRrUkaqItu
         l6UXKT6VTYJEjzOusp54U9g1/aP9fPTguh0Buk5UHm7tvMGekNIMtpxydY9zn4MdF38k
         kpBNwltV8J27TdPdr6TsabivE/FIv0NPUNmHLviU1yDXM5fzKUP7HWrxXHOkmlS4yATJ
         bbu7DYwojwiWSkxKy1jy54AVrFNRnVx7Lo3+11swejv6QuX7S685PAIULQEgN7rCaxN/
         fCZQ==
X-Gm-Message-State: AOAM5338t12L6TyrarLMXDHaKzTJuSi20zXE6Lo4kicuUYN0lI3WSc8F
        /Oq/hSoBCSixQ8qpXvwZ2Js1ly94ybA=
X-Google-Smtp-Source: ABdhPJwJ+soDH2qNpw4Tj2qiXI4jgs1+qqlYVWKTToMUls9C2y+iUkGUiyWH4Bw7fWWqNibJzoMdLA==
X-Received: by 2002:a17:90b:164c:: with SMTP id il12mr3501195pjb.32.1614260824436;
        Thu, 25 Feb 2021 05:47:04 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:47:02 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 00/37] KVM: PPC: Book3S: C-ify the P9 entry/exit code
Date:   Thu, 25 Feb 2021 23:46:15 +1000
Message-Id: <20210225134652.2127648-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Since last posting, fixed a bunch of bugs, tidied things up, and
ironed out a few issues with XIVE.

I also got HPT guest and also host working on the new P9 path, which
allows major simplifications to the old path and moving P9 off it
completely, so I think that is really worth posting (I thought it
would be much more difficult).

Thanks,
Nick

Nicholas Piggin (37):
  KVM: PPC: Book3S 64: remove unused kvmppc_h_protect argument
  KVM: PPC: Book3S HV: Fix CONFIG_SPAPR_TCE_IOMMU=n default hcalls
  powerpc/64s: Remove KVM handler support from CBE_RAS interrupts
  powerpc/64s: remove KVM SKIP test from instruction breakpoint handler
  KVM: PPC: Book3S HV: Ensure MSR[ME] is always set in guest MSR
  KVM: PPC: Book3S 64: move KVM interrupt entry to a common entry point
  KVM: PPC: Book3S 64: Move GUEST_MODE_SKIP test into KVM
  KVM: PPC: Book3S 64: add hcall interrupt handler
  KVM: PPC: Book3S 64: Move hcall early register setup to KVM
  KVM: PPC: Book3S 64: Move interrupt early register setup to KVM
  KVM: PPC: Book3S 64: move bad_host_intr check to HV handler
  KVM: PPC: Book3S 64: Minimise hcall handler calling convention
    differences
  KVM: PPC: Book3S HV P9: Move radix MMU switching instructions together
  KVM: PPC: Book3S HV P9: implement kvmppc_xive_pull_vcpu in C
  KVM: PPC: Book3S HV P9: Move xive vcpu context management into
    kvmhv_p9_guest_entry
  KVM: PPC: Book3S HV P9: Stop handling hcalls in real-mode in the P9
    path
  KVM: PPC: Book3S HV P9: Move setting HDEC after switching to guest
    LPCR
  KVM: PPC: Book3S HV P9: Use large decrementer for HDEC
  KVM: PPC: Book3S HV P9: Use host timer accounting to avoid decrementer
    read
  KVM: PPC: Book3S HV P9: Reduce mftb per guest entry/exit
  powerpc: add set_dec_or_work API for safely updating decrementer
  KVM: PPC: Book3S HV P9: Reduce irq_work vs guest decrementer races
  KVM: PPC: Book3S HV P9: Implement the rest of the P9 path in C
  KVM: PPC: Book3S HV P9: inline kvmhv_load_hv_regs_and_go into
    __kvmhv_vcpu_entry_p9
  KVM: PPC: Book3S HV P9: Read machine check registers while MSR[RI] is
    0
  KVM: PPC: Book3S HV P9: Improve exit timing accounting coverage
  KVM: PPC: Book3S HV P9: Move SPR loading after expiry time check
  KVM: PPC: Book3S HV P9: Add helpers for OS SPR handling
  KVM: PPC: Book3S HV P9: Switch to guest MMU context as late as
    possible
  KVM: PPC: Book3S HV: Implement radix prefetch workaround by disabling
    MMU
  KVM: PPC: Book3S HV: Remove support for dependent threads mode on P9
  KVM: PPC: Book3S HV: Remove radix guest support from P7/8 path
  KVM: PPC: Book3S HV: small pseries_do_hcall cleanup
  KVM: PPC: Book3S HV: add virtual mode handlers for HPT hcalls and page
    faults
  KVM: PPC: Book3S HV P9: implement hash guest support
  KVM: PPC: Book3S HV P9: implement hash host / hash guest support
  KVM: PPC: Book3S HV: remove POWER9 support from P7/8 paths

 arch/powerpc/include/asm/asm-prototypes.h |   3 +-
 arch/powerpc/include/asm/exception-64s.h  |  13 +
 arch/powerpc/include/asm/kvm_asm.h        |   3 +-
 arch/powerpc/include/asm/kvm_book3s_64.h  |   8 +
 arch/powerpc/include/asm/kvm_host.h       |   1 -
 arch/powerpc/include/asm/kvm_ppc.h        |  10 +-
 arch/powerpc/include/asm/mmu_context.h    |   6 -
 arch/powerpc/include/asm/paca.h           |   1 +
 arch/powerpc/include/asm/time.h           |  16 +
 arch/powerpc/kernel/exceptions-64s.S      | 257 ++-------
 arch/powerpc/kernel/security.c            |   5 +-
 arch/powerpc/kernel/time.c                |  20 +-
 arch/powerpc/kvm/Makefile                 |   6 +
 arch/powerpc/kvm/book3s_64_entry.S        | 297 ++++++++++
 arch/powerpc/kvm/book3s_hv.c              | 590 ++++++++++----------
 arch/powerpc/kvm/book3s_hv_builtin.c      |   7 +
 arch/powerpc/kvm/book3s_hv_interrupt.c    | 493 +++++++++++++++++
 arch/powerpc/kvm/book3s_hv_interrupts.S   |   9 +-
 arch/powerpc/kvm/book3s_hv_nested.c       |   1 +
 arch/powerpc/kvm/book3s_hv_ras.c          |   5 +
 arch/powerpc/kvm/book3s_hv_rm_mmu.c       |   7 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S   | 625 +---------------------
 arch/powerpc/kvm/book3s_segment.S         |   7 +
 arch/powerpc/kvm/book3s_xive.c            |  93 ++++
 arch/powerpc/mm/book3s64/radix_pgtable.c  |  27 +-
 arch/powerpc/mm/book3s64/radix_tlb.c      |  46 --
 arch/powerpc/mm/mmu_context.c             |   4 +-
 arch/powerpc/platforms/powernv/idle.c     |  52 +-
 28 files changed, 1342 insertions(+), 1270 deletions(-)
 create mode 100644 arch/powerpc/kvm/book3s_64_entry.S
 create mode 100644 arch/powerpc/kvm/book3s_hv_interrupt.c

-- 
2.23.0

