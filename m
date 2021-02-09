Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A7031509B
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Feb 2021 14:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhBINnQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Feb 2021 08:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbhBINk4 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 9 Feb 2021 08:40:56 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1ED1C061794
        for <kvm-ppc@vger.kernel.org>; Tue,  9 Feb 2021 05:40:02 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id t196so2113716oot.2
        for <kvm-ppc@vger.kernel.org>; Tue, 09 Feb 2021 05:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LhfQbnhwDGpqGDadCiKHjxS8DmSjilEDHzg3CJ532pI=;
        b=JigqNdgDEFgtQlKMjnmdnlDlN7M4qkzWm5dhzF1dd992sb4eU3A75DIikN86A5yKF3
         +HYqLOXv3f90n0bmYdNvleTeiQcUc5RdDT1mXps9fTyTu9OPEPFxGyjMaOdfAf5jGZOp
         LN5zBs74rUhwch5wHpsKumLLOkAYJemIb3dfs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LhfQbnhwDGpqGDadCiKHjxS8DmSjilEDHzg3CJ532pI=;
        b=KoRCbmeuDGElJJY00YX5C6AhYtAErL4QH4SeqFYyEwR8FMvHBh+Q8xm3otJJ1S12kT
         +cJMp+oCcPMZbej6kZc+VE8nJIG8f6HnxRwHRChJd9fLmKPDisMYsqbEI/i7npnQds/M
         0EkiAixsPLBsO7BOI/SMXa6OFXWx5hCrS7AwhTAVoRBK+3kw++PkmQPnweAy6AQn3SKP
         Q4GvmYuVRe0UAL8jdrmj3Fe2rYIVesMY/qVJ1pFu2pXOJrIOI/sSbQHqK738/lS/Kmqd
         CP32vSjvru3fu3W4pXXZUK+jMpK9HAM3/BznWoYxIo0HDdM1dunx3ZX9D3KaODFePY5X
         ocww==
X-Gm-Message-State: AOAM531X52yAEbE5oiGYPmK48bJRZHiyzEO3Tuz60yG9miiu5iiAIrM0
        mCuJ0KZYyDboKdiEdAQ2StRXJJHccmV6DcSWhlB6FQ==
X-Google-Smtp-Source: ABdhPJxCuVVi8kRB1kkxAZJFWPpa7yPv+iZrvRDXXQ3OzMMiP+Pm+I8NUjrdp4w6xRd7m67NamfzG5rvygCAv52MFRA=
X-Received: by 2002:a4a:d891:: with SMTP id b17mr15851254oov.28.1612878002267;
 Tue, 09 Feb 2021 05:40:02 -0800 (PST)
MIME-Version: 1.0
References: <20210209010722.13839-1-apopple@nvidia.com> <CAKMK7uGwg2-DTU7Zrco=TSkcR4yTqN1AF0hvVYEAbuj4BUYi5Q@mail.gmail.com>
 <3426910.QXTomnrpqD@nvdebian> <20210209133520.GB4718@ziepe.ca>
In-Reply-To: <20210209133520.GB4718@ziepe.ca>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Tue, 9 Feb 2021 14:39:51 +0100
Message-ID: <CAKMK7uGR44pSdL7FOui4XE6hRY8pMs7d0bPbgHHoprRG4tGmFQ@mail.gmail.com>
Subject: Re: [PATCH 0/9] Add support for SVM atomics in Nouveau
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Alistair Popple <apopple@nvidia.com>,
        Linux MM <linux-mm@kvack.org>,
        Nouveau Dev <nouveau@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm-ppc@vger.kernel.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        John Hubbard <jhubbard@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Jerome Glisse <jglisse@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Feb 9, 2021 at 2:35 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Tue, Feb 09, 2021 at 11:57:28PM +1100, Alistair Popple wrote:
> > On Tuesday, 9 February 2021 9:27:05 PM AEDT Daniel Vetter wrote:
> > > >
> > > > Recent changes to pin_user_pages() prevent the creation of pinned pages in
> > > > ZONE_MOVABLE. This series allows pinned pages to be created in
> > ZONE_MOVABLE
> > > > as attempts to migrate may fail which would be fatal to userspace.
> > > >
> > > > In this case migration of the pinned page is unnecessary as the page can
> > be
> > > > unpinned at anytime by having the driver revoke atomic permission as it
> > > > does for the migrate_to_ram() callback. However a method of calling this
> > > > when memory needs to be moved has yet to be resolved so any discussion is
> > > > welcome.
> > >
> > > Why do we need to pin for gpu atomics? You still have the callback for
> > > cpu faults, so you
> > > can move the page as needed, and hence a long-term pin sounds like the
> > > wrong approach.
> >
> > Technically a real long term unmoveable pin isn't required, because as you say
> > the page can be moved as needed at any time. However I needed some way of
> > stopping the CPU page from being freed once the userspace mappings for it had
> > been removed.
>
> The issue is you took the page out of the PTE it belongs to, which
> makes it orphaned and unlocatable by the rest of the mm?
>
> Ideally this would leave the PTE in place so everything continues to
> work, just disable CPU access to it.
>
> Maybe some kind of special swap entry?

I probably should have read the patches more in detail, I was assuming
the ZONE_DEVICE is only for vram. At least I thought the requirement
for gpu atomics was that the page is in vram, but maybe I'm mixing up
how this works on nvidia with how it works in other places. Iirc we
had a long discussion about this at lpc19 that ended with the
conclusion that we must be able to migrate, and sometimes migration is
blocked. But the details ellude me now.

Either way ZONE_DEVICE for not vram/device memory sounds wrong. Is
that really going on here?
-Daniel

>
> I also don't much like the use of ZONE_DEVICE here, that should only
> be used for actual device memory, not as a temporary proxy for CPU
> pages.. Having two struct pages refer to the same physical memory is
> pretty ugly.
>
> > The normal solution of registering an MMU notifier to unpin the page when it
> > needs to be moved also doesn't work as the CPU page tables now point to the
> > device-private page and hence the migration code won't call any invalidate
> > notifiers for the CPU page.
>
> The fact the page is lost from the MM seems to be the main issue here.
>
> > Yes, I would like to avoid the long term pin constraints as well if possible I
> > just haven't found a solution yet. Are you suggesting it might be possible to
> > add a callback in the page migration logic to specially deal with moving these
> > pages?
>
> How would migration even find the page?
>
> Jason



-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
