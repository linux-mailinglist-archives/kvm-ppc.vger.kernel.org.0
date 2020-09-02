Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017B225A8A6
	for <lists+kvm-ppc@lfdr.de>; Wed,  2 Sep 2020 11:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgIBJcl (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 2 Sep 2020 05:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBJck (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 2 Sep 2020 05:32:40 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F070C061244
        for <kvm-ppc@vger.kernel.org>; Wed,  2 Sep 2020 02:32:40 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4BhJd01Pwjz9sVC; Wed,  2 Sep 2020 19:32:36 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1599039156; bh=Kizt9X0kTnda/s/85a3DzRuk5nTGzcVy2NygEUxiPVg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=toflBDUAFckn6EHGnHGTLZqb5s9A8mcETSfohJQ2IqPRF/Khbi8rgjBdZhsBX2XVR
         2rVXjPxNSKWD0/7463vpSCMGKHZwm4GAapq03/zU6JtBaPyoRUmQ83cUszVdI6qQML
         NKZRuAukl2kTUqs1jVZD/3IZArUo94jYDWFEpOZPyE/SlLafJgr/9zaElAB0L6hGVI
         BXYakQRwERdHt/1Vs6RWd6nUYkibxTs439t/lPXu/kTqemsdwFLstqpMTISrqPDUkB
         t2mVOrkBRaEZNikeE7yRcZupNsbq8o+9IjEnYT1YVsukgGZNl/ZO15FoNKZt1KKOFN
         Tlu6FJ1fjFJ1A==
Date:   Wed, 2 Sep 2020 19:32:31 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Jordan Niethe <jniethe5@gmail.com>
Cc:     kvm-ppc@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [RFC PATCH 1/2] KVM: PPC: Use the ppc_inst type
Message-ID: <20200902093231.GG272502@thinks.paulus.ozlabs.org>
References: <20200820033922.32311-1-jniethe5@gmail.com>
 <20200902061318.GE272502@thinks.paulus.ozlabs.org>
 <CACzsE9qrgs8ujQ7HeHVo-8oyY2bdwFVnVxR5dEZns5V7qK7Cbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACzsE9qrgs8ujQ7HeHVo-8oyY2bdwFVnVxR5dEZns5V7qK7Cbg@mail.gmail.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Sep 02, 2020 at 06:00:24PM +1000, Jordan Niethe wrote:
> On Wed, Sep 2, 2020 at 4:18 PM Paul Mackerras <paulus@ozlabs.org> wrote:
> >
> > On Thu, Aug 20, 2020 at 01:39:21PM +1000, Jordan Niethe wrote:
> > > The ppc_inst type was added to help cope with the addition of prefixed
> > > instructions to the ISA. Convert KVM to use this new type for dealing
> > > wiht instructions. For now do not try to add further support for
> > > prefixed instructions.
> >
> > This change does seem to splatter itself across a lot of code that
> > mostly or exclusively runs on machines which are not POWER10 and will
> > never need to handle prefixed instructions, unfortunately.  I wonder
> > if there is a less invasive way to approach this.
> Something less invasive would be good.
> >
> > In particular we are inflicting this 64-bit struct on 32-bit platforms
> > unnecessarily (I assume, correct me if I am wrong here).
> No, that is something that I wanted to to avoid, on 32 bit platforms
> it is a 32bit struct:
> 
> struct ppc_inst {
>         u32 val;
> #ifdef CONFIG_PPC64
>         u32 suffix;
> #endif
> } __packed;
> >
> > How would it be to do something like:
> >
> > typedef unsigned long ppc_inst_t;
> >
> > so it is 32 bits on 32-bit platforms and 64 bits on 64-bit platforms,
> > and then use that instead of 'struct ppc_inst'?  You would still need
> > to change the function declarations but I think most of the function
> > bodies would not need to be changed.  In particular you would avoid a
> > lot of the churn related to having to add ppc_inst_val() and suchlike.
> 
> Would the idea be to get rid of `struct ppc_inst` entirely or just not
> use it in kvm?
> In an earlier series I did something similar (at least code shared
> between 32bit and 64bit would need helpers, but 32bit only code need
> not change):
> 
> #ifdef __powerpc64__
> 
> typedef struct ppc_inst {
>     union {
>         struct {
>             u32 word;
>             u32 pad;
>         } __packed;
>         struct {
>             u32 prefix;
>             u32 suffix;
>         } __packed;
>     };
> } ppc_inst;
> 
> #else /* !__powerpc64__ */
> 
> typedef u32 ppc_inst;
> #endif
> 
> However mpe wanted to avoid using a typedef
> (https://patchwork.ozlabs.org/comment/2391845/)

Well it doesn't have to be typedef'd, it could just be "unsigned
long", which is used in other places for things that want to be 32-bit
on 32-bit machines and 64-bit on 64-bit machines.

I do however think that it should be a numeric type so that we can
mask, shift and compare it more easily.  I know that's less "abstract"
but it's also a lot less obfuscated and I think that will lead to
clearer code.  If you got the opposite advice from Michael Ellerman or
Nick Piggin then I will discuss it with them.

> We did also talk about just using a u64 for instructions
> (https://lore.kernel.org/linuxppc-dev/1585028462.t27rstc2uf.astroid@bobo.none/)
> but the concern was that as prefixed instructions act as two separate
> u32s (prefix is always before the suffix regardless of endianess)
> keeping it as a u64 would lead to lot of macros and potential
> confusion.
> But it does seem if that can avoid a lot of needless churn it might
> worth the trade off.

	u32 *ip;

	instr = *ip++;
	if (is_prefix(instr) && is_suitably_aligned(ip))
		instr = (instr << 32) | *ip++;

would avoid the endian issues pretty cleanly I think.  In other words
the prefix would always be the high half of the 64-bit value, so you
can't just do a single 64-bit of the instruction on little-endian
platforms; but you can't do a single 64-bit load for other reasons as
well, such as alignment.

Paul.
