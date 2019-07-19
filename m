Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51A816D90D
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Jul 2019 04:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfGSCZ6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm-ppc@lfdr.de>); Thu, 18 Jul 2019 22:25:58 -0400
Received: from ozlabs.org ([203.11.71.1]:44713 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbfGSCZ6 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 18 Jul 2019 22:25:58 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45qZcM21Yjz9s7T;
        Fri, 19 Jul 2019 12:25:55 +1000 (AEST)
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
        Ryan Grimm <grimm@linux.ibm.com>,
        Ryan Grimm <grimm@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 4/8] KVM: PPC: Ultravisor: Use UV_WRITE_PATE ucall to register a PATE
In-Reply-To: <6688060f-3744-cae5-635e-f1ee3ff48c19@linux.ibm.com>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com> <20190628200825.31049-5-cclaudio@linux.ibm.com> <87ims8g24r.fsf@concordia.ellerman.id.au> <6688060f-3744-cae5-635e-f1ee3ff48c19@linux.ibm.com>
Date:   Fri, 19 Jul 2019 12:25:54 +1000
Message-ID: <87ef2m92vh.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Claudio Carvalho <cclaudio@linux.ibm.com> writes:
> On 7/11/19 9:57 AM, Michael Ellerman wrote:
>>>  static pmd_t *get_pmd_from_cache(struct mm_struct *mm)
>>> diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
>>> index 8904aa1243d8..da6a6b76a040 100644
>>> --- a/arch/powerpc/mm/book3s64/radix_pgtable.c
>>> +++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
>>> @@ -656,8 +656,10 @@ void radix__early_init_mmu_secondary(void)
>>>  		lpcr = mfspr(SPRN_LPCR);
>>>  		mtspr(SPRN_LPCR, lpcr | LPCR_UPRT | LPCR_HR);
>>>  
>>> -		mtspr(SPRN_PTCR,
>>> -		      __pa(partition_tb) | (PATB_SIZE_SHIFT - 12));
>>> +		if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
>>> +			mtspr(SPRN_PTCR, __pa(partition_tb) |
>>> +			      (PATB_SIZE_SHIFT - 12));
>>> +
>>>  		radix_init_amor();
>>>  	}
>>>  
>>> @@ -673,7 +675,8 @@ void radix__mmu_cleanup_all(void)
>>>  	if (!firmware_has_feature(FW_FEATURE_LPAR)) {
>>>  		lpcr = mfspr(SPRN_LPCR);
>>>  		mtspr(SPRN_LPCR, lpcr & ~LPCR_UPRT);
>>> -		mtspr(SPRN_PTCR, 0);
>>> +		if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
>>> +			mtspr(SPRN_PTCR, 0);
>>>  		powernv_set_nmmu_ptcr(0);
>>>  		radix__flush_tlb_all();
>>>  	}
>> There's four of these case where we skip touching the PTCR, which is
>> right on the borderline of warranting an accessor. I guess we can do it
>> as a cleanup later.
>
> I agree.
>
> Since the kernel doesn't need to access a big number of ultravisor
> privileged registers, maybe we can define mtspr_<reg> and mfspr_<reg>
> inline functions that in ultravisor.h that skip touching the register if an
> ultravisor is present and and the register is ultravisor privileged. Thus,
> we don't need to replicate comments and that also would make it easier for
> developers to know what are the ultravisor privileged registers.
>
> Something like this:
>
> --- a/arch/powerpc/include/asm/ultravisor.h
> +++ b/arch/powerpc/include/asm/ultravisor.h
> @@ -10,10 +10,21 @@
>  
>  #include <asm/ultravisor-api.h>
>  #include <asm/asm-prototypes.h>
> +#include <asm/reg.h>
>  
>  int early_init_dt_scan_ultravisor(unsigned long node, const char *uname,
>                                   int depth, void *data);
>  
> +static inline void mtspr_ptcr(unsigned long val)
> +{
> +       /*
> +        * If the ultravisor firmware is present, it maintains the partition
> +        * table. PTCR becomes ultravisor privileged only for writing.
> +        */
> +       if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
> +               mtspr(SPRN_PTCR, val);
> +}
+
>  static inline int uv_register_pate(u64 lpid, u64 dw0, u64 dw1)
>  {
>         return ucall_norets(UV_WRITE_PATE, lpid, dw0, dw1);
> diff --git a/arch/powerpc/mm/book3s64/pgtable.c
> b/arch/powerpc/mm/book3s64/pgtable.c
> index e1bbc48e730f..25156f9dfde8 100644
> --- a/arch/powerpc/mm/book3s64/pgtable.c
> +++ b/arch/powerpc/mm/book3s64/pgtable.c
> @@ -220,7 +220,7 @@ void __init mmu_partition_table_init(void)
>          * 64 K size.
>          */
>         ptcr = __pa(partition_tb) | (PATB_SIZE_SHIFT - 12);
> -       mtspr(SPRN_PTCR, ptcr);
> +       mtspr_ptcr(ptcr);
>         powernv_set_nmmu_ptcr(ptcr);
>  }
>
> What do you think?

I don't think that's actually clearer.

If the logic was always:

  if (ultravisor)
     do_ucall()
  else
     mtspr()

Then a wrapper called eg. set_ptcr() would make sense.

But because in some cases you do a ucall and some you don't, I don't
think it helps to hide that in an accessor like above.

That is confusing to a reader who sees all this code to setup a value
and then the write to PTCR does nothing.

And in fact you didn't explain why it's OK for those cases to not do the
write at all.

> An alternative could be to change the mtspr() and mfspr() macros as we
> proposed in the v1, but access to non-ultravisor privileged registers would
> be performance impacted because we always would need to check if the
> register is one of the few ultravisor registers that the kernel needs to
> access.

Yeah that and it would be very confusing to a reader who sees:

    ptcr = ...;
    mtspr(SPRN_PTCR, ptcr);
    ...

And then they discover the mtspr does *nothing* when the Ultravisor is
enabled.

cheers
