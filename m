Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D5837F7BC
	for <lists+kvm-ppc@lfdr.de>; Thu, 13 May 2021 14:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbhEMMX3 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 13 May 2021 08:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhEMMX0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 13 May 2021 08:23:26 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E872EC061574
        for <kvm-ppc@vger.kernel.org>; Thu, 13 May 2021 05:22:16 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id b15so8095760plh.10
        for <kvm-ppc@vger.kernel.org>; Thu, 13 May 2021 05:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ft0g2zD8408Z54jIUMFNMg0Bz9F8U7T73dGcm+3N1sc=;
        b=WgouQyYS1RzZQz5cgkB+QbAUWCmyfd8FavisI6f6E11Kj1ARvMhhhC2Dd9lIt85v6i
         4AViihE0E4IVJIglSG9phsDue3Q8dSX6FKhv3ZgotMB2fkL9P3NR+ftBxkH8ITAP3dyp
         1lNO7gzMd8OxBn/LB+y0qqjGE3PGbVzpr+L9ISnNiD9SJvKw/fSLnnOYdun9cYchMbT/
         4Tv6ngAhg3aXsNKrm5gVb8KwnsJQAwgiNoFRj025b4kKruUEky7z3sf8d8MAPZULGIB2
         PF8/NjgkdW2jiUNb13ZjTirwhbK9Q30NZDsJaWiFmGIIQ7pTBeGgBq8V4SPmhOerkBFF
         kWhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ft0g2zD8408Z54jIUMFNMg0Bz9F8U7T73dGcm+3N1sc=;
        b=qs1XmdSioUg1fUiiWjMrVqR2oTKm7dzuM1SWFFYeQHD9vVydf1eZf9/W0kGsL8Q3Eq
         ujAc2sFOVFWjOBDkcdlHjhnXJqn+YRYHo1MhgTHgZ+MaMwideU2UPDzb+ZAn4TBAf4+G
         E0WVMSchrvWhPkpqvZ/6KU4Tv0h65urwm4aWiDLrbb3S+qMqOpjj6hdoAQPRSqWlOTRL
         5n1VMxheNW0PErf59kl3EPs/8bPyIdEkIE8co8T0Ae3OJ03v26CtEUgsnU4N5IEUBjBP
         NmDZIInVj7KnFYnF+++gZ95NZqGLITNBjD1n3+nkI+z5Yozk4Xkh6X0ucua4hsebeMIV
         fdzw==
X-Gm-Message-State: AOAM533yEc0TN9uGDLBRXUXfaVdkPRTtlnoWecXkQ9gHwx8yDWIQkBLt
        jniuNg7Avopn6Zs+PKL3ObsXnKZUhZ/dPg==
X-Google-Smtp-Source: ABdhPJyDDIePA561klkx5Izw8hZ45eztbXOBhC78Ydo0jBoOihKyD0iPQUSkIgPRDYhphH3Eeyx0tA==
X-Received: by 2002:a17:903:208a:b029:ef:9465:ad10 with SMTP id d10-20020a170903208ab02900ef9465ad10mr4614574plc.53.1620908536360;
        Thu, 13 May 2021 05:22:16 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (14-201-155-8.tpgi.com.au. [14.201.155.8])
        by smtp.gmail.com with ESMTPSA id mp21sm6892416pjb.50.2021.05.13.05.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 05:22:16 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 0/4] KVM: PPC: Convert P9 HV path to C
Date:   Thu, 13 May 2021 22:22:03 +1000
Message-Id: <20210513122207.1897664-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This applies on top of these series:

https://patchwork.ozlabs.org/project/linuxppc-dev/list/?series=238649
https://patchwork.ozlabs.org/project/linuxppc-dev/list/?series=238941
https://patchwork.ozlabs.org/project/linuxppc-dev/list/?series=238946

This was broken out from the large Cify series. Since that was last
posted, changes are:

- Rebase, reordering of patches, tweaking changelog and comments.
- Changed P9 radix exist SLB sanitising to use 4x slbmte to clear
  rather than 8x slbmfee/slbmfev, which turns out to be faster (and
  is what today's asm code does) [from review from Paul].
- Renamed book3s_hv_interrupt.c to book3s_hv_p9_entry.c, which reduces
  confusion with book3s_hv_interrupts.S.
- Fixed !HV compile [Alexey].

Nicholas Piggin (4):
  KVM: PPC: Book3S HV P9: Move xive vcpu context management into
    kvmhv_p9_guest_entry
  KVM: PPC: Book3S HV P9: Move radix MMU switching instructions together
  KVM: PPC: Book3S HV P9: Stop handling hcalls in real-mode in the P9
    path
  KVM: PPC: Book3S HV P9: Implement the rest of the P9 path in C

 arch/powerpc/include/asm/asm-prototypes.h |   3 +-
 arch/powerpc/include/asm/kvm_asm.h        |   1 +
 arch/powerpc/include/asm/kvm_book3s_64.h  |   8 +
 arch/powerpc/include/asm/kvm_host.h       |   7 +-
 arch/powerpc/include/asm/kvm_ppc.h        |   6 +
 arch/powerpc/kernel/security.c            |   5 +-
 arch/powerpc/kvm/Makefile                 |   1 +
 arch/powerpc/kvm/book3s.c                 |   6 +
 arch/powerpc/kvm/book3s_64_entry.S        | 254 ++++++++++++++++++++++
 arch/powerpc/kvm/book3s_hv.c              | 155 +++++++++----
 arch/powerpc/kvm/book3s_hv_p9_entry.c     | 207 ++++++++++++++++++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S   | 120 +---------
 arch/powerpc/kvm/book3s_xive.c            |  64 ++++++
 13 files changed, 683 insertions(+), 154 deletions(-)
 create mode 100644 arch/powerpc/kvm/book3s_hv_p9_entry.c

-- 
2.23.0

