Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0BB249425
	for <lists+kvm-ppc@lfdr.de>; Wed, 19 Aug 2020 06:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbgHSEf0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 19 Aug 2020 00:35:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34609 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725803AbgHSEfZ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 19 Aug 2020 00:35:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597811724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yPJctkGigK2eZZ7lK+QxEUST+IwxWemrdhUtdKg0lXE=;
        b=FMd40B337ZS4PorxGb/UT3KOXVodtaANu9yQJa+8eiVDyeUTXNzt11lJq07K/kc34syr0t
        6F0xSv9UH969G97jiX3fvDCo1NdaHddFyGe2KdWamj9ZllPqtfOfIm2OHqCgujRYAVycH7
        VjaMUyyyFrsjjVI4UpVYgbGkEtjI/fw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-nITry09UMYuOf_-FmD5u3g-1; Wed, 19 Aug 2020 00:35:20 -0400
X-MC-Unique: nITry09UMYuOf_-FmD5u3g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9983E425D0;
        Wed, 19 Aug 2020 04:35:17 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-112-195.ams2.redhat.com [10.36.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C2F6600DD;
        Wed, 19 Aug 2020 04:35:16 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 38A479D8F; Wed, 19 Aug 2020 06:35:15 +0200 (CEST)
Date:   Wed, 19 Aug 2020 06:35:15 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Christian Zigotzky <chzigotzky@xenosoft.de>
Cc:     daniel.vetter@ffwll.ch, Darren Stevens <darren@stevens-zone.net>,
        mad skateman <madskateman@gmail.com>,
        Michel =?utf-8?Q?D=C3=A4nzer?= <michel@daenzer.net>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>,
        "R.T.Dickinson" <rtd2@xtra.co.nz>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        gurchetansingh@chromium.org
Subject: Re: [Virtual ppce500] virtio_gpu virtio0: swiotlb buffer is full
Message-ID: <20200819043515.saq6ey33q7p2uccz@sirius.home.kraxel.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f2434a5-edcf-e7d1-f6ae-7c912dc8d859@xenosoft.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Aug 18, 2020 at 04:41:38PM +0200, Christian Zigotzky wrote:
> Hello Gerd,
> 
> I compiled a new kernel with the latest DRM misc updates today. The patch is
> included in these updates.
> 
> This kernel works with the VirtIO-GPU in a virtual e5500 QEMU/KVM HV machine
> on my X5000.
> 
> Unfortunately I can only use the VirtIO-GPU (Monitor: Red Hat, Inc. 8") with
> a resolution of 640x480. If I set a higher resolution then the guest
> disables the monitor.
> I can use higher resolutions with the stable kernel 5.8 and the VirtIO-GPU.
> 
> Please check the latest DRM updates.

https://patchwork.freedesktop.org/patch/385980/

(tests & reviews & acks are welcome)

HTH,
  Gerd

