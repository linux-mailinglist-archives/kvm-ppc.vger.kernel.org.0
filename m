Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6988D355482
	for <lists+kvm-ppc@lfdr.de>; Tue,  6 Apr 2021 15:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344318AbhDFNCy (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 6 Apr 2021 09:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbhDFNCy (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 6 Apr 2021 09:02:54 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD988C06174A
        for <kvm-ppc@vger.kernel.org>; Tue,  6 Apr 2021 06:02:46 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id v10so10366085pfn.5
        for <kvm-ppc@vger.kernel.org>; Tue, 06 Apr 2021 06:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=M9XWbSlqZBle5z6Rn68Dc9W+emscH1TqVCAuWTrNVxs=;
        b=H5SZwL0LBZzUNCWbZzMG5TQb2+5ORC/1DeNLYVbU8tG6VMzAUPhcvFHToMhA3qQC/7
         8M5KzbC1imidLCjh2NgBxCQvjkFuX0+IWJorOLFqlYjoE+abAAYZtqMNy/KhdwLc4Drw
         SoCEq1ZOSmq9irNILSzO1In+DbtzQkd5TGh1yr3Yz85ktJd5dfnzrwtWKiRBrftxyH7m
         uVkp+l8YBW2qYqm861upx3wHdrPqksH1aHgJQX8N9w4BYzjrbkENgiiRb5hBjHX7Srng
         iC0D44TVQnmXsBwetYL4o19GrY1MZYBBCRMK+AyxGWi5Te6gUJwPZn785jyeJLpHVN2Z
         3c7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=M9XWbSlqZBle5z6Rn68Dc9W+emscH1TqVCAuWTrNVxs=;
        b=rfbkhuRT9ZXy6Cc/gPLfD3rSMD7Vp8t4P1yygQED13ZmsSd4k9vnc35m06Ep7ANhW5
         XjTeAKE45btTtAZd7bjRul/iGai7IBjPoJWeuwnjlTOp1/b5LfTBCnzKqmL9VV3exv0W
         DlBd9sthLukIOBO+jGuHH+TUmh7YEcHjZAxU9ywL+AI4F/LUfFs5/UXhUjXLNROZ2F6Y
         wTmEweQ1Z48kDNIx211zSwSaUoexNDIC3U27Z2adBp2b9vFzCT5fgePpYeI1fH8ecD6M
         1ANNtElyuQdUu3AuIBVKliiupHW65XMXjoiJOTxg3GPOmQ9VsG7xrUS9rWZset1JndLn
         1fbQ==
X-Gm-Message-State: AOAM532OUBq5+GSaeCPkKKPNZ9emGmT4lyBXLst86+I8Nri5lhO6jjCs
        Nvnmt4vxnk1yiIJV3LpRjCqRHGCd6Lkk6g==
X-Google-Smtp-Source: ABdhPJykH7D2WzRN1jNoNyfTfuPtBCCWTZuwKt12Q5XiA9U5ToJQ/4b0+HZ7uhCr1iANjgtj2s0dMQ==
X-Received: by 2002:a62:347:0:b029:23f:7001:c0e6 with SMTP id 68-20020a6203470000b029023f7001c0e6mr2663882pfd.75.1617714166048;
        Tue, 06 Apr 2021 06:02:46 -0700 (PDT)
Received: from localhost ([1.132.179.35])
        by smtp.gmail.com with ESMTPSA id l10sm17891125pfc.125.2021.04.06.06.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 06:02:45 -0700 (PDT)
Date:   Tue, 06 Apr 2021 23:02:39 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v6 30/48] KVM: PPC: Book3S HV P9: Implement the rest of
 the P9 path in C
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20210405011948.675354-1-npiggin@gmail.com>
        <20210405011948.675354-31-npiggin@gmail.com>
        <YGwNRUahuv42VZPR@thinks.paulus.ozlabs.org>
        <1617699912.sfw989xp02.astroid@bobo.none>
In-Reply-To: <1617699912.sfw989xp02.astroid@bobo.none>
MIME-Version: 1.0
Message-Id: <1617713818.l4464kzxzg.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Nicholas Piggin's message of April 6, 2021 7:12 pm:
> Excerpts from Paul Mackerras's message of April 6, 2021 5:27 pm:
>> On Mon, Apr 05, 2021 at 11:19:30AM +1000, Nicholas Piggin wrote:
>>> Almost all logic is moved to C, by introducing a new in_guest mode for
>>> the P9 path that branches very early in the KVM interrupt handler to
>>> P9 exit code.
>>>=20
>>> The main P9 entry and exit assembly is now only about 160 lines of low
>>> level stack setup and register save/restore, plus a bad-interrupt
>>> handler.
>>>=20
>>> There are two motivations for this, the first is just make the code mor=
e
>>> maintainable being in C. The second is to reduce the amount of code
>>> running in a special KVM mode, "realmode". In quotes because with radix
>>> it is no longer necessarily real-mode in the MMU, but it still has to b=
e
>>> treated specially because it may be in real-mode, and has various
>>> important registers like PID, DEC, TB, etc set to guest. This is hostil=
e
>>> to the rest of Linux and can't use arbitrary kernel functionality or be
>>> instrumented well.
>>>=20
>>> This initial patch is a reasonably faithful conversion of the asm code,
>>> but it does lack any loop to return quickly back into the guest without
>>> switching out of realmode in the case of unimportant or easily handled
>>> interrupts. As explained in previous changes, handling HV interrupts
>>> in real mode is not so important for P9.
>>>=20
>>> Use of Linux 64s interrupt entry code register conventions including
>>> paca EX_ save areas are brought into the KVM code. There is no point
>>> shuffling things into different paca save areas and making up a
>>> different calling convention for KVM.
>>>=20
>>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>>=20
>> [snip]
>>=20
>>> +/*
>>> + * Took an interrupt somewhere right before HRFID to guest, so registe=
rs are
>>> + * in a bad way. Return things hopefully enough to run host virtual co=
de and
>>> + * run the Linux interrupt handler (SRESET or MCE) to print something =
useful.
>>> + *
>>> + * We could be really clever and save all host registers in known loca=
tions
>>> + * before setting HSTATE_IN_GUEST, then restoring them all here, and s=
etting
>>> + * return address to a fixup that sets them up again. But that's a lot=
 of
>>> + * effort for a small bit of code. Lots of other things to do first.
>>> + */
>>> +kvmppc_p9_bad_interrupt:
>>> +	/*
>>> +	 * Set GUEST_MODE_NONE so the handler won't branch to KVM, and clear
>>> +	 * MSR_RI in r12 ([H]SRR1) so the handler won't try to return.
>>> +	 */
>>> +	li	r10,KVM_GUEST_MODE_NONE
>>> +	stb	r10,HSTATE_IN_GUEST(r13)
>>> +	li	r10,MSR_RI
>>> +	andc	r12,r12,r10
>>> +
>>> +	/*
>>> +	 * Clean up guest registers to give host a chance to run.
>>> +	 */
>>> +	li	r10,0
>>> +	mtspr	SPRN_AMR,r10
>>> +	mtspr	SPRN_IAMR,r10
>>> +	mtspr	SPRN_CIABR,r10
>>> +	mtspr	SPRN_DAWRX0,r10
>>> +BEGIN_FTR_SECTION
>>> +	mtspr	SPRN_DAWRX1,r10
>>> +END_FTR_SECTION_IFSET(CPU_FTR_DAWR1)
>>> +	mtspr	SPRN_PID,r10
>>> +
>>> +	/*
>>> +	 * Switch to host MMU mode
>>> +	 */
>>> +	ld	r10, HSTATE_KVM_VCPU(r13)
>>> +	ld	r10, VCPU_KVM(r10)
>>> +	lwz	r10, KVM_HOST_LPID(r10)
>>> +	mtspr	SPRN_LPID,r10
>>> +
>>> +	ld	r10, HSTATE_KVM_VCPU(r13)
>>> +	ld	r10, VCPU_KVM(r10)
>>> +	ld	r10, KVM_HOST_LPCR(r10)
>>> +	mtspr	SPRN_LPCR,r10
>>> +
>>> +	/*
>>> +	 * Go back to interrupt handler
>>> +	 */
>>> +	ld	r10,HSTATE_SCRATCH0(r13)
>>> +	cmpwi	r10,BOOK3S_INTERRUPT_MACHINE_CHECK
>>> +	beq	machine_check_common
>>> +
>>> +	ld	r10,HSTATE_SCRATCH0(r13)
>>> +	cmpwi	r10,BOOK3S_INTERRUPT_SYSTEM_RESET
>>> +	beq	system_reset_common
>>> +
>>> +	b	.
>>=20
>> So you only handle machine check and system reset here?  I would think
>> that program check would also be useful, for the cases where people
>> put BUG_ON in sensitive places (see below).  DSI and ISI could also be
>> useful for the null pointer dereference cases, I would think.
>=20
> Those ones have their own stack, so a bit simpler to run them (and
> they obviously have to be handled as they are NMIs). I'll see if we
> can do something to improve the others a bit. Maybe just call program
> check for any other exception might work, making sure that it'll use
> the emergency stack rather than something that looks like a kernel
> stack but is a guest value, I'll see what we can get to work.

So program check isn't tested in virt mode, and neither are ISI or
DSI unless PR is possible, so the bad host interrupt check in
rmhandlers doesn't really catch those cases either.

We may want to improve on that but I might wait until after this
series.

I did get rid of the BUG_ON though.

Thanks,
Nick

>>> +static inline void mtslb(unsigned int idx, u64 slbee, u64 slbev)
>>> +{
>>> +	BUG_ON((slbee & 0xfff) !=3D idx);
>>> +
>>> +	asm volatile("slbmte %0,%1" :: "r" (slbev), "r" (slbee));
>>> +}
>>=20
>> Using BUG_ON here feels dangerous, and the condition it is testing is
>> certainly not one where the host kernel is in such trouble that it
>> can't continue to run.  If the index was wrong then at worst the guest
>> kernel would be in trouble.  So I don't believe BUG_ON is appropriate.
>=20
> Yeah good point, some of it was a bit of development paranoia but I=20
> do have to go through and tighten these up.
>=20
>>> +
>>> +/*
>>> + * Malicious or buggy radix guests may have inserted SLB entries
>>> + * (only 0..3 because radix always runs with UPRT=3D1), so these must
>>> + * be cleared here to avoid side-channels. slbmte is used rather
>>> + * than slbia, as it won't clear cached translations.
>>> + */
>>> +static void radix_clear_slb(void)
>>> +{
>>> +	u64 slbee, slbev;
>>> +	int i;
>>> +
>>> +	for (i =3D 0; i < 4; i++) {
>>> +		mfslb(i, &slbee, &slbev);
>>> +		if (unlikely(slbee || slbev)) {
>>> +			slbee =3D i;
>>> +			slbev =3D 0;
>>> +			mtslb(i, slbee, slbev);
>>> +		}
>>> +	}
>>=20
>> Are four slbmfee + slbmfev really faster than four slbmte?
>=20
> I'd thought yes if they behaved similarly to mfspr, but from the look of=20
> some workbooks it doesn't look like it's quite that simple.
>=20
> I'll have to measure it.
>=20
> Thanks,
> Nick
>=20
