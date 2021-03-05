Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5A132E1E6
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 06:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbhCEFyM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 00:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhCEFyM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 00:54:12 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B32C061574
        for <kvm-ppc@vger.kernel.org>; Thu,  4 Mar 2021 21:54:12 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id t25so623882pga.2
        for <kvm-ppc@vger.kernel.org>; Thu, 04 Mar 2021 21:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=JqUWCFyVuv0H2Wh1BTSETwqA0oM5AW2lC5rIk29qh1I=;
        b=bS/oHgGIBkdHm6OegfLS7TFqld9dU5de2E+0ipeJ5c2DZJwTCXhv/sFEchETupGEwx
         hoYdm/2aWKpups3NTFDHU9b/DwCMkFHppV34jjZSnukXUNsneXqxdGlwt8v2DM9q3P5j
         C/GhlR9i0bLOnOAWBBb2PKGeA9rwpGoA+/6Ys=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=JqUWCFyVuv0H2Wh1BTSETwqA0oM5AW2lC5rIk29qh1I=;
        b=UNAfOzuRnfaojXETzTOCXNQaBzXaloXE+bUlL5Z0pOIk3sSx2z7Xyyp4lBZqpXj+AG
         mpGan3n7ereiAFYX4VYfORj4x0ffcf3uHFzFwolBicLFpPOdm1wQguefaB25bL0iAkf6
         jUoGi1AOqNn8pF1yzjyU2Hz3SJZ1pqBUG3R2nungrIXhOZpXkDCe90GEkz5ptv/vnJ1P
         +QIT28PTz7yvItqucJgjgn7Dvtx6GlDM9WRKhoDdarKkddd6iA6bl31Pq3v7YZ8+xs9E
         fiHoGH2J3XzWfzWFwE8XjPEivIzs6mN2zOcgJHSjFGS5zejfC4V9Bg0nzihmHhcJXEC7
         eCnQ==
X-Gm-Message-State: AOAM530pqI6t+SebHe8tQN8hqTTOhOC05YWyfSMarc8H2gt+7IdkY0OH
        53l+7+0harZ/B59NtyLwLDm1Qfk3GVe10Rz8
X-Google-Smtp-Source: ABdhPJyDGpsAz2tWTfFnOll45AyL/0CTz1s+BVgn7s9QJrjRSPCA4m2s2JubFx5gysYvABv9uM+tDQ==
X-Received: by 2002:a63:cc05:: with SMTP id x5mr6778459pgf.254.1614923651586;
        Thu, 04 Mar 2021 21:54:11 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-7ad2-5bb3-4fd4-d737.static.ipv6.internode.on.net. [2001:44b8:1113:6700:7ad2:5bb3:4fd4:d737])
        by smtp.gmail.com with ESMTPSA id n184sm1192954pfd.205.2021.03.04.21.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 21:54:11 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: Re: [PATCH v2 07/37] KVM: PPC: Book3S 64: Move GUEST_MODE_SKIP test into KVM
In-Reply-To: <20210225134652.2127648-8-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com> <20210225134652.2127648-8-npiggin@gmail.com>
Date:   Fri, 05 Mar 2021 16:54:08 +1100
Message-ID: <87o8fy87sv.fsf@linkitivity.dja.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Nick,

> -	.if IKVM_SKIP
> -89:	mtocrf	0x80,r9
> -	ld	r10,IAREA+EX_CTR(r13)
> -	mtctr	r10
> -	ld	r9,IAREA+EX_R9(r13)
> -	ld	r10,IAREA+EX_R10(r13)
> -	ld	r11,IAREA+EX_R11(r13)
> -	ld	r12,IAREA+EX_R12(r13)
> -	.if IHSRR_IF_HVMODE
> -	BEGIN_FTR_SECTION
> -	b	kvmppc_skip_Hinterrupt
> -	FTR_SECTION_ELSE
> -	b	kvmppc_skip_interrupt
> -	ALT_FTR_SECTION_END_IFSET(CPU_FTR_HVMODE | CPU_FTR_ARCH_206)

I was initially concerned that you were pulling out the complexities
around IHSRR_IF_HVMODE, but I checked exceptions-64s.S and the only
exception handler that sets IHSRR_IF_HVMODE is hardware_interrupt and
that does not set IKVM_SKIP, so we are indeed fine to not keep this
complex little asm section.

> -	.elseif IHSRR
> -	b	kvmppc_skip_Hinterrupt
> -	.else
> -	b	kvmppc_skip_interrupt
> -	.endif
> -	.endif
>  .endm

> +/*
> + * KVM uses a trick where it is running in MSR[HV]=1 mode in real-mode with the
> + * guest MMU context loaded, and it sets KVM_GUEST_MODE_SKIP and enables
> + * MSR[DR]=1 while leaving MSR[IR]=0, so it continues to fetch HV instructions
> + * but loads and stores will access the guest context. This is used to load
> + * the faulting instruction without walking page tables.
> + *
> + * However the guest context may not be able to translate, or it may cause a
> + * machine check or other issue, which will result in a fault in the host
> + * (even with KVM-HV).
> + *
> + * These faults are caught here and if the fault was (or was likely) due to
> + * that load, then we just return with the PC advanced +4 and skip the load,
> + * which then goes via the slow path.
> + */

This is a really helpful comment! Thanks!

> +.Lmaybe_skip:
> +	cmpwi	r12,BOOK3S_INTERRUPT_MACHINE_CHECK
> +	beq	1f
> +	cmpwi	r12,BOOK3S_INTERRUPT_DATA_STORAGE
> +	beq	1f
> +	cmpwi	r12,BOOK3S_INTERRUPT_DATA_SEGMENT
> +	beq	1f
> +#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
> +	/* HSRR interrupts have 2 added to trap vector */
> +	cmpwi	r12,BOOK3S_INTERRUPT_H_DATA_STORAGE | 0x2

This took me by surprise for a while, but I checked how it works in
exceptions-64s.S and indeed the GEN_KVM macro will add 0x2 to the IVEC
if IHSRR is set, and it is set for h_data_storage.

So this checks out to me.

I have checked, to the best of my limited assembler capabilities that
the logic before and after matches. It seems good to me.

On that limited basis,
Reviewed-by: Daniel Axtens <dja@axtens.net>

Kind regards,
Daniel


> +	beq	2f
> +#endif
> +	b	.Lno_skip
> +1:	mfspr	r9,SPRN_SRR0
> +	addi	r9,r9,4
> +	mtspr	SPRN_SRR0,r9
> +	ld	r12,HSTATE_SCRATCH0(r13)
> +	ld	r9,HSTATE_SCRATCH2(r13)
> +	GET_SCRATCH0(r13)
> +	RFI_TO_KERNEL
> +#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
> +2:	mfspr	r9,SPRN_HSRR0
> +	addi	r9,r9,4
> +	mtspr	SPRN_HSRR0,r9
> +	ld	r12,HSTATE_SCRATCH0(r13)
> +	ld	r9,HSTATE_SCRATCH2(r13)
> +	GET_SCRATCH0(r13)
> +	HRFI_TO_KERNEL
> +#endif
> -- 
> 2.23.0
