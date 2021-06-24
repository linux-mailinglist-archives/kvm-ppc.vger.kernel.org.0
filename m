Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FA93B2810
	for <lists+kvm-ppc@lfdr.de>; Thu, 24 Jun 2021 08:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbhFXHA1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 24 Jun 2021 03:00:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20956 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230082AbhFXHAN (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 24 Jun 2021 03:00:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624517863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=igFDOV6BxGJ7IfsozRxLlI1SBnI7ilQNQtLZk9DKzFQ=;
        b=NfMKvr8Ax1E1LpAoe9jSBidAQj+ol3buwQmpYHGZG+kDQY+eCVgPPndbFH8AmRYtuUGdd6
        73Dbvk1gl3N6WMgE0j2Ge8KPXEThGtYmYzN2ufR5BXrPwwfcYj9hfimVKweuRvymgVyEEw
        vdbW6duZZOGeWQm/vjJkitKFrUcOawo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-Ysd_XqYdNJCP1L6N9_dAiA-1; Thu, 24 Jun 2021 02:57:41 -0400
X-MC-Unique: Ysd_XqYdNJCP1L6N9_dAiA-1
Received: by mail-wm1-f70.google.com with SMTP id m186-20020a1c26c30000b02901e1c85168f1so496714wmm.2
        for <kvm-ppc@vger.kernel.org>; Wed, 23 Jun 2021 23:57:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=igFDOV6BxGJ7IfsozRxLlI1SBnI7ilQNQtLZk9DKzFQ=;
        b=eBoEAxLkd/dxkLmHu1gRmAFFOcOjdgEzrNx3m9j8H77Kr1OOdcSBIdZjnFyWtVyPql
         X9pTNuVcvVTdkwvV5D6BRm6fi9ak674SrJfj1xePxLx7abuxPJiz53eYPUlodud8FwHC
         dx9n+mAFMMC6+W05hUAwIMD+LaJVOOGWTb5jmd7of8OUE54TV0AiPd5KRnf4udB2I7kE
         BH/GDNHdhpCuX7DpmHgSQf95CgzRmg5QiBPVfT7+90xY9mFUfESRmZBne4RMD1362qaA
         E1h429ewPcOpN2JiusYFnRAe0sYUv9+qCiwk8pjvm8NBlfaxviTT2dkzP/VnYKhkHNYQ
         9yGg==
X-Gm-Message-State: AOAM533k9txCEtpu2SRXdw2pH277hc6eqZvCNbaCF5It3xmU+T3MYZ5S
        p1pFgRLsOzeE2vEw19DAidzGqSjSZyiOvP1+uxN1VwAp0/tXv1n6rX5w3coe7gqoFoY34Z05KXm
        vPLo7qQlg5ODS8NDY1Q==
X-Received: by 2002:a05:6000:1889:: with SMTP id a9mr85612wri.141.1624517860504;
        Wed, 23 Jun 2021 23:57:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdqChWxI2TqFhdGI9pdTdW0OY2cpxOML9ILwZzD3plJUW6I8N3vbOFGhbVC127GRhm0xAu2w==
X-Received: by 2002:a05:6000:1889:: with SMTP id a9mr85587wri.141.1624517860347;
        Wed, 23 Jun 2021 23:57:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o26sm1900491wmr.29.2021.06.23.23.57.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 23:57:39 -0700 (PDT)
Subject: Re: [PATCH 0/6] KVM: Remove uses of struct page from x86 and arm64
 MMU
To:     David Stevens <stevensd@chromium.org>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        David Stevens <stevensd@google.com>
References: <20210624035749.4054934-1-stevensd@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20baae77-785c-5d46-e00c-41d86c2fbc56@redhat.com>
Date:   Thu, 24 Jun 2021 08:57:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210624035749.4054934-1-stevensd@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 24/06/21 05:57, David Stevens wrote:
> KVM supports mapping VM_IO and VM_PFNMAP memory into the guest by using
> follow_pte in gfn_to_pfn. However, the resolved pfns may not have
> assoicated struct pages, so they should not be passed to pfn_to_page.
> This series removes such calls from the x86 and arm64 secondary MMU. To
> do this, this series modifies gfn_to_pfn to return a struct page in
> addition to a pfn, if the hva was resolved by gup. This allows the
> caller to call put_page only when necessated by gup.
> 
> This series provides a helper function that unwraps the new return type
> of gfn_to_pfn to provide behavior identical to the old behavior. As I
> have no hardware to test powerpc/mips changes, the function is used
> there for minimally invasive changes. Additionally, as gfn_to_page and
> gfn_to_pfn_cache are not integrated with mmu notifier, they cannot be
> easily changed over to only use pfns.
> 
> This addresses CVE-2021-22543 on x86 and arm64.

Thank you very much for this.  I agree that it makes sense to have a 
minimal change; I had similar changes almost ready, but was stuck with 
deadlocks in the gfn_to_pfn_cache case.  In retrospect I should have 
posted something similar to your patches.

I have started reviewing the patches, and they look good.  I will try to 
include them in 5.13.

Paolo

