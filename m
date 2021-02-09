Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEFD1314F93
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Feb 2021 13:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhBIM6S (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Feb 2021 07:58:18 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:7414 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbhBIM6Q (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 9 Feb 2021 07:58:16 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602286be0002>; Tue, 09 Feb 2021 04:57:34 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 9 Feb
 2021 12:57:33 +0000
Received: from nvdebian.localnet (172.20.145.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 9 Feb 2021
 12:57:31 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     Daniel Vetter <daniel@ffwll.ch>
CC:     Linux MM <linux-mm@kvack.org>,
        Nouveau Dev <nouveau@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <kvm-ppc@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        John Hubbard <jhubbard@nvidia.com>,
        "Ralph Campbell" <rcampbell@nvidia.com>,
        Jerome Glisse <jglisse@redhat.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>
Subject: Re: [PATCH 0/9] Add support for SVM atomics in Nouveau
Date:   Tue, 9 Feb 2021 23:57:28 +1100
Message-ID: <3426910.QXTomnrpqD@nvdebian>
In-Reply-To: <CAKMK7uGwg2-DTU7Zrco=TSkcR4yTqN1AF0hvVYEAbuj4BUYi5Q@mail.gmail.com>
References: <20210209010722.13839-1-apopple@nvidia.com> <CAKMK7uGwg2-DTU7Zrco=TSkcR4yTqN1AF0hvVYEAbuj4BUYi5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612875454; bh=pYEk+wLn0WR1PrJ8wQ1bjhLk8lHthKCYTa7kbR8IFPs=;
        h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
         MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=foqYIUG2YToD3++t7RvC/O9TLWkjJUt0Pltnbtp0sR7pywI+cAebvYhi317cAbNSr
         VydpmfsuTknwcWRlTd66EAz+R9xSNztHwSP33xHyJAFQvtLRUTbQwRXbndoMK1lEJF
         TgGwAN2SUxtBZ0f/e/IcLq8SSJy7c2LekoisE4ZVwBU2poXVLnVfl7U8hpridXMyTn
         zY0KnpayTxNuJk+qBbJ9n86Xy1k8+uiNA0lT4Gdz/v0kUB8yYnf3zATNUu2lkU6Fvq
         5VmynfHHE2DRHRW2grMjAJ7J08c/7pJHmKRf11bdHcei9X2GIi/a2HEZYETdgloJ6u
         m+MEA871VmIWA==
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tuesday, 9 February 2021 9:27:05 PM AEDT Daniel Vetter wrote:
> >
> > Recent changes to pin_user_pages() prevent the creation of pinned pages in
> > ZONE_MOVABLE. This series allows pinned pages to be created in 
ZONE_MOVABLE
> > as attempts to migrate may fail which would be fatal to userspace.
> >
> > In this case migration of the pinned page is unnecessary as the page can 
be
> > unpinned at anytime by having the driver revoke atomic permission as it
> > does for the migrate_to_ram() callback. However a method of calling this
> > when memory needs to be moved has yet to be resolved so any discussion is
> > welcome.
> 
> Why do we need to pin for gpu atomics? You still have the callback for
> cpu faults, so you
> can move the page as needed, and hence a long-term pin sounds like the
> wrong approach.

Technically a real long term unmoveable pin isn't required, because as you say 
the page can be moved as needed at any time. However I needed some way of 
stopping the CPU page from being freed once the userspace mappings for it had 
been removed. Obviously I could have just used get_page() but from the 
perspective of page migration the result is much the same as a pin - a page 
which can't be moved because of the extra refcount.

The normal solution of registering an MMU notifier to unpin the page when it 
needs to be moved also doesn't work as the CPU page tables now point to the 
device-private page and hence the migration code won't call any invalidate 
notifiers for the CPU page.

> That would avoid all the hacking around long term pin constraints, because
> for real unmoveable long term pinned memory we really want to have all
> these checks. So I think we might be missing some other callbacks to be
> able to move these pages, instead of abusing longterm pins for lack of
> better tools.

Yes, I would like to avoid the long term pin constraints as well if possible I 
just haven't found a solution yet. Are you suggesting it might be possible to 
add a callback in the page migration logic to specially deal with moving these 
pages?

Thanks, Alistair

> Cheers, Daniel
> 
> 
> 
> >
> > Alistair Popple (9):
> >   mm/migrate.c: Always allow device private pages to migrate
> >   mm/migrate.c: Allow pfn flags to be passed to migrate_vma_setup()
> >   mm/migrate: Add a unmap and pin migration mode
> >   Documentation: Add unmap and pin to HMM
> >   hmm-tests: Add test for unmap and pin
> >   nouveau/dmem: Only map migrating pages
> >   nouveau/svm: Refactor nouveau_range_fault
> >   nouveau/dmem: Add support for multiple page types
> >   nouveau/svm: Implement atomic SVM access
> >
> >  Documentation/vm/hmm.rst                      |  22 +-
> >  arch/powerpc/kvm/book3s_hv_uvmem.c            |   4 +-
> >  drivers/gpu/drm/nouveau/include/nvif/if000c.h |   1 +
> >  drivers/gpu/drm/nouveau/nouveau_dmem.c        | 190 +++++++++++++++---
> >  drivers/gpu/drm/nouveau/nouveau_dmem.h        |   9 +
> >  drivers/gpu/drm/nouveau/nouveau_svm.c         | 148 +++++++++++---
> >  drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.h |   1 +
> >  .../drm/nouveau/nvkm/subdev/mmu/vmmgp100.c    |   6 +
> >  include/linux/migrate.h                       |   2 +
> >  include/linux/migrate_mode.h                  |   1 +
> >  lib/test_hmm.c                                | 109 ++++++++--
> >  lib/test_hmm_uapi.h                           |   1 +
> >  mm/migrate.c                                  |  82 +++++---
> >  tools/testing/selftests/vm/hmm-tests.c        |  49 +++++
> >  14 files changed, 524 insertions(+), 101 deletions(-)
> >
> > --
> > 2.20.1
> >
> 
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch




