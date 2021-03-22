Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7227B344E2C
	for <lists+kvm-ppc@lfdr.de>; Mon, 22 Mar 2021 19:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhCVSNt (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 14:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbhCVSNr (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 14:13:47 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA667C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 11:13:46 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id mz6-20020a17090b3786b02900c16cb41d63so8990633pjb.2
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 11:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=Qq8raOlLG9v3LgEz+Fj0Q18e7Dl2YyDOZyF1mZtkVlo=;
        b=OuAiyERmsYYOhOXnyNL4DS25SMQYNvHknavb1QJwjwrLATpGojEOk/JZ8ITnWDVSuD
         miligP7rq17+CX37qnq7bCq2YgglBXT2RgQP62V7HGE91TIDD8/sOAsGyPxeEiwvhJX9
         OY1d+1AQfJ9Bc0HXR5Fv7SkcSicZi7bBoJp4z8A9f6QT/h5DkKusa+GycVhKRfYIRwwh
         M/R6a7JW8Qa3whHXDlEZF0fTEiGGpl9lM89eIG6MJp2dPGuQFp3vyXslspCZnc/Nj0X8
         lHWU2e95Q/dt7eCbe/xz0V/20LMd0Sp9PUZqbPv+PcFf9PprMErx89yJ0vP4N4XgcohV
         Lceg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=Qq8raOlLG9v3LgEz+Fj0Q18e7Dl2YyDOZyF1mZtkVlo=;
        b=QZmFadbiNKrg8XIg8PkipESVFMZV6XEbpPMmmOxUPr33KuQsZekNY3L/W3xklvIpOP
         ArUdqEXeDX/RNQfejr3K0jFyMgCftvZLgjKolV9cnuY3CwlPqG9Wpi0WWRyRSKMT2gVp
         PQbii6k6kVAR2SAAhICgrlSiJngwq0l1+FJCfWARv0owieabe0PinNXGYSEq6IuVaahM
         gEBRIyuQ5Bgw7K6UVJ2SiBysaetiRTEEnxtnQ3YF2IA46dly9lgxw3Ckls92UYbdFTmB
         y1aFKUfQWgKrJ4oUvovPcOBi4VPfjI1+G9+Y8AiGCcR0+cI47g8eeSlnqqQaFVaMreLo
         QIug==
X-Gm-Message-State: AOAM533XSmMdEXSv+7J8xdCyeFxarYSNW7NzJqFkMEsrSdFw3WrQl8EN
        oDcAGtfgLz4mhd1KafR5Y6paaLT0go8=
X-Google-Smtp-Source: ABdhPJyLc8hsm4YQnGwcJtuT2J5r6Vv7n+9Ww9+yJQhgy5V3kQxuozM7MRkXXuMBDbSRVO0dwEURdw==
X-Received: by 2002:a17:90a:ab09:: with SMTP id m9mr375039pjq.122.1616436826270;
        Mon, 22 Mar 2021 11:13:46 -0700 (PDT)
Received: from localhost ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id n25sm4513370pgv.66.2021.03.22.11.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 11:13:45 -0700 (PDT)
Date:   Tue, 23 Mar 2021 04:13:39 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 17/41] KVM: PPC: Book3S HV P9: implement
 kvmppc_xive_pull_vcpu in C
To:     =?iso-8859-1?q?C=E9dric?= Le Goater <clg@kaod.org>,
        kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210305150638.2675513-1-npiggin@gmail.com>
        <20210305150638.2675513-18-npiggin@gmail.com>
        <11823cfb-3d10-8f2f-4caf-9b38a010ed31@kaod.org>
In-Reply-To: <11823cfb-3d10-8f2f-4caf-9b38a010ed31@kaod.org>
MIME-Version: 1.0
Message-Id: <1616436715.ynrx4scuw6.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from C=C3=A9dric Le Goater's message of March 23, 2021 2:19 am:
> On 3/5/21 4:06 PM, Nicholas Piggin wrote:
>> This is more symmetric with kvmppc_xive_push_vcpu. The extra test in
>> the asm will go away in a later change.
>>=20
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>=20
> Reviewed-by: C=C3=A9dric Le Goater <clg@kaod.org>
>> diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xi=
ve.c
>> index e7219b6f5f9a..52cdb9e2660a 100644
>> --- a/arch/powerpc/kvm/book3s_xive.c
>> +++ b/arch/powerpc/kvm/book3s_xive.c
>> @@ -127,6 +127,37 @@ void kvmppc_xive_push_vcpu(struct kvm_vcpu *vcpu)
>>  }
>>  EXPORT_SYMBOL_GPL(kvmppc_xive_push_vcpu);
>> =20
>> +/*
>> + * Pull a vcpu's context from the XIVE on guest exit.
>> + * This assumes we are in virtual mode (MMU on)
>=20
> should we add an assert on is_rm() ?=20

I thought the same thing at first, but I think it should be okay.
kvmppc_xive_push_cpu does not have an assert, and in the next
patch the push and pull get moved out to where it is much clearer
to see the MMU is on.

Thanks,
Nick
