Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B06315F16
	for <lists+kvm-ppc@lfdr.de>; Wed, 10 Feb 2021 06:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbhBJFet (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 10 Feb 2021 00:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbhBJFej (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 10 Feb 2021 00:34:39 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A73EC061574
        for <kvm-ppc@vger.kernel.org>; Tue,  9 Feb 2021 21:33:59 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id gb24so476643pjb.4
        for <kvm-ppc@vger.kernel.org>; Tue, 09 Feb 2021 21:33:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=ka5u/4623VhUpWA2lZFOTkFFHOaZKNtJ9ggqfvmLma0=;
        b=KJJ4OYi1uT6h7FaCA84QlTRQAZvHWCft9Es8RgaLnCW23c0wPfqti03RxIJDvJcjc0
         LcdXol+Z2btc35reZ1AZkm/YL19MgSAf84pb8cghcUTzBsc8GGO1BWEoMi2corjM/pTg
         Om1UXpj6GI9jHwzWFbf4NImFj10Nvcnm4fEEh6UcGbqG3rrRjke8Z+PgiVWYqLfvjk8Q
         eO8omwSJY/qqR3iVfLiDnN/wdZeCK2M3hrbeq8BZPeqkBHrljHfRAFHoHs/AfMgUT4dN
         Ch9TtjkWEbx5jN1pkdKPBfdIrlxoROcvzoxVZFccjMwd7W+RzjdWWfZ8zXRomiWPRfvl
         yrmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=ka5u/4623VhUpWA2lZFOTkFFHOaZKNtJ9ggqfvmLma0=;
        b=sEX2sifGnZ3qqzS9gLUAUTtJmLZ2h3HkI16dcuBzrCaeQMp5OxjMYZsL+MvuNS5whJ
         d4M0gKZogs1FCMoB/y4jUu8YHNioOKLCIB7oyidXvjiWOCKEJWr3Pgmj+adN2wmubsAY
         Wt6sT5FD7yV8g9SwbVw9LcWIJDs0e5jgo0n+OjlHWyFDCOcBONo6rnf+k6caf2w2iN7U
         zNqawgoZCB074MhFcRdgmV07l8C8Yj0RC/IUnCch8VrOtX+C2LygW2zZLu7MRnuUJqfd
         tIs3PSNfyj3jbvsWIk+fwVhyK55UwEW7hjI5KbmduTm4gJV5mMP+AAzVLLGmmtJz1vMP
         GLWA==
X-Gm-Message-State: AOAM533YHMLncbqrtzzCs8AO6VBdF+TAPWowwlXJBD0ImOlNxgHmZBHB
        AouPfu8AvomPaCVssxSV98mJrTM9xqc=
X-Google-Smtp-Source: ABdhPJxrNcNoXzTF8AY36VGzfbEBU3Cn9uLZ2xn8YnK5EFL6QzpbHfskowo7Ld5dv4y4BpXXTpcg+g==
X-Received: by 2002:a17:902:f545:b029:e1:1466:f42b with SMTP id h5-20020a170902f545b02900e11466f42bmr1438881plf.45.1612935239165;
        Tue, 09 Feb 2021 21:33:59 -0800 (PST)
Received: from localhost (14-201-150-91.tpgi.com.au. [14.201.150.91])
        by smtp.gmail.com with ESMTPSA id t21sm741749pfc.92.2021.02.09.21.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 21:33:58 -0800 (PST)
Date:   Wed, 10 Feb 2021 15:33:53 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 1/2] KVM: PPC: Book3S HV: Remove shared-TLB optimisation
 from vCPU TLB coherency logic
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org
References: <20210118122609.1447366-1-npiggin@gmail.com>
        <20210209071926.GA2841126@thinks.paulus.ozlabs.org>
        <1612857591.l3d2b98uvh.astroid@bobo.none>
        <20210210003914.GC2854001@thinks.paulus.ozlabs.org>
        <1612919826.6b4hx3kcrb.astroid@bobo.none>
        <20210210024646.GE2854001@thinks.paulus.ozlabs.org>
In-Reply-To: <20210210024646.GE2854001@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Message-Id: <1612934661.odpjnmvpwe.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Paul Mackerras's message of February 10, 2021 12:46 pm:
> On Wed, Feb 10, 2021 at 11:44:54AM +1000, Nicholas Piggin wrote:
>> Excerpts from Paul Mackerras's message of February 10, 2021 10:39 am:
>> > On Tue, Feb 09, 2021 at 06:44:53PM +1000, Nicholas Piggin wrote:
>> >> Excerpts from Paul Mackerras's message of February 9, 2021 5:19 pm:
>> >> > On Mon, Jan 18, 2021 at 10:26:08PM +1000, Nicholas Piggin wrote:
>> >> >> Processors that implement ISA v3.0 or later don't necessarily have
>> >> >> threads in a core sharing all translations, and/or TLBIEL does not
>> >> >> necessarily invalidate translations on all other threads (the
>> >> >> architecture talks only about the effect on translations for "the =
thread
>> >> >> executing the tlbiel instruction".
>> >> >=20
>> >> > It seems to me that to have an implementation where TLB entries
>> >> > created on one thread (say T0) are visible to and usable by another
>> >> > thread (T1), but a tlbiel on thread T0 does not result in the entry
>> >> > being removed from visibility/usability on T1, is a pretty insane
>> >> > implementation.  I'm not sure that the architecture envisaged allow=
ing
>> >> > this kind of implementation, though perhaps the language doesn't
>> >> > absolutely prohibit it.
>> >> >=20
>> >> > This kind of implementation is what you are allowing for in this
>> >> > patch, isn't it?
>> >>=20
>> >> Not intentionally, and patch 2 removes the possibility.
>> >>=20
>> >> The main thing it allows is an implementation where TLB entries creat=
ed=20
>> >> by T1 which are visble only to T1 do not get removed by TLBIEL on T0.
>> >=20
>> > I could understand this patch as trying to accommodate both those
>> > implementations where TLB entries are private to each thread, and
>> > those implementations where TLB entries are shared, without needing to
>> > distinguish between them, at the expense of doing unnecessary
>> > invalidations on both kinds of implementation.
>>=20
>> That's exactly what it is. Existing code accommodates shared TLBs, this=20
>> patch additionally allows for private.
>>=20
>> >> I also have some concern with ordering of in-flight operations (ptesy=
nc,
>> >> memory ordering, etc) which are mostly avoided with this.
>> >>=20
>> >> > The sane implementations would be ones where either (a) TLB entries
>> >> > are private to each thread and tlbiel only works on the local threa=
d,
>> >> > or (b) TLB entries can be shared and tlbiel works across all thread=
s.
>> >> > I think this is the conclusion we collectively came to when working=
 on
>> >> > that bug we worked on towards the end of last year.
>> >>=20
>> >> I think an implementation could have both types. So it's hard to get=20
>> >> away from flushing all threads.
>> >=20
>> > Having both private and shared TLB entries in the same implementation
>> > would seem very odd to me.  What would determine whether a given entry
>> > is shared or private?
>>=20
>> Example: an ERAT or L1 TLB per-thread, and a shared L2 TLB behind that.
>> The L1 may not be PID/LPID tagged so you don't want to cross-invalidate
>> other threads every time, say.
>=20
> That's the insane implementation I referred to above, so we're back to
> saying we need to allow for that kind of implementation.

I misunderstood you then.

The really insane implementation we were talking about a couple of=20
months ago is one where a translation can be brought in by T0, then=20
invalidated with TLBIEL on T0, but it is later visible to T1 if it
switches to that context.

A combination of private and shared TLBs I don't see as being insane, so=20
long as (there is the appearance that) 1. translations are not created=20
on threads that are not running that context, and 2. tlbiel invalidates=20
translations visible to that thread.

Thanks,
Nick
