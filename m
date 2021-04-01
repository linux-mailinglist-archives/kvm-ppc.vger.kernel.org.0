Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C52B351FD1
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 21:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235101AbhDAT3W (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 15:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbhDAT3M (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 15:29:12 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CD1C0613AC
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 12:21:13 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id n198so1059905iod.0
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 12:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=898Op6M40JinO4D3cznUkQtr1L0luSLau7chpWc5uKg=;
        b=ZHtLYWtQ+FqDVYKZTHwxwCgUSMGSoQwWB3jcqgznkK+uvYCZl71pVwy5ATKWFW+awD
         RSsxcenvm4NI2KyYWaJUIG6gvaMfET9w4iUr92BU7UnnqyKaC+Ju011n6FIZIKYDawUS
         RfPx0iEgWjQkSsfvtpGU74dXu9GoGZoyW0RremDQPcGSRotsSgTYpyhipkTT3zuFwni9
         sjiPRhgr49+7DQJBGGd7WW1reLrFWvr/qNBKcAA2mu09pJ2RM+Gdf2ROLzB5obPcnu9S
         RvCPLxzmOd4AN2AX3Z8HVq/gV/3V7zY244fX74qyZGgWcN/dIAA+Fg3WJlQfpEJEuMwR
         wlBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=898Op6M40JinO4D3cznUkQtr1L0luSLau7chpWc5uKg=;
        b=fNPwRcI0yms8jSv3AYvlYvirIZ/DNm+DE6LklPmb+B0vI4iAF40V01+1Km1Hk1/d7C
         nx5PUoguwaxFQuA5TCgVgfyh5H2e79ZMz0a9ch3U3Un7PprQnvkeouTBuejHFajzY+LT
         TAai0+JFUY/TJrbETwttu1wa5jwmbDCu/qTh/FI//4vFHYPbUsCZ0mRvmcHG37jpQwSw
         JT5juo55C5s+yurwv7GZi89kT44e/szuGRrPh8m4e9eoOTkr0+Uh5MXdxN7sqDbBkwYi
         vXdLdJHttsdCbxlFxLnuBkplvhPkOeb8T266xi6TtY1e2KRCtlvHuqLxixcOL46G0Ylq
         8ETg==
X-Gm-Message-State: AOAM532kB1DcfcIoeqTIPN91/2qx/vTgrExgEXkY0sl8O1vm677CdjQb
        lr6KZ8TklWrdM1N1eDM7WcvX27LjEn6E+Is/a+k8/Q==
X-Google-Smtp-Source: ABdhPJxEg/kpAy++MLYpSkRG9zcOD0RT02x3wwPiTJxd0kzs4URGTpC5xS4fYjGbFYzdClWgvc/xicYjAnIIn52b/Ng=
X-Received: by 2002:a05:6638:388e:: with SMTP id b14mr9630881jav.62.1617304872817;
 Thu, 01 Apr 2021 12:21:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210326000805.2518-1-apopple@nvidia.com> <23784464.epyy5R1Yul@nvdebian>
 <20210331115746.GA1463678@nvidia.com> <2557539.O4bb4zRkYN@nvdebian>
In-Reply-To: <2557539.O4bb4zRkYN@nvdebian>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Thu, 1 Apr 2021 12:21:01 -0700
Message-ID: <CALvZod5a39kNUW3uj4z0+eYi_yfWLPEZ1BKdzbA42=E5TeEgHQ@mail.gmail.com>
Subject: Re: [PATCH v7 3/8] mm/rmap: Split try_to_munlock from try_to_unmap
To:     Alistair Popple <apopple@nvidia.com>,
        Hugh Dickins <hughd@google.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Linux MM <linux-mm@kvack.org>, nouveau@lists.freedesktop.org,
        bskeggs@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kvm-ppc@vger.kernel.org, dri-devel@lists.freedesktop.org,
        rcampbell@nvidia.com,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, daniel@ffwll.ch,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

CC: Hugh Dickins

On Wed, Mar 31, 2021 at 9:37 PM Alistair Popple <apopple@nvidia.com> wrote:
>
> On Wednesday, 31 March 2021 10:57:46 PM AEDT Jason Gunthorpe wrote:
> > On Wed, Mar 31, 2021 at 03:15:47PM +1100, Alistair Popple wrote:
> > > On Wednesday, 31 March 2021 2:56:38 PM AEDT John Hubbard wrote:
> > > > On 3/30/21 3:56 PM, Alistair Popple wrote:
> > > > ...
> > > > >> +1 for renaming "munlock*" items to "mlock*", where applicable. good
> > > grief.
> > > > >
> > > > > At least the situation was weird enough to prompt further
> investigation :)
> > > > >
> > > > > Renaming to mlock* doesn't feel like the right solution to me either
> > > though. I
> > > > > am not sure if you saw me responding to myself earlier but I am
> thinking
> > > > > renaming try_to_munlock() -> page_mlocked() and try_to_munlock_one() -
> >
> > > > > page_mlock_one() might be better. Thoughts?
> > > > >
> > > >
> > > > Quite confused by this naming idea. Because: try_to_munlock() returns
> > > > void, so a boolean-style name such as "page_mlocked()" is already not a
> > > > good fit.
> > > >
> > > > Even more important, though, is that try_to_munlock() is mlock-ing the
> > > > page, right? Is there some subtle point I'm missing? It really is doing
> > > > an mlock to the best of my knowledge here. Although the kerneldoc
> > > > comment for try_to_munlock() seems questionable too:
> > >
> > > It's mlocking the page if it turns out it still needs to be locked after
> > > unlocking it. But I don't think you're missing anything.
> >
> > It is really searching all VMA's to see if the VMA flag is set and if
> > any are found then it mlocks the page.
> >
> > But presenting this rountine in its simplified form raises lots of
> > questions:
> >
> >  - What locking is being used to read the VMA flag?
> >  - Why do we need to manipulate global struct page flags under the
> >    page table locks of a single VMA?
>
> I was wondering that and questioned it in an earlier version of this series. I
> have done some digging and the commit log for b87537d9e2fe ("mm: rmap use pte
> lock not mmap_sem to set PageMlocked") provides the original justification.
>
> It's fairly long so I won't quote it here but the summary seems to be that
> among other things the combination of page lock and ptl makes this safe. I
> have yet to verify if everything there still holds and is sensible, but the
> last paragraph certainly is :-)
>
> "Stopped short of separating try_to_munlock_one() from try_to_munmap_one()
> on this occasion, but that's probably the sensible next step - with a
> rename, given that try_to_munlock()'s business is to try to set Mlocked."
>
> >  - Why do we need to check for huge pages inside the VMA loop, not
> >    before going to the rmap? PageTransCompoundHead() is not sensitive to
> >    the PTEs. (and what happens if the huge page breaks up concurrently?)
> >  - Why do we clear the mlock bit then run around to try and set it?
>
> I don't have an answer for that as I'm not (yet) across all the mlock code
> paths, but I'm hoping this patch at least won't change anything.
>

It would be good to ask the person who has the most answers?

Hugh, the thread started at
https://lore.kernel.org/dri-devel/20210326000805.2518-4-apopple@nvidia.com/
