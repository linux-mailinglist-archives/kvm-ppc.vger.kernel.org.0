Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09385400545
	for <lists+kvm-ppc@lfdr.de>; Fri,  3 Sep 2021 20:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350714AbhICSsh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 3 Sep 2021 14:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350796AbhICSsc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 3 Sep 2021 14:48:32 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA6CC061760
        for <kvm-ppc@vger.kernel.org>; Fri,  3 Sep 2021 11:47:32 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id f2so298233ljn.1
        for <kvm-ppc@vger.kernel.org>; Fri, 03 Sep 2021 11:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DxQ+Qr7YPaLGE685i8Qhsb70C5/CP3uq+dG10rbYZ70=;
        b=aeAOf1HhD/MVvJF7n6CgbrcTB3IqvXzZ7V9Bso2CuLxbnXtu5olMXAQM4VeDrdy8Il
         Z8RH0YAw/8fqOzLfZTyVHjhoHWLsbs/W4ZXj9+gKfNOL7/w6NZJj3tUns7Sw1uoKMP32
         3b3KouBf10B7N3ZLkloX1nWHTqjSNyQJPy528=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DxQ+Qr7YPaLGE685i8Qhsb70C5/CP3uq+dG10rbYZ70=;
        b=oscItYBR3lV1FFWZmx0tVykY8Hb2YcHJY9u61vR3ffD9J7wXpLgIYuYzZFUELFTf7O
         oOajgXGxxr7Wn0YYn+KYvyAO88OF2l3H0AH2/z6WXxFsSOIRmh20WVq6ioM6EcHseY7w
         IakKR8lAmZw9ml9J7E6uuQImVjqFSC1pAIjRTh7rSmyHebmV+sHTKEIL5d0ibejtmwmG
         zZLiEsFqgOBDKWmNnSlrFygwBSMhZGRJ/nTARF+FlJKVZKmj3EyAcXVPYPFul9F9XE5j
         4wXiUysiDEyJGErZ3MPUYIq5lyPkK4m/lxDcXwqhBYtUfJ+mLcHvtMK6qTrHHr62TFN8
         aaCw==
X-Gm-Message-State: AOAM530xtVnpIm2TJuXa3u+cQgYJ01h9MWwo3uGfZXAu3JvYlDS1zSdS
        SWYILtUPXyGC98dVsHXmIKtnkx+5rMiyPOhXsdk=
X-Google-Smtp-Source: ABdhPJwIcSC3aUBcpl9ZBB+K9uX3AE7ZnUxPRrEJbrNi3cL2NQ819Z810pQHzQWsRoMrcjo0y2ZPSg==
X-Received: by 2002:a2e:a713:: with SMTP id s19mr306556lje.177.1630694849964;
        Fri, 03 Sep 2021 11:47:29 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id c17sm24258lfv.12.2021.09.03.11.47.28
        for <kvm-ppc@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 11:47:29 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id bq28so131766lfb.7
        for <kvm-ppc@vger.kernel.org>; Fri, 03 Sep 2021 11:47:28 -0700 (PDT)
X-Received: by 2002:a05:6512:3987:: with SMTP id j7mr269355lfu.280.1630694848707;
 Fri, 03 Sep 2021 11:47:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210827164926.1726765-1-agruenba@redhat.com> <CAHk-=wiUtyoTWuzroNJQwQDM9GHRXvq4974VL=y8T_3tUxDbkA@mail.gmail.com>
 <CAHc6FU7K0Ho=nH6fCK+Amc7zEg2G31v+gE3920ric3NE4MfH=A@mail.gmail.com>
 <CAHk-=wjUs8qy3hTEy-7QX4L=SyS85jF58eiT2Yq2YMUdTFAgvA@mail.gmail.com> <YTJoqq0fVB+xAB7w@zeniv-ca.linux.org.uk>
In-Reply-To: <YTJoqq0fVB+xAB7w@zeniv-ca.linux.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 3 Sep 2021 11:47:12 -0700
X-Gmail-Original-Message-ID: <CAHk-=whVNs=67KdMg21wxQdKuOJNg2p3d9t6dX-u3Jw+tzxjoQ@mail.gmail.com>
Message-ID: <CAHk-=whVNs=67KdMg21wxQdKuOJNg2p3d9t6dX-u3Jw+tzxjoQ@mail.gmail.com>
Subject: Re: [PATCH v7 00/19] gfs2: Fix mmap + page fault deadlocks
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
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

On Fri, Sep 3, 2021 at 11:28 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> FWIW, my objections regarding the calling conventions are still there.

So I'm happy to further change the calling conventions, but by now
_that_ part is most definitely a "not this merge window". The need for
that ternary state is still there.

It might go away in the future, but I think that's literally that: a
future cleanup. Not really related to the problem at hand.

              Linus
