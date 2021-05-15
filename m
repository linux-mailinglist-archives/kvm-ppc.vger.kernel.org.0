Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358EF381753
	for <lists+kvm-ppc@lfdr.de>; Sat, 15 May 2021 11:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhEOJts (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 15 May 2021 05:49:48 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:13792 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbhEOJtn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 15 May 2021 05:49:43 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1621072097; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=bsgISamXjnx3jvMilwi69anrF8BIO19ElQSD/WoZgtgw1nczLuE2GONfUeDrCW6T3l
    dCWWnN3ytvlEfPyALWhuh84MD4yfoYNgR4oYo86Wph/kwzoFq7YVrD0r/AaUhTS8aQfy
    8W2Zb3Xta6pOTh4D3iT+lIBCayWTOfpq4RWSWsKrVe5cEnyk6RSZzYQ7IwVVUXJlnS/v
    U4k6GOPsQBFs8lJReqlhy5PqTrQKg3aehEqeUteTTKxD2RFb3EcliDJ7YQAQ+25Dz8Zs
    I22dQKsyjfcq5BXX+I7jZr4qSPUAx1IBbgKnNA0FRfVW33j5sFANMREwo7CtfA5QN47t
    Q/MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1621072097;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:Date:Message-ID:Cc:References:To:From:Subject:Cc:Date:
    From:Subject:Sender;
    bh=DooonvsnXQrUosdrhbUqCbyxjMDxSKv7u3E4sbwbDKI=;
    b=rWqbkKKH5iN32c/XZXEGWtzHhRtmBknD9PxKWCh6wApCgn/oKZPCokc3Iw0bYn7M4E
    vkO6FUbt02KUEYZuBrXIK9hqF/DVGZmawvuTJkikeJfDylJauvDV17KfQwAFcNlTP4W8
    /sicq0p7oQhzXPE0N/Ar89JvseT/1P79CNjvAR02YntclOuyWJkzQcYSuQlulxltp3dP
    qSEmzn4SdrvXcADWcEI0VS3PeIdcmVmKjQuJ8KE/3r4JWU3vA05E43d0H5JcpyNZ0LI6
    yOnXSKPTBPYTO7Cfw9DCNDE/+UHmuZw/K+CsNqt6gtMUmNt2Bap+OWc30gQGXKx1u0bG
    zlbg==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1621072097;
    s=strato-dkim-0002; d=xenosoft.de;
    h=In-Reply-To:Date:Message-ID:Cc:References:To:From:Subject:Cc:Date:
    From:Subject:Sender;
    bh=DooonvsnXQrUosdrhbUqCbyxjMDxSKv7u3E4sbwbDKI=;
    b=Ygv9nlc1qzVaS9B7YrEbX7C45lBWXQB/CCS5LfyWLqXkjdpzoKqlpOAzl+c60vA54g
    3Tssb7nrI294k5om7HmEr1BFpDD2pwmByrJkXggJUVTHVK1Ar8shpHhJPnJuh7qIwSpm
    Kzyz0X4EqQ/J5hxNOu2MVLr991f48WwlfUuWMJNn7n39EWYRb0jC6DDjXPFozepz1h9d
    LA+kByg8CE8zWOFRgc3wUVNa6LKGz7oFfn/MF5CgkjMR9ZeNjXzkXbGbnqCN739FeOQR
    iEJlYo+Chups8FoWXVoU8uOVzMo3nIfs0D06cKKgBF5yQ9s+f9sg7W3c8Z+TvnrVxEhD
    tqEw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGM4l4Hio94KKxRySfLxnHfJ+Dkjp5DdBJSrwuuqxvPhXJ7dKjcwcOiBaUbwe0R4Xq9qUgw=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a02:8109:89c0:ebfc:41e6:8089:8f38:3ee8]
    by smtp.strato.de (RZmta 47.25.9 AUTH)
    with ESMTPSA id n06826x4F9mG07S
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sat, 15 May 2021 11:48:16 +0200 (CEST)
Subject: Re: [FSL P50x0] KVM HV doesn't work anymore
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
To:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>
References: <04526309-4653-3349-b6de-e7640c2258d6@xenosoft.de>
Cc:     "R.T.Dickinson" <rtd2@xtra.co.nz>,
        Darren Stevens <darren@stevens-zone.net>,
        mad skateman <madskateman@gmail.com>,
        Christian Zigotzky <info@xenosoft.de>
Message-ID: <34617b1b-e213-668b-05f6-6fce7b549bf0@xenosoft.de>
Date:   Sat, 15 May 2021 11:48:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <04526309-4653-3349-b6de-e7640c2258d6@xenosoft.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: de-DE
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi All,

I bisected today [1] and the bisecting itself was OK but the reverting 
of the bad commit doesn't solve the issue. Do you have an idea which 
commit could be resposible for this issue? Maybe the bisecting wasn't 
successful. I will look in the kernel git log. Maybe there is a commit 
that affected KVM HV on FSL P50x0 machines.

Thanks,
Christian

[1] https://forum.hyperion-entertainment.com/viewtopic.php?p=53209#p53209

On 14 May 2021 at 10:10 am, Christian Zigotzky wrote:
> Hi All,
>
> The RC1 of kernel 5.13 doesn't boot in a virtual e5500 QEMU machine 
> with KVM HV anymore. I see in the serial console that the uImage 
> doesn't load. I use the following QEMU command for booting:
>
> qemu-system-ppc64 -M ppce500 -cpu e5500 -enable-kvm -m 1024 -kernel 
> uImage-5.13 -drive 
> format=raw,file=MintPPC32-X5000.img,index=0,if=virtio -netdev 
> user,id=mynet0 -device e1000,netdev=mynet0 -append "rw root=/dev/vda" 
> -device virtio-vga -device virtio-mouse-pci -device 
> virtio-keyboard-pci -device pci-ohci,id=newusb -device 
> usb-audio,bus=newusb.0 -smp 4
>
> The kernel boots without KVM HV.
>
> Have you already tested KVM HV with the kernel 5.13?
>
> Thanks,
> Christian
>
>

