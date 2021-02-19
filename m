Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41B131F51B
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Feb 2021 07:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhBSGgc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Feb 2021 01:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhBSGgb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 Feb 2021 01:36:31 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF596C061574
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:35:50 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id ba1so2832404plb.1
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UymbtmbdqSs8j3UG2YdaaaUw62kh30J7HQRbQZoqk44=;
        b=YhOxqAvJA2J4SAvdzaUv4tDBFzuXDZF1zkP7zX3jz+8qFSCkYd7ZfgZYRdqfe1M2Hy
         lOdZP8Fw1owFl9bFOqKTlz+RHfv427I4CaOvtCYII5THolZQkdb5Np8f4vD0YmgD5Ae1
         Jm9Qz5XMj9FkeJLYWlqnuaV+n6sqRlYr7Rucgv2U8oW5H49n8TbxdrTcPCJHnANGEbkV
         cnwjL5q64FH4YFZO9+GuDnd2/GkdANjld8+8nax98ea4rYAIQb5hq/ZnW9cny1BYRdGw
         INy30LZBprtcvCnsq5mpQK7x+wCxiIt1epiUubRqe9iyMwJh30EnLCyPDhm/KcYx2JVK
         MjuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UymbtmbdqSs8j3UG2YdaaaUw62kh30J7HQRbQZoqk44=;
        b=N6cRnmsBRrravalSWgM3oDx6/UuPc5ZCWh5axcybjUcEgd/aeunKNtivDT25M+894h
         RDHaKDmTmiFwPnlhYoiFpjJz4LLEM6nYkuE1/4nYEqsfsmX494wqCbe3JKVu/tUkRhpY
         y8V+tzPQLYbDzyQFxg7x/fB23vphAEEm1j1K0LVgY/+t63c7kHa7p1Ryn8KYlv8URD2S
         06DFvePOD8y+10xUOw3XQAIoKsGPBjSj+HZKnnIpk2HycG8l03mjrpBlM6xO2NXhRvIx
         0FZEa6Wv/5bVfcXv87/rkFezeXvpVQSf+Jk2WSwRlxPYVBgmF5QPME1jIKjl49hpiZlv
         2NVw==
X-Gm-Message-State: AOAM533EYoyQH5i0iITAQixKAoutAx8rkAftizXJh/cpSeKqyonMb23R
        nXIeIqPyHre69dC9+clR7d01Ic6pkbU=
X-Google-Smtp-Source: ABdhPJyPRF0a10TfMG/EtsZivUGEtkgV3v8OiBgHlDh9o99Xn820XzQu15exvkO9OkfpQkmyHOP2bg==
X-Received: by 2002:a17:902:e5c4:b029:e3:b422:34ef with SMTP id u4-20020a170902e5c4b02900e3b42234efmr455796plf.26.1613716549848;
        Thu, 18 Feb 2021 22:35:49 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (14-201-150-91.tpgi.com.au. [14.201.150.91])
        by smtp.gmail.com with ESMTPSA id v16sm7813099pfu.76.2021.02.18.22.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 22:35:49 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 00/13] KVM: PPC: Book3S: C-ify the P9 entry/exit code
Date:   Fri, 19 Feb 2021 16:35:29 +1000
Message-Id: <20210219063542.1425130-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This has a lot more implemented, things tidied up, and more things split
out. It's also implemented on top of powerpc next and kvm next which
have a few prerequisite patches (mainly removing EXSLB).

I've got a bunch more things after this including implementing HPT
guests with radix host in the "new" path -- whether we ever actually
want to do that, or port the legacy path up to C, or just leave it to
maintenance mode, I was just testing the waters there and making sure I
wasn't doing something fundamentally incompatible with hash.

I won't post anything further than this for now because I think it's a
good start and gets the total asm code for KVM entry and exit down to
about 160 lines plus the shim for the legacy paths. So would like to
concentrate on getting this in before juggling things around too much
or adding new things.

Thanks,
Nick

Nicholas Piggin (13):
  powerpc/64s: Remove KVM handler support from CBE_RAS interrupts
  powerpc/64s: remove KVM SKIP test from instruction breakpoint handler
  KVM: PPC: Book3S HV: Ensure MSR[ME] is always set in guest MSR
  KVM: PPC: Book3S 64: remove unused kvmppc_h_protect argument
  KVM: PPC: Book3S 64: move KVM interrupt entry to a common entry point
  KVM: PPC: Book3S 64: Move GUEST_MODE_SKIP test into KVM
  KVM: PPC: Book3S 64: add hcall interrupt handler
  KVM: PPC: Book3S HV: Move hcall early register setup to KVM
  KVM: PPC: Book3S HV: Move interrupt early register setup to KVM
  KVM: PPC: Book3S HV: move bad_host_intr check to HV handler
  KVM: PPC: Book3S HV: Minimise hcall handler calling convention
    differences
  KVM: PPC: Book3S HV: Move radix MMU switching together in the P9 path
  KVM: PPC: Book3S HV: Implement the rest of the P9 entry/exit handling
    in C

 arch/powerpc/include/asm/asm-prototypes.h |   3 +-
 arch/powerpc/include/asm/exception-64s.h  |  13 +
 arch/powerpc/include/asm/kvm_asm.h        |   3 +-
 arch/powerpc/include/asm/kvm_book3s_64.h  |   2 +
 arch/powerpc/include/asm/kvm_ppc.h        |   5 +-
 arch/powerpc/kernel/exceptions-64s.S      | 257 +++----------------
 arch/powerpc/kernel/security.c            |   5 +-
 arch/powerpc/kvm/Makefile                 |   6 +
 arch/powerpc/kvm/book3s_64_entry.S        | 295 ++++++++++++++++++++++
 arch/powerpc/kvm/book3s_hv.c              |  69 +++--
 arch/powerpc/kvm/book3s_hv_builtin.c      |   7 +
 arch/powerpc/kvm/book3s_hv_interrupt.c    | 208 +++++++++++++++
 arch/powerpc/kvm/book3s_hv_rm_mmu.c       |   3 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S   | 125 +--------
 arch/powerpc/kvm/book3s_segment.S         |   7 +
 arch/powerpc/kvm/book3s_xive.c            |  32 +++
 16 files changed, 670 insertions(+), 370 deletions(-)
 create mode 100644 arch/powerpc/kvm/book3s_64_entry.S
 create mode 100644 arch/powerpc/kvm/book3s_hv_interrupt.c

-- 
2.23.0

