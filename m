Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB343B2953
	for <lists+kvm-ppc@lfdr.de>; Thu, 24 Jun 2021 09:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhFXHdk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 24 Jun 2021 03:33:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52958 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231463AbhFXHdh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 24 Jun 2021 03:33:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624519878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1ummzXLEBVOW6zJVjd9RvyjdRwJ4z9g5ls7IEU8SqM4=;
        b=EKjWU/oCsLdpB6Ve8sDprlx/L0Jt05YjwP5nSO/SYUSh4gTC+85eoSZaZuuwdLQFSIEMWj
        qWrffPhvgFsjuYne1khKwc/x06PQHRVUPrUT3Ib2m+TuT4HlrzKGtbNqe1+p3MT6Q9vAeM
        Wh98VQCon2LWEZOpu4LDd4QF+wj3dH8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-DqelZmWNOiyojiM3Nzq3FQ-1; Thu, 24 Jun 2021 03:31:14 -0400
X-MC-Unique: DqelZmWNOiyojiM3Nzq3FQ-1
Received: by mail-wr1-f71.google.com with SMTP id l6-20020a0560000226b029011a80413b4fso1843800wrz.23
        for <kvm-ppc@vger.kernel.org>; Thu, 24 Jun 2021 00:31:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1ummzXLEBVOW6zJVjd9RvyjdRwJ4z9g5ls7IEU8SqM4=;
        b=nrYi7qbCisjoLI5DMMTksazaT8STSIqC/y/vNaMgbgcrnboHJvwrO+it+jzjGHNvZV
         9Xx26CJ24DNgKuE8vXB4slvm45se36vJhu4uiyrXGdeQhqoEI0dsuBaPQ5mueqoxZzAw
         LPnkE6HFX5/WLMEE6k8hFs3qvexyRsdgC8Tm15PtdWkXdZN2dH7qg+/HD+wfVNfXAKKI
         oUgyxudGZ6g/64rEaCnaLxOgAXf7QR9qoUP9C55zNwuiaXCeaAEkUoXOM8rQ3W4nVg5P
         QsXq8ApIQWw84sNpcS+AkN4ZroeF5QmswYX+0aRJl0uWXSOGDiWRIVnbxLjOD6tqzmDy
         e/Zg==
X-Gm-Message-State: AOAM530UwxyNhyTn2hPiVE1i6wOdxMYVrIQxZa5+zR7o07QNpVZmzKo8
        ZzI8FK7lAnrs1pS2mVvjHsKpdVKX30BpwJ/gv7uB+1QXhFC9c+XBN8jET3xB1llpXTrbDyO4Omv
        kpH08g0x0t9dQ0zL7Yw==
X-Received: by 2002:adf:f88e:: with SMTP id u14mr2674298wrp.391.1624519873867;
        Thu, 24 Jun 2021 00:31:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmU2A8muf7XixWmRWMn8O50eJCa1GKEjZYZIlN1VsKBfgiuuBfyX9v0BcxFt1KFEfxAoHypw==
X-Received: by 2002:adf:f88e:: with SMTP id u14mr2674272wrp.391.1624519873717;
        Thu, 24 Jun 2021 00:31:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f19sm2269746wre.48.2021.06.24.00.31.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 00:31:13 -0700 (PDT)
Subject: Re: [PATCH 3/6] KVM: x86/mmu: avoid struct page in MMU
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
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
References: <20210624035749.4054934-1-stevensd@google.com>
 <20210624035749.4054934-4-stevensd@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <49504c79-2cd4-1707-a0a5-79b679a4b214@redhat.com>
Date:   Thu, 24 Jun 2021 09:31:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210624035749.4054934-4-stevensd@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 24/06/21 05:57, David Stevens wrote:
>   static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> -			int map_writable, int max_level, kvm_pfn_t pfn,
> +			int map_writable, int max_level,
> +			const struct kvm_pfn_page *pfnpg,
>   			bool prefault, bool is_tdp)
>   {
>   	bool nx_huge_page_workaround_enabled = is_nx_huge_pa

So the main difference with my tentative patches is that here I was 
passing the struct by value.  I'll try to clean this up for 5.15, but 
for now it's all good like this.  Thanks again!

Paolo

