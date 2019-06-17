Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08519477B5
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 Jun 2019 03:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfFQBjp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 16 Jun 2019 21:39:45 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:36355 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727389AbfFQBjp (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 16 Jun 2019 21:39:45 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45Rv5p6y4Jz9sBr; Mon, 17 Jun 2019 11:39:42 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1560735582; bh=pcv1Phlc4kk6OPUazU/QM2QaQ731Z9xGbPl8OXiUXAc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MZbZpPOebOybDaiHLevQQVx5E2tMS/dyxtdab5wjTVV5HTrrfs4+RP7Y9d1xumk+X
         HrUjKg0t5NlT+26jpPcAJCr0p/tbVeGexWEp7nsrQ1AnGGVaISccEeFIXNAItH2hCw
         02WgGINMWaHt/8rqENLS4LecTOXu1xIbjmyy6OmPK8igdkrfaCVVsGW/epuzpMwdSV
         ShA9CoaH0Ep/yDppr+j6QD27uksbyvhQckdj4Re8qkrQZnieI/3mHjBbDItznuaxJr
         TCSM2IiTJVBqd6XwtGZTiJcKLMhd7oFT1TJO2ed5HVWhPAHFz+8CwpsufAjCGINoMy
         zJ52Zugt4GmIg==
Date:   Mon, 17 Jun 2019 11:39:39 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 2/5] KVM: PPC: Book3S: Replace reset_msr mmu op with
 inject_interrupt arch op
Message-ID: <20190617013939.ewv2txwz2w7priej@oak.ozlabs.ibm.com>
References: <20190520005659.18628-1-npiggin@gmail.com>
 <20190520005659.18628-2-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520005659.18628-2-npiggin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, May 20, 2019 at 10:56:56AM +1000, Nicholas Piggin wrote:
> reset_msr sets the MSR for interrupt injection, but it's cleaner and
> more flexible to provide a single op to set both MSR and PC for the
> interrupt.

Comment below...

> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index d5fc624e0655..46015d2e09e0 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -341,6 +341,29 @@ static void kvmppc_core_vcpu_put_hv(struct kvm_vcpu *vcpu)
>  	spin_unlock_irqrestore(&vcpu->arch.tbacct_lock, flags);
>  }
>  
> +static void kvmppc_inject_interrupt_hv(struct kvm_vcpu *vcpu, int vec, u64 srr1_flags)
> +{
> +	unsigned long msr, pc, new_msr, new_pc;
> +
> +	msr = kvmppc_get_msr(vcpu);
> +	pc = kvmppc_get_pc(vcpu);
> +	new_msr = vcpu->arch.intr_msr;
> +	new_pc = vec;
> +
> +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM

Do we really need this ifdef?  It only saves a few bytes, and it
wasn't present in the place where this code came from.  And the same
comment applies to the code in book3s_pr.c.

Paul.
