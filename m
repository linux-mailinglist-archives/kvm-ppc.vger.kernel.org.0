Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFA3E8F997
	for <lists+kvm-ppc@lfdr.de>; Fri, 16 Aug 2019 06:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbfHPEHs (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 16 Aug 2019 00:07:48 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40961 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfHPEHs (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 16 Aug 2019 00:07:48 -0400
Received: by mail-pf1-f194.google.com with SMTP id 196so2426495pfz.8
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Aug 2019 21:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nFEM/d7HA8S025LPfsz2KN5UKEOo8SVPz08/9wibTs8=;
        b=aLkfZORjgZLqWShU3gWEKEin71YSrlPYtJ+6jHfehxPGNO4uF3t0IC4Han+2vjKMPM
         VejsTz3Ur+L9u8wOPn76TAYnqlt57X9zIPalr075FFntJeaSZOQ73E8itF1Kdprn5JD8
         xK+Nw9mftagtTKlFuu5OS9u07KRdxV87jmOBAJTSu9V/rxomRDWAvVyeKpIBK5OTX3aD
         9FBvpyGkxvo3RaK2cu4PSR8sDBUJi6PTTW5yAlI59ZM6uhNj+mTt1BG5SF9WDl3U4xJt
         FpqlLpvyEJLWLFAWntrjgaXSSKcxdsR36L4H8/IOtxent63QooPYSJr5plpLYJXejs+p
         CM+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nFEM/d7HA8S025LPfsz2KN5UKEOo8SVPz08/9wibTs8=;
        b=fIlPM5Xqc7Sq0gjsf5LRZqHwjnOi7MxDU9LcNiNTU4CNxs12RFy9O1U3hV5cj0D2pZ
         g3IWXpSb9APEPZKWJ0O2cUHvGSixBhGK5AQJDgvYbUq4FArcg+2RfBMRRoJNC6WmIJfZ
         kl5quU7T1mMZMDrnHhORa934E8rDAF6Rw9Dcs3tHczgYHInM4MDqQTAfrWmqD3pb2YjY
         p8nyJ0Hl1E8385xqJ9JvuI3SCQoJxaOaksluMkchr7K4gihVILuHzOR21fUuqgHqr3rS
         jigIAh1J/LQmdrWuz2hwpPOGo7d12X+y3rRMOpoowLdUpnakOq4EzLMGiZmwMaowxFUb
         Lv9g==
X-Gm-Message-State: APjAAAXYhqPyo+CoxHaRi40LnN4oY/Fe7LeIivPVVtZ6J4OG1vxOavjo
        aA3/z4E+X1INjZx7R2fkKME=
X-Google-Smtp-Source: APXvYqyqsaeaJfJYViB7G0cDITZyTzhnYbuDI1mcX7bVMo8T0rL3K694o7uEAMO6A/2ltFcjXBQcJw==
X-Received: by 2002:aa7:9483:: with SMTP id z3mr8888700pfk.104.1565928467479;
        Thu, 15 Aug 2019 21:07:47 -0700 (PDT)
Received: from bobo.local0.net (61-68-63-22.tpgi.com.au. [61.68.63.22])
        by smtp.gmail.com with ESMTPSA id j187sm4994850pfg.178.2019.08.15.21.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 21:07:46 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org,
        Anton Blanchard <anton@ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH 0/3] series to optionally disable tlbie for 64s/radix
Date:   Fri, 16 Aug 2019 14:07:30 +1000
Message-Id: <20190816040733.5737-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Since the RFC I accounted for feedback, and also made the patch more
complete so we can actually boot and run a 64s/radix kernel without
using tlbie at all.

KVM and bare metal hash are harder to support. Bare metal hash because
it does some TLB invation with interrupts disabled (can't use IPIs).
It might be possible those invalidates could be avoided or the paths
changed to enable interrupts, but it would be a much bigger change.

KVM with radix guests might be acutally quite simple to support, so I
can look at that next if we get this merged.

KVM with hash guests might not be feasible to do in a performant way,
because of the design of virtualised hash architecture (host flushes
guest effective addresses), at least it would need special real mode
IPI handlers for TLB flushes.

Thanks,
Nick

Nicholas Piggin (3):
  powerpc/64s: Remove mmu_partition_table_set
  powerpc/64s/radix: all CPUs should flush local translation structure
    before turning MMU on
  powerpc/64s: introduce options to disable use of the tlbie instruction

 .../admin-guide/kernel-parameters.txt         |   4 +
 arch/powerpc/include/asm/book3s/64/tlbflush.h |   9 +
 arch/powerpc/include/asm/mmu.h                |   2 -
 arch/powerpc/kvm/book3s_hv.c                  |  10 +-
 arch/powerpc/kvm/book3s_hv_nested.c           |  35 +++-
 arch/powerpc/mm/book3s64/hash_utils.c         |   4 +-
 arch/powerpc/mm/book3s64/mmu_context.c        |   4 +-
 arch/powerpc/mm/book3s64/pgtable.c            |  77 +++++---
 arch/powerpc/mm/book3s64/radix_pgtable.c      |  22 +--
 arch/powerpc/mm/book3s64/radix_tlb.c          | 182 ++++++++++++++++--
 arch/powerpc/mm/pgtable_64.c                  |   5 +-
 drivers/misc/cxl/main.c                       |   4 +
 drivers/misc/ocxl/main.c                      |   4 +
 13 files changed, 282 insertions(+), 80 deletions(-)

-- 
2.22.0

