Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3C13899A1
	for <lists+kvm-ppc@lfdr.de>; Thu, 20 May 2021 01:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhESXJU (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 19 May 2021 19:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhESXJT (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 19 May 2021 19:09:19 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571FDC061574
        for <kvm-ppc@vger.kernel.org>; Wed, 19 May 2021 16:07:58 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id b13-20020a17090a8c8db029015cd97baea9so4284373pjo.0
        for <kvm-ppc@vger.kernel.org>; Wed, 19 May 2021 16:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=cymZYvTpVQSrTcAXUybuDxB8tbOvF2n109X7Qd3QHII=;
        b=gC9WAZKA86C7gWqhb8VQik/Nw0aVcDfyRtgnUlSQUhYLb+icQldwNoYlZNHNWSKujx
         mMkCPDYMYrEaWepeJ9NpoPz0+do8WExDObJLAI6dVu/IAoRAnPh9WhUklCV+rrs40fsw
         V4q98u4GS+4aM1gaoFUbygPc0ST+S1aTIuZb5SzWTkB0W6CVQUFYGnAUZrI2iEgRx8DT
         UYaSatelKvAy3OZ9fYU98UdOnjaXFhr1mqydtIbUlQOgiZc2t1sQDAH6nEnzOdw6t1F4
         6KBQ0+gIPPwc0Ao5IR5PAcsPSOIrXeCprsfIjtU52w4RnJIrvgzQgwmkRIUzM6rYAi3m
         OW5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=cymZYvTpVQSrTcAXUybuDxB8tbOvF2n109X7Qd3QHII=;
        b=M2yDDmCZUxOLhQcevZ+nsHFe2xkRfcy3cCEuv7HCsUI/Bb7DUx+si4U1FCogA+VK1F
         EelZUg0IbiflF0v4og8sh9zj7SCvqemdS6yBtxFLljXi2nmy5HTPXmoOheCuTnDNoVjU
         ZQ51x/rsr4l26sLsx39vwIwtSZ7Mk4yHzRRodKrdPGb351verGFDt+7zJKbnVLxvyGkp
         FvPcbeOHpegjOtlU2FzoAxJXV5jvIChMklY703IFWmWdfSWfNm1YexEFvpYdgzvXnOZn
         oW6MjR51nEOxVCHXW8WtdDL3XqMGNOJMl6y7QNgprFzHNb+1UFnGVKv2VzDvQv7/aRfd
         X/Kw==
X-Gm-Message-State: AOAM5313eLOe+QqvhHb3jegqDrA8mJKEhkqbenw6ktCNMHghEoV4SpzN
        PiwYn9EDfPjd99YK3rWuFyGroJHO/dNZWQ==
X-Google-Smtp-Source: ABdhPJy+WYY8IkzRFV/hh4NfJvnY+fXH3wMeNL+ToKcyRCO3c3nZKI4q9nf0D2FNohwdwfn5U/Dgaw==
X-Received: by 2002:a17:902:dcce:b029:ef:339:fa6a with SMTP id t14-20020a170902dcceb02900ef0339fa6amr2130593pll.24.1621465677922;
        Wed, 19 May 2021 16:07:57 -0700 (PDT)
Received: from localhost (60-241-27-127.tpgi.com.au. [60.241.27.127])
        by smtp.gmail.com with ESMTPSA id ch24sm5254090pjb.18.2021.05.19.16.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 16:07:57 -0700 (PDT)
Date:   Thu, 20 May 2021 09:07:51 +1000
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
        <1621410977.cgh0d6nvlo.astroid@bobo.none>
        <acf63821-2030-90fa-f178-b2baeb0c4784@xenosoft.de>
In-Reply-To: <acf63821-2030-90fa-f178-b2baeb0c4784@xenosoft.de>
MIME-Version: 1.0
Message-Id: <1621464963.g8v9ejlhyh.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Christian Zigotzky's message of May 19, 2021 9:52 pm:
> On 19 May 2021 at 09:57 am, Nicholas Piggin wrote:
>> Excerpts from Christian Zigotzky's message of May 17, 2021 7:42 pm:
>>> On 17 May 2021 at 09:42am, Nicholas Piggin wrote:
>>>> Excerpts from Christian Zigotzky's message of May 15, 2021 11:46 pm:
>>>>> I tried it but it doesn't solve the issue. The uImage works without=20
>>>>> KVM
>>>>> HV in a virtual e5500 QEMU machine.
>>>> Any more progress with this? I would say that bisect might have just
>>>> been a bit unstable and maybe by chance some things did not crash so
>>>> it's pointing to the wrong patch.
>>>>
>>>> Upstream merge of powerpc-5.13-1 was good and powerpc-5.13-2 was bad?
>>>>
>>>> Between that looks like some KVM MMU rework. You could try the patch
>>>> before this one b1c5356e873c ("KVM: PPC: Convert to the gfn-based MMU
>>>> notifier callbacks"). That won't revert cleanly so just try run the
>>>> tree at that point. If it works, test the patch and see if it fails.
>>>>
>>>> Thanks,
>>>> Nick
>>> Hi Nick,
>>>
>>> Thanks a lot for your answer. Yes, there is a little bit of progress.
>>> The RC2 of kernel 5.13 successfully boots with -smp 3 in a virtual e550=
0
>>> QEMU machine.
>>> -smp 4 doesn't work anymore since the PowerPC updates 5.13-2. I used
>>> -smp 4 before 5.13 because my FSL P5040 machine has 4 cores.
>>>
>>> Could you please post a patch for reverting the commit before
>>> b1c5356e873c ("KVM: PPC: Convert to the gfn-based MMU notifier callback=
s")?
>> You could `git checkout b1c5356e873c~1`
>>
>> Thanks,
>> Nick
> Hi Nick,
>=20
> Thanks for your answer. I checked out the commit b1c5356e873c~1 (HEAD is=20
> now at d923ff258423 KVM: MIPS/MMU: Convert to the gfn-based MMU notifier=20
> callbacks).
> The kernel boots with '-smp 4' without any problems.
> After that I patched with the probable first bad commit (KVM: PPC:=20
> Convert to the gfn-based MMU notifier callbacks). The kernel also boots=20
> with this patch. That means, this isn't the first bad commit.
> Further information:=20
> https://forum.hyperion-entertainment.com/viewtopic.php?p=3D53267#p53267

Hmm, okay that probably rules out those notifier changes then.

Can you remind me were you able to rule these out as suspects?

8f6cc75a97d1 powerpc: move norestart trap flag to bit 0
8dc7f0229b78 powerpc: remove partial register save logic
c45ba4f44f6b powerpc: clean up do_page_fault
d738ee8d56de powerpc/64e/interrupt: handle bad_page_fault in C
ceff77efa4f8 powerpc/64e/interrupt: Use new interrupt context tracking sche=
me
097157e16cf8 powerpc/64e/interrupt: reconcile irq soft-mask state in C
3db8aa10de9a powerpc/64e/interrupt: NMI save irq soft-mask state in C
0c2472de23ae powerpc/64e/interrupt: use new interrupt return
dc6231821a14 powerpc/interrupt: update common interrupt code for
4228b2c3d20e powerpc/64e/interrupt: always save nvgprs on interrupt
5a5a893c4ad8 powerpc/syscall: switch user_exit_irqoff and trace_hardirqs_of=
f order

Thanks,
Nick
