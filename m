Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CC5439816
	for <lists+kvm-ppc@lfdr.de>; Mon, 25 Oct 2021 16:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbhJYOJL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 25 Oct 2021 10:09:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40891 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231812AbhJYOJK (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 25 Oct 2021 10:09:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635170807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FblMqi74l2aNQDmIbjX/cagfl890xy4Kf5Rp2sw8Ik4=;
        b=iybnwA0ZadanTHPHXV9Sbz8JrJm508VE747MwvM0WjR6zQ0H7YDqd8ZruBnkQ8FFxyEkLe
        EgxdHniFGcd9Kn9JX9OlnRN8CIce0gmXIzCQlA1kEkpfoB6YZQAZlGvUeoCF65178Zytrj
        D7Zwzzcgb/nbyViN/FOhKcEzj6+6j48=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-uwPYzbqEPiaIS-PYDp3yHw-1; Mon, 25 Oct 2021 10:06:46 -0400
X-MC-Unique: uwPYzbqEPiaIS-PYDp3yHw-1
Received: by mail-ed1-f71.google.com with SMTP id o22-20020a056402439600b003dd4f228451so3528704edc.16
        for <kvm-ppc@vger.kernel.org>; Mon, 25 Oct 2021 07:06:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FblMqi74l2aNQDmIbjX/cagfl890xy4Kf5Rp2sw8Ik4=;
        b=r0qbD2vaWIbUoZCNJR7Z9SGmL6Ea4P0g9h4iRpMlS/cnsAmMetAuQLnfNlOwAtykqm
         rviYly+r5afC6WvNYtOeaGGY1hoCv5m6ZN7Vr3adgUALXrxrFvJRIgnnqDL1LfeyuqbR
         SHXNUu8LkwHKvRrqTBW+YJRbRIERzzIZuieISycdrlzCAhmn7J+w+dBzbvIUDAM11qnI
         YQQ1+UYbWQHgN59y4NmKICUBb764GFd5GdJ2rOfrMQ600WSJrgmOzHwlz9AQuL0RwDGe
         yGeDsnfuPfPOsKkz7g+ZL3gReKrHG45YbXrqz6QB8YFN3x9NJTMYbWlQ/Fu0mTTBcAzO
         m/pQ==
X-Gm-Message-State: AOAM530DHWm3ao5cdClasITbZMiLGcXWdQYZpLpILfPXA9Ac6sQFKIm9
        2m+YFppJNzpuCDTzWQ0tFQsEAKcFbaQPNH2As5bJGwNU727p5Y8hrF/piJ2G+sP2gy8mAYGfJ44
        2jS95+f/kY8lFVuql3w==
X-Received: by 2002:a50:fb02:: with SMTP id d2mr11770118edq.100.1635170804931;
        Mon, 25 Oct 2021 07:06:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZ2X8dAbxM+1kv2smymvR7I3dtS7qD9GGOcFC9wjjp+md9MuSuvCzqRB05il5WqZEpIp8nlw==
X-Received: by 2002:a50:fb02:: with SMTP id d2mr11770084edq.100.1635170804745;
        Mon, 25 Oct 2021 07:06:44 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o3sm7472237eju.123.2021.10.25.07.06.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 07:06:44 -0700 (PDT)
Message-ID: <591073c1-b520-21de-8573-ddb83950e9f1@redhat.com>
Date:   Mon, 25 Oct 2021 16:06:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 19/43] KVM: Add helpers to wake/query blocking vCPU
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
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
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-20-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211009021236.4122790-20-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 09/10/21 04:12, Sean Christopherson wrote:
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 7e8396f74010..addd53b6eba6 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -649,7 +649,6 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>   {
>   	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
>   	struct timer_map map;
> -	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
>   
>   	if (unlikely(!timer->enabled))
>   		return;
> @@ -672,7 +671,7 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>   	if (map.emul_ptimer)
>   		soft_timer_cancel(&map.emul_ptimer->hrtimer);
>   
> -	if (rcuwait_active(wait))
> +	if (kvm_vcpu_is_blocking(vcpu))
>   		kvm_timer_blocking(vcpu);
>   
>   	/*

So this trick is what you're applying to x86 too instead of using 
vmx_pre_block, I see.

Paolo

