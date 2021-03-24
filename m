Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51032346EEA
	for <lists+kvm-ppc@lfdr.de>; Wed, 24 Mar 2021 02:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhCXBf1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 23 Mar 2021 21:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhCXBfA (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 23 Mar 2021 21:35:00 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6236FC061763
        for <kvm-ppc@vger.kernel.org>; Tue, 23 Mar 2021 18:35:00 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id l1so13540550pgb.5
        for <kvm-ppc@vger.kernel.org>; Tue, 23 Mar 2021 18:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=2Esp6d9qJMuOjUmKYgGj6kVKFLxI1yLM0VLvKW/6jTo=;
        b=RgFXgZDPWXDd162vmCVB+rkePQayzeoHj4DoEkOAShQhrMkc3AIsH4j0tegvfg55Q2
         3qE3/oex7CeR1lRpKlr/wpe9afxT2IPc2n6uRRtIGXb7f4sYAfraEkDq52yau2lI8XxI
         OTFPEQwhuJpHS5Ho7yrioaZtvH62Ed48NWmVfiI9zkt1NqjIKRxyCOta6if6svESjrN1
         iKGDvLG1VhjpLJ9/oG9FML8h/0ISt3RteykmLSAGLnPQEGhYxX6fqSAivr/MqRYH7aUx
         mlJMVj+l/nZNar1NP+Aebnk8WM3Rfsh2Lgb6vzPj3rOYgj0US4tVHpMYuqwgcesQrvul
         qjvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=2Esp6d9qJMuOjUmKYgGj6kVKFLxI1yLM0VLvKW/6jTo=;
        b=pzVvEkRVkCtVL1+rm4cXa5wzwlRPZNIuXyZcZgJNyMpDFMI1tulCGcpt0o1L0hoTy2
         Jfds73VpRrfddHlZCgjHXgmeVfqJzfO9DVSnUDexDf0aWPiWoYeG2Et3vmlCkC3Fc/pE
         e3L4kXIaxZjVW84i7IwFNxpGVzZQYALvhmweU1205bPm0oD0XCokYqvvi0/GTNjtYOP9
         piXDN71I2AkNB5HPN7RTJK/cUmPRzgS1dp404m3fuPBqyeY79FmhcAalSwS9W/yp4npO
         7jXQB7Y3HMt/6qzC4PV8MIw2nHwNdM4CQjwGBsi9qdV36wPsOduxicRUbtTnqZG6A1qK
         p+gA==
X-Gm-Message-State: AOAM53298N1dcC24RKRVFOIMaaYih0PELkcFPPuWHaznism0m+Y4qXam
        oTrZT4/oMX+Hyyjr1/3at1iTd1oW4rA=
X-Google-Smtp-Source: ABdhPJx2+SzcdmpzPYGk5x1oUCWIBBJ+/x+AV+tqcF8TyXqNmywur28Opjzjq1KMs92ok0kzzsyPhA==
X-Received: by 2002:a62:a108:0:b029:1c1:119b:8713 with SMTP id b8-20020a62a1080000b02901c1119b8713mr861259pff.74.1616549699978;
        Tue, 23 Mar 2021 18:34:59 -0700 (PDT)
Received: from localhost (193-116-197-97.tpgi.com.au. [193.116.197.97])
        by smtp.gmail.com with ESMTPSA id 9sm370057pgy.79.2021.03.23.18.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 18:34:59 -0700 (PDT)
Date:   Wed, 24 Mar 2021 11:34:54 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 44/46] KVM: PPC: Book3S HV P9: implement hash guest
 support
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210323010305.1045293-1-npiggin@gmail.com>
        <20210323010305.1045293-45-npiggin@gmail.com> <87tup1kgtb.fsf@linux.ibm.com>
In-Reply-To: <87tup1kgtb.fsf@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1616549242.r712wrhm08.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of March 24, 2021 1:53 am:
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
>> Guest entry/exit has to restore and save/clear the SLB, plus several
>> other bits to accommodate hash guests in the P9 path.
>>
>> Radix host, hash guest support is removed from the P7/8 path.
>>
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>=20
> <snip>
>=20
>> diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/b=
ook3s_hv_interrupt.c
>> index cd84d2c37632..03fbfef708a8 100644
>> --- a/arch/powerpc/kvm/book3s_hv_interrupt.c
>> +++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
>> @@ -55,6 +55,50 @@ static void __accumulate_time(struct kvm_vcpu *vcpu, =
struct kvmhv_tb_accumulator
>>  #define accumulate_time(vcpu, next) do {} while (0)
>>  #endif
>>
>> +static inline void mfslb(unsigned int idx, u64 *slbee, u64 *slbev)
>> +{
>> +	asm volatile("slbmfev  %0,%1" : "=3Dr" (*slbev) : "r" (idx));
>> +	asm volatile("slbmfee  %0,%1" : "=3Dr" (*slbee) : "r" (idx));
>> +}
>> +
>> +static inline void __mtslb(u64 slbee, u64 slbev)
>> +{
>> +	asm volatile("slbmte %0,%1" :: "r" (slbev), "r" (slbee));
>> +}
>> +
>> +static inline void mtslb(unsigned int idx, u64 slbee, u64 slbev)
>> +{
>> +	BUG_ON((slbee & 0xfff) !=3D idx);
>> +
>> +	__mtslb(slbee, slbev);
>> +}
>> +
>> +static inline void slb_invalidate(unsigned int ih)
>> +{
>> +	asm volatile("slbia %0" :: "i"(ih));
>> +}
>=20
> Fyi, in my environment the assembler complains:
>=20
> {standard input}: Assembler messages:                                   =20
> {standard input}:1293: Error: junk at end of line: `6'                   =
         =20
> {standard input}:2138: Error: junk at end of line: `6'                   =
=20
> make[3]: *** [../scripts/Makefile.build:271:
> arch/powerpc/kvm/book3s_hv_interrupt.o] Error 1
>=20
> This works:
>=20
> -       asm volatile("slbia %0" :: "i"(ih));
> +       asm volatile(PPC_SLBIA(%0) :: "i"(ih));
>=20
> But I don't know what is going on.

Ah yes, we still need to use PPC_SLBIA. IH parameter to slbia was only=20
added in binutils 2.27 and we support down to 2.23.

Thanks for the fix I'll add it.

Thanks,
Nick
