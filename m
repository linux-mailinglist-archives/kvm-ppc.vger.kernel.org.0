Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB943EDC19
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Aug 2021 19:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhHPRLi (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Aug 2021 13:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbhHPRLh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 16 Aug 2021 13:11:37 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E450DC0613C1
        for <kvm-ppc@vger.kernel.org>; Mon, 16 Aug 2021 10:11:04 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id u22so4721737lfq.13
        for <kvm-ppc@vger.kernel.org>; Mon, 16 Aug 2021 10:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vMMb4LU8I/SSdOh5kDDQxYQsVy+zic4iTvxGmme0W+w=;
        b=DQ1YzDDCUc0s4buLxDE7pPgWrS7zvaM2Ye5O1kmIi3i4IWcnpDBNQS1aZqq9UAS83i
         S+aV5Q+r5TuiraFtlZ/+2JRbnUwXmhFnEPHsZG4ZClcpH0hNPFjBY/t4ep59b6gg4sGN
         6VONK496qhLfXdCtcHDodq6IlCfwMZ82i3AixZD+6GGUspwYfdU9s2ipfm5TZgCmapjA
         jaj4WtPOFWng9pKK3oSkK05qg0PNl37wSxLmnyZk1ubWvd+OzwH/4oDtOhuHR9PB8Jem
         V+y7D75Q4XP1GQQc9vMBY6lBYXm3dN1nldZoopg/BV4KHHViMkhjSmJ40CFZ9Qjagihg
         lzbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vMMb4LU8I/SSdOh5kDDQxYQsVy+zic4iTvxGmme0W+w=;
        b=Gbh9ZSrHnPf9EpWa4XxKcgH+HZbPdNtz6aV3avCe0wLVk5x1FztUxXFMBSJeMcg2hp
         BZzqKWRWwr/w9yWd0twWBOgon8nsMTRUlMRP5ZhPLKQ0jxiuKVEvrVpsbH2oV+6wPZB4
         S8wIwNK0BZzwTPKCVavvWbUWtsD2cJjBbfZCTxyEXWNjL6jsZ18yMpHf7oC5zvufQtkl
         SmUYU+BSkWXFLA2lpC2yoWqKP9jT/r0bD5FpcL7qBoY1pVvPsDv6Ebk2c2GEIIsEkZXt
         U++7ZyaTbaZXi57R3zgLek9nruTHjAwEckdRlu0SS7LAQyNdb9lHLL6FLbGyG8e7jiW9
         LmCw==
X-Gm-Message-State: AOAM533Hogy1AocbIzBX4GXyU59CpaUzaeJ4yUmKn2Ie8khvaLrf9joh
        i10r+KOWT8ToKwk7G0Y1DHfNdIl28UuzZh/V0QRLAw==
X-Google-Smtp-Source: ABdhPJy/VGzQ64TxuWTYy+SEVYAKoflKNBVWguzBknLH1QYeedLemTQ9SQGd3PAOsKKvj1ELKUmrZPXAYZwFwKpVPPs=
X-Received: by 2002:a05:6512:3f5:: with SMTP id n21mr7838880lfq.359.1629133862948;
 Mon, 16 Aug 2021 10:11:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210813195433.2555924-1-jingzhangos@google.com> <YRcMAXvvI/Kphb5R@google.com>
In-Reply-To: <YRcMAXvvI/Kphb5R@google.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Mon, 16 Aug 2021 10:10:52 -0700
Message-ID: <CAAdAUtgo883HWgxQDgD-wofd=bW4HqozvCRhh8nEEbU-c0nbQQ@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: stats: Add VM stat for the cumulative number of
 dirtied pages
To:     Sean Christopherson <seanjc@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Peter Feiner <pfeiner@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Aug 13, 2021 at 5:19 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Aug 13, 2021, Jing Zhang wrote:
> > A per VCPU stat dirtied_pages is added to record the number of dirtied
> > pages in the life cycle of a VM.
> > The growth rate of this stat is a good indicator during the process of
> > live migrations. The exact number of dirty pages at the moment doesn't
> > matter. That's why we define dirtied_pages as a cumulative counter instead
> > of an instantaneous one.
> >
> > Original-by: Peter Feiner <pfeiner@google.com>
> > Suggested-by: Oliver Upton <oupton@google.com>
> > Reviewed-by: Oliver Upton <oupton@google.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 3e67c93ca403..8c673198cc83 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -3075,6 +3075,8 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
> >                            struct kvm_memory_slot *memslot,
> >                            gfn_t gfn)
> >  {
> > +     struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> > +
> >       if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
> >               unsigned long rel_gfn = gfn - memslot->base_gfn;
> >               u32 slot = (memslot->as_id << 16) | memslot->id;
> > @@ -3084,6 +3086,9 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
> >                                           slot, rel_gfn);
> >               else
> >                       set_bit_le(rel_gfn, memslot->dirty_bitmap);
> > +
> > +             if (vcpu)
> > +                     ++vcpu->stat.generic.dirtied_pages;
>
> I agree with Peter that this is a solution looking for a problem, and the stat is
> going to be confusing because it's only active if dirty logging is enabled.
>
> For Oliver's debug use case, it will require userspace to coordinate reaping the
> dirty bitmap/ring with the stats, otherwise there's no baseline, e.g. the number
> of dirtied pages will scale with how frequently userspace is clearing dirty bits.
>
> At that point, userspace can do the whole thing itself, e.g. with a dirty ring
> it's trivial to do "dirtied_pages += ring->dirty_index - ring->reset_index".
> The traditional bitmap will be slower, but without additional userspace enabling
> the dirty logging dependency means this is mostly limited to live migration being
> in-progress.  In that case, something in userspace needs to actually be processing
> the dirty pages, it should be easy for that something to keep a running count.
Thanks Sean. Looks like it is not a bad idea to drop this change. Will do that.

Jing
