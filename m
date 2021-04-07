Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0A6356827
	for <lists+kvm-ppc@lfdr.de>; Wed,  7 Apr 2021 11:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345947AbhDGJf7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 7 Apr 2021 05:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350187AbhDGJf5 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 7 Apr 2021 05:35:57 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F024EC06175F
        for <kvm-ppc@vger.kernel.org>; Wed,  7 Apr 2021 02:35:46 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id l123so10964440pfl.8
        for <kvm-ppc@vger.kernel.org>; Wed, 07 Apr 2021 02:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=ZVfKBalueTSgx5OM8QhCg5tppz9Kqf0PHs1cKuDosxY=;
        b=IlI3gz6rmZE1g6Lr92QfSvO1jp0oUCgzsUDPV0c4ta5CPrtBiHImp5Q3bjTVMh1Rlq
         AIAilsI7WBQgT41uReuS2IOgd6BPXvnxJTl2DpnjrD21J/KRHaHY+AfDEnNMGe2S3c5r
         pXZRlUXVskQ8xTcncDLhulAgSiLfc64W9mrRPabsH4cg5FBzqs+hsEn5UiKqP7vUZbsz
         5JHgTwxe0B9oXVNf88sE0r4dWjr12Xvn7uMOmEww3HcFXHfvzSLtUez/uRtIstKLlVD9
         DwCxOZoWpAqfAQ/Xg05paUMd4E6+DPWc43f/1Pct7JPk8XziuTWOHUuQchw88gC4gwHc
         Segg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=ZVfKBalueTSgx5OM8QhCg5tppz9Kqf0PHs1cKuDosxY=;
        b=HLWp0qUvzeUhOcxf6RyqRL5HWg6Ws+8Fr3jZsWQF1OwmPjpT711j7w1JCVLV+a9uH6
         SevpRQdQcNZNII1VIxHfhQxalGfNCKG5jNkEObOn22lHyluTnm5LFhtj+qM6ZfPm47ms
         BDBLNJ3CJPeqP5OL/VNz/GSNCcWw3HhTsXkAObkXKsh+tP3udV1a48HJvP9gGuIWGPpD
         H5mwMRASuT9IuCrDJOFPyF7WtuIblelcgEhmSw+oq+E/B0Ru+jEXB6krP+CQj4UNOjD0
         uRlxbYP75YezpyS583GOfGPBxrymykQl+zoCt1V1WHGqL++2OoXR2hjEWU38/4R74iUU
         LP6g==
X-Gm-Message-State: AOAM531f3Dat2vGoNE0MWkVfvSgCf5IyPzQrRbrmFUs8CJBsye7AEL/J
        5CEw4/ttXjI90ScS0qEWngI=
X-Google-Smtp-Source: ABdhPJxBWevds9psSxRVML0ZYqbSkhf4IYBWg75auTJad2dREclOYkr/V28gnKKaT4t9MnCpmhdyNQ==
X-Received: by 2002:a63:f715:: with SMTP id x21mr2401572pgh.399.1617788146335;
        Wed, 07 Apr 2021 02:35:46 -0700 (PDT)
Received: from localhost ([1.132.144.230])
        by smtp.gmail.com with ESMTPSA id q17sm23336341pfq.171.2021.04.07.02.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 02:35:45 -0700 (PDT)
Date:   Wed, 07 Apr 2021 19:35:40 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v6 38/48] KVM: PPC: Book3S HV: Remove support for
 dependent threads mode on P9
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20210405011948.675354-1-npiggin@gmail.com>
        <20210405011948.675354-39-npiggin@gmail.com>
        <YG1WcjXTbGtsqHgY@thinks.paulus.ozlabs.org>
        <1617779718.vvrcxrnvnp.astroid@bobo.none>
In-Reply-To: <1617779718.vvrcxrnvnp.astroid@bobo.none>
MIME-Version: 1.0
Message-Id: <1617787999.rtpf8vvh36.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Nicholas Piggin's message of April 7, 2021 5:44 pm:
> Excerpts from Paul Mackerras's message of April 7, 2021 4:51 pm:
>> On Mon, Apr 05, 2021 at 11:19:38AM +1000, Nicholas Piggin wrote:
>>> Radix guest support will be removed from the P7/8 path, so disallow
>>> dependent threads mode on P9.
>>=20
>> Dependent threads mode on P9 was added in order to support the mode
>> where for security reasons you want to restrict the vcpus that run on
>> a core to all be from the same VM, without requiring all guests to run
>> single-threaded.  This was (at least at one stage) thought to be a
>> useful mode for users that are worried about side-channel data leaks.
>=20
> Right.
>=20
>>=20
>> Now it's possible that that mode is not practically useful for some
>> reason, or that no-one actually wants it, but its removal should be
>> discussed.  Also, the fact that we are losing that mode should be
>> explicit in the commit message.
>=20
> Let's discuss. Did / does anyone really use it or ask for it that you
> know of? What do other archs do? Compared with using standard options
> that would achive this kind of security (disable SMT, I guess?) how
> much is this worth keeping?
>=20
> It was pretty simple to support when the P8 dependent theads code had
> to support P9 anyway. After this series, now all that code is only for
> that one feature, so it would be pretty nice to be able to remove it.
> How do we reach a point where you'd be okay to remove this and tell=20
> people to just turn off SMT?

Assuming we do decide to remove it, how's about something like this for=20
a changelog. Does a bit more justice to the feature and its removal.

Thanks,
Nick

    Dependent-threads mode is the normal KVM mode for pre-POWER9 SMT
    processors, where all threads in a core (or subcore) would run the same
    partition at the same time, or they would run the host.
   =20
    This design was mandated by MMU state that is shared between threads in
    a processor, so the synchronisation point is in hypervisor real-mode
    that has essentially no shared state, so it's safe for multiple threads
    to gather and switch to the correct mode.
   =20
    It is implemented by having the host unplug all secondary threads and
    always run in SMT1 mode, and host QEMU threads essentially represent
    virtual cores that wake these secondary threads out of unplug when the
    ioctl is called to run the guest. This happens via a side-path that is
    mostly invisible to the rest of the Linux host and the secondary thread=
s
    still appear to be unplugged.
   =20
    POWER9 / ISA v3.0 has a more flexible MMU design that is independent
    per-thread and allows a much simpler KVM implementation. Before the new
    "P9 fast path" was added that began to take advantage of this, POWER9
    support was implemented in the existing path which has support to run
    in the dependent threads mode. So it was not much work to add support t=
o
    run POWER9 in this dependent threads mode.
   =20
    The mode is not required by the POWER9 MMU (although "mixed-mode" hash =
/
    radix MMU limitations of early processors were worked around using this
    mode). But it is one way to run SMT guests without running different
    guests or guest and host on different threads of the same core, so it
    could avoid or reduce some SMT attack surfaces without turning off SMT
    entirely.
   =20
    This security feature has some real, if indeterminate, value. However
    the old path is lagging in features (nested HV), and with this series
    the new P9 path adds remaining missing features (radix prefetch bug
    and hash support, in later patches), so POWER9 dependent threads mode
    support would be the only remaining reason to keep that code in and kee=
p
    supporting POWER9/POWER10 in the old path. So here we make the call to
    drop this feature.
   =20
    Remove dependent threads mode support for POWER9 and above processors.
    Systems can still achieve this security by disabling SMT entirely, but
    that would generally come at a larger performance cost for guests.

