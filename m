Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94FA6344564
	for <lists+kvm-ppc@lfdr.de>; Mon, 22 Mar 2021 14:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhCVNSa (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 09:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhCVNPj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 09:15:39 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F3AC061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 06:15:38 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso8504502pjb.3
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 06:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=eWbPIX4LvCYaXMETb/NGTke/4oExib4R55S8CtxwLio=;
        b=sGmzVSN5gKsNLzmEtRylSxBhciDbMRFIuW5rYoZFUFfEL0YdJNJmTNj5QF1KE3zzJO
         806h82tnDb2JpKnGMATGhMAy9eCyjkY9+BzFNDtY8VQHDXQpSv7SPtsPz52YIOJ/0nIb
         ZKojgb/dqFbaSP+Y5+4UcnGxiiG8ZrtEl/bHL34HeGpymkyAxwSQ/QN2rqufNn0Fu117
         5telPUFzFTmNH3GNVccSFWXrWaUYztymu6pxt+ApzChBDW4lI7YbIL1n5onWhklWF7jm
         QwSJG4EVb+vd8UNxhQMJLsdFirBU4khJc1iTMr0njX1IUTIVTdZspFxJAjOwXV3K2en4
         bmOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=eWbPIX4LvCYaXMETb/NGTke/4oExib4R55S8CtxwLio=;
        b=CmWWj8mAHcp2c46AptHJoQTpunKttRTGICngYUDYrALUncFuf4DLAmYblV39LMOyaQ
         WJJCOMOqdO6ZX6VDtf7jp4uY6LbN2TZaCDeW1u7xlhx91HmYHdC1RJnQhjXReqe1NxOh
         GQ59OMC8F9XpBkV6gOnJIPZsYlO1OQDfPSDAa6UCkHZDVCkVv771DhKEWcWeDA6lP++v
         3b+OLnl+ojspcNndcPjqOxJEuaiuwdZpNPmlbsq7LwP+GNKn33lOm1pRi8MeDlfhdVUc
         +dXTOf1rJn1hrPBWDOG8QnDmxjvsoKTEFIw3DEjLDhsGhXT28uFFsenrvV62pZV0fSC4
         zYvg==
X-Gm-Message-State: AOAM531p3MgzyGQ6jBsx5ez5ggxKMJjmi2YJ79PdLZ9wpuJbLif6wLBh
        8VTOtjK+NIevMzex0HYjtao0+iTbYvw=
X-Google-Smtp-Source: ABdhPJyWZpOBADRwJFux8ntisJkX9nMzCcb9dlQHwhkoPRs8mSQXwm5J1CRkMd0A/hzI7YhAr7cREg==
X-Received: by 2002:a17:90b:f15:: with SMTP id br21mr13469015pjb.234.1616418937853;
        Mon, 22 Mar 2021 06:15:37 -0700 (PDT)
Received: from localhost ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id m4sm12224419pgu.4.2021.03.22.06.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 06:15:36 -0700 (PDT)
Date:   Mon, 22 Mar 2021 23:15:30 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 19/41] KVM: PPC: Book3S HV P9: Stop handling hcalls in
 real-mode in the P9 path
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org,
        =?iso-8859-1?q?C=E9dric?= Le Goater <clg@kaod.org>
References: <20210305150638.2675513-1-npiggin@gmail.com>
        <20210305150638.2675513-20-npiggin@gmail.com>
        <b06ebe14-a714-c882-8bdf-ac41de9a8523@ozlabs.ru>
In-Reply-To: <b06ebe14-a714-c882-8bdf-ac41de9a8523@ozlabs.ru>
MIME-Version: 1.0
Message-Id: <1616417941.ksskhyvg3t.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Alexey Kardashevskiy's message of March 22, 2021 5:30 pm:
>=20
>=20
> On 06/03/2021 02:06, Nicholas Piggin wrote:
>> In the interest of minimising the amount of code that is run in
>> "real-mode", don't handle hcalls in real mode in the P9 path.
>>=20
>> POWER8 and earlier are much more expensive to exit from HV real mode
>> and switch to host mode, because on those processors HV interrupts get
>> to the hypervisor with the MMU off, and the other threads in the core
>> need to be pulled out of the guest, and SLBs all need to be saved,
>> ERATs invalidated, and host SLB reloaded before the MMU is re-enabled
>> in host mode. Hash guests also require a lot of hcalls to run. The
>> XICS interrupt controller requires hcalls to run.
>>=20
>> By contrast, POWER9 has independent thread switching, and in radix mode
>> the hypervisor is already in a host virtual memory mode when the HV
>> interrupt is taken. Radix + xive guests don't need hcalls to handle
>> interrupts or manage translations.
>>=20
>> So it's much less important to handle hcalls in real mode in P9.
>=20
> So acde25726bc6034b (which added if(kvm_is_radix(vcpu->kvm))return=20
> H_TOO_HARD) can be reverted, pretty much?

Yes. Although that calls attention to the fact I missed doing
a P9 h_random handler in this patch. I'll fix that, then I think
acde2572 could be reverted entirely.

[...]

>>   	} else {
>>   		kvmppc_xive_push_vcpu(vcpu);
>>   		trap =3D kvmhv_load_hv_regs_and_go(vcpu, time_limit, lpcr);
>> -		kvmppc_xive_pull_vcpu(vcpu);
>> +		/* H_CEDE has to be handled now, not later */
>> +		/* XICS hcalls must be handled before xive is pulled */
>> +		if (trap =3D=3D BOOK3S_INTERRUPT_SYSCALL &&
>> +		    !(vcpu->arch.shregs.msr & MSR_PR)) {
>> +			unsigned long req =3D kvmppc_get_gpr(vcpu, 3);
>>  =20
>> +			if (req =3D=3D H_CEDE) {
>> +				kvmppc_cede(vcpu);
>> +				kvmppc_xive_cede_vcpu(vcpu); /* may un-cede */
>> +				kvmppc_set_gpr(vcpu, 3, 0);
>> +				trap =3D 0;
>> +			}
>> +			if (req =3D=3D H_EOI || req =3D=3D H_CPPR ||
>=20
> else if (req =3D=3D H_EOI ... ?

Hummm, sure.

[...]

>> +void kvmppc_xive_cede_vcpu(struct kvm_vcpu *vcpu)
>> +{
>> +	void __iomem *esc_vaddr =3D (void __iomem *)vcpu->arch.xive_esc_vaddr;
>> +
>> +	if (!esc_vaddr)
>> +		return;
>> +
>> +	/* we are using XIVE with single escalation */
>> +
>> +	if (vcpu->arch.xive_esc_on) {
>> +		/*
>> +		 * If we still have a pending escalation, abort the cede,
>> +		 * and we must set PQ to 10 rather than 00 so that we don't
>> +		 * potentially end up with two entries for the escalation
>> +		 * interrupt in the XIVE interrupt queue.  In that case
>> +		 * we also don't want to set xive_esc_on to 1 here in
>> +		 * case we race with xive_esc_irq().
>> +		 */
>> +		vcpu->arch.ceded =3D 0;
>> +		/*
>> +		 * The escalation interrupts are special as we don't EOI them.
>> +		 * There is no need to use the load-after-store ordering offset
>> +		 * to set PQ to 10 as we won't use StoreEOI.
>> +		 */
>> +		__raw_readq(esc_vaddr + XIVE_ESB_SET_PQ_10);
>> +	} else {
>> +		vcpu->arch.xive_esc_on =3D true;
>> +		mb();
>> +		__raw_readq(esc_vaddr + XIVE_ESB_SET_PQ_00);
>> +	}
>> +	mb();
>=20
>=20
> Uff. Thanks for cut-n-pasting the comments, helped a lot to match this c=20
> to that asm!

Glad it helped.

>> +}
>> +EXPORT_SYMBOL_GPL(kvmppc_xive_cede_vcpu);
>> +
>>   /*
>>    * This is a simple trigger for a generic XIVE IRQ. This must
>>    * only be called for interrupts that support a trigger page
>> @@ -2106,6 +2140,32 @@ static int kvmppc_xive_create(struct kvm_device *=
dev, u32 type)
>>   	return 0;
>>   }
>>  =20
>> +int kvmppc_xive_xics_hcall(struct kvm_vcpu *vcpu, u32 req)
>> +{
>> +	struct kvmppc_vcore *vc =3D vcpu->arch.vcore;
>=20
>=20
> Can a XIVE enabled guest issue these hcalls? Don't we want if=20
> (!kvmppc_xics_enabled(vcpu)) and
>   if (xics_on_xive()) here, as kvmppc_rm_h_xirr() have? Some of these=20
> hcalls do write to XIVE registers but some seem to change=20
> kvmppc_xive_vcpu. Thanks,

Yes I think you're right, good catch. I'm not completely sure about all=20
the xive and xics modes but a guest certainly can make any kind of hcall=20
it likes and we have to sanity check it.

We want to take the hcall here (in replacement of the real mode hcalls)
with the same condition. So it would be:

        if (!kvmppc_xics_enabled(vcpu))
                return H_TOO_HARD;
        if (!xics_on_xive())
		return H_TOO_HARD;
=09
	[ ... process xive_vm_h_xirr / cppr / eoi / etc ]

Right?

Thanks,
Nick

>=20
>=20
>=20
>=20
>> +
>> +	switch (req) {
>> +	case H_XIRR:
>> +		return xive_vm_h_xirr(vcpu);
>> +	case H_CPPR:
>> +		return xive_vm_h_cppr(vcpu, kvmppc_get_gpr(vcpu, 4));
>> +	case H_EOI:
>> +		return xive_vm_h_eoi(vcpu, kvmppc_get_gpr(vcpu, 4));
>> +	case H_IPI:
>> +		return xive_vm_h_ipi(vcpu, kvmppc_get_gpr(vcpu, 4),
>> +					  kvmppc_get_gpr(vcpu, 5));
>> +	case H_IPOLL:
>> +		return xive_vm_h_ipoll(vcpu, kvmppc_get_gpr(vcpu, 4));
>> +	case H_XIRR_X:
>> +		xive_vm_h_xirr(vcpu);
>> +		kvmppc_set_gpr(vcpu, 5, get_tb() + vc->tb_offset);
>> +		return H_SUCCESS;
>> +	}
>> +
>> +	return H_UNSUPPORTED;
>> +}
>> +EXPORT_SYMBOL_GPL(kvmppc_xive_xics_hcall);
>> +
>>   int kvmppc_xive_debug_show_queues(struct seq_file *m, struct kvm_vcpu =
*vcpu)
>>   {
>>   	struct kvmppc_xive_vcpu *xc =3D vcpu->arch.xive_vcpu;
>>=20
>=20
> --=20
> Alexey
>=20
