Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFCB346E9D
	for <lists+kvm-ppc@lfdr.de>; Wed, 24 Mar 2021 02:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhCXBWs (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 23 Mar 2021 21:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234460AbhCXBWb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 23 Mar 2021 21:22:31 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971A5C061763
        for <kvm-ppc@vger.kernel.org>; Tue, 23 Mar 2021 18:22:31 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id c17so9259395pfn.6
        for <kvm-ppc@vger.kernel.org>; Tue, 23 Mar 2021 18:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=VLp0/dDyk4EjnBgHnzs0JikL651xSfQ2Nz2XUIvb9N4=;
        b=fLMWxkB3JDtH6E17o/W8rZ+8d0BOCXklBK52kmGAcny4yJ+aZYWfCMXZQ1aTbSzAIS
         nOpG3umXljOc8fJ9+MkU1WJjpAQBDOjbjF6Saa8t+FOmigrg1mIIislQieSKY3MhzxCu
         5/RYmIlr+BdZJwATUccj/66KRvqVJdgqzNrBmtICMcTMhUhiZ0OJW88wuDbvL2d460uY
         XwZwShYP5k3Keo2lBgeKYwtUsKA6iK5udId7YB8z+OkB9aG9OVb5ZE+PgahsWo+ZHCcV
         XQOcTUlzyTFUMP1vr5W1TxG6acvtEGlZEaz4qeYipFRg1i036/ekumpx5ChkepJ/ROEN
         sM+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=VLp0/dDyk4EjnBgHnzs0JikL651xSfQ2Nz2XUIvb9N4=;
        b=GRD5/6wamWMfhp0XHtmoS/UQkp8TBu5aZhRRbANKahzHP1797/OcqEC9btQfkpLRTR
         xNCFjtIZYPVW4tR+izzk2EAob0d4bVtosw7R1prLW8hVAsiBZHZNYVyhJBmKrjdBQ2pX
         k6N6gRn2mZnewgKzaFgRPZFYB2dC5yJLMwD70+shibNdOaBl0D8UGrw9hkJw451foqzV
         /b9bYP2JSXGHW9EFIqr0kKgW9PeDpmxtFz/p1DzHl0I/gJ5VsOa61TmahSedKcO9Ub7F
         yH2L2hwh6A1YTtLgBrG00xvxacYdm6UyWOjyF/9pfH/lBEJPByfxGJ9IQ3K1UOQyurUc
         E4qw==
X-Gm-Message-State: AOAM530Gj0AzUQ5OpuPiSbcz7inc3DQaCQD30NkDd1hpGCSgQuRyd3sr
        hNXnsHHZkrz3TklNdw0k8Ebv/AEoPAA=
X-Google-Smtp-Source: ABdhPJyfpFoUMy4L8Y8Bbw1hcDFGPQ8d98zEK++nehDthIzCF37Si42eFq1lC/447SPZnfJlWV8QKA==
X-Received: by 2002:aa7:990d:0:b029:21d:7aef:c545 with SMTP id z13-20020aa7990d0000b029021d7aefc545mr778385pff.77.1616548950944;
        Tue, 23 Mar 2021 18:22:30 -0700 (PDT)
Received: from localhost (193-116-197-97.tpgi.com.au. [193.116.197.97])
        by smtp.gmail.com with ESMTPSA id i1sm359645pfo.160.2021.03.23.18.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 18:22:30 -0700 (PDT)
Date:   Wed, 24 Mar 2021 11:22:25 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 22/46] KVM: PPC: Book3S HV P9: Stop handling hcalls in
 real-mode in the P9 path
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210323010305.1045293-1-npiggin@gmail.com>
        <20210323010305.1045293-23-npiggin@gmail.com> <871rc5g32x.fsf@linux.ibm.com>
In-Reply-To: <871rc5g32x.fsf@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1616548908.9uulj8jwq3.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of March 24, 2021 4:03 am:
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
>> In the interest of minimising the amount of code that is run in
>> "real-mode", don't handle hcalls in real mode in the P9 path.
>>
>> POWER8 and earlier are much more expensive to exit from HV real mode
>> and switch to host mode, because on those processors HV interrupts get
>> to the hypervisor with the MMU off, and the other threads in the core
>> need to be pulled out of the guest, and SLBs all need to be saved,
>> ERATs invalidated, and host SLB reloaded before the MMU is re-enabled
>> in host mode. Hash guests also require a lot of hcalls to run. The
>> XICS interrupt controller requires hcalls to run.
>>
>> By contrast, POWER9 has independent thread switching, and in radix mode
>> the hypervisor is already in a host virtual memory mode when the HV
>> interrupt is taken. Radix + xive guests don't need hcalls to handle
>> interrupts or manage translations.
>>
>> So it's much less important to handle hcalls in real mode in P9.
>>
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>=20
> I tried this again in the L2 with xive=3Doff and it works as expected now=
.
>=20
> Tested-by: Fabiano Rosas <farosas@linux.ibm.com>

Oh good, thanks for spotting the problem and re testing.

Thanks,
Nick

