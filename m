Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79CF36576F
	for <lists+kvm-ppc@lfdr.de>; Thu, 11 Jul 2019 14:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbfGKM5u (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 11 Jul 2019 08:57:50 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:43137 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbfGKM5u (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 11 Jul 2019 08:57:50 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45kx151mswz9sNT;
        Thu, 11 Jul 2019 22:57:45 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>, linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>
Subject: Re: [PATCH v4 8/8] KVM: PPC: Ultravisor: Check for MSR_S during hv_reset_msr
In-Reply-To: <20190628200825.31049-9-cclaudio@linux.ibm.com>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com> <20190628200825.31049-9-cclaudio@linux.ibm.com>
Date:   Thu, 11 Jul 2019 22:57:43 +1000
Message-ID: <87ef2wg248.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Claudio Carvalho <cclaudio@linux.ibm.com> writes:
> From: Michael Anderson <andmike@linux.ibm.com>
>
>  - Check for MSR_S so that kvmppc_set_msr will include it. Prior to this
>    change return to guest would not have the S bit set.

That sounds like it would be bad?

Please spell out what the practical impact of the patch is, ie.
somewhere on the spectrum from "without this patch everything catches
fire", to "this is not a bug but makes things clearer because ..."

cheers

>  - Patch based on comment from Paul Mackerras <pmac@au1.ibm.com>
>
> Signed-off-by: Michael Anderson <andmike@linux.ibm.com>
> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
> Acked-by: Paul Mackerras <paulus@ozlabs.org>
> ---
>  arch/powerpc/kvm/book3s_64_mmu_hv.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> index ab3d484c5e2e..ab62a66f9b4e 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> @@ -295,6 +295,7 @@ static void kvmppc_mmu_book3s_64_hv_reset_msr(struct kvm_vcpu *vcpu)
>  		msr |= MSR_TS_S;
>  	else
>  		msr |= vcpu->arch.shregs.msr & MSR_TS_MASK;
> +	msr |= vcpu->arch.shregs.msr & MSR_S;
>  	kvmppc_set_msr(vcpu, msr);
>  }
>  
> -- 
> 2.20.1
