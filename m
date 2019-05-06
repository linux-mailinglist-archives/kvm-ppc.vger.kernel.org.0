Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4EE14EBE
	for <lists+kvm-ppc@lfdr.de>; Mon,  6 May 2019 17:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbfEFPE3 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 6 May 2019 11:04:29 -0400
Received: from 7.mo7.mail-out.ovh.net ([46.105.43.131]:34988 "EHLO
        7.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728034AbfEFPE2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 6 May 2019 11:04:28 -0400
Received: from player730.ha.ovh.net (unknown [10.108.54.67])
        by mo7.mail-out.ovh.net (Postfix) with ESMTP id 32B1811271F
        for <kvm-ppc@vger.kernel.org>; Mon,  6 May 2019 17:04:25 +0200 (CEST)
Received: from kaod.org (lfbn-1-10649-41.w90-89.abo.wanadoo.fr [90.89.235.41])
        (Authenticated sender: clg@kaod.org)
        by player730.ha.ovh.net (Postfix) with ESMTPSA id 6E57255802CD;
        Mon,  6 May 2019 15:04:18 +0000 (UTC)
Subject: Re: [PATCH] KVM: PPC: Book3S HV: XIVE: Clear escalation interrupt
 pointers on device close
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org
Cc:     David Gibson <david@gibson.dropbear.id.au>, kvm-ppc@vger.kernel.org
References: <20190426065414.GC12768@blackberry>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <4d9e4296-2004-265c-9eb6-748d2f71e98e@kaod.org>
Date:   Mon, 6 May 2019 17:04:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190426065414.GC12768@blackberry>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 5546464419197586391
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrjeejgdekiecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 4/26/19 8:54 AM, Paul Mackerras wrote:
> This adds code to ensure that after a XIVE or XICS-on-XIVE KVM device
> is closed, KVM will not try to enable or disable any of the escalation
> interrupts for the VCPUs.  

Yes. This is a required cleanup.

Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.


> We don't have to worry about races between
> clearing the pointers and use of the pointers by the XIVE context
> push/pull code, because the callers hold the vcpu->mutex, which is
> also taken by the KVM_RUN code.  Therefore the vcpu cannot be entering
> or exiting the guest concurrently.
> 
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
> ---
>  arch/powerpc/kvm/book3s_xive.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
> index 4280cd8..4953957 100644
> --- a/arch/powerpc/kvm/book3s_xive.c
> +++ b/arch/powerpc/kvm/book3s_xive.c
> @@ -1096,6 +1096,21 @@ void kvmppc_xive_disable_vcpu_interrupts(struct kvm_vcpu *vcpu)
>  			arch_spin_unlock(&sb->lock);
>  		}
>  	}
> +
> +	/* Disable vcpu's escalation interrupt */
> +	if (vcpu->arch.xive_esc_on) {
> +		__raw_readq((void __iomem *)(vcpu->arch.xive_esc_vaddr +
> +					     XIVE_ESB_SET_PQ_01));
> +		vcpu->arch.xive_esc_on = false;
> +	}
> +
> +	/*
> +	 * Clear pointers to escalation interrupt ESB.
> +	 * This is safe because the vcpu->mutex is held, preventing
> +	 * any other CPU from concurrently executing a KVM_RUN ioctl.
> +	 */
> +	vcpu->arch.xive_esc_vaddr = 0;
> +	vcpu->arch.xive_esc_raddr = 0;
>  }
>  
>  void kvmppc_xive_cleanup_vcpu(struct kvm_vcpu *vcpu)
> 

