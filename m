Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C7344DA82
	for <lists+kvm-ppc@lfdr.de>; Thu, 11 Nov 2021 17:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbhKKQe6 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 11 Nov 2021 11:34:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39375 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233902AbhKKQe5 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 11 Nov 2021 11:34:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636648327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xONcWka4yJg1UQhheAmGmQGTeSz62+BFAMVpGU5MQlM=;
        b=ZFk/12Nj960PWgtq5aTi8SV3sqMq8o+Mx1XZWpnHefGW9PTsRlbsUAsKmjOuxEgoGHdpJU
        1WXY9Ik2MjHBAi/DS192hyAEJ/CX1m8kRVgtY31pPdAsecJ4atNTYqD4gTSPocg9aS4hAX
        zpr4gO3srTFIAzjEwMN2jfeuKmrduJI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-8WboDPO6OIalB6EDz17RBA-1; Thu, 11 Nov 2021 11:32:06 -0500
X-MC-Unique: 8WboDPO6OIalB6EDz17RBA-1
Received: by mail-wm1-f69.google.com with SMTP id l4-20020a05600c1d0400b00332f47a0fa3so2894366wms.8
        for <kvm-ppc@vger.kernel.org>; Thu, 11 Nov 2021 08:32:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xONcWka4yJg1UQhheAmGmQGTeSz62+BFAMVpGU5MQlM=;
        b=jhCyNRQ/GYFuBTCv6yGmyPgdrGlrt9LAHhWYvB70g8kJldbojBy/aJ3GJ8qAYU6vCC
         TzJl0aLyG3B6DXC/dw6bMWeaOt6mNvnStU/wZpYIaZ63WhuATtUvdDy86a1Aim8Ob8X2
         3OSpz40iv/gNZq11Lyhz2HSGcIXrWoSlFRl5dFOi63mqmDAkG5oCM+NLSBouLeM3yy8g
         a0GGBn3YVRj13sot5gt8v1vpoOw+2Lq3AWFRNysso5J7AM5FbFfhy9PJY/3CheBFLDNO
         5XUMZYPGGXAHTPWnh0WIHupUlLTHPnhynv0K3UuZ6REjnRBFH1ysVusu1gXVT0PZs4Nn
         huYQ==
X-Gm-Message-State: AOAM532jLVPhX1COMIokXraN8DYPk8jYtxYFKl9dvT+IELeyYPe5uRfA
        KzgAh4vyDX5LF9k+cu3NnsmoHwHFb9KKz351MBOPlAcJ7JLUJ+2F6GGvFsPMchlObRSqAICEVtr
        G1K0Z/NAvxR3xGluxOw==
X-Received: by 2002:a05:600c:3553:: with SMTP id i19mr26522389wmq.97.1636648325381;
        Thu, 11 Nov 2021 08:32:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxnDkUP6eGDmwtDENl8am0CL9MrNcHh26P8buehu4QWyCT5kMI7SNPBa0SKMZxtky6JcBjzZg==
X-Received: by 2002:a05:600c:3553:: with SMTP id i19mr26522360wmq.97.1636648325165;
        Thu, 11 Nov 2021 08:32:05 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id l22sm3253329wmp.34.2021.11.11.08.32.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 08:32:04 -0800 (PST)
Message-ID: <4a3c7be7-12fa-6e47-64eb-02e6c5be5dbc@redhat.com>
Date:   Thu, 11 Nov 2021 17:32:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 0/5] KVM: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS and
 re-purpose it on x86
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
References: <20211111162746.100598-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211111162746.100598-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 11/11/21 17:27, Vitaly Kuznetsov wrote:
> This is a comtinuation of "KVM: x86: Drop arbitraty KVM_SOFT_MAX_VCPUS"
> (https://lore.kernel.org/kvm/20211111134733.86601-1-vkuznets@redhat.com/)
> work.
> 
> 1) Enforce KVM_CAP_NR_VCPUS <= KVM_CAP_MAX_VCPUS rule on all
>   architectures. [Sean Christopherson]
> 2) Make KVM_CAP_NR_VCPUS return num_online_cpus() and not an arbitrary
>   value of '710' on x86.
> 
> Everything but x86 was only 'eyeball tested', the change is trivial
> but sorry in advance if I screwed up)

Christian, can you look at this for s390?  Returning a fixed value seems 
wrong for KVM_CAP_NR_VCPUS.

Thanks,

Paolo

> Vitaly Kuznetsov (5):
>    KVM: arm64: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
>    KVM: MIPS: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
>    KVM: PPC: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
>    KVM: RISC-V: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
>    KVM: x86: Drop arbitraty KVM_SOFT_MAX_VCPUS
> 
>   arch/arm64/kvm/arm.c            | 7 ++++++-
>   arch/mips/kvm/mips.c            | 2 +-
>   arch/powerpc/kvm/powerpc.c      | 4 ++--
>   arch/riscv/kvm/vm.c             | 2 +-
>   arch/x86/include/asm/kvm_host.h | 1 -
>   arch/x86/kvm/x86.c              | 2 +-
>   6 files changed, 11 insertions(+), 7 deletions(-)
> 

