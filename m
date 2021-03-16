Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EE133CC3C
	for <lists+kvm-ppc@lfdr.de>; Tue, 16 Mar 2021 04:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbhCPDnu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 15 Mar 2021 23:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234954AbhCPDnr (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 15 Mar 2021 23:43:47 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1CDC06174A
        for <kvm-ppc@vger.kernel.org>; Mon, 15 Mar 2021 20:43:47 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id c17so4318292pfv.12
        for <kvm-ppc@vger.kernel.org>; Mon, 15 Mar 2021 20:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=pJMqp9EIEi0XFu4H8gDRGASddQ1NcQquoIf0sgZVsck=;
        b=FC8kxpQzZWPyMIpBVv8QnX/o1Xp4rND8Y1f9I595cBz7iAwWgSNXDLqgeAZ/k80prG
         pi0QOsB4MUrDO/hSpBEuS7SxDnDVZ8ZS4FJvZSiOgqwRb8j54wfJzAdtn7uaoFnWQdTp
         Kn1VB2EdzvjeIpmWR2CmOszvq0+LltoHdyzZInRpDVFkJsJSbrDeuTorL1ZCb7fjtFNj
         oY3a7Isx0YfbJ3ms2QTM8FiLDYrV1y81BiuITAudtNQyUFBryb1lUGqz7lG+ilOWF1zd
         CFfn8VXYPbBvkOSyGoZpeSDA74+Fr2NkmLqgZHMBn8pjWqnLM/G9Yp4eeTDyCrWaXhlD
         MEfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=pJMqp9EIEi0XFu4H8gDRGASddQ1NcQquoIf0sgZVsck=;
        b=PDC8Zh1MeAozBnBsNz+eN5E91nU1jXsLkcagkC5hevJiItquafcKWx+t4yU7nFrb1M
         ut1RiDpLQ5yAIoQItCZzqUCXhu0Cgn4FExAqVsPQJAsIJU7TZwFPhpOA6pK1D+9iWXDK
         FNEp7NBgmqKVoH0DW54FAb2P+QlnnBJHE/pRlSzvO9gFWNaOWTtUYIgQsWiFcTqJVShR
         uhQsyDqKliOhBWwoUY2hyINQ1zk1TrBNRKhZ4Aop98dNYNJCJcIG7h1ulFtkfVNvhn0u
         hn66tHMc2xfRAl0Zps+vWnzWyfBlpF5YwHTBhPb4+X1dZlOrxrsmqVa/8MA7weL+lr2M
         a2eQ==
X-Gm-Message-State: AOAM533ZjtYap7Eg/JMdlmjpTg4EfCh5D2ReFoBVUkkB97gLLCPJNm2b
        L5EI8UBYB2BeYLbXJQrRCjOaUBNA55M=
X-Google-Smtp-Source: ABdhPJzqCoph7XnqsP4+hZ0QROL33qbqzR7fZiP3cJwDwx7BBugSNkKKNM1hdDQ7XFCb4uIhqQ81hQ==
X-Received: by 2002:a62:8ccc:0:b029:1f6:c5e2:69ff with SMTP id m195-20020a628ccc0000b02901f6c5e269ffmr13293916pfd.46.1615866226554;
        Mon, 15 Mar 2021 20:43:46 -0700 (PDT)
Received: from localhost (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id d20sm1003991pjv.47.2021.03.15.20.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 20:43:45 -0700 (PDT)
Date:   Tue, 16 Mar 2021 13:43:40 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 12/41] KVM: PPC: Book3S 64: Move hcall early register
 setup to KVM
To:     Daniel Axtens <dja@axtens.net>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210305150638.2675513-1-npiggin@gmail.com>
        <20210305150638.2675513-13-npiggin@gmail.com>
        <87czw57wn8.fsf@linkitivity.dja.id.au>
In-Reply-To: <87czw57wn8.fsf@linkitivity.dja.id.au>
MIME-Version: 1.0
Message-Id: <1615862463.zij1m644om.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Daniel Axtens's message of March 12, 2021 3:45 pm:
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
>> System calls / hcalls have a different calling convention than
>> other interrupts, so there is code in the KVMTEST to massage these
>> into the same form as other interrupt handlers.
>>
>> Move this work into the KVM hcall handler. This means teaching KVM
>> a little more about the low level interrupt handler setup, PACA save
>> areas, etc., although that's not obviously worse than the current
>> approach of coming up with an entirely different interrupt register
>> / save convention.
>>
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>>  arch/powerpc/include/asm/exception-64s.h | 13 ++++++++
>>  arch/powerpc/kernel/exceptions-64s.S     | 42 +-----------------------
>>  arch/powerpc/kvm/book3s_64_entry.S       | 17 ++++++++++
>>  3 files changed, 31 insertions(+), 41 deletions(-)
>>
>> diff --git a/arch/powerpc/include/asm/exception-64s.h b/arch/powerpc/inc=
lude/asm/exception-64s.h
>> index c1a8aac01cf9..bb6f78fcf981 100644
>> --- a/arch/powerpc/include/asm/exception-64s.h
>> +++ b/arch/powerpc/include/asm/exception-64s.h
>> @@ -35,6 +35,19 @@
>>  /* PACA save area size in u64 units (exgen, exmc, etc) */
>>  #define EX_SIZE		10
>> =20
>> +/* PACA save area offsets */
>> +#define EX_R9		0
>> +#define EX_R10		8
>> +#define EX_R11		16
>> +#define EX_R12		24
>> +#define EX_R13		32
>> +#define EX_DAR		40
>> +#define EX_DSISR	48
>> +#define EX_CCR		52
>> +#define EX_CFAR		56
>> +#define EX_PPR		64
>> +#define EX_CTR		72
>> +
>>  /*
>>   * maximum recursive depth of MCE exceptions
>>   */
>> diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/=
exceptions-64s.S
>> index 292435bd80f0..b7092ba87da8 100644
>> --- a/arch/powerpc/kernel/exceptions-64s.S
>> +++ b/arch/powerpc/kernel/exceptions-64s.S
>> @@ -21,22 +21,6 @@
>>  #include <asm/feature-fixups.h>
>>  #include <asm/kup.h>
>> =20
>> -/* PACA save area offsets (exgen, exmc, etc) */
>> -#define EX_R9		0
>> -#define EX_R10		8
>> -#define EX_R11		16
>> -#define EX_R12		24
>> -#define EX_R13		32
>> -#define EX_DAR		40
>> -#define EX_DSISR	48
>> -#define EX_CCR		52
>> -#define EX_CFAR		56
>> -#define EX_PPR		64
>> -#define EX_CTR		72
>> -.if EX_SIZE !=3D 10
>> -	.error "EX_SIZE is wrong"
>> -.endif
>> -
>>  /*
>>   * Following are fixed section helper macros.
>>   *
>> @@ -1964,29 +1948,8 @@ EXC_VIRT_END(system_call, 0x4c00, 0x100)
>> =20
>>  #ifdef CONFIG_KVM_BOOK3S_64_HANDLER
>>  TRAMP_REAL_BEGIN(system_call_kvm)
>> -	/*
>> -	 * This is a hcall, so register convention is as above, with these
>> -	 * differences:
>> -	 * r13 =3D PACA
>> -	 * ctr =3D orig r13
>> -	 * orig r10 saved in PACA
>> -	 */
>> -	 /*
>> -	  * Save the PPR (on systems that support it) before changing to
>> -	  * HMT_MEDIUM. That allows the KVM code to save that value into the
>> -	  * guest state (it is the guest's PPR value).
>> -	  */
>> -BEGIN_FTR_SECTION
>> -	mfspr	r10,SPRN_PPR
>> -	std	r10,HSTATE_PPR(r13)
>> -END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
>> -	HMT_MEDIUM
>>  	mfctr	r10
>> -	SET_SCRATCH0(r10)
>> -	mfcr	r10
>> -	std	r12,HSTATE_SCRATCH0(r13)
>> -	sldi	r12,r10,32
>> -	ori	r12,r12,0xc00
>> +	SET_SCRATCH0(r10) /* Save r13 in SCRATCH0 */
>=20
> If I've understood correctly, you've saved the _original_/guest r13 in
> SCRATCH0. That makes sense - it just took me a while to follow the
> logic, especially because the parameter to SET_SCRATCH0 is r10, not r13.
>=20
> I would probably expand the comment to say the original or guest r13 (as
> you do in the comment at the start of kvmppc_hcall), but if there's a
> convention here that I've missed that might not be necessary.

There is a convention which is that all kvm interrupts including system
call come in with r13 saved in SCRATCH0, although that's all in a state
of flux throughput this series of course.

I added the comment because I moved the bigger comment here, I think=20
that's okay because you're always referring to interrupted context=20
(i.e., guest in this case) when talking about saved registers.

>=20
>>  #ifdef CONFIG_RELOCATABLE
>>  	/*
>>  	 * Requires __LOAD_FAR_HANDLER beause kvmppc_hcall lives
>> @@ -1994,15 +1957,12 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
>>  	 */
>>  	__LOAD_FAR_HANDLER(r10, kvmppc_hcall)
>>  	mtctr   r10
>> -	ld	r10,PACA_EXGEN+EX_R10(r13)
>>  	bctr
>>  #else
>> -	ld	r10,PACA_EXGEN+EX_R10(r13)
>>  	b       kvmppc_hcall
>>  #endif
>>  #endif
>> =20
>> -
>>  /**
>>   * Interrupt 0xd00 - Trace Interrupt.
>>   * This is a synchronous interrupt in response to instruction step or
>> diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3=
s_64_entry.S
>> index 8cf5e24a81eb..a7b6edd18bc8 100644
>> --- a/arch/powerpc/kvm/book3s_64_entry.S
>> +++ b/arch/powerpc/kvm/book3s_64_entry.S
>> @@ -14,6 +14,23 @@
>>  .global	kvmppc_hcall
>>  .balign IFETCH_ALIGN_BYTES
>>  kvmppc_hcall:
>> +	/*
>> +	 * This is a hcall, so register convention is as
>> +	 * Documentation/powerpc/papr_hcalls.rst, with these additions:
>> +	 * R13		=3D PACA
>> +	 * guest R13 saved in SPRN_SCRATCH0
>> +	 * R10		=3D free
>> +	 */
>> +BEGIN_FTR_SECTION
>> +	mfspr	r10,SPRN_PPR
>> +	std	r10,HSTATE_PPR(r13)
>> +END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
>=20
> Do we want to preserve the comment about why we save the PPR?

Wouldn't hurt. I think the reason the comment is there is because it's a=20
difference with system calls. Hcalls preserve the PPR, system calls do not.

Should probably leave the "orig r10 saved in the PACA" comment too.

>=20
>> +	HMT_MEDIUM
>> +	mfcr	r10
>> +	std	r12,HSTATE_SCRATCH0(r13)
>> +	sldi	r12,r10,32
>> +	ori	r12,r12,0xc00
>=20
> I see that this is a direct copy from the earlier code, but it confuses
> me a bit. Looking at exceptions-64s.S, there's the following comment:
>=20
>  * In HPT, sc 1 always goes to 0xc00 real mode. In RADIX, sc 1 can go to
>  * 0x4c00 virtual mode.
>=20
> However, this code uncondionally sets the low bits to be c00, even if
> the exception came in via 4c00. Is this right? Do we need to pass
> that through somehow?

We don't need to. The "trap" numbers are always the real-mode vectors
(except scv which is a bit weird) by convention.

>=20
>> +	ld	r10,PACA_EXGEN+EX_R10(r13)
>>
>=20
> Otherwise, this looks good to me so far.

Thanks,
Nick
