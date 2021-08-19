Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9C63F2168
	for <lists+kvm-ppc@lfdr.de>; Thu, 19 Aug 2021 22:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhHSUPO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 19 Aug 2021 16:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbhHSUPO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 19 Aug 2021 16:15:14 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E94FC061575
        for <kvm-ppc@vger.kernel.org>; Thu, 19 Aug 2021 13:14:37 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id p38so15581827lfa.0
        for <kvm-ppc@vger.kernel.org>; Thu, 19 Aug 2021 13:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GYLpQkQZuRNvZVwWVHs6hiU3DKifELOt1KfkaMF5F2A=;
        b=B/IqwFJs/njcsFfxsssIWHeM8wznSo35wuhfCYyv4goqG/wjeI0zQ6nT0ZTt1/0BWF
         dLG71NTia4sTZlEvT5L06WR+5GaQEZiCaVyDVwP/BXavVqKls8jDto6k1yYQLWciRx4D
         x4YO/nWZvA4cGnX7riXpfM3/Op2bIpR4wpJD8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GYLpQkQZuRNvZVwWVHs6hiU3DKifELOt1KfkaMF5F2A=;
        b=eg5ljb10jetXE04yT8H1FPW9QPE4KVxiDTS4Ptbl4R8mTMfDgsl/7Ed7laVjZ7ylcG
         trSqpwUwMiFbftjtbBR3y09XhCzU/onib3EFI9+hi/DnrP97xD9/6siwh4p2WQZTZjkT
         YomEIKP6Ak0XavBexpaODNuJumZi7KkzpYn4HtEdOtOITRAteSKejcpi9wAR3FLf7rNI
         79F1BxfCkMv3743dsk6FJNBTYHuoB0iG7POoOPC6U8AyZqJB1W40cREACnTlucjk/Siq
         V/AGeXurO6HrKgwyOUd4FjWdT+YOIojtwMoQXHsxtlbiAXIR3bx0V7EEZcAthIvDPd4Q
         ddNw==
X-Gm-Message-State: AOAM530SZkxTuSU6JhbYCmqg36xgc8fDaByALkNyCsEMayXDxuB7BP0E
        u1P0Id4T91DOmMcVzHccMtrPqTfUj9IKa+V6h1U=
X-Google-Smtp-Source: ABdhPJwump0BKiPANuWR1quW/MUNYKzbrOMejghSGvqwwlZ+wTSVOYLde5i06++7/4UrIdVzYq69SQ==
X-Received: by 2002:ac2:41c2:: with SMTP id d2mr11792987lfi.241.1629404075570;
        Thu, 19 Aug 2021 13:14:35 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id y32sm405497lfa.171.2021.08.19.13.14.33
        for <kvm-ppc@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 13:14:34 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id s3so13432090ljp.11
        for <kvm-ppc@vger.kernel.org>; Thu, 19 Aug 2021 13:14:33 -0700 (PDT)
X-Received: by 2002:a2e:8808:: with SMTP id x8mr13668362ljh.220.1629404073513;
 Thu, 19 Aug 2021 13:14:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210803191818.993968-1-agruenba@redhat.com> <CAHk-=wj+_Y7NQ-NhhE0jk52c9ZB0VJbO1AjtMJFB8wP=PO+bdw@mail.gmail.com>
 <CAHc6FU6H5q20qiQ5FX1726i0FJHyh=Y46huWkCBZTR3sk+3Dhg@mail.gmail.com>
 <CAHk-=whBCm3G5yibbvQsTn00fA16a688NTU_geQV158DnRy+bQ@mail.gmail.com> <CAHc6FU5HHFwuJBCNuU0e_N0ehaFrzbUrCuTJyaLNC4qxwfazYA@mail.gmail.com>
In-Reply-To: <CAHc6FU5HHFwuJBCNuU0e_N0ehaFrzbUrCuTJyaLNC4qxwfazYA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 19 Aug 2021 13:14:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgumKBhggjyR7Ff6V8VKxaJK1yA-LpWdzZFSqFyqYq0Dw@mail.gmail.com>
Message-ID: <CAHk-=wgumKBhggjyR7Ff6V8VKxaJK1yA-LpWdzZFSqFyqYq0Dw@mail.gmail.com>
Subject: Re: [PATCH v5 00/12] gfs2: Fix mmap + page fault deadlocks
To:     Andreas Gruenbacher <agruenba@redhat.com>
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

On Thu, Aug 19, 2021 at 12:41 PM Andreas Gruenbacher
<agruenba@redhat.com> wrote:
>
> Hmm, what if GUP is made to skip VM_IO vmas without adding anything to
> the pages array? That would match fault_in_iov_iter_writeable, which
> is modeled after __mm_populate and which skips VM_IO and VM_PFNMAP
> vmas.

I don't understand what you mean.. GUP already skips VM_IO (and
VM_PFNMAP) pages. It just returns EFAULT.

We could make it return another error. We already have DAX and
FOLL_LONGTERM returning -EOPNOTSUPP.

Of course, I think some code ends up always just returning "number of
pages looked up" and might return 0 for "no pages" rather than the
error for the first page.

So we may end up having interfaces that then lose that explanation
error code, but I didn't check.

But we couldn't make it just say "skip them and try later addresses",
if that is what you meant. THAT makes no sense - that would just make
GUP look up some other address than what was asked for.

> > I also do still think that even regardless of that, we want to just
> > add a FOLL_NOFAULT flag that just disables calling handle_mm_fault(),
> > and then you can use the regular get_user_pages().
> >
> > That at least gives us the full _normal_ page handling stuff.
>
> And it does fix the generic/208 failure.

Good. So I think the approach is usable, even if we might have corner
cases left.

So I think the remaining issue is exactly things like VM_IO and
VM_PFNMAP. Do the fstests have test-cases for things like this? It
_is_ quite specialized, it might be a good idea to have that.

Of course, doing direct-IO from special memory regions with zerocopy
might be something special people actually want to do. But I think
we've had that VM_IO flag testing there basically forever, so I don't
think it has ever worked (for some definition of "ever").

            Linus
