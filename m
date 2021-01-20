Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6A32FC5C2
	for <lists+kvm-ppc@lfdr.de>; Wed, 20 Jan 2021 01:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbhATA1k (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 19 Jan 2021 19:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727450AbhATA1i (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 19 Jan 2021 19:27:38 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4418AC061573
        for <kvm-ppc@vger.kernel.org>; Tue, 19 Jan 2021 16:26:58 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id q20so13392105pfu.8
        for <kvm-ppc@vger.kernel.org>; Tue, 19 Jan 2021 16:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:references:in-reply-to:mime-version:message-id
         :content-transfer-encoding;
        bh=fZ6Yeu0aefudIRTiSVq3VDUTWlirpo0W2U3YMont1js=;
        b=cFFhDQ9ohOw4egQ6Ew7IBMYT2hI9F2d+r2AgbIoa6R34KnUTt8GSfzprrLxB87GFMU
         vyGIKGZn3lL/5oXNgLYcZ19JyLzgJ2Al89lI5y5Qov+6ZBDIQ704cKJYQFxyXkMiiyUZ
         5DS6dF9cm0ikI44oBcoDzsYvGGD+c2sAqfeu5q0D+RcZ6yfWrUyIp4E8wWU1CKWt6Fbl
         AzAR1Bt1u4eM038Gbr/7NPSy8EzQaKZVqpmmVhYD47poesdaUX/HpEf3EdvHSahkgE6q
         plKFcUPuMkZ6RTijxh5Oi2KRaOmaHaejleb50POECXZ5NdOhOYjottOLqWt9nZfIuVgV
         YRJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=fZ6Yeu0aefudIRTiSVq3VDUTWlirpo0W2U3YMont1js=;
        b=Y1cXhBcBST175TsdjCyOWuk+jjhcvCbKxo5HJ3nIPFb4E+flWqjd8y69AMtuVaZYR1
         jIhiX3aP909r8lQjg7dSZI2n6kvE+W9O7Z4vcuSTwy+Vb2i5HH6pULTbOv+nEsqHFWZ2
         n/7lb/LXtExxg3/xrWBz6Vo6TXg4vbjNiDoQYtQnt2ILsfQHz7NpdN020y9bZZEDq04B
         mxfockUVI2Ce6H9V7+BW1dAM/4iMlVTY2DFacAp8jDwVWfAp6R+kVjbH/i0e5Ie+XF4s
         LGNqTIQPyBnQ9mPdoZq11QQuIrSAI0UtqC0RGwPcMfCcwts8cWAEdd9P9KJVMtfTwJtw
         Jlzg==
X-Gm-Message-State: AOAM5322YQIt+YLMI4yYLymivWZk30kYOBod1pM7SYFRj7jCcMs4wdXq
        zyc/FifidsyKcOMXBSWtKZo=
X-Google-Smtp-Source: ABdhPJxClTRJyVnEaBp6AjtkhCmMl7ShkitYnh3pvrxu3TEz0RfeU5GJVoFtELjNveXPo1K99yX74w==
X-Received: by 2002:a63:ff09:: with SMTP id k9mr6789190pgi.175.1611102417849;
        Tue, 19 Jan 2021 16:26:57 -0800 (PST)
Received: from localhost ([124.170.13.62])
        by smtp.gmail.com with ESMTPSA id s76sm247062pfc.35.2021.01.19.16.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 16:26:57 -0800 (PST)
Date:   Wed, 20 Jan 2021 10:26:51 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 2/2] KVM: PPC: Book3S HV: Optimise TLB flushing when a
 vcpu moves between threads in a core
To:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        kvm-ppc@vger.kernel.org
References: <20210118122609.1447366-1-npiggin@gmail.com>
        <20210118122609.1447366-2-npiggin@gmail.com> <87sg6x5kfo.fsf@linux.ibm.com>
In-Reply-To: <87sg6x5kfo.fsf@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1611101698.8m2ih5f8sn.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Aneesh Kumar K.V's message of January 19, 2021 7:45 pm:
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
>> As explained in the comment, there is no need to flush TLBs on all
>> threads in a core when a vcpu moves between threads in the same core.
>>
>> Thread migrations can be a significant proportion of vcpu migrations,
>> so this can help reduce the TLB flushing and IPI traffic.
>>
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>> I believe we can do this and have the TLB coherency correct as per
>> the architecture, but would appreciate someone else verifying my
>> thinking.
>>
>> Thanks,
>> Nick
>>
>>  arch/powerpc/kvm/book3s_hv.c | 28 ++++++++++++++++++++++++++--
>>  1 file changed, 26 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index 752daf43f780..53d0cbfe5933 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -2584,7 +2584,7 @@ static void kvmppc_release_hwthread(int cpu)
>>  	tpaca->kvm_hstate.kvm_split_mode =3D NULL;
>>  }
>> =20
>> -static void radix_flush_cpu(struct kvm *kvm, int cpu, struct kvm_vcpu *=
vcpu)
>> +static void radix_flush_cpu(struct kvm *kvm, int cpu, bool core, struct=
 kvm_vcpu *vcpu)
>>  {
>=20
> Can we rename 'core' to something like 'core_sched'  or 'within_core'=20
>=20
>>  	struct kvm_nested_guest *nested =3D vcpu->arch.nested;
>>  	cpumask_t *cpu_in_guest;
>> @@ -2599,6 +2599,14 @@ static void radix_flush_cpu(struct kvm *kvm, int =
cpu, struct kvm_vcpu *vcpu)
>>  		cpu_in_guest =3D &kvm->arch.cpu_in_guest;
>>  	}
>>
>=20
> and do
>       if (core_sched) {

This function is called to flush guest TLBs on this cpu / all threads on=20
this cpu core. I don't think it helps to bring any "why" logic into it
because the caller has already dealt with that.

Thanks,
Nick

>=20
>> +	if (!core) {
>> +		cpumask_set_cpu(cpu, need_tlb_flush);
>> +		smp_mb();
>> +		if (cpumask_test_cpu(cpu, cpu_in_guest))
>> +			smp_call_function_single(cpu, do_nothing, NULL, 1);
>> +		return;
>> +	}
>> +
>>  	cpu =3D cpu_first_thread_sibling(cpu);
>>  	for (i =3D 0; i < threads_per_core; ++i)
>>  		cpumask_set_cpu(cpu + i, need_tlb_flush);
>> @@ -2655,7 +2663,23 @@ static void kvmppc_prepare_radix_vcpu(struct kvm_=
vcpu *vcpu, int pcpu)
>>  		if (prev_cpu < 0)
>>  			return; /* first run */
>> =20
>> -		radix_flush_cpu(kvm, prev_cpu, vcpu);
>> +		/*
>> +		 * If changing cores, all threads on the old core should
>> +		 * flush, because TLBs can be shared between threads. More
>> +		 * precisely, the thread we previously ran on should be
>> +		 * flushed, and the thread to first run a vcpu on the old
>> +		 * core should flush, but we don't keep enough information
>> +		 * around to track that, so we flush all.
>> +		 *
>> +		 * If changing threads in the same core, only the old thread
>> +		 * need be flushed.
>> +		 */
>> +		if (cpu_first_thread_sibling(prev_cpu) !=3D
>> +		    cpu_first_thread_sibling(pcpu))
>> +			radix_flush_cpu(kvm, prev_cpu, true, vcpu);
>> +		else
>> +			radix_flush_cpu(kvm, prev_cpu, false, vcpu);
>> +
>>  	}
>>  }
>> =20
>> --=20
>> 2.23.0
>=20
