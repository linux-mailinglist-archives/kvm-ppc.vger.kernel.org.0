Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B81D316D9B
	for <lists+kvm-ppc@lfdr.de>; Wed, 10 Feb 2021 19:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbhBJSCE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 10 Feb 2021 13:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbhBJR74 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 10 Feb 2021 12:59:56 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9441C0613D6
        for <kvm-ppc@vger.kernel.org>; Wed, 10 Feb 2021 09:59:15 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id e9so703697qvy.3
        for <kvm-ppc@vger.kernel.org>; Wed, 10 Feb 2021 09:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mEPuatLoyym+J6ItA3BIfCEOLL8sQ3QwAzMr1dNPupk=;
        b=jW9PVjGrRwIiTu0DvrBNx4ykL4I0ErasGCeEaMHeyrXRbfEG9LB3dcE8vE11UBawk6
         1G1tcdRNTWBDtUg+fhfGsQMXOWfqjp3mTLwZKFq4HmTvwSr/K8tGSYW63Zm+KpQxHBXW
         u0ZOrWnXE5JBPOQyNkpBsjDIpzJF/xZBBZ9sBVx4nngGJfwe8dUE8XiCc/Io+j7LyXb3
         qrq9PeYWhfP2y1Eo2XwOk5F4UEKCmphlVy4z7L2moVXVcz43s9cOi+RdntHzTecyr9XT
         0EAPy3emAM7JVX2q3gq8vXafguG5d+qLtIeyiWB7Whu98AaOeG5oA/d4Anm2Sc/eA5pZ
         rwJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mEPuatLoyym+J6ItA3BIfCEOLL8sQ3QwAzMr1dNPupk=;
        b=YSoFp4uxeYCz+ut5oyJQCc6vW0eqcGIoUBUk6kHKSvRgb7twt5VPTBVMqNCvZu1CbD
         ku8oAOfloAbaWWGEoBTX9rZTrym1fPym8nQpUjmg2mzIm1c2Si/NMbKUvgxuKtBX1DcK
         jeQrhtwVKtw8cXarn+TjCXMFJu9XoslAXZzUMmbcouXIiMdvoKjli03P8kUEnXd2u37h
         xTNh5IsGDRlLQ41ICdo7hCt4zKev/p5O2C+WqVOmSHX79Ax8uhhMsVQNJ6jFGPNkWoRQ
         jSQ/socQ/7nQmYZAsnkTVsmVtMU4aLYOZU0k2kwEolJVBRBlAN4ZxzPSWNRo7dozdDmZ
         IgsQ==
X-Gm-Message-State: AOAM530LRrfFNB3G5/RwN5RnKzqRN4uyouBJwXiWXPsXFkhwdOglMyu3
        fTleyPfNSR6FGdQDv1kHhWbeZQ==
X-Google-Smtp-Source: ABdhPJxwZzRaoXxpNKuY9U9fnfERIckZW7aYN7mA/qmqVG4TxZ7Frx9umWXL+42aGA2CymOfvFagoA==
X-Received: by 2002:a0c:ed42:: with SMTP id v2mr3900087qvq.15.1612979954649;
        Wed, 10 Feb 2021 09:59:14 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id p16sm1742656qtq.24.2021.02.10.09.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 09:59:14 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1l9tlh-006895-Mz; Wed, 10 Feb 2021 13:59:13 -0400
Date:   Wed, 10 Feb 2021 13:59:13 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Daniel Vetter <daniel@ffwll.ch>,
        Alistair Popple <apopple@nvidia.com>,
        Linux MM <linux-mm@kvack.org>,
        Nouveau Dev <nouveau@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm-ppc@vger.kernel.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH 0/9] Add support for SVM atomics in Nouveau
Message-ID: <20210210175913.GO4718@ziepe.ca>
References: <20210209010722.13839-1-apopple@nvidia.com>
 <CAKMK7uGwg2-DTU7Zrco=TSkcR4yTqN1AF0hvVYEAbuj4BUYi5Q@mail.gmail.com>
 <3426910.QXTomnrpqD@nvdebian>
 <CAKMK7uHp+BzHF1=JhKjv5HYm_j0SVqsGdRqjUxVFYx4GSEPucg@mail.gmail.com>
 <57fe0deb-8bf6-d3ee-3545-11109e946528@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57fe0deb-8bf6-d3ee-3545-11109e946528@nvidia.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Feb 09, 2021 at 12:53:27PM -0800, John Hubbard wrote:

> This direction sounds at least...possible. Using MMU notifiers instead of pins
> is definitely appealing. I'm not quite clear on the callback idea above, but
> overall it seems like taking advantage of the ZONE_DEVICE tracking of pages
> (without having to put anything additional in each struct page), could work.

It isn't the ZONE_DEVICE page that needs to be tracked.

Really what you want to do here is leave the CPU page in the VMA and
the page tables where it started and deny CPU access to the page. Then
all the proper machinery will continue to work.

IMHO "migration" is the wrong idea if the data isn't actually moving.

Jason
