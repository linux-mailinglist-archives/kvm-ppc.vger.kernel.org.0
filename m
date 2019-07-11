Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5327D65769
	for <lists+kvm-ppc@lfdr.de>; Thu, 11 Jul 2019 14:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbfGKM5N (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 11 Jul 2019 08:57:13 -0400
Received: from ozlabs.org ([203.11.71.1]:46943 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbfGKM5M (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 11 Jul 2019 08:57:12 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45kx0P2Pdmz9sNH;
        Thu, 11 Jul 2019 22:57:09 +1000 (AEST)
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
Subject: Re: [PATCH v4 1/8] KVM: PPC: Ultravisor: Introduce the MSR_S bit
In-Reply-To: <20190628200825.31049-2-cclaudio@linux.ibm.com>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com> <20190628200825.31049-2-cclaudio@linux.ibm.com>
Date:   Thu, 11 Jul 2019 22:57:07 +1000
Message-ID: <87muhkg258.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Claudio Carvalho <cclaudio@linux.ibm.com> writes:
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
>
> The ultravisor processor mode is introduced in POWER platforms that
> supports the Protected Execution Facility (PEF). Ultravisor is higher
> privileged than hypervisor mode.
>
> In PEF enabled platforms, the MSR_S bit is used to indicate if the
> thread is in secure state. With the MSR_S bit, the privilege state of
> the thread is now determined by MSR_S, MSR_HV and MSR_PR, as follows:
>
> S   HV  PR
> -----------------------
> 0   x   1   problem
> 1   0   1   problem
> x   x   0   privileged
> x   1   0   hypervisor
> 1   1   0   ultravisor
> 1   1   1   reserved

What are you trying to express with the 'x' value?

I guess you mean it as "either" or "don't care" - but then you have
cases where it could only have one value, such as hypervisor. I think it
would be clearer if you spelled it out more explicitly.

> The hypervisor doesn't (and can't) run with the MSR_S bit set, but a
> secure guest and the ultravisor firmware do.

I know you're trying to be helpful, but this comment is really just
confusing to someone who doesn't have all the documentation.

I'd really like to see something in Documentation/powerpc describing at
least the outline of how the system works. I'm pretty sure most of that
is public, so even if it's mostly a list of references to other
documentations or presentations that would be fine. But I'm not really
happy with a whole new processor mode appearing with zero documentation
in the tree.

> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> [ Update the commit message ]

It's normal to prefix these comments with your handle to make it clear
who is saying it.

> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/reg.h | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
> index 10caa145f98b..39b4c0a519f5 100644
> --- a/arch/powerpc/include/asm/reg.h
> +++ b/arch/powerpc/include/asm/reg.h
> @@ -38,6 +38,7 @@
>  #define MSR_TM_LG	32		/* Trans Mem Available */
>  #define MSR_VEC_LG	25	        /* Enable AltiVec */
>  #define MSR_VSX_LG	23		/* Enable VSX */
> +#define MSR_S_LG	22		/* Secure VM bit */

I don't think that's the best description, because it's also the
Ultravisor bit when MSR[HV] = 1.

So "Secure state" as you have below would be better IMO.

cheers

>  #define MSR_POW_LG	18		/* Enable Power Management */
>  #define MSR_WE_LG	18		/* Wait State Enable */
>  #define MSR_TGPR_LG	17		/* TLB Update registers in use */
> @@ -71,11 +72,13 @@
>  #define MSR_SF		__MASK(MSR_SF_LG)	/* Enable 64 bit mode */
>  #define MSR_ISF		__MASK(MSR_ISF_LG)	/* Interrupt 64b mode valid on 630 */
>  #define MSR_HV 		__MASK(MSR_HV_LG)	/* Hypervisor state */
> +#define MSR_S		__MASK(MSR_S_LG)	/* Secure state */
>  #else
>  /* so tests for these bits fail on 32-bit */
>  #define MSR_SF		0
>  #define MSR_ISF		0
>  #define MSR_HV		0
> +#define MSR_S		0
>  #endif
>  
>  /*
> -- 
> 2.20.1
