Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAD1314AB9
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Feb 2021 09:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhBIIsZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Feb 2021 03:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbhBIIpl (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 9 Feb 2021 03:45:41 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1560C06178A
        for <kvm-ppc@vger.kernel.org>; Tue,  9 Feb 2021 00:44:59 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id c132so12025963pga.3
        for <kvm-ppc@vger.kernel.org>; Tue, 09 Feb 2021 00:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=fSzrvaDAro6eLy1On1Rc8/lyfF7tpixbfC9OjdGko54=;
        b=cmHpIZz0yPz5olEjACMVDjExTdjnavhMPGBJ+0HrjpyAd4JIEKY785fZJvektyx9RD
         A46QoSo4zEb2GEWGf7tEWdZPearnROR/mvhSrj13p0AJYMMwHllBMsNYgdjYTpgPd5y7
         cCJVZ1TBAHdbKfy7ZGNguelnLYSkgD3L0Z/Uw4VrSQQ2FWJyUIjSYYg13xx/Ol4nWBjW
         jlERYivns8GzTP3u7Lo8ZQ2Wfwi7zyBSIKaK0q7DZpbXHCvaqpF4mzIUEL6fhuThsfuR
         FYmTM8msSAokL4BxtIj0luY1G8NjzmV0hHmqL7cgxwgvnb3Fpry6kyK/4XRmI+LBnunp
         Y5Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=fSzrvaDAro6eLy1On1Rc8/lyfF7tpixbfC9OjdGko54=;
        b=T9T9oEJH2j5D42OI+z3sN0wKkaD9BlTblLiDgstdBqQcDUTVWZMXhBmF/c8VXlDbGq
         G3uPLl91MJOic9iX/HDaQxhZOFbkdKT3M96V3MNJplFsx0GBrDPM6p662Dgc7oM+UvlW
         7hydGsC/tc6aYdr4WPrbud3RW3Bkl5hWkjhmA6gS2hCj7H77aDNPsb+PC3+zPUOq1zWm
         YVUnPsKJHR89MBLHoNe+mq/HpqjQ/CN8N/90yKb84PmVFfM69jjw3vs4YfIpXewclWA3
         LRXPVrD72sWA03C4bMQkqh6NO1ldV/9lgCVE0iZi2LpwRBP4HPT6Y5H4CS1X/qiv9Lg3
         lEWg==
X-Gm-Message-State: AOAM532NzF0jug08Jan8lxSBKVQs7X97Uwz6xWXnfomDlgRkKaUgxNO5
        U5TvuoP2kfJbN69zazQdCB8FPtclZHU=
X-Google-Smtp-Source: ABdhPJw9HDnH69H1In0/rrI5712C6cz7HhsRaCnvwvJS84oxU31cHdDNtrgIPYQ2zLgzf+2MDi55RA==
X-Received: by 2002:a63:205f:: with SMTP id r31mr18372805pgm.328.1612860299521;
        Tue, 09 Feb 2021 00:44:59 -0800 (PST)
Received: from localhost (14-201-150-91.tpgi.com.au. [14.201.150.91])
        by smtp.gmail.com with ESMTPSA id z2sm10334163pfj.100.2021.02.09.00.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 00:44:58 -0800 (PST)
Date:   Tue, 09 Feb 2021 18:44:53 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 1/2] KVM: PPC: Book3S HV: Remove shared-TLB optimisation
 from vCPU TLB coherency logic
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org
References: <20210118122609.1447366-1-npiggin@gmail.com>
        <20210209071926.GA2841126@thinks.paulus.ozlabs.org>
In-Reply-To: <20210209071926.GA2841126@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Message-Id: <1612857591.l3d2b98uvh.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Paul Mackerras's message of February 9, 2021 5:19 pm:
> On Mon, Jan 18, 2021 at 10:26:08PM +1000, Nicholas Piggin wrote:
>> Processors that implement ISA v3.0 or later don't necessarily have
>> threads in a core sharing all translations, and/or TLBIEL does not
>> necessarily invalidate translations on all other threads (the
>> architecture talks only about the effect on translations for "the thread
>> executing the tlbiel instruction".
>=20
> It seems to me that to have an implementation where TLB entries
> created on one thread (say T0) are visible to and usable by another
> thread (T1), but a tlbiel on thread T0 does not result in the entry
> being removed from visibility/usability on T1, is a pretty insane
> implementation.  I'm not sure that the architecture envisaged allowing
> this kind of implementation, though perhaps the language doesn't
> absolutely prohibit it.
>=20
> This kind of implementation is what you are allowing for in this
> patch, isn't it?

Not intentionally, and patch 2 removes the possibility.

The main thing it allows is an implementation where TLB entries created=20
by T1 which are visble only to T1 do not get removed by TLBIEL on T0.
I also have some concern with ordering of in-flight operations (ptesync,
memory ordering, etc) which are mostly avoided with this.

> The sane implementations would be ones where either (a) TLB entries
> are private to each thread and tlbiel only works on the local thread,
> or (b) TLB entries can be shared and tlbiel works across all threads.
> I think this is the conclusion we collectively came to when working on
> that bug we worked on towards the end of last year.

I think an implementation could have both types. So it's hard to get=20
away from flushing all threads.

If the vCPU ran on T0 then migrated to another core, then before running=20
a vCPU from the same LPAR in this core again, we could flush _just_ T0=20
and that should be fine, but if the vCPU was scheduled onto T1 first, we=20
would have to flush to catch shared xlates. But if we flush on T1, then=20
we would still have to flush T0 when that ran the LPID again to catch=20
the private xlates (but probably would not have to flush T2 or T3).

We could catch that and optimise it with a shared mask and a private mask,
but it seems like a lot of complexity and memory ordering issues for=20
unclear gain.

>=20
>> While this worked for POWER9, it may not for future implementations, so
>> remove it. A POWER9 specific optimisation would have to have a specific
>> CPU feature to check, if it were to be re-added.
>=20
> Did you do any measurements of how much performance impact this has on
> POWER9?

I don't think I've really been able to generate enough CPU migrations to=20
cause a blip. Not to say it doesn't have an impact just that I don't=20
know how to create a worst case load (short of spamming vCPus with=20
sched_setaffinity calls).


> I don't believe this patch will actually be necessary on
> POWER10, so it seems like this patch is just to allow for some
> undefined possible future CPU.  It may still be worth putting in for
> the sake of strict architecture compliance if the performance impact
> is minimal.

AFAIK we still have an issue upstream with other known fixes in,
that was fixed with this patch.

Thanks,
Nick
