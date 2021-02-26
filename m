Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13AB326A94
	for <lists+kvm-ppc@lfdr.de>; Sat, 27 Feb 2021 01:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhB0AAn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 26 Feb 2021 19:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhB0AAn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 26 Feb 2021 19:00:43 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126F1C061574
        for <kvm-ppc@vger.kernel.org>; Fri, 26 Feb 2021 16:00:03 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id c19so6917904pjq.3
        for <kvm-ppc@vger.kernel.org>; Fri, 26 Feb 2021 16:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=q02clYmBzkhA5KqgdXouRwP+oXWTfl58JTIK8ZTCmTY=;
        b=YXHe0DQn4b6+dqgikiXwYRMKXIV1X+48BP/H/CaXof+vJvD/amZ5QS6A98n+ta0lYy
         7kcyZONlhBJYCjHJPBs7tH/lZHx+gbaeYloCx3JA9h6h31AsGu8MmynY446IabBan1CK
         EQPXahRCRQ4aipd5iwbw1hkBbgSR4ymONQ1+qa5xhJloTYkFs+44VMs83Ny4DLWOhJfc
         p0WNMZNwn9P48ckU+icl3dR5FU1Soo6/J3kS10SOdSS0D24ZnxcQT7h42NtLSGmp0qJR
         RZ7l15YV8Ybq/1e89GRD/xHgTGrxVltuuCNVlYxBaELUXfysMYaHdyuCLdRX5pTKiTfy
         PCPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=q02clYmBzkhA5KqgdXouRwP+oXWTfl58JTIK8ZTCmTY=;
        b=eFx2vJKpH2IrJPgKD0qa4gEuBpKDXCzThQG8PEt9QzVRR7fIT5fWS9PRpZyC+Tr6X7
         ctfEZU85erzukpUYRGeeXv23OeywxB22DVveGXKMkhW1kE8ZHZvG8/FTEEZ1AAcs7rr7
         kmPH/z+OUL/EtDAmzkRP/aQOr88uUAk3kupUZ92imNVbhS/swg062zYZIH57xjlA+eZB
         nT3Bv4/8bBt2VuYHt2wo712YGG5EuiKjt1Oh0h23mo6L8RirfDZSOnvP99IzEgVmFrRH
         4uqnrV+JC7wxvboXTlkO9WHWxG58PwlaHebH8SmjFCNPTVcfLVkiv92lOlZvpc5Yeb3i
         W8LA==
X-Gm-Message-State: AOAM532J0y7CYHTsDhEUMxYEi6nsmj22LFmPWz9ir9WtCNG1vD5fX16C
        q3NYqYxhKz4QtmPQN1HXCWw=
X-Google-Smtp-Source: ABdhPJzd713AUpA/1Snjwu12meI0pB6TlIXc+LXz9tfvjOqxFXD/6jF06ddyvunz+QQrm+07XdeQFA==
X-Received: by 2002:a17:90a:8901:: with SMTP id u1mr5689828pjn.21.1614384002713;
        Fri, 26 Feb 2021 16:00:02 -0800 (PST)
Received: from localhost (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id gm13sm9940265pjb.47.2021.02.26.16.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 16:00:02 -0800 (PST)
Date:   Sat, 27 Feb 2021 09:59:57 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 17/37] KVM: PPC: Book3S HV P9: Move setting HDEC after
 switching to guest LPCR
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210225134652.2127648-1-npiggin@gmail.com>
        <20210225134652.2127648-18-npiggin@gmail.com> <8735xiyebs.fsf@linux.ibm.com>
In-Reply-To: <8735xiyebs.fsf@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1614383980.ftu5gtbvbm.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of February 27, 2021 2:38 am:
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
>> LPCR[HDICE]=3D0 suppresses hypervisor decrementer exceptions on some
>> processors, so it must be enabled before HDEC is set.
>>
>> Rather than set it in the host LPCR then setting HDEC, move the HDEC
>> update to after the guest MMU context (including LPCR) is loaded.
>> There shouldn't be much concern with delaying HDEC by some 10s or 100s
>> of nanoseconds by setting it a bit later.
>>
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>>  arch/powerpc/kvm/book3s_hv.c | 24 ++++++++++--------------
>>  1 file changed, 10 insertions(+), 14 deletions(-)
>>
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index d4770b222d7e..63cc92c45c5d 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -3490,23 +3490,13 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_=
vcpu *vcpu, u64 time_limit,
>>  		host_dawrx1 =3D mfspr(SPRN_DAWRX1);
>>  	}
>>
>> -	/*
>> -	 * P8 and P9 suppress the HDEC exception when LPCR[HDICE] =3D 0,
>> -	 * so set HDICE before writing HDEC.
>> -	 */
>> -	mtspr(SPRN_LPCR, kvm->arch.host_lpcr | LPCR_HDICE);
>> -	isync();
>> -
>> -	hdec =3D time_limit - mftb();
>=20
> Would it be possible to leave the mftb() in this patch and then replace
> them all at once in patch 20/37 - "KVM: PPC: Book3S HV P9: Reduce mftb
> per guest entry/exit"?

I suppose that makes sense. I'll see how that looks.

Thanks,
Nick
