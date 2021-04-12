Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF9F35BB3C
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Apr 2021 09:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbhDLHv1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 12 Apr 2021 03:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236936AbhDLHv1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 12 Apr 2021 03:51:27 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D012FC061574
        for <kvm-ppc@vger.kernel.org>; Mon, 12 Apr 2021 00:51:09 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id a12so8660755pfc.7
        for <kvm-ppc@vger.kernel.org>; Mon, 12 Apr 2021 00:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ghAZbXCnYZv5OC+rtIwdziC8cQB3Sr8op6xK0fZMBD0=;
        b=J15qDNvNiePUPTiNhNaWD5Wbd6HvlV7qiMPXaiov0HPCr2EL5luqhLhX3bb2rXX/EI
         eBhYpWPxcBkZI3KrLq0QqdU1ZbsdYXEY/o7SSNGRhrk1QjXFSwtiknkcYArMQpqQH/8g
         ncAkBu4sZDb/864NS3XwubuhuA5qIPF/NFKLHhJ2AtcvTzqltgMTeyvnsccxFt1ReiQG
         A2ib/0frOKUf4zhKHLTW4Phy+8VDMwec68iENR54vvoWszW3sB50xWOk3wqZKiNBe8Ck
         YLmzvBkFGhlpV1mzhukkjMaFFdyBzwCKYCzGLlz/0IIQlIS61pC1YL9e2q/quCw64yF/
         7neA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ghAZbXCnYZv5OC+rtIwdziC8cQB3Sr8op6xK0fZMBD0=;
        b=NCk0ohwAqHfgFZNZ2JhrqVOURudM7gmUgLQUJVNxzWF1sGmynqwWL0z8JJnvUqylSu
         7egJHVLnJYBubxJhIGL0u0stiB0YqgD2y1/NgFmp1CILJN/JXBbYc9zDD4OhXkGk51P+
         mn5tdxtg9CbyYZ2/Kq3uJUvCVEfzqK4pXlLRe+ZGd1aBgP6C/fJZN+WQnVNmSKg5Zc4f
         dmRFCayfQwPbpGNU/rLmTYYz/tyx7fkh2MJ3hJrpjQPwEwiauKXZ0mt15gAv1xYNWFm3
         nwKmGL4RaP0We/ofzMiPtlpkr2EOwfPwXyV9L1/+fhc9PXSv7GrnXw0n7JU2JF4J6LTG
         Ta9Q==
X-Gm-Message-State: AOAM531eBZTD3mHRqutluPLUKtRmuqnfERYrsOT2nZ6J80aqi06tkunL
        oRfW2SiUjHY5egLUm37ZNUAKtdawBsY=
X-Google-Smtp-Source: ABdhPJzxcnnIBC9LkW1u96hVOEfdPeulPsnwRQTsPa+PuYMmzfVDOmE0o0ryvRjgLrW2Px94cPAiQg==
X-Received: by 2002:a63:3e4b:: with SMTP id l72mr25143629pga.203.1618213869155;
        Mon, 12 Apr 2021 00:51:09 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id i18sm606180pfq.168.2021.04.12.00.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 00:51:08 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 0/7] KVM / 64s interrupt handling changes
Date:   Mon, 12 Apr 2021 17:50:56 +1000
Message-Id: <20210412075103.1533302-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This is the second batch of patches split from the big KVM in C
series.

This implements all the changes to exception-64s.S required for the
subsequent C conversion. I think they stand on their own as good
patches.

The main things done here are to make the code more amenable to
adding different KVM interrupt handlers (rather than just PR and
HV), and moving a lot of KVM specific code out of exceptions-64s.S
and moving it to arch/powerpc/kvm/book3s_64_entry.S. Calling
convention between those files is changed to mostly match the
exception-64s.S "GEN_INT_ENTRY" convention, so that's a change but
now you only have to remember that one for both cases (either
branching to KVM handler or continuing to GEN_COMMON handler).

This is tested with HV KVM, nested HV under radix L0+L1, and nested
PR KVM under HPT guest. All seems to be working okay.

Thanks,
Nick

Nicholas Piggin (7):
  KVM: PPC: Book3S 64: move KVM interrupt entry to a common entry point
  KVM: PPC: Book3S 64: Move GUEST_MODE_SKIP test into KVM
  KVM: PPC: Book3S 64: add hcall interrupt handler
  KVM: PPC: Book3S 64: Move hcall early register setup to KVM
  KVM: PPC: Book3S 64: Move interrupt early register setup to KVM
  KVM: PPC: Book3S 64: move bad_host_intr check to HV handler
  KVM: PPC: Book3S 64: Minimise hcall handler calling convention
    differences

 arch/powerpc/include/asm/exception-64s.h |  13 ++
 arch/powerpc/kernel/exceptions-64s.S     | 250 ++++-------------------
 arch/powerpc/kvm/Makefile                |   3 +
 arch/powerpc/kvm/book3s_64_entry.S       | 158 ++++++++++++++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S  |  13 +-
 arch/powerpc/kvm/book3s_segment.S        |   3 +
 6 files changed, 220 insertions(+), 220 deletions(-)
 create mode 100644 arch/powerpc/kvm/book3s_64_entry.S

-- 
2.23.0

