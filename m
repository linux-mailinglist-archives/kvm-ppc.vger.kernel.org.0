Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5A73512A6
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 11:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbhDAJpi (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 05:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbhDAJp1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 05:45:27 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5EFC0613E6
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 02:45:27 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so2782523pjb.4
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 02:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=cxJdpEx/qaSyYLkc2fRUsLM6PN0Yk9OCyV658jn3wQw=;
        b=l8j5HhBu2NMWk5khRpRrTjj6hXiWysYLf7Om3Tzwq8w6Gr9sjWIkV0U3uIt+XRjTMq
         58j0F7hcRwAiO4o8eTAMe9gPkqJPH7nox1iZ5Zi2DXdU9w5CuCHOYo7j8/ixCJM7uFQi
         Q9XbqYqyfmL0QcESJDZZ9DfodF6meShZqmqI2LLQe+EQlNRW0gdaykom+0AKsgqC/GLI
         Y4SmgrtvvbdWL+7UU3jKRxh97AjundWz9KqPRE2f6OA34wsDf/S5eDwPg8JXKlx3vsvw
         NELRCpC00AZAVI1KFXPcddBgt+QW9qtoxmn9tiuC9rE1dKXe25QL2Ei/EEAUhSRsWelU
         BhiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=cxJdpEx/qaSyYLkc2fRUsLM6PN0Yk9OCyV658jn3wQw=;
        b=CfulcyVXvd6pqbp94uc6cYj5HCT6dx/T4uJsem65Y72jAm3f5ZEkXPMmsdrEsC2Fvt
         ztGhQ9QTnZbUqOA6tIJI5AF0v1Pi3QAhW9A0i4VOoJAx/m0CdkWnXFAbMPgSPaVb76eH
         fysRDV3yXIExR7a+/3jyuwZsuBVnLROJQYWXkju76BIr7Sitf0mgIhNCWYex2LXZOm/B
         cXEreOsIFS9clCV3CUgmhTyKtY2nqt2IJ5FjGL5XyQSdlvXHAxbmwfq2iqttC+CSdO8C
         RmOPPt79FZ1AUihz3eI4A5ubL/sFGrdR1G6A5QY5jJjNYSKGWzI//ScruUHGKvHFmaxl
         4Zxg==
X-Gm-Message-State: AOAM532r3cQsTE0E0DuwzCyyTHBJY7mrGOElYw1PWsAPZ8zt9xbAn0wN
        tk2rWYlLtmS4zBSFG7LCrJk=
X-Google-Smtp-Source: ABdhPJxdWFYfE6O7Q+j5sbwdf2QmgDQVt4PvxApyIGNP2vWkKbb4/984ZUfbaeJ1CX6ocCJmJYuJTg==
X-Received: by 2002:a17:902:a412:b029:e5:d7dd:9e41 with SMTP id p18-20020a170902a412b02900e5d7dd9e41mr7317919plq.78.1617270327264;
        Thu, 01 Apr 2021 02:45:27 -0700 (PDT)
Received: from localhost ([1.128.222.144])
        by smtp.gmail.com with ESMTPSA id s22sm4958637pjs.42.2021.04.01.02.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 02:45:27 -0700 (PDT)
Date:   Thu, 01 Apr 2021 19:45:21 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 04/46] KVM: PPC: Book3S HV: Prevent radix guests from
 setting LPCR[TC]
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20210323010305.1045293-1-npiggin@gmail.com>
        <20210323010305.1045293-5-npiggin@gmail.com>
        <YGP74QVmx5yyE8Rc@thinks.paulus.ozlabs.org>
In-Reply-To: <YGP74QVmx5yyE8Rc@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Message-Id: <1617269806.5qka0ltce0.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Paul Mackerras's message of March 31, 2021 2:34 pm:
> On Tue, Mar 23, 2021 at 11:02:23AM +1000, Nicholas Piggin wrote:
>> This bit only applies to hash partitions.
>>=20
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>>  arch/powerpc/kvm/book3s_hv.c        | 6 ++++++
>>  arch/powerpc/kvm/book3s_hv_nested.c | 3 +--
>>  2 files changed, 7 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index c5de7e3f22b6..1ffb0902e779 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -1645,6 +1645,12 @@ static int kvm_arch_vcpu_ioctl_set_sregs_hv(struc=
t kvm_vcpu *vcpu,
>>   */
>>  unsigned long kvmppc_filter_lpcr_hv(struct kvmppc_vcore *vc, unsigned l=
ong lpcr)
>>  {
>> +	struct kvm *kvm =3D vc->kvm;
>> +
>> +	/* LPCR_TC only applies to HPT guests */
>> +	if (kvm_is_radix(kvm))
>> +		lpcr &=3D ~LPCR_TC;
>=20
> I'm not sure I see any benefit from this, and it is a little extra
> complexity.

Principle of allowing a guest to mess with as little HV state as=20
possible (but not littler), which I think is a good one to follow.

>=20
>>  	/* On POWER8 and above, userspace can modify AIL */
>>  	if (!cpu_has_feature(CPU_FTR_ARCH_207S))
>>  		lpcr &=3D ~LPCR_AIL;
>> diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book=
3s_hv_nested.c
>> index f7b441b3eb17..851e3f527eb2 100644
>> --- a/arch/powerpc/kvm/book3s_hv_nested.c
>> +++ b/arch/powerpc/kvm/book3s_hv_nested.c
>> @@ -140,8 +140,7 @@ static void sanitise_hv_regs(struct kvm_vcpu *vcpu, =
struct hv_guest_state *hr)
>>  	/*
>>  	 * Don't let L1 change LPCR bits for the L2 except these:
>>  	 */
>> -	mask =3D LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_AIL | LPCR_LD |
>> -		LPCR_LPES | LPCR_MER;
>> +	mask =3D LPCR_DPFD | LPCR_ILE | LPCR_AIL | LPCR_LD | LPCR_LPES | LPCR_=
MER;
>=20
> Doesn't this make it completely impossible to set TC for any guest?

Argh, yes Fabiano pointed this out in an earlier rev and I didn't
fix this hunk after adding the filter bit. Thanks.

Thanks,
Nick
