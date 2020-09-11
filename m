Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69513265F40
	for <lists+kvm-ppc@lfdr.de>; Fri, 11 Sep 2020 14:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbgIKMJv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 11 Sep 2020 08:09:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38782 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgIKMJn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 11 Sep 2020 08:09:43 -0400
Received: from 1.general.cascardo.us.vpn ([10.172.70.58] helo=mussarela)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1kGhrE-0003aM-11; Fri, 11 Sep 2020 12:08:48 +0000
Date:   Fri, 11 Sep 2020 09:08:43 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Greg Kurz <groug@kaod.org>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>, trivial@kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Don't return -ENOTSUPP to userspace in ioctls
Message-ID: <20200911120843.GG4002@mussarela>
References: <159982162511.459323.13495475646618845164.stgit@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159982162511.459323.13495475646618845164.stgit@bahia.lan>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Sep 11, 2020 at 12:53:45PM +0200, Greg Kurz wrote:
> ENOTSUPP is a linux only thingy, the value of which is unknown to
> userspace, not to be confused with ENOTSUP which linux maps to
> EOPNOTSUPP, as permitted by POSIX [1]:
> 
> [EOPNOTSUPP]
> Operation not supported on socket. The type of socket (address family
> or protocol) does not support the requested operation. A conforming
> implementation may assign the same values for [EOPNOTSUPP] and [ENOTSUP].
> 
> Return -EOPNOTSUPP instead of -ENOTSUPP for the following ioctls:
> - KVM_GET_FPU for Book3s and BookE
> - KVM_SET_FPU for Book3s and BookE
> - KVM_GET_DIRTY_LOG for BookE
> 
> This doesn't affect QEMU which doesn't call the KVM_GET_FPU and
> KVM_SET_FPU ioctls on POWER anyway since they are not supported,
> and _buggily_ ignores anything but -EPERM for KVM_GET_DIRTY_LOG.
> 
> [1] https://pubs.opengroup.org/onlinepubs/9699919799/functions/V2_chap02.html
> 
> Signed-off-by: Greg Kurz <groug@kaod.org>

Agreed. ENOTSUPP should never be returned to userspace.

Acked-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

> ---
>  arch/powerpc/kvm/book3s.c |    4 ++--
>  arch/powerpc/kvm/booke.c  |    6 +++---
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
> index 1fce9777af1c..44bf567b6589 100644
> --- a/arch/powerpc/kvm/book3s.c
> +++ b/arch/powerpc/kvm/book3s.c
> @@ -558,12 +558,12 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>  
>  int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
>  {
> -	return -ENOTSUPP;
> +	return -EOPNOTSUPP;
>  }
>  
>  int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
>  {
> -	return -ENOTSUPP;
> +	return -EOPNOTSUPP;
>  }
>  
>  int kvmppc_get_one_reg(struct kvm_vcpu *vcpu, u64 id,
> diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
> index 3e1c9f08e302..b1abcb816439 100644
> --- a/arch/powerpc/kvm/booke.c
> +++ b/arch/powerpc/kvm/booke.c
> @@ -1747,12 +1747,12 @@ int kvmppc_set_one_reg(struct kvm_vcpu *vcpu, u64 id,
>  
>  int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
>  {
> -	return -ENOTSUPP;
> +	return -EOPNOTSUPP;
>  }
>  
>  int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
>  {
> -	return -ENOTSUPP;
> +	return -EOPNOTSUPP;
>  }
>  
>  int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
> @@ -1773,7 +1773,7 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>  
>  int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
>  {
> -	return -ENOTSUPP;
> +	return -EOPNOTSUPP;
>  }
>  
>  void kvmppc_core_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
> 
> 
