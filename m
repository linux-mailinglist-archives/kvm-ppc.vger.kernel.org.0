Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839CD3D51A0
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhGZDKR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhGZDKQ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:10:16 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35629C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:50:45 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id b6so11098859pji.4
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OjRP80SRdC4NrDoUYdepl+6SJi6oWXRm4ds0fD0adMM=;
        b=e3h+RNaE8aCMM2R/rKJ+2bvFQ+7TszexJNry5BJlijfPPSmD5yO1E+ZuRYb8fkO1Rt
         1v4SPjOiGcsRYhQyyXRWuLu8+5NYB48YvRDSiJQkMW3MBuQe1aq8Mp7uO/YvK1DC919e
         /gUpBQ37QjFb3D7QcknD9IpLiXbYGj9XdAVAaQYkORK4VcYaSTwzzfZW4LmItO7UqB3D
         LfsSEg9l+gk4R15HZf8FzwpoORLRCAXGS7X5KdBWgj5J4oJklipgAWpf556AIMfzDyfW
         T2Nr8yiZzAFYFsYY4Elv0riuTCLuLkWkHbw5LgMNK0C9r81y7nZm9JfEtrEqJT2N7ens
         vLeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OjRP80SRdC4NrDoUYdepl+6SJi6oWXRm4ds0fD0adMM=;
        b=SmoWu7EsYFdbqZaqKzLWNhYqPwxFhSNVfTCXUV15miS0YmHtz+2zUPbHGhatnqvwwB
         5GuYpUnB2y/WKl3I4rZ17m+O8uP51C9KogFt+7XlJx6XuJZvDaOOI3VYkoadeUJyh4PP
         yfLpQSzB8FtaToFTKiJOj7ZJn3Z1ANXW67YNE5nRxRmYV1i3TMpfs7PbeghIVTseuQRB
         vuJzs5R3/oxjjGIgoYcozvwqGF9eSsSHHQ7RSilw8v4oip54p/ow4PEVdee7nahqxMVP
         BfsEndSlZeNcl9eC3caPQ8ya4CfQD6cNJ8JmMmsKmXSvtcMrDw/+vbXpoXQr1pb+4zkk
         yeLw==
X-Gm-Message-State: AOAM530jFBEowa5e0LK4ow/PJukTOmBb8jcmI8OmQvvkb7iOIFnNVYJ/
        g7zqsKBm99uJ3i0DPazt3/ecAjTLj5c=
X-Google-Smtp-Source: ABdhPJzImlPtDWBfEXfFmj3SVqgOwjQjQ6oCxWfqPCfMGVETEH9KeP39snMbzaVCJe/Y7Et9/oNHfw==
X-Received: by 2002:a17:90b:1e10:: with SMTP id pg16mr15433609pjb.87.1627271444557;
        Sun, 25 Jul 2021 20:50:44 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:50:44 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 00/55] KVM: PPC: Book3S HV P9: entry/exit optimisations
Date:   Mon, 26 Jul 2021 13:49:41 +1000
Message-Id: <20210726035036.739609-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This reduces radix guest full entry/exit latency on POWER9 and POWER10
by almost 2x.

Nested HV guests should see smaller improvements in their L1 entry/exit,
but this is also combined with most L0 speedups also applying to nested
entry. nginx localhost throughput test in a SMP nested guest is improved
about 10% (in a direct guest it doesn't change much because it uses XIVE
for IPIs) when L0 and L1 are patched.

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

This also adds the 2nd round patches to the series, which improve
performance mostly by reducing locking, barriers, and atomics related
to the vcpus-per-vcore > 1 handling that the P9 path does not require.

Some of the numbers quoted in changelogs may have changed a bit with
patches being updated, reordered, etc. They give a bit of a guide, but
I might remove them from the final submission because they're too much
to maintain.

Changes since RFC:
- Rebased with Fabiano's HV sanitising patches at the front.
- Several demand faulting bug fixes mostly relating to nested guests.
- Removed facility demand-faulting from L0 nested entry/exit handler.
  Demand faulting is still done in the L1, but not the L0. The reason
  is to reduce complexity (although it's only a small amount of
  complexity), reduce demand faulting overhead that may require several
  interrupts, and allow better testing of the L1 demand faulting,
  because we may run on hypervisors that do not implement L0 demand
  faulting. In future, depending on performance and such, we could add
  demand faulting to L0 nested entry handling and/or remove it from the
  L1.
- Fixed a timebase problem with the HMI subcore patch.


Fabiano Rosas (2):
  KVM: PPC: Book3S HV: Sanitise vcpu registers in nested path
  KVM: PPC: Book3S HV: Stop forwarding all HFUs to L1

Nicholas Piggin (53):
  KVM: PPC: Book3S HV: Remove TM emulation from POWER7/8 path
  KVM: PPC: Book3S HV P9: Fixes for TM softpatch interrupt
  KVM: PPC: Book3S HV Nested: Reflect guest PMU in-use to L0 when guest
    SPRs are live
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
  powerpc/64s: Implement PMU override command line option
  KVM: PPC: Book3S HV P9: Implement PMU save/restore in C
  KVM: PPC: Book3S HV P9: Factor PMU save/load into context switch
    functions
  KVM: PPC: Book3S HV P9: Demand fault PMU SPRs when marked not inuse
  KVM: PPC: Book3S HV P9: Factor out yield_count increment
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
  KVM: PPC: Book3S HV P9: Add unlikely annotation for !mmu_ready
  KVM: PPC: Book3S HV P9: Avoid cpu_in_guest atomics on entry and exit
  KVM: PPC: Book3S HV P9: Remove most of the vcore logic
  KVM: PPC: Book3S HV P9: Tidy kvmppc_create_dtl_entry
  KVM: PPC: Book3S HV P9: Stop using vc->dpdes
  KVM: PPC: Book3S HV P9: Remove subcore HMI handling

 .../admin-guide/kernel-parameters.txt         |   7 +
 arch/powerpc/include/asm/asm-prototypes.h     |   5 -
 arch/powerpc/include/asm/kvm_asm.h            |   1 +
 arch/powerpc/include/asm/kvm_book3s.h         |   6 +
 arch/powerpc/include/asm/kvm_book3s_64.h      |   6 +-
 arch/powerpc/include/asm/kvm_host.h           |   6 +-
 arch/powerpc/include/asm/pmc.h                |   7 +
 arch/powerpc/include/asm/reg.h                |   3 +-
 arch/powerpc/include/asm/switch_to.h          |   2 +
 arch/powerpc/include/asm/time.h               |  19 +-
 arch/powerpc/kernel/cpu_setup_power.c         |  12 +-
 arch/powerpc/kernel/dt_cpu_ftrs.c             |   8 +-
 arch/powerpc/kernel/process.c                 |  30 +
 arch/powerpc/kernel/time.c                    |  54 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c        |   4 +
 arch/powerpc/kvm/book3s_hv.c                  | 857 ++++++++++--------
 arch/powerpc/kvm/book3s_hv.h                  |  36 +
 arch/powerpc/kvm/book3s_hv_builtin.c          |   2 +
 arch/powerpc/kvm/book3s_hv_hmi.c              |   7 +-
 arch/powerpc/kvm/book3s_hv_interrupts.S       |  13 +-
 arch/powerpc/kvm/book3s_hv_nested.c           | 131 +--
 arch/powerpc/kvm/book3s_hv_p9_entry.c         | 793 ++++++++++++++--
 arch/powerpc/kvm/book3s_hv_ras.c              |   4 +
 arch/powerpc/kvm/book3s_hv_rmhandlers.S       | 116 +--
 arch/powerpc/kvm/book3s_hv_tm.c               |  57 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c      |  15 -
 arch/powerpc/perf/core-book3s.c               |  35 +
 arch/powerpc/platforms/powernv/idle.c         |  10 +-
 28 files changed, 1508 insertions(+), 738 deletions(-)
 create mode 100644 arch/powerpc/kvm/book3s_hv.h

-- 
2.23.0

