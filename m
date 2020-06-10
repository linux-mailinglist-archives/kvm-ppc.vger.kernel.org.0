Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2D71F5356
	for <lists+kvm-ppc@lfdr.de>; Wed, 10 Jun 2020 13:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgFJLfb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 10 Jun 2020 07:35:31 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.21]:13227 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728338AbgFJLf3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 10 Jun 2020 07:35:29 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jun 2020 07:35:29 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1591788928;
        s=strato-dkim-0002; d=xenosoft.de;
        h=In-Reply-To:Date:Message-ID:References:Cc:To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=ppHyWkO8AGokDFVTFfSR/y0B8VZdaapRRYZ1XbHFeWo=;
        b=bGwPgXeObMYw4UpapphAv6ouutm9sEn1k36V03L4VEOG1D3R1DhuBhzncvxaJrLFmk
        3WKEOxmc8LJthF0sxqNe8OV7iUlZ6uwUb1/Zkl1aKIad2zJDkWedrs+Epn2vwuXw3d4p
        Bf2OTLI7hhIMiKZ8vfMVM6gOo7dMObbBLB3HAnVaemacykmHylYa7BQla63YK+oJbDgo
        OauUBcGDtPKR172/xNkUqEQMO6BWX/p9w3lv360ZQszXJQEED2LWgI9Yz+HvqxC799IO
        4XBgaHoTj6dPXjkUXEpQEJXwuqprzzX7DmvyWp85cXwMUeu+11RWmyykFq2j2rzsUVW3
        y5AA==
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGM4l4Hio94KKxRySfLxnHfJ+Dkjp5DdBJSrwuuqxvPhSI1Vi9hdbute3wuvmUTfEdg9AyQ=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a02:8109:89c0:ebfc:15f9:f3ba:c3bc:6875]
        by smtp.strato.de (RZmta 46.9.1 AUTH)
        with ESMTPSA id w06ffew5ABNSZgw
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 10 Jun 2020 13:23:28 +0200 (CEST)
Subject: Re: PowerPC KVM-PR issue
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
To:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Alexander Graf <agraf@suse.de>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>
Cc:     Christian Zigotzky <info@xenosoft.de>,
        Darren Stevens <darren@stevens-zone.net>,
        "R.T.Dickinson" <rtd2@xtra.co.nz>
References: <f7f1b233-6101-2316-7996-4654586b7d24@csgroup.eu>
 <067BBAB3-19B6-42C6-AA9F-B9F14314255C@xenosoft.de>
 <014e1268-dcce-61a3-8bcd-a06c43e0dfaf@csgroup.eu>
 <7bf97562-3c6d-de73-6dbd-ccca275edc7b@xenosoft.de>
 <87tuznq89p.fsf@linux.ibm.com>
 <f2706f5f-62b8-9c52-08f4-59f91da48fa6@xenosoft.de>
 <cf99a8c0-3bad-d089-de54-e02d3dba7f72@xenosoft.de>
Message-ID: <7e859f68-9455-f98f-1fa3-071619fa1731@xenosoft.de>
Date:   Wed, 10 Jun 2020 13:23:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <cf99a8c0-3bad-d089-de54-e02d3dba7f72@xenosoft.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: de-DE
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 10 June 2020 at 11:06 am, Christian Zigotzky wrote:
> On 10 June 2020 at 00:18 am, Christian Zigotzky wrote:
>> Hello,
>>
>> KVM-PR doesn't work anymore on my Nemo board [1]. I figured out that 
>> the Git kernels and the kernel 5.7 are affected.
>>
>> Error message: Fienix kernel: kvmppc_exit_pr_progint: emulation at 
>> 700 failed (00000000)
>>
>> I can boot virtual QEMU PowerPC machines with KVM-PR with the kernel 
>> 5.6 without any problems on my Nemo board.
>>
>> I tested it with QEMU 2.5.0 and QEMU 5.0.0 today.
>>
>> Could you please check KVM-PR on your PowerPC machine?
>>
>> Thanks,
>> Christian
>>
>> [1] https://en.wikipedia.org/wiki/AmigaOne_X1000
>
> I figured out that the PowerPC updates 5.7-1 [1] are responsible for 
> the KVM-PR issue. Please test KVM-PR on your PowerPC machines and 
> check the PowerPC updates 5.7-1 [1].
>
> Thanks
>
> [1] 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d38c07afc356ddebaa3ed8ecb3f553340e05c969
>
>
I tested the latest Git kernel with Mac-on-Linux/KVM-PR today. 
Unfortunately I can't use KVM-PR with MoL anymore because of this issue 
(see screenshots [1]). Please check the PowerPC updates 5.7-1.

Thanks

[1]
- 
https://i.pinimg.com/originals/0c/b3/64/0cb364a40241fa2b7f297d4272bbb8b7.png
- 
https://i.pinimg.com/originals/9a/61/d1/9a61d170b1c9f514f7a78a3014ffd18f.png

