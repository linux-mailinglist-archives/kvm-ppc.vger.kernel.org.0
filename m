Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD35421346
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236175AbhJDQCw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236219AbhJDQCw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:02:52 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AAB8C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:01:03 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id h1so4201511pfv.12
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E3/DKCuixot+rBhlKO9j8ghHV1VGiVQ2OCyqQ+LwbfU=;
        b=JukXO/CWwatMz5SxhFcIbBHgaJphaeMUwYM4ZamB2NqhfR+vdHchA+k/AkcLYSNMa6
         8uXd6kQv61Z+dUX/NwCFSpJU1ZFCg2Rs2DohiL6hh3iC3A+NcFzpsHn9rTQU/XPzp2FB
         D9SqG+rbVnHlZU9ZmOpQlI2Y7HeUV3Qn7lPAWJoPORz5SKF85WHPeFTmvyFPNDSTCs2d
         9sOd37BXAFeFTBhMKs7EI/yYmYyDbfQDlS0qcafvXIYVXRCsX07sKBNvrABjGTkmTW+l
         YnsmmZyursbVBkd5m13dhMeaXcoeqwz/i5HWjpd0VCXKvEvljYlp86MMGWh4A0aGctcI
         7tIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E3/DKCuixot+rBhlKO9j8ghHV1VGiVQ2OCyqQ+LwbfU=;
        b=IxaGZp5edceAqDV0g7a8PSie5x7ihj6TmDQaeOY9aeK3cRp06in4neTL3baLB3sUz/
         Y3D4vM9rkI7mDreTTFlHJvlQncHHcW0zsXYppQtNCY39ET92QS1/0BhTVFVYrwwuCyVg
         TCQbUl60n/DllMcUV5ZDBsb4yEBVVdBLO0ldr9t1N281YTKxSysaAJQCrUZkNfOMt+T1
         DoGdK4Dy0FAr9gW1nc9S+kxVSUXnH11WI8Ij7JGxa2voUL8thjvNcTEnzaGexazSKe0Q
         zmS02yHR3OIkdVSF3QpK1APSu2zChMlz71xIEvq7c8EbQpjZnfzQBbtenFR8VQsxWgqB
         LMag==
X-Gm-Message-State: AOAM531mm7tG1NsDSAika/dJIzzZqL/S59n9KpfbqNziEvYg/Ixg0H9s
        z4Vrf1E3qVAOBbooxk6ktg7qzJkpejg=
X-Google-Smtp-Source: ABdhPJyiPFmBGhxkhKL3Sqe3aVWJLGBJvZ4cYe/CzTRzt0ekVNfnUBzAGCvEMItzDbrWeB5a8FjD9A==
X-Received: by 2002:a63:b505:: with SMTP id y5mr11543461pge.91.1633363262377;
        Mon, 04 Oct 2021 09:01:02 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:01:02 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 00/52] KVM: PPC: Book3S HV P9: entry/exit optimisations
Date:   Tue,  5 Oct 2021 01:59:57 +1000
Message-Id: <20211004160049.1338837-1-npiggin@gmail.com>
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

Changes since v2:
- Rebased, several patches from the series were merged in the previous
  merge window.
- Fixed some compile errors noticed by kernel test robot.
- Added RB from Athira for the PMU stuff (thanks!)
- Split TIDR ftr check (patch 2) out into its own patch.
- Added a missed license tag on new file.

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

Thanks,
Nick

Nicholas Piggin (52):
  powerpc/64s: Remove WORT SPR from POWER9/10 (take 2)
  powerpc/64s: guard optional TIDR SPR with CPU ftr test
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
 arch/powerpc/include/asm/kvm_book3s_64.h      |   5 +-
 arch/powerpc/include/asm/kvm_host.h           |   7 +-
 arch/powerpc/include/asm/kvm_ppc.h            |   1 +
 arch/powerpc/include/asm/switch_to.h          |   3 +
 arch/powerpc/include/asm/time.h               |  19 +-
 arch/powerpc/kernel/cpu_setup_power.c         |  12 +-
 arch/powerpc/kernel/dt_cpu_ftrs.c             |   8 +-
 arch/powerpc/kernel/process.c                 |  34 +
 arch/powerpc/kernel/time.c                    |  54 +-
 arch/powerpc/kvm/Kconfig                      |  15 +
 arch/powerpc/kvm/book3s_64_entry.S            |  11 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c        |   4 +
 arch/powerpc/kvm/book3s_hv.c                  | 836 +++++++++---------
 arch/powerpc/kvm/book3s_hv.h                  |  42 +
 arch/powerpc/kvm/book3s_hv_builtin.c          |   2 +
 arch/powerpc/kvm/book3s_hv_hmi.c              |   7 +-
 arch/powerpc/kvm/book3s_hv_interrupts.S       |  13 +-
 arch/powerpc/kvm/book3s_hv_nested.c           |   8 +-
 arch/powerpc/kvm/book3s_hv_p9_entry.c         | 821 ++++++++++++++---
 arch/powerpc/kvm/book3s_hv_ras.c              |  54 ++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S       |  73 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c      |  15 -
 arch/powerpc/perf/core-book3s.c               |  35 +
 arch/powerpc/platforms/powernv/idle.c         |   9 +-
 arch/powerpc/xmon/xmon.c                      |  10 +-
 29 files changed, 1459 insertions(+), 659 deletions(-)
 create mode 100644 arch/powerpc/kvm/book3s_hv.h

-- 
2.23.0

