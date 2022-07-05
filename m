Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F42566056
	for <lists+kvm-ppc@lfdr.de>; Tue,  5 Jul 2022 02:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbiGEAtY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Jul 2022 20:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbiGEAtX (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Jul 2022 20:49:23 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A84F102
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Jul 2022 17:49:21 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id ay10so11719463qtb.1
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Jul 2022 17:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q3paDzJi5zzEw3QKS2XN4fxvFnQ/vqjvAcG3eiMUei8=;
        b=UWbvO6ZtItbh0AdvVy7iymQqSlvRnGbG03r6ZLE3bPIbnGB88/Bpo7DWEw+NDXEvj7
         PmGWTxIJm2jUK3a0CGepEoTVZ/5tFuOwbd5Dy4xoBvStZ7MGWEkPcecHGLFgz0uqCWy3
         i0c66yox5GEptajw8phz5NlVFOyc65ny13gu9QVOHim/yP3XkiVXZsyNeB/ptfYd8jjb
         lbkUhlS5uNDOrvMvmE0fwxQUTe0Se7/4WolupftYzZkhmbANXe1E5tTjx4Sq4sJqKs81
         0pFSq2XR7jJqV+/2kdpP5TQjGIhNyq/8Ky7JHJSfsEHkfdlUZFsTOpE0uT+zmxopfMvQ
         7prw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q3paDzJi5zzEw3QKS2XN4fxvFnQ/vqjvAcG3eiMUei8=;
        b=TYN9F5atYWN3tsVA1hxI4ZQZB0mF8eCR0c/monRvmmJipLOPC3rsLb2DddKgKjjT2U
         vCLgSTYUnoDPQSOl+wwRGyP5b8wp4e28FtAHqno1dS6iVWYdYFPUi4dgeUu600Uq0BWS
         SAwbl0CKPW2MQ/nwJ4f42TbwfnsQmpfdH2qhzg9qNmMIiND00r4PcUBZlAHAn1oJoA30
         quT9AIUIEmS3vPSajQ4iheh8Q23/kRZsbUie5AOdMqHbTjnOOr0yAPJQlizyOCmvq02z
         IcNsvnX7SYPARSxjC2dESmhvHq6z4B14MpS4/8qyPWVIu1xSC/gffU4m/DGgxorVpfcR
         Kfjg==
X-Gm-Message-State: AJIora8pzYbarplvntuD+xavOYLvouNtSwzV6JIfEo1rtaGzjN1TcVeB
        1xQJFIdhrRyCAslSs4+E+gITpNGIWavMYA==
X-Google-Smtp-Source: AGRyM1v5frr1uOWGkJNLK26qAXQwOq64RJvzJwbQq+FM7xK2HnzN7SunKJbtfAy4C3ywWOXCYBlXXQ==
X-Received: by 2002:a05:6214:da6:b0:472:f008:af1c with SMTP id h6-20020a0562140da600b00472f008af1cmr8915098qvh.22.1656982160756;
        Mon, 04 Jul 2022 17:49:20 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id 14-20020ac8594e000000b00304fc3d144esm22730700qtz.1.2022.07.04.17.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 17:49:20 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1o8Wkh-006I6B-Ig; Mon, 04 Jul 2022 21:49:19 -0300
Date:   Mon, 4 Jul 2022 21:49:19 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>,
        Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [RFC PATCH kernel] vfio: Skip checking for
 IOMMU_CAP_CACHE_COHERENCY on POWER and more
Message-ID: <20220705004919.GC23621@ziepe.ca>
References: <20220701061751.1955857-1-aik@ozlabs.ru>
 <BN9PR11MB527622E1CD94C59829D5CF398CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527622E1CD94C59829D5CF398CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Jul 01, 2022 at 07:10:45AM +0000, Tian, Kevin wrote:
> > From: Alexey Kardashevskiy <aik@ozlabs.ru>
> > Sent: Friday, July 1, 2022 2:18 PM
> > 
> > VFIO on POWER does not implement iommu_ops and therefore
> > iommu_capable()
> > always returns false and __iommu_group_alloc_blocking_domain() always
> > fails.
> > 
> > iommu_group_claim_dma_owner() in setting container fails for the same
> > reason - it cannot allocate a domain.
> > 
> > This skips the check for platforms supporting VFIO without implementing
> > iommu_ops which to my best knowledge is POWER only.
> > 
> > This also allows setting container in absence of iommu_ops.
> > 
> > Fixes: 70693f470848 ("vfio: Set DMA ownership for VFIO devices")
> > Fixes: e8ae0e140c05 ("vfio: Require that devices support DMA cache
> > coherence")
> > Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> > ---
> > 
> > Not quite sure what the proper small fix is and implementing iommu_ops
> > on POWER is not going to happen any time soon or ever :-/
> 
> I'm not sure how others feel about checking bus->iommu_ops outside
> of iommu subsystem. This sounds a bit non-modular to me and it's not
> obvious from the caller side why lacking of iommu_ops implies the two
> relevant APIs are not usable.

The more I think about this, the more I think POWER should implement
partial iommu_ops to make this work. It would not support an UNMANAGED
domain, or default domains, but it would support blocking and the
coherency probe.

This makes everything work properly and keeps the mess out of the core
code.

It should not be hard to do if someone can share a bit about the ppc
code and test it..

Jason
