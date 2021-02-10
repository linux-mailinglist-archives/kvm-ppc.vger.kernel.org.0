Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8EC316D6E
	for <lists+kvm-ppc@lfdr.de>; Wed, 10 Feb 2021 18:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbhBJR5Y (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 10 Feb 2021 12:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbhBJR5K (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 10 Feb 2021 12:57:10 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E0CC0613D6
        for <kvm-ppc@vger.kernel.org>; Wed, 10 Feb 2021 09:56:29 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id e15so2146590qte.9
        for <kvm-ppc@vger.kernel.org>; Wed, 10 Feb 2021 09:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RUQ3IiEy3EeRQSWZTl5rkIVfBMl0Yr+7rUwczbTqPUI=;
        b=a+PshXZQLSQ7/K/9jegFaNYC0vZtmSYFRP1bDA8dbf8/musoPpHsw5fl3p1ROGJKfd
         BIwN8dEMPEjoYVb1yDkSYhphTXpCL9gSnrGEzHWvQCXWv29Ejjq92mz5G3Dg0KmE0XCX
         FeeRFLPtrUqSk8F0amJkbyHTGLQm8PvYyk+6v0OxaHba2MdI5fI0N/d0XsEh6GVU5emG
         /0vg6Fo5+WSy7jh21z0QKnlqdDB/yryAPmpCWW8UUSaCKsVbVpQw7LWKFor1C0y7OngB
         hQc5Rc67W3FeJVpxVwzluKmOqtnpGTOUR0RUS2WW2uLURW1Ug+7jhSO51GMEDjEjkQEH
         Fj+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RUQ3IiEy3EeRQSWZTl5rkIVfBMl0Yr+7rUwczbTqPUI=;
        b=Yj6UcTX8t3dAVf1oQLAKE4WObV4ZlxrgjYw/ft9HM6j5vr3OK3bg0pfpFGFmwPo8RT
         W+rM8XooVIW/UE1gT/KrMeYuVcTZy7H9XNgJl1kd5G8QNV4JSculZrNgPUhhbc9yPLFX
         GOG3Y56WsNmIe8KVEAtczt3ogpzI1MnT2mABIopiNUtwcWE63yf9kXSHvKoXxFjT06qy
         vULZ/4gTn3arp1ZaiclQIo2X/z7STPBJuITXcadKy6LuBiQFiUUWj8SEA2M5usY1E/Mi
         Ri7XkWWy08sGerswFoOGJUiyB0W1YqGpMFTv8MGlrtlROkShqQyGT//Phfd0Mr2Nr1GN
         pWWw==
X-Gm-Message-State: AOAM530Fel9SbjoLw/ZX0cQrj0cXfNynbLqVB7Yk8q6VDslmW2YYMQqw
        eCJOc5PZK2STUJ5spy8uwpKzvmJYH3SDRXc+
X-Google-Smtp-Source: ABdhPJwWEC9HwbcTz58sdbmUTleaPOjsDExx3u3MJe7UYTKAqinGSmHRrRGSIqyVmc4V1t6YgU/4OQ==
X-Received: by 2002:ac8:d03:: with SMTP id q3mr3814296qti.19.1612979788592;
        Wed, 10 Feb 2021 09:56:28 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id a25sm1697115qtw.87.2021.02.10.09.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 09:56:27 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1l9tj0-00686U-SC; Wed, 10 Feb 2021 13:56:26 -0400
Date:   Wed, 10 Feb 2021 13:56:26 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jerome Glisse <jglisse@redhat.com>
Cc:     Alistair Popple <apopple@nvidia.com>,
        Daniel Vetter <daniel@ffwll.ch>, Linux MM <linux-mm@kvack.org>,
        Nouveau Dev <nouveau@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm-ppc@vger.kernel.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        John Hubbard <jhubbard@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>
Subject: Re: [PATCH 0/9] Add support for SVM atomics in Nouveau
Message-ID: <20210210175626.GN4718@ziepe.ca>
References: <20210209010722.13839-1-apopple@nvidia.com>
 <CAKMK7uGwg2-DTU7Zrco=TSkcR4yTqN1AF0hvVYEAbuj4BUYi5Q@mail.gmail.com>
 <3426910.QXTomnrpqD@nvdebian>
 <20210209133520.GB4718@ziepe.ca>
 <20210209211738.GA834106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209211738.GA834106@redhat.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Feb 09, 2021 at 04:17:38PM -0500, Jerome Glisse wrote:

> > > Yes, I would like to avoid the long term pin constraints as well if possible I
> > > just haven't found a solution yet. Are you suggesting it might be possible to 
> > > add a callback in the page migration logic to specially deal with moving these 
> > > pages?
> > 
> > How would migration even find the page?
> 
> Migration can scan memory from physical address (isolate_migratepages_range())
> So the CPU mapping is not the only path to get to a page.

I mean find out that the page is now owned by the GPU driver to tell
it that it needs to migrate that reference. Normally that would go
through the VMA to the mmu notifier, but with the page removed from
the normal VMA it can't get to a mmu notifier or the GPU driver.

Jason
