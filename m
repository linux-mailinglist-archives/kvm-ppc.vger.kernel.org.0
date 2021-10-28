Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE3C43F2D6
	for <lists+kvm-ppc@lfdr.de>; Fri, 29 Oct 2021 00:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhJ1Wf0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 28 Oct 2021 18:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbhJ1WfM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 28 Oct 2021 18:35:12 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91583C061348
        for <kvm-ppc@vger.kernel.org>; Thu, 28 Oct 2021 15:32:44 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id l13so16744821lfg.6
        for <kvm-ppc@vger.kernel.org>; Thu, 28 Oct 2021 15:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P2oA0jP1wTViA9d0b6XSu2m2Y7tBKqkUPBuDKDK703M=;
        b=HzbuQnUzqbVH0zR+CZxMx/jYbjOwSKkqX9v1Ii3J+JA3hprq4SQBq/oq1XV2WHbboW
         GM6mCzsEY8CYnDKile42NhDWBAMmGmwAtNFEXySLaWKfRUD8V0FHk+7TYyOvdi/ZUvfX
         rOFaS1m2I/gKNLQEoFvUh9TDMESUKJVjJQ7lU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P2oA0jP1wTViA9d0b6XSu2m2Y7tBKqkUPBuDKDK703M=;
        b=lqkr93IEbbCNy3N/Quvw+gV94cbucY4ObgEaXo0dBeDiBs49eEmxdKYMsfJI4dmt32
         ndfg6UqsA7vLh5AH2h0L+oyQm/51BVWbktbRV8pC5EtC6AJz4C4+YG1hh8drPKkolnZz
         MNjAy8XwTO3C7xaDzIR040/e1/zuh2Nq4iMkl8GSqsqDwKENdajL7IY057t5SsMNkJWy
         Bw49b9zIvQGdPNyQzjASgtultWNaCwV+3fsU1X5mxBXL/u6zzLvVw899voWvIn9QOM7d
         hRkthRn3KZURtJnzy1Wo3/5hpsezSfQHL5PzJW9QEkALew+RCAEjK3rB7uhEZtBsV5ra
         1UOw==
X-Gm-Message-State: AOAM533mpIgF2Jh28NEHF6i5v95PdBYzdCJ/uJHG1p0+BmNofml+15MP
        r6IWc6CcKfsC+RP9LvlC7cQHvodiXeS0gR/k
X-Google-Smtp-Source: ABdhPJxPXbjQvLQmf4gt502HfaLDXBBWXRdwPdCbpmmzesCppFNMKA73QybGPAb99jf+hWitNaaR7w==
X-Received: by 2002:ac2:5d4e:: with SMTP id w14mr6904104lfd.138.1635460362694;
        Thu, 28 Oct 2021 15:32:42 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id i13sm438595lfb.45.2021.10.28.15.32.39
        for <kvm-ppc@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 15:32:40 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id 17so10142658ljq.0
        for <kvm-ppc@vger.kernel.org>; Thu, 28 Oct 2021 15:32:39 -0700 (PDT)
X-Received: by 2002:a2e:89d4:: with SMTP id c20mr7772843ljk.191.1635460359642;
 Thu, 28 Oct 2021 15:32:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wgv=KPZBJGnx_O5-7hhST8CL9BN4wJwtVuycjhv_1MmvQ@mail.gmail.com>
 <YXCbv5gdfEEtAYo8@arm.com> <CAHk-=wgP058PNY8eoWW=5uRMox-PuesDMrLsrCWPS+xXhzbQxQ@mail.gmail.com>
 <YXL9tRher7QVmq6N@arm.com> <CAHk-=wg4t2t1AaBDyMfOVhCCOiLLjCB5TFVgZcV4Pr8X2qptJw@mail.gmail.com>
 <CAHc6FU7BEfBJCpm8wC3P+8GTBcXxzDWcp6wAcgzQtuaJLHrqZA@mail.gmail.com>
 <YXhH0sBSyTyz5Eh2@arm.com> <CAHk-=wjWDsB-dDj+x4yr8h8f_VSkyB7MbgGqBzDRMNz125sZxw@mail.gmail.com>
 <YXmkvfL9B+4mQAIo@arm.com> <CAHk-=wjQqi9cw1Guz6a8oBB0xiQNF_jtFzs3gW0k7+fKN-mB1g@mail.gmail.com>
 <YXsUNMWFpmT1eQcX@arm.com>
In-Reply-To: <YXsUNMWFpmT1eQcX@arm.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 28 Oct 2021 15:32:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgzEKEYKRoR_abQRDO=R8xJX_FK+XC3gNhKfu=KLdxt3g@mail.gmail.com>
Message-ID: <CAHk-=wgzEKEYKRoR_abQRDO=R8xJX_FK+XC3gNhKfu=KLdxt3g@mail.gmail.com>
Subject: Re: [PATCH v8 00/17] gfs2: Fix mmap + page fault deadlocks
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        cluster-devel <cluster-devel@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com, kvm-ppc@vger.kernel.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Oct 28, 2021 at 2:21 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> They do look fairly similar but we should have the information in the
> fault handler to distinguish: not a page fault (pte permission or p*d
> translation), in_task(), user address, fixup handler. But I agree the
> logic looks fragile.

So thinking about this a bit more, I think I have a possible
suggestion for how to handle this..

The pointer color fault (or whatever some other architecture may do to
generate sub-page faults) is not only not recoverable in the sense
that we can't fix it up, it also ends up being a forced SIGSEGV (ie it
can't be blocked - it has to either be caught or cause the process to
be killed).

And the thing is, I think we could just make the rule be that kernel
code that has this kind of retry loop with fault_in_pages() would
force an EFAULT on a pending SIGSEGV.

IOW, the pending SIGSEGV could effectively be exactly that "thread flag".

And that means that fault_in_xyz() wouldn't need to worry about this
situation at all: the regular copy_from_user() (or whatever flavor it
is - to/from/iter/whatever) would take the fault. And if it's a
regular page fault,. it would act exactly like it does now, so no
changes.

If it's a sub-page fault, we'd just make the rule be that we send a
SIGSEGV even if the instruction in question has a user exception
fixup.

Then we just need to add the logic somewhere that does "if active
pending SIGSEGV, return -EFAULT".

Of course, that logic might be in fault_in_xyz(), but it migth also be
a separate function entirely.

So this does effectively end up being a thread flag, but it's also
slightly more than that - it's that a sub-page fault from kernel mode
has semantics that a regular page fault does not.

The whole "kernel access doesn't cause SIGSEGV, but returns -EFAULT
instead" has always been an odd and somewhat wrong-headed thing. Of
course it should cause a SIGSEGV, but that's not how Unix traditionall
worked. We would just say "color faults always raise a signal, even if
the color fault was triggered in a system call".

(And I didn't check: I say "SIGSEGV" above, but maybe the pointer
color faults are actually SIGBUS? Doesn't change the end result).

                 Linus
