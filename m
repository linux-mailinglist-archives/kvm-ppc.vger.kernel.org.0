Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF552F99E4
	for <lists+kvm-ppc@lfdr.de>; Mon, 18 Jan 2021 07:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731060AbhARG27 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 18 Jan 2021 01:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730146AbhARG25 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 18 Jan 2021 01:28:57 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA29C061573
        for <kvm-ppc@vger.kernel.org>; Sun, 17 Jan 2021 22:28:16 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id l23so9100675pjg.1
        for <kvm-ppc@vger.kernel.org>; Sun, 17 Jan 2021 22:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HRAgrTksAYQNvbWip9py1mZp/2xK3ua+1beJBsrSWMM=;
        b=fh1OGZ6VmilFB3O12ZNGshOCyehK0ITYFspIAXC1hXp/hoAIhIl5H27AInOt70YjqP
         KBqiiUyHzpeKFT2Y8uU7WPLCaOFpXReYXsnx0OnBA0to8xezy5fgek1FAieTXkdDfBcZ
         Hpt8ESzHtTVyZsZIsXOURGGweKg5L4QG4JVivmfKPNJzvTHv4DhKKp6aEGIb0WSfe6RN
         19o4W2xLUo/mulrPsOZTEtuxR2vwGtYjh7SPu03sixVYtJ3S2XcMcPhqXqlyKF7nin51
         AnjAuy+OXrkzUdMLXXb6RZQc2As8NFNNYw/0ZETLOjzxG8qXWI0WHfWxa0elDbtn0dUQ
         h8AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HRAgrTksAYQNvbWip9py1mZp/2xK3ua+1beJBsrSWMM=;
        b=k+dM4XbKZFsOCnxd+UJBwPt8is9pqKkCUW+ih9cyLhqIqEHilcgp6MS2fCFtbucn+q
         vgsq/G6y/zoTCo9UUNzowjrRmBZfIgIZs2BlqLN5ZWohBERJ0dRmNmNPbWl7b+urpkWe
         1aXE4ztzTV9qVTUzUv3zC3XeDtZknmF6PgApSKugtAi99h6q/hjvrjSSDKHOB9btaPHf
         FRe0phKpIzOVVKWN639fUbDT/ltY2f89RfV/WbgksAKAwD5L4nhNCmGStYzV9GXYQbBf
         hxY5s5QMn/LCUAyJrQmQMBioN4a+nrriOmTFrH9NOfSmXSOMg9YKyZHgKExZS+cjpjlZ
         4eMA==
X-Gm-Message-State: AOAM531PlNxU6uIwSTFEPVgrFwY5JG7Xx/2IakJBzBi/ROtLc4h8c61D
        OPIqKLQtl6dewZ7NSh/0e5lSkMC3FCc=
X-Google-Smtp-Source: ABdhPJzxZHvytwO8Dl/Gzy5h94PZV0SxmXUn6Gnqaz7IBSnjEoCKtf25iuBJfak7AWpSDtCp3sAEOg==
X-Received: by 2002:a17:90b:4d09:: with SMTP id mw9mr25191330pjb.199.1610951296056;
        Sun, 17 Jan 2021 22:28:16 -0800 (PST)
Received: from bobo.ibm.com ([124.170.13.62])
        by smtp.gmail.com with ESMTPSA id w25sm8502318pfg.103.2021.01.17.22.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 22:28:15 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 0/4] a few KVM patches
Date:   Mon, 18 Jan 2021 16:28:05 +1000
Message-Id: <20210118062809.1430920-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

These patches are unrelated except touching some of the same code.
The first two fix actual guest exploitable issues, the other two try
to tidy up SLB management slightly.

Thanks,
Nick

Nicholas Piggin (4):
  KVM: PPC: Book3S HV: Remove support for running HPT guest on RPT host
    without mixed mode support
  KVM: PPC: Book3S HV: Fix radix guest SLB side channel
  KVM: PPC: Book3S HV: No need to clear radix host SLB before loading
    guest
  KVM: PPC: Book3S HV: Use POWER9 SLBIA IH=6 variant to clear SLB

 arch/powerpc/include/asm/kvm_book3s_asm.h |  11 --
 arch/powerpc/kernel/asm-offsets.c         |   3 -
 arch/powerpc/kvm/book3s_hv.c              |  56 ++--------
 arch/powerpc/kvm/book3s_hv_builtin.c      | 108 +-----------------
 arch/powerpc/kvm/book3s_hv_rmhandlers.S   | 129 ++++++++++------------
 5 files changed, 70 insertions(+), 237 deletions(-)

-- 
2.23.0

