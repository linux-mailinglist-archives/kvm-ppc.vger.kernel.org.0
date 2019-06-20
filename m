Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFD7B4C517
	for <lists+kvm-ppc@lfdr.de>; Thu, 20 Jun 2019 03:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731156AbfFTBrP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 19 Jun 2019 21:47:15 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33899 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfFTBrO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 19 Jun 2019 21:47:14 -0400
Received: by mail-pf1-f195.google.com with SMTP id c85so691386pfc.1
        for <kvm-ppc@vger.kernel.org>; Wed, 19 Jun 2019 18:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=l3iU69UdUouImGD/C1rzkHrdhSDtisQup2hMO2eAkIQ=;
        b=X04L84mGDtOAPUYF9lvUCCJDr5J/yI5sqdvwmTUZiaJBHii63YGira00ZHhI/klAIP
         wYrj1EsaS0Pt+ceZMTSCddNIN946VfJl7c1Dobgnhj8y48oF+DgIZddEoDs3sCo46Fdd
         ZCFv5s1OeSU2OOriXBJGRqKX/kEiXRZv0Apf8Q6TOHPSd3sopqZ2ZR1o/jBxJmZ0ruRZ
         DvCAlvIz6CKsVoQ5V0uQtkTVCCjHLad59EaIHROKZ2E3Mj5kCH2of28q09Pr9ecziTtg
         FS2Ja7+OApeRBWpbAQYgXj6xLnvngVFA74AKrUv6oQQbIygtsWZJ8pTy2kefCAM/3QQQ
         OenA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=l3iU69UdUouImGD/C1rzkHrdhSDtisQup2hMO2eAkIQ=;
        b=PMUBTSyUTH4eUM9E3bCkOdmlPqw0XRdZtdtbsapnPk6dCwUGYnTccALruQAUFwaD58
         cft+MT/3aFtUZ49+ZekAnIiTfNzP9l51mOYPBqENI55DFu01tJA5t2hjz3zWC0+IH20T
         Q0+NObk82NhStiWVvnuUswRW10cF9IGlkJdzFa1zzrX6wFFfpfurmmlOU7YSSi/gkuM1
         72HObpL7TdRSLKBvfg6Q7hAmz3xseg56+WcMzqWih1EycjD3XBAs3BV0HBhzwM8WaSNT
         uC997fGvp3g+NNv2vto+uz/OZN34+W2aG92VcpKhfR2e8lMg6wFtA7b1VGVAlvPGfVl8
         sO3Q==
X-Gm-Message-State: APjAAAUp5hy2nTjz3hf8lLT25jwYp4o96VvuhAaFREonQYyOQMZ/BV6/
        i0nDk4mtTiTbEpl2eZGvxZw=
X-Google-Smtp-Source: APXvYqxMJLWywIo3gBdN535Tn+IYUHBPX4rEbPXeczQStY5K2tm8qniTlv5Y4gN+h8bTWG691puyqQ==
X-Received: by 2002:a17:90a:3210:: with SMTP id k16mr268761pjb.13.1560995234135;
        Wed, 19 Jun 2019 18:47:14 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id 23sm20763528pfn.176.2019.06.19.18.47.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Jun 2019 18:47:13 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mpe@ellerman.id.au, paulus@ozlabs.org,
        clg@kaod.org, sjitindarsingh@gmail.com
Subject: [PATCH 1/3] KVM: PPC: Book3S HV: Invalidate ERAT when flushing guest TLB entries
Date:   Thu, 20 Jun 2019 11:46:49 +1000
Message-Id: <20190620014651.7645-1-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

When a guest vcpu moves from one physical thread to another it is
necessary for the host to perform a tlb flush on the previous core if
another vcpu from the same guest is going to run there. This is because the
guest may use the local form of the tlb invalidation instruction meaning
stale tlb entries would persist where it previously ran. This is handled
on guest entry in kvmppc_check_need_tlb_flush() which calls
flush_guest_tlb() to perform the tlb flush.

Previously the generic radix__local_flush_tlb_lpid_guest() function was
used, however the functionality was reimplemented in flush_guest_tlb()
to avoid the trace_tlbie() call as the flushing may be done in real
mode. The reimplementation in flush_guest_tlb() was missing an erat
invalidation after flushing the tlb.

This lead to observable memory corruption in the guest due to the
caching of stale translations. Fix this by adding the erat invalidation.

Fixes: 70ea13f6e609 "KVM: PPC: Book3S HV: Flush TLB on secondary radix threads"

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_builtin.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 6035d24f1d1d..a46286f73eec 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -833,6 +833,7 @@ static void flush_guest_tlb(struct kvm *kvm)
 		}
 	}
 	asm volatile("ptesync": : :"memory");
+	asm volatile(PPC_INVALIDATE_ERAT : : :"memory");
 }
 
 void kvmppc_check_need_tlb_flush(struct kvm *kvm, int pcpu,
-- 
2.13.6

