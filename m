Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C53CE5DAA3
	for <lists+kvm-ppc@lfdr.de>; Wed,  3 Jul 2019 03:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfGCBUc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 2 Jul 2019 21:20:32 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34402 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGCBUc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 2 Jul 2019 21:20:32 -0400
Received: by mail-pl1-f195.google.com with SMTP id i2so260404plt.1
        for <kvm-ppc@vger.kernel.org>; Tue, 02 Jul 2019 18:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PQ4NMu50Y3TCTLANEIOA6X2/IvBk3A44Utjy8py8evs=;
        b=jXj35CazM3QZbbRCCsaLsfk/Wd3IJLUgBLmEgFQvzQBcgh2GsMNzt97j8wVElT7nKm
         OC5eJShKiW8ihuZQU8qUEinWGcR6vlE9s9i1V1xoH0voEFAmphXy6htvudMPcMHDIGml
         YsNMmEEGxAQpsQHenuA0eLjKefX3OB5tuUncJw/g9Ryi/R6IGGD4+rlhp62TM+IF95mb
         wK4JMRDZ8051Y4qFrDXkFQdqvZbzrQb7qxa1XJ3YhNIkWC1Ctl/HzTEaxeA4EF2moYqT
         FVMjmwYAFBSJ6QPBaKO1O8WBjgciGjoEvML9O4YQWUiT4TrUC6a/yipM4vhZdgNhYP2b
         eZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PQ4NMu50Y3TCTLANEIOA6X2/IvBk3A44Utjy8py8evs=;
        b=UE898kNbo2ICWIWI3c2VoHufGAS6WNPiBXBWaaiB+lcxAZzPor/s2yBTDuRC8YUbo0
         9KlD1eWo2cIib6WXGT3Pg1kvbnN22MYJxDCMyXEja+gn0pN2HRZTbYJ1MAMzsNcn9LHt
         IWr56omNNL0+wxXxu7NseZIx2dxdUConCsnXdaV9BZD/rfQH9B3cky3u6OI2jMDB9i2I
         zY0tBVv1qZwRhNe5LlpwKG7hLGU2tHqWEhrZdqI7gtHhWhxo4RcS/M+w48jfpBT4W4Sd
         V/CABX8EOL9P6GFNzU5tH+70R6/UH47nBjvj625ULKL5a8QXmXXdwA3Cl48j9y30svtK
         u7Rw==
X-Gm-Message-State: APjAAAW0Uj4VY1n98UGZpljvDLP0mkQpR6/ujwGriDZnzY+encoCj1YS
        D1vtzscX8l0Qs5CU2JrrfH8=
X-Google-Smtp-Source: APXvYqxxCayGdd1EX7v0vzne6JjklaJqMqrDnhmtEzSn0ou/oqvDY7xq7c1vlTGWVEBb67pjYVuzAg==
X-Received: by 2002:a17:902:1129:: with SMTP id d38mr39113510pla.220.1562116831564;
        Tue, 02 Jul 2019 18:20:31 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id j11sm318058pfa.2.2019.07.02.18.20.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Jul 2019 18:20:31 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mpe@ellerman.id.au, paulus@ozlabs.org,
        sjitindarsingh@gmail.com
Subject: [PATCH 1/3] KVM: PPC: Book3S HV: Always save guest pmu for guest capable of nesting
Date:   Wed,  3 Jul 2019 11:20:20 +1000
Message-Id: <20190703012022.15644-1-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The performance monitoring unit (PMU) registers are saved on guest exit
when the guest has set the pmcregs_in_use flag in its lppaca, if it
exists, or unconditionally if it doesn't. If a nested guest is being
run then the hypervisor doesn't, and in most cases can't, know if the
pmu registers are in use since it doesn't know the location of the lppaca
for the nested guest, although it may have one for its immediate guest.
This results in the values of these registers being lost across nested
guest entry and exit in the case where the nested guest was making use
of the performance monitoring facility while it's nested guest hypervisor
wasn't.

Further more the hypervisor could interrupt a guest hypervisor between
when it has loaded up the pmu registers and it calling H_ENTER_NESTED or
between returning from the nested guest to the guest hypervisor and the
guest hypervisor reading the pmu registers, in kvmhv_p9_guest_entry().
This means that it isn't sufficient to just save the pmu registers when
entering or exiting a nested guest, but that it is necessary to always
save the pmu registers whenever a guest is capable of running nested guests
to ensure the register values aren't lost in the context switch.

Ensure the pmu register values are preserved by always saving their
value into the vcpu struct when a guest is capable of running nested
guests.

This should have minimal performance impact however any impact can be
avoided by booting a guest with "-machine pseries,cap-nested-hv=false"
on the qemu commandline.

Fixes: 95a6432ce903 "KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests"

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index ec1804f822af..b682a429f3ef 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3654,6 +3654,8 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		vcpu->arch.vpa.dirty = 1;
 		save_pmu = lp->pmcregs_in_use;
 	}
+	/* Must save pmu if this guest is capable of running nested guests */
+	save_pmu |= nesting_enabled(vcpu->kvm);
 
 	kvmhv_save_guest_pmu(vcpu, save_pmu);
 
-- 
2.13.6

