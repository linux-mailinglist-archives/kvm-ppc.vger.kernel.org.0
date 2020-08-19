Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FB2249A5F
	for <lists+kvm-ppc@lfdr.de>; Wed, 19 Aug 2020 12:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgHSK3B (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 19 Aug 2020 06:29:01 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.164]:12137 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbgHSK26 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 19 Aug 2020 06:28:58 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Aug 2020 06:28:57 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1597832936;
        s=strato-dkim-0002; d=xenosoft.de;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=iot4F9NIeNJEKxo3vS94S+e9faKTbXdWR+AZlk71Fbw=;
        b=b0MiKnZurriCyR7n36AZ+KqM5CWcTVOVLg1UD0DattNuU0Yvs+o1xGDqKPu7m5/2En
        cUo9ruaRQc0g9/hmhrnRd+lYkIQL7uKcRTcxoqst3AMc2tRpXjjASmdUd3rxXSgIGD/y
        MGSkasnWccyU5Y1gmUfdea5hBQ+QOdRS7mWHv3NvViLQVtJTZz6RxL+u6mIgIqobrnQ4
        lwhq+dAxoRt1uuXuQ4scZFZdLPjxhjIvCjS6wb4ceWxpp3JBu2XJbnJ1PevfwV0sc2QG
        F8eSriGw+/0BGLpbMDIkZvgNu2Hr8kgqrSGp8aKIr+U+cufPlfCXH1F46062Wq0BSaTa
        xrGQ==
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGM4l4Hio94KKxRySfLxnHvJzedV4gJwhNnAyjUduDV+ZkOHUlEM0OPMli3OTXFzhrrfu"
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a01:598:d00a:a116:5430:18e8:3be9:8596]
        by smtp.strato.de (RZmta 46.10.7 AUTH)
        with ESMTPSA id Y04f7aw7JAMq0hZ
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 19 Aug 2020 12:22:52 +0200 (CEST)
Subject: Re: [Virtual ppce500] virtio_gpu virtio0: swiotlb buffer is full
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     daniel.vetter@ffwll.ch, Darren Stevens <darren@stevens-zone.net>,
        mad skateman <madskateman@gmail.com>,
        =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>,
        "R.T.Dickinson" <rtd2@xtra.co.nz>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        gurchetansingh@chromium.org
References: <87h7tb4zwp.fsf@linux.ibm.com>
 <E1C071A5-19D1-4493-B04A-4507A70D7848@xenosoft.de>
 <bc1975fb-23df-09c2-540a-c13b39ad56c5@xenosoft.de>
 <51482c70-1007-1202-9ed1-2d174c1e923f@xenosoft.de>
 <9688335c-d7d0-9eaa-22c6-511e708e0d2a@linux.ibm.com>
 <9805f81d-651d-d1a3-fd05-fb224a8c2031@xenosoft.de>
 <3162da18-462c-72b4-f8f0-eef896c6b162@xenosoft.de>
 <3eee8130-6913-49d2-2160-abf0bf17c44e@xenosoft.de>
 <20200818081830.d2a2cva4hd2jzwba@sirius.home.kraxel.org>
 <0f2434a5-edcf-e7d1-f6ae-7c912dc8d859@xenosoft.de>
 <20200819043515.saq6ey33q7p2uccz@sirius.home.kraxel.org>
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
Message-ID: <52a15836-4e95-089e-1683-416fdbb3fd19@xenosoft.de>
Date:   Wed, 19 Aug 2020 12:22:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200819043515.saq6ey33q7p2uccz@sirius.home.kraxel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: de-DE
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 19 August 2020 at 06:35 am, Gerd Hoffmann wrote:
> On Tue, Aug 18, 2020 at 04:41:38PM +0200, Christian Zigotzky wrote:
>> Hello Gerd,
>>
>> I compiled a new kernel with the latest DRM misc updates today. The patch is
>> included in these updates.
>>
>> This kernel works with the VirtIO-GPU in a virtual e5500 QEMU/KVM HV machine
>> on my X5000.
>>
>> Unfortunately I can only use the VirtIO-GPU (Monitor: Red Hat, Inc. 8") with
>> a resolution of 640x480. If I set a higher resolution then the guest
>> disables the monitor.
>> I can use higher resolutions with the stable kernel 5.8 and the VirtIO-GPU.
>>
>> Please check the latest DRM updates.
> https://patchwork.freedesktop.org/patch/385980/
>
> (tests & reviews & acks are welcome)
>
> HTH,
>    Gerd
>
Hello Gerd,

I compiled a new RC1 with our patches today. With these patches, the 
VirtIO-GPU works without any problems. I can use higher resolutions again.

Screenshot of the RC1-3 with the VirtIO-GPU in a virtual e5500 QEMU/KVM 
HV machine on my X5000: 
https://i.pinimg.com/originals/4f/b0/14/4fb01476edd7abe6be1e1203a8e7e152.png

Thanks a lot for your help!

Cheers,
Christian
