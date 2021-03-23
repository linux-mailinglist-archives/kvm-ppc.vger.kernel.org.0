Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E037345A98
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 10:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbhCWJRS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 23 Mar 2021 05:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhCWJQq (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 23 Mar 2021 05:16:46 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8CDC061574
        for <kvm-ppc@vger.kernel.org>; Tue, 23 Mar 2021 02:16:46 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id v2so11044406pgk.11
        for <kvm-ppc@vger.kernel.org>; Tue, 23 Mar 2021 02:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=5BDD63F9RbA0cIc4K62YFaOVo6SGtjL/6YgIaXly2Fo=;
        b=VwqCh8dn+GgwI88ucFwNs9M28t/zwQVK8OhLoOUSKqLF52iAR8DPfQsD3BEhzLRoJb
         JJnDF6Tu4Kv6EYunhBNqtHJrCKVMpgDmECJjQt/s3qwyPobPoYkkW5YzkhuF2AAOrgy4
         BXC7oCKyDzLvUg8gcS4JdRsZVi0F4iCpO6oStIqVaFeU+/EV81okHYdv0LsN6pfTBAAL
         1wUzqsGyMDHp41MgQDa4uvr1VPBTNgrycUij/D5Th+UsIFa7+6rVfpZx+y9qTs+X+XkH
         Hm3Ba0Re9VxcpiLoKO8pLZBDGvSGkK2iga8U8wz/Z3Gk3tS5p3wZJanwa9P9hBZsfsF/
         azhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=5BDD63F9RbA0cIc4K62YFaOVo6SGtjL/6YgIaXly2Fo=;
        b=p6uUPTIfp2OWdFfgUGwzlmnpx16DlkEKBuiCxFBwc7XVBU2ggWabvrJAJqG1NkZkIr
         9f2yRWAk3WRjRLFMbyE+nRvaS01Q+G86PDK6ggmGWZLqUJnjuO5uXYZLN5fEK6X9yRi7
         YsKH75uZQ65NsiC8MDdRtdqM8IxyH+mm4LSs4XOdEcv5SEaZTpzuLMoIEfhhfmuQUIQg
         2jU0+mwp7SU8O+n1ZeQnTG0rpJKmhF4rs0JIdsMGl8SGcmTbT03EdxDreZFoOgg6820F
         HobvN1n+iVDhEDROjxPf68hnbmAF/lAIiS0qazJ9egczmzLAcEdGwl5YPoTQa0nPYbTS
         PKew==
X-Gm-Message-State: AOAM531Bt/F+CWRjBHtuEUctWp8D1PVRTATTF9HIsdadNBvoLQjn7VBQ
        6Wr/8oiV4nBhfmrAksie8NY=
X-Google-Smtp-Source: ABdhPJzCPgcLfZIwrcOoXGSBeD4y3/Z71zS1IkrYquJXtQKLyI6OYdBSZBf+q0xGuqvIXZt5HVbqSg==
X-Received: by 2002:a17:902:d905:b029:e4:64d6:bdb0 with SMTP id c5-20020a170902d905b02900e464d6bdb0mr4463710plz.7.1616491005940;
        Tue, 23 Mar 2021 02:16:45 -0700 (PDT)
Received: from localhost ([1.132.172.235])
        by smtp.gmail.com with ESMTPSA id m21sm16419343pff.61.2021.03.23.02.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 02:16:45 -0700 (PDT)
Date:   Tue, 23 Mar 2021 19:16:38 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 22/46] KVM: PPC: Book3S HV P9: Stop handling hcalls in
 real-mode in the P9 path
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210323010305.1045293-1-npiggin@gmail.com>
        <20210323010305.1045293-23-npiggin@gmail.com>
        <6901d698-f3d8-024b-3aa1-47b157bbd57d@ozlabs.ru>
In-Reply-To: <6901d698-f3d8-024b-3aa1-47b157bbd57d@ozlabs.ru>
MIME-Version: 1.0
Message-Id: <1616490842.v369xyk7do.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Alexey Kardashevskiy's message of March 23, 2021 7:02 pm:
>=20
>=20
> On 23/03/2021 12:02, Nicholas Piggin wrote:
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
>>=20
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>>   arch/powerpc/include/asm/kvm_ppc.h      |  5 ++
>>   arch/powerpc/kvm/book3s_hv.c            | 57 ++++++++++++++++----
>>   arch/powerpc/kvm/book3s_hv_rmhandlers.S |  5 ++
>>   arch/powerpc/kvm/book3s_xive.c          | 70 +++++++++++++++++++++++++
>>   4 files changed, 127 insertions(+), 10 deletions(-)
>>=20
>> diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/a=
sm/kvm_ppc.h
>> index 73b1ca5a6471..db6646c2ade2 100644
>> --- a/arch/powerpc/include/asm/kvm_ppc.h
>> +++ b/arch/powerpc/include/asm/kvm_ppc.h
>> @@ -607,6 +607,7 @@ extern void kvmppc_free_pimap(struct kvm *kvm);
>>   extern int kvmppc_xics_rm_complete(struct kvm_vcpu *vcpu, u32 hcall);
>>   extern void kvmppc_xics_free_icp(struct kvm_vcpu *vcpu);
>>   extern int kvmppc_xics_hcall(struct kvm_vcpu *vcpu, u32 cmd);
>> +extern int kvmppc_xive_xics_hcall(struct kvm_vcpu *vcpu, u32 req);
>>   extern u64 kvmppc_xics_get_icp(struct kvm_vcpu *vcpu);
>>   extern int kvmppc_xics_set_icp(struct kvm_vcpu *vcpu, u64 icpval);
>>   extern int kvmppc_xics_connect_vcpu(struct kvm_device *dev,
>> @@ -639,6 +640,8 @@ static inline int kvmppc_xics_enabled(struct kvm_vcp=
u *vcpu)
>>   static inline void kvmppc_xics_free_icp(struct kvm_vcpu *vcpu) { }
>>   static inline int kvmppc_xics_hcall(struct kvm_vcpu *vcpu, u32 cmd)
>>   	{ return 0; }
>> +static inline int kvmppc_xive_xics_hcall(struct kvm_vcpu *vcpu, u32 req=
)
>> +	{ return 0; }
>>   #endif
>>  =20
>>   #ifdef CONFIG_KVM_XIVE
>> @@ -673,6 +676,7 @@ extern int kvmppc_xive_set_irq(struct kvm *kvm, int =
irq_source_id, u32 irq,
>>   			       int level, bool line_status);
>>   extern void kvmppc_xive_push_vcpu(struct kvm_vcpu *vcpu);
>>   extern void kvmppc_xive_pull_vcpu(struct kvm_vcpu *vcpu);
>> +extern void kvmppc_xive_cede_vcpu(struct kvm_vcpu *vcpu);
>>  =20
>>   static inline int kvmppc_xive_enabled(struct kvm_vcpu *vcpu)
>>   {
>> @@ -714,6 +718,7 @@ static inline int kvmppc_xive_set_irq(struct kvm *kv=
m, int irq_source_id, u32 ir
>>   				      int level, bool line_status) { return -ENODEV; }
>>   static inline void kvmppc_xive_push_vcpu(struct kvm_vcpu *vcpu) { }
>>   static inline void kvmppc_xive_pull_vcpu(struct kvm_vcpu *vcpu) { }
>> +static inline void kvmppc_xive_cede_vcpu(struct kvm_vcpu *vcpu) { }
>>  =20
>>   static inline int kvmppc_xive_enabled(struct kvm_vcpu *vcpu)
>>   	{ return 0; }
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index fa7614c37e08..17739aaee3d8 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -1142,12 +1142,13 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcp=
u)
>>   }
>>  =20
>>   /*
>> - * Handle H_CEDE in the nested virtualization case where we haven't
>> - * called the real-mode hcall handlers in book3s_hv_rmhandlers.S.
>> + * Handle H_CEDE in the P9 path where we don't call the real-mode hcall
>> + * handlers in book3s_hv_rmhandlers.S.
>> + *
>>    * This has to be done early, not in kvmppc_pseries_do_hcall(), so
>>    * that the cede logic in kvmppc_run_single_vcpu() works properly.
>>    */
>> -static void kvmppc_nested_cede(struct kvm_vcpu *vcpu)
>> +static void kvmppc_cede(struct kvm_vcpu *vcpu)
>>   {
>>   	vcpu->arch.shregs.msr |=3D MSR_EE;
>>   	vcpu->arch.ceded =3D 1;
>> @@ -1403,9 +1404,15 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu =
*vcpu,
>>   		/* hcall - punt to userspace */
>>   		int i;
>>  =20
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
>>  =20
>>   		run->papr_hcall.nr =3D kvmppc_get_gpr(vcpu, 3);
>>   		for (i =3D 0; i < 9; ++i)
>> @@ -3663,6 +3670,12 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_v=
cpu *vcpu, u64 time_limit,
>>   	return trap;
>>   }
>>  =20
>> +static inline bool hcall_is_xics(unsigned long req)
>> +{
>> +	return (req =3D=3D H_EOI || req =3D=3D H_CPPR || req =3D=3D H_IPI ||
>> +		req =3D=3D H_IPOLL || req =3D=3D H_XIRR || req =3D=3D H_XIRR_X);
>=20
> Do not need braces :)
>=20
>=20
>> +}
>> +
>>   /*
>>    * Virtual-mode guest entry for POWER9 and later when the host and
>>    * guest are both using the radix MMU.  The LPIDR has already been set=
.
>> @@ -3774,15 +3787,36 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu =
*vcpu, u64 time_limit,
>>   		/* H_CEDE has to be handled now, not later */
>>   		if (trap =3D=3D BOOK3S_INTERRUPT_SYSCALL && !vcpu->arch.nested &&
>>   		    kvmppc_get_gpr(vcpu, 3) =3D=3D H_CEDE) {
>> -			kvmppc_nested_cede(vcpu);
>> +			kvmppc_cede(vcpu);
>>   			kvmppc_set_gpr(vcpu, 3, 0);
>>   			trap =3D 0;
>>   		}
>>   	} else {
>>   		kvmppc_xive_push_vcpu(vcpu);
>>   		trap =3D kvmhv_load_hv_regs_and_go(vcpu, time_limit, lpcr);
>> +		if (trap =3D=3D BOOK3S_INTERRUPT_SYSCALL && !vcpu->arch.nested &&
>> +		    !(vcpu->arch.shregs.msr & MSR_PR)) {
>> +			unsigned long req =3D kvmppc_get_gpr(vcpu, 3);
>> +
>> +			/* H_CEDE has to be handled now, not later */
>> +			if (req =3D=3D H_CEDE) {
>> +				kvmppc_cede(vcpu);
>> +				kvmppc_xive_cede_vcpu(vcpu); /* may un-cede */
>> +				kvmppc_set_gpr(vcpu, 3, 0);
>> +				trap =3D 0;
>> +
>> +			/* XICS hcalls must be handled before xive is pulled */
>> +			} else if (hcall_is_xics(req)) {
>> +				int ret;
>> +
>> +				ret =3D kvmppc_xive_xics_hcall(vcpu, req);
>> +				if (ret !=3D H_TOO_HARD) {
>> +					kvmppc_set_gpr(vcpu, 3, ret);
>> +					trap =3D 0;
>> +				}
>> +			}
>> +		}
>>   		kvmppc_xive_pull_vcpu(vcpu);
>> -
>>   	}
>>  =20
>>   	vcpu->arch.slb_max =3D 0;
>> @@ -4442,8 +4476,11 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vc=
pu)
>>   		else
>>   			r =3D kvmppc_run_vcpu(vcpu);
>>  =20
>> -		if (run->exit_reason =3D=3D KVM_EXIT_PAPR_HCALL &&
>> -		    !(vcpu->arch.shregs.msr & MSR_PR)) {
>> +		if (run->exit_reason =3D=3D KVM_EXIT_PAPR_HCALL) {
>> +			if (WARN_ON_ONCE(vcpu->arch.shregs.msr & MSR_PR)) {
>> +				r =3D RESUME_GUEST;
>> +				continue;
>> +			}
>>   			trace_kvm_hcall_enter(vcpu);
>>   			r =3D kvmppc_pseries_do_hcall(vcpu);
>>   			trace_kvm_hcall_exit(vcpu, r);
>> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/=
book3s_hv_rmhandlers.S
>> index c11597f815e4..2d0d14ed1d92 100644
>> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>> @@ -1397,9 +1397,14 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
>>   	mr	r4,r9
>>   	bge	fast_guest_return
>>   2:
>> +	/* If we came in through the P9 short path, no real mode hcalls */
>> +	lwz	r0, STACK_SLOT_SHORT_PATH(r1)
>> +	cmpwi	r0, 0
>> +	bne	no_try_real
>=20
>=20
> btw is mmu on at this point? or it gets enabled by rfid at the end of=20
> guest_exit_short_path?

Hash guest it's off. Radix guest it can be on or off depending on the
interrupt type and MSR and LPCR[AIL] values.

Thanks,
Nick

