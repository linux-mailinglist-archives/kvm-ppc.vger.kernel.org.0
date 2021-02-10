Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61562315B75
	for <lists+kvm-ppc@lfdr.de>; Wed, 10 Feb 2021 01:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbhBJAmG (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Feb 2021 19:42:06 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:38355 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234197AbhBJAkG (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 9 Feb 2021 19:40:06 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4Db19M0vRgz9sBy; Wed, 10 Feb 2021 11:39:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1612917559; bh=/HvK8qHS9n70jIWVysz7Fv73wR2ICquWo7T+cmRtP5c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O87TEdAmyYSrmN2piXYCEk9mZIyT8N94UO9KydAIM/i29zJoO2Kc/FhOqJyulBxPP
         7RWwdxrmsLVQL0hC8MqiKl/dsMqrTdNK1WCQLwg3Qnwczf/5nnFEm/9irgGWLbotbp
         +UeEonyzSVNfcZZH51Gv6RxyIukg0L0/uimmEl7JKn8kRzTU5Z/W7s1VOw14tQtM8F
         EgW530BIsq13qIpIg/we4dpMfynY5DqH5JFEgUmjJsppxsH/cl3lf04wTWakQx/EVl
         Dv1RHp6PZJwkpzjZJvHlzqJB5pWlHwxTFAaXdgW56v1pUWopnpNzc+iJqoCDWiKfk9
         2f4RQxmPout3w==
Date:   Wed, 10 Feb 2021 11:39:14 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: PPC: Book3S HV: Remove shared-TLB optimisation
 from vCPU TLB coherency logic
Message-ID: <20210210003914.GC2854001@thinks.paulus.ozlabs.org>
References: <20210118122609.1447366-1-npiggin@gmail.com>
 <20210209071926.GA2841126@thinks.paulus.ozlabs.org>
 <1612857591.l3d2b98uvh.astroid@bobo.none>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612857591.l3d2b98uvh.astroid@bobo.none>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Feb 09, 2021 at 06:44:53PM +1000, Nicholas Piggin wrote:
> Excerpts from Paul Mackerras's message of February 9, 2021 5:19 pm:
> > On Mon, Jan 18, 2021 at 10:26:08PM +1000, Nicholas Piggin wrote:
> >> Processors that implement ISA v3.0 or later don't necessarily have
> >> threads in a core sharing all translations, and/or TLBIEL does not
> >> necessarily invalidate translations on all other threads (the
> >> architecture talks only about the effect on translations for "the thread
> >> executing the tlbiel instruction".
> > 
> > It seems to me that to have an implementation where TLB entries
> > created on one thread (say T0) are visible to and usable by another
> > thread (T1), but a tlbiel on thread T0 does not result in the entry
> > being removed from visibility/usability on T1, is a pretty insane
> > implementation.  I'm not sure that the architecture envisaged allowing
> > this kind of implementation, though perhaps the language doesn't
> > absolutely prohibit it.
> > 
> > This kind of implementation is what you are allowing for in this
> > patch, isn't it?
> 
> Not intentionally, and patch 2 removes the possibility.
> 
> The main thing it allows is an implementation where TLB entries created 
> by T1 which are visble only to T1 do not get removed by TLBIEL on T0.

I could understand this patch as trying to accommodate both those
implementations where TLB entries are private to each thread, and
those implementations where TLB entries are shared, without needing to
distinguish between them, at the expense of doing unnecessary
invalidations on both kinds of implementation.

> I also have some concern with ordering of in-flight operations (ptesync,
> memory ordering, etc) which are mostly avoided with this.
> 
> > The sane implementations would be ones where either (a) TLB entries
> > are private to each thread and tlbiel only works on the local thread,
> > or (b) TLB entries can be shared and tlbiel works across all threads.
> > I think this is the conclusion we collectively came to when working on
> > that bug we worked on towards the end of last year.
> 
> I think an implementation could have both types. So it's hard to get 
> away from flushing all threads.

Having both private and shared TLB entries in the same implementation
would seem very odd to me.  What would determine whether a given entry
is shared or private?

Paul.
