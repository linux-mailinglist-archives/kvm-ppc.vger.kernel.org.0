Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 130BA4C518
	for <lists+kvm-ppc@lfdr.de>; Thu, 20 Jun 2019 03:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731167AbfFTBrR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 19 Jun 2019 21:47:17 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35778 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfFTBrR (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 19 Jun 2019 21:47:17 -0400
Received: by mail-pg1-f195.google.com with SMTP id s27so675710pgl.2
        for <kvm-ppc@vger.kernel.org>; Wed, 19 Jun 2019 18:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mCIC2aboa3+r+s8FwQIzqoLVu7DilRd8Ln+aL0vqvn0=;
        b=qgNZHp/lhGNyohg7ZT58DH0wNF+D5EwcPHyalSMFyf7j727/HvDLykynP9BGEC4SrY
         EpU0MQeYT+JACzcMGkUhTJy59RpMLJYV/yB7RNZOdsPwZt+4h+zu9FeKxueyzEqT0+vw
         0y3n3wuaIyhCNKoh96673+B3zjlZ0p9X3wnDz/kQqRDEYmXSSgrwuZiNWrf+LLZHQyid
         WDk5CSTtan+AxUk9jibW3Qc3PfO7Ye5VRERY5TCU7vjvC7z1iXEqTOcL3VC/Z6qM5eSk
         xtn+nk4bKeFz3qLmIasf1XG0ffivOI7sFYzhWBmrrXl++VREgpZHFUSSbUrWIlWnA0hB
         LgyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mCIC2aboa3+r+s8FwQIzqoLVu7DilRd8Ln+aL0vqvn0=;
        b=tUmpJUHqCSt9wnRxw2L+HYpcH+FrGsoL7FY/ZYvEQ9Guw9YDahVPktc8qFRzBREL5I
         j/87B2XMEyB7mTm+h2xnWWmFOM8SmMY2NBnqeA+g4JGxbtkhdTgra7Q3/AAnWAJ7D0WN
         DbETx2nnE5QJ0P9rTXbDeURj38wdOgw569VJVP3lpGyqBiz/lppt+ILHXJrMlnumlgzu
         LbRPKcc1RpeNIS1tfgYj47WAAw/HpTlnXXBYpzct4CH4m2zcKS2PD9hKkHY95hcQIKhD
         RSLPvob4TsTMypkapbwJAbKXPirnhAUyvnn4kByYpjxGXFykKdTTHkLKrUqwqklkMcoE
         /rwQ==
X-Gm-Message-State: APjAAAVSJchiRTDmGpJmrGOk8cLGtKXyMzYXe13knV1Rd2q/9VuRSevF
        4e+IQeVdxTHTskViZ8WIyp8=
X-Google-Smtp-Source: APXvYqzxxwvput0hwtg9iKYmnq2VzDGr9V32cZn/53fXeykdeqkBTdooGW36AwvHS58s9fIbCQCIbg==
X-Received: by 2002:a17:90b:8d2:: with SMTP id ds18mr290574pjb.132.1560995237014;
        Wed, 19 Jun 2019 18:47:17 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id 23sm20763528pfn.176.2019.06.19.18.47.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Jun 2019 18:47:16 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mpe@ellerman.id.au, paulus@ozlabs.org,
        clg@kaod.org, sjitindarsingh@gmail.com
Subject: [PATCH 2/3] KVM: PPC: Book3S HV: Signed extend decrementer value if not using large decr
Date:   Thu, 20 Jun 2019 11:46:50 +1000
Message-Id: <20190620014651.7645-2-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190620014651.7645-1-sjitindarsingh@gmail.com>
References: <20190620014651.7645-1-sjitindarsingh@gmail.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On POWER9 the decrementer can operate in large decrementer mode where
the decrementer is 56 bits and signed extended to 64 bits. When not
operating in this mode the decrementer behaves as a 32 bit decrementer
which is NOT signed extended (as on POWER8).

Currently when reading a guest decrementer value we don't take into
account whether the large decrementer is enabled or not, and this means
the value will be incorrect when the guest is not using the large
decrementer. Fix this by sign extending the value read when the guest
isn't using the large decrementer.

Fixes: 95a6432ce903 "KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests"

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index d3684509da35..719fd2529eec 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3607,6 +3607,8 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	vcpu->arch.slb_max = 0;
 	dec = mfspr(SPRN_DEC);
+	if (!(lpcr & LPCR_LD)) /* Sign extend if not using large decrementer */
+		dec = (s32) dec;
 	tb = mftb();
 	vcpu->arch.dec_expires = dec + tb;
 	vcpu->cpu = -1;
-- 
2.13.6

