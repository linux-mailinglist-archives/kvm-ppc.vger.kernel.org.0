Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A34B1F4A33
	for <lists+kvm-ppc@lfdr.de>; Wed, 10 Jun 2020 01:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgFIX41 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Jun 2020 19:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbgFIX40 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 9 Jun 2020 19:56:26 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80520C08C5C3
        for <kvm-ppc@vger.kernel.org>; Tue,  9 Jun 2020 16:56:26 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id g44so221979uae.12
        for <kvm-ppc@vger.kernel.org>; Tue, 09 Jun 2020 16:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4sxWZx3UI6VKLDq8Qy1UYUg5vtAHPMsTevThfv39TWA=;
        b=WLpRcLXqwdVOvuMgwWkmR8Gr4lwaHRK/EF6daq2IMeFXYgWSJrphnkQvLEH+41LO0x
         pBkEeJfVAEq/uryeN4HHM4Hb3NfdIqrrZcULOeMuMtGfZEKTK0JPggE4ybLNYEuiV0pp
         hiSCdaRlAd+ayR3yLwkLqaPFRVUUau1KjcEyNNFF5lmfQTLhnmvgVGyA1JJV3qaW45Fh
         jEN3gjAjfZpQCTtGPfowcu+cTV09P9OWMskURcxzz2UEuwU2bgMY7NSPvwSFJYRc6/bv
         5cAINv0x9snM9p3flSgBPUFTJrC9TtnEnQ07K+dBbcgAeuIsCrM4zFy5fBTuIldM5yBs
         xNEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4sxWZx3UI6VKLDq8Qy1UYUg5vtAHPMsTevThfv39TWA=;
        b=VT9UTynihYR/uWNkI1vJqXXRrsjObVgsfxk45jx1iBNmp/v6b3+quZKi1Y44XPcL2D
         gGnY1ft7HhYsfKQQU+fpHtsCwih1AWpaJ5/X7/+L38pgl2av6wez35HioiSMc1htMYF7
         7xGKrrdPM+G+y88VFGrCnvTy3m+1wO6kTL0P4Wp+rrBCLAy3nSjYcrYF1PlDbvnJTPO9
         wnXoPvHT8t5W8uJGzjF5ZtVL1bOJgYrwLNdJPPEqvBXlBHGsUt2L5wEqI+A2skMvnVbp
         7ls371MEE3Z8HeeB09SUF5/eGLiP8cxd9hW2VYqG9vOwQ8H05jMFGmNr3s7ZtjYJXWEW
         ScbQ==
X-Gm-Message-State: AOAM532bXl5QTiZuREGMDleK2mgCZUR4+mm9FjCyX3WvhUZBXuyHH3tM
        Y+gLtOhrcGNM/OfAnINUYebA4LrOqIXwJxRhz/m1tA==
X-Google-Smtp-Source: ABdhPJyXAGLXljdkHhgQRDD2Vm3KO3b89VigddFLuju4QbS8KbKbayXYphsX76+lBqoc+5yPzGQnUDz7icYaQgNy+rs=
X-Received: by 2002:ab0:6012:: with SMTP id j18mr679163ual.69.1591746985111;
 Tue, 09 Jun 2020 16:56:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com> <20200605213853.14959-10-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-10-sean.j.christopherson@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 9 Jun 2020 16:56:13 -0700
Message-ID: <CANgfPd_ftZ_fC0EEt=1nOoyc6Yi6Xo3TB4woY=tkHzXbjHk4aA@mail.gmail.com>
Subject: Re: [PATCH 09/21] KVM: x86/mmu: Separate the memory caches for shadow
 pages and gfn arrays
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
> Use separate caches for allocating shadow pages versus gfn arrays.  This
> sets the stage for specifying __GFP_ZERO when allocating shadow pages
> without incurring extra cost for gfn arrays.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 ++-
>  arch/x86/kvm/mmu/mmu.c          | 15 ++++++++++-----
>  2 files changed, 12 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 16347b050754..e7a427547557 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -636,7 +636,8 @@ struct kvm_vcpu_arch {
>         struct kvm_mmu *walk_mmu;
>
>         struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
> -       struct kvm_mmu_memory_cache mmu_page_cache;
> +       struct kvm_mmu_memory_cache mmu_shadow_page_cache;
> +       struct kvm_mmu_memory_cache mmu_gfn_array_cache;
>         struct kvm_mmu_memory_cache mmu_page_header_cache;
>
>         /*
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 451e0365e5dd..d245acece3cd 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1108,8 +1108,12 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
>                                    1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
>         if (r)
>                 return r;
> -       r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
> -                                  2 * PT64_ROOT_MAX_LEVEL);
> +       r = mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
> +                                  PT64_ROOT_MAX_LEVEL);
> +       if (r)
> +               return r;
> +       r = mmu_topup_memory_cache(&vcpu->arch.mmu_gfn_array_cache,
> +                                  PT64_ROOT_MAX_LEVEL);
>         if (r)
>                 return r;
>         return mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
> @@ -1119,7 +1123,8 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
>  static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>  {
>         mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
> -       mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
> +       mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
> +       mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
>         mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
>  }
>
> @@ -2096,9 +2101,9 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
>         struct kvm_mmu_page *sp;
>
>         sp = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> -       sp->spt = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache);
> +       sp->spt = mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
>         if (!direct)
> -               sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache);
> +               sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
>         set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
>
>         /*
> --
> 2.26.0
>
