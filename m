Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD881F49C3
	for <lists+kvm-ppc@lfdr.de>; Wed, 10 Jun 2020 00:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbgFIW6Q (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Jun 2020 18:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729047AbgFIW5w (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 9 Jun 2020 18:57:52 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7372DC00862E
        for <kvm-ppc@vger.kernel.org>; Tue,  9 Jun 2020 15:57:47 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id w20so204229uaa.2
        for <kvm-ppc@vger.kernel.org>; Tue, 09 Jun 2020 15:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xl5EexOSop6lv+UL7XlaACYBiSImdbhXFtk47GA4aNo=;
        b=jGKUzdkMHAPPrsDAO+KgKuAkBcwZtqhUNuimhvROzoJ9soMzQeLhFacPERf2F1XAt1
         d2bGPLktS4oAbDypyJsO1bp4jOu+yrHrzisYt7q9+K1Hi0hoL3YOduunxwK7YD7Qt7z0
         y3licW0I0Hm1qOPCUTKLoyKQp/3B2kLD9SN+DIFf4qUocN8tZ+JcyuvkpeJa+Nx5P9Na
         1hfqO82s7cJ49zBil2iU4uF0YAvQfZ67+OT8TQ3PAwA47G7EZ666/1ojukkE3Jpdnxbt
         eMot5sAzs9ckGI/LQ9GzRveHRIuIi8iCm7iWgocOAu+Hv9q8sX3vAn7FZhDyBYP80Kmo
         spbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xl5EexOSop6lv+UL7XlaACYBiSImdbhXFtk47GA4aNo=;
        b=mztuyPBNet4fB7iSXgwl/fyCxN4xD+3g/SNfrFawnd82MHf6l6hUHbyNK9PPsBbhWg
         lCdIHsx7tdFZAHWRfAIpkPiZ1KKxR9lLEfg6tvQ6gFeM3Yf5B/mjNQeza55mRm6ej8nD
         KeLpcVID4QjU0IW8VWvSqGRp1z0n5XPCZIrkHqsUZzb8IxvSrYuPqkDQiebKeCUiSsSc
         Eo+2gSqN0swcheg1N7qSMNY3ShLaCW7vsJMFs9tPbWLhCAhALfwbwAlLF+B/O5hDwYfW
         6SdfRpKnBU8WRhyEORVHw2UJWmJdnEGS6531muUiBEzBJN8+Ok/2hLs+GcTLeyRbWBs0
         5M6g==
X-Gm-Message-State: AOAM531b7C03K9hSmxzTJtBekAiofAoAek/G40hAkoCIZLiy9TlVyeO8
        9CJvL1ILtTQczJUgVlPMT/Ym3hWoKiI8B6YaZCPqOg==
X-Google-Smtp-Source: ABdhPJw+x8rHkvjQXtHjLxkujrakxTirbbawkFrKZAQkOg8tp5FX1PiZ/3qyVw3h4kYT7bC0/YyoJYi+dfxe0RsUL8o=
X-Received: by 2002:ab0:70c9:: with SMTP id r9mr536687ual.15.1591743466435;
 Tue, 09 Jun 2020 15:57:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com> <20200605213853.14959-5-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-5-sean.j.christopherson@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 9 Jun 2020 15:57:35 -0700
Message-ID: <CANgfPd8p=SzkWucGm=a-ajRMfYmY1sPjeXBeZ6cHeAviQg9pag@mail.gmail.com>
Subject: Re: [PATCH 04/21] KVM: x86/mmu: Remove superfluous gotos from mmu_topup_memory_caches()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Jun 5, 2020 at 2:39 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Return errors directly from mmu_topup_memory_caches() instead of
> branching to a label that does the same.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 36c90f004ef4..ba70de24a5b0 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1100,13 +1100,11 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
>         r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
>                                    8 + PTE_PREFETCH_NUM);
>         if (r)
> -               goto out;
> +               return r;
>         r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache, 8);
>         if (r)
> -               goto out;
> -       r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache, 4);
> -out:
> -       return r;
> +               return r;
> +       return mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache, 4);
>  }
>
>  static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
> --
> 2.26.0
>
