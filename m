Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1B818C3C3
	for <lists+kvm-ppc@lfdr.de>; Fri, 20 Mar 2020 00:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgCSXeq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 19 Mar 2020 19:34:46 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:44561 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbgCSXeq (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 19 Mar 2020 19:34:46 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 48k3Cm2kFYz9sRf; Fri, 20 Mar 2020 10:34:43 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1584660884; bh=3e2k76pHCNkJOTrpeeP78LipvWD3QnennPV0985nbeY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w+xaqjFY5Fv29r1Q0f9Q0Bo8C4lkPR9EmD5Ich/4mWGxpHrXeA7cX9BRHCaCbTXCz
         LUtuJ4h9wDgyvIx3cLqP6DXvLkowerdeH1F7vr3N6oHvo21rBjMqf5IAVQqEZXYTc2
         OoZQsJjlRliODnmWWffoyVgOqHsmAZEGprxfLrtTbMjBUjNXHgvh/qJ/ZH0yFgbima
         2sR+0gJNIjornWzZBsn34TSW3pyh1CRKS5Sd7xO7qLcqD0iyetshmgT+bYdNn9CJk7
         0pukYH3HWFi2K873b/NZjs40Xz3XCI+vFqd596KQdGf2agfYZWKZjC5vPJ0rJ8/NHn
         sLFtKqmgI5pVQ==
Date:   Fri, 20 Mar 2020 10:33:30 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Joe Perches <joe@perches.com>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next 016/491] KERNEL VIRTUAL MACHINE FOR POWERPC
 (KVM/powerpc): Use fallthrough;
Message-ID: <20200319233330.GE3260@blackberry>
References: <cover.1583896344.git.joe@perches.com>
 <37a5342c67e1b68b9ad06aca8da245b0ff409692.1583896348.git.joe@perches.com>
 <20200319011840.GA5033@blackberry>
 <7584d7937f4bb929beb0b9f5e80523653297676d.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7584d7937f4bb929beb0b9f5e80523653297676d.camel@perches.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Mar 18, 2020 at 06:22:29PM -0700, Joe Perches wrote:
> On Thu, 2020-03-19 at 12:18 +1100, Paul Mackerras wrote:
> > On Tue, Mar 10, 2020 at 09:51:30PM -0700, Joe Perches wrote:
> > > Convert the various uses of fallthrough comments to fallthrough;
> > > 
> > > Done via script
> > > Link: https://lore.kernel.org/lkml/b56602fcf79f849e733e7b521bb0e17895d390fa.1582230379.git.joe.com/
> > > 
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > 
> > The subject line should look like "KVM: PPC: Use fallthrough".
> 
> There's no way to generate a subject line like that via a script
> so far as I can tell.
> 
> > Apart from that,
> > 
> > Acked-by: Paul Mackerras <paulus@ozlabs.org>
> > 
> > How are these patches going upstream?  Do you want me to take this via
> > my tree?
> 
> If you want.
> 
> Ideally, these changes would go in treewide via a script run
> by Linus at an -rc1, but if the change is OK with you, it'd
> be fine to have you apply it now.

I have taken this patch in my kvm-ppc-next branch.

Thanks,
Paul.
