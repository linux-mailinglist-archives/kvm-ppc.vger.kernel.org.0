Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE223A39AD
	for <lists+kvm-ppc@lfdr.de>; Fri, 11 Jun 2021 04:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhFKC1K (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 10 Jun 2021 22:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbhFKC1J (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 10 Jun 2021 22:27:09 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74877C061574
        for <kvm-ppc@vger.kernel.org>; Thu, 10 Jun 2021 19:24:57 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id s14so3187918pfd.9
        for <kvm-ppc@vger.kernel.org>; Thu, 10 Jun 2021 19:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=lWU4Vw0CGzQdddd7531AABGYy3FLb0CgVBwzysYGHYA=;
        b=I6ibkR1f0h0wumnTnmTl44RwOrJeQ04rA21yaUsHN0zd0m9JbQc+v0uw9/gE62YLcz
         CklpqIuzOcj1S3pvKA+fyfdsheWl3CJLU8H1PfXUHzgCvHpPY8MU7Uf6kfbF181q6pX3
         IunZswNAMoSi/XRgUCBVU4Shg/NRVsElcZGOCgsyIwZh/tF5JmxO9B75pTf8Cwos/oDg
         QKCkxxqQ99Xqc3cI6T8d3fa/sg3VvaNq8s/PoWIP3d5g58z3ARISNbxPnSjXFbElv502
         Kz5K+iVH0j0EojnZqJbI70iPouED4wauLPGM7hg6PlP0gaKyHDdP43A22/CSZvmkeVQV
         kV4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=lWU4Vw0CGzQdddd7531AABGYy3FLb0CgVBwzysYGHYA=;
        b=OXYKCD4SvSnYovhnTB+UKBLSqSCJtpTrt2bubFiBrotvnh+zLi5hpGNN+tII7iEynn
         DRXw+ElD6axJCjujgqAqvbknXDFxq6eA8Ap+S4o/WDXkFokHNHzLn5THHbTWwLvC4foJ
         RbCzJY/3n6MDsfh6MOlpua8BGZU1BBPCCKlfo23+U2B6EeIQtZQ6e3TUYUSm5mL4PSA9
         mNf4iCcl09jg+IsL25XDLk8g5YH5vXi/DByEmotW8mN3R/Viog/e/XiXCr15y/9KkR3E
         IBTdAmS2IV0rPK4+aDbDM+e8eJVsZY6Q4efERvD5DYqUIcyzbGnzF9eF8pC2hyg9wliD
         l9jg==
X-Gm-Message-State: AOAM532D9ovZp3PilI8bD6JrKYa1WUgziONAFhjplXNcfp2MiwOmMcYu
        7admND4g2PF277kvmjH9LZ4=
X-Google-Smtp-Source: ABdhPJz57Cm9SUiVdKRM7MoGvcOhd0hkvt4CITORQXOWGm2kw0Vh1lSZXAwJIWizsPnbtxdb7qifbQ==
X-Received: by 2002:a62:5547:0:b029:2ec:8f20:4e2 with SMTP id j68-20020a6255470000b02902ec8f2004e2mr5913590pfb.71.1623378294499;
        Thu, 10 Jun 2021 19:24:54 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id f17sm3668935pgm.37.2021.06.10.19.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 19:24:53 -0700 (PDT)
Date:   Fri, 11 Jun 2021 12:24:48 +1000
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
        <1621464963.g8v9ejlhyh.astroid@bobo.none>
        <f437d727-8bc7-6467-6134-4e84942628f1@xenosoft.de>
        <b3821ab6-f3b4-ee51-93a2-064c09bc4278@xenosoft.de>
In-Reply-To: <b3821ab6-f3b4-ee51-93a2-064c09bc4278@xenosoft.de>
MIME-Version: 1.0
Message-Id: <1623377186.j5de3q1s8g.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Christian Zigotzky's message of June 7, 2021 5:21 pm:
> On 02 June 2021 at 01:26pm, Christian Zigotzky wrote:
>> On 20 May 2021 at 01:07am, Nicholas Piggin wrote:
>>> Hmm, okay that probably rules out those notifier changes then.
>>> Can you remind me were you able to rule these out as suspects?
>>>
>>> 8f6cc75a97d1 powerpc: move norestart trap flag to bit 0
>>> 8dc7f0229b78 powerpc: remove partial register save logic
>>> c45ba4f44f6b powerpc: clean up do_page_fault
>>> d738ee8d56de powerpc/64e/interrupt: handle bad_page_fault in C
>>> ceff77efa4f8 powerpc/64e/interrupt: Use new interrupt context=20
>>> tracking scheme
>>> 097157e16cf8 powerpc/64e/interrupt: reconcile irq soft-mask state in C
>>> 3db8aa10de9a powerpc/64e/interrupt: NMI save irq soft-mask state in C
>>> 0c2472de23ae powerpc/64e/interrupt: use new interrupt return
>>> dc6231821a14 powerpc/interrupt: update common interrupt code for
>>> 4228b2c3d20e powerpc/64e/interrupt: always save nvgprs on interrupt
>>> 5a5a893c4ad8 powerpc/syscall: switch user_exit_irqoff and=20
>>> trace_hardirqs_off order
>>>
>>> Thanks,
>>> Nick
>> Hi Nick,
>>
>> I tested these commits above today and all works with -smp 4. [1]
>>
>> Smp 4 still doesn't work with the RC4 of kernel 5.13 on quad core=20
>> e5500 CPUs with KVM HV. I use -smp 3 currently.
>>
>> What shall I test next?
>>
>> Thanks,
>> Christian
>>
>> [1] https://forum.hyperion-entertainment.com/viewtopic.php?p=3D53367#p53=
367
> Hi All,
>=20
> I tested the RC5 of kernel 5.13 today. Unfortunately the KVM HV issue=20
> still exists.
> I also figured out, that '-smp 2' doesn't work either.
>=20
> Summary:
>=20
> -smp 1 -> works
> -smp 2 -> doesn't work
> -smp 3 -> works
> -smp 4 -> doesn't work

Sorry, I'm not able to see anything, if the KVM patches were okay and=20
the 64e interrupt series. I don't know why the -smp behaviour would make

I can't think of why the -smp behaviour would make a difference except=20
for a strange race. Doing another bisect might be the only way to get
to the bottom of it.

But before that you could try get some data about why the guest stops?
Get some samples of CPU registers when it gets stuck and see if you can
see if it is stuck in a loop of interupts or something.

I don't know if qemu can log much from KVM execution so you might have
to just run info registers a dozen times on each CPU (`cpu 1` will=20
change to CPU 1 in the qemu monitor).

Thanks,
Nick
