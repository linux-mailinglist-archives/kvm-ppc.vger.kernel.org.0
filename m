Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF093E9536
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbhHKQCJ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbhHKQCI (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:02:08 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA2EC061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:01:44 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id fa24-20020a17090af0d8b0290178bfa69d97so5806149pjb.0
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wnb1qv9jtR0YHYN8nS9SRaMD7upzhDvCoKMvqB6Y45c=;
        b=U2vlhMT1D9nXIxdTN6cLBtu3AlINpkLCljMmK/pRy7rtKZmLB02sgP3sJ8Lc0+j5nT
         darChkZIBtS49CuTKUEnJOVQEWKov81HiGmtr7r62Qfj5e3KazOmQncxJWcppTw6T5pw
         0u3iZvn5CvSNA7bPXyNzOSYnPLlQdcOOWIe/emUKpSyHRWwYyJXkHBO/WjuSUtFGPY99
         vqpNO+hAdLBVSSBbGSmeMP8VYNdgM88iHsKV76J1hdhhT4Dc5jQXH9CXWaEFksL3X2Mm
         Vg5gcDNFzwlMNQ1qJecsTmg4yX0HvnDfNgwjB1AewmWQFx5bffe7iwre30Jv64Pk6pxs
         /gdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wnb1qv9jtR0YHYN8nS9SRaMD7upzhDvCoKMvqB6Y45c=;
        b=jg0ZeX3gDt9a7DSvc/aL7HGeOIisEZEvB14MZQysMDqykBlxq1WInie2d+lUkZHvNG
         dmK00orJGh2vDaEsoTrGy14ULOu7BVnfYMlv+usIZJK2A2xkb9Q9l3Solkv582/+B5zE
         tMlAVTbZzWtSzZHicwJWsc7b88g3bZ6yqqN3ExGJkQFAR3bjNMvqd/5vcWk48jg9Jvf5
         jAbFYs05bvJqfX/s1xZEtiQVmBEutHXus6dQy0p3xUDaOjwlcR9CumFL8WmQ3zl7YHtx
         xBS1B5C7bpcsYNNxZDh1iQ6rp6ohWMJDcV9TER+aoYEXQIQN0kuL1sYdge1ikO1gifHs
         Fnbg==
X-Gm-Message-State: AOAM5308IlSu3wWBRutreFPrIRWYTUvdrGbUBaVkgrqspMKFLslioxeg
        zSrKaSEHa68HvnFxaFOv3cqrhekCidc=
X-Google-Smtp-Source: ABdhPJzLO1NEOpqHs/cm2iF6r+BDk/7p/MVEO6CO5MyvcMe/0S6tEwakMkf3HbebEYYaHqzETU4Npw==
X-Received: by 2002:a17:90a:de12:: with SMTP id m18mr11170173pjv.221.1628697704064;
        Wed, 11 Aug 2021 09:01:44 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:01:43 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 00/60] KVM: PPC: Book3S HV P9: entry/exit optimisations
Date:   Thu, 12 Aug 2021 02:00:34 +1000
Message-Id: <20210811160134.904987-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This reduces radix guest full entry/exit latency on POWER9 and POWER10
by 2x.

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

- Reduce locking, barriers, atomics related to the vcpus-per-vcore > 1
  handling that the P9 path does not require.

Changes since v1:
- Verified DPDES changes still work with msgsndp SMT emulation.
- Fixed HMI handling bug.
- Split softpatch handling fixes into smaller pieces.
- Rebased with Fabiano's latest HV sanitising patches.
- Fix TM demand faulting bug causing nested guest TM tests to TM Bad
  Thing the host in rare cases.
- Re-name new "pmu=" command line option to "pmu_override=" and update
  documentation wording.
- Add default=y config option rather than unconditionally removing the
  L0 nested PMU workaround.
- Remove unnecessary MSR[RI] updates in entry/exit. Down to about 4700
  cycles now.
- Another bugfix from Alexey's testing.

Changes since RFC:
- Rebased with Fabiano's HV sanitising patches at the front.
- Several demand faulting bug fixes mostly relating to nested guests.
- Removed facility demand-faulting from L0 nested entry/exit handler.
  Demand faulting is still done in the L1, but not the L0. The reason
  is to reduce complexity (although it's only a small amount of
  complexity), reduce demand faulting overhead that may require several

Fabiano Rosas (3):
  KVM: PPC: Book3S HV Nested: Sanitise vcpu registers
  KVM: PPC: Book3S HV Nested: Stop forwarding all HFUs to L1
  KVM: PPC: Book3S HV Nested: save_hv_return_state does not require trap
    argument

Nicholas Piggin (57):
  KVM: PPC: Book3S HV: Initialise vcpu MSR with MSR_ME
  KVM: PPC: Book3S HV: Remove TM emulation from POWER7/8 path
  KVM: PPC: Book3S HV P9: Fixes for TM softpatch interrupt NIP
  KVM: PPC: Book3S HV Nested: Fix TM softpatch HFAC interrupt emulation
  KVM: PPC: Book3S HV Nested: Make nested HFSCR state accessible
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
  KVM: PPC: Book3S HV P9: Avoid changing MSR[RI] in entry and exit
  KVM: PPC: Book3S HV P9: Add unlikely annotation for !mmu_ready
  KVM: PPC: Book3S HV P9: Avoid cpu_in_guest atomics on entry and exit
  KVM: PPC: Book3S HV P9: Remove most of the vcore logic
  KVM: PPC: Book3S HV P9: Tidy kvmppc_create_dtl_entry
  KVM: PPC: Book3S HV P9: Stop using vc->dpdes
  KVM: PPC: Book3S HV P9: Remove subcore HMI handling

 .../admin-guide/kernel-parameters.txt         |   8 +
 arch/powerpc/include/asm/asm-prototypes.h     |   5 -
 arch/powerpc/include/asm/kvm_asm.h            |   1 +
 arch/powerpc/include/asm/kvm_book3s.h         |   6 +
 arch/powerpc/include/asm/kvm_book3s_64.h      |   6 +-
 arch/powerpc/include/asm/kvm_host.h           |   7 +-
 arch/powerpc/include/asm/kvm_ppc.h            |   1 +
 arch/powerpc/include/asm/pmc.h                |   7 +
 arch/powerpc/include/asm/reg.h                |   3 +-
 arch/powerpc/include/asm/switch_to.h          |   2 +
 arch/powerpc/include/asm/time.h               |  19 +-
 arch/powerpc/kernel/cpu_setup_power.c         |  12 +-
 arch/powerpc/kernel/dt_cpu_ftrs.c             |   8 +-
 arch/powerpc/kernel/process.c                 |  32 +
 arch/powerpc/kernel/time.c                    |  54 +-
 arch/powerpc/kvm/Kconfig                      |  15 +
 arch/powerpc/kvm/book3s_64_mmu_radix.c        |   4 +
 arch/powerpc/kvm/book3s_hv.c                  | 890 ++++++++++--------
 arch/powerpc/kvm/book3s_hv.h                  |  41 +
 arch/powerpc/kvm/book3s_hv_builtin.c          |   2 +
 arch/powerpc/kvm/book3s_hv_hmi.c              |   7 +-
 arch/powerpc/kvm/book3s_hv_interrupts.S       |  13 +-
 arch/powerpc/kvm/book3s_hv_nested.c           | 109 ++-
 arch/powerpc/kvm/book3s_hv_p9_entry.c         | 817 +++++++++++++---
 arch/powerpc/kvm/book3s_hv_ras.c              |  54 ++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S       | 115 +--
 arch/powerpc/kvm/book3s_hv_tm.c               |  61 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c      |  15 -
 arch/powerpc/perf/core-book3s.c               |  35 +
 arch/powerpc/platforms/powernv/idle.c         |  10 +-
 30 files changed, 1589 insertions(+), 770 deletions(-)
 create mode 100644 arch/powerpc/kvm/book3s_hv.h

-- 
2.23.0

