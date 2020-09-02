Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24EBE25A744
	for <lists+kvm-ppc@lfdr.de>; Wed,  2 Sep 2020 10:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgIBIAi (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 2 Sep 2020 04:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBIAi (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 2 Sep 2020 04:00:38 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80DBC061244
        for <kvm-ppc@vger.kernel.org>; Wed,  2 Sep 2020 01:00:36 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id v16so3494855otp.10
        for <kvm-ppc@vger.kernel.org>; Wed, 02 Sep 2020 01:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zpnjn6f8oeFbP2O+Jv7aUIl6F5Bk24aTxxfcp1ZBfPQ=;
        b=WdhcQ80bdf8jjmBasboFEWb4emxu3yEKjvw629iQqu1e34rp5yDFGGOtEXVuv2AAAk
         LeVcKSX3onUojPc867KHrhEsyNhoQpZp58cVZNJJT3nGvckpQr+lNcTKWNuyj8R7OIh6
         lANv1VU4e6nCjwj10b+f+Nz/O6Lj2taQcN8mqxqwjDGlw5NUjWZAj149oC/5AQffwlkc
         hlHA72T39lK4LnRYYelh+4vClvHo1SXx8YXU0dmi+TOBPjMHI4fhP7OITVA/mBAAZ9W3
         BKc1SBhadVu4z/8sUoH1gK+xROyjkbMbCBYLH37UVsg7LAeQaPKKQsLj1Yg0i3CJmJDF
         +LWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zpnjn6f8oeFbP2O+Jv7aUIl6F5Bk24aTxxfcp1ZBfPQ=;
        b=BDFdYm8Hf8ejmlAhaE/x2wJS1bLxtTutkeWVBfqVwbJsctLBGbRl8NTBUMmEyHVnQI
         hyCJAU41xL22IEX2J7wZNO9m5DUjrxArIAbEY2ucM/4Q3qDDFtZGGkIZKfGhb4zfScof
         VYoHa+sg+oqSVg+gXxyapcUxRPas4XWjcVPuydasu2spwuJikFZomFQdlIecII3dKjPY
         Qk078tZXd+8+AyT9p214eZEgAQkrNoY4rS4zFgZf4XuFndQz5yA92QBsxQtzuzmyRbqV
         KpGBzoe5dEhXfLwynjHignXkgGhIwAF1h8ml8b5f+vXilz7ZHvPsfl+sQ7oMCzEqLjau
         VbsQ==
X-Gm-Message-State: AOAM533ZQrIofxzXZ/hOYdEXaklnnQKsoeK8x8I8vJ0do1E4cPuasY7+
        Zgp68YVeothapEYY8myydNO+TB+3aU0BObBDpBI=
X-Google-Smtp-Source: ABdhPJx0WBNr9W1Nwgn0liQdUfM1taDwLxQD9fexgGLSMjFOjxOuNtFcfvzrxV80VGe+mFpQDmezLwJQXUj41yLgsGQ=
X-Received: by 2002:a05:6830:1283:: with SMTP id z3mr4244875otp.51.1599033636102;
 Wed, 02 Sep 2020 01:00:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200820033922.32311-1-jniethe5@gmail.com> <20200902061318.GE272502@thinks.paulus.ozlabs.org>
In-Reply-To: <20200902061318.GE272502@thinks.paulus.ozlabs.org>
From:   Jordan Niethe <jniethe5@gmail.com>
Date:   Wed, 2 Sep 2020 18:00:24 +1000
Message-ID: <CACzsE9qrgs8ujQ7HeHVo-8oyY2bdwFVnVxR5dEZns5V7qK7Cbg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] KVM: PPC: Use the ppc_inst type
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Sep 2, 2020 at 4:18 PM Paul Mackerras <paulus@ozlabs.org> wrote:
>
> On Thu, Aug 20, 2020 at 01:39:21PM +1000, Jordan Niethe wrote:
> > The ppc_inst type was added to help cope with the addition of prefixed
> > instructions to the ISA. Convert KVM to use this new type for dealing
> > wiht instructions. For now do not try to add further support for
> > prefixed instructions.
>
> This change does seem to splatter itself across a lot of code that
> mostly or exclusively runs on machines which are not POWER10 and will
> never need to handle prefixed instructions, unfortunately.  I wonder
> if there is a less invasive way to approach this.
Something less invasive would be good.
>
> In particular we are inflicting this 64-bit struct on 32-bit platforms
> unnecessarily (I assume, correct me if I am wrong here).
No, that is something that I wanted to to avoid, on 32 bit platforms
it is a 32bit struct:

struct ppc_inst {
        u32 val;
#ifdef CONFIG_PPC64
        u32 suffix;
#endif
} __packed;
>
> How would it be to do something like:
>
> typedef unsigned long ppc_inst_t;
>
> so it is 32 bits on 32-bit platforms and 64 bits on 64-bit platforms,
> and then use that instead of 'struct ppc_inst'?  You would still need
> to change the function declarations but I think most of the function
> bodies would not need to be changed.  In particular you would avoid a
> lot of the churn related to having to add ppc_inst_val() and suchlike.

Would the idea be to get rid of `struct ppc_inst` entirely or just not
use it in kvm?
In an earlier series I did something similar (at least code shared
between 32bit and 64bit would need helpers, but 32bit only code need
not change):

#ifdef __powerpc64__

typedef struct ppc_inst {
    union {
        struct {
            u32 word;
            u32 pad;
        } __packed;
        struct {
            u32 prefix;
            u32 suffix;
        } __packed;
    };
} ppc_inst;

#else /* !__powerpc64__ */

typedef u32 ppc_inst;
#endif

However mpe wanted to avoid using a typedef
(https://patchwork.ozlabs.org/comment/2391845/)

We did also talk about just using a u64 for instructions
(https://lore.kernel.org/linuxppc-dev/1585028462.t27rstc2uf.astroid@bobo.none/)
but the concern was that as prefixed instructions act as two separate
u32s (prefix is always before the suffix regardless of endianess)
keeping it as a u64 would lead to lot of macros and potential
confusion.
But it does seem if that can avoid a lot of needless churn it might
worth the trade off.
>
> > -static inline unsigned make_dsisr(unsigned instr)
> > +static inline unsigned make_dsisr(struct ppc_inst instr)
> >  {
> >       unsigned dsisr;
> > +     u32 word = ppc_inst_val(instr);
> >
> >
> >       /* bits  6:15 --> 22:31 */
> > -     dsisr = (instr & 0x03ff0000) >> 16;
> > +     dsisr = (word & 0x03ff0000) >> 16;
> >
> >       if (IS_XFORM(instr)) {
> >               /* bits 29:30 --> 15:16 */
> > -             dsisr |= (instr & 0x00000006) << 14;
> > +             dsisr |= (word & 0x00000006) << 14;
> >               /* bit     25 -->    17 */
> > -             dsisr |= (instr & 0x00000040) << 8;
> > +             dsisr |= (word & 0x00000040) << 8;
> >               /* bits 21:24 --> 18:21 */
> > -             dsisr |= (instr & 0x00000780) << 3;
> > +             dsisr |= (word & 0x00000780) << 3;
> >       } else {
> >               /* bit      5 -->    17 */
> > -             dsisr |= (instr & 0x04000000) >> 12;
> > +             dsisr |= (word & 0x04000000) >> 12;
> >               /* bits  1: 4 --> 18:21 */
> > -             dsisr |= (instr & 0x78000000) >> 17;
> > +             dsisr |= (word & 0x78000000) >> 17;
> >               /* bits 30:31 --> 12:13 */
> >               if (IS_DSFORM(instr))
> > -                     dsisr |= (instr & 0x00000003) << 18;
> > +                     dsisr |= (word & 0x00000003) << 18;
>
> Here I would have done something like:
>
> > -static inline unsigned make_dsisr(unsigned instr)
> > +static inline unsigned make_dsisr(struct ppc_inst pi)
> >  {
> >       unsigned dsisr;
> > +     u32 instr = ppc_inst_val(pi);
>
> and left the rest of the function unchanged.
That is better.
>
> At first I wondered why we still had that function, since IBM Power
> CPUs have not set DSISR on an alignment interrupt since POWER3 days.
> It turns out it this function is used by PR KVM when it is emulating
> one of the old 32-bit PowerPC CPUs (601, 603, 604, 750, 7450 etc.).
>
> > diff --git a/arch/powerpc/kernel/kvm.c b/arch/powerpc/kernel/kvm.c
>
> Despite the file name, this code is not used on IBM Power servers.
> It is for platforms which run under an ePAPR (not server PAPR)
> hypervisor (which would be a KVM variant, but generally book E KVM not
> book 3S).
>
> Paul.
