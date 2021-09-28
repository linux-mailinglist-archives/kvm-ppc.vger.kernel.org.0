Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30B041B6C3
	for <lists+kvm-ppc@lfdr.de>; Tue, 28 Sep 2021 20:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242348AbhI1S7d (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 28 Sep 2021 14:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242332AbhI1S7d (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 28 Sep 2021 14:59:33 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8716DC06161C
        for <kvm-ppc@vger.kernel.org>; Tue, 28 Sep 2021 11:57:53 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 75so85920pga.3
        for <kvm-ppc@vger.kernel.org>; Tue, 28 Sep 2021 11:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hbmr+iwzxjrwsm+tEChOCbQhDq6UlfLy+47j+9ocUio=;
        b=LIUKsJb5csfGXRweUbuDpDidwcU5eWp7I/BC8UyxJljOvp53d1+D8/lVafchjWnTQ0
         UFJ3m7MEw7wR7ZRxd8ACwxPZ0m52bD6vj7TVNWZMtZNMTJOZwlD3eAWWyH1Qjhl43L3U
         W1FytngggVEVCnX/gF5j3GcAVm16wdtULlRYpFUEUDEjCyafanTtEjpuUFGcRp39K4zP
         8bcEH690dj17b/WyNjFuFNPEP5hGpR8USgdsDcq9O2S4cVlCSktUAxA777RgXT/lt+Vv
         Bzig6jNqwzLE2GfeCQZTnW8FZN7tYmEiOfv/wCyJ4cPc56oImH3Qexl4IlFXY6fcK+dx
         1HLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hbmr+iwzxjrwsm+tEChOCbQhDq6UlfLy+47j+9ocUio=;
        b=ZsPKWf/73WDY3SZAcTHcIOGR5fz9f9vPmcFFgCCq/wiFnaCyYZdcdW5pUpVT729V2h
         dgwc1c5+BCQGCWffnsKqkMT4t909RABAMrMvDsoem6ZSq83Y8YloclyvI86JupHAyTnD
         mjvvanUvcdqORuSOeK0rmoeV1BXrk64cAUF9iTcvEEA487tTz+II3rEOq5JOI5/Yf7Qi
         xQ27ClIlK/S1kaI9wRggcWiQ9sX0p0IdAe/is2L79aW75XxRpdHfsSsCb39X/jLg677m
         cI/867H0+Sug5ZzXFhARMb1l8eKVGmrNnnxbgw7rJg3Up1mvdBLoVu9aeCTNmVxta6E6
         R0lA==
X-Gm-Message-State: AOAM530GjVaJQIflLkKs9g47v5R8i92mumy4S+Hr8Pmu+/III9GBL4DU
        2y7CP+/ks9g0LlBKY7Kj372xQA==
X-Google-Smtp-Source: ABdhPJzvJEVMFLwNuCMQ/B/wkbjy954+2YLM0705uJahpnQn4hlzIhG6+toRk9qgzctw/+QJEMGtgw==
X-Received: by 2002:a62:7ccf:0:b0:444:9264:dbcd with SMTP id x198-20020a627ccf000000b004449264dbcdmr7051691pfc.50.1632855472798;
        Tue, 28 Sep 2021 11:57:52 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id f16sm21088582pfk.110.2021.09.28.11.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 11:57:52 -0700 (PDT)
Date:   Tue, 28 Sep 2021 18:57:46 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
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
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 02/14] KVM: Update halt-polling stats if and only if
 halt-polling was attempted
Message-ID: <YVNlqgEKluDRVGv0@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-3-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210925005528.1145584-3-seanjc@google.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Sep 24, 2021 at 05:55:16PM -0700, Sean Christopherson wrote:
> Don't update halt-polling stats if halt-polling wasn't attempted.  This
> is a nop as @poll_ns is guaranteed to be '0' (poll_end == start), but it
> will allow a future patch to move the histogram stats into the helper to
> resolve a discrepancy in what is considered a "successful" halt-poll.
> 
> No functional change intended.
> 
> Cc: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  virt/kvm/kvm_main.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 768a4cbb26a6..8b33f5045b4d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3214,6 +3214,7 @@ update_halt_poll_stats(struct kvm_vcpu *vcpu, u64 poll_ns, bool waited)
>  void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  {
>  	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
> +	bool do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
>  	ktime_t start, cur, poll_end;
>  	bool waited = false;
>  	u64 block_ns;
> @@ -3221,7 +3222,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	kvm_arch_vcpu_blocking(vcpu);
>  
>  	start = cur = poll_end = ktime_get();
> -	if (vcpu->halt_poll_ns && halt_poll_allowed) {
> +	if (do_halt_poll) {
>  		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
>  
>  		++vcpu->stat.generic.halt_attempted_poll;
> @@ -3273,8 +3274,9 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	kvm_arch_vcpu_unblocking(vcpu);
>  	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
>  
> -	update_halt_poll_stats(
> -		vcpu, ktime_to_ns(ktime_sub(poll_end, start)), waited);
> +	if (do_halt_poll)
> +		update_halt_poll_stats(
> +			vcpu, ktime_to_ns(ktime_sub(poll_end, start)), waited);
>  
>  	if (halt_poll_allowed) {
>  		if (!vcpu_valid_wakeup(vcpu)) {
> -- 
> 2.33.0.685.g46640cef36-goog
> 
