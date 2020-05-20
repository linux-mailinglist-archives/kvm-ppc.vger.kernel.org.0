Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543A31DC1B7
	for <lists+kvm-ppc@lfdr.de>; Thu, 21 May 2020 00:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgETWBI (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 20 May 2020 18:01:08 -0400
Received: from 10.mo4.mail-out.ovh.net ([188.165.33.109]:60778 "EHLO
        10.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728046AbgETWBI (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 20 May 2020 18:01:08 -0400
X-Greylist: delayed 13040 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 May 2020 18:01:07 EDT
Received: from player792.ha.ovh.net (unknown [10.110.103.41])
        by mo4.mail-out.ovh.net (Postfix) with ESMTP id 2306D2367D3
        for <kvm-ppc@vger.kernel.org>; Wed, 20 May 2020 20:23:45 +0200 (CEST)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player792.ha.ovh.net (Postfix) with ESMTPSA id 6F0A9129C9408;
        Wed, 20 May 2020 18:23:37 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-101G00477dc0413-69de-485b-8c2c-a864b1457d08,D4AE9CB3A4750E3488E7135F1D4D455A9A9A4933) smtp.auth=groug@kaod.org
Date:   Wed, 20 May 2020 20:23:36 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, paulus@samba.org, mpe@ellerman.id.au,
        sukadev@linux.ibm.com, linuxram@us.ibm.com
Subject: Re: [PATCH v2] KVM: PPC: Book3S HV: relax check on H_SVM_INIT_ABORT
Message-ID: <20200520202336.661ae973@bahia.lan>
In-Reply-To: <20200520174308.77820-1-ldufour@linux.ibm.com>
References: <20200520193259.0b66db32@bahia.lan>
        <20200520174308.77820-1-ldufour@linux.ibm.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 8480559574304070084
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedruddtledguddvvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpefirhgvghcumfhurhiiuceoghhrohhugheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeehkefhtdehgeehheejledufeekhfdvleefvdeihefhkefhudffhfeuuedvffdthfenucfkpheptddrtddrtddrtddpkedvrddvheefrddvtdekrddvgeeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrjeelvddrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehgrhhouhhgsehkrghougdrohhrghdprhgtphhtthhopehkvhhmqdhpphgtsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 20 May 2020 19:43:08 +0200
Laurent Dufour <ldufour@linux.ibm.com> wrote:

> The commit 8c47b6ff29e3 ("KVM: PPC: Book3S HV: Check caller of H_SVM_*
> Hcalls") added checks of secure bit of SRR1 to filter out the Hcall
> reserved to the Ultravisor.
> 
> However, the Hcall H_SVM_INIT_ABORT is made by the Ultravisor passing the
> context of the VM calling UV_ESM. This allows the Hypervisor to return to
> the guest without going through the Ultravisor. Thus the Secure bit of SRR1
> is not set in that particular case.
> 
> In the case a regular VM is calling H_SVM_INIT_ABORT, this hcall will be
> filtered out in kvmppc_h_svm_init_abort() because kvm->arch.secure_guest is
> not set in that case.
> 
> Fixes: 8c47b6ff29e3 ("KVM: PPC: Book3S HV: Check caller of H_SVM_* Hcalls")
> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
> ---

Reviewed-by: Greg Kurz <groug@kaod.org>

>  arch/powerpc/kvm/book3s_hv.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 93493f0cbfe8..6ad1a3b14300 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -1099,9 +1099,12 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
>  			ret = kvmppc_h_svm_init_done(vcpu->kvm);
>  		break;
>  	case H_SVM_INIT_ABORT:
> -		ret = H_UNSUPPORTED;
> -		if (kvmppc_get_srr1(vcpu) & MSR_S)
> -			ret = kvmppc_h_svm_init_abort(vcpu->kvm);
> +		/*
> +		 * Even if that call is made by the Ultravisor, the SSR1 value
> +		 * is the guest context one, with the secure bit clear as it has
> +		 * not yet been secured. So we can't check it here.
> +		 */
> +		ret = kvmppc_h_svm_init_abort(vcpu->kvm);
>  		break;
>  
>  	default:

