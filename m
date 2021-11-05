Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC8D446841
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Nov 2021 19:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234526AbhKESIY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Nov 2021 14:08:24 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.166]:31561 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbhKESIX (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Nov 2021 14:08:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1636135532;
    s=strato-dkim-0002; d=xenosoft.de;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=lW6PZrEMoh4YrNGw6p6fcAehMIXj+QcvqFKm6eiG2Ho=;
    b=PUxjeHeXW9B2GdUVGfUdv2fpN9PMdwa6YU6vlu24/Lgbex16rHHDBqofjsEz41hvl7
    VGjou1/HH6mnAZI1nhopFNxsku6dDQydiisPTB+Fi0S6HgZOEnlA2xDwioBgWojGvFqr
    Nu0KY7ZY9K25MZWcZa5KqfJ9LYbuqTwbMqjzSMnNx9TT1SdYLkVy5S0ytjgcVxAz72iV
    mQsdYblOZa9iZgFGBWrparxjc4TjwOrtcsdaMFE4ovW+GH4fjNEdYgYAndbknlV5rF0H
    YJsC/0YkUkIt3DUe5YOmrVFB40fjEZCp4LBiYPqGR7F93bjiLRA5AfPAiJ3beNRy5oKi
    b1Eg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGM4l4Hio94KKxRySfLxnHfJ+Dkjp5DdBJSrwuuqxvPhacCDkZL5G9UYE/q69Nx1/DIB5"
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a02:8109:89c0:ebfc:9f9:e5a3:6af5:bb18]
    by smtp.strato.de (RZmta 47.34.1 AUTH)
    with ESMTPSA id w0066dxA5I5VJTy
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 5 Nov 2021 19:05:31 +0100 (CET)
Message-ID: <aa9ce992-e48f-31b4-cc3e-3300bd557dc8@xenosoft.de>
Date:   Fri, 5 Nov 2021 19:05:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH] drm/virtio: Fix NULL dereference error in virtio_gpu_poll
Content-Language: de-DE
To:     Vivek Kasireddy <vivek.kasireddy@intel.com>,
        dri-devel@lists.freedesktop.org
Cc:     Gurchetan Singh <gurchetansingh@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>,
        "R.T.Dickinson" <rtd2@xtra.co.nz>,
        Darren Stevens <darren@stevens-zone.net>,
        mad skateman <madskateman@gmail.com>,
        Christian Zigotzky <info@xenosoft.de>
References: <15731ad7-83ff-c7ef-e4a1-8b11814572c2@xenosoft.de>
 <20211104214249.1802789-1-vivek.kasireddy@intel.com>
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
In-Reply-To: <20211104214249.1802789-1-vivek.kasireddy@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 04 November 2021 at 10:42 pm, Vivek Kasireddy wrote:

 > When virgl is not enabled, vfpriv pointer would not be allocated.
 > Therefore, check for a valid value before dereferencing.
 >
 > Reported-by: Christian Zigotzky <chzigotzky@xenosoft.de>
 > Cc: Gurchetan Singh <gurchetansingh@chromium.org>
 > Cc: Gerd Hoffmann <kraxel@redhat.com>
 > Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
 > ---
 >  drivers/gpu/drm/virtio/virtgpu_drv.c | 3 ++-
 >  1 file changed, 2 insertions(+), 1 deletion(-)
 >
 > diff --git a/drivers/gpu/drm/virtio/virtgpu_drv.c 
b/drivers/gpu/drm/virtio/virtgpu_drv.c
 > index 749db18dcfa2..d86e1ad4a972 100644
 > --- a/drivers/gpu/drm/virtio/virtgpu_drv.c
 > +++ b/drivers/gpu/drm/virtio/virtgpu_drv.c
 > @@ -163,10 +163,11 @@ static __poll_t virtio_gpu_poll(struct file *filp,
 >      struct drm_file *drm_file = filp->private_data;
 >      struct virtio_gpu_fpriv *vfpriv = drm_file->driver_priv;
 >      struct drm_device *dev = drm_file->minor->dev;
 > +    struct virtio_gpu_device *vgdev = dev->dev_private;
 >      struct drm_pending_event *e = NULL;
 >      __poll_t mask = 0;
 >
 > -    if (!vfpriv->ring_idx_mask)
 > +    if (!vgdev->has_virgl_3d || !vfpriv || !vfpriv->ring_idx_mask)
 >          return drm_poll(filp, wait);
 >
 >      poll_wait(filp, &drm_file->event_wait, wait);

Tested-by: Christian Zigotzky <chzigotzky@xenosoft.de> [1]

[1] https://i.ibb.co/N1vL5Kd/Kernel-5-16-alpha3-Power-PC.png
