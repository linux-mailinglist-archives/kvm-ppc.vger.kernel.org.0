Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FAA393F57
	for <lists+kvm-ppc@lfdr.de>; Fri, 28 May 2021 11:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236657AbhE1JIq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 28 May 2021 05:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236523AbhE1JI2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 28 May 2021 05:08:28 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA70C061763
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:06:53 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id r1so2040789pgk.8
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AWipQFhJnjMhlV5h42SKDn1wpSlrbpzkPc9SX58WizI=;
        b=j/QhhpoOC5RsGSxmvO18bgiilwDJSLAzVMWDwwKCzaJA4Xuo1vX9LXmKdOayvdHgvF
         mayHKib2d1xo1wiXkXm7rcOH5bpbQKTMV1sxO/LBmBIvG/VopvVcSgmwsT0w2cvSKbtt
         39aWphOe4mINSTFGJXDqR/SLKxRkzEHoSwPYY5N5PpiEmGUt8qWY7lBd6lIFXwJIo1SU
         cVgp313rKwE4pFQVuw0KaTFNAYfurnimoPQcSEWWO10es364Tm+yiq96MHhPOFQLogSF
         71YbSss2BwmyZR6os8QKDTJQMOdnfl+cQLMZWISrWykJtbYmWH+weReTbbonZhgr81jh
         ZEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AWipQFhJnjMhlV5h42SKDn1wpSlrbpzkPc9SX58WizI=;
        b=MAPu2D8Y6pQtPuRwvmR6bjEkhZKWadwVGPuGhQhicohDgdpt0ON9/I/W8X5qXXmiec
         Ffzs/zCTeSz3GAzxK6QdjmUNWvBqwIxD6dYDAvDREUw0kGDE0HgqxhxTGCtglbhRvdCI
         ZXsRvRy/QMEgtYukn34ybPBzn2qXpCB/Sz8DilYWrxBvypDwPBK9XyYOC69PSXocoYgA
         71NzxhKPqS5HZPyofZIdxX+Xk1fEFpULmKsV5ZI0PjRwauSPWPsHfRDSbvUnY5uR5yEF
         njMCaHvnDHxNHgAkdc/g29Jj7lbiGpnZKYJeyf6Y9McU1QsAVr/TeSliWVWYpjDzsNMt
         BMgw==
X-Gm-Message-State: AOAM532l5BzEdmBhel9olWsIVl8AHE/1ZCriJw9RpNgIQOVQNbG96hSs
        G3dF2bljRrhNTVSLhvpHwCKGPQpuprw=
X-Google-Smtp-Source: ABdhPJw2lqNt97YYi8TEnCaZG3TaYjVSEA/sNkb8GtOHq3ZRbk3Zy0shNJfDphp1PCk5PMROyBO1tA==
X-Received: by 2002:a62:4ed1:0:b029:2e4:df13:fbd8 with SMTP id c200-20020a624ed10000b02902e4df13fbd8mr2834473pfb.68.1622192812376;
        Fri, 28 May 2021 02:06:52 -0700 (PDT)
Received: from bobo.ibm.com (124-169-110-219.tpgi.com.au. [124.169.110.219])
        by smtp.gmail.com with ESMTPSA id x187sm3745694pfc.104.2021.05.28.02.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 02:06:51 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v7 00/32] KVM: PPC: Book3S: C-ify the P9 entry/exit code
Date:   Fri, 28 May 2021 19:06:11 +1000
Message-Id: <20210528090643.3541902-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Git tree here

https://github.com/npiggin/linux/tree/kvm-in-c-5.14-1

This series applies to upstream plus a couple of KVM regression fixes
not yet in powerpc tree, which are included in the above git tree.

I split out the series into a few parts including about a dozen which
were merged in the last window, but this brings a bunch of them together
again for proposed merge.

Since last posting, this is rebased with some patches merged.  Some
patches have also been deferred.

No major changes to code, changelogs have been improved including some
numbers and better explanation for HPT guest performance regression.

This has been tested with radix host and hash / radix guest and hash
host / hash guest on P9. Also hash guest and PR KVM hash guest, and a PR
KVM nested hash guest, and radix guest and nested HV KVM radix nested
guest. P8 with SMT guest. Also P10 with radix and hash guests. It has
been tested with RHEL6,7,8,9 and AIX guests.

Thanks,
Nick

Nicholas Piggin (32):
  KVM: PPC: Book3S 64: move KVM interrupt entry to a common entry point
  KVM: PPC: Book3S 64: Move GUEST_MODE_SKIP test into KVM
  KVM: PPC: Book3S 64: add hcall interrupt handler
  KVM: PPC: Book3S 64: Move hcall early register setup to KVM
  KVM: PPC: Book3S 64: Move interrupt early register setup to KVM
  KVM: PPC: Book3S 64: move bad_host_intr check to HV handler
  KVM: PPC: Book3S 64: Minimise hcall handler calling convention
    differences
  KVM: PPC: Book3S HV P9: implement kvmppc_xive_pull_vcpu in C
  KVM: PPC: Book3S HV P9: Move setting HDEC after switching to guest
    LPCR
  KVM: PPC: Book3S HV P9: Reduce irq_work vs guest decrementer races
  KVM: PPC: Book3S HV P9: Move xive vcpu context management into
    kvmhv_p9_guest_entry
  KVM: PPC: Book3S HV P9: Move radix MMU switching instructions together
  KVM: PPC: Book3S HV P9: Stop handling hcalls in real-mode in the P9
    path
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
  KVM: PPC: Book3S HV: Remove virt mode checks from real mode handlers
  KVM: PPC: Book3S HV: Remove unused nested HV tests in XICS emulation
  KVM: PPC: Book3S HV P9: Allow all P9 processors to enable nested HV
  KVM: PPC: Book3S HV: small pseries_do_hcall cleanup
  KVM: PPC: Book3S HV: add virtual mode handlers for HPT hcalls and page
    faults
  KVM: PPC: Book3S HV P9: Reflect userspace hcalls to hash guests to
    support PR KVM
  KVM: PPC: Book3S HV P9: implement hash guest support
  KVM: PPC: Book3S HV P9: implement hash host / hash guest support
  KVM: PPC: Book3S HV: remove ISA v3.0 and v3.1 support from P7/8 path

 arch/powerpc/include/asm/asm-prototypes.h |   3 +-
 arch/powerpc/include/asm/exception-64s.h  |  13 +
 arch/powerpc/include/asm/kvm_asm.h        |   1 +
 arch/powerpc/include/asm/kvm_book3s_64.h  |   8 +
 arch/powerpc/include/asm/kvm_host.h       |   8 +-
 arch/powerpc/include/asm/kvm_ppc.h        |  18 +-
 arch/powerpc/include/asm/mmu_context.h    |   6 -
 arch/powerpc/include/asm/time.h           |  12 +
 arch/powerpc/kernel/asm-offsets.c         |   1 -
 arch/powerpc/kernel/exceptions-64s.S      | 250 ++------
 arch/powerpc/kernel/security.c            |   5 +-
 arch/powerpc/kernel/time.c                |  10 -
 arch/powerpc/kvm/Makefile                 |   4 +
 arch/powerpc/kvm/book3s.c                 |  17 +-
 arch/powerpc/kvm/book3s_64_entry.S        | 416 +++++++++++++
 arch/powerpc/kvm/book3s_64_vio_hv.c       |  12 -
 arch/powerpc/kvm/book3s_hv.c              | 696 ++++++++++++----------
 arch/powerpc/kvm/book3s_hv_builtin.c      | 135 +----
 arch/powerpc/kvm/book3s_hv_interrupts.S   |   9 +-
 arch/powerpc/kvm/book3s_hv_p9_entry.c     | 508 ++++++++++++++++
 arch/powerpc/kvm/book3s_hv_rm_mmu.c       |  12 +
 arch/powerpc/kvm/book3s_hv_rm_xics.c      |  15 -
 arch/powerpc/kvm/book3s_hv_rmhandlers.S   | 684 +--------------------
 arch/powerpc/kvm/book3s_segment.S         |   3 +
 arch/powerpc/kvm/book3s_xive.c            | 113 +++-
 arch/powerpc/kvm/book3s_xive.h            |   7 -
 arch/powerpc/kvm/book3s_xive_native.c     |  10 -
 arch/powerpc/mm/book3s64/radix_pgtable.c  |  27 +-
 arch/powerpc/mm/book3s64/radix_tlb.c      |  46 --
 arch/powerpc/mm/mmu_context.c             |   4 +-
 arch/powerpc/platforms/powernv/idle.c     |  52 +-
 31 files changed, 1588 insertions(+), 1517 deletions(-)
 create mode 100644 arch/powerpc/kvm/book3s_64_entry.S
 create mode 100644 arch/powerpc/kvm/book3s_hv_p9_entry.c

-- 
2.23.0

