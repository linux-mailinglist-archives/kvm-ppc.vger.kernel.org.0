Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9FD30B595
	for <lists+kvm-ppc@lfdr.de>; Tue,  2 Feb 2021 04:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhBBDEP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 1 Feb 2021 22:04:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhBBDEG (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 1 Feb 2021 22:04:06 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338A8C061573
        for <kvm-ppc@vger.kernel.org>; Mon,  1 Feb 2021 19:03:26 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id b8so11629757plh.12
        for <kvm-ppc@vger.kernel.org>; Mon, 01 Feb 2021 19:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XnMUGqo6v78Eh/fRxn0LKxydpRpgQp2lWUKIA3uSBwg=;
        b=oqSZBfla6Syh4Wf97Rza+UzgRlPbCwFuCIhFkhdYt1F/QcFe/DpObhcI4+TKeUPYHz
         ZAehemmixU1PaMcqq1AsEx3aM1CXOYhD/rPMhLUfNWHAE0tPm8X+7NMZdSlogeYMMo6Z
         jCZ7KJSVdEdkbeDSdgTcexONO9WLEhwH3YSpc/J6HwFLFgu+MMJGKyn/J4a72yyFOw71
         GP6lqcGzk5eIiFiN1SXeZ/8DpBVqTroWuvksTb4619IWFKr2zNMvL5AlueGD8PAf1TIL
         yMv0EeNMXSBF9L4zigqvbshEnT9EVTWTSA7hrJH+RJDvXmJ1AHv3t8YLWzTadSHkyaHf
         mmLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XnMUGqo6v78Eh/fRxn0LKxydpRpgQp2lWUKIA3uSBwg=;
        b=DO7n3K3AX/jrxYAhsHId0KuBaiSspIgfgEKpuSrg8rRzt+1UH187kok7tbuJGr78Ay
         jerMAWenhRZ8DP4Qatp6l7vDcOYK2KluBX7Rfu0efXAL+XEt21IGFUKg4aHrARmuKlYR
         9ZYcoP8Gx6gnanED9LsVj2wl8sDzybW8k36dKzu+hrDZdC6mGuM2JdynxVaqSKeFK4fE
         4ZBuUOOlz8Bsb5Xq5qhMS5JH4oE0ZxRQS+wcPr41xyig8eKIUrSCHWjIzaw3Puy3stvh
         4YCtwXv3+HUZLEWG2pHua9YHRPB1mGgZZceTSJlOY66jo3LGwK2aSC14Kkkz8DT9UkFB
         eEwg==
X-Gm-Message-State: AOAM533g0pRqGgq8l6OAKSS+3GY9/Jm0mLLFpPIY5FueNN+h+GeruBYR
        GiDqER9QXHAoAhqTx/lN3c5WSXhh2vA=
X-Google-Smtp-Source: ABdhPJzl/udEkMG/FNjx4O4cAOZRHx0YIFbfy1Nv6jQaHPQzD6AgeqfyexofMeJU7MlrmCjfEx5JQA==
X-Received: by 2002:a17:90a:f2cf:: with SMTP id gt15mr1899400pjb.166.1612235005509;
        Mon, 01 Feb 2021 19:03:25 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (192.156.221.203.dial.dynamic.acc50-nort-cbr.comindico.com.au. [203.221.156.192])
        by smtp.gmail.com with ESMTPSA id a24sm20877337pff.18.2021.02.01.19.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 19:03:25 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 0/9] KVM: PPC: Book3S: C-ify the P9 entry/exit code
Date:   Tue,  2 Feb 2021 13:03:04 +1000
Message-Id: <20210202030313.3509446-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This series goes on top of the KVM patches I sent for the next
merge window. It's pretty rough and incomplete at the moment but
has started booting a simple guest into busybox in sim.

One of the main points of this is to avoid running KVM in a special
mode (aka "realmode") which is hostile to the rest of Linux and can't
be instrumented well by core facilities or generally use core code.

The asm itself is also tricky to follow. It's nothing compared with the
old HV path when you sit down and go through it, but it's not trivial
and sharing code paths makes things painful too.

One issue is what to do about PR-KVM and pre-ISAv3.0 / HPT HV-KVM.

The old path could also be converted similarly to C, although that's a
far bigger job. At least removing the asm code sharing makes a (slight)
simplification to the old path for now.

This change is a pretty clean break in the low level exit/entry code,
and the rest of the code already has many divergences, so I don't think
this exacerbates the problem, but if those PR / old-HV are to be
maintained well then we should eat the cost early to modernise that
code too. If they stay walled off with these interface shims then
they'll just be harder to maintain and the problem will definitely not
get better.

Now, the number of people who understand PR-KVM and have time to
maintain it is roughly zero, and for the old HV path it's approaching
zero. The radix, LPAR-per-thread programming model by comparison is so
nice and simple, maybe its better to just keep the rest on life support
and keep them going for as long as we can with the bare minimum.

Thanks,
Nick

Nicholas Piggin (9):
  KVM: PPC: Book3S 64: move KVM interrupt entry to a common entry point
  KVM: PPC: Book3S 64: Move GUEST_MODE_SKIP test into KVM
  KVM: PPC: Book3S 64: add hcall interrupt handler
  KVM: PPC: Book3S HV: Move hcall early register setup to KVM
  powerpc/64s: Remove EXSLB interrupt save area
  KVM: PPC: Book3S HV: Move interrupt early register setup to KVM
  KVM: PPC: Book3S HV: move bad_host_intr check to HV handler
  KVM: PPC: Book3S HV: Minimise hcall handler calling convention
    differences
  KVM: PPC: Book3S HV: Implement the rest of the P9 entry/exit handling
    in C

 arch/powerpc/include/asm/asm-prototypes.h |   2 +-
 arch/powerpc/include/asm/exception-64s.h  |  13 ++
 arch/powerpc/include/asm/kvm_asm.h        |   3 +-
 arch/powerpc/include/asm/kvm_book3s_64.h  |   2 +
 arch/powerpc/include/asm/kvm_ppc.h        |   2 +
 arch/powerpc/include/asm/paca.h           |   3 +-
 arch/powerpc/kernel/asm-offsets.c         |   1 -
 arch/powerpc/kernel/exceptions-64s.S      | 259 +++-------------------
 arch/powerpc/kvm/Makefile                 |   6 +
 arch/powerpc/kvm/book3s_64_entry.S        | 232 +++++++++++++++++++
 arch/powerpc/kvm/book3s_hv.c              |  21 +-
 arch/powerpc/kvm/book3s_hv_interrupt.c    | 164 ++++++++++++++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S   | 136 ++----------
 arch/powerpc/kvm/book3s_segment.S         |   7 +
 arch/powerpc/kvm/book3s_xive.c            |  32 +++
 15 files changed, 523 insertions(+), 360 deletions(-)
 create mode 100644 arch/powerpc/kvm/book3s_64_entry.S
 create mode 100644 arch/powerpc/kvm/book3s_hv_interrupt.c

-- 
2.23.0

