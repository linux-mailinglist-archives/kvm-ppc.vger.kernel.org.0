Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12F26C474F
	for <lists+kvm-ppc@lfdr.de>; Wed,  2 Oct 2019 08:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfJBGAw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 2 Oct 2019 02:00:52 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37937 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfJBGAw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 2 Oct 2019 02:00:52 -0400
Received: by mail-pf1-f196.google.com with SMTP id h195so9748659pfe.5
        for <kvm-ppc@vger.kernel.org>; Tue, 01 Oct 2019 23:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O0FXnKNS9Or1i25EERkAWxVch1nwXy3Vu+Y9wUVugCo=;
        b=D0/yVXeJONTvNi3Tbm/lCFg6i9HM6x2YG+xS3NNBAMR8LRbWqnzyYNuXcQMClwhGAv
         N6fO1js9qvufzUCyumPTJXcvhWPKq3IOymITkjDKFCMCcV4iBvBcpovVxaaVvwYxlLyZ
         V2YKPEE68BB9jq7JR3Iaj1IIXgylw/wK7buB0rC07V9VPxbhVeAO7PAbhkUVq19vEdFF
         Ogedlf9bWr7WdJbjr/XyNzni5hG+GT5McoMrZtVXpvO4k15DXMZ9LNlRqt5CjpqkNTgM
         XBrm0L8mVCRcgU16H7VMbTajkIn8fGiRYSot4GQDje/v8qGMwvG5F1HUB5rgdByjzyGD
         QKLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O0FXnKNS9Or1i25EERkAWxVch1nwXy3Vu+Y9wUVugCo=;
        b=GSmIb4srieaoRaZjwnb8hXh8P8iPneUZel937nbFCseTILYJrsjemy7OoOccY4qpx4
         keRudwbWyIDiTw72iQtb6uApLX81fonNfMXi/A1HHdG3YADxuVpQNkEoaNOSOyH/n8ew
         uLtxw7jgYsq6TI55VK+vzrvQd+H/WJb2dGCuOUB0zqoCwatxpSY/MVX84WKZmtnA22Y5
         BrnvN1szjeAE4f4VNngHsMBKUtnKEec1V/N8bVn1EL+BAvpAgSUbosBWDptJSXIiWaeW
         yKhLxCV62X5KklMgCXrpu+RTLSFaqU464VFedIwnGDwt76ytqWwTVT1IbITnJRbKNzy3
         KL6Q==
X-Gm-Message-State: APjAAAXD7sS10TR94tz2TPxxVzzBakuHCbbAwKWsMnC0ZDmlDfPH7JhM
        P+NwRsQmX7vB0dCc8Zm1fWw4ApJA
X-Google-Smtp-Source: APXvYqw0DG1oOOm1E3onRj02x7rF9HvI5FSfenFkTIKH4XGvXkMzz7/W2mDbj6bOkgfFeiBBK7jnAA==
X-Received: by 2002:a62:780c:: with SMTP id t12mr2554323pfc.211.1569996051227;
        Tue, 01 Oct 2019 23:00:51 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id v12sm18660749pgr.31.2019.10.01.23.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 23:00:50 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v2 0/5] Fix LPCR[AIL]=3 implementation
Date:   Wed,  2 Oct 2019 16:00:20 +1000
Message-Id: <20191002060025.11644-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

- Fixed compile failure on pmac32_defconfig + PR KVM.
- Fixed bug where end_cede was still being incorrectly called.
- Slightly improved a comment about AIL delivery criteria.

Thanks,
Nick

Nicholas Piggin (5):
  KVM: PPC: Book3S: Define and use SRR1_MSR_BITS
  KVM: PPC: Book3S: Replace reset_msr mmu op with inject_interrupt arch
    op
  KVM: PPC: Book3S HV: Reuse kvmppc_inject_interrupt for async guest
    delivery
  KVM: PPC: Book3S HV: Implement LPCR[AIL]=3 mode for injected
    interrupts
  KVM: PPC: Book3S HV: Reject mflags=2 (LPCR[AIL]=2) ADDR_TRANS_MODE
    mode

 arch/powerpc/include/asm/kvm_host.h  |  1 -
 arch/powerpc/include/asm/kvm_ppc.h   |  1 +
 arch/powerpc/include/asm/reg.h       | 12 ++++
 arch/powerpc/kvm/book3s.c            | 27 +--------
 arch/powerpc/kvm/book3s.h            |  3 +
 arch/powerpc/kvm/book3s_32_mmu.c     |  6 --
 arch/powerpc/kvm/book3s_64_mmu.c     | 15 -----
 arch/powerpc/kvm/book3s_64_mmu_hv.c  | 13 -----
 arch/powerpc/kvm/book3s_hv.c         | 28 ++--------
 arch/powerpc/kvm/book3s_hv_builtin.c | 82 +++++++++++++++++++++++-----
 arch/powerpc/kvm/book3s_hv_nested.c  |  2 +-
 arch/powerpc/kvm/book3s_pr.c         | 40 +++++++++++++-
 12 files changed, 131 insertions(+), 99 deletions(-)

-- 
2.23.0

