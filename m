Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA06453349
	for <lists+kvm-ppc@lfdr.de>; Tue, 16 Nov 2021 14:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236911AbhKPN5p (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 16 Nov 2021 08:57:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45966 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236920AbhKPN5W (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 16 Nov 2021 08:57:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637070865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L0l8U98gykrEb+6mbIddDuP0F41+6lCqLlmJs6JdFso=;
        b=Pp8LDO4NClydwzyHNH6XaE92wVnVHs+wJ//i3B5ApZnKMpX8i4gAVHSTshUlBRQn/wDINA
        KdpB4pKUsXdcY9wkc9I6j5+4BDg+SJlDP9kAePa54nXB9KDl6rVfrVtk93SiOoB3/o7B8u
        mR33QfX+AIfEQZpUyhUZ0z0bw3A+Fjo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-yT2yr58aM6KxmlNmaxnoIA-1; Tue, 16 Nov 2021 08:54:24 -0500
X-MC-Unique: yT2yr58aM6KxmlNmaxnoIA-1
Received: by mail-wr1-f70.google.com with SMTP id d7-20020a5d6447000000b00186a113463dso4488145wrw.10
        for <kvm-ppc@vger.kernel.org>; Tue, 16 Nov 2021 05:54:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L0l8U98gykrEb+6mbIddDuP0F41+6lCqLlmJs6JdFso=;
        b=5MQVLiborLjQOAATgx/eVazC82kxACU6kX2rhlPtuX7OwCdA1VwU+cz5DZC/cyCUd7
         EcdQW5hDZboF3VJhedJFQvChlEcrNw5Str82t3RLZq0xmFo9TF29r4t27uzUDfrdDnwy
         JvVLwn2TDV0CjsO1rywUdQRe2LTuG0Wz61OOuf2WPgEw/FjHB0fWVcP56iN8t2IjuSHo
         kABv869WIOKlO2dLEA/nV5b94nbuIFFsuxy1dApan9kIynWUmWNmH1Lig2YPltwTbdry
         OJNmZJIoufNlB0/wwM1zDqn3Jsg17n8F3pKHS123fmPi+W2hY1r7UVgJMmFq1ZCXZ3IO
         EhZQ==
X-Gm-Message-State: AOAM531ADy9+tqnP8YEWWVBhOTO28JeEjlqjZKT1UjugRBEt3BnUX+1L
        k3NJrkuwmLQ7VPKnxRfxNBa2p/X06sd3h5LPP4xype1G8mjL0aUaVi02k/SotcFdk2LOys703Sv
        AUbDfHFpPKgUMWeVYyTH/GoiTGB7wax8HGg==
X-Received: by 2002:a05:600c:1ca0:: with SMTP id k32mr8157166wms.74.1637070861991;
        Tue, 16 Nov 2021 05:54:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzkE0ZUdhTupcolHEn3mZwOjI5RxolJG8TsOzucbh8Kv+FGnxDoIbqJ9yNpgl/Dl6oTuf5XlMzsyqFNl9LN+Zk=
X-Received: by 2002:a05:600c:1ca0:: with SMTP id k32mr8157134wms.74.1637070861810;
 Tue, 16 Nov 2021 05:54:21 -0800 (PST)
MIME-Version: 1.0
References: <20211115165313.549179499@linuxfoundation.org> <20211115165315.847107930@linuxfoundation.org>
 <CAHc6FU7a+gTDCZMCE6gOH1EDUW5SghPbQbsbeVtdg4tV1VdGxg@mail.gmail.com> <YZMBVdDZzjE6Pziq@sashalap>
In-Reply-To: <YZMBVdDZzjE6Pziq@sashalap>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Tue, 16 Nov 2021 14:54:10 +0100
Message-ID: <CAHc6FU4cgAXc2GxYw+N=RACPG0xc=urrrqw8Gc3X1Rpr4255pg@mail.gmail.com>
Subject: Re: [PATCH 5.4 063/355] powerpc/kvm: Fix kvm_use_magic_page
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Mathieu Malaterre <malat@debian.org>,
        Paul Mackerras <paulus@ozlabs.org>, kvm-ppc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Nov 16, 2021 at 1:54 AM Sasha Levin <sashal@kernel.org> wrote:
> On Mon, Nov 15, 2021 at 06:47:41PM +0100, Andreas Gruenbacher wrote:
> >Greg,
> >
> >On Mon, Nov 15, 2021 at 6:10 PM Greg Kroah-Hartman
> ><gregkh@linuxfoundation.org> wrote:
> >> From: Andreas Gruenbacher <agruenba@redhat.com>
> >>
> >> commit 0c8eb2884a42d992c7726539328b7d3568f22143 upstream.
> >>
> >> When switching from __get_user to fault_in_pages_readable, commit
> >> 9f9eae5ce717 broke kvm_use_magic_page: like __get_user,
> >> fault_in_pages_readable returns 0 on success.
> >
> >I've not heard back from the maintainers about this patch so far, so
> >it would probably be safer to leave it out of stable for now.
>
> What do you mean exactly? It's upstream.

Mathieu Malaterre broke this test in 2018 (commit 9f9eae5ce717) but
that wasn't noticed until now (commit 0c8eb2884a42). This means that
this fix probably isn't critical, so I shouldn't be backported.

Thanks,
Andreas

