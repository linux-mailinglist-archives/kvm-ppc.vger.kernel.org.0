Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33D7326A8A
	for <lists+kvm-ppc@lfdr.de>; Sat, 27 Feb 2021 00:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhBZX4j (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 26 Feb 2021 18:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbhBZX4j (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 26 Feb 2021 18:56:39 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57020C061574
        for <kvm-ppc@vger.kernel.org>; Fri, 26 Feb 2021 15:55:59 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id e3so3320307pfj.6
        for <kvm-ppc@vger.kernel.org>; Fri, 26 Feb 2021 15:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=0iWVAUcrQ7hjmdJNydWlz82tvQ4nt8XRr82kvlydDIA=;
        b=Q1fLeF3lqbYpiR5g0v0wdeHI8aoqRL1oLCUzJBCXzZ8QKR/7DkZEOQLaPewS4wLwV/
         UCVzlB161Mp7m0TqJCF6r66V5Z5CcxTGT8fnQrtPL/XsIjFJptbOlm6NrdiALNs6Me7s
         8yEgqqQOUL67Wy0oMe/KdzzOQSLgKXKpLRGznrdm7PwCmxSyRV8oQkdk+zxayzJ/zfg+
         IuVwvQWBesGEWJfVqZp2nEoSa/MHRuEabYQBE6+rWCagIheV2gTBADnT3Gfc8UOLSVmf
         VAITd34CEiZuIgcKQXkUsBo9c3JJ9hqJQTdkN0ljvpi0Rc9Jkt8Om1m5CFQlCSltY2XH
         le9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=0iWVAUcrQ7hjmdJNydWlz82tvQ4nt8XRr82kvlydDIA=;
        b=lFDBEAwoO877cVWswcgOVS7zH7xTzLv9AdQkHJGrm3I85TBA3wUhH53lYzPlaJJSOt
         d53MOUG3Luk/F0FBvCsQboOKa7r+EvW6ScGYz1lggbRzRb7eADBWrqMBtEtk8Lei99+o
         i2XHDALCjDJ43MvXZK2WCqn7cgx0pGBnf8Z55zZTQkZquO17sB+wa0rn1a9xVpS3Cgfo
         e8q31tVgpBaQGAwPYh+ZR+Squ+/+zSU7Hrl6Hk+dW18SP70jJyG2QYYE5Hag8pKf4IYr
         1kfHModX2PsPhlIfpuGxJxBw5gcUmH/srU0035xKRUqH9+V01db84CkEkzJkp1UY1QJQ
         GrWw==
X-Gm-Message-State: AOAM532yNnbBrtSc9inOeaqjPyJndwLXAoFajywWSXLRp7CqVzwGkRNN
        1L8rwsAqChSmkv3Vm5Kw2cs=
X-Google-Smtp-Source: ABdhPJy1nC9H0MWkQjtzqChMteHynP/Gcsj+WZiio4QgAAraqoxOhhNEGze8PfMNMmkGnCVzEJk3XA==
X-Received: by 2002:a63:cb52:: with SMTP id m18mr5007435pgi.358.1614383758468;
        Fri, 26 Feb 2021 15:55:58 -0800 (PST)
Received: from localhost (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m12sm9398356pjk.47.2021.02.26.15.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 15:55:57 -0800 (PST)
Date:   Sat, 27 Feb 2021 09:55:52 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 05/37] KVM: PPC: Book3S HV: Ensure MSR[ME] is always
 set in guest MSR
To:     Daniel Axtens <dja@axtens.net>, kvm-ppc@vger.kernel.org
Cc:     Fabiano Rosas <farosas@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
References: <20210225134652.2127648-1-npiggin@gmail.com>
        <20210225134652.2127648-6-npiggin@gmail.com>
        <87zgzr8is2.fsf@linkitivity.dja.id.au>
In-Reply-To: <87zgzr8is2.fsf@linkitivity.dja.id.au>
MIME-Version: 1.0
Message-Id: <1614383549.rxe6rxw7w8.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Daniel Axtens's message of February 26, 2021 4:06 pm:
> Hi Nick,
>=20
>>  void kvmppc_set_msr_hv(struct kvm_vcpu *vcpu, u64 msr)
>>  {
>> +	/*
>> +	 * Guest must always run with machine check interrupt
>> +	 * enabled.
>> +	 */
>> +	if (!(msr & MSR_ME))
>> +		msr |=3D MSR_ME;
>=20
> This 'if' is technically redundant but you mention a future patch warning
> on !(msr & MSR_ME) so I'm holding off on any judgement about the 'if' unt=
il
> I get to that patch :)

That's true. The warning is actually further down when we're setting up=20
the msr to run in guest mode. At this point the MSR I think comes from
qemu (and arguably the guest setup code shouldn't need to know about HV
specific MSR bits) so a warning here wouldn't be appropriate.

I could remove the if, although the compiler might already do that.

>=20
> The patch seems sane to me, I agree that we don't want guests running wit=
h
> MSR_ME=3D0 and kvmppc_set_msr_hv already ensures that the transactional s=
tate is
> sane so this is another sanity-enforcement in the same sort of vein.
>=20
> All up:
> Reviewed-by: Daniel Axtens <dja@axtens.net>

Thanks,
Nick
