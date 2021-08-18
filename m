Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF0D3F0DAC
	for <lists+kvm-ppc@lfdr.de>; Wed, 18 Aug 2021 23:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbhHRVuX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 18 Aug 2021 17:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234083AbhHRVuW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 18 Aug 2021 17:50:22 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB7CC061764
        for <kvm-ppc@vger.kernel.org>; Wed, 18 Aug 2021 14:49:47 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id i28so7835584lfl.2
        for <kvm-ppc@vger.kernel.org>; Wed, 18 Aug 2021 14:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iJVkGRZsMGQxCh04dQEEetPATyoitTCuRRt3dR/OwaQ=;
        b=MBJrjaGztFAJR0qOLiTWThRt9z10srm4PeJK99NfdPS1VdWHes04bGEuCMJ3+81yKG
         xMmt1W/5VFXH3Y/rlf6JGj6KPQ5aqt6Bo2HysLVRmrbi/u8P9ZK6QtkU0Zxnv02rxAmg
         ETOd9msrKzgzXYudP8auMlhAHgLqL7dhfq+1A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iJVkGRZsMGQxCh04dQEEetPATyoitTCuRRt3dR/OwaQ=;
        b=iGpoo28sw9hKj07RDXiICThURt9BRb2Kd9KRmb0nsdynze5tUTzgaTaJvB41aZKBLn
         LxH5vnUZ4xlrJ9HFFf5BUdjrxdMS0Z7gusMJshJTAz4jEbVrGhYCjPym81WOCgbKF/w5
         ebD1ZHddqOIKuXoc6RU4G2TLOH6RSVapnVUghU04TfwUo5YCozb1ryPKiKd6Kayt6+NU
         dsun6uuJWFxXmgDWxOoizrmaR3P81nRzy5BPalQ8g7YUdP5ATen1fVxp03JsiYUChZC4
         Btgg8aMYdi9O0M4nqZqFx0Rk/SXCtxvZNZJ12WYSWrVHU78EOFCAp+holxsylK6FeNDg
         GJrw==
X-Gm-Message-State: AOAM531yYf4GeYEzh+cgCWiGdo6KI2O22dp9iQrvXCvs5ltRwbPn15zu
        5cHjE6oOrAJHPmsT7hnM5HxAAhgc6FtAfhoQ
X-Google-Smtp-Source: ABdhPJylGrL6E/yy9Ghjy21k+ZAZdAqZxAk9KDJ9XzZL/9PvTcLv5dVGVhenLacSYkngIVQrYvG5tA==
X-Received: by 2002:a05:6512:23a2:: with SMTP id c34mr8232714lfv.342.1629323385574;
        Wed, 18 Aug 2021 14:49:45 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id m15sm88487lfl.14.2021.08.18.14.49.44
        for <kvm-ppc@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 14:49:44 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id d4so7754950lfk.9
        for <kvm-ppc@vger.kernel.org>; Wed, 18 Aug 2021 14:49:44 -0700 (PDT)
X-Received: by 2002:ac2:5a1a:: with SMTP id q26mr7636192lfn.41.1629323384436;
 Wed, 18 Aug 2021 14:49:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210803191818.993968-1-agruenba@redhat.com> <CAHk-=wj+_Y7NQ-NhhE0jk52c9ZB0VJbO1AjtMJFB8wP=PO+bdw@mail.gmail.com>
 <CAHc6FU6H5q20qiQ5FX1726i0FJHyh=Y46huWkCBZTR3sk+3Dhg@mail.gmail.com>
In-Reply-To: <CAHc6FU6H5q20qiQ5FX1726i0FJHyh=Y46huWkCBZTR3sk+3Dhg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 18 Aug 2021 14:49:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=whBCm3G5yibbvQsTn00fA16a688NTU_geQV158DnRy+bQ@mail.gmail.com>
Message-ID: <CAHk-=whBCm3G5yibbvQsTn00fA16a688NTU_geQV158DnRy+bQ@mail.gmail.com>
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

[ Sorry for the delay, I was on the road and this fell through the cracks ]

On Mon, Aug 16, 2021 at 12:14 PM Andreas Gruenbacher
<agruenba@redhat.com> wrote:
>
> On Tue, Aug 3, 2021 at 9:45 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Hmm. Have you tried to figure out why that "still returns 0" happens?
>
> The call stack is:
>
> gup_pte_range
> gup_pmd_range
> gup_pud_range
> gup_p4d_range
> gup_pgd_range
> lockless_pages_from_mm
> internal_get_user_pages_fast
> get_user_pages_fast
> iov_iter_get_pages
> __bio_iov_iter_get_pages
> bio_iov_iter_get_pages
> iomap_dio_bio_actor
> iomap_dio_actor
> iomap_apply
> iomap_dio_rw
> gfs2_file_direct_write
>
> In gup_pte_range, pte_special(pte) is true and so we return 0.

Ok, so that is indeed something that the fast-case can't handle,
because some of the special code wants to have the mm_lock so that it
can look at the vma flags (eg "vm_normal_page()" and friends.

That said, some of these cases even the full GUP won't ever handle,
simply because a mapping doesn't necessarily even _have_ a 'struct
page' associated with it if it's a VM_IO mapping.

So it turns out that you can't just always do
fault_in_iov_iter_readable() and then assume that you can do
iov_iter_get_pages() and repeat until successful.

We could certainly make get_user_pages_fast() handle a few more cases,
but I get the feeling that we need to have separate error cases for
EFAULT - no page exists - and the "page exists, but cannot be mapped
as a 'struct page'" case.

I also do still think that even regardless of that, we want to just
add a FOLL_NOFAULT flag that just disables calling handle_mm_fault(),
and then you can use the regular get_user_pages().

That at least gives us the full _normal_ page handling stuff.

                   Linus
