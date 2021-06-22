Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08413B01EF
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhFVLAN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhFVLAM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:00:12 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369A5C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:57:57 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id c8so2258609pfp.5
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/onsYkPs3dfRAIn3wGRUeZzLH6Tuwz/Hl6UQ4x7dJH0=;
        b=deqysb54NEU9KznElL0N7r8EZ1SiutJ+WSC9YzzQeNiK4cHWI738plkSWTHt20v2Jb
         IhiQ1/M+zGL4GioJRIfeYL7tEzs2MwoOXnijopkrn6KfL0x2lb4ePvilxSXnZVzU8fcL
         0HRtKhXrrXtAPqtHoJ5TOUD4hcDXd7xvEToWg1i85ClgN7XEVHSxhX8i97P8gSwK11Zu
         LXcvMLltgCRGOvwEgfh3wOC4glhsUexQO4eEdbZtI5h3sTWcnwTzYD8oRBFSb8U92Q50
         EqXeax6wcpf5c8aRM3QMPCn2Ri2F6MFWPYTJ1YCFZCxZQIVCGEHdzTVZiPRYHZl7qhql
         Pv9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/onsYkPs3dfRAIn3wGRUeZzLH6Tuwz/Hl6UQ4x7dJH0=;
        b=pEKVfPp2VHWmyZmel35q0M75Tezlw/TUbRjczC/IloXMrHFcp2uJQ2m56qTNrh6hKc
         kadJ6WjD4QqUq98A6A9/CL1P/chQoGKpjBiGAeAcrWxkDQcmMUjHJY4dlFQM8gDHO/4H
         1c4Zgv3MtK8Y68F8PTOKND6dhwdJ1taVjpdo0jjZIJtQqrLlq3tYoGo57w5MXxK4uBw8
         Quagjan8ldInNCdUZ2EmCb8CcqcZ+cAFjmlvxJ+SZZ7W3C0w+E7hBr6WWvmN39n20ucf
         c7xGsygE68OA2LD+2byQlnBdC5dkk1gy9mVdeRBVNfx8YTja6oShV+6JjkfOjsDxNOGh
         86pQ==
X-Gm-Message-State: AOAM531sPP94Wf4owNhYtg+Ws3Q5Vi+NO3YUz9ky+lWnAHqaxamlnjIP
        F9SQHQKXnpaih+hSoTH7FvgtTWiLnIk=
X-Google-Smtp-Source: ABdhPJw41oMwYWmEPgVT/O9oQYi6bom5hbZOpzmeqVE+q3GDm1EopRcuAW1eNufkq8x+sKJP/bKo+A==
X-Received: by 2002:a05:6a00:ac2:b029:300:effd:4320 with SMTP id c2-20020a056a000ac2b0290300effd4320mr3030388pfl.76.1624359476610;
        Tue, 22 Jun 2021 03:57:56 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:57:56 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 00/43] KVM: PPC: Book3S HV P9: entry/exit optimisations round 1
Date:   Tue, 22 Jun 2021 20:56:53 +1000
Message-Id: <20210622105736.633352-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This series applies to powerpc topic/ppc-kvm branch (KVM Cify
series in particular), plus "KVM: PPC: Book3S HV Nested: Reflect L2 PMU
in-use to L0 when L2 SPRs are live" posted to kvm-ppc.

This reduces radix guest full entry/exit latency on POWER9 and POWER10
by almost 2x (hash is similar but it's still significantly slower than
the P7/8 real mode handler). Nested HV guests should see speedups with
some smaller improvements in the L1, plus the L0 switching sees many
of the same speedups as a direct guest.

It does this in several main ways:

- Rearrange code to optimise SPR accesses. Mainly, avoid scoreboard
  stalls.

- Test SPR values to avoid mtSPRs where possible. mtSPRs are expensive.

- Reduce mftb. mftb is expensive.

- Demand fault certain facilities to avoid saving and/or restoring them
  (at the cost of fault when they are used, but this is mitigated over
  a number of entries, like the facilities when context switching 
  processes). PM, TM, and EBB so far.

- Defer some sequences that are made just in case a guest is interrupted
  in the middle of a critical section to the case where the guest is
  scheduled on a different CPU, rather than every time (at the cost of
  an extra IPI in this case). Namely the tlbsync sequence for radix with
  GTSE, which is very expensive.

Some of the numbers quoted in changelogs may have changed a bit with
patches being updated, reordered, etc. They give a bit of a guide, but
I might remove them from the final submission because they're too much
to maintain.

Thanks,
Nick

Nicholas Piggin (43):
  powerpc/64s: Remove WORT SPR from POWER9/10
  KMV: PPC: Book3S HV P9: Use set_dec to set decrementer to host
  KVM: PPC: Book3S HV P9: Use host timer accounting to avoid decrementer
    read
  KVM: PPC: Book3S HV P9: Use large decrementer for HDEC
  KVM: PPC: Book3S HV P9: Reduce mftb per guest entry/exit
  powerpc/time: add API for KVM to re-arm the host timer/decrementer
  KVM: PPC: Book3S HV: POWER10 enable HAIL when running radix guests
  powerpc/64s: Keep AMOR SPR a constant ~0 at runtime
  KVM: PPC: Book3S HV: Don't always save PMU for guest capable of
    nesting
  powerpc/64s: Always set PMU control registers to frozen/disabled when
    not in use
  KVM: PPC: Book3S HV P9: Implement PMU save/restore in C
  KVM: PPC: Book3S HV P9: Factor out yield_count increment
  KVM: PPC: Book3S HV P9: Factor PMU save/load into context switch
    functions
  KVM: PPC: Book3S HV P9: Demand fault PMU SPRs when marked not inuse
  KVM: PPC: Book3S HV: CTRL SPR does not require read-modify-write
  KVM: PPC: Book3S HV P9: Move SPRG restore to restore_p9_host_os_sprs
  KVM: PPC: Book3S HV P9: Reduce mtmsrd instructions required to save
    host SPRs
  KVM: PPC: Book3S HV P9: Improve mtmsrd scheduling by delaying MSR[EE]
    disable
  KVM: PPC: Book3S HV P9: Add kvmppc_stop_thread to match
    kvmppc_start_thread
  KVM: PPC: Book3S HV: Change dec_expires to be relative to guest
    timebase
  KVM: PPC: Book3S HV P9: Move TB updates
  KVM: PPC: Book3S HV P9: Optimise timebase reads
  KVM: PPC: Book3S HV P9: Avoid SPR scoreboard stalls
  KVM: PPC: Book3S HV P9: Only execute mtSPR if the value changed
  KVM: PPC: Book3S HV P9: Juggle SPR switching around
  KVM: PPC: Book3S HV P9: Move vcpu register save/restore into functions
  KVM: PPC: Book3S HV P9: Move host OS save/restore functions to
    built-in
  KVM: PPC: Book3S HV P9: Move nested guest entry into its own function
  KVM: PPC: Book3S HV P9: Move remaining SPR and MSR access into low
    level entry
  KVM: PPC: Book3S HV P9: Implement TM fastpath for guest entry/exit
  KVM: PPC: Book3S HV P9: Switch PMU to guest as late as possible
  KVM: PPC: Book3S HV P9: Restrict DSISR canary workaround to processors
    that require it
  KVM: PPC: Book3S HV P9: More SPR speed improvements
  KVM: PPC: Book3S HV P9: Demand fault EBB facility registers
  KVM: PPC: Book3S HV P9: Demand fault TM facility registers
  KVM: PPC: Book3S HV P9: Use Linux SPR save/restore to manage some host
    SPRs
  KVM: PPC: Book3S HV P9: Comment and fix MMU context switching code
  KVM: PPC: Book3S HV P9: Test dawr_enabled() before saving host DAWR
    SPRs
  KVM: PPC: Book3S HV P9: Don't restore PSSCR if not needed
  KVM: PPC: Book3S HV P9: Avoid tlbsync sequence on radix guest exit
  KVM: PPC: Book3S HV Nested: Avoid extra mftb() in nested entry
  KVM: PPC: Book3S HV P9: Improve mfmsr performance on entry
  KVM: PPC: Book3S HV P9: Optimise hash guest SLB saving

 arch/powerpc/include/asm/asm-prototypes.h |   5 -
 arch/powerpc/include/asm/kvm_asm.h        |   1 +
 arch/powerpc/include/asm/kvm_book3s.h     |   6 +
 arch/powerpc/include/asm/kvm_book3s_64.h  |   4 +-
 arch/powerpc/include/asm/kvm_host.h       |   5 +-
 arch/powerpc/include/asm/switch_to.h      |   2 +
 arch/powerpc/include/asm/time.h           |  19 +-
 arch/powerpc/kernel/cpu_setup_power.c     |  12 +-
 arch/powerpc/kernel/dt_cpu_ftrs.c         |   8 +-
 arch/powerpc/kernel/process.c             |  30 +
 arch/powerpc/kernel/time.c                |  54 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c    |   4 +
 arch/powerpc/kvm/book3s_hv.c              | 628 +++++++++----------
 arch/powerpc/kvm/book3s_hv.h              |  36 ++
 arch/powerpc/kvm/book3s_hv_interrupts.S   |  13 +-
 arch/powerpc/kvm/book3s_hv_nested.c       |  21 +-
 arch/powerpc/kvm/book3s_hv_p9_entry.c     | 725 +++++++++++++++++++---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S   |  74 +--
 arch/powerpc/mm/book3s64/radix_pgtable.c  |  15 -
 arch/powerpc/perf/core-book3s.c           |   7 +
 arch/powerpc/platforms/powernv/idle.c     |  10 +-
 21 files changed, 1143 insertions(+), 536 deletions(-)
 create mode 100644 arch/powerpc/kvm/book3s_hv.h

-- 
2.23.0

