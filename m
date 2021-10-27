Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0370243D59E
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 Oct 2021 23:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbhJ0VaU (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 27 Oct 2021 17:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234735AbhJ0VaE (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 27 Oct 2021 17:30:04 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FD8C0431A1
        for <kvm-ppc@vger.kernel.org>; Wed, 27 Oct 2021 14:21:42 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id h11so7042838ljk.1
        for <kvm-ppc@vger.kernel.org>; Wed, 27 Oct 2021 14:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hiXmABk2yLJcTBwV/OV64LUSAMHnd37fHZz79FC6JvU=;
        b=ZWNMOoSkuRaQ/lv8qizXhk55H0ec5K7RYuCkQOMY0yln4tyxGOGFp3Gs+/CZY7p6bT
         3CZlT/Neco4TP12/d9wLKcFuseqO24iEpPL6jwtGtY8MUiJAI9mKP12Z7SKjitGg++uj
         lH3CUAw1rGdqhKUixiRRtsMf0iuWhbOzVZTJw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hiXmABk2yLJcTBwV/OV64LUSAMHnd37fHZz79FC6JvU=;
        b=MLmCPm5vvg1SuTyUI/ihmkTiM01ALt9wcAafZdR2TciCfaGBc/SZC7rMjejmzRuy3r
         obr9V7/EQ02jj+dEyuCYSU7dmZAOHQYjuQ1/69SmtyMHeoqBITiVWqV1JCzdefpsgERt
         vMRDiq2g09LR6/rZO0TWYki07IbEKLnZWShigBiKaNBktD3j1IyXuj0egCdQ172bwP6M
         svPXin0xI2oelO/xizhczrdGVFQICSNOdgiKkIXMFKSs2uF4DMI5vQu0RKt1x7Tlxvnx
         Nf2Gp9fqn0pGQS+S7gtQdRWhxWX3nE0VAxfkiWmVT8FLLtn80No84IGi+eYhrPGyohl9
         u3EA==
X-Gm-Message-State: AOAM533ZxyORFhKJusG1z0fwYvwd7vxEB8InIlBI6Ddl1oPLuHqI4Gya
        aKRY75mGnxQvYATbG+F6fsD6kmljMp4C+xhf
X-Google-Smtp-Source: ABdhPJxOOWT5KHKghTgK2xpyiLIMC5ze7HmKunoZ+PkCDM+UWh8jkAPyUYOcZJ/ubrAG0bEr7kCt3g==
X-Received: by 2002:a2e:3e16:: with SMTP id l22mr385537lja.210.1635369700467;
        Wed, 27 Oct 2021 14:21:40 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id c12sm94204ljf.82.2021.10.27.14.21.40
        for <kvm-ppc@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 14:21:40 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id bq11so8969330lfb.10
        for <kvm-ppc@vger.kernel.org>; Wed, 27 Oct 2021 14:21:40 -0700 (PDT)
X-Received: by 2002:a19:f619:: with SMTP id x25mr90493lfe.141.1635369304547;
 Wed, 27 Oct 2021 14:15:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wh0_3y5s7-G74U0Pcjm7Y_yHB608NYrQSvgogVNBxsWSQ@mail.gmail.com>
 <YXBFqD9WVuU8awIv@arm.com> <CAHk-=wgv=KPZBJGnx_O5-7hhST8CL9BN4wJwtVuycjhv_1MmvQ@mail.gmail.com>
 <YXCbv5gdfEEtAYo8@arm.com> <CAHk-=wgP058PNY8eoWW=5uRMox-PuesDMrLsrCWPS+xXhzbQxQ@mail.gmail.com>
 <YXL9tRher7QVmq6N@arm.com> <CAHk-=wg4t2t1AaBDyMfOVhCCOiLLjCB5TFVgZcV4Pr8X2qptJw@mail.gmail.com>
 <CAHc6FU7BEfBJCpm8wC3P+8GTBcXxzDWcp6wAcgzQtuaJLHrqZA@mail.gmail.com>
 <YXhH0sBSyTyz5Eh2@arm.com> <CAHk-=wjWDsB-dDj+x4yr8h8f_VSkyB7MbgGqBzDRMNz125sZxw@mail.gmail.com>
 <YXmkvfL9B+4mQAIo@arm.com>
In-Reply-To: <YXmkvfL9B+4mQAIo@arm.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 27 Oct 2021 14:14:48 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjQqi9cw1Guz6a8oBB0xiQNF_jtFzs3gW0k7+fKN-mB1g@mail.gmail.com>
Message-ID: <CAHk-=wjQqi9cw1Guz6a8oBB0xiQNF_jtFzs3gW0k7+fKN-mB1g@mail.gmail.com>
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

On Wed, Oct 27, 2021 at 12:13 PM Catalin Marinas
<catalin.marinas@arm.com> wrote:
>
> As an alternative, you mentioned earlier that a per-thread fault status
> was not feasible on x86 due to races. Was this only for the hw poison
> case? I think the uaccess is slightly different.

It's not x86-specific, it's very generic.

If we set some flag in the per-thread status, we'll need to be careful
about not overwriting it if we then have a subsequent NMI that _also_
takes a (completely unrelated) page fault - before we then read the
per-thread flag.

Think 'perf' and fetching backtraces etc.

Note that the NMI page fault can easily also be a pointer coloring
fault on arm64, for exactly the same reason that whatever original
copy_from_user() code was. So this is not a "oh, pointer coloring
faults are different". They have the same re-entrancy issue.

And both the "pagefault_disable" and "fault happens in interrupt
context" cases are also the exact same 'faulthandler_disabled()'
thing. So even at fault time they look very similar.

So we'd have to have some way to separate out only the one we care about.

               Linus
