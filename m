Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1BA20F06F
	for <lists+kvm-ppc@lfdr.de>; Tue, 30 Jun 2020 10:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731014AbgF3I0Q (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 30 Jun 2020 04:26:16 -0400
Received: from ozlabs.org ([203.11.71.1]:49507 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727059AbgF3I0Q (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 30 Jun 2020 04:26:16 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 49wy9y650Xz9sR4; Tue, 30 Jun 2020 18:26:14 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1593505574; bh=JbOYm2XV+atwgocCfiD7EFquDxzd1zUoFHSLuxojxvc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bdc3UNQK5NBUOHQw7ss2AdD1micdJVbavu7gcDloFI6Lljs882WfVaYGdVz7ngIAe
         xmHIVLcG94NVEWkPQ1vDB8onPqrXXUpTeT8GhRb6MCYyPKWtx57TQnbBD1/VxVSrYk
         zQGWAO4bKpQvA/ujp7IKZ03uHWF6UTqCR0zOUJ/ReS+HsnFaF7gxgL/l1uTWEQgW5W
         HiNTPahpWc+Qq/V8vT+2Uwdwt0/3QF8TiY06RsGH9eJyN1rEWjT71YmnnPLjid1vgq
         qM/K+7sCsQzDn46HdQkNuciK+JnHkNq4xgr33zBdaaM2St8vHGPmmtI1h545uOiFj4
         tvnam+sbO41LA==
Date:   Tue, 30 Jun 2020 18:26:07 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Anton Blanchard <anton@linux.ibm.com>,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 3/3] powerpc/pseries: Add KVM guest doorbell restrictions
Message-ID: <20200630082607.GB618342@thinks.paulus.ozlabs.org>
References: <20200627150428.2525192-1-npiggin@gmail.com>
 <20200627150428.2525192-4-npiggin@gmail.com>
 <20200630022713.GA618342@thinks.paulus.ozlabs.org>
 <1593495049.cacw882re0.astroid@bobo.none>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1593495049.cacw882re0.astroid@bobo.none>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Jun 30, 2020 at 03:35:08PM +1000, Nicholas Piggin wrote:
> Excerpts from Paul Mackerras's message of June 30, 2020 12:27 pm:
> > On Sun, Jun 28, 2020 at 01:04:28AM +1000, Nicholas Piggin wrote:
> >> KVM guests have certain restrictions and performance quirks when
> >> using doorbells. This patch tests for KVM environment in doorbell
> >> setup, and optimises IPI performance:
> >> 
> >>  - PowerVM guests may now use doorbells even if they are secure.
> >> 
> >>  - KVM guests no longer use doorbells if XIVE is available.
> > 
> > It seems, from the fact that you completely remove
> > kvm_para_available(), that you perhaps haven't tried building with
> > CONFIG_KVM_GUEST=y.
> 
> It's still there and builds:

OK, good, I missed that.

> static inline int kvm_para_available(void)
> {
>         return IS_ENABLED(CONFIG_KVM_GUEST) && is_kvm_guest();
> }
> 
> but...
> 
> > Somewhat confusingly, that option is not used or
> > needed when building for a PAPR guest (i.e. the "pseries" platform)
> > but is used on non-IBM platforms using the "epapr" hypervisor
> > interface.
> 
> ... is_kvm_guest() returns false on !PSERIES now.

And therefore kvm_para_available() returns false on all the platforms
where the code that depends on it could actually be used.

It's not correct to assume that !PSERIES means not a KVM guest.

> Not intended
> to break EPAPR. I'm not sure of a good way to share this between
> EPAPR and PSERIES, I might just make a copy of it but I'll see.

OK, so you're doing a new version?

Regards,
Paul.
