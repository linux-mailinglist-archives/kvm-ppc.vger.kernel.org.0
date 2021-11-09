Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A7944A408
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Nov 2021 02:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238818AbhKIBkL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 8 Nov 2021 20:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238894AbhKIBkI (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 8 Nov 2021 20:40:08 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2894C0432E6
        for <kvm-ppc@vger.kernel.org>; Mon,  8 Nov 2021 17:13:13 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id t21so17842871plr.6
        for <kvm-ppc@vger.kernel.org>; Mon, 08 Nov 2021 17:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OY5KYqUbBGpBDQ1k/TLXaDPEogjFGrqFLQuez5gL1qA=;
        b=te7Nw2DvzfZp/BOqwknAvOUpfBhundhcdPJe1dNUemJpr+5tBnfyFRHnMzcPLxJFqN
         KujEpDxbDQg9UP19BIas9xWrfjlUr8iNQnw44E4nNiuCXPw9XE2oUUEO4vm6LObg4EhG
         d4Eh18RhxnXj0DeQQGDa0fItbHkrWTp2aGHdm8SLozmyzGYlENGO46rSxB1omAxCZquV
         0SE2otTQgQ85nJvIEamMaKTrGUdltz0CPMYpQRIdj8uIl5/rXQOmwBDoJILcZ8QF1Jqs
         zpka1GweINt+W1Mdx9Gb5XIPiYSJXz2XTgcNv6K30CkWtk/7XN35z66PabO6xsFDyCBN
         K+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OY5KYqUbBGpBDQ1k/TLXaDPEogjFGrqFLQuez5gL1qA=;
        b=RxG3nVQJlhMKvHIfy7BNPGvZewS/swTOox/Yc7Kz2Ba4gjfbpY4OFpxzR6+04D9xXp
         XTmEybPS6igR7BnlS+/AcyusYEviP+F6WvgU/v/hEooKT56IQsRubu1hUHxMAOcGXxXe
         vMG0LXdPMjh0w4DJnxysiwXILH5n7XL20Ry9OlKODx9Avpdy+wyA51y2tIN5LqwU8GTr
         XEXmDZp0537i+wgnhQMFlfX2IwYooPvhP2XgPIiANIVPBrLukZS7/cWi6k+sOi6CIgSn
         0fSHEMIRtQHI75S8k5rOBawXvjnvxGMCmyAWMqqEnv0L98m6H0ERHPRpG1mNiUXVUPF7
         ed8A==
X-Gm-Message-State: AOAM533JNQNwhRHjkb/XYG6sa/eVqzWBpGiNzg4bnN+OZrcgM8baZuIm
        30u9mMMaYGP2zbL61P7aO+/mAg==
X-Google-Smtp-Source: ABdhPJzcevbnubHEXgv1M6rLX2JGTzdlefd4kCjCHHTj8uzt2X4SJm7iMiDLodL/pGyJRFtYyjZrnw==
X-Received: by 2002:a17:902:7c0e:b0:142:53c3:39d9 with SMTP id x14-20020a1709027c0e00b0014253c339d9mr3570608pll.66.1636420393180;
        Mon, 08 Nov 2021 17:13:13 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t135sm13421760pgc.51.2021.11.08.17.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 17:13:12 -0800 (PST)
Date:   Tue, 9 Nov 2021 01:13:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5.5 07/30] KVM: Let/force architectures to deal with
 arch specific memslot data
Message-ID: <YYnLJKyt0aYsl1H0@google.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-8-seanjc@google.com>
 <e12ecff3-ee69-9e2c-02f9-0e54a1cb9519@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e12ecff3-ee69-9e2c-02f9-0e54a1cb9519@oracle.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Nov 09, 2021, Maciej S. Szmigiero wrote:
> On 04.11.2021 01:25, Sean Christopherson wrote:
> > Pass the "old" slot to kvm_arch_prepare_memory_region() and force arch
> > code to handle propagating arch specific data from "new" to "old" when
> > necessary.  This is a baby step towards dynamically allocating "new" from
> > the get go, and is a (very) minor performance boost on x86 due to not
> > unnecessarily copying arch data.
> > 
> > For PPC HV, copy the rmap in the !CREATE and !DELETE paths, i.e. for MOVE
> > and FLAGS_ONLY.  This is functionally a nop as the previous behavior
> > would overwrite the pointer for CREATE, and eventually discard/ignore it
> > for DELETE.
> > 
> > For x86, copy the arch data only for FLAGS_ONLY changes.  Unlike PPC HV,
> > x86 needs to reallocate arch data in the MOVE case as the size of x86's
> > allocations depend on the alignment of the memslot's gfn.
> > 
> > Opportunistically tweak kvm_arch_prepare_memory_region()'s param order to
> > match the "commit" prototype.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/arm64/kvm/mmu.c               |  7 ++++---
> >   arch/mips/kvm/mips.c               |  3 ++-
> >   arch/powerpc/include/asm/kvm_ppc.h | 18 ++++++++++--------
> >   arch/powerpc/kvm/book3s.c          | 12 ++++++------
> >   arch/powerpc/kvm/book3s_hv.c       | 17 ++++++++++-------
> >   arch/powerpc/kvm/book3s_pr.c       | 17 +++++++++--------
> >   arch/powerpc/kvm/booke.c           |  5 +++--
> >   arch/powerpc/kvm/powerpc.c         |  5 +++--
> >   arch/s390/kvm/kvm-s390.c           |  3 ++-
> >   arch/x86/kvm/x86.c                 | 15 +++++++++++----
> >   include/linux/kvm_host.h           |  3 ++-
> >   virt/kvm/kvm_main.c                |  5 +----
> >   12 files changed, 63 insertions(+), 47 deletions(-)
> > 
> 
> You didn't include the RISCV kvm_arch_prepare_memory_region() change here
> (that's actually in patch 13 of this series) so bisection on that arch
> will be broken between this patch and patch 13.

Argh, I thought I had found all of those.  :-/  Thanks.  
