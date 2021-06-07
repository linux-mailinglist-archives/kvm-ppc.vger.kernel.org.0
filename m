Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B87639D5E1
	for <lists+kvm-ppc@lfdr.de>; Mon,  7 Jun 2021 09:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhFGHX7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 7 Jun 2021 03:23:59 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:12228 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbhFGHX6 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 7 Jun 2021 03:23:58 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1623050518; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=UMTAZywUI9wD+8SScPKMrRP/ZWJMg9tGRVML6z61uNnuYZhspiKD2nMKMqOaCmVwX0
    L+XuhDz73MQaGq+5HCXVX6yTb3es4gsZ8qHxTMq+Te5QmyX9BvtnEg9Pt37bon2HTH/Q
    tilgVOhVHV8Djxul84W+op78qgpWjHvCapvDHNqZt2gKSCR88njLA6vnDW1OnHT+YUEo
    c1/PfSltN2UPeZAX7rehVBuStbuuCHgfdZSmy/VOhGjXTZUCS1+cVk8KrdFhiYJYO1kl
    piNWvrQQ3Ocvbi0s/dhYz753gypv1tNTFIjTY1qsX/5BSL8P22k62ahrQRvFiyq3K25Y
    GI/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1623050518;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:Date:Message-ID:References:Cc:To:From:Subject:Cc:Date:
    From:Subject:Sender;
    bh=MVlqXk2aYeDOOWrW5A5tD2Ftk3uhNDcY4tSxE/lqIhM=;
    b=FeLUst9DBmkuvFf6TAXuymo8ZemWJf4VR3PKSn/MtiDg1a9osh3lV+W9l+RocT1+RY
    LbUWsfYY6ZAaAapUvOEbj29f6kIOXiRxlMgmtxVelIsx3W0EgYEEJps1gLIWzQeTwGOR
    WQ3WF9Grt32j+jv6Z/n52o9pYBs223TvsTQXNB+CuL2vvHHG2pnpFKHPRQ214RdqN25P
    Jc+LdlirlqPiKQqMoAavkYqcgwF7ZxgkG66AsrA4OzBNEZukNum233ISgmK1XZ9BpPsh
    FvxIPMTO9wn6Kppu6XEDOBhKdAuStAtIDzDsmf5zx/uXtpMNeI9+KSDD+RL2yBXVNXCN
    qtcQ==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1623050518;
    s=strato-dkim-0002; d=xenosoft.de;
    h=In-Reply-To:Date:Message-ID:References:Cc:To:From:Subject:Cc:Date:
    From:Subject:Sender;
    bh=MVlqXk2aYeDOOWrW5A5tD2Ftk3uhNDcY4tSxE/lqIhM=;
    b=VSO26Xmo3DrQ6GfbXnj2xqVpY2m/AwD5+swaZLkOkYoO+HvQXgKngEx636+9yPfZzs
    VJwlaXk8sxkNtF+Y0C3QzlT3foe+yanqOtxnsKAAsms0SQF9f3F76/VuKjXyo6w2x4Er
    OBxH4P9gwOayUZ/cSNhYYuxzEUjBGKyQBoGmNt7Qdj8YtoEeAFU4XGliE8wAoO2zlaUF
    HnCBAUSJnCEatZrfmyudRLjU4T+9+nz8Fc+GaqEtCBwK0AjNLFNzmcnY1eHPUBRfxkSd
    2KP0AszUiElDqBPceyFtCiJDUt0/7nw/MljHbiEalNIoMeX9j+bftPYVcp8AhFRVuo64
    E9MA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGM4l4Hio94KKxRySfLxnHfJ+Dkjp5DdBJSrwuuqxvPhULn4zoao3L+5CMtRE44O5k1jhlw=="
X-RZG-CLASS-ID: mo00
Received: from Christians-iMac.fritz.box
    by smtp.strato.de (RZmta 47.27.2 AUTH)
    with ESMTPSA id g069fax577LwFLs
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 7 Jun 2021 09:21:58 +0200 (CEST)
Subject: Re: [FSL P50x0] KVM HV doesn't work anymore
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
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
 <e6ed7674-3df9-ec3e-8bcf-dcd8ff0fecf8@xenosoft.de>
 <1621410977.cgh0d6nvlo.astroid@bobo.none>
 <acf63821-2030-90fa-f178-b2baeb0c4784@xenosoft.de>
 <1621464963.g8v9ejlhyh.astroid@bobo.none>
 <f437d727-8bc7-6467-6134-4e84942628f1@xenosoft.de>
Message-ID: <b3821ab6-f3b4-ee51-93a2-064c09bc4278@xenosoft.de>
Date:   Mon, 7 Jun 2021 09:21:58 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <f437d727-8bc7-6467-6134-4e84942628f1@xenosoft.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: de-DE
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 02 June 2021 at 01:26pm, Christian Zigotzky wrote:
> On 20 May 2021 at 01:07am, Nicholas Piggin wrote:
>> Hmm, okay that probably rules out those notifier changes then.
>> Can you remind me were you able to rule these out as suspects?
>>
>> 8f6cc75a97d1 powerpc: move norestart trap flag to bit 0
>> 8dc7f0229b78 powerpc: remove partial register save logic
>> c45ba4f44f6b powerpc: clean up do_page_fault
>> d738ee8d56de powerpc/64e/interrupt: handle bad_page_fault in C
>> ceff77efa4f8 powerpc/64e/interrupt: Use new interrupt context 
>> tracking scheme
>> 097157e16cf8 powerpc/64e/interrupt: reconcile irq soft-mask state in C
>> 3db8aa10de9a powerpc/64e/interrupt: NMI save irq soft-mask state in C
>> 0c2472de23ae powerpc/64e/interrupt: use new interrupt return
>> dc6231821a14 powerpc/interrupt: update common interrupt code for
>> 4228b2c3d20e powerpc/64e/interrupt: always save nvgprs on interrupt
>> 5a5a893c4ad8 powerpc/syscall: switch user_exit_irqoff and 
>> trace_hardirqs_off order
>>
>> Thanks,
>> Nick
> Hi Nick,
>
> I tested these commits above today and all works with -smp 4. [1]
>
> Smp 4 still doesn't work with the RC4 of kernel 5.13 on quad core 
> e5500 CPUs with KVM HV. I use -smp 3 currently.
>
> What shall I test next?
>
> Thanks,
> Christian
>
> [1] https://forum.hyperion-entertainment.com/viewtopic.php?p=53367#p53367
Hi All,

I tested the RC5 of kernel 5.13 today. Unfortunately the KVM HV issue 
still exists.
I also figured out, that '-smp 2' doesn't work either.

Summary:

-smp 1 -> works
-smp 2 -> doesn't work
-smp 3 -> works
-smp 4 -> doesn't work

Cheers,
Christian
