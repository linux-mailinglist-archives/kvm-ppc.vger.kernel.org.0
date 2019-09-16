Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80EAEB35A5
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Sep 2019 09:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbfIPHbS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Sep 2019 03:31:18 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43872 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfIPHbS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 16 Sep 2019 03:31:18 -0400
Received: by mail-pl1-f193.google.com with SMTP id 4so16514683pld.10
        for <kvm-ppc@vger.kernel.org>; Mon, 16 Sep 2019 00:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VM+mdbNuqQkbOyyrNUkKueKWgte8gxeC/01EaJCJzG0=;
        b=fS3VH2WDFveSi1YcXAsY6BzXHYiLSeswPnA+Wd2vttz0x27ukVF8Bs93Zr63MGsMje
         szdEQnRmL+LZgaS9t9zxAWVnBuJN4iAy1pjCgEguDm5LLe4wr3IAYCHAymSKgTEDHVSI
         5F0REgXIik8OvznVasC68gv84AcqkhbVleEwW+eddARJCTnOzM4jTsruLDAPCQ+qJB7X
         FbIqI0UdsfmBIcEGQTS/aFUnq1GJ62BIwgaS4dOGkLxbCaSy+hwC5pHbXHfqmax7zuer
         wgmVPEixRGjLjBkJp0V2AV+iF/JCbqhofH9FvjzWVhGvu6pitAPsIuultJOLHaTPFFN7
         FMgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VM+mdbNuqQkbOyyrNUkKueKWgte8gxeC/01EaJCJzG0=;
        b=XMZMQ+JDAU1GLLJUBCqz/KPFtTVRMSHve0tqqYdINc6DOadaMsE82u0jlcaZF6DzrW
         VcKhM52MuyK8FIbq7GpSqoiVhNsizb0iuxrJk1WAT9taO4pvfeDt9AhDMv9+uVAAIgrj
         eURfNkSFOwnVmsR2RmqDk6vDgvStyx3pXi3FXz+El9JUKnOz6QYEwflV+hYwfCQQNRXg
         xeM4BoAkidksDofvXJ/p+Skr/ejhwZMdkOvz3uvhL+n2SK1JKhvcvtApiBTzDDmzsByL
         uaxAUQtmNfVCabtj9Nyedt9CTz94obykj73Wd7gmPasulkgTm7WrWawOarZ0qx+/EFNO
         ZqBw==
X-Gm-Message-State: APjAAAV9SO4esRY8D9745Mpc1Ut8h0sZrhMySewx7F1pnAmLSs0rhvfV
        /FmZwT0LJku3aR3cLBp4iR3EILvK
X-Google-Smtp-Source: APXvYqy+lWWNdMC3IUMoTNXPBSWAIok+UVf4we5BAyMFNu3kgqBfPRafc9qQW6yZJbDDlyJF3hA2qg==
X-Received: by 2002:a17:902:a5c5:: with SMTP id t5mr59679203plq.316.1568619077458;
        Mon, 16 Sep 2019 00:31:17 -0700 (PDT)
Received: from bobo.local0.net ([203.63.189.78])
        by smtp.gmail.com with ESMTPSA id 195sm12484964pfz.103.2019.09.16.00.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 00:31:16 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH v2 0/5] Fix LPCR[AIL]=3 implementation and reject
Date:   Mon, 16 Sep 2019 17:31:03 +1000
Message-Id: <20190916073108.3256-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This is an update of the series with comments addressed. Most of them
were relatively minor details except patch 3, which incorrectly added
end_cede to guest entry interrupt injection, now fixed.

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
 arch/powerpc/kvm/book3s_pr.c         | 38 ++++++++++++-
 12 files changed, 129 insertions(+), 99 deletions(-)

-- 
2.23.0

