Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976E748A63B
	for <lists+kvm-ppc@lfdr.de>; Tue, 11 Jan 2022 04:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345924AbiAKDXV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 10 Jan 2022 22:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345894AbiAKDXV (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 10 Jan 2022 22:23:21 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE17C06173F
        for <kvm-ppc@vger.kernel.org>; Mon, 10 Jan 2022 19:23:19 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id g11-20020a17090a7d0b00b001b2c12c7273so966712pjl.0
        for <kvm-ppc@vger.kernel.org>; Mon, 10 Jan 2022 19:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=cGcjhxHa1UfE+w3Pwk1V+Srw14TjijtJvFVLj26vVvk=;
        b=Xih5sPt5ya8F7x6OJi3Vgl+zKxKXV3Vs0d8C5NqtFAHFULSatRxOCF1Ohknsaeuu+M
         cr2Kpue/a1sHrxZ2FaEirnXxczrB7/JmtLS0Z5C3w3gNyhHYRKEB+9YIZzXs+chGGW46
         xolCyFc62sJyng+oDzpiipONXIFe7aqiTBwszfCB4SmoVYJ8HNjXiaxCm28VJCpzKk3M
         C0D2BUsSmgM3z5HOQE7l90mwxo8ciKZHi/fZdDihAabd16nu527RvS2z0QKcKcphbYBB
         DFbMzdVT0ScFhicrFzxReRPl7f8l6epdHVhNSsHpudkMRfzGdjYIWTiJFeL3APp+x4ZK
         C6TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=cGcjhxHa1UfE+w3Pwk1V+Srw14TjijtJvFVLj26vVvk=;
        b=R0EkKsZlmTGToSlxYZcg7j5QmNYo5RNj2AZupnwcjtHpxB5uEguxF8Giiee23aRuxk
         Zcp7Rquue/gIfOhWZB+e5dNt4csZuOudFOKHWbHKuMUKRxGqkz+TUGEp4JKYPYPw9oKI
         kubkLszKneYUmsq2JGdUpTo5v8Kql8eSdfoKXY6rbPnakZRHppRaIxDHU36ha7zw+HWX
         spvrOXQ0rlenVl/PbBk/81aZzLgf8ECicfiL2RNkTom/wCeHot80EyHW4ZMvjvSaksH3
         t+wNi7A4rK9wXYHQiUvd7qabwZ6hVGlT3g96QFK1YYuVi1Cz7psYF0xMrTmkj92Wtcvu
         xu3Q==
X-Gm-Message-State: AOAM532lIGAsZWPVKD+YRZFRc0LM56XAZK5C15YiUfQUsW3Kpx3YsjPf
        aQwBiEpb2I2MNpwz1tl6Z9Q=
X-Google-Smtp-Source: ABdhPJxdlbhSugTpZ/4WKbny7vCIqL/mMNTIu6//CvE+AzpbsW4CZp+RjANvZmnFBx6h99eWTKSIKQ==
X-Received: by 2002:a63:cc4d:: with SMTP id q13mr2355485pgi.166.1641871399359;
        Mon, 10 Jan 2022 19:23:19 -0800 (PST)
Received: from localhost (124-171-74-95.tpgi.com.au. [124.171.74.95])
        by smtp.gmail.com with ESMTPSA id em22sm431516pjb.23.2022.01.10.19.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 19:23:19 -0800 (PST)
Date:   Tue, 11 Jan 2022 13:23:14 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 5/6] KVM: PPC: mmio: Return to guest after emulation
 failure
To:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20220107210012.4091153-1-farosas@linux.ibm.com>
        <20220107210012.4091153-6-farosas@linux.ibm.com>
        <1641799578.6dxlxsaaos.astroid@bobo.none>
        <bf61f021-15b3-7093-f991-cdcda93d059d@ozlabs.ru>
In-Reply-To: <bf61f021-15b3-7093-f991-cdcda93d059d@ozlabs.ru>
MIME-Version: 1.0
Message-Id: <1641870717.tcavxuxzck.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Alexey Kardashevskiy's message of January 11, 2022 9:51 am:
>=20
>=20
> On 1/10/22 18:36, Nicholas Piggin wrote:
>> Excerpts from Fabiano Rosas's message of January 8, 2022 7:00 am:
>>> If MMIO emulation fails we don't want to crash the whole guest by
>>> returning to userspace.
>>>
>>> The original commit bbf45ba57eae ("KVM: ppc: PowerPC 440 KVM
>>> implementation") added a todo:
>>>
>>>    /* XXX Deliver Program interrupt to guest. */
>>>
>>> and later the commit d69614a295ae ("KVM: PPC: Separate loadstore
>>> emulation from priv emulation") added the Program interrupt injection
>>> but in another file, so I'm assuming it was missed that this block
>>> needed to be altered.
>>>
>>> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
>>> Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>>> ---
>>>   arch/powerpc/kvm/powerpc.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
>>> index 6daeea4a7de1..56b0faab7a5f 100644
>>> --- a/arch/powerpc/kvm/powerpc.c
>>> +++ b/arch/powerpc/kvm/powerpc.c
>>> @@ -309,7 +309,7 @@ int kvmppc_emulate_mmio(struct kvm_vcpu *vcpu)
>>>   		kvmppc_get_last_inst(vcpu, INST_GENERIC, &last_inst);
>>>   		kvmppc_core_queue_program(vcpu, 0);
>>>   		pr_info("%s: emulation failed (%08x)\n", __func__, last_inst);
>>> -		r =3D RESUME_HOST;
>>> +		r =3D RESUME_GUEST;
>>=20
>> So at this point can the pr_info just go away?
>>=20
>> I wonder if this shouldn't be a DSI rather than a program check.
>> DSI with DSISR[37] looks a bit more expected. Not that Linux
>> probably does much with it but at least it would give a SIGBUS
>> rather than SIGILL.
>=20
> It does not like it is more expected to me, it is not about wrong memory=20
> attributes, it is the instruction itself which cannot execute.

It's not an illegal instruction though, it can't execute because of the
nature of the data / address it is operating on. That says d-side to me.

DSISR[37] isn't perfect but if you squint it's not terrible. It's about
certain instructions that have restrictions operating on other than
normal cacheable mappings.

Thanks,
Nick


>=20
> DSISR[37]:
> Set to 1 if the access is due to a lq, stq, lwat, ldat, lbarx, lharx,=20
> lwarx, ldarx, lqarx, stwat,
> stdat, stbcx., sthcx., stwcx., stdcx., or stqcx. instruction that=20
> addresses storage that is Write
> Through Required or Caching Inhibited; or if the access is due to a copy=20
> or paste. instruction
> that addresses storage that is Caching Inhibited; or if the access is=20
> due to a lwat, ldat, stwat, or
> stdat instruction that addresses storage that is Guarded; otherwise set=20
> to 0.
>=20
