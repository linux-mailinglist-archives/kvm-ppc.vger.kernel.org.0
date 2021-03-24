Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B04346EA9
	for <lists+kvm-ppc@lfdr.de>; Wed, 24 Mar 2021 02:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbhCXB1v (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 23 Mar 2021 21:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbhCXB1Q (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 23 Mar 2021 21:27:16 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB87C061763
        for <kvm-ppc@vger.kernel.org>; Tue, 23 Mar 2021 18:27:16 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id v23so7058479ple.9
        for <kvm-ppc@vger.kernel.org>; Tue, 23 Mar 2021 18:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=nzpqaVMQ3IUMG30sPJ4iVSoB4g0F5+nzjHooZaW9EYU=;
        b=o9jdf0UaH4iqgysLoFQBtvAxyJfnWn7+yiETn9HREIvvcG388uTFwirj4zIFo/l+hd
         F8tZwyLBbu+RjSWm0ciry23PEyNCCJ+Uv3nNGpid4T7taxoLEsad3aFEnGMLtyf5PDaX
         JhhRUXbJGRy/80zULMBAHrafLb72/576E+qmGWPVN1rG68RQy0wzMbd0U0POsparqH8j
         x6VUEpnd1wXQchAKYOXHB811UdhIoy85v1SCsnQXklkJXitD19/TZ4x7McNP47ElCvbf
         YCkN8+TF46Gk8/N6RegAJhSklDXAvBJvjKu3yBzBcn9ZNosVy5FuA8qg5v1EamSVh+3W
         D8JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=nzpqaVMQ3IUMG30sPJ4iVSoB4g0F5+nzjHooZaW9EYU=;
        b=cq4IhC+FYW5kU07re3sRVcvbx+nJgngimaKjbSYaLH66plnIif8OXdUHKTvxIj44DN
         vijlDcgm45SdXo01l3CAXxP+OJ18uraszd7u3bbA2GXZiR4UXf4MA/W+ORaJI9VojLOo
         v+G/bV9hgCwmf6XkpilIyBtrkJnhZEbogelEHh/a+FcRLVKz1UszRoanB10HdynOP6T9
         RCjcKC1jHTXUbtaQwul+6b4UmZALLnGHawVngiMDc2UjDWDCXZv47CFcyp7tuw99sVzB
         fBrUIw0KFLH/6K0nkM+DS0cfcWKm0qNv4imXipRCUbCNK8Unmu6Jf5FETh3jJaPpHGCR
         S/ng==
X-Gm-Message-State: AOAM533IzNjuCs5PVTxePal5p4MTUlGQVhh4d22/bhbrjnsRd0LR3/Fx
        6WzwmyNbNr85SiJp0n89R+7xF7LAcdM=
X-Google-Smtp-Source: ABdhPJwlnb/0C1Upjp5GyaOwv9VkE9QbE7AYqUqpNbtyCDRoHVEOKqD+YO5IYQCVyEFHZ7WmqWIFjQ==
X-Received: by 2002:a17:90b:1044:: with SMTP id gq4mr816183pjb.232.1616549235640;
        Tue, 23 Mar 2021 18:27:15 -0700 (PDT)
Received: from localhost (193-116-197-97.tpgi.com.au. [193.116.197.97])
        by smtp.gmail.com with ESMTPSA id v1sm366370pjt.1.2021.03.23.18.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 18:27:14 -0700 (PDT)
Date:   Wed, 24 Mar 2021 11:27:09 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 22/46] KVM: PPC: Book3S HV P9: Stop handling hcalls in
 real-mode in the P9 path
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210323010305.1045293-1-npiggin@gmail.com>
        <20210323010305.1045293-23-npiggin@gmail.com> <87y2ed5vi0.fsf@linux.ibm.com>
In-Reply-To: <87y2ed5vi0.fsf@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1616548948.qjnut0qf3h.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of March 24, 2021 8:57 am:
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
>> In the interest of minimising the amount of code that is run in
>> "real-mode", don't handle hcalls in real mode in the P9 path.
>>
>> POWER8 and earlier are much more expensive to exit from HV real mode
>> and switch to host mode, because on those processors HV interrupts get
>> to the hypervisor with the MMU off, and the other threads in the core
>> need to be pulled out of the guest, and SLBs all need to be saved,
>> ERATs invalidated, and host SLB reloaded before the MMU is re-enabled
>> in host mode. Hash guests also require a lot of hcalls to run. The
>> XICS interrupt controller requires hcalls to run.
>>
>> By contrast, POWER9 has independent thread switching, and in radix mode
>> the hypervisor is already in a host virtual memory mode when the HV
>> interrupt is taken. Radix + xive guests don't need hcalls to handle
>> interrupts or manage translations.
>>
>> So it's much less important to handle hcalls in real mode in P9.
>>
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>=20
> <snip>
>=20
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index fa7614c37e08..17739aaee3d8 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -1142,12 +1142,13 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcp=
u)
>>  }
>>
>>  /*
>> - * Handle H_CEDE in the nested virtualization case where we haven't
>> - * called the real-mode hcall handlers in book3s_hv_rmhandlers.S.
>> + * Handle H_CEDE in the P9 path where we don't call the real-mode hcall
>> + * handlers in book3s_hv_rmhandlers.S.
>> + *
>>   * This has to be done early, not in kvmppc_pseries_do_hcall(), so
>>   * that the cede logic in kvmppc_run_single_vcpu() works properly.
>>   */
>> -static void kvmppc_nested_cede(struct kvm_vcpu *vcpu)
>> +static void kvmppc_cede(struct kvm_vcpu *vcpu)
>>  {
>>  	vcpu->arch.shregs.msr |=3D MSR_EE;
>>  	vcpu->arch.ceded =3D 1;
>> @@ -1403,9 +1404,15 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu =
*vcpu,
>>  		/* hcall - punt to userspace */
>>  		int i;
>>
>> -		/* hypercall with MSR_PR has already been handled in rmode,
>> -		 * and never reaches here.
>> -		 */
>> +		if (unlikely(vcpu->arch.shregs.msr & MSR_PR)) {
>> +			/*
>> +			 * Guest userspace executed sc 1, reflect it back as a
>> +			 * privileged program check interrupt.
>> +			 */
>> +			kvmppc_core_queue_program(vcpu, SRR1_PROGPRIV);
>> +			r =3D RESUME_GUEST;
>> +			break;
>> +		}
>=20
> This patch bypasses sc_1_fast_return so it breaks KVM-PR. L1 loops with
> the following output:
>=20
> [    9.503929][ T3443] Couldn't emulate instruction 0x4e800020 (op 19 xop=
 16)
> [    9.503990][ T3443] kvmppc_exit_pr_progint: emulation at 48f4 failed (=
4e800020)
> [    9.504080][ T3443] Couldn't emulate instruction 0x4e800020 (op 19 xop=
 16)
> [    9.504170][ T3443] kvmppc_exit_pr_progint: emulation at 48f4 failed (=
4e800020)
>=20
> 0x4e800020 is a blr after a sc 1 in SLOF.
>=20
> For KVM-PR we need to inject a 0xc00 at some point, either here or
> before branching to no_try_real in book3s_hv_rmhandlers.S.

Ah, I didn't know about that PR KVM (I suppose I should test it but I=20
haven't been able to get it running in the past).

Should be able to deal with that. This patch probably shouldn't change=20
the syscall behaviour like this anyway.

Thanks,
Nick
