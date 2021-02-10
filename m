Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11930315C88
	for <lists+kvm-ppc@lfdr.de>; Wed, 10 Feb 2021 02:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbhBJBrO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Feb 2021 20:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbhBJBpp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 9 Feb 2021 20:45:45 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68CDC061574
        for <kvm-ppc@vger.kernel.org>; Tue,  9 Feb 2021 17:45:02 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id w18so230845pfu.9
        for <kvm-ppc@vger.kernel.org>; Tue, 09 Feb 2021 17:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=KxyuoaSK4UD7JTWVaq2TjS790Q2AD8/YgREaw2QYVpA=;
        b=cVslpHpxJATj6LG8akumCtdAoWmNhCuUh4YqNw+n2PYISMbZcHseUSbPwOPJSCvDOu
         ZGXgrFK53Ko8vQ9c9BVf6hL0G5QS2elqGfZL7w9MyuiqIAYX66o9HibiRizRgimT1+eX
         ZEPuJBTlXkvjjYtvz/mj/JUMMZW952Q+h5iykWKUC+pD9kIHjIvcRf7k+Q7zgOY7BNN/
         Dyf5q6yom5ZOjoZImRYrfzHGWT5DngOWmosttUTXDc55UuEwByVe0EsbveeMIgie7QTn
         1aAGEebFxxJancR5tdBal4DEPu+nrWDrW6YXLShS4Wuuu2VzcnWwOZHbBpw7HaKfSAsH
         kCgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=KxyuoaSK4UD7JTWVaq2TjS790Q2AD8/YgREaw2QYVpA=;
        b=POXqBC+7EFanY5qnuWSMp6130fxYilvH3zgMPGoyMfDGn7J/jzGxkUsG9d828XFIY/
         c5qUvLPkG7cDfuw+Nv+GddM+FAwqsY4fshkAyRpGtV+C2soW8QeIKyWLkXTAiTwoW4GX
         36qCkwIIxs+KmzIsG8oIvnQG0RrNJJxT4zjStwNpkbRaiKiH465pnS4yjsbcf9Kqe6JB
         uWFdk/iLphIuPS49XEK1ebfVva18MmN1CoZVGloHj9F8KKt6eOubnZontmk8F6aXId3Z
         Xp7+aJx3p+Z3QcdjNQduzSpf8C0K+D+fHXa3NJ11o8sDuhiLVnkTksdfOF5iWgNMMILw
         0cgw==
X-Gm-Message-State: AOAM533gBx8hpBrsHVC3i30PxM/qQfz4f7nALLSvsIPgW4V0r9V2GXFd
        o3bWODcU6AG8ItA7ucEYqSqHfMBdL8c=
X-Google-Smtp-Source: ABdhPJyg++6DX5zK43N+S+zZb18I2XYGkcmDy0Xj9O45WfYugINnRSYQkCqbJGIFfgV/7dZ+2mcQJA==
X-Received: by 2002:aa7:8598:0:b029:1dd:9cb4:37ee with SMTP id w24-20020aa785980000b02901dd9cb437eemr901842pfn.54.1612921502362;
        Tue, 09 Feb 2021 17:45:02 -0800 (PST)
Received: from localhost (14-201-150-91.tpgi.com.au. [14.201.150.91])
        by smtp.gmail.com with ESMTPSA id y20sm163614pfo.210.2021.02.09.17.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 17:45:01 -0800 (PST)
Date:   Wed, 10 Feb 2021 11:44:54 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 1/2] KVM: PPC: Book3S HV: Remove shared-TLB optimisation
 from vCPU TLB coherency logic
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org
References: <20210118122609.1447366-1-npiggin@gmail.com>
        <20210209071926.GA2841126@thinks.paulus.ozlabs.org>
        <1612857591.l3d2b98uvh.astroid@bobo.none>
        <20210210003914.GC2854001@thinks.paulus.ozlabs.org>
In-Reply-To: <20210210003914.GC2854001@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Message-Id: <1612919826.6b4hx3kcrb.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Paul Mackerras's message of February 10, 2021 10:39 am:
> On Tue, Feb 09, 2021 at 06:44:53PM +1000, Nicholas Piggin wrote:
>> Excerpts from Paul Mackerras's message of February 9, 2021 5:19 pm:
>> > On Mon, Jan 18, 2021 at 10:26:08PM +1000, Nicholas Piggin wrote:
>> >> Processors that implement ISA v3.0 or later don't necessarily have
>> >> threads in a core sharing all translations, and/or TLBIEL does not
>> >> necessarily invalidate translations on all other threads (the
>> >> architecture talks only about the effect on translations for "the thr=
ead
>> >> executing the tlbiel instruction".
>> >=20
>> > It seems to me that to have an implementation where TLB entries
>> > created on one thread (say T0) are visible to and usable by another
>> > thread (T1), but a tlbiel on thread T0 does not result in the entry
>> > being removed from visibility/usability on T1, is a pretty insane
>> > implementation.  I'm not sure that the architecture envisaged allowing
>> > this kind of implementation, though perhaps the language doesn't
>> > absolutely prohibit it.
>> >=20
>> > This kind of implementation is what you are allowing for in this
>> > patch, isn't it?
>>=20
>> Not intentionally, and patch 2 removes the possibility.
>>=20
>> The main thing it allows is an implementation where TLB entries created=20
>> by T1 which are visble only to T1 do not get removed by TLBIEL on T0.
>=20
> I could understand this patch as trying to accommodate both those
> implementations where TLB entries are private to each thread, and
> those implementations where TLB entries are shared, without needing to
> distinguish between them, at the expense of doing unnecessary
> invalidations on both kinds of implementation.

That's exactly what it is. Existing code accommodates shared TLBs, this=20
patch additionally allows for private.

>> I also have some concern with ordering of in-flight operations (ptesync,
>> memory ordering, etc) which are mostly avoided with this.
>>=20
>> > The sane implementations would be ones where either (a) TLB entries
>> > are private to each thread and tlbiel only works on the local thread,
>> > or (b) TLB entries can be shared and tlbiel works across all threads.
>> > I think this is the conclusion we collectively came to when working on
>> > that bug we worked on towards the end of last year.
>>=20
>> I think an implementation could have both types. So it's hard to get=20
>> away from flushing all threads.
>=20
> Having both private and shared TLB entries in the same implementation
> would seem very odd to me.  What would determine whether a given entry
> is shared or private?

Example: an ERAT or L1 TLB per-thread, and a shared L2 TLB behind that.
The L1 may not be PID/LPID tagged so you don't want to cross-invalidate
other threads every time, say.

Thanks,
Nick
