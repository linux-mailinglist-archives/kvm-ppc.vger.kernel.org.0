Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2A0352A12
	for <lists+kvm-ppc@lfdr.de>; Fri,  2 Apr 2021 13:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235077AbhDBLJE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 2 Apr 2021 07:09:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40451 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235014AbhDBLJE (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 2 Apr 2021 07:09:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617361742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0hU09Gh7VhRgV7xvcyXGklubADiCKUnFuUwdUO/8C8M=;
        b=UxcHE4k6GwY9MYg/uAEe5hAlPDPoWQv7OAg989pxTX0HFhBeGBA1Dz6MjVqf/zAU+ez2et
        od5P+hrS1kojTc466ck8TYVDb5HQvySiVyUmuKGNgVLYmkecYLAlcWxw2+N4eLrwVPrfht
        eeSMR971gsnGVuAU2SjxJHJrYg0PLc8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-iVfHpmj3MKKhGf_DQgwpaA-1; Fri, 02 Apr 2021 07:09:01 -0400
X-MC-Unique: iVfHpmj3MKKhGf_DQgwpaA-1
Received: by mail-wm1-f71.google.com with SMTP id a17so2090320wme.4
        for <kvm-ppc@vger.kernel.org>; Fri, 02 Apr 2021 04:09:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0hU09Gh7VhRgV7xvcyXGklubADiCKUnFuUwdUO/8C8M=;
        b=az9zBA+ELhI19wl79rpvZtlz78eUUadZpx62ra0BOjfInxSyPOzqDnUbVDmHervV8g
         19+BUtCFYa+oUlp5iFzADwu0qTZPpSCmKMBzFg1uwkzTFHRJbJx+ukfDBJYlzj+oab1T
         OyzZXTYXu7GKc7GT9Fw66eZ0rE1Ey9EdIq16zcgfgvWQyV/kJSyYT4W29fqbhnRucqEQ
         x7K5Or/8Bt5P745yKdM+4OvxwsEuqmh0P7NObM1rkqIxX/xqiPog1zAlDUbe+387RzRv
         Swoyo4bEtVj8W3YRwbXUQmuzbNMAReqEXaU3qjjIos7+x3cpr7yZq78nNwdbVt4TPdXI
         mBqA==
X-Gm-Message-State: AOAM531u4BfP+x9I4VDTQT/kvM934buE2SZg92CniEoBwpwqqS+icUCj
        dNFCYwGmWxK0NhSRKzdCVSO+Gwv1y4qGXu1r68Epwesm+2QP/nV4nkVhcvvAxCHen/U4j3WJ50G
        fq7xGaqHxkfksj8GH8g==
X-Received: by 2002:a7b:c407:: with SMTP id k7mr12554646wmi.136.1617361740010;
        Fri, 02 Apr 2021 04:09:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTzlBVbJGp7zOm3yypid9AymbapTJgMzZcFAv4/0wGVk1JV0HTRbkNFWcPN0Mr5tyDof6yiw==
X-Received: by 2002:a7b:c407:: with SMTP id k7mr12554609wmi.136.1617361739749;
        Fri, 02 Apr 2021 04:08:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id p17sm11190916wmq.47.2021.04.02.04.08.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 04:08:59 -0700 (PDT)
Subject: Re: [PATCH v2 01/10] KVM: Assert that notifier count is elevated in
 .change_pte()
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
References: <20210402005658.3024832-1-seanjc@google.com>
 <20210402005658.3024832-2-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3fb5283e-21f0-8eb2-03ab-96113ca1f463@redhat.com>
Date:   Fri, 2 Apr 2021 13:08:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210402005658.3024832-2-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 02/04/21 02:56, Sean Christopherson wrote:
> In KVM's .change_pte() notification callback, replace the notifier
> sequence bump with a WARN_ON assertion that the notifier count is
> elevated.  An elevated count provides stricter protections than bumping
> the sequence, and the sequence is guarnateed to be bumped before the
> count hits zero.
> 
> When .change_pte() was added by commit 828502d30073 ("ksm: add
> mmu_notifier set_pte_at_notify()"), bumping the sequence was necessary
> as .change_pte() would be invoked without any surrounding notifications.
> 
> However, since commit 6bdb913f0a70 ("mm: wrap calls to set_pte_at_notify
> with invalidate_range_start and invalidate_range_end"), all calls to
> .change_pte() are guaranteed to be bookended by start() and end(), and
> so are guaranteed to run with an elevated notifier count.
> 
> Note, wrapping .change_pte() with .invalidate_range_{start,end}() is a
> bug of sorts, as invalidating the secondary MMU's (KVM's) PTE defeats
> the purpose of .change_pte().  Every arch's kvm_set_spte_hva() assumes
> .change_pte() is called when the relevant SPTE is present in KVM's MMU,
> as the original goal was to accelerate Kernel Samepage Merging (KSM) by
> updating KVM's SPTEs without requiring a VM-Exit (due to invalidating
> the SPTE).  I.e. it means that .change_pte() is effectively dead code
> on _all_ architectures.
> 
> x86 and MIPS are clearcut nops if the old SPTE is not-present, and that
> is guaranteed due to the prior invalidation.  PPC simply unmaps the SPTE,
> which again should be a nop due to the invalidation.  arm64 is a bit
> murky, but it's also likely a nop because kvm_pgtable_stage2_map() is
> called without a cache pointer, which means it will map an entry if and
> only if an existing PTE was found.
> 
> For now, take advantage of the bug to simplify future consolidation of
> KVMs's MMU notifier code.   Doing so will not greatly complicate fixing
> .change_pte(), assuming it's even worth fixing.  .change_pte() has been
> broken for 8+ years and no one has complained.  Even if there are
> KSM+KVM users that care deeply about its performance, the benefits of
> avoiding VM-Exits via .change_pte() need to be reevaluated to justify
> the added complexity and testing burden.  Ripping out .change_pte()
> entirely would be a lot easier.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   virt/kvm/kvm_main.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d1de843b7618..8df091950161 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -461,12 +461,17 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
>   
>   	trace_kvm_set_spte_hva(address);
>   
> +	/*
> +	 * .change_pte() must be bookended by .invalidate_range_{start,end}(),

Changed to "surrounded" for the benefit of non-native speakers. :)

Paolo

> +	 * and so always runs with an elevated notifier count.  This obviates
> +	 * the need to bump the sequence count.
> +	 */
> +	WARN_ON_ONCE(!kvm->mmu_notifier_count);
> +
>   	idx = srcu_read_lock(&kvm->srcu);
>   
>   	KVM_MMU_LOCK(kvm);
>   
> -	kvm->mmu_notifier_seq++;
> -
>   	if (kvm_set_spte_hva(kvm, address, pte))
>   		kvm_flush_remote_tlbs(kvm);
>   
> 

