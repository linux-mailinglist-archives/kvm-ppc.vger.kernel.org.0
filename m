Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E70326A87
	for <lists+kvm-ppc@lfdr.de>; Sat, 27 Feb 2021 00:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhBZXwf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 26 Feb 2021 18:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhBZXwe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 26 Feb 2021 18:52:34 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E81CC061574
        for <kvm-ppc@vger.kernel.org>; Fri, 26 Feb 2021 15:51:54 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id p21so7148599pgl.12
        for <kvm-ppc@vger.kernel.org>; Fri, 26 Feb 2021 15:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=zVCQxsICbHOyHh30iPPaVoEQs8OioKHBSxz33rSHcf4=;
        b=mD3B2eHeDq/3NzRnAestA7yjVEPuvNOzLGGpB6ngH8PMpjFbJRWc1+pQSN+8AiSqsP
         DgUAp/1Ms0fEby5Px3CAjG/vPmkcMvmbbqk5y0egLrxKYlc9X8ClhqNWG7MmcU9UcG/J
         3qo6vhx7Pp2VjVpktDYOP+jqwqyhWFbudqr3dwDL/lMGWT+09TiDIKw492KItrQxhx3v
         PEbT0cdoqHvkGaQemT1jufxFZgpNiTPLDuFgWeQKJNG3+H6dHKqKDl9lI74I0bHgx59C
         ugyhzt5D2IwVWPo7y9tQY/0uvXzWyquvK2CKigQq1RMCRA1mvGEwFzceRkMpsmpCCgCo
         WhbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=zVCQxsICbHOyHh30iPPaVoEQs8OioKHBSxz33rSHcf4=;
        b=Vh8EKZ8S6z+cOHnWf5H+NnBYkxluWPIM3YCgUcRZPlD2m4hUonOzb7R6ltgMGnIghE
         2VsBJskYb4DAM8zv/jNAMppKJnxT4xufO0P49WCK+txs52qkRpc7rMIKEGAYnk1FNmDg
         kCLvAehbe7Ywh4Zr/YasLXTddXOfA+D6wZS6LhxP5BOm4h51oFvAepeVO6RSiDs5hxqg
         R6FL9DmkpLDuWs2OrSsXtX/H6kJEb7bCjEM3cWIAoPrFFzuF36mPaCqOvvsmWt1lbrab
         6+apiWA7WasgqLzVWxJy3s8q+bjDc1ES7KDKsP84RSOqbZJZyknQ6Ph1W85MGew7FZQr
         kfjw==
X-Gm-Message-State: AOAM531bdCs4QRqC+2nEpxfKkBp7NsVVNDdTQP0TY9k6rJbiFGvLh74M
        +FYfOcrpkhjDnbHy4upnXbGoI6U6++g=
X-Google-Smtp-Source: ABdhPJwZY6m/MjM2b//hidlAPFT6ke+QB6OZJd+f2tGf9SMVLmRqQADn3ixWL0gPxAHUboju5VG5+Q==
X-Received: by 2002:a63:4c2:: with SMTP id 185mr4857054pge.75.1614383513772;
        Fri, 26 Feb 2021 15:51:53 -0800 (PST)
Received: from localhost (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id o23sm10796887pfp.89.2021.02.26.15.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 15:51:53 -0800 (PST)
Date:   Sat, 27 Feb 2021 09:51:47 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 04/37] powerpc/64s: remove KVM SKIP test from
 instruction breakpoint handler
To:     Daniel Axtens <dja@axtens.net>, kvm-ppc@vger.kernel.org
Cc:     Fabiano Rosas <farosas@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
References: <20210225134652.2127648-1-npiggin@gmail.com>
        <20210225134652.2127648-5-npiggin@gmail.com>
        <8735xj9yd4.fsf@linkitivity.dja.id.au>
In-Reply-To: <8735xj9yd4.fsf@linkitivity.dja.id.au>
MIME-Version: 1.0
Message-Id: <1614383420.qkrnr8p53z.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Daniel Axtens's message of February 26, 2021 3:44 pm:
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
>> The code being executed in KVM_GUEST_MODE_SKIP is hypervisor code with
>> MSR[IR]=3D0, so the faults of concern are the d-side ones caused by acce=
ss
>> to guest context by the hypervisor.
>>
>> Instruction breakpoint interrupts are not a concern here. It's unlikely
>> any good would come of causing breaks in this code, but skipping the
>> instruction that caused it won't help matters (e.g., skip the mtmsr that
>> sets MSR[DR]=3D0 or clears KVM_GUEST_MODE_SKIP).
>=20
> I'm not entirely clear on the example here, but the patch makes sense
> and I can follow your logic for removing the IKVM_SKIP handler from the
> instruction breakpoint exception.

The example just means that a breakpoint interrupt on any instruction=20
inside the guest mode skip region would be skipped, and skipping one of=20
those (mtmsrd or store that gets us out of guest mode skip) would cause=20
a crash.

Thanks,
Nick

>=20
> On that basis:
> Reviewed-by: Daniel Axtens <dja@axtens.net>
>=20
> Kind regards,
> Daniel
>=20
>>
>> Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>>  arch/powerpc/kernel/exceptions-64s.S | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/=
exceptions-64s.S
>> index a027600beeb1..0097e0676ed7 100644
>> --- a/arch/powerpc/kernel/exceptions-64s.S
>> +++ b/arch/powerpc/kernel/exceptions-64s.S
>> @@ -2553,7 +2553,6 @@ EXC_VIRT_NONE(0x5200, 0x100)
>>  INT_DEFINE_BEGIN(instruction_breakpoint)
>>  	IVEC=3D0x1300
>>  #ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
>> -	IKVM_SKIP=3D1
>>  	IKVM_REAL=3D1
>>  #endif
>>  INT_DEFINE_END(instruction_breakpoint)
>> --=20
>> 2.23.0
>=20
