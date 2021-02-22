Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44AAE321F0B
	for <lists+kvm-ppc@lfdr.de>; Mon, 22 Feb 2021 19:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbhBVSTi (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Feb 2021 13:19:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53660 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232285AbhBVSSk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Feb 2021 13:18:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614017833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M1O2O9X5RXSfF+m5PX0DyBo6+zLejZgNhGtzl18mwLU=;
        b=QDjXmzeb1OSx90iF0IKeV2aFsu7iNXdqyaxP2vhMhiFcqs2njGWR9t6HXuETHmXksExCnP
        Ft3k5eDjMY7NerrJ+cOyFFbmgz2hcFX7HEi0+AM+oEOU4/JkYfDgSQZeil4cnWxYAOq9uo
        z+5Weeg5mhQQ1vZ34OXNZusETOZlu6U=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-VyWuv1GiNF6CjdPIZwYGXQ-1; Mon, 22 Feb 2021 13:17:09 -0500
X-MC-Unique: VyWuv1GiNF6CjdPIZwYGXQ-1
Received: by mail-ed1-f69.google.com with SMTP id w9so7316001edi.15
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Feb 2021 10:17:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M1O2O9X5RXSfF+m5PX0DyBo6+zLejZgNhGtzl18mwLU=;
        b=etxFGhzRVOzOE6I41x3MB0k49f3/QwHm2QKqNbX8CbiV7hX8zfP9kSM51IP3mmxEEc
         0qmH94tvjUP1xDgORlW/WTbzR42ewoTSthSfShKxr6URhtvvZJvegy8RxZnBAJ1jGvxA
         7gCX5rA/CJKuNyex0gZIr9WxidCXN9dxiEEDobPvqlMqzfrgCaHji15c7KyWY2pKW2DY
         hOt6994svEDaoXruqusrdGGp+qnWhYZ2+f1z6OLliMzvzqgZLHgqoodM4h/XRAd+lzpF
         mg7Ppee1J/up557ZNbMud2gv4/wq7KHuEx6aI/ZgRCOkNnIszqzsZeqz6/s7Z4U58aLW
         lNjQ==
X-Gm-Message-State: AOAM533IIZPlEv2nKkeZaC0zhf5JHkqNJNBjS/TkITQX0kcd2KGmSqgt
        Vnzl/BD7ma4SjWWGZ014sl/kyKnAPmnbgX8Lu63C47qYWHK0M81bjJBmf3Fc81Q8UeHdasu1vnu
        lkM9FU5wE+MoWz/RntA==
X-Received: by 2002:a17:906:1c4f:: with SMTP id l15mr11171173ejg.148.1614017828673;
        Mon, 22 Feb 2021 10:17:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzT03kSWOr2tXOOmqkmqccMekugd1GPN0H9nHYrXxVs3CozSxxVXGpHmYF/OdiWxYx0Hw1ilw==
X-Received: by 2002:a17:906:1c4f:: with SMTP id l15mr11171153ejg.148.1614017828484;
        Mon, 22 Feb 2021 10:17:08 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d5sm12773936edu.12.2021.02.22.10.17.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 10:17:07 -0800 (PST)
Subject: Re: [PATCH v4 0/2] KVM: x86/mmu: Skip mmu_notifier changes when
 possible
To:     David Stevens <stevensd@chromium.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        kvm-ppc@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Stevens <stevensd@google.com>
References: <20210222024522.1751719-1-stevensd@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7fe10f74-e183-411a-468b-93fcdf786bb6@redhat.com>
Date:   Mon, 22 Feb 2021 19:17:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210222024522.1751719-1-stevensd@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 22/02/21 03:45, David Stevens wrote:
> These patches reduce how often mmu_notifier updates block guest page
> faults. The primary benefit of this is the reduction in the likelihood
> of extreme latency when handling a page fault due to another thread
> having been preempted while modifying host virtual addresses.
> 
> v3 -> v4:
>   - Fix bug by skipping prefetch during invalidation
> 
> v2 -> v3:
>   - Added patch to skip check for MMIO page faults
>   - Style changes
> 
> David Stevens (1):
>    KVM: x86/mmu: Consider the hva in mmu_notifier retry
> 
> Sean Christopherson (1):
>    KVM: x86/mmu: Skip mmu_notifier check when handling MMIO page fault
> 
>   arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
>   arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
>   arch/x86/kvm/mmu/mmu.c                 | 23 ++++++++++++++------
>   arch/x86/kvm/mmu/paging_tmpl.h         |  7 ++++---
>   include/linux/kvm_host.h               | 25 +++++++++++++++++++++-
>   virt/kvm/kvm_main.c                    | 29 ++++++++++++++++++++++----
>   6 files changed, 72 insertions(+), 16 deletions(-)
> 

Rebased, and queued with the fix that Sean suggested.

Paolo

