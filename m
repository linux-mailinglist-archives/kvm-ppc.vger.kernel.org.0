Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D7C314980
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Feb 2021 08:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhBIH1c (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Feb 2021 02:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhBIH1K (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 9 Feb 2021 02:27:10 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBB1C061786
        for <kvm-ppc@vger.kernel.org>; Mon,  8 Feb 2021 23:26:30 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4DZZFY6lV5z9sSC; Tue,  9 Feb 2021 18:26:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1612855585; bh=/RjV4eM3ppmc3cXLU4eL4Vq4TL2hMj++pRhw2XvGJik=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GHyJ/J90o79FNY4tiX2Elq67pg6c9dqcM+QwpQZfMJnL3ApfGA2qpcX7I3NIvZOXu
         vPmgRkh4IF1Kkcmh2yDJPh3qgc/0aWF7G7+2J/Zk0m73zNTk7It9gTwHpqZ3toGv78
         IyYU2UAGkJwjvoOBGlZ7ctUmmK4IKg7T3IdLVWWUzW+56MsgGyMllssiK3WE2sqMkU
         c3+hoawfkcMTL7I0pqKwPMgy9Pab9j5UEt+TE9izKg5RPQ4F+WNbMkq7eznYDiSw0i
         aHzEB+UH6vju9vyTMTcrzH7faHk9iaV8A4jUrTh4f6lAqOkAnDUnQgp3ptSeIstKGD
         hsPUjEZ1x7+mA==
Date:   Tue, 9 Feb 2021 18:19:26 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: PPC: Book3S HV: Remove shared-TLB optimisation
 from vCPU TLB coherency logic
Message-ID: <20210209071926.GA2841126@thinks.paulus.ozlabs.org>
References: <20210118122609.1447366-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118122609.1447366-1-npiggin@gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Jan 18, 2021 at 10:26:08PM +1000, Nicholas Piggin wrote:
> Processors that implement ISA v3.0 or later don't necessarily have
> threads in a core sharing all translations, and/or TLBIEL does not
> necessarily invalidate translations on all other threads (the
> architecture talks only about the effect on translations for "the thread
> executing the tlbiel instruction".

It seems to me that to have an implementation where TLB entries
created on one thread (say T0) are visible to and usable by another
thread (T1), but a tlbiel on thread T0 does not result in the entry
being removed from visibility/usability on T1, is a pretty insane
implementation.  I'm not sure that the architecture envisaged allowing
this kind of implementation, though perhaps the language doesn't
absolutely prohibit it.

This kind of implementation is what you are allowing for in this
patch, isn't it?

The sane implementations would be ones where either (a) TLB entries
are private to each thread and tlbiel only works on the local thread,
or (b) TLB entries can be shared and tlbiel works across all threads.
I think this is the conclusion we collectively came to when working on
that bug we worked on towards the end of last year.

> While this worked for POWER9, it may not for future implementations, so
> remove it. A POWER9 specific optimisation would have to have a specific
> CPU feature to check, if it were to be re-added.

Did you do any measurements of how much performance impact this has on
POWER9?  I don't believe this patch will actually be necessary on
POWER10, so it seems like this patch is just to allow for some
undefined possible future CPU.  It may still be worth putting in for
the sake of strict architecture compliance if the performance impact
is minimal.

Paul.
