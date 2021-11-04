Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF537445B1C
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Nov 2021 21:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhKDUeA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 4 Nov 2021 16:34:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28696 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231867AbhKDUd7 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 4 Nov 2021 16:33:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636057880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HlUyb94lQB0YUSrmRZ31/WYJ0OQFpRSOr5iyyx2CB+I=;
        b=iZbh4uDLSP6kT7knLw1eAIfBEVznYQ+opQcOSyUDBkZ9FShhYRFB1bBd+Eqr+iUpM6c1Nz
        w2g66LNA7mUQTV++sdSNdLD/FbzjJdfh4N3E3lGk5qvqQy3A8jGgCfZH+u4MSRTRE1fH9S
        GI9TeD/uXnHLI7OrozjVp7RjdEUAJZE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-r1WBkXRvPVmS989H1G-icw-1; Thu, 04 Nov 2021 16:31:19 -0400
X-MC-Unique: r1WBkXRvPVmS989H1G-icw-1
Received: by mail-wr1-f72.google.com with SMTP id y4-20020adfd084000000b00186b16950f3so1434241wrh.14
        for <kvm-ppc@vger.kernel.org>; Thu, 04 Nov 2021 13:31:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HlUyb94lQB0YUSrmRZ31/WYJ0OQFpRSOr5iyyx2CB+I=;
        b=QBVF03JdvS8XGEMJY7KlVHKfjWJDPhYDicFB/SfbdzOLR2uXT3VNHUYyA4WRQpGTBE
         XbwBUpaOLWQuU+3lBhkbrabcOTyVsaUHNQtZxrfNfMUdzzc9IdWBXFf6/pMKHqpQb6pW
         8rbxd6D9CZ18oGw6mf3jnBqMQLy9eikQwVMZuGogbd+w6CvL7Qf16PHMjz6rrrWCGrEo
         hjUy5r7ug+WW5yO1JwJptFTK+l2B36hNW14t1mVNfX+Nz+7dSrSUGTDFoqpiFN4nxAgo
         upRyZZ6dEKT+zRuw2sbjUkVzKwu/VWvqnLD3DRNQ6Zo8dqepBBAgUcrlyQRgHzBNoowE
         OWsg==
X-Gm-Message-State: AOAM532RW5RIltp4ZqmC0tTyGVZ3vIEnZK+JU4EoorsJAXz7LDSV91HM
        P8WpeLpSySHk3MHmQmM9MfbA8obuEBNT3VhkAgL0k4obYwz1Y3tlxOc9hJ63z6iihRiG4pvyjc+
        94mkEBGpacw1Mwwc3Mr8F3usjQ77kR7erYQ==
X-Received: by 2002:a5d:628f:: with SMTP id k15mr55558394wru.363.1636057878501;
        Thu, 04 Nov 2021 13:31:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzy1DT2zp9sqf5BtrQx4eQL+9Qk0WkCFqWYvRSY0pAibZ7MAIDeuCyzWc0voG6eZ/QZ2qH8hnGM3VUV2a9qxnY=
X-Received: by 2002:a5d:628f:: with SMTP id k15mr55558351wru.363.1636057878260;
 Thu, 04 Nov 2021 13:31:18 -0700 (PDT)
MIME-Version: 1.0
References: <20211102122945.117744-1-agruenba@redhat.com> <20211102122945.117744-5-agruenba@redhat.com>
 <YYQk9L0D57QHc0gE@arm.com>
In-Reply-To: <YYQk9L0D57QHc0gE@arm.com>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Thu, 4 Nov 2021 21:31:07 +0100
Message-ID: <CAHc6FU5DsC5C+aOTPX+MV+_49-V_RvyOWKNzcjoVfY=OzEVuAw@mail.gmail.com>
Subject: Re: [PATCH v9 04/17] iov_iter: Turn iov_iter_fault_in_readable into fault_in_iov_iter_readable
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     cluster-devel <cluster-devel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>, Jan Kara <jack@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com,
        kvm-ppc@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>,
        joey.gouly@arm.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Nov 4, 2021 at 7:22 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Tue, Nov 02, 2021 at 01:29:32PM +0100, Andreas Gruenbacher wrote:
> > Turn iov_iter_fault_in_readable into a function that returns the number
> > of bytes not faulted in, similar to copy_to_user, instead of returning a
> > non-zero value when any of the requested pages couldn't be faulted in.
> > This supports the existing users that require all pages to be faulted in
> > as well as new users that are happy if any pages can be faulted in.
> >
> > Rename iov_iter_fault_in_readable to fault_in_iov_iter_readable to make
> > sure this change doesn't silently break things.
> >
> > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> [...]
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index ff34f4087f87..4dd5edcd39fd 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -3757,7 +3757,7 @@ ssize_t generic_perform_write(struct file *file,
> >                * same page as we're writing to, without it being marked
> >                * up-to-date.
> >                */
> > -             if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
> > +             if (unlikely(fault_in_iov_iter_readable(i, bytes))) {
> >                       status = -EFAULT;
> >                       break;
> >               }
>
> Now that fault_in_iov_iter_readable() returns the number of bytes, we
> could change the above test to:
>
>                 if (unlikely(fault_in_iov_iter_readable(i, bytes) == bytes)) {
>
> Assuming we have a pointer 'a', accessible, and 'a + PAGE_SIZE' unmapped:
>
>         write(fd, a + PAGE_SIZE - 1, 2);
>
> can still copy one byte but it returns -EFAULT instead since the second
> page is not accessible.
>
> While writing some test-cases for MTE (sub-page faults, 16-byte
> granularity), we noticed that reading 2 bytes from 'a + 15' with
> 'a + 16' tagged for faulting:
>
>         write(fd, a + 15, 2);
>
> succeeds as long as 'a + 16' is not at a page boundary. Checking against
> 'bytes' above makes this consistent.
>
> The downside is that it's an ABI change though not sure anyone is
> relying on it.

The same pattern exists in iomap_write_iter too, of course. In the
very light testing I did for eliminating the pre-faulting, this kind
of change was working fine. I have no performance numbers though.

  https://lore.kernel.org/linux-fsdevel/20211026094430.3669156-1-agruenba@redhat.com/
  https://lore.kernel.org/linux-fsdevel/20211027212138.3722977-1-agruenba@redhat.com/

Thanks,
Andreas

