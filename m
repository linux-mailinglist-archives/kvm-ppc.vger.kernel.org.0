Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEEBE3F2258
	for <lists+kvm-ppc@lfdr.de>; Thu, 19 Aug 2021 23:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235375AbhHSVks (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 19 Aug 2021 17:40:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60677 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230112AbhHSVkr (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 19 Aug 2021 17:40:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629409210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DvdcXZIwl3tPZt3OBpuE3xqKVNbMTKzJBp4rw8ENU30=;
        b=FjwSGTPBYVlTqBtCrCdhOcvRbjtKjjXFcTekrCe/GPm+vLdSYs1Y+NQtQHVcsrfe94EPIf
        lAWwMS3e8s+7jc3kKX25VU8Y5BDNh6YNcjecX5qOApOzvchgCOkZGk9xQvEn6UB374i+A0
        dfIaOOJctFO8QHMAq82Ewzs+Bj+pUnw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-Mvuh0Q-tMsenzOMyT7aNiw-1; Thu, 19 Aug 2021 17:40:09 -0400
X-MC-Unique: Mvuh0Q-tMsenzOMyT7aNiw-1
Received: by mail-wr1-f69.google.com with SMTP id q4-20020a05600000c400b00156d811312aso2140493wrx.3
        for <kvm-ppc@vger.kernel.org>; Thu, 19 Aug 2021 14:40:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DvdcXZIwl3tPZt3OBpuE3xqKVNbMTKzJBp4rw8ENU30=;
        b=F2qkTwEOqNYw4JwubEQwUQhRoZeJn3QUDHLyCxqLJcjCOKwH3Z7R4H2UE+mGoauhcd
         o7Q4wEoI7FOKx6hoVWg7Xq6e7sAOPjxdo39fR8N8oGNz1zxVgTEtbQoHsWKtBh7QHWdO
         u6SSQBafjsPkeLI6A4/x0igs1DVL8GKo6GL92S7i2DlHRkmbO18A8PqxeA/SVeZxW/zQ
         +Uyax2QGF8R+qcIk2KdlehxZZlSFsbYwHWgpcpQB3E1PHMmZ1TDMY6WS/MeMeSucOrL9
         NWMGdPac66G6qy84oc+GctTu8skZcL3e2gBD58Q5emHFsNOk01x91jplvZBnkOx6SmnL
         hvpQ==
X-Gm-Message-State: AOAM531OroW2PVDMocHL8XpcMflltp6d3/YuxO8OzAQxnaF7iSKe37ga
        QAudl6mYMrpT42Whr1DYTPIbIVoxz6j4UNcCLUjsLpTrgGiIyVcTt6jHIzBr7ZWXCrgSJMntKk7
        TiUF+/dHOhaNGpY1zjQ0boZz8R7rlZQR3Qw==
X-Received: by 2002:a1c:7916:: with SMTP id l22mr623015wme.27.1629409208119;
        Thu, 19 Aug 2021 14:40:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYA97+cGFeqU43YBkPI260mv8aQOOw6JSQmOGyumgFbyOD0nefEq4MgAFBQrx6D74nVITzdNSFMePqB4OBxCo=
X-Received: by 2002:a1c:7916:: with SMTP id l22mr622994wme.27.1629409207884;
 Thu, 19 Aug 2021 14:40:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210803191818.993968-1-agruenba@redhat.com> <CAHk-=wj+_Y7NQ-NhhE0jk52c9ZB0VJbO1AjtMJFB8wP=PO+bdw@mail.gmail.com>
 <CAHc6FU6H5q20qiQ5FX1726i0FJHyh=Y46huWkCBZTR3sk+3Dhg@mail.gmail.com>
 <CAHk-=whBCm3G5yibbvQsTn00fA16a688NTU_geQV158DnRy+bQ@mail.gmail.com>
 <CAHc6FU5HHFwuJBCNuU0e_N0ehaFrzbUrCuTJyaLNC4qxwfazYA@mail.gmail.com> <CAHk-=wgumKBhggjyR7Ff6V8VKxaJK1yA-LpWdzZFSqFyqYq0Dw@mail.gmail.com>
In-Reply-To: <CAHk-=wgumKBhggjyR7Ff6V8VKxaJK1yA-LpWdzZFSqFyqYq0Dw@mail.gmail.com>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Thu, 19 Aug 2021 23:39:56 +0200
Message-ID: <CAHc6FU6a8SLmHfMoS7NUDKboWpVEGBKyC46pU_brx3y8crbEXA@mail.gmail.com>
Subject: Re: [PATCH v5 00/12] gfs2: Fix mmap + page fault deadlocks
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>, Jan Kara <jack@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        cluster-devel <cluster-devel@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com, kvm-ppc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Aug 19, 2021 at 10:14 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Aug 19, 2021 at 12:41 PM Andreas Gruenbacher
> <agruenba@redhat.com> wrote:
> >
> > Hmm, what if GUP is made to skip VM_IO vmas without adding anything to
> > the pages array? That would match fault_in_iov_iter_writeable, which
> > is modeled after __mm_populate and which skips VM_IO and VM_PFNMAP
> > vmas.
>
> I don't understand what you mean.. GUP already skips VM_IO (and
> VM_PFNMAP) pages. It just returns EFAULT.
>
> We could make it return another error. We already have DAX and
> FOLL_LONGTERM returning -EOPNOTSUPP.
>
> Of course, I think some code ends up always just returning "number of
> pages looked up" and might return 0 for "no pages" rather than the
> error for the first page.
>
> So we may end up having interfaces that then lose that explanation
> error code, but I didn't check.
>
> But we couldn't make it just say "skip them and try later addresses",
> if that is what you meant. THAT makes no sense - that would just make
> GUP look up some other address than what was asked for.

get_user_pages has a start and a nr_pages argument, which specifies an
address range from start to start + nr_pages * PAGE_SIZE. If pages !=
NULL, it adds a pointer to that array for each PAGE_SIZE subpage. I
was thinking of skipping over VM_IO vmas in that process, so when the
range starts in a mappable vma, runs into a VM_IO vma, and ends in a
mappable vma, the pages in the pages array would be discontiguous;
they would only cover the mappable vmas. But that would make it
difficult to make sense of what's in the pages array. So scratch that
idea.

> > > I also do still think that even regardless of that, we want to just
> > > add a FOLL_NOFAULT flag that just disables calling handle_mm_fault(),
> > > and then you can use the regular get_user_pages().
> > >
> > > That at least gives us the full _normal_ page handling stuff.
> >
> > And it does fix the generic/208 failure.
>
> Good. So I think the approach is usable, even if we might have corner
> cases left.
>
> So I think the remaining issue is exactly things like VM_IO and
> VM_PFNMAP. Do the fstests have test-cases for things like this? It
> _is_ quite specialized, it might be a good idea to have that.
>
> Of course, doing direct-IO from special memory regions with zerocopy
> might be something special people actually want to do. But I think
> we've had that VM_IO flag testing there basically forever, so I don't
> think it has ever worked (for some definition of "ever").

The v6 patch queue should handle those cases acceptably well for now,
but I don't think we have tests covering that at all.

Thanks,
Andreas

