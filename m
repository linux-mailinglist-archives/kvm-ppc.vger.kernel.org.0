Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE687381776
	for <lists+kvm-ppc@lfdr.de>; Sat, 15 May 2021 12:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbhEOKJd (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 15 May 2021 06:09:33 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:51663 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231432AbhEOKJd (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sat, 15 May 2021 06:09:33 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4Fj1LW2Hc7z9sZx;
        Sat, 15 May 2021 12:08:19 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 71uUNgqQvqJQ; Sat, 15 May 2021 12:08:19 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4Fj1LW17l1z9sZw;
        Sat, 15 May 2021 12:08:19 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id F03318B76E;
        Sat, 15 May 2021 12:08:18 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id DW0Ta4PfXQm9; Sat, 15 May 2021 12:08:18 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 67E7A8B765;
        Sat, 15 May 2021 12:08:18 +0200 (CEST)
Subject: Re: [FSL P50x0] KVM HV doesn't work anymore
To:     Christian Zigotzky <chzigotzky@xenosoft.de>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>
Cc:     Darren Stevens <darren@stevens-zone.net>,
        mad skateman <madskateman@gmail.com>,
        "R.T.Dickinson" <rtd2@xtra.co.nz>,
        Christian Zigotzky <info@xenosoft.de>
References: <04526309-4653-3349-b6de-e7640c2258d6@xenosoft.de>
 <34617b1b-e213-668b-05f6-6fce7b549bf0@xenosoft.de>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <9af2c1c9-2caf-120b-2f97-c7722274eee3@csgroup.eu>
Date:   Sat, 15 May 2021 12:08:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <34617b1b-e213-668b-05f6-6fce7b549bf0@xenosoft.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



Le 15/05/2021 à 11:48, Christian Zigotzky a écrit :
> Hi All,
> 
> I bisected today [1] and the bisecting itself was OK but the reverting of the bad commit doesn't 
> solve the issue. Do you have an idea which commit could be resposible for this issue? Maybe the 
> bisecting wasn't successful. I will look in the kernel git log. Maybe there is a commit that 
> affected KVM HV on FSL P50x0 machines.

If the uImage doesn't load, it may be because of the size of uImage.

See https://github.com/linuxppc/issues/issues/208

Is there a significant size difference with and without KVM HV ?

Maybe you can try to remove another option to reduce the size of the uImage.

Or if you are using gzipped uImage you can try with an lzma uImage. You can find a way to get an 
lzma uImage here: https://github.com/linuxppc/issues/issues/208#issuecomment-477479951

Christophe

> 
> Thanks,
> Christian
> 
> [1] https://forum.hyperion-entertainment.com/viewtopic.php?p=53209#p53209
> 
> On 14 May 2021 at 10:10 am, Christian Zigotzky wrote:
>> Hi All,
>>
>> The RC1 of kernel 5.13 doesn't boot in a virtual e5500 QEMU machine with KVM HV anymore. I see in 
>> the serial console that the uImage doesn't load. I use the following QEMU command for booting:
>>
>> qemu-system-ppc64 -M ppce500 -cpu e5500 -enable-kvm -m 1024 -kernel uImage-5.13 -drive 
>> format=raw,file=MintPPC32-X5000.img,index=0,if=virtio -netdev user,id=mynet0 -device 
>> e1000,netdev=mynet0 -append "rw root=/dev/vda" -device virtio-vga -device virtio-mouse-pci -device 
>> virtio-keyboard-pci -device pci-ohci,id=newusb -device usb-audio,bus=newusb.0 -smp 4
>>
>> The kernel boots without KVM HV.
>>
>> Have you already tested KVM HV with the kernel 5.13?
>>
>> Thanks,
>> Christian
>>
>>
