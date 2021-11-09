Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1005C44A424
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Nov 2021 02:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237567AbhKIBnf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 8 Nov 2021 20:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236380AbhKIBnW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 8 Nov 2021 20:43:22 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0043C01CB3D
        for <kvm-ppc@vger.kernel.org>; Mon,  8 Nov 2021 17:34:29 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id u11so17951248plf.3
        for <kvm-ppc@vger.kernel.org>; Mon, 08 Nov 2021 17:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1YRNoCeeCQqxDvBnoZCtovzT6k/QbqjejEhDlgxJ1xE=;
        b=pNVpk+rCV3HDgb16D6KNssN4BA5U8FFOZNcV6kT2A3hGuTm+OeROOwB3Gc25RBu5yd
         X4Uhm2QzCn6VeLOQwzmDpP+LvkACbbM7DOiiN1F9FMFmdBDaNGhlXPS6Id8TxlqFveUv
         ykpl9sKIWGUMRi9cWNOq4NVL7iOrhHfOKikKZQ1aYP9i+ytWzFlBD/awLiOZyTwIbWYd
         XQYDPLCQNX3Mp2Ht8drmEm0GVWUVRwAlw4IodZrpKgzHqAjOAs0439do5Z+7ssrDyIK1
         8md3BDizbcDwWCcQYcShMQ13fICVIj7mwm722Rbu19AAPS5eH2kbVej7sO/fO5BfTAlH
         wWLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1YRNoCeeCQqxDvBnoZCtovzT6k/QbqjejEhDlgxJ1xE=;
        b=RnI5BvBuJkQ9Vh+knAjzwHyMXgoq1P6RptBhGUJq6xV/3PtfFwrTfb8hjt2yLkkfpx
         2BuBJ48bDzkIwxo144IAojBwIa+6sdlcIRqjgsLzW6LBtaz8f9D57cHFkG/Xe9E4C4DN
         lZlR9KoH0mXQspqkx57nIOM/cb0WBwScFlPRqTnmresdOhgIkshmH13Xu5lwWVQ/wwnw
         9Yv8lm4irLq/cGBzSGgoToAIs7sm+zClkqPY48xjh5Ecx0USfYszO7iY+IYxO+4g/8yJ
         JolCKtXgpktLMadp+utmmOMCGf0bmq6DMJ3s6NTLov3RCqG/9dYOTll9oNDTaJgTgdTX
         cYXA==
X-Gm-Message-State: AOAM530WdLJRm0/v6eyUo0gXGuO4ahv7/hLI7bCry0fwGb1pPh2Rc1Mg
        XYL/MuZiz5RUHwBlVi/BvsSjAg==
X-Google-Smtp-Source: ABdhPJy0HaVA5X41obakvoewrsg+dddMWtR8SRrwlCTWxcj9Z8BfUyvzJbNA9mrSzEmNcuMJfGzR8Q==
X-Received: by 2002:a17:90b:1c02:: with SMTP id oc2mr2968763pjb.65.1636421669237;
        Mon, 08 Nov 2021 17:34:29 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h36sm307891pgb.9.2021.11.08.17.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 17:34:28 -0800 (PST)
Date:   Tue, 9 Nov 2021 01:34:25 +0000
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
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5.5 20/30] KVM: x86: Use nr_memslot_pages to avoid
 traversing the memslots array
Message-ID: <YYnQIYdsb3wwg86j@google.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-21-seanjc@google.com>
 <88d64cd0-4db1-34a8-96af-6661a55e971e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88d64cd0-4db1-34a8-96af-6661a55e971e@oracle.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Nov 09, 2021, Maciej S. Szmigiero wrote:
> On 04.11.2021 01:25, Sean Christopherson wrote:
> > From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> > 
> > There is no point in recalculating from scratch the total number of pages
> > in all memslots each time a memslot is created or deleted.  Use KVM's
> > cached nr_memslot_pages to compute the default max number of MMU pages.
> > 
> > Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> > [sean: use common KVM field and rework changelog accordingly]

Heh, and I forgot to add "and introduce bugs"

> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h |  1 -
> >   arch/x86/kvm/mmu/mmu.c          | 24 ------------------------
> >   arch/x86/kvm/x86.c              | 11 ++++++++---
> >   3 files changed, 8 insertions(+), 28 deletions(-)
> > 
> (..)
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -11837,9 +11837,14 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
> >   				enum kvm_mr_change change)
> >   {
> >   	if (!kvm->arch.n_requested_mmu_pages &&
> > -	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE))
> > -		kvm_mmu_change_mmu_pages(kvm,
> > -				kvm_mmu_calculate_default_mmu_pages(kvm));
> > +	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE)) {
> > +		unsigned long nr_mmu_pages;
> > +
> > +		nr_mmu_pages = kvm->nr_memslot_pages * KVM_PERMILLE_MMU_PAGES;
> 
> Unfortunately, even if kvm->nr_memslot_pages is capped at ULONG_MAX then
> this value multiplied by 20 can still overflow an unsigned long variable.

Doh.  And that likely subtly avoided by the compiler collapsing the "* 20 / 1000"
into "/ 50".

Any objection to adding a patch to cut out the multiplication entirely?  Well, cut
it from the source code, looks like gcc generates some fancy SHR+MUL to do the
divide.

I'm thinking this:

#define KVM_MEMSLOT_PAGES_TO_MMU_PAGES_RATIO 50


	...

	nr_mmu_pages = nr_pages / KVM_MEMSLOT_PAGES_TO_MMU_PAGES_RATIO;


