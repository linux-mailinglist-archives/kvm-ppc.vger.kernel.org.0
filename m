Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11070366DC1
	for <lists+kvm-ppc@lfdr.de>; Wed, 21 Apr 2021 16:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239546AbhDUOKm (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 21 Apr 2021 10:10:42 -0400
Received: from 9.mo51.mail-out.ovh.net ([46.105.48.137]:36366 "EHLO
        9.mo51.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239480AbhDUOKm (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 21 Apr 2021 10:10:42 -0400
Received: from mxplan5.mail.ovh.net (unknown [10.108.1.237])
        by mo51.mail-out.ovh.net (Postfix) with ESMTPS id 21C372811BB;
        Wed, 21 Apr 2021 15:31:45 +0200 (CEST)
Received: from kaod.org (37.59.142.104) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Wed, 21 Apr
 2021 15:31:45 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-104R005fde4d96d-4b09-4c53-bf41-50ee194d27e8,
                    3FD145AD23CDC28BEDADD0458B38E3079EC5C648) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 90.89.73.13
Subject: Re: [PATCH v1] KVM: PPC: Book3S HV P9: implement
 kvmppc_xive_pull_vcpu in C
To:     Nicholas Piggin <npiggin@gmail.com>, <kvm-ppc@vger.kernel.org>
CC:     <linuxppc-dev@lists.ozlabs.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
References: <20210413133802.1691660-1-npiggin@gmail.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <18f75805-160b-b8c0-b8df-84fc801af93e@kaod.org>
Date:   Wed, 21 Apr 2021 15:31:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210413133802.1691660-1-npiggin@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.104]
X-ClientProxiedBy: DAG8EX1.mxp5.local (172.16.2.71) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: 51411077-147f-4b63-a934-da58dbb75886
X-Ovh-Tracer-Id: 2972657230926482400
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrvddtkedgieeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffvfhfhkffffgggjggtgfhisehtkeertddtfeejnecuhfhrohhmpeevrogurhhitggpnfgvpgfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhephedtgfethfduhfduteeuhefffefhgfdtudevudevudfgtdfgjedukeffteelkeffnecuffhomhgrihhnpehrmhhhrghnughlvghrshdrshgsnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrddutdegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegtlhhgsehkrghougdrohhrghdprhgtphhtthhopehnphhighhgihhnsehgmhgrihhlrdgtohhm
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 4/13/21 3:38 PM, Nicholas Piggin wrote:
> This is more symmetric with kvmppc_xive_push_vcpu, and has the advantage
> that it runs with the MMU on.
> 
> The extra test added to the asm will go away with a future change.
> 
> Reviewed-by: Cédric Le Goater <clg@kaod.org>
> Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
> Another bit that came from the KVM Cify series.
> 
> Thanks,
> Nick
> 
>  arch/powerpc/include/asm/kvm_ppc.h      |  2 ++
>  arch/powerpc/kvm/book3s_hv.c            |  2 ++
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S |  5 ++++
>  arch/powerpc/kvm/book3s_xive.c          | 31 +++++++++++++++++++++++++
>  4 files changed, 40 insertions(+)
> 
> diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
> index 9531b1c1b190..73b1ca5a6471 100644
> --- a/arch/powerpc/include/asm/kvm_ppc.h
> +++ b/arch/powerpc/include/asm/kvm_ppc.h
> @@ -672,6 +672,7 @@ extern int kvmppc_xive_set_icp(struct kvm_vcpu *vcpu, u64 icpval);
>  extern int kvmppc_xive_set_irq(struct kvm *kvm, int irq_source_id, u32 irq,
>  			       int level, bool line_status);
>  extern void kvmppc_xive_push_vcpu(struct kvm_vcpu *vcpu);
> +extern void kvmppc_xive_pull_vcpu(struct kvm_vcpu *vcpu);
>  
>  static inline int kvmppc_xive_enabled(struct kvm_vcpu *vcpu)
>  {
> @@ -712,6 +713,7 @@ static inline int kvmppc_xive_set_icp(struct kvm_vcpu *vcpu, u64 icpval) { retur
>  static inline int kvmppc_xive_set_irq(struct kvm *kvm, int irq_source_id, u32 irq,
>  				      int level, bool line_status) { return -ENODEV; }
>  static inline void kvmppc_xive_push_vcpu(struct kvm_vcpu *vcpu) { }
> +static inline void kvmppc_xive_pull_vcpu(struct kvm_vcpu *vcpu) { }
>  
>  static inline int kvmppc_xive_enabled(struct kvm_vcpu *vcpu)
>  	{ return 0; }
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 4a532410e128..981bcaf787a8 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3570,6 +3570,8 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>  
>  	trap = __kvmhv_vcpu_entry_p9(vcpu);
>  
> +	kvmppc_xive_pull_vcpu(vcpu);
> +
>  	/* Advance host PURR/SPURR by the amount used by guest */
>  	purr = mfspr(SPRN_PURR);
>  	spurr = mfspr(SPRN_SPURR);
> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> index 75405ef53238..c11597f815e4 100644
> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> @@ -1442,6 +1442,11 @@ guest_exit_cont:		/* r9 = vcpu, r12 = trap, r13 = paca */
>  	bl	kvmhv_accumulate_time
>  #endif
>  #ifdef CONFIG_KVM_XICS
> +	/* If we came in through the P9 short path, xive pull is done in C */
> +	lwz	r0, STACK_SLOT_SHORT_PATH(r1)
> +	cmpwi	r0, 0
> +	bne	1f
> +
>  	/* We are exiting, pull the VP from the XIVE */
>  	lbz	r0, VCPU_XIVE_PUSHED(r9)
>  	cmpwi	cr0, r0, 0
> diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
> index e7219b6f5f9a..741bf1f4387a 100644
> --- a/arch/powerpc/kvm/book3s_xive.c
> +++ b/arch/powerpc/kvm/book3s_xive.c
> @@ -127,6 +127,37 @@ void kvmppc_xive_push_vcpu(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvmppc_xive_push_vcpu);
>  
> +/*
> + * Pull a vcpu's context from the XIVE on guest exit.
> + * This assumes we are in virtual mode (MMU on)
> + */
> +void kvmppc_xive_pull_vcpu(struct kvm_vcpu *vcpu)
> +{
> +	void __iomem *tima = local_paca->kvm_hstate.xive_tima_virt;
> +
> +	if (!vcpu->arch.xive_pushed)
> +		return;
> +
> +	/*
> +	 * Should not have been pushed if there is no tima
> +	 */
> +	if (WARN_ON(!tima))
> +		return;
> +
> +	eieio();
> +	/* First load to pull the context, we ignore the value */
> +	__raw_readl(tima + TM_SPC_PULL_OS_CTX);
> +	/* Second load to recover the context state (Words 0 and 1) */
> +	vcpu->arch.xive_saved_state.w01 = __raw_readq(tima + TM_QW1_OS);

This load could be removed on P10, since HW is configured to do the same.
It should save a few cycles.

C. 

> +	/* Fixup some of the state for the next load */
> +	vcpu->arch.xive_saved_state.lsmfb = 0;
> +	vcpu->arch.xive_saved_state.ack = 0xff;
> +	vcpu->arch.xive_pushed = 0;
> +	eieio();
> +}
> +EXPORT_SYMBOL_GPL(kvmppc_xive_pull_vcpu);
> +
>  /*
>   * This is a simple trigger for a generic XIVE IRQ. This must
>   * only be called for interrupts that support a trigger page
> 

