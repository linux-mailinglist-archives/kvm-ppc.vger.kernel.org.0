Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9434E3B3D7F
	for <lists+kvm-ppc@lfdr.de>; Fri, 25 Jun 2021 09:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhFYHjj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 25 Jun 2021 03:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhFYHjj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 25 Jun 2021 03:39:39 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F78EC061574
        for <kvm-ppc@vger.kernel.org>; Fri, 25 Jun 2021 00:37:18 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id v12so4282768plo.10
        for <kvm-ppc@vger.kernel.org>; Fri, 25 Jun 2021 00:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=arS0mKVzVlqtqVfiVwhtHqUqhLwMsArq/fcDdatjRgU=;
        b=dHO26QDY5LUMI+Tc2XZzsgpXZDpORNAX7YyZkCQ5xy7oSytr1O3oUF01CG9gH6yL5q
         Y3La01kqEVPP9WWTMrMPMSLK8aydIT/ocZATNuL06J51ec4Okfq4Nv5ekqNB14ZWBhjL
         tL88LfPKWlydh9eprQr48AASmItpc0PiVGEJE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=arS0mKVzVlqtqVfiVwhtHqUqhLwMsArq/fcDdatjRgU=;
        b=pnQwTDu/Sxjgh7ZgNzhwaXAtKgHkpb+1tbw33MNBIKDbyAb+c/ZY7AQVoEm73yLT/D
         tO1ILAyOWFMJ2a6eh9uluzs4l33rBoFrjbdSY6NN1Fq3T4+qvIlulCgkBrLdNKFpFJ+n
         n9qaAL5Hau8FixUlY2PzXdtHIuRqxj/ugalTu2/aTZLr+5sNmAf8V98FDcgapIAMhrRE
         TvXdZqQ2XB4bzuaoTpdD6R1Oec2exHNEz9cprjoX9GUXJyDFoCUJbP/HAb5lk668IgB6
         9n3mciIK1A5JrxbhjB8+ypv5PVhOvcUcAzxtCZIIzUQqmZr4VYTnIT0xEW9gbt9dnLGZ
         znVQ==
X-Gm-Message-State: AOAM530ojUSAm90u2z+cC2y87OEucS/nB86XNRhd+obd65H6d4gKZdUJ
        lNPBTA0nW+xWDZ9OL1yJF1g6KQ==
X-Google-Smtp-Source: ABdhPJzJyYhoE1B9Fk5Wy7zlre5sRlAATH1Tds+i1SalCyUSMMBey0lep4anSoEg3on5gb5KkCMm2Q==
X-Received: by 2002:a17:902:c947:b029:125:34d4:249d with SMTP id i7-20020a170902c947b029012534d4249dmr7925026pla.3.1624606637340;
        Fri, 25 Jun 2021 00:37:17 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:1492:9d4f:19fa:df61])
        by smtp.gmail.com with UTF8SMTPSA id a9sm9986991pjm.51.2021.06.25.00.37.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 00:37:16 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nick Piggin <npiggin@gmail.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        David Stevens <stevensd@google.com>
Subject: [PATCH v2 0/5] Remove uses of struct page from x86 and arm64 MMU
Date:   Fri, 25 Jun 2021 16:36:11 +0900
Message-Id: <20210625073616.2184426-1-stevensd@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

KVM supports mapping VM_IO and VM_PFNMAP memory into the guest by using
follow_pte in gfn_to_pfn. However, the resolved pfns may not have
assoicated struct pages, so they should not be passed to pfn_to_page.
This series removes such calls from the x86 and arm64 secondary MMU. To
do this, this series introduces gfn_to_pfn_page functions that parallel
the gfn_to_pfn functions. These functions take an extra out parameter
which  contains the page if the hva was resovled by gup. This allows the
caller to call put_page only when necessated by gup.

The gfn_to_pfn functions are depreciated. For now the functions remain
with identical behavior to before, but callers should be migrated to the
new gfn_to_pfn_page functions. I added new functions instead of simply
adding another parameter to the existing functions to make it easier to
track down users of the deprecated functions.

I have migrated the x86 and arm64 secondary MMUs to the new
gfn_to_pfn_page functions.

This addresses CVE-2021-22543 on x86 and arm64.

v1 -> v2:
 - Introduce new gfn_to_pfn_page functions instead of modifying the
   behavior of existing gfn_to_pfn functions, to make the change less
   invasive.
 - Drop changes to mmu_audit.c
 - Include Nicholas Piggin's patch to avoid corrupting refcount in the
   follow_pte case, and use it in depreciated gfn_to_pfn functions.
 - Rebase on kvm/next

David Stevens (4):
  KVM: mmu: introduce new gfn_to_pfn_page functions
  KVM: x86/mmu: use gfn_to_pfn_page
  KVM: arm64/mmu: use gfn_to_pfn_page
  KVM: mmu: remove over-aggressive warnings

Nicholas Piggin (1):
  KVM: do not allow mapping valid but non-refcounted pages

 arch/arm64/kvm/mmu.c            |  26 +++--
 arch/x86/kvm/mmu/mmu.c          |  50 ++++-----
 arch/x86/kvm/mmu/mmu_internal.h |   3 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |  23 +++--
 arch/x86/kvm/mmu/tdp_mmu.c      |   6 +-
 arch/x86/kvm/mmu/tdp_mmu.h      |   4 +-
 arch/x86/kvm/x86.c              |   6 +-
 include/linux/kvm_host.h        |  17 +++
 virt/kvm/kvm_main.c             | 177 +++++++++++++++++++++++++-------
 9 files changed, 222 insertions(+), 90 deletions(-)

-- 
2.32.0.93.g670b81a890-goog

