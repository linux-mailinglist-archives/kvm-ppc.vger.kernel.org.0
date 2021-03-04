Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96EB432D18A
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Mar 2021 12:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239328AbhCDLD7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 4 Mar 2021 06:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239432AbhCDLDh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 4 Mar 2021 06:03:37 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF5DC061574
        for <kvm-ppc@vger.kernel.org>; Thu,  4 Mar 2021 03:02:57 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id h4so18642741pgf.13
        for <kvm-ppc@vger.kernel.org>; Thu, 04 Mar 2021 03:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=+gWRxcdUXMQou9ziU1lKLrEon8VwgQT0NWd6SS7G4WA=;
        b=VG/4OHrDaovLA3OwfWlPeMGZwqwJmibuMwD9pS1rOUXRvuUoHHwifAksU4b05zfxTa
         tsjvOXmESHzDbxC9GpjoCmjTkhLU3dwTQgfzRVDCgTkDE+ghjMThKSw73l7cQ5/SbLEt
         IoXUrWyPXtV16vrq4YZAxMXUwL9PsvkGLbYDzngCtHQkXl1CxFZ7g7/CguAWwGxoz+80
         vkvzWHLNSWCn6mrr/epHi2uc9dyMLSPbsHHQIfZIiWhGUnpuHCkRhmyNGQolgCoj/A+h
         u2o9Ec42TjIY+KhUfNhkhlI75Cp8u37JqSx3JYwLSzdu033xWfpoQ6CSRjNsAjAoGjAX
         kFdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=+gWRxcdUXMQou9ziU1lKLrEon8VwgQT0NWd6SS7G4WA=;
        b=SOTqGorwgkNYg4C1zwKnMckgl2v8rziXxqMHOmgPBbod2JzNNFiIVmxeD5viRx0A2E
         kC+GtFFZ0WxhRWn+zmP2j8pkHuR3heMzEUJAANZ9jbU4uQsEAAIiS3DW+hpjKQzEk2DW
         VupBXmKzulash1eq+qWms8wjRP1gGhyNw/kJUjyeJQdpT2z+AO7j5mEANThwv279rgap
         Bb4rV6ijPpAJ4hEw3tld8qWffZINxLVQIqYN3kNWGs5QITeVIPcaybBiiWg8rrC0QCPL
         odF5/Ln15NvTEwrhn2/FHZlopiGWdMnSUX/a5M94SnIRZMOsY+8BL6UKcNvfUaxg9Jrs
         PsrQ==
X-Gm-Message-State: AOAM5307FaX8oJ1adNAgTpH/fBa7Uvxl06oc+Q0cOCKAHC5OAdWDsoT3
        fHxHtUtc2vNMvuaL4yVcfMQ=
X-Google-Smtp-Source: ABdhPJw7HGv6gZKtEV1R5UJu3lP8PDz4gVRtiwaqTD13kyQhdKUKNvA25N45gXzYzF1JzriQeZbPTA==
X-Received: by 2002:a05:6a00:22d1:b029:1b4:9bb5:724c with SMTP id f17-20020a056a0022d1b02901b49bb5724cmr3667161pfj.63.1614855776615;
        Thu, 04 Mar 2021 03:02:56 -0800 (PST)
Received: from localhost (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id n24sm2591073pgl.27.2021.03.04.03.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 03:02:55 -0800 (PST)
Date:   Thu, 04 Mar 2021 21:02:49 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 28/37] KVM: PPC: Book3S HV P9: Add helpers for OS SPR
 handling
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210225134652.2127648-1-npiggin@gmail.com>
        <20210225134652.2127648-29-npiggin@gmail.com> <87pn0hwq9f.fsf@linux.ibm.com>
In-Reply-To: <87pn0hwq9f.fsf@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1614855554.y6ukh6cl5v.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of March 3, 2021 1:04 am:
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
>> This is a first step to wrapping supervisor and user SPR saving and
>> loading up into helpers, which will then be called independently in
>> bare metal and nested HV cases in order to optimise SPR access.
>>
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>=20
> <snip>
>=20
>> +/* vcpu guest regs must already be saved */
>> +static void restore_p9_host_os_sprs(struct kvm_vcpu *vcpu,
>> +				    struct p9_host_os_sprs *host_os_sprs)
>> +{
>> +	mtspr(SPRN_PSPB, 0);
>> +	mtspr(SPRN_WORT, 0);
>> +	mtspr(SPRN_UAMOR, 0);
>> +	mtspr(SPRN_PSPB, 0);
>=20
> Not your fault, but PSPB is set twice here.

Yeah you're right.

>> +
>> +	mtspr(SPRN_DSCR, host_os_sprs->dscr);
>> +	mtspr(SPRN_TIDR, host_os_sprs->tidr);
>> +	mtspr(SPRN_IAMR, host_os_sprs->iamr);
>> +
>> +	if (host_os_sprs->amr !=3D vcpu->arch.amr)
>> +		mtspr(SPRN_AMR, host_os_sprs->amr);
>> +
>> +	if (host_os_sprs->fscr !=3D vcpu->arch.fscr)
>> +		mtspr(SPRN_FSCR, host_os_sprs->fscr);
>> +}
>> +
>=20
> <snip>
>=20
>> @@ -3605,34 +3666,10 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu =
*vcpu, u64 time_limit,
>>  	vcpu->arch.dec_expires =3D dec + tb;
>>  	vcpu->cpu =3D -1;
>>  	vcpu->arch.thread_cpu =3D -1;
>> -	vcpu->arch.ctrl =3D mfspr(SPRN_CTRLF);
>> -
>> -	vcpu->arch.iamr =3D mfspr(SPRN_IAMR);
>> -	vcpu->arch.pspb =3D mfspr(SPRN_PSPB);
>> -	vcpu->arch.fscr =3D mfspr(SPRN_FSCR);
>> -	vcpu->arch.tar =3D mfspr(SPRN_TAR);
>> -	vcpu->arch.ebbhr =3D mfspr(SPRN_EBBHR);
>> -	vcpu->arch.ebbrr =3D mfspr(SPRN_EBBRR);
>> -	vcpu->arch.bescr =3D mfspr(SPRN_BESCR);
>> -	vcpu->arch.wort =3D mfspr(SPRN_WORT);
>> -	vcpu->arch.tid =3D mfspr(SPRN_TIDR);
>> -	vcpu->arch.amr =3D mfspr(SPRN_AMR);
>> -	vcpu->arch.uamor =3D mfspr(SPRN_UAMOR);
>> -	vcpu->arch.dscr =3D mfspr(SPRN_DSCR);
>> -
>> -	mtspr(SPRN_PSPB, 0);
>> -	mtspr(SPRN_WORT, 0);
>> -	mtspr(SPRN_UAMOR, 0);
>> -	mtspr(SPRN_DSCR, host_dscr);
>> -	mtspr(SPRN_TIDR, host_tidr);
>> -	mtspr(SPRN_IAMR, host_iamr);
>> -	mtspr(SPRN_PSPB, 0);
>>
>> -	if (host_amr !=3D vcpu->arch.amr)
>> -		mtspr(SPRN_AMR, host_amr);
>> +	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
>>
>> -	if (host_fscr !=3D vcpu->arch.fscr)
>> -		mtspr(SPRN_FSCR, host_fscr);
>> +	store_spr_state(vcpu);
>=20
> store_spr_state should come first, right? We want to save the guest
> state before restoring the host state.

Yes good catch. I switched that back around later but looks like I
never brought the fix back to the right patch. Interestingly, things=20
pretty much work like this if the guest or host doesn't do anything
much with the SPRs!

Thanks,
Nick
