Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFCCC5DAA6
	for <lists+kvm-ppc@lfdr.de>; Wed,  3 Jul 2019 03:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfGCBUm (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 2 Jul 2019 21:20:42 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37308 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbfGCBUk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 2 Jul 2019 21:20:40 -0400
Received: by mail-pl1-f196.google.com with SMTP id bh12so252841plb.4
        for <kvm-ppc@vger.kernel.org>; Tue, 02 Jul 2019 18:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=q3fFTelOhqkb1Mwuc5eMY9x9ha5lfJs2EAbdT9hPUxk=;
        b=RH/3iLdsxo433D8bqQwGL/9FPB5yF+k0fcF0uDWNdIqHFwBKMirdOH4am3QXNHJYSn
         rY4r/pfbR+HzWOa8YVSKaFR9ZO0LQC9H7zOEQB9tnIzDUuqEI0/DOQsr96nFf1b3qFyb
         6cXV24+vc/1EXm/XtkVqszJoIDg37R/TAYjbci2YtuwMMmUMcIx/WTBbAXc0Ia8zjZxb
         KlYMd6yImr8TLShte/YqPNUQ7PxXlM4kt6sNtxgzIpCoFrcMPe1vGPasbGwY0djwAzlE
         a+iINADzJwNendu1TCWNzcYc0hmoerC/E8aEh16OQx+UthQ07cWtau49tHUp+PXjmr6E
         MQ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=q3fFTelOhqkb1Mwuc5eMY9x9ha5lfJs2EAbdT9hPUxk=;
        b=dWfg08apRIyjHDCnCC1TZ4wFTPuofCOUmQrEKG+J3AOZDl+0iHpvz0WsRVlIQXY9S9
         fwLUXchQW18h1qPst7flZKZBZ4KrdlcJRfe0m6Pz/uqas3wakU3ueU85Mh4WnI/M+8g2
         CaVs+4iqbxSBB8w8iGvRBzy4Qar+T5vWolW7iAbqBiXeehjyAW+fKA78ShgAYVDs4xBI
         9nSACZTDb5wOJpTi+tX23q0478pwqOD4lBVBJZ3a9nnFP6nMg2Yh25nLvU98znd2xVC7
         POvzynUanSePTiJmx4cxmocOwSFphHepv6sltQXC/oqYVhBZ7PbxvNH7HCXDT50W+SqZ
         X1RQ==
X-Gm-Message-State: APjAAAW+CTrS8G415bQhuHklvUzBnX60SmzP+YNrxCOYEiet9pU+x766
        8gXng9IQoqoOzNkr2tuw43o=
X-Google-Smtp-Source: APXvYqzkt5g7kNg6hKYTqsIuNXDzDhDUtUgqHARyXeeseHu6TWKvRfxy1H2TSr3uJ1aWKFKC5zKorA==
X-Received: by 2002:a17:902:684:: with SMTP id 4mr38647623plh.138.1562116840189;
        Tue, 02 Jul 2019 18:20:40 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id j11sm318058pfa.2.2019.07.02.18.20.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Jul 2019 18:20:39 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mpe@ellerman.id.au, paulus@ozlabs.org,
        sjitindarsingh@gmail.com
Subject: [PATCH 3/3] KVM: PPC: Book3S HV: Save and restore guest visible PSSCR bits on pseries
Date:   Wed,  3 Jul 2019 11:20:22 +1000
Message-Id: <20190703012022.15644-3-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190703012022.15644-1-sjitindarsingh@gmail.com>
References: <20190703012022.15644-1-sjitindarsingh@gmail.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The performance stop status and control register (PSSCR) is used to
control the power saving facilities of the processor. This register has
various fields, some of which can be modified only in hypervisor state,
and others which can be modified in both hypervisor and priviledged
non-hypervisor state. The bits which can be modified in priviledged
non-hypervisor state are referred to as guest visible.

Currently the L0 hypervisor saves and restores both it's own host value
as well as the guest value of the psscr when context switching between
the hypervisor and guest. However a nested hypervisor running it's own
nested guests (as indicated by kvmhv_on_pseries()) doesn't context
switch the psscr register. This means that if a nested (L2) guest
modified the psscr that the L1 guest hypervisor will run with this
value, and if the L1 guest hypervisor modified this value and then goes
to run the nested (L2) guest again that the L2 psscr value will be lost.

Fix this by having the (L1) nested hypervisor save and restore both its
host and the guest psscr value when entering and exiting a nested (L2)
guest. Note that only the guest visible parts of the psscr are context
switched since this is all the L1 nested hypervisor can access, this is
fine however as these are the only fields the L0 hypervisor provides
guest control of anyway and so all other fields are ignored.

This could also have been implemented by adding the psscr register to
the hv_regs passed to the L0 hypervisor as input to the H_ENTER_NESTED
hcall, however this would have meant updating the structure layout and
thus required modifications to both the L0 and L1 kernels. Whereas the
approach used doesn't require L0 kernel modifications while achieving
the same result.

Fixes: 95a6432ce903 "KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests"

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index b682a429f3ef..cde3f5a4b3e4 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3569,9 +3569,18 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	mtspr(SPRN_DEC, vcpu->arch.dec_expires - mftb());
 
 	if (kvmhv_on_pseries()) {
+		/*
+		 * We need to save and restore the guest visible part of the
+		 * psscr (i.e. using SPRN_PSSCR_PR) since the hypervisor
+		 * doesn't do this for us. Note only required if pseries since
+		 * this is done in kvmhv_load_hv_regs_and_go() below otherwise.
+		 */
+		unsigned long host_psscr;
 		/* call our hypervisor to load up HV regs and go */
 		struct hv_guest_state hvregs;
 
+		host_psscr = mfspr(SPRN_PSSCR_PR);
+		mtspr(SPRN_PSSCR_PR, vcpu->arch.psscr);
 		kvmhv_save_hv_regs(vcpu, &hvregs);
 		hvregs.lpcr = lpcr;
 		vcpu->arch.regs.msr = vcpu->arch.shregs.msr;
@@ -3590,6 +3599,8 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		vcpu->arch.shregs.msr = vcpu->arch.regs.msr;
 		vcpu->arch.shregs.dar = mfspr(SPRN_DAR);
 		vcpu->arch.shregs.dsisr = mfspr(SPRN_DSISR);
+		vcpu->arch.psscr = mfspr(SPRN_PSSCR_PR);
+		mtspr(SPRN_PSSCR_PR, host_psscr);
 
 		/* H_CEDE has to be handled now, not later */
 		if (trap == BOOK3S_INTERRUPT_SYSCALL && !vcpu->arch.nested &&
-- 
2.13.6

