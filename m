Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB2A3871F5
	for <lists+kvm-ppc@lfdr.de>; Tue, 18 May 2021 08:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhERGfB (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 18 May 2021 02:35:01 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:18731 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhERGfA (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 18 May 2021 02:35:00 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1621319607; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=PBUelKX9f52bDZRaB2BR+uZaZFU9h/R6aVZw6YK+2osCe1jHpRS3iLoGhWJCPOwdXI
    bqlDv9cVLcX5Z9RmH6CLW8xem89Gs+e47JLrcWLkt4FwnqqX8T/gpjzCl1z64ngsZbMy
    0wnBTuwCI6e+rfxviTvW1O2Hjhrj/J19HUSPfAp5TlOP3PXno6aaWaLKQz9ZQ2sVjfPD
    Hf1Qo9HzNz+dmiC+07x9eb5SMRuV+5Hkislmc+uqcdxieKEk76teuCh7iIASFeWdKfbb
    w3qYO61y/4MuucLg4zVx2ViNv0lbGaC1ORKP3Hz01u4mUp6KalrOjMCiTP3yo5cB50Wo
    eXvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1621319607;
    s=strato-dkim-0002; d=strato.com;
    h=To:In-Reply-To:Cc:References:Message-Id:Date:Subject:From:Cc:Date:
    From:Subject:Sender;
    bh=/jlMH/n0JB9K6U94RowhlQ5JqXu9HQE9ziGYRVgBXLY=;
    b=LhvBvXLBcwg20SVbjFOOvgpxEd43RYtzZL2tUpVFlqNJWGw4i1AG1LlDNw9cC6Sixb
    cSbaZyA+2w4hRPxgl93KGdUtvWf4L6j8OhOVJRlAS0UvTC0nZfft/nG+/9wc+6/GchV2
    z8OTkWc4HbFgLaB79HMBXa7L2noDzuOWzp0cwsQzj9J8H2/yCHWgeWS38lW5Qpixt+Jn
    0P7ZEBAfqVDTeQRx1O5h+1ByKJg6d1X2sfoGPfGKBLjmndecYSrQGgR4oXLoWyTsYpQp
    Ai1a9WsBgILYaoH9Gad46C28o5Kirx9e46sC54hQrlaVTR7OGAWs227Ec4RwjmqHQ0Yn
    yBtg==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1621319607;
    s=strato-dkim-0002; d=xenosoft.de;
    h=To:In-Reply-To:Cc:References:Message-Id:Date:Subject:From:Cc:Date:
    From:Subject:Sender;
    bh=/jlMH/n0JB9K6U94RowhlQ5JqXu9HQE9ziGYRVgBXLY=;
    b=fyCdx9xTBxmI0jmMPuT2PKn3YJx7Sy97fNrg8NkaOIStqewzi2tithC1pguNzXIVua
    0KC+gSsJNCqTzNdKwHS0m7G0iBoZqHsBCttjaY+yYLRj5T2sLZqgZipDOGph+CcIy769
    QXaLwA3hvpMp9k+ssSJAVr8Sq9JMdE9i9ipgt+dsAMc6OEWZukIgMOuxz2c52/cQIuTw
    7IfDDQrjs4RiE3MDmeX+CuM3y5YHQay0V+sRFoSCtEQ63Qgs5dbxftfkWcempwxEc3Ms
    Mv5yNYqC6PWhh8FGuK2R0e1BQ693ghHIFOiivJA/2rs4HOTDXMvyIRs7MGL7ZYNOUbZU
    h1vg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGN0rBVhd9dFr6KxrfO5Oh7R7bGdwirpmzSCRZBtmg048aXyW7fONJ6crnoXUaLVc"
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a01:598:a011:39f7:79a7:a762:c241:3bc0]
    by smtp.strato.de (RZmta 47.26.1 AUTH)
    with ESMTPSA id K01586x4I6XR1Ue
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 18 May 2021 08:33:27 +0200 (CEST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
Mime-Version: 1.0 (1.0)
Subject: Re: [FSL P50x0] KVM HV doesn't work anymore
Date:   Tue, 18 May 2021 08:33:26 +0200
Message-Id: <F193DA31-4C74-4239-8F9B-E318F49BA3F0@xenosoft.de>
References: <e6ed7674-3df9-ec3e-8bcf-dcd8ff0fecf8@xenosoft.de>
Cc:     Darren Stevens <darren@stevens-zone.net>,
        Christian Zigotzky <info@xenosoft.de>,
        mad skateman <madskateman@gmail.com>,
        "R.T.Dickinson" <rtd2@xtra.co.nz>
In-Reply-To: <e6ed7674-3df9-ec3e-8bcf-dcd8ff0fecf8@xenosoft.de>
To:     Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        kvm-ppc@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
X-Mailer: iPhone Mail (18D70)
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



> On 17. May 2021, at 11:43, Christian Zigotzky <chzigotzky@xenosoft.de> wro=
te:
>=20
> =EF=BB=BFOn 17 May 2021 at 09:42am, Nicholas Piggin wrote:
>> Excerpts from Christian Zigotzky's message of May 15, 2021 11:46 pm:
>>> On 15 May 2021 at 12:08pm Christophe Leroy wrote:
>>>>=20
>>>>> Le 15/05/2021 =C3=A0 11:48, Christian Zigotzky a =C3=A9crit :
>>>>>> Hi All,
>>>>>>=20
>>>>>> I bisected today [1] and the bisecting itself was OK but the
>>>>>> reverting of the bad commit doesn't solve the issue. Do you have an
>>>>>> idea which commit could be resposible for this issue? Maybe the
>>>>>> bisecting wasn't successful. I will look in the kernel git log. Maybe=

>>>>>> there is a commit that affected KVM HV on FSL P50x0 machines.
>>>>> If the uImage doesn't load, it may be because of the size of uImage.
>>>>>=20
>>>>> See https://github.com/linuxppc/issues/issues/208
>>>>>=20
>>>>> Is there a significant size difference with and without KVM HV ?
>>>>>=20
>>>>> Maybe you can try to remove another option to reduce the size of the
>>>>> uImage.
>>> I tried it but it doesn't solve the issue. The uImage works without KVM
>>> HV in a virtual e5500 QEMU machine.
>> Any more progress with this? I would say that bisect might have just
>> been a bit unstable and maybe by chance some things did not crash so
>> it's pointing to the wrong patch.
>>=20
>> Upstream merge of powerpc-5.13-1 was good and powerpc-5.13-2 was bad?
>>=20
>> Between that looks like some KVM MMU rework. You could try the patch
>> before this one b1c5356e873c ("KVM: PPC: Convert to the gfn-based MMU
>> notifier callbacks"). That won't revert cleanly so just try run the
>> tree at that point. If it works, test the patch and see if it fails.
>>=20
>> Thanks,
>> Nick
> Hi Nick,
>=20
> Thanks a lot for your answer. Yes, there is a little bit of progress. The R=
C2 of kernel 5.13 successfully boots with -smp 3 in a virtual e5500 QEMU mac=
hine.
> -smp 4 doesn't work anymore since the PowerPC updates 5.13-2. I used -smp 4=
 before 5.13 because my FSL P5040 machine has 4 cores.
>=20
> Could you please post a patch for reverting the commit before b1c5356e873c=
 ("KVM: PPC: Convert to the gfn-based MMU notifier callbacks")?
>=20
> Thanks in advance,
>=20
> Christian
>=20
>=20
For me it is ok to work with -smp 1, 2, and 3 but I am curious why -smp 4 do=
esn=E2=80=99t work.

-Christian=

