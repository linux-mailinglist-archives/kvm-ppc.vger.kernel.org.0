Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9108F35B838
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Apr 2021 03:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235718AbhDLBtN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 11 Apr 2021 21:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbhDLBtN (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 11 Apr 2021 21:49:13 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C12C061574
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:48:55 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id p12so8168193pgj.10
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z50PGWgtT7tea+Zn1Qkyxzl07ppTYoZ5ibYNEEJnaYE=;
        b=SQ1snoYZcheAEWI5pmOIZiO+tFZPUI8Q5wFl9BPPKoPLX1c2s8GWcZ3yxznKUoBWDu
         W5ZX+BXqlW4ULdCULt5i2IDmruu1Y7+Vyt9BkuMjtzc0faB/3ilM6iRjYV5xk6kWl0a2
         /OwSCVCFoLdV0gEyNV4iezX/SdqJXcLOJshaXduzlH5SefiurZp2f7iJS8CM6yS3tr8t
         8U0cG6wWdzOwaLMC2CFXcJzqi0pCsBBCx4B78OVgX7xK11CU5n2F7ORxBmjRXrvM9ql9
         m7U/ie/bnuQSGBAHv5Q9TV8w/2PL++fA/MdICK6UnxU46iPy1dUOz0lpWR/GZ9gtAZWq
         NFPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z50PGWgtT7tea+Zn1Qkyxzl07ppTYoZ5ibYNEEJnaYE=;
        b=gmTCOekTc8tAMsZPOZh+4SY1SMB1wuzsqgV6Pq984WCw4f86KWwkt6Xyuc6w+Z+14Q
         bDSfNl9LyHJ55AQEtpQvV3l2IkHfGtsVTPR5kPN/pHA/8GUV2mKa6LAmDjPXaU2LCom8
         y7SrNl/AXtyKiaeGDPrEXSzzzGgsfqYErYPT9RssczIe4Gde/WhlZTSp8k2tPJubKbA3
         qbjiwVuy8N9Y6wricdLRQHgbnri7ihg/4Pk5Aj5M8xvsEClW5nkxLbXwUb5IRwFcxKuP
         OSd57d2NN9gSt2b8gp66CV6b+vpQhP1LO1Z3895ujxsSrtIHhijpiGrK22zeX1VP0zED
         ANig==
X-Gm-Message-State: AOAM532pGa9sBptktkYnoFPYa5IwE2RYd7vsfAJZ/F9lbI+SRLX/nn9Z
        9Ov1ftC0Y3FE2hRL+BJzDbuGt8cSh7o=
X-Google-Smtp-Source: ABdhPJxmCDWh2nPt64vl3jvFOnXjwUFL/kX0n2gA+V6tya3ZT1YcBssBYuDp3PjR7c04Ie/U2A3Miw==
X-Received: by 2002:a05:6a00:2389:b029:21a:d3b4:e5 with SMTP id f9-20020a056a002389b029021ad3b400e5mr23210783pfc.39.1618192134345;
        Sun, 11 Apr 2021 18:48:54 -0700 (PDT)
Received: from bobo.ibm.com (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id m9sm9502345pgt.65.2021.04.11.18.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:48:54 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 00/12] minor KVM fixes and cleanups
Date:   Mon, 12 Apr 2021 11:48:33 +1000
Message-Id: <20210412014845.1517916-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Here is the first batch of patches are extracted from the patches of the
KVM C conversion series, plus one new fix (host CTRL not restored) since
v6 was posted.

Please consider for merging.

Thanks,
Nick

Nicholas Piggin (12):
  KVM: PPC: Book3S HV P9: Restore host CTRL SPR after guest exit
  KVM: PPC: Book3S HV: Nested move LPCR sanitising to sanitise_hv_regs
  KVM: PPC: Book3S HV: Add a function to filter guest LPCR bits
  KVM: PPC: Book3S HV: Disallow LPCR[AIL] to be set to 1 or 2
  KVM: PPC: Book3S HV: Prevent radix guests setting LPCR[TC]
  KVM: PPC: Book3S HV: Remove redundant mtspr PSPB
  KVM: PPC: Book3S HV: remove unused kvmppc_h_protect argument
  KVM: PPC: Book3S HV: Fix CONFIG_SPAPR_TCE_IOMMU=n default hcalls
  powerpc/64s: Remove KVM handler support from CBE_RAS interrupts
  powerpc/64s: remove KVM SKIP test from instruction breakpoint handler
  KVM: PPC: Book3S HV: Ensure MSR[ME] is always set in guest MSR
  KVM: PPC: Book3S HV: Ensure MSR[HV] is always clear in guest MSR

 arch/powerpc/include/asm/kvm_book3s.h |  2 +
 arch/powerpc/include/asm/kvm_ppc.h    |  3 +-
 arch/powerpc/kernel/exceptions-64s.S  | 15 +++--
 arch/powerpc/kvm/book3s_hv.c          | 85 ++++++++++++++++++++-------
 arch/powerpc/kvm/book3s_hv_builtin.c  |  3 +
 arch/powerpc/kvm/book3s_hv_nested.c   | 37 +++++++++---
 arch/powerpc/kvm/book3s_hv_rm_mmu.c   |  3 +-
 7 files changed, 109 insertions(+), 39 deletions(-)

-- 
2.23.0

