Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47EBC3C9F36
	for <lists+kvm-ppc@lfdr.de>; Thu, 15 Jul 2021 15:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbhGONST (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 15 Jul 2021 09:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbhGONST (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 15 Jul 2021 09:18:19 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECE1C06175F
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Jul 2021 06:15:25 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id s18so6229718pgg.8
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Jul 2021 06:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bRUBKr+pcQvTSq7JQJ+usk7fg5wenAu/IEJC6e2X31Y=;
        b=tRvbZW90L/vB4s+bsXld1ARwLyxpo+jD4hsD1j2g7P5xN3PdNy5QS07jKnyULuAK//
         0D4Pn/r/Ljd6Ej2TCm5lhSQFpurpXIoNRJYVVXRw7iP6uoVPMMcypYix4GON1NMDTpVp
         WWj4HmnjX06s/CM45nc+uL8Y7OvgBiwsgSDkW/jyF0ZeuJu6WpT1BtiSEauh6Tm6LKHM
         F5gHE8aCEYFeQeHTApvXbq1Nke267SVp6K2q8cUmvP68bCSMygzGyV3dohgWp6DidEWw
         2lklO2RhLdv7/KSysj0QqxvWguxIRegnnpffrRVk/fCRGNik88sisDg2VUbfUwxt3YpT
         ZrzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bRUBKr+pcQvTSq7JQJ+usk7fg5wenAu/IEJC6e2X31Y=;
        b=kld3CzJ/ixP1dEcl58ay42CAe/NXvDeRLA2aYmvXgr0THOoUy2DECKkZ6Jcmm9V39h
         BS42MgrPrilfD/wzMq5fV8oan6MaoQ6EhCnNfgPaSk30TDKaoKE0NT5GNfJqJTANhOF8
         nlcqVx28xEFH4TaSw/+yNgU6e08Ek00zETTMn1uXZUTc6Dm/vDpHNidpqszk5ih3QHl+
         mPtUCOf/ooqYmbK+V+Cr5snN3QbE/k8sVYcd/oA9h5LGnaM97rpolUX9ogsxIehbW1kR
         vLXqWGNukHlg4NRF3u86Fa5ajeMsclU2K23vdS/J/yAlyPNlPdd1RjLtTFLDXriDvgDA
         RGVQ==
X-Gm-Message-State: AOAM532yh4+wY+x/kKEGmwZgGdBjxIrZ1lrpjIp5YgFmuLGmjW43UklS
        HyFR7mxoRy5qejK6S+qTW9uuFUno5Q1Ezg==
X-Google-Smtp-Source: ABdhPJzZUSN9nK3A2xJ0js4cQ6ax2FRFwvS8cedldMlHU8p4M0ZPNKMxzRKyRznGgpSOpH6Cd/aZyA==
X-Received: by 2002:a62:442:0:b029:31d:2e52:f1c4 with SMTP id 63-20020a6204420000b029031d2e52f1c4mr4732354pfe.14.1626354925098;
        Thu, 15 Jul 2021 06:15:25 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (27-33-83-114.tpgi.com.au. [27.33.83.114])
        by smtp.gmail.com with ESMTPSA id k6sm4864216pju.8.2021.07.15.06.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 06:15:24 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 0/6] KVM: PPC: Book3S HV P9: Reduce guest entry/exit
Date:   Thu, 15 Jul 2021 23:15:12 +1000
Message-Id: <20210715131518.146917-1-npiggin@gmail.com>
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

