Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2173F9D7F
	for <lists+kvm-ppc@lfdr.de>; Fri, 27 Aug 2021 19:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239817AbhH0RRr (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 27 Aug 2021 13:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239707AbhH0RRq (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 27 Aug 2021 13:17:46 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35255C0613CF
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Aug 2021 10:16:57 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id p38so15962669lfa.0
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Aug 2021 10:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j79aTkkV7QWLMRm7gv45CG9ALkTrZZR1j0Lx/8G3d6o=;
        b=fj/ZxCs8ur2rBha43Ay0HYB7+91H8QbKZzf8dL12yK9YzzNVZrCZbQRf5t7oQpJsoI
         Wgz8k7xy+geN1KnmohU7DOJais9Vhl6IrRuWDBIc20zyIyuMKAlU0hx94AqlBsRcWyd+
         95xQ+kewg4rcEfCorLbNVHCfZaK90xSHRzBSg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j79aTkkV7QWLMRm7gv45CG9ALkTrZZR1j0Lx/8G3d6o=;
        b=F9WnC0w26djqB1aDbe8HW5QEFfOAwC6AECdhGyghE1Wdqguj5PoAJJhTpETcIM/c+A
         1kDzeUELp1KWfYCd65tOfusXwI+QThPe+8CDffWGaRw+GPKklU5/K2Yk9c9VUdiWNlpQ
         LKqz+NffY7dEqjnadi0qman+lT5Uh5nRiODNDQuwvsDrGCahK7BFlpo9UdfzqHw6FSFK
         i1S1zPi1t3XczzkQqzTTxbHwHLiWcIRx9Oc8j9ZjPJw9sRd0i4AgjqokXwbXbkClSWKd
         XXqhS7xDCfy10u1flDhSqbxA9XQR1AbiNhUWlWsyKfJ9PlqYT4mtT54P28zwnvhQRvSq
         UeJg==
X-Gm-Message-State: AOAM531KFPpmDyVus5U2j4a6D7EMIsUW4NtIqEfvITslI1PNsatlacDJ
        MEG0WVBOY7tqgIswMSWLndq581g2teXWtIgI
X-Google-Smtp-Source: ABdhPJzacHk3afIvWF8cuBujg12XBH3v7mGHP4JMZaF1R2YSLOKgcyAW5CWO7Fq9WVG/EmBuoFCH5w==
X-Received: by 2002:a05:6512:c24:: with SMTP id z36mr7685083lfu.194.1630084615329;
        Fri, 27 Aug 2021 10:16:55 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id d9sm646105lfn.147.2021.08.27.10.16.53
        for <kvm-ppc@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 10:16:54 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id w4so12589768ljh.13
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Aug 2021 10:16:53 -0700 (PDT)
X-Received: by 2002:a2e:3004:: with SMTP id w4mr8318181ljw.465.1630084613565;
 Fri, 27 Aug 2021 10:16:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210827164926.1726765-1-agruenba@redhat.com>
In-Reply-To: <20210827164926.1726765-1-agruenba@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 27 Aug 2021 10:16:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiUtyoTWuzroNJQwQDM9GHRXvq4974VL=y8T_3tUxDbkA@mail.gmail.com>
Message-ID: <CAHk-=wiUtyoTWuzroNJQwQDM9GHRXvq4974VL=y8T_3tUxDbkA@mail.gmail.com>
Subject: Re: [PATCH v7 00/19] gfs2: Fix mmap + page fault deadlocks
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>, Jan Kara <jack@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        cluster-devel <cluster-devel@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com, kvm-ppc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Aug 27, 2021 at 9:49 AM Andreas Gruenbacher <agruenba@redhat.com> wrote:
>
> here's another update on top of v5.14-rc7.  Changes:
>
>  * Some of the patch descriptions have been improved.
>
>  * Patch "gfs2: Eliminate ip->i_gh" has been moved further to the front.
>
> At this point, I'm not aware of anything that still needs fixing,

From a quick scan, I didn't see anything that raised my hackles.

But I skipped all the gfs2-specific changes in the series, since
that's all above my paygrade.

                 Linus
