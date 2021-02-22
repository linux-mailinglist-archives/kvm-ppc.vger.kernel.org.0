Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608C6320F85
	for <lists+kvm-ppc@lfdr.de>; Mon, 22 Feb 2021 03:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbhBVCqW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 21 Feb 2021 21:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbhBVCqV (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 21 Feb 2021 21:46:21 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01E8C06178A
        for <kvm-ppc@vger.kernel.org>; Sun, 21 Feb 2021 18:45:40 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id z6so5748605pfq.0
        for <kvm-ppc@vger.kernel.org>; Sun, 21 Feb 2021 18:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XvYAYuW5s5qinuMeBbssbbRBBrYSpWkKVGWmhyi6aks=;
        b=SQN3YewJJCVgPoZW33ilUolg2UKuFOff9YMoNynS6YazfZf97j6rEtP8B4hdFiJUPN
         x/+/LdV2d+MwWs94nVraKcNpabBohd6yIfVxdjN8tCWQAmrhxeIDMdGhw9RCBtskVaLN
         c+y9iCUVvhRpZuYVo8HdTUkA1R+B6hSVeK8BI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XvYAYuW5s5qinuMeBbssbbRBBrYSpWkKVGWmhyi6aks=;
        b=bijnDoGi0sEy/nJ1za1UwtXWQBxmuR3nQmjhr06dPqh6mx5BfbOsbm0a0EEUZVTGYp
         /gLuQDRpHP64aTmk2VD4/5plRSL9YPucjfaF3Ex4+8Gob4jHRxwvMjXek+l/J9qHwM73
         ZV3BKGXpuJISMPAkeqG4S03r0Q3V9P0kBn0ph4+C82LHd6RgJIKHNzIff0kE5zMriF5Y
         SLhEywFuvf4q5uzgJj5D3d64pt27hy3QxyPyz8vUP7gBJ5HFzrCAqOjklICJzNkvGP96
         7I9gvnksd70Qvew2VDd5GIcR2xb5Eu3rljfFEzBvnbc+zcEacT7tIP+R2+OFC/RefNph
         o2LQ==
X-Gm-Message-State: AOAM530nrxxs292nYFBsgqSYjKPZvOe2MJLT6oWVlpiDCpn8P2UAJIEi
        bX/ffTtGcOctfvQuDc2wdWmJHQ==
X-Google-Smtp-Source: ABdhPJxZBJ5R6P+6KWCdQ/BarGMyXsUR+MHf6ansvmPqZOtFJPNjlFfXgwH4tftoJWaWtQXpcQFE4w==
X-Received: by 2002:aa7:961b:0:b029:1db:532c:9030 with SMTP id q27-20020aa7961b0000b02901db532c9030mr20358294pfg.30.1613961939826;
        Sun, 21 Feb 2021 18:45:39 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:11b3:5e1a:7cb:7e1f])
        by smtp.gmail.com with UTF8SMTPSA id 77sm15847696pgd.65.2021.02.21.18.45.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 18:45:39 -0800 (PST)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        kvm-ppc@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Stevens <stevensd@google.com>
Subject: [PATCH v4 0/2] KVM: x86/mmu: Skip mmu_notifier changes when possible
Date:   Mon, 22 Feb 2021 11:45:20 +0900
Message-Id: <20210222024522.1751719-1-stevensd@google.com>
X-Mailer: git-send-email 2.30.0.617.g56c4b15f3c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

These patches reduce how often mmu_notifier updates block guest page
faults. The primary benefit of this is the reduction in the likelihood
of extreme latency when handling a page fault due to another thread
having been preempted while modifying host virtual addresses.

v3 -> v4:
 - Fix bug by skipping prefetch during invalidation

v2 -> v3:
 - Added patch to skip check for MMIO page faults
 - Style changes

David Stevens (1):
  KVM: x86/mmu: Consider the hva in mmu_notifier retry

Sean Christopherson (1):
  KVM: x86/mmu: Skip mmu_notifier check when handling MMIO page fault

 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
 arch/x86/kvm/mmu/mmu.c                 | 23 ++++++++++++++------
 arch/x86/kvm/mmu/paging_tmpl.h         |  7 ++++---
 include/linux/kvm_host.h               | 25 +++++++++++++++++++++-
 virt/kvm/kvm_main.c                    | 29 ++++++++++++++++++++++----
 6 files changed, 72 insertions(+), 16 deletions(-)

-- 
2.30.0.617.g56c4b15f3c-goog

