Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17BD6453375
	for <lists+kvm-ppc@lfdr.de>; Tue, 16 Nov 2021 15:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237019AbhKPODh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 16 Nov 2021 09:03:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21245 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237011AbhKPODd (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 16 Nov 2021 09:03:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637071235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AQWT9RsItIh3/PVThc0IzK61qGCHH7mYKsvmzbBvIIU=;
        b=ipFEV9z+5N0l7ZXte9d/sXOnmSuRcgq/ckodIqCApH7lSVfsWgvkzM/c2h32VWj9jjX0MT
        A8TadtOAJV5BGUDWCBSZNWgIbNihCk46KC8zNr9QFSN7iwzVuT4cIwUgjvRxrSTF7uIxAx
        x2ZG2gd9/XsZQeg5JzW1DaozKWgsWzk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-QwTS8WzpMhmgxK_Jki2t1g-1; Tue, 16 Nov 2021 09:00:34 -0500
X-MC-Unique: QwTS8WzpMhmgxK_Jki2t1g-1
Received: by mail-wm1-f71.google.com with SMTP id m18-20020a05600c3b1200b0033283ea5facso698151wms.1
        for <kvm-ppc@vger.kernel.org>; Tue, 16 Nov 2021 06:00:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AQWT9RsItIh3/PVThc0IzK61qGCHH7mYKsvmzbBvIIU=;
        b=HKjrpxmPxKJnmK9+gs666p0xzh/gncFrAoTnJBqBUkB+lGbXA8DultGwXXhDICufl7
         kUMEv6H1Pf8k32oCVrMyNXhZG5q1heo7XPwC0ETswGVG2Y5ROwpnifY4kGtn6JLtWg2g
         7PBs/9AidBKKwLyV8w4XOlUUB3ydKOL4vQmBzAYAvTgFZqypWmaN3z8RltLOKMLO5luU
         d0/9sRFO3jCFcsH88+3YGwKOH56o2+QhH24dcj83aT4cb7wuNCdWZftTe/BRvyEC8PxO
         UQgj0m/GS1dtDXu3HY+S17fo7fEBrinQJmeJaA9fsjc80B5Dcnmoyv3alqbq3Q401ipt
         zKXg==
X-Gm-Message-State: AOAM532ooI43a6rTerhWnpNkpCcwfo/x262Jz4dQaukU+tOgHjCLjHBG
        EoVCUL6p8OHHcHBpco8Y02xmHQWjI36W5L80Kj+W9TkIwXzZNLIzKgOTxxPU7GfMaCbeSx4o5+D
        R3dKpwyNc7HB9NDBZPbRdbqsOanmwTNhNXQ==
X-Received: by 2002:a1c:ed1a:: with SMTP id l26mr71507142wmh.19.1637071231354;
        Tue, 16 Nov 2021 06:00:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyrxhf6z7sBAJvOpOOUlfL2JU/LuAMJYJ+PkN53D7lmXU6CXnBwDHswetyBwnxBUgS4/QIsBFAXBYWEfbCCjFQ=
X-Received: by 2002:a1c:ed1a:: with SMTP id l26mr71507103wmh.19.1637071231144;
 Tue, 16 Nov 2021 06:00:31 -0800 (PST)
MIME-Version: 1.0
References: <20211115165313.549179499@linuxfoundation.org> <20211115165315.847107930@linuxfoundation.org>
 <CAHc6FU7a+gTDCZMCE6gOH1EDUW5SghPbQbsbeVtdg4tV1VdGxg@mail.gmail.com>
 <YZMBVdDZzjE6Pziq@sashalap> <CAHc6FU4cgAXc2GxYw+N=RACPG0xc=urrrqw8Gc3X1Rpr4255pg@mail.gmail.com>
 <YZO4wIfpjxnzZjuh@kroah.com>
In-Reply-To: <YZO4wIfpjxnzZjuh@kroah.com>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Tue, 16 Nov 2021 15:00:19 +0100
Message-ID: <CAHc6FU7BU2-B2x=JV0HtLci6=mGy2XxLNNGh1f4DGtVbeJFcVA@mail.gmail.com>
Subject: Re: [PATCH 5.4 063/355] powerpc/kvm: Fix kvm_use_magic_page
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Mathieu Malaterre <malat@debian.org>,
        Paul Mackerras <paulus@ozlabs.org>, kvm-ppc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Nov 16, 2021 at 2:57 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Nov 16, 2021 at 02:54:10PM +0100, Andreas Gruenbacher wrote:
> > On Tue, Nov 16, 2021 at 1:54 AM Sasha Levin <sashal@kernel.org> wrote:
> > > On Mon, Nov 15, 2021 at 06:47:41PM +0100, Andreas Gruenbacher wrote:
> > > >Greg,
> > > >
> > > >On Mon, Nov 15, 2021 at 6:10 PM Greg Kroah-Hartman
> > > ><gregkh@linuxfoundation.org> wrote:
> > > >> From: Andreas Gruenbacher <agruenba@redhat.com>
> > > >>
> > > >> commit 0c8eb2884a42d992c7726539328b7d3568f22143 upstream.
> > > >>
> > > >> When switching from __get_user to fault_in_pages_readable, commit
> > > >> 9f9eae5ce717 broke kvm_use_magic_page: like __get_user,
> > > >> fault_in_pages_readable returns 0 on success.
> > > >
> > > >I've not heard back from the maintainers about this patch so far, so
> > > >it would probably be safer to leave it out of stable for now.
> > >
> > > What do you mean exactly? It's upstream.
> >
> > Mathieu Malaterre broke this test in 2018 (commit 9f9eae5ce717) but
> > that wasn't noticed until now (commit 0c8eb2884a42). This means that
> > this fix probably isn't critical, so I shouldn't be backported.
>
> Then why did you tag it to be explicitly backported to all stable
> kernels newer than 4.18?

Well, sorry for that. What else do you expect me to do in addition to
pointing out the mistake?

Thanks,
Andreas

