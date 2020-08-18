Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D45248391
	for <lists+kvm-ppc@lfdr.de>; Tue, 18 Aug 2020 13:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgHRLIk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 18 Aug 2020 07:08:40 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:34211 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgHRLIj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 18 Aug 2020 07:08:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1597748918;
        s=strato-dkim-0002; d=xenosoft.de;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=koJFguAnm5m7Yf22e906vapRRMCc7tRf8L4mLRereyM=;
        b=VBudImc3ITxGcLwcfkNDMtdgEX8O2rnZ95SxM9v8/r0FjTwYaOlpUDEtkywwI9IYUA
        zNUHa6tH29rUV4HaWYZ0ZEy6nPVfPbpsce1dhDQ9cpVI879JITc9FKrb9MyHqZWk/CfM
        wtbEgYoXUd2XAyklQD2NnVVz6YIDumeDA25ab6o3mpmgY9CpoLdR5noHCO5KJ9Gq+mW/
        URGaBuxDN89zJLJjdu7x2pRYcN1i5sWCcNxCrbOHdFYpHfh9GU9+wjVcFddFZkGyUaXr
        mczPiPdlomBbcU30EoXH6EC1roqf5PKXGFzBV7yheIzutIa2M8/Kc1eWyyrXIoPKq25I
        BXJA==
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGM4l4Hio94KKxRySfLxnHvJzedV4hp0hM3BukOMWh+LViYiuzXqVlZzVo7xSI73ElHU="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a01:598:b10d:7054:8ddd:9a9:703b:cd26]
        by smtp.strato.de (RZmta 46.10.5 AUTH)
        with ESMTPSA id 60686ew7IB8Sqqz
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 18 Aug 2020 13:08:28 +0200 (CEST)
Subject: Re: [Virtual ppce500] virtio_gpu virtio0: swiotlb buffer is full
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     daniel.vetter@ffwll.ch, Darren Stevens <darren@stevens-zone.net>,
        mad skateman <madskateman@gmail.com>,
        =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>,
        "R.T.Dickinson" <rtd2@xtra.co.nz>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
References: <87h7tb4zwp.fsf@linux.ibm.com>
 <E1C071A5-19D1-4493-B04A-4507A70D7848@xenosoft.de>
 <bc1975fb-23df-09c2-540a-c13b39ad56c5@xenosoft.de>
 <51482c70-1007-1202-9ed1-2d174c1e923f@xenosoft.de>
 <9688335c-d7d0-9eaa-22c6-511e708e0d2a@linux.ibm.com>
 <9805f81d-651d-d1a3-fd05-fb224a8c2031@xenosoft.de>
 <3162da18-462c-72b4-f8f0-eef896c6b162@xenosoft.de>
 <3eee8130-6913-49d2-2160-abf0bf17c44e@xenosoft.de>
 <20200818081830.d2a2cva4hd2jzwba@sirius.home.kraxel.org>
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
Message-ID: <56faac9f-49e8-2f0b-6cd5-f8e589db4c8c@xenosoft.de>
Date:   Tue, 18 Aug 2020 13:08:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200818081830.d2a2cva4hd2jzwba@sirius.home.kraxel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: de-DE
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 18 August 2020 at 10:18 am, Gerd Hoffmann wrote:
> On Mon, Aug 17, 2020 at 11:19:58AM +0200, Christian Zigotzky wrote:
>> Hello
>>
>> I compiled the RC1 of kernel 5.9 today. Unfortunately the issue with the
>> VirtIO-GPU (see below) still exists. Therefore we still need the patch (see
>> below) for using the VirtIO-GPU in a virtual e5500 PPC64 QEMU machine.
> It is fixed in drm-misc-next (commit 51c3b0cc32d2e17581fce5b487ee95bbe9e8270a).
>
> Will cherry-pick into drm-misc-fixes once the branch is 5.9-based, which
> in turn should bring it to 5.9-rc2 or -rc3.
>
> take care,
>    Gerd
>
Thank you!
