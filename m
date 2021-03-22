Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E997344E6B
	for <lists+kvm-ppc@lfdr.de>; Mon, 22 Mar 2021 19:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbhCVSW4 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 14:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhCVSWj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 14:22:39 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0B1C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 11:22:38 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id e33so9181524pgm.13
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 11:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=QxuKVyTvlzqvIyZMYlOg/wA3wb29CMEYj7cOhvVg6Ms=;
        b=I+57htQtmF2AGOV53/d3NGT6d3KMsm84nHKheSyx2H9pMmiM26AA7Hm2OMzwIO4Rx7
         WwQmvTnesrC3BgilV1jCBI3MZzG2PuQoT3dgnB/MkHzxlJENm1ziG+tnpec9hf4lOVyH
         k2xz1dT4YYkpO114LmCBH0HO0nrtmpWCz3TfW7bFj8vLF6tiU2rfVZZO743ntbbdhyTp
         s353K6XdNEv9phGcx+6wSpOsI/hot7o5+9OsI9pzembozA+dL4ClEnrS+psvbyO/bqTP
         xMhFxQt6oggQcXFHy105e4HSHoGB1BTd7CDMxeKghD04fiY4YGqwSLzVH95P4NZHpf2/
         7yCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=QxuKVyTvlzqvIyZMYlOg/wA3wb29CMEYj7cOhvVg6Ms=;
        b=cebQPpLFfSjhPJm8YUu8NdipqBrcu2U7glLVjJE3b2aiGYe8ziFeZmFslFTbBoB5g2
         d/G0M+uuKRMXxyOBtUe+zb4uKT9kLgN8czhn4JXdNOsHduLGNvABzGjzX1cNrq2lTU7W
         YbsLEggL5hVqlfG7Vzk3Sk2kBlbplhYnVWCOti6HCvohe4rrNsNFFN+X8js+5z8TRYo3
         CNpNstZyT9AXraOokv9jZ7jk10+xTtLCuhVwVQ0e7Gss48pHfRJmdk+Q9WCoiry6DMqf
         xR0p8t9+kQbpxh1sYi3vVgJ6+WV2UODPBaNPtiLtiWJaPW6cR1SDBRO596ALZx/F5a7k
         KRFQ==
X-Gm-Message-State: AOAM531Fj1KUmGnyjkS13ufnhzJr1/m3U/X+bDgAlftcP89HZpi4biGm
        r20Igw+fr1Pw9qf50cI8Q6k=
X-Google-Smtp-Source: ABdhPJw6cS0mcws5+WfS0HfdOPCd7dYV/QHFippasKFEEZfoE5Z5zDXMos3aPkjVUlsAuoRHxOtM/g==
X-Received: by 2002:a63:390:: with SMTP id 138mr783494pgd.8.1616437357732;
        Mon, 22 Mar 2021 11:22:37 -0700 (PDT)
Received: from localhost ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id g21sm140870pjl.28.2021.03.22.11.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 11:22:36 -0700 (PDT)
Date:   Tue, 23 Mar 2021 04:22:31 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 19/41] KVM: PPC: Book3S HV P9: Stop handling hcalls in
 real-mode in the P9 path
To:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        =?iso-8859-1?q?C=E9dric?= Le Goater <clg@kaod.org>,
        kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210305150638.2675513-1-npiggin@gmail.com>
        <20210305150638.2675513-20-npiggin@gmail.com>
        <b06ebe14-a714-c882-8bdf-ac41de9a8523@ozlabs.ru>
        <1616417941.ksskhyvg3t.astroid@bobo.none>
        <cc1660a7-e81e-b7b3-a841-35fb77fb571b@kaod.org>
In-Reply-To: <cc1660a7-e81e-b7b3-a841-35fb77fb571b@kaod.org>
MIME-Version: 1.0
Message-Id: <1616436906.owrt3o4wh1.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from C=C3=A9dric Le Goater's message of March 23, 2021 2:01 am:
> On 3/22/21 2:15 PM, Nicholas Piggin wrote:
>> Excerpts from Alexey Kardashevskiy's message of March 22, 2021 5:30 pm:
>>>
>>>
>>> On 06/03/2021 02:06, Nicholas Piggin wrote:
>>>> In the interest of minimising the amount of code that is run in>>> "re=
al-mode", don't handle hcalls in real mode in the P9 path.
>>>>
>>>> POWER8 and earlier are much more expensive to exit from HV real mode
>>>> and switch to host mode, because on those processors HV interrupts get
>>>> to the hypervisor with the MMU off, and the other threads in the core
>>>> need to be pulled out of the guest, and SLBs all need to be saved,
>>>> ERATs invalidated, and host SLB reloaded before the MMU is re-enabled
>>>> in host mode. Hash guests also require a lot of hcalls to run. The
>>>> XICS interrupt controller requires hcalls to run.
>>>>
>>>> By contrast, POWER9 has independent thread switching, and in radix mod=
e
>>>> the hypervisor is already in a host virtual memory mode when the HV
>>>> interrupt is taken. Radix + xive guests don't need hcalls to handle
>>>> interrupts or manage translations.
>=20
> Do we need to handle the host-is-a-P9-without-xive case ?

I'm not sure really. Is there an intention for OPAL to be able to=20
provide a fallback layer in the worst case? Maybe microwatt grows
HV capability before XIVE?

>=20
>>>> So it's much less important to handle hcalls in real mode in P9.
>>>
>>> So acde25726bc6034b (which added if(kvm_is_radix(vcpu->kvm))return=20
>>> H_TOO_HARD) can be reverted, pretty much?
>>=20
>> Yes. Although that calls attention to the fact I missed doing
>> a P9 h_random handler in this patch. I'll fix that, then I think
>> acde2572 could be reverted entirely.
>>=20
>> [...]
>>=20
>>>>   	} else {
>>>>   		kvmppc_xive_push_vcpu(vcpu);
>>>>   		trap =3D kvmhv_load_hv_regs_and_go(vcpu, time_limit, lpcr);
>>>> -		kvmppc_xive_pull_vcpu(vcpu);
>>>> +		/* H_CEDE has to be handled now, not later */
>>>> +		/* XICS hcalls must be handled before xive is pulled */
>>>> +		if (trap =3D=3D BOOK3S_INTERRUPT_SYSCALL &&
>>>> +		    !(vcpu->arch.shregs.msr & MSR_PR)) {
>>>> +			unsigned long req =3D kvmppc_get_gpr(vcpu, 3);
>>>>  =20
>>>> +			if (req =3D=3D H_CEDE) {
>>>> +				kvmppc_cede(vcpu);
>>>> +				kvmppc_xive_cede_vcpu(vcpu); /* may un-cede */
>>>> +				kvmppc_set_gpr(vcpu, 3, 0);
>>>> +				trap =3D 0;
>>>> +			}
>>>> +			if (req =3D=3D H_EOI || req =3D=3D H_CPPR ||
>>>
>>> else if (req =3D=3D H_EOI ... ?
>>=20
>> Hummm, sure.
>=20
> you could integrate the H_CEDE in the switch statement below.

Below is in a different file just for the emulation calls.

>>=20
>> [...]
>>=20
>>>> +void kvmppc_xive_cede_vcpu(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	void __iomem *esc_vaddr =3D (void __iomem *)vcpu->arch.xive_esc_vadd=
r;
>>>> +
>>>> +	if (!esc_vaddr)
>>>> +		return;
>>>> +
>>>> +	/* we are using XIVE with single escalation */
>>>> +
>>>> +	if (vcpu->arch.xive_esc_on) {
>>>> +		/*
>>>> +		 * If we still have a pending escalation, abort the cede,
>>>> +		 * and we must set PQ to 10 rather than 00 so that we don't
>>>> +		 * potentially end up with two entries for the escalation
>>>> +		 * interrupt in the XIVE interrupt queue.  In that case
>>>> +		 * we also don't want to set xive_esc_on to 1 here in
>>>> +		 * case we race with xive_esc_irq().
>>>> +		 */
>>>> +		vcpu->arch.ceded =3D 0;
>>>> +		/*
>>>> +		 * The escalation interrupts are special as we don't EOI them.
>>>> +		 * There is no need to use the load-after-store ordering offset
>>>> +		 * to set PQ to 10 as we won't use StoreEOI.
>>>> +		 */
>>>> +		__raw_readq(esc_vaddr + XIVE_ESB_SET_PQ_10);
>>>> +	} else {
>>>> +		vcpu->arch.xive_esc_on =3D true;
>>>> +		mb();
>>>> +		__raw_readq(esc_vaddr + XIVE_ESB_SET_PQ_00);
>>>> +	}
>>>> +	mb();
>>>
>>>
>>> Uff. Thanks for cut-n-pasting the comments, helped a lot to match this =
c=20
>>> to that asm!
>>=20
>> Glad it helped.
>>>> +}
>=20
> I had to do the PowerNV models in QEMU to start understanding that stuff =
...=20
>=20
>>>> +EXPORT_SYMBOL_GPL(kvmppc_xive_cede_vcpu);
>>>> +
>>>>   /*
>>>>    * This is a simple trigger for a generic XIVE IRQ. This must
>>>>    * only be called for interrupts that support a trigger page
>>>> @@ -2106,6 +2140,32 @@ static int kvmppc_xive_create(struct kvm_device=
 *dev, u32 type)
>>>>   	return 0;
>>>>   }
>>>>  =20
>>>> +int kvmppc_xive_xics_hcall(struct kvm_vcpu *vcpu, u32 req)
>>>> +{
>>>> +	struct kvmppc_vcore *vc =3D vcpu->arch.vcore;
>>>
>>>
>>> Can a XIVE enabled guest issue these hcalls? Don't we want if=20
>>> (!kvmppc_xics_enabled(vcpu)) and
>>>   if (xics_on_xive()) here, as kvmppc_rm_h_xirr() have? Some of these=20
>>> hcalls do write to XIVE registers but some seem to change=20
>>> kvmppc_xive_vcpu. Thanks,
>>=20
>> Yes I think you're right, good catch. I'm not completely sure about all=20
>> the xive and xics modes but a guest certainly can make any kind of hcall=
=20
>> it likes and we have to sanity check it.
>=20
> Yes.=20
>=20
>> We want to take the hcall here (in replacement of the real mode hcalls)
>> with the same condition. So it would be:
>>=20
>>         if (!kvmppc_xics_enabled(vcpu))
>>                 return H_TOO_HARD;
>=20
> Yes.
>=20
> This test covers the case in which a vCPU does XICS hcalls without QEMU=20
> having connected the vCPU to a XICS ICP. The ICP is the KVM XICS device=20
> on P8 or XICS-on-XIVE on P9. It catches QEMU errors when the interrupt=20
> mode is negotiated, we don't want the OS to do XICS hcalls after having=20
> negotiated the XIVE interrupt mode.=20

Okay.

> It's different for the XIVE hcalls (when running under XICS) because they=
=20
> are all handled in QEMU.=20

XIVE guest hcalls running on XICS host?

>>         if (!xics_on_xive())
>> 		return H_TOO_HARD;
>=20
> I understand that this code is only called on P9 and with translation on.

Yes.

> On P9, we could have xics_on_xive() =3D=3D 0 if XIVE is disabled at compi=
le=20
> time or with "xive=3Doff" at boot time. But guests should be supported.=20
> I don't see a reason to restrict the support even if these scenarios=20
> are rather unusual if not very rare.
>=20
> on P10, it's the same but since we don't have the XICS emulation layer=20
> in OPAL, the host will be pretty useless. We don't care.
>=20
> Since we are trying to handle hcalls, this is L0 and it can not be called=
=20
> for nested guests, which would be another case of xics_on_xive() =3D=3D 0=
.=20
> We don't care either.

Okay so no xics_on_xive() test. I'll change that.

Thanks,
Nick
