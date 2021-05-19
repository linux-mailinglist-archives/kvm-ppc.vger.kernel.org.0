Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234823888D1
	for <lists+kvm-ppc@lfdr.de>; Wed, 19 May 2021 09:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbhESH6d (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 19 May 2021 03:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243639AbhESH6d (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 19 May 2021 03:58:33 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D688C06175F
        for <kvm-ppc@vger.kernel.org>; Wed, 19 May 2021 00:57:14 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b13-20020a17090a8c8db029015cd97baea9so3122390pjo.0
        for <kvm-ppc@vger.kernel.org>; Wed, 19 May 2021 00:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=KhG7DdiIupXeHhCtT3OzrIBr8xIgzyTCtv60R9AOj28=;
        b=OR0eliZr0wy/juooXT/WN9fNlZ1v+u38YQwZuxS0rVatYjKFsRf9/Lz33Y15Tvki+D
         0YhA0mtJF8GYUcmnT4LflZv06fK+up0uZrCxcXfsRySFKMfkwR3nNHd40WNXYzGq1gVS
         Y9ofSfBi2bvTI0nY/7PO0/js4np2UQlIdMWPwAO/e+oABp52H6GKs4eqk6+AEvfvYXCW
         qo8mCljXrRnBN4yGKow6W3yT5lHJysfgy5YZOM8mKM2eVu7gnklYhMNmvzTQzBi1b4Ix
         0KBRJ/9A/NjqnSyEiOFSlUOuF8q9FejwqkwMUVMT9F9vwril5flxM4gH0RpKkhliduOZ
         dB2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=KhG7DdiIupXeHhCtT3OzrIBr8xIgzyTCtv60R9AOj28=;
        b=rhCtS0vfc4Zqk8FxeSwc2vT+8+MmFJux+0A62pPHKy0HgQKjuB4J2wr6o4H7iDZOj2
         UobV93IHle/HbdUB5p5ExMLUZyRVqZfrLMBGyPT2ZpR493iriV3YbNiM+Q7nKHjp2Bzt
         Ma2bmbM5s5ZZPOy1gLAjCAWn+v1obT5Oduzkm1/aa9P7MSodD4l5e/pq6Lbl4u9gTXYy
         q8yTWVmSumpVA3d4owed7qlN9LRhN/ToroTYpx/WOIm8dEKR0sFQ8v4NDV6A3tBaHNRa
         QUb8082vssip9ixAioxHSiJM3gIO125c6XwEnfB7KA5KoUPO0xe6hOUVBCwz3qF3R0TB
         wWag==
X-Gm-Message-State: AOAM5314zrIgxnScuMGlCr/7pbZ1N1L1fJAvJmWwMLHjuJVvMMnWP7V9
        Sgw3zHcynFugIYIL/RrghKw=
X-Google-Smtp-Source: ABdhPJwodw2G3AahH5x15v3WvTxAdf5SvVJDcjC0WYbwBARN1Msn6qODLQ/HYJ6/ayY/vCex5tJS2Q==
X-Received: by 2002:a17:902:e04f:b029:eb:66b0:6d08 with SMTP id x15-20020a170902e04fb02900eb66b06d08mr9485408plx.50.1621411033621;
        Wed, 19 May 2021 00:57:13 -0700 (PDT)
Received: from localhost (14-201-155-8.tpgi.com.au. [14.201.155.8])
        by smtp.gmail.com with ESMTPSA id n20sm14926827pjq.45.2021.05.19.00.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 00:57:13 -0700 (PDT)
Date:   Wed, 19 May 2021 17:57:08 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [FSL P50x0] KVM HV doesn't work anymore
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Christian Zigotzky <chzigotzky@xenosoft.de>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Darren Stevens <darren@stevens-zone.net>,
        Christian Zigotzky <info@xenosoft.de>,
        mad skateman <madskateman@gmail.com>,
        "R.T.Dickinson" <rtd2@xtra.co.nz>
References: <04526309-4653-3349-b6de-e7640c2258d6@xenosoft.de>
        <34617b1b-e213-668b-05f6-6fce7b549bf0@xenosoft.de>
        <9af2c1c9-2caf-120b-2f97-c7722274eee3@csgroup.eu>
        <199da427-9511-34fe-1a9e-08e24995ea85@xenosoft.de>
        <1621236734.xfc1uw04eb.astroid@bobo.none>
        <e6ed7674-3df9-ec3e-8bcf-dcd8ff0fecf8@xenosoft.de>
In-Reply-To: <e6ed7674-3df9-ec3e-8bcf-dcd8ff0fecf8@xenosoft.de>
MIME-Version: 1.0
Message-Id: <1621410977.cgh0d6nvlo.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Christian Zigotzky's message of May 17, 2021 7:42 pm:
> On 17 May 2021 at 09:42am, Nicholas Piggin wrote:
>> Excerpts from Christian Zigotzky's message of May 15, 2021 11:46 pm:
>>> On 15 May 2021 at 12:08pm Christophe Leroy wrote:
>>>>
>>>> Le 15/05/2021 =C3=A0 11:48, Christian Zigotzky a =C3=A9crit=C2=A0:
>>>>> Hi All,
>>>>>
>>>>> I bisected today [1] and the bisecting itself was OK but the
>>>>> reverting of the bad commit doesn't solve the issue. Do you have an
>>>>> idea which commit could be resposible for this issue? Maybe the
>>>>> bisecting wasn't successful. I will look in the kernel git log. Maybe
>>>>> there is a commit that affected KVM HV on FSL P50x0 machines.
>>>> If the uImage doesn't load, it may be because of the size of uImage.
>>>>
>>>> See https://github.com/linuxppc/issues/issues/208
>>>>
>>>> Is there a significant size difference with and without KVM HV ?
>>>>
>>>> Maybe you can try to remove another option to reduce the size of the
>>>> uImage.
>>> I tried it but it doesn't solve the issue. The uImage works without KVM
>>> HV in a virtual e5500 QEMU machine.
>> Any more progress with this? I would say that bisect might have just
>> been a bit unstable and maybe by chance some things did not crash so
>> it's pointing to the wrong patch.
>>
>> Upstream merge of powerpc-5.13-1 was good and powerpc-5.13-2 was bad?
>>
>> Between that looks like some KVM MMU rework. You could try the patch
>> before this one b1c5356e873c ("KVM: PPC: Convert to the gfn-based MMU
>> notifier callbacks"). That won't revert cleanly so just try run the
>> tree at that point. If it works, test the patch and see if it fails.
>>
>> Thanks,
>> Nick
> Hi Nick,
>=20
> Thanks a lot for your answer. Yes, there is a little bit of progress.=20
> The RC2 of kernel 5.13 successfully boots with -smp 3 in a virtual e5500=20
> QEMU machine.
> -smp 4 doesn't work anymore since the PowerPC updates 5.13-2. I used=20
> -smp 4 before 5.13 because my FSL P5040 machine has 4 cores.
>=20
> Could you please post a patch for reverting the commit before=20
> b1c5356e873c ("KVM: PPC: Convert to the gfn-based MMU notifier callbacks"=
)?

You could `git checkout b1c5356e873c~1`

Thanks,
Nick
>=20
