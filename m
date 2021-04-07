Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9AD63565A9
	for <lists+kvm-ppc@lfdr.de>; Wed,  7 Apr 2021 09:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbhDGHpI (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 7 Apr 2021 03:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240787AbhDGHpH (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 7 Apr 2021 03:45:07 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442E3C06174A
        for <kvm-ppc@vger.kernel.org>; Wed,  7 Apr 2021 00:44:57 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id h25so12412476pgm.3
        for <kvm-ppc@vger.kernel.org>; Wed, 07 Apr 2021 00:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=5Kphp8J3Yhi8mWW3z/UUIbkkrK9S0cYnMnP/5h5hC9o=;
        b=fb/P4hkTtXrWm0Zy01LAxM9nUEmCJ/7loqvlzxKdKW8aqNO/dwJ6lQSmyrZ1BGQdub
         1KhDjiBJRQjo7yEe8CaZl3Ao2VeZFvzxq9uJtrwuPeMTZW+GSLjyB0OmMhJenyxZ8OXw
         9Nw0AbP6DjjA+QwhYVbSLuhMWdrBkZ3UufXisnfkkmG+nXjD+2JauLvGMAFrrGfF5jSE
         9WkRqr6heeqWzOdRbPcPXkoAH19P7++Vj7RgWn+MwS66MnXQ/NfIKoOSIRzNHOJ2AP7f
         XWLLp4aBZhPPCqNe1rrRUExTUfuKU6vMNDMukOkzxJ0idzyJLT3Sh9UyADqgg/EPRvy8
         yrkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=5Kphp8J3Yhi8mWW3z/UUIbkkrK9S0cYnMnP/5h5hC9o=;
        b=D5+qq6qpEx1d8oA9pzePueAM+xWmS1PsHHWCTDm+PI3zop1XT8ce2Ds+5VdiwqIUMV
         h2+D5H9ha+5Jw6UAhg4aJBZbQCgTZyRYz/2lOcSpda0gV7CkpCmv9m5cb22+I5AO8Os4
         +Hilerbd3pjHRIXlagTSnVqhAOLFTMfuZilZJt53hx2fEUX52fLZ8WA+Pz4jSnncD3H5
         MmspGa5cHiTVo7+1YTney3lIh58/4ZKcFWKoL1PHhuopfxbYoKywrCkxacj1YJ7/AE9r
         S6594czBaS8Q8bex5b0K4bg6kInyo1cHA4oC0h5cBzpki9SDWvKJyxlbsIwsiJj5Ys7u
         U8jw==
X-Gm-Message-State: AOAM530HUdwgNNbPA9EgvY0yhv4fDLsK2Wyydowo2aTc9qCuduAjZOMM
        PjNdRLUvOUMvfmEhgwzLrp8r2X4rG5Y=
X-Google-Smtp-Source: ABdhPJy9egQT77T6TcXp2e569RzNQaOwCsIksfN/29TRdDDt/tsJeWl0t6x+j99EqaMxnhscFN/HRA==
X-Received: by 2002:a65:5cc2:: with SMTP id b2mr2060462pgt.280.1617781496843;
        Wed, 07 Apr 2021 00:44:56 -0700 (PDT)
Received: from localhost ([144.130.156.129])
        by smtp.gmail.com with ESMTPSA id j3sm20460295pfi.74.2021.04.07.00.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 00:44:56 -0700 (PDT)
Date:   Wed, 07 Apr 2021 17:44:51 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v6 38/48] KVM: PPC: Book3S HV: Remove support for
 dependent threads mode on P9
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20210405011948.675354-1-npiggin@gmail.com>
        <20210405011948.675354-39-npiggin@gmail.com>
        <YG1WcjXTbGtsqHgY@thinks.paulus.ozlabs.org>
In-Reply-To: <YG1WcjXTbGtsqHgY@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Message-Id: <1617779718.vvrcxrnvnp.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Paul Mackerras's message of April 7, 2021 4:51 pm:
> On Mon, Apr 05, 2021 at 11:19:38AM +1000, Nicholas Piggin wrote:
>> Radix guest support will be removed from the P7/8 path, so disallow
>> dependent threads mode on P9.
>=20
> Dependent threads mode on P9 was added in order to support the mode
> where for security reasons you want to restrict the vcpus that run on
> a core to all be from the same VM, without requiring all guests to run
> single-threaded.  This was (at least at one stage) thought to be a
> useful mode for users that are worried about side-channel data leaks.

Right.

>=20
> Now it's possible that that mode is not practically useful for some
> reason, or that no-one actually wants it, but its removal should be
> discussed.  Also, the fact that we are losing that mode should be
> explicit in the commit message.

Let's discuss. Did / does anyone really use it or ask for it that you
know of? What do other archs do? Compared with using standard options
that would achive this kind of security (disable SMT, I guess?) how
much is this worth keeping?

It was pretty simple to support when the P8 dependent theads code had
to support P9 anyway. After this series, now all that code is only for
that one feature, so it would be pretty nice to be able to remove it.
How do we reach a point where you'd be okay to remove this and tell=20
people to just turn off SMT?

Thanks,
Nick
