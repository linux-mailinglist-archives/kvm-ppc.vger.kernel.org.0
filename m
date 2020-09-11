Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D11265E61
	for <lists+kvm-ppc@lfdr.de>; Fri, 11 Sep 2020 12:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbgIKKx4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm-ppc@lfdr.de>); Fri, 11 Sep 2020 06:53:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51434 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725710AbgIKKxx (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 11 Sep 2020 06:53:53 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-OnADtvZ-MD-Qnyk_94E4sg-1; Fri, 11 Sep 2020 06:53:49 -0400
X-MC-Unique: OnADtvZ-MD-Qnyk_94E4sg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 121EB81CBE7;
        Fri, 11 Sep 2020 10:53:48 +0000 (UTC)
Received: from bahia.lan (ovpn-113-23.ams2.redhat.com [10.36.113.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D40D027BD0;
        Fri, 11 Sep 2020 10:53:45 +0000 (UTC)
Subject: [PATCH] KVM: PPC: Don't return -ENOTSUPP to userspace in ioctls
From:   Greg Kurz <groug@kaod.org>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        trivial@kernel.org
Date:   Fri, 11 Sep 2020 12:53:45 +0200
Message-ID: <159982162511.459323.13495475646618845164.stgit@bahia.lan>
User-Agent: StGit/0.21
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=groug@kaod.org
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: kaod.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

ENOTSUPP is a linux only thingy, the value of which is unknown to
userspace, not to be confused with ENOTSUP which linux maps to
EOPNOTSUPP, as permitted by POSIX [1]:

[EOPNOTSUPP]
Operation not supported on socket. The type of socket (address family
or protocol) does not support the requested operation. A conforming
implementation may assign the same values for [EOPNOTSUPP] and [ENOTSUP].

Return -EOPNOTSUPP instead of -ENOTSUPP for the following ioctls:
- KVM_GET_FPU for Book3s and BookE
- KVM_SET_FPU for Book3s and BookE
- KVM_GET_DIRTY_LOG for BookE

This doesn't affect QEMU which doesn't call the KVM_GET_FPU and
KVM_SET_FPU ioctls on POWER anyway since they are not supported,
and _buggily_ ignores anything but -EPERM for KVM_GET_DIRTY_LOG.

[1] https://pubs.opengroup.org/onlinepubs/9699919799/functions/V2_chap02.html

Signed-off-by: Greg Kurz <groug@kaod.org>
---
 arch/powerpc/kvm/book3s.c |    4 ++--
 arch/powerpc/kvm/booke.c  |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 1fce9777af1c..44bf567b6589 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -558,12 +558,12 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 
 int kvmppc_get_one_reg(struct kvm_vcpu *vcpu, u64 id,
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 3e1c9f08e302..b1abcb816439 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -1747,12 +1747,12 @@ int kvmppc_set_one_reg(struct kvm_vcpu *vcpu, u64 id,
 
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 
 int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
@@ -1773,7 +1773,7 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 
 int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 {
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 
 void kvmppc_core_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)


