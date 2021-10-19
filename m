Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B60433AD9
	for <lists+kvm-ppc@lfdr.de>; Tue, 19 Oct 2021 17:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhJSPmp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 19 Oct 2021 11:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhJSPmp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 19 Oct 2021 11:42:45 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D67FC06161C
        for <kvm-ppc@vger.kernel.org>; Tue, 19 Oct 2021 08:40:32 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id y15so8401149lfk.7
        for <kvm-ppc@vger.kernel.org>; Tue, 19 Oct 2021 08:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M5qLpGOaG+oQiwUY6IZoloZawU2xGFjPWL0KZDD5Sqk=;
        b=Wmr7RZGDwVuUUI0LgeG+526Yzd808WwmB0Gv3Ef8vlN4fSo+FWdGkt2ewAZlHCizf2
         AOj6nKdkBK/50v2SslKwFKgXMONLSaQQZm/2hQbpblrN5k/KDVfxEf5XH7GllHiFtRBq
         4jqVHC4XfB57XB9V0yinVHJ5h8DIkkpImv8f0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M5qLpGOaG+oQiwUY6IZoloZawU2xGFjPWL0KZDD5Sqk=;
        b=zJIFqRWKlh67rEoh3CHSiHMj3u7WtwkC9pacmKL/wadAIxLur5Ibqonyld8WXjDI3I
         gxGHdlacyIILcGMZAGGD6EyK+JZQi/R7DRyqiXC8IZMm0T3+f2zThB3l0MgOQKMISBDG
         kqpOGSM6S7kPH0Inxu9B37DGHB9dccpNXPHU1hGjdt0dDKbRiJdb+04Bv64FBzpRIFd5
         kOHcTej4DfHOHNF2cMp3WpIkHipIsR7frdAZeYbPEhp6ns5HA/J+z8kRdnkrGhGjiJ0m
         so4WB93ywoEal9ub07QzwBhkB/68A1H5e59NTpACh7ptRa9n5B7vryg+ZfXQLFbLSsfh
         j5kw==
X-Gm-Message-State: AOAM530rNy3m3CMEfAT1tw1ZqkH0s6b4rqiA1q3bEzuuqMG4XBJltcuY
        10OO9BHrSLwOK4eOlNydNLLmUJ6xR5W3xyTg
X-Google-Smtp-Source: ABdhPJyYVdZDuhq1SF+Mzg0+bTeyho/OpUS4bKhO9sIlomycB+wwUecyEV8rqMWBxFYlTLTEzCPIig==
X-Received: by 2002:a05:6512:36ce:: with SMTP id e14mr6523789lfs.328.1634658030457;
        Tue, 19 Oct 2021 08:40:30 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id h4sm1695596lft.184.2021.10.19.08.40.29
        for <kvm-ppc@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 08:40:29 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id z11so8441039lfj.4
        for <kvm-ppc@vger.kernel.org>; Tue, 19 Oct 2021 08:40:29 -0700 (PDT)
X-Received: by 2002:a05:6512:398a:: with SMTP id j10mr6559053lfu.402.1634658028835;
 Tue, 19 Oct 2021 08:40:28 -0700 (PDT)
MIME-Version: 1.0
References: <20211019134204.3382645-1-agruenba@redhat.com>
In-Reply-To: <20211019134204.3382645-1-agruenba@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 19 Oct 2021 05:40:13 -1000
X-Gmail-Original-Message-ID: <CAHk-=wh0_3y5s7-G74U0Pcjm7Y_yHB608NYrQSvgogVNBxsWSQ@mail.gmail.com>
Message-ID: <CAHk-=wh0_3y5s7-G74U0Pcjm7Y_yHB608NYrQSvgogVNBxsWSQ@mail.gmail.com>
Subject: Re: [PATCH v8 00/17] gfs2: Fix mmap + page fault deadlocks
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        cluster-devel <cluster-devel@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com, kvm-ppc@vger.kernel.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Oct 19, 2021 at 3:42 AM Andreas Gruenbacher <agruenba@redhat.com> wrote:
>
> From my point of view, the following questions remain:
>
>  * I hope these patches will be merged for v5.16, but what process
>    should I follow for that?  The patch queue contains mm and iomap
>    changes, so a pull request from the gfs2 tree would be unusual.

Oh, I'd much rather get these as one pull request from the author and
from the person that actually ended up testing this.

It might be "unusual", but it's certainly not unheard of, and trying
to push different parts of the series through different maintainers
would just cause lots of extra churn.

Yes, normally I'd expect filesystem changes to have a diffstat that
clearly shows that "yes, it's all local to this filesystem", and when
I see anything else it raises red flags.

But it raises red flags not because it would be wrong to have changes
to other parts, but simply because when cross-subsystem development
happens, it needs to be discussed and cleared with people. And you've
done that.

So I'd take this as one pull request from you. You've been doing the
work, you get the questionable glory of being in charge of it all.
You'll get the blame too ;)

>  * Will Catalin Marinas's work for supporting arm64 sub-page faults
>    be queued behind these patches?  We have an overlap in
>    fault_in_[pages_]readable fault_in_[pages_]writeable, so one of
>    the two patch queues will need some adjustments.

I think that on the whole they should be developed separately, I don't
think it's going to be a particularly difficult conflict.

That whole discussion does mean that I suspect that we'll have to
change fault_in_iov_iter_writeable() to do the "every 16 bytes" or
whatever thing, and make it use an actual atomic "add zero" or
whatever rather than walk the page tables. But that's a conceptually
separate discussion from this one, I wouldn't actually want to mix up
the two issues too much.

Sure, they touch the same code, so there is _that_ overlap, but one is
about "the hardware rules are a-changing" and the other is about
filesystem use of - and expansion of - the things we do. Let's keep
them separate until ready, and then fix up the fallout at that point
(either as a merge resolution, or even partly after-the-fact).

                     Linus
