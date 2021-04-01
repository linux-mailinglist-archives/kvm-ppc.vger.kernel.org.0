Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3306D3512C2
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 11:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbhDAJxp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 05:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233383AbhDAJx3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 05:53:29 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B497C0613E6
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 02:53:29 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id a12so1082850pfc.7
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 02:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=F4k3xltC/mdSm/joM9oLpm2TwHoO0oN2DqAFlf1TJDM=;
        b=HAt0FUlXreQHPqvvmqmfz8BJ0iDeU+/1hovAiob8HxWZDxwRSBR8b2HBUQ+JM29+ja
         r/JMZ4JH/lI1zrRHX+zJc5EK++ITEGUwo077AZmYLIY8UZB8nA1pM7EpdEa3bHFLK8WP
         LtnxGgPL5OL1o69ZapT7VZTVURaqDEj5tZSXIazgFtGg7S5TM3iL8KBB0aipCBRRPwzv
         OpXdOjorrfY0AK3Qo5zGgGF+NdOe8qjx0Fr06SEW1Mbmem7vRmwuL+MmFPMrLVyS4bzU
         Id6XflW8BveQXLjv3cpjFHznAS6QMiESZABrLmxeD1cJI9SVLNTUzugXGAfLZ5NfHD26
         TbVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=F4k3xltC/mdSm/joM9oLpm2TwHoO0oN2DqAFlf1TJDM=;
        b=dKIgAaM0N9PoLutcPKJ1/QnDlSNAbmgqUtrbZRBYg7hQeZ1KGaWDp7s1Jx/4Purg0q
         x3dOYjxkFFOhM0EZ31duj9voXXRigyNuDXNtKjfGsiJlJqFwyWwrL3pr6mcUyNA2D4mL
         +cRmj9PHTf1Xzl8s1kW2FZRd4Dd1HQ+oOwAMXp2eQ8y0nbyjfn9cUcAtt9X8TjauOfUC
         9LZiz4Eqcl1ZQor2pgjabVi7IaSMP27Aj5CpQ+0DzwawuU5NLXkYy3HcN4JAGuxoi+xJ
         mmeTpwRSty8QA3gsE3D3X8GUpE/e/WVqLQ4nJ/CiKRROb4ygUTz+G7J+Ci8ymQJAmsxK
         TGqw==
X-Gm-Message-State: AOAM530NDG7N1BkftZ3sJKmwTBRB6BTI6EPlIUQu5BU5wARCZlWauMyo
        k9StyfBqbobeRtw4SYQSMQ0=
X-Google-Smtp-Source: ABdhPJzR8DjIT+RPNAptiXqmIPQZZw3Cz1vI7wkbRy9K7DqINSFVZ2CtCEvmM9f6qJIJWOT/mhKUOw==
X-Received: by 2002:a05:6a00:cc7:b029:203:6bc9:3edf with SMTP id b7-20020a056a000cc7b02902036bc93edfmr6736719pfv.23.1617270808940;
        Thu, 01 Apr 2021 02:53:28 -0700 (PDT)
Received: from localhost ([1.128.222.7])
        by smtp.gmail.com with ESMTPSA id gb1sm5004177pjb.21.2021.04.01.02.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 02:53:28 -0700 (PDT)
Date:   Thu, 01 Apr 2021 19:53:23 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 13/46] KVM: PPC: Book3S 64: Move GUEST_MODE_SKIP test
 into KVM
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Daniel Axtens <dja@axtens.net>,
        Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <20210323010305.1045293-1-npiggin@gmail.com>
        <20210323010305.1045293-14-npiggin@gmail.com>
        <YGVbApPydgwAU8cP@thinks.paulus.ozlabs.org>
In-Reply-To: <YGVbApPydgwAU8cP@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Message-Id: <1617270768.urf3tmz6b4.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Paul Mackerras's message of April 1, 2021 3:32 pm:
> On Tue, Mar 23, 2021 at 11:02:32AM +1000, Nicholas Piggin wrote:
>> Move the GUEST_MODE_SKIP logic into KVM code. This is quite a KVM
>> internal detail that has no real need to be in common handlers.
>>=20
>> Also add a comment explaining why this thing exists.
>=20
> [snip]
>=20
>> diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3=
s_64_entry.S
>> index 7a039ea78f15..a5412e24cc05 100644
>> --- a/arch/powerpc/kvm/book3s_64_entry.S
>> +++ b/arch/powerpc/kvm/book3s_64_entry.S
>> @@ -1,6 +1,7 @@
>>  /* SPDX-License-Identifier: GPL-2.0-only */
>>  #include <asm/asm-offsets.h>
>>  #include <asm/cache.h>
>> +#include <asm/exception-64s.h>
>>  #include <asm/kvm_asm.h>
>>  #include <asm/kvm_book3s_asm.h>
>>  #include <asm/ppc_asm.h>
>> @@ -20,9 +21,12 @@ kvmppc_interrupt:
>>  	 * guest R12 saved in shadow VCPU SCRATCH0
>>  	 * guest R13 saved in SPRN_SCRATCH0
>>  	 */
>> -#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
>>  	std	r9,HSTATE_SCRATCH2(r13)
>>  	lbz	r9,HSTATE_IN_GUEST(r13)
>> +	cmpwi	r9,KVM_GUEST_MODE_SKIP
>> +	beq-	.Lmaybe_skip
>> +.Lno_skip:
>> +#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
>>  	cmpwi	r9,KVM_GUEST_MODE_HOST_HV
>>  	beq	kvmppc_bad_host_intr
>>  #ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
>> @@ -34,3 +38,48 @@ kvmppc_interrupt:
>>  #else
>>  	b	kvmppc_interrupt_pr
>>  #endif
>=20
> It's a bit hard to see without more context, but I think that in the
> PR-only case (CONFIG_KVM_BOOK3S_HV_POSSIBLE undefined), this will
> corrupt R9.  You need to restore R9 before the unconditional branch to
> kvmppc_interrupt_pr.  (I realize this code gets modified further, but
> I'd rather not break bisection.)

Very good catch, thanks.

Thanks,
Nick
