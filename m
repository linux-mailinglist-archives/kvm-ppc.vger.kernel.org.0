Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C963D306D63
	for <lists+kvm-ppc@lfdr.de>; Thu, 28 Jan 2021 07:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhA1GGO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 28 Jan 2021 01:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbhA1GGI (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 28 Jan 2021 01:06:08 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2AAC06174A
        for <kvm-ppc@vger.kernel.org>; Wed, 27 Jan 2021 22:05:28 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 11so3322267pfu.4
        for <kvm-ppc@vger.kernel.org>; Wed, 27 Jan 2021 22:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Il8qZNLJiUnVs1yENR7U+/PHj95Y8fthqxWVAqkzlPM=;
        b=FOBAuUwtS7jVTeXxIChL9bNsz+Er77qc8WeJTUw3A9nq5VmzNwUAKBriJKft/2FquC
         lZ1AHyh5KOkJj9MCdwK+uRaOkDxeiWtZsQ5uhyci9WKjrgU878iPVblmqSfMotl3qqsZ
         AadDpgG2cJ01V8kMSBtXZ7XoVEWtzV5RpOGlc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Il8qZNLJiUnVs1yENR7U+/PHj95Y8fthqxWVAqkzlPM=;
        b=lWlI06bVmF8CgsEC4DaXfXqmDUPdbjFsPji2TYquFA2IfPjADCLzDoIgUim32jXQuL
         JIsQT0ftruB3uSmMhVFmsJXAHWw9TfW/XyRul6le0ft6dnoUTID6ZlVOMT+t9ED4jQxR
         fkGHPTm/Gbyzjpq3S8jPzouYDdZznNGWXdnnGdz6vfI38fSIFRUaLPLKfM4rBo/ehhh0
         49PoaCVzUBrS+A1Lsj+res+xAoG1JtFSqzNLckRc7FimcKhfxAGQwiYRX3pFegznh4Mo
         gu6SNJZzgMaF75gKiRj1afT7LIMHw5zaUwfJ53UU0FRak+chYZXHM2Lv085BLbLwn7dj
         khNw==
X-Gm-Message-State: AOAM530GWGKMePzYYmeORH9P/j74Ng+QXFvM0GHNyPcR7OJoNt1rDTPr
        95Wz0X2BcekwrBYYmEyOb9FF6Q==
X-Google-Smtp-Source: ABdhPJxidwWhR7mlBTuFlylUNvopLRyxeu+Iq8ZjCqlH84G6RemXi1bI0gdxZW+QAPoQaFarpqDzPg==
X-Received: by 2002:a62:1690:0:b029:1c6:fdac:3438 with SMTP id 138-20020a6216900000b02901c6fdac3438mr6879262pfw.43.1611813927818;
        Wed, 27 Jan 2021 22:05:27 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:919f:d6:7815:52bc])
        by smtp.gmail.com with ESMTPSA id z6sm4345903pfr.133.2021.01.27.22.05.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 22:05:27 -0800 (PST)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
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
Subject: [PATCH v3 0/2] KVM: x86/mmu: Skip mmu_notifier changes when possible
Date:   Thu, 28 Jan 2021 15:05:13 +0900
Message-Id: <20210128060515.1732758-1-stevensd@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

These patches reduce how often mmu_notifier updates block guest page
faults. The primary benefit of this is the reduction in the likelihood
of extreme latency when handling a page fault due to another thread
having been preempted while modifying host virtual addresses.

v2 -> v3:
 - Added patch to skip check for MMIO page faults
 - Style changes

David Stevens (1):
  KVM: x86/mmu: Consider the hva in mmu_notifier retry

Sean Christopherson (1):
  KVM: x86/mmu: Skip mmu_notifier check when handling MMIO page fault

 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
 arch/x86/kvm/mmu/mmu.c                 | 16 ++++++++------
 arch/x86/kvm/mmu/paging_tmpl.h         |  7 ++++---
 include/linux/kvm_host.h               | 25 +++++++++++++++++++++-
 virt/kvm/kvm_main.c                    | 29 ++++++++++++++++++++++----
 6 files changed, 65 insertions(+), 16 deletions(-)

-- 
2.30.0.280.ga3ce27912f-goog

