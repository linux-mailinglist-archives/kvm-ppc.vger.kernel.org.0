Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23DEE38289D
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 May 2021 11:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbhEQJoL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 17 May 2021 05:44:11 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:27289 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236192AbhEQJoL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 17 May 2021 05:44:11 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1621244566; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Bb80fHfWsl2as0Bzja3tmAaZ9msvugut1/sG21fSivbAd+Ci5k77xAo1vY49KvSfgL
    0p1ngQsBhhrOgCyHGtGJt7POPNMLCrSwCP7FmFYtj4UEeG6UrKB+2V+THYr5/sTQ8pHg
    r1L90+LASdtNq/zM+pNkqkVifhFFcZNc02UaNyRHHBg3dCBrC3uLnqAEmO7NC9UcYjw+
    kjnO3Xq+09ADSVK4eWN86kCuCWI3x8UVM5XBeSFnS0YgZ8OpPqU6PMDrTyDUgQgRe7l/
    MohnAOn0DN8gIkZEQjGd9HC8NIaespq7X2HMW7tchJRsGvqXKX0Qj9s83U0Wr0t4glAH
    f80Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1621244566;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=Rl/Gdkc7egQWIBOSMIJX1XaY9AiyuXx2nuAj0o6wsks=;
    b=GbXH6pkiDdNME/8kFE6Qgu3m1019Wh/liU76uViiBP95222qAhDpDa7NJlV6Vqev71
    fOXPzyMrQ/nf3aiYwmn6NSitros3S/UylHr5EKMGOZ3SZJ73f4iibNixWEPo+x40cmaI
    2WmN9/vcSZztAAE6GSJXwK7JXvqLs+O25/zMM5IO3+k/vIHJoHebeEIONdAxTQHk5nax
    z97Ga1P153ZgFz4kaLzGY/HPejuGbojafCwD94sykMSX3SLV2FMGAb6C7sL4PZLC5w+m
    TFpjwvmyjw1b00bhuL2aSf/qz7yPAOTL8hyTBbJL5eGCecSnh4q84O7QVEFbjLPcx8Qc
    b6WQ==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1621244566;
    s=strato-dkim-0002; d=xenosoft.de;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=Rl/Gdkc7egQWIBOSMIJX1XaY9AiyuXx2nuAj0o6wsks=;
    b=b8luP57gpmrZBcfUwwdMzFRTcocewx8zMH8sYzg/rMu7djzRfVaOPgagdkh2b2hNk1
    IXPyIVybF5pmseiY4Psw66sZ818HgedyFsIG/8uG38vhnYXAEy3rhgKMzDEx9OxsOo2b
    JolbvIS4ZDkobhCeK0QWL34vUXsTsvkq2mXdAR6FklDAcfMQc4Iblh1hTtCV6qMcV9zy
    CSj1XROYuldh+sNEcqgp0QDVL9iTKYrZr08jpsJJBIoFnj1yXqP2tEof4WxxpO6vJVN9
    e91+l1MaKn+s6p8rmBMBbXIr6Qvw0Eixs3N/6pnbS6tkJHYh2udlv9zYAZEq3RQbMaZ2
    wyXw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGM4l4Hio94KKxRySfLxnHfJ+Dkjp5DdBJSrwuuqxvPhbL1/HFNrQWNLFP5JgxJd3+MH2JA=="
X-RZG-CLASS-ID: mo00
Received: from Christians-iMac.fritz.box
    by smtp.strato.de (RZmta 47.26.0 AUTH)
    with ESMTPSA id f051dfx4H9gj0nU
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 17 May 2021 11:42:45 +0200 (CEST)
Subject: Re: [FSL P50x0] KVM HV doesn't work anymore
To:     Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
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
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
Message-ID: <e6ed7674-3df9-ec3e-8bcf-dcd8ff0fecf8@xenosoft.de>
Date:   Mon, 17 May 2021 11:42:45 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1621236734.xfc1uw04eb.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: de-DE
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 17 May 2021 at 09:42am, Nicholas Piggin wrote:
> Excerpts from Christian Zigotzky's message of May 15, 2021 11:46 pm:
>> On 15 May 2021 at 12:08pm Christophe Leroy wrote:
>>>
>>> Le 15/05/2021 à 11:48, Christian Zigotzky a écrit :
>>>> Hi All,
>>>>
>>>> I bisected today [1] and the bisecting itself was OK but the
>>>> reverting of the bad commit doesn't solve the issue. Do you have an
>>>> idea which commit could be resposible for this issue? Maybe the
>>>> bisecting wasn't successful. I will look in the kernel git log. Maybe
>>>> there is a commit that affected KVM HV on FSL P50x0 machines.
>>> If the uImage doesn't load, it may be because of the size of uImage.
>>>
>>> See https://github.com/linuxppc/issues/issues/208
>>>
>>> Is there a significant size difference with and without KVM HV ?
>>>
>>> Maybe you can try to remove another option to reduce the size of the
>>> uImage.
>> I tried it but it doesn't solve the issue. The uImage works without KVM
>> HV in a virtual e5500 QEMU machine.
> Any more progress with this? I would say that bisect might have just
> been a bit unstable and maybe by chance some things did not crash so
> it's pointing to the wrong patch.
>
> Upstream merge of powerpc-5.13-1 was good and powerpc-5.13-2 was bad?
>
> Between that looks like some KVM MMU rework. You could try the patch
> before this one b1c5356e873c ("KVM: PPC: Convert to the gfn-based MMU
> notifier callbacks"). That won't revert cleanly so just try run the
> tree at that point. If it works, test the patch and see if it fails.
>
> Thanks,
> Nick
Hi Nick,

Thanks a lot for your answer. Yes, there is a little bit of progress. 
The RC2 of kernel 5.13 successfully boots with -smp 3 in a virtual e5500 
QEMU machine.
-smp 4 doesn't work anymore since the PowerPC updates 5.13-2. I used 
-smp 4 before 5.13 because my FSL P5040 machine has 4 cores.

Could you please post a patch for reverting the commit before 
b1c5356e873c ("KVM: PPC: Convert to the gfn-based MMU notifier callbacks")?

Thanks in advance,

Christian


