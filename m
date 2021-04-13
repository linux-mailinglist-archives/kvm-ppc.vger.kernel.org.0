Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D9535E058
	for <lists+kvm-ppc@lfdr.de>; Tue, 13 Apr 2021 15:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbhDMNmy (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 13 Apr 2021 09:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242387AbhDMNmw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 13 Apr 2021 09:42:52 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA747C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 13 Apr 2021 06:42:32 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so10697481pjb.4
        for <kvm-ppc@vger.kernel.org>; Tue, 13 Apr 2021 06:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a7MSTQsSZSicQObTfMfxpXsyE7yOosfcVZRQwmQUgIs=;
        b=oMUUSP7MZ/V4s0ShLsOp/gj2vQ+9ZQPfdogQBa9yGRKwbxdMJ80JTRhVF3wIRV9/qc
         uBdvjDLGrfCk/qpt0NiSritJ8Bs6aAt8PkhdPNYLyRAlBxbCGQLB+yI7qOZA3dLKth68
         xlzwjyZaoAaHNaS2l2jzJRP9tXQNTYtHoPEw8XMLxdFplhXheCc3dqpF4VA58fS3F7ow
         VhC5jRsPG4+MvMuWmxlYfPTuv/dFJsQnpnk9aXmTsoqqsSqFPUkY3KSjXmw11NBN7pdd
         Mv1WFphsbS9AzYj8oTv/4Y7/UdQ3fcptxlE8i/dZ30l4zPSQE96La1dG9TaAnFGcfYJm
         39hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a7MSTQsSZSicQObTfMfxpXsyE7yOosfcVZRQwmQUgIs=;
        b=fPJLo2jhlXMxTwYkwl+T2muuLqnvv4xJxXnha9+JUgwPJ1KnXKZVrOXHq/GGy6s7yC
         qRR+JpNK7SgKeEzo5n6VgJ/n0/MeiDD6IZN2sN0dO/HCQ8DOWTarsu0BX05OUsBzi8xa
         RSQulhOTJML3ceP2MQmFHT3h46E3RcrAo2WlgllBfg+ejeokyaM3qc5B7vIX1UmXyF61
         8AdMc9pnse89iwRSr6eH+QMvieYk6wiJAfYp0mIc+HDTaCTZ53j4ZNVZ2pNd7P9j29Ma
         kVOpfQBsraAmHLaLMHUMTepROPJHPvMqzvcTC1ELwjJVymkpaPLfwFl7Z6TwxITWk8Sh
         0+rg==
X-Gm-Message-State: AOAM531Sy2h9BVyKkxqx/PRyYySpd51Lwhh0quVvMx4i/6YHCtDQyLks
        n1nRo2HgGwe3zx8Y2MX17hgn/9WsBFg=
X-Google-Smtp-Source: ABdhPJyPCtlLPGatTTz1M/YhH2KN+c6H0kIdYGVwtChIG0vvaZUrVhMyLKcjx1nAS5xxd0Yt7YipMQ==
X-Received: by 2002:a17:902:ac98:b029:ea:b3c2:53da with SMTP id h24-20020a170902ac98b02900eab3c253damr19358722plr.23.1618321352371;
        Tue, 13 Apr 2021 06:42:32 -0700 (PDT)
Received: from bobo.ibm.com (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id l22sm100465pjc.13.2021.04.13.06.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 06:42:32 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 0/2] KVM: PPC: timer improvements
Date:   Tue, 13 Apr 2021 23:42:21 +1000
Message-Id: <20210413134223.1691892-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

These are small timer improvement and buglet fix, taken from the
KVM Cify series.

This is the last one for the upcoming merge window.

Thanks,
Nick

Nicholas Piggin (2):
  KVM: PPC: Book3S HV P9: Move setting HDEC after switching to guest
    LPCR
  KVM: PPC: Book3S HV P9: Reduce irq_work vs guest decrementer races

 arch/powerpc/include/asm/time.h | 12 ++++++++++++
 arch/powerpc/kernel/time.c      | 10 ----------
 arch/powerpc/kvm/book3s_hv.c    | 34 +++++++++++++++++++++------------
 3 files changed, 34 insertions(+), 22 deletions(-)

-- 
2.23.0

