Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94CE5477C6
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 Jun 2019 03:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbfFQBsS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 16 Jun 2019 21:48:18 -0400
Received: from ozlabs.org ([203.11.71.1]:55539 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727481AbfFQBsS (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 16 Jun 2019 21:48:18 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45RvHg5VxFz9s4Y; Mon, 17 Jun 2019 11:48:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1560736095; bh=ANDNfTwZB0m+2tUoAJS3RHHR0Z6quTecM+C9ab4Py7s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vIyQoPQCpd3fkSK5edpneU3sQdCAsrkY3SDfk9fEi6Jv94/mAhyBR3SRhgiJUwAv1
         zD3FVcUdKIuVXPpmWsR0i5PzUSSUP8N7+W4j1txQB0FY54uPF0OHyuTBrbGDvamA4R
         g/opJF7EywJUjlaw5ovANRikGqDSuc4icWZajmtU9GpOvSu/zjgfnKltkbF8HaiTFS
         RFCLUOkp4dJIvQZaDl6dx4cUMIbEDzLfux0f22hJSS5fN6MRVkDsw+LBLHmIqebnEL
         hWVCXldw9ahH2iV/knpoNA+ED9F8ygyopofc35PhTZZtteeas5aA39PnqOoD8pFk0P
         eHNuzHdBnyJEQ==
Date:   Mon, 17 Jun 2019 11:48:11 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 4/5] KVM: PPC: Book3S HV: Implement LPCR[AIL]=3 mode for
 injected interrupts
Message-ID: <20190617014811.a7nabxo3e3ex7ued@oak.ozlabs.ibm.com>
References: <20190520005659.18628-1-npiggin@gmail.com>
 <20190520005659.18628-4-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520005659.18628-4-npiggin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, May 20, 2019 at 10:56:58AM +1000, Nicholas Piggin wrote:
> kvmppc_inject_interrupt does not implement LPCR[AIL]!=0 modes, which
> can result in the guest receiving interrupts as if LPCR[AIL]=0
> contrary to the ISA.
> 
> In practice, Linux guests cope with this deviation, but it should be
> fixed.

Comment below...

> diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
> index 5ae7f8359368..2453a085da86 100644
> --- a/arch/powerpc/kvm/book3s_hv_builtin.c
> +++ b/arch/powerpc/kvm/book3s_hv_builtin.c
> @@ -797,6 +797,20 @@ void kvmppc_inject_interrupt_hv(struct kvm_vcpu *vcpu, int vec, u64 srr1_flags)
>  		new_msr |= msr & MSR_TS_MASK;
>  #endif
>  
> +#ifdef CONFIG_PPC_BOOK3S_64

Why do we need this ifdef?  This file doesn't get compiled when
CONFIG_PPC_BOOK3S_64=n, right?

Paul.
