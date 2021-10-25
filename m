Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5322F439ED2
	for <lists+kvm-ppc@lfdr.de>; Mon, 25 Oct 2021 21:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233697AbhJYTDV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 25 Oct 2021 15:03:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37230 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233720AbhJYTDV (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 25 Oct 2021 15:03:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635188458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QkyoC/NexH1Nu0O2R4wJhF/62iz6WrFzKuF9woFeRsA=;
        b=FMgtWL46advIFc7a6Z4Daj5ZHup5t8m+GSfyUGpbsOs3yNJiysWmY6X4so8zxrrF8RdYHb
        KYr9DvZLg1Rwjnlg9PbS+aoALmXhDNDC4lZIhyj10VO5tixNxrwqy2IIBOa97gYtty03QF
        hA+w8TXa7lI0lp/nfm32RH8f4G3KqQ0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-TkbXBZ92O_qwQ77AnKeRyQ-1; Mon, 25 Oct 2021 15:00:56 -0400
X-MC-Unique: TkbXBZ92O_qwQ77AnKeRyQ-1
Received: by mail-wm1-f69.google.com with SMTP id k5-20020a7bc3050000b02901e081f69d80so4058979wmj.8
        for <kvm-ppc@vger.kernel.org>; Mon, 25 Oct 2021 12:00:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QkyoC/NexH1Nu0O2R4wJhF/62iz6WrFzKuF9woFeRsA=;
        b=3tdpYvrC8eZvg7YmOGgTO712N7vkhKKCOiM5sFrnimmHpx3cZCbIjiFxa1NMAdGmZw
         6njn8Mtud6xot9zDUltwmPCAFS6KzceZW5XBXOtweAccfH98czJKKVCq1R91UGkSZvQF
         n3yXDCwFvMhWTmEvpv4rCu1SMzglQNjarp2Bzc0362glyIdGoDlD9X7zCJ/6iLa2CmnC
         j5LYtmUUjVhKJ3z79halmrvsslyoLPQc007sVrw+CKK1MgMn1NZSk7RUmZ/4tCjacTJK
         sSVKxH0QwABZjgm0eOwVTMCEKSmgJ/t1Kh+mgi/EN3LaXwG+0nRli9qx5Rxo2WoMmSyb
         LIyQ==
X-Gm-Message-State: AOAM532SMa3HGGtd7sOXm4VSwulsZOM1YNrhS6lJKn0ai5TlnNSADte0
        Hc2OUkz6nzB3oEgLIeZ9jYW+FQWR4mEXHao7U7UFe432eqXWoVPsIwFVTakgXlz37M++L/vIArc
        IiIbxh9UCczuRzI3nN3jSYBlRDWj60vnP7w==
X-Received: by 2002:a7b:c74f:: with SMTP id w15mr21890322wmk.186.1635188455455;
        Mon, 25 Oct 2021 12:00:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzXLWqbHTas2L+Ep0jJ8Ym3FrcHaKtpcTPgh7nV35XP5aJDxyjNlJ4UaNmG9hWfJd1eun8dCJKnnE+XiZ6mmk=
X-Received: by 2002:a7b:c74f:: with SMTP id w15mr21890297wmk.186.1635188455236;
 Mon, 25 Oct 2021 12:00:55 -0700 (PDT)
MIME-Version: 1.0
References: <20211019134204.3382645-1-agruenba@redhat.com> <CAHk-=wh0_3y5s7-G74U0Pcjm7Y_yHB608NYrQSvgogVNBxsWSQ@mail.gmail.com>
 <YXBFqD9WVuU8awIv@arm.com> <CAHk-=wgv=KPZBJGnx_O5-7hhST8CL9BN4wJwtVuycjhv_1MmvQ@mail.gmail.com>
 <YXCbv5gdfEEtAYo8@arm.com> <CAHk-=wgP058PNY8eoWW=5uRMox-PuesDMrLsrCWPS+xXhzbQxQ@mail.gmail.com>
 <YXL9tRher7QVmq6N@arm.com> <CAHk-=wg4t2t1AaBDyMfOVhCCOiLLjCB5TFVgZcV4Pr8X2qptJw@mail.gmail.com>
In-Reply-To: <CAHk-=wg4t2t1AaBDyMfOVhCCOiLLjCB5TFVgZcV4Pr8X2qptJw@mail.gmail.com>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Mon, 25 Oct 2021 21:00:43 +0200
Message-ID: <CAHc6FU7BEfBJCpm8wC3P+8GTBcXxzDWcp6wAcgzQtuaJLHrqZA@mail.gmail.com>
Subject: Re: [PATCH v8 00/17] gfs2: Fix mmap + page fault deadlocks
To:     Linus Torvalds <torvalds@linux-foundation.org>
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

On Fri, Oct 22, 2021 at 9:23 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Oct 22, 2021 at 8:06 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > Probing only the first byte(s) in fault_in() would be ideal, no need to
> > go through all filesystems and try to change the uaccess/probing order.
>
> Let's try that. Or rather: probing just the first page - since there
> are users like that btrfs ioctl, and the direct-io path.

For direct I/O, we actually only want to trigger page fault-in so that
we can grab page references with bio_iov_iter_get_pages. Probing for
sub-page error domains will only slow things down. If we hit -EFAULT
during the actual copy-in or copy-out, we know that the error can't be
page fault related. Similarly, in the buffered I/O case, we only
really care about the next byte, so any probing beyond that is
unnecessary.

So maybe we should split the sub-page error domain probing off from
the fault-in functions. Or at least add an argument to the fault-in
functions that specifies the amount of memory to probe.

Thanks,
Andreas

