Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D570F351BB2
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235183AbhDASKu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 14:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237305AbhDASDj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 14:03:39 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8800C08EA70
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 06:28:15 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id x26so1523140pfn.0
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 06:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=moDbZSIuQbE+Re/GxIqrR5DF17rrpW/0FK43E8e+pFA=;
        b=LdF6JJ4xXCgaxItU5LDAPV4SIK6+1ZisRfBsLfB5H1eu8ikNJ5B+DGAC2DaQTG7NwS
         HVEh8fAGufr1Y2jl/afLlsi+ZDQ8LF7NMzPzY/EBUPqIhRtJiAc1vQD9Etj97Y4CScoQ
         sCjkSBJ7STB2JywhLuU7vYCygtlIsoU4XyqM6AsTPtlHxDkOeB6d/3dUEZa6Zxxw0QWC
         +ZB4LjgduEiZWj2QflNkQmavrcikpvRIh1HzChO2haEbpaI3Uk8NsrY20/lbdGkKU/m6
         mlewigh1FrcR1IwLtIyT/Cx2K4/RbIUl+WOXTbX2gY7wiBZqDgqkhAyIbp4USbWWuxvR
         NtEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=moDbZSIuQbE+Re/GxIqrR5DF17rrpW/0FK43E8e+pFA=;
        b=ZYEHVZEd9/ZE9Xckt3BLoyVbDSxYjjjjFX8UyI2Vnbco57Vg94kXMt8P9ucPk3xClK
         S+jRiI20lCQXzqwzbCUXZFotKPyxsoj2w58IBdZCRZyCj7jj1nsg5YaTSi4vod4eVxhV
         4OFYrwjLZzKLXnjapFV8axWNH+a4o624lyEgQigmaiPVQ+V7wdsBsPpUV2yldMdEJx6c
         h8UwJLl/iG93Sjmvs66ojueCbUA3kmGXANsdpXcWmy+ByGH36AoBr1BSUoyOMXFeQoDL
         bizDgQbgJS0w2NG9Ms5SoRimf0Lw5ZtRFlDm9l37t/9uHFMonfSJ5TYN/ZVBH4LjSwO3
         viSw==
X-Gm-Message-State: AOAM5318m0Iiy95j1fqjF74uYY7qyZqkSvBDy2X+kfmwuP3WubfkGlBT
        fAmpasaYsK4IuQt/b0VwM+wZ3UuUhGg=
X-Google-Smtp-Source: ABdhPJw1sOrEU/4cofTB8qbdFtxs+oTQFcpgbhYGb0n/BpWB98aRuZDlGFVhKnmkasp8AP0EUr6IFA==
X-Received: by 2002:a62:180f:0:b029:225:5266:2b61 with SMTP id 15-20020a62180f0000b029022552662b61mr7771209pfy.30.1617283695211;
        Thu, 01 Apr 2021 06:28:15 -0700 (PDT)
Received: from localhost ([1.128.222.58])
        by smtp.gmail.com with ESMTPSA id z8sm5783437pjd.0.2021.04.01.06.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 06:28:14 -0700 (PDT)
Date:   Thu, 01 Apr 2021 23:28:09 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 02/46] KVM: PPC: Book3S HV: Add a function to filter
 guest LPCR bits
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20210323010305.1045293-1-npiggin@gmail.com>
        <20210323010305.1045293-3-npiggin@gmail.com>
        <YGP1uXH5q72auwP7@thinks.paulus.ozlabs.org>
        <1617269036.86nd07dbhp.astroid@bobo.none>
In-Reply-To: <1617269036.86nd07dbhp.astroid@bobo.none>
MIME-Version: 1.0
Message-Id: <1617283627.0fudnz2en1.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Nicholas Piggin's message of April 1, 2021 7:32 pm:
> Excerpts from Paul Mackerras's message of March 31, 2021 2:08 pm:
>> On Tue, Mar 23, 2021 at 11:02:21AM +1000, Nicholas Piggin wrote:
>>> Guest LPCR depends on hardware type, and future changes will add
>>> restrictions based on errata and guest MMU mode. Move this logic
>>> to a common function and use it for the cases where the guest
>>> wants to update its LPCR (or the LPCR of a nested guest).
>>=20
>> [snip]
>>=20
>>> @@ -4641,8 +4662,9 @@ void kvmppc_update_lpcr(struct kvm *kvm, unsigned=
 long lpcr, unsigned long mask)
>>>  		struct kvmppc_vcore *vc =3D kvm->arch.vcores[i];
>>>  		if (!vc)
>>>  			continue;
>>> +
>>>  		spin_lock(&vc->lock);
>>> -		vc->lpcr =3D (vc->lpcr & ~mask) | lpcr;
>>> +		vc->lpcr =3D kvmppc_filter_lpcr_hv(vc, (vc->lpcr & ~mask) | lpcr);
>>=20
>> This change seems unnecessary, since kvmppc_update_lpcr is called only
>> to update MMU configuration bits, not as a result of any action by
>> userspace or a nested hypervisor.  It's also beyond the scope of what
>> was mentioned in the commit message.
>=20
> I didn't think it was outside the spirit of the patch, but yes
> only the guest update LPCR case was enumerated. Would it be more=20
> consistent to add it to the changelog and leave it in here or would
> you prefer it left out until there is a real use?

On second thoughts, I already left at least one other place without
such a check, so I now tend to agree with you. But I instead added
a test that just ensures the host is not out of synch with itself in
terms of what it can set the LPCR to.

Thanks,
Nick
