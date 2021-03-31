Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6478134FAD2
	for <lists+kvm-ppc@lfdr.de>; Wed, 31 Mar 2021 09:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhCaHwu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 31 Mar 2021 03:52:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29704 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234240AbhCaHwj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 31 Mar 2021 03:52:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617177158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pQ5Qm7wzrETleGdIZygb6hZggBdQLM72Jyc7tGd4rCA=;
        b=Pb3MkZ12nIe29/GyrQ+y0lVTcOrMgo2tE3vlLkV3c/ihfKSnePv8774ZAXxRdPr+7GnsGf
        XXadNkkv7SvdOV27vfK5ejdf/j7kaA8JH+L3uvlDRhCIbMxUVrsifa3/b/U8i6x4G0WdGe
        YbljWw7v2BsVSyCfU5+LH/r2sHrkPs8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-9peA4BoZOp-6Itl8a2GEfw-1; Wed, 31 Mar 2021 03:52:36 -0400
X-MC-Unique: 9peA4BoZOp-6Itl8a2GEfw-1
Received: by mail-wm1-f72.google.com with SMTP id c9so125359wme.5
        for <kvm-ppc@vger.kernel.org>; Wed, 31 Mar 2021 00:52:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pQ5Qm7wzrETleGdIZygb6hZggBdQLM72Jyc7tGd4rCA=;
        b=q7I479wAIR+IZiTz8XDzARIBl4z771dIZ95G3sjNYeG5iuQW9Zs6u+Ne8cfluRPOWH
         9qBv7MqGXTh1uOv7IPS75CX+Lyvab7bi2B6Au/Y1vQ5Ld1z5WhxwCOo+X8FxJSU+JxvC
         LCSxvRMZ1Mgg5s0ZOPq2VcDSv/kP8eWIR80s2LDy1E3qCxUUKFxVL4aQ4iLT5J3QrI3l
         SViTnoOxcM9Kq/gaZPnrhbi9O8PwENDBfSrk4DyN1wIPMsK+Ck/Ty2pWspkjpi/jLKdg
         VRR0x+5LIHyDe++NBcbm/4mgZfbYOrzbdjJqFxQpL4tgZivGJwLOjFqBlq6x+KgYvnj8
         ERvA==
X-Gm-Message-State: AOAM532Dx3I1ftrEHSIqYZpds553MbsgxcJqW63o0cDw3sruRETYxBsF
        /4164x8gHDjtuE3P9Y9yrZgUBs9e2stIk7hH9RY3afOYcQKBFGD+LP+V15JuYOQ3+6IFtasTYo/
        d64ZAFIxv/vgALE7vOw==
X-Received: by 2002:a1c:dfc1:: with SMTP id w184mr1947748wmg.21.1617177155318;
        Wed, 31 Mar 2021 00:52:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrEJ16pEEpfSd4UOjbnqA+7pbiSAPPFNpTAPEwcpv0H2fU5p4zyKOS02szcKvl3Y4jdrVOKQ==
X-Received: by 2002:a1c:dfc1:: with SMTP id w184mr1947732wmg.21.1617177155168;
        Wed, 31 Mar 2021 00:52:35 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id b17sm2793386wrt.17.2021.03.31.00.52.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 00:52:33 -0700 (PDT)
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
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-11-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 10/18] KVM: Move x86's MMU notifier memslot walkers to
 generic code
Message-ID: <ba3f7a9c-0b59-cbeb-5d46-4236cde2c51f@redhat.com>
Date:   Wed, 31 Mar 2021 09:52:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210326021957.1424875-11-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 26/03/21 03:19, Sean Christopherson wrote:
> +#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
> +	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
> +#else
>   	struct kvm *kvm = mmu_notifier_to_kvm(mn);
>   	int idx;
>  	trace_kvm_set_spte_hva(address);
>  
> 	idx = srcu_read_lock(&kvm->srcu);
> 
> 	KVM_MMU_LOCK(kvm);
> 
> 	kvm->mmu_notifier_seq++;
> 
> 	if (kvm_set_spte_hva(kvm, address, pte))
> 		kvm_flush_remote_tlbs(kvm);
> 
>   	KVM_MMU_UNLOCK(kvm);
>   	srcu_read_unlock(&kvm->srcu, idx);
> +#endif

The kvm->mmu_notifier_seq is missing in the new API side.  I guess you 
can add an argument to __kvm_handle_hva_range and handle it also in 
patch 15 ("KVM: Take mmu_lock when handling MMU notifier iff the hva 
hits a memslot").

Paolo

