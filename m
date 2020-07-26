Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212F522DB92
	for <lists+kvm-ppc@lfdr.de>; Sun, 26 Jul 2020 05:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgGZDwL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 25 Jul 2020 23:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgGZDwK (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 25 Jul 2020 23:52:10 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9E1C0619D2
        for <kvm-ppc@vger.kernel.org>; Sat, 25 Jul 2020 20:52:10 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id w126so7132903pfw.8
        for <kvm-ppc@vger.kernel.org>; Sat, 25 Jul 2020 20:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SX3waSOwvWtbt+qxV9rfiwGFPf3TjuzEFNm2XiZC97k=;
        b=JxQpDO4sXaL0H2Y086nSrR/yZLDTlovI1PalJRgKsHrkkFCozRBzrp/M4b61ECkQ1X
         EK2klsT7w3EZZX+WfFtK2yc+HDkN4Sh4/C0p86KA0xxia6N0jKoYB3SpRxDfBFyz9yx5
         0d1qQwR2LHw+IuE9y6OKs1rFDK675578lX4OyW0hjm9ouHhljN4VySR2JIqCuVD7lMCg
         llgi+STum88sZ9g0zbttirvyBQoNI/r7PBDQxOvcTv3W9tO0vHSStpD0c69FO3HtKFbN
         J6aFK5E+pvT3giwX2ROBi4uyTUbY8TBm5puKXimxbqGmTQ0r3KT6Fcl1CNQVHNQ+UFGv
         y8tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SX3waSOwvWtbt+qxV9rfiwGFPf3TjuzEFNm2XiZC97k=;
        b=JOYwuffdMecbOt0QOKyld+PQPBQhvvzh6v8s3VUcdVsvI/qSKLPlogsAW2GYtyMLJg
         yPlDWGUGFpsP4al8NOwaz00ZmFi/vnIA+vsHzQWE638LqSXBqmtk2Q5W7POsa2tlfeLX
         WsjBwS5nSBHSEKUoXXvNNAQDvX1RSAOKmkGMCKEKnss/4mK9Sx62vTRXWORmTUE2Hr4M
         75Il4lKIuTETsMGHi5St6R/RG46pQGZxNgyDYYhPHyhNLs7gaAB5l1L5z4hGtt9C0uNK
         8cmtp/XWBHa8xYwRO6RThJHsH4ZAOLInmKuAHd58r2dAXyTAP78E8zhEFrAcCku0sOlM
         i6ow==
X-Gm-Message-State: AOAM532btmz9gBe0gZGleN+qrCaOYmzI4+RetyRSAaXkoTZ5jb4MsIXp
        CqYBIxFKXQSBvz85JPrqoqI=
X-Google-Smtp-Source: ABdhPJw7sKVaB5XsX4EFRVYUpFw8L8U00v6SelmOIRTuyaS2qGaZjYzkcRozLB105R3VTvJQ9sw3nQ==
X-Received: by 2002:a63:8949:: with SMTP id v70mr14345804pgd.256.1595735528747;
        Sat, 25 Jul 2020 20:52:08 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (110-174-173-27.tpgi.com.au. [110.174.173.27])
        by smtp.gmail.com with ESMTPSA id p1sm3638860pjp.10.2020.07.25.20.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 20:52:07 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Anton Blanchard <anton@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@ozlabs.org>, kvm-ppc@vger.kernel.org
Subject: [PATCH v3 0/3] powerpc/pseries: IPI doorbell improvements
Date:   Sun, 26 Jul 2020 13:51:52 +1000
Message-Id: <20200726035155.1424103-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Since v2:
- Fixed ppc32 compile error
- Tested-by from Cedric

Nicholas Piggin (3):
  powerpc: inline doorbell sending functions
  powerpc/pseries: Use doorbells even if XIVE is available
  powerpc/pseries: Add KVM guest doorbell restrictions

 arch/powerpc/include/asm/dbell.h     | 67 ++++++++++++++++++++++++++--
 arch/powerpc/include/asm/firmware.h  |  6 +++
 arch/powerpc/include/asm/kvm_para.h  | 26 ++---------
 arch/powerpc/kernel/Makefile         |  5 +--
 arch/powerpc/kernel/dbell.c          | 55 -----------------------
 arch/powerpc/kernel/firmware.c       | 19 ++++++++
 arch/powerpc/platforms/pseries/smp.c | 62 +++++++++++++++++--------
 7 files changed, 138 insertions(+), 102 deletions(-)

-- 
2.23.0

