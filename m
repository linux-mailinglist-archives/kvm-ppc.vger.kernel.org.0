Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAAB3C9F33
	for <lists+kvm-ppc@lfdr.de>; Thu, 15 Jul 2021 15:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237428AbhGONRc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 15 Jul 2021 09:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbhGONRc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 15 Jul 2021 09:17:32 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29373C06175F
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Jul 2021 06:14:39 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id p22so5193264pfh.8
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Jul 2021 06:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bRUBKr+pcQvTSq7JQJ+usk7fg5wenAu/IEJC6e2X31Y=;
        b=Voha/AtEN8cfpYgNnmoHS4zRmfLt/Ky0HJGjI0qXteIW4qBKxxex7m4/4NTRwOvQaf
         ziDv25763qa/m7unNtszzXVQbdl/DC63sKVWXbC4AtqZ2xusQXf/FRHnjkGjhj7eW6pb
         X9UiEH/ie7Ag6jBfF21MMyQgszoaA+FZX5WUWTty7JAqW7xUg5vT8LsTqYcTIzkzRaOe
         HNKSuZGHFkUy9Vl3A9iDOqCX7ElLnBlc4GwGmLF8LCPVJE2Hav99JVmLRkDO6BA4hxNx
         S/ZwAbHAV/XrQ4S8FPDmtEy5+uZhTl0/lih3H2/mpnwNqxHyqd/8LC2o4dop1tMrDTeH
         9wLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bRUBKr+pcQvTSq7JQJ+usk7fg5wenAu/IEJC6e2X31Y=;
        b=Bt7XXNPHKS9h0v5DN24KS6zzOTAlpTdLFwM2d2yDNrpeWGIb8qIhBg9M/i6BnT5c0J
         /pOuzBLGdgv9Aei0FDSgNhBsQBRDEQncydxOIUT8Q/UhT0x6IDu7nSyV+QPUfZ7TM5KR
         iT4Z/7a1CcMsR1S1tQK+Qkp99bvhY3C5CGdr1u9cpw1waPUCr/rGNjIT83tezQqbUDdp
         +37mLqOpJ5ZG+rszTuY7UELohd1EWDfAFIkHK93UNQE4vpZmssRc8Joyod8Y2aJCLqW0
         PU9kL0S76Sg0D2ZQPkQDT8uq/ym6Q+NKS9s07ZKsWQc5L9Gq2FwwQe9yz8feeK7rHtVw
         etrg==
X-Gm-Message-State: AOAM530TZ9WtjRfMOjPI8Vj+TUhK4rQbijQjHjsMTr5R3CDtFt+m9r0+
        E1Gf50fOzIqPP+92BRyUa8BzRfz5GOaBJQ==
X-Google-Smtp-Source: ABdhPJzEUOyF67eFyKKF84MjZFlh7BZrh93X3lDArRwdckxRXBw4UQgZQXDedO7G19bVjn7Iedwr+g==
X-Received: by 2002:a63:4750:: with SMTP id w16mr4546776pgk.229.1626354878486;
        Thu, 15 Jul 2021 06:14:38 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (27-33-83-114.tpgi.com.au. [27.33.83.114])
        by smtp.gmail.com with ESMTPSA id g18sm6357670pfi.199.2021.07.15.06.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 06:14:37 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 0/6] KVM: PPC: Book3S HV P9: Reduce guest entry/exit
Date:   Thu, 15 Jul 2021 23:14:24 +1000
Message-Id: <20210715131424.146850-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This goes on top of the previous speedup series. The previous series is
mostly invovled with reducing the cost of SPR accesses. This one starts
to look beyond those, to atomics, barriers, and other logic that can be
reduced. After this series the P9 path uses very few things from the
vcore structure. This saves several hundred cycles for guest entry/exit
on a POWER9.

Thanks,
Nick

Nicholas Piggin (6):
  KVM: PPC: Book3S HV P9: Add unlikely annotation for !mmu_ready
  KVM: PPC: Book3S HV P9: Avoid cpu_in_guest atomics on entry and exit
  KVM: PPC: Book3S HV P9: Remove most of the vcore logic
  KVM: PPC: Book3S HV P9: Tidy kvmppc_create_dtl_entry
  KVM: PPC: Book3S HV P9: Stop using vc->dpdes
  KVM: PPC: Book3S HV P9: Remove subcore HMI handling

 arch/powerpc/include/asm/kvm_book3s_64.h |   1 -
 arch/powerpc/include/asm/kvm_host.h      |   1 -
 arch/powerpc/kvm/book3s_hv.c             | 250 +++++++++++++----------
 arch/powerpc/kvm/book3s_hv_builtin.c     |   2 +
 arch/powerpc/kvm/book3s_hv_hmi.c         |   7 +-
 arch/powerpc/kvm/book3s_hv_p9_entry.c    |  35 +++-
 arch/powerpc/kvm/book3s_hv_ras.c         |   4 +
 7 files changed, 185 insertions(+), 115 deletions(-)

-- 
2.23.0

