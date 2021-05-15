Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D93381925
	for <lists+kvm-ppc@lfdr.de>; Sat, 15 May 2021 15:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbhEONrm (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 15 May 2021 09:47:42 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:31510 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbhEONrl (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 15 May 2021 09:47:41 -0400
X-Greylist: delayed 106508 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 May 2021 09:47:41 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1621086368; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=GtWoYOZY/6YEwLHO9iIjcg0ZHEMOVbCeqXm++qL0Q29vQBfIxAdOGsH6HVyadX4ulI
    r1hIYipFz2Bv2aYthhrxiMEbV464xDpxAoqjr0/ihLfgu6TMpUCPn/TeRiUQI5LavDo3
    nh/XaGzXXSJPnvqE3KNfI0PBcc1nuM0CvkV8r3rpWwg6Xyr1zmY4Ru/sIdn8Ylg/01yw
    wNPFL/JjLyywOYW9JBXIoJ+LFVdS5NYQg1kYq5DcTQo6NinUOY+65kOCiYDXfpEvu+No
    6d8SWJVQYqzYMYTct9pdCTVJkZ2ipg3Cx7Ej9aUJYZkG8CV9lFrar05FSGvBBNny0mHk
    9nRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1621086368;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=W8FOkPnYyh6UJtBaruAJNswDUw0QYZocwPT4lvzzJ5c=;
    b=UGwBymx79kxaQ9GU3OxlhRcE2qU65qmA1TEPyFW7POGF5OovNZvrStsJ+wgf53wsU6
    ECyFalgaw2/BkB6MIKXarR6F/NXeMIgT6B/hexBUSzFDzahCnrF6miuWMqzF7oIOnZ0r
    VdwOQi6IGu9QIDChitMt15pQqd9I6nKTq9nFBdB/NaZI0FFUOFbceSk/Ds48QaZX+D1J
    sHjk+zS/Q4SfxVie5rnqBn1d/wDFuWDiQVTp8KVwpG2F8t06IYb1aUIwVYQtyHxDo3OB
    9CVAK++r4nI3KAFnPC+o1LfpfRi6WIhKT/uRUZxtCSZ0XSi3/5M7Z2S6BowpPtko8JpC
    3Hig==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1621086368;
    s=strato-dkim-0002; d=xenosoft.de;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=W8FOkPnYyh6UJtBaruAJNswDUw0QYZocwPT4lvzzJ5c=;
    b=Xc/CMbHRE+xm+JLD3operOSS+0K5UyZlTvepO3gqqMD52859l0DKUpAdyMpq6j/vIu
    jWkq8QVEr9nzlqTFTTmzuKyHqmu+pJOb1eNKFuR9rDWaK9GQ8v49nzPf84KmLJdlK9s3
    x36RQlQIeYzsb05Foun9wwEQBuwtre0Rkm97mCjhEtEvAH4M93MRNpmHO3eX17tDEync
    Ues7rt+j4QC+hBPBNL9KykSX/JG8yZSjJjQLQMS3LAKGvo4FPfjj2He1xx+7qHJT+JGa
    G9UFWCSH+BaNhvbeIaAD/4jExhaDEMRb1AzQr0XEIomzxx203PSdnEqxOIRneWdspesx
    GI4A==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGM4l4Hio94KKxRySfLxnHfJ+Dkjp5DdBJSrwuuqxvPhVJ9j5ZEyMSeKih4K8vrU55j1KuA=="
X-RZG-CLASS-ID: mo00
Received: from Christians-iMac.fritz.box
    by smtp.strato.de (RZmta 47.25.9 AUTH)
    with ESMTPSA id n06826x4FDk70Sj
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sat, 15 May 2021 15:46:07 +0200 (CEST)
Subject: Re: [FSL P50x0] KVM HV doesn't work anymore
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>
Cc:     Darren Stevens <darren@stevens-zone.net>,
        mad skateman <madskateman@gmail.com>,
        "R.T.Dickinson" <rtd2@xtra.co.nz>,
        Christian Zigotzky <info@xenosoft.de>
References: <04526309-4653-3349-b6de-e7640c2258d6@xenosoft.de>
 <34617b1b-e213-668b-05f6-6fce7b549bf0@xenosoft.de>
 <9af2c1c9-2caf-120b-2f97-c7722274eee3@csgroup.eu>
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
Message-ID: <199da427-9511-34fe-1a9e-08e24995ea85@xenosoft.de>
Date:   Sat, 15 May 2021 15:46:06 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <9af2c1c9-2caf-120b-2f97-c7722274eee3@csgroup.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: de-DE
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 15 May 2021 at 12:08pm Christophe Leroy wrote:
>
>
> Le 15/05/2021 à 11:48, Christian Zigotzky a écrit :
>> Hi All,
>>
>> I bisected today [1] and the bisecting itself was OK but the 
>> reverting of the bad commit doesn't solve the issue. Do you have an 
>> idea which commit could be resposible for this issue? Maybe the 
>> bisecting wasn't successful. I will look in the kernel git log. Maybe 
>> there is a commit that affected KVM HV on FSL P50x0 machines.
>
> If the uImage doesn't load, it may be because of the size of uImage.
>
> See https://github.com/linuxppc/issues/issues/208
>
> Is there a significant size difference with and without KVM HV ?
>
> Maybe you can try to remove another option to reduce the size of the 
> uImage.
I tried it but it doesn't solve the issue. The uImage works without KVM 
HV in a virtual e5500 QEMU machine.

-Christian
>
> Or if you are using gzipped uImage you can try with an lzma uImage. 
> You can find a way to get an lzma uImage here: 
> https://github.com/linuxppc/issues/issues/208#issuecomment-477479951
>
> Christophe
>
>>
>> Thanks,
>> Christian
>>
>> [1] 
>> https://forum.hyperion-entertainment.com/viewtopic.php?p=53209#p53209
>>
>> On 14 May 2021 at 10:10 am, Christian Zigotzky wrote:
>>> Hi All,
>>>
>>> The RC1 of kernel 5.13 doesn't boot in a virtual e5500 QEMU machine 
>>> with KVM HV anymore. I see in the serial console that the uImage 
>>> doesn't load. I use the following QEMU command for booting:
>>>
>>> qemu-system-ppc64 -M ppce500 -cpu e5500 -enable-kvm -m 1024 -kernel 
>>> uImage-5.13 -drive 
>>> format=raw,file=MintPPC32-X5000.img,index=0,if=virtio -netdev 
>>> user,id=mynet0 -device e1000,netdev=mynet0 -append "rw 
>>> root=/dev/vda" -device virtio-vga -device virtio-mouse-pci -device 
>>> virtio-keyboard-pci -device pci-ohci,id=newusb -device 
>>> usb-audio,bus=newusb.0 -smp 4
>>>
>>> The kernel boots without KVM HV.
>>>
>>> Have you already tested KVM HV with the kernel 5.13?
>>>
>>> Thanks,
>>> Christian
>>>
>>>

