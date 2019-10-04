Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79463CB35B
	for <lists+kvm-ppc@lfdr.de>; Fri,  4 Oct 2019 04:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731004AbfJDCxx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 3 Oct 2019 22:53:53 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34015 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730309AbfJDCxw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 3 Oct 2019 22:53:52 -0400
Received: by mail-pl1-f196.google.com with SMTP id k7so2449249pll.1
        for <kvm-ppc@vger.kernel.org>; Thu, 03 Oct 2019 19:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pw20gjwGyIvk4z43y2bV2DrT/I4s7wENPGMcRRJ5rbU=;
        b=I+7X8PFymt8BYtwV6VPllwcWxilbTowRfL8xWjjgfRDnyc1vOoMFchC9SqBarrsgAm
         6ghMr6iSAVYWfyXYZbtwpFaL5m10QOx0SvNLbUCf9yzu6zmtGnOMiZE/eqwVAxvT/ZlR
         gnn2mvEePlMKHVn4PrCP+n8V7eYsHkjxVZBrZPDMjU4037JYe1NYNSKwe5OrcOgJb53m
         wDUSQw+7WwmK/vaxvYN1EoaKjv/qX4ZZOP1m+OwAZdYXoRVhVKdPYKqVQ0LJOjC/2t3s
         BSkFO5qdHDD9ZG/obz7Th/peMJBH7WXnmUwJvGCAEIdSzgKaM/Z6nBbDR9p4KMEnLiA4
         kNrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pw20gjwGyIvk4z43y2bV2DrT/I4s7wENPGMcRRJ5rbU=;
        b=M81kM+CA4mGSHgo9xEPcRQ2W8tWNrTT/11CQGha9/c2i0CHKLe8DW0cMN+BTfBRBx8
         sv9sz9UZho4l17GwNbV7I6xQ3Ko/CcNfRVfytTdn9stmDH/JUaoX23DZmYtJA/NbiRDh
         EjC5dwMcooixZY/tl+qvu0xvBd2F0FpjAeoCo067BFUQoBri3AtwR8nNrsdGWfpfKquT
         e9SslKttJrdvxuceLYdxiIZsJLt43+36tvH+TkD+NPSCptI1dXMAiw4EVMP9pURpOHuS
         Z+2kF5/dOf1so2v6GulWBKBLpYYLH3OGyC8ZksS0heWk2vcipQzrvpvJZtu/M7GlktGZ
         qjPg==
X-Gm-Message-State: APjAAAW44tdMlp6LX1tUaWDJ0QZYIPrFG8/8NrBvcWi7i45WyxsjLtK7
        tFxvutl/Ww8LHjdEInLrNzc=
X-Google-Smtp-Source: APXvYqz+Wnmy5oq8K1YLi07YGFVPhyMZPZ0qDgQMDHCzmadww+fy1WVnAmWycWvQyFJxrLfO/vp3nA==
X-Received: by 2002:a17:902:ff18:: with SMTP id f24mr12839898plj.173.1570157632027;
        Thu, 03 Oct 2019 19:53:52 -0700 (PDT)
Received: from pasglop.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id d20sm6920181pfq.88.2019.10.03.19.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 19:53:51 -0700 (PDT)
From:   Jordan Niethe <jniethe5@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     patch-notifications@ellerman.id.au, paulus@ozlabs.org,
        alistair@popple.id.au, kvm-ppc@vger.kernel.org, aik@ozlabs.ru,
        Jordan Niethe <jniethe5@gmail.com>
Subject: [PATCH] powerpc/kvm: Fix kvmppc_vcore->in_guest value in kvmhv_switch_to_host
Date:   Fri,  4 Oct 2019 12:53:17 +1000
Message-Id: <20191004025317.19340-1-jniethe5@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

kvmhv_switch_to_host() in arch/powerpc/kvm/book3s_hv_rmhandlers.S needs
to set kvmppc_vcore->in_guest to 0 to signal secondary CPUs to continue.
This happens after resetting the PCR. Before commit 13c7bb3c57dc
("powerpc/64s: Set reserved PCR bits"), r0 would always be 0 before it
was stored to kvmppc_vcore->in_guest. However because of this change in
the commit:

        /* Reset PCR */
        ld      r0, VCORE_PCR(r5)
-       cmpdi   r0, 0
+       LOAD_REG_IMMEDIATE(r6, PCR_MASK)
+       cmpld   r0, r6
        beq     18f
-       li      r0, 0
-       mtspr   SPRN_PCR, r0
+       mtspr   SPRN_PCR, r6
 18:
        /* Signal secondary CPUs to continue */
        stb     r0,VCORE_IN_GUEST(r5)

We are no longer comparing r0 against 0 and loading it with 0 if it
contains something else. Hence when we store r0 to
kvmppc_vcore->in_guest, it might not be 0.  This means that secondary
CPUs will not be signalled to continue. Those CPUs get stuck and errors
like the following are logged:

    KVM: CPU 1 seems to be stuck
    KVM: CPU 2 seems to be stuck
    KVM: CPU 3 seems to be stuck
    KVM: CPU 4 seems to be stuck
    KVM: CPU 5 seems to be stuck
    KVM: CPU 6 seems to be stuck
    KVM: CPU 7 seems to be stuck

This can be reproduced with:
    $ for i in `seq 1 7` ; do chcpu -d $i ; done ;
    $ taskset -c 0 qemu-system-ppc64 -smp 8,threads=8 \
       -M pseries,accel=kvm,kvm-type=HV -m 1G -nographic -vga none \
       -kernel vmlinux -initrd initrd.cpio.xz

Fix by making sure r0 is 0 before storing it to kvmppc_vcore->in_guest.

Fixes: 13c7bb3c57dc ("powerpc/64s: Set reserved PCR bits")
Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 74a9cfe84aee..faebcbb8c4db 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -1921,6 +1921,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
 	mtspr	SPRN_PCR, r6
 18:
 	/* Signal secondary CPUs to continue */
+	li	r0, 0
 	stb	r0,VCORE_IN_GUEST(r5)
 19:	lis	r8,0x7fff		/* MAX_INT@h */
 	mtspr	SPRN_HDEC,r8
-- 
2.20.1

