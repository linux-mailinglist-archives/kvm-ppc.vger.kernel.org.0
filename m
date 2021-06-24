Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7C73B32AA
	for <lists+kvm-ppc@lfdr.de>; Thu, 24 Jun 2021 17:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbhFXPhx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 24 Jun 2021 11:37:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26497 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232377AbhFXPhw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 24 Jun 2021 11:37:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624548932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f6k4ykVaPXFxqKCeveqsqgjZTsHJh+2Hx0FU9Hu8Shk=;
        b=fEwzt1Ur7YqA7l19kiUugGJRO/H/dvI+1x7GM/mgPG5F4QUtx+W0HI8u0m96/5ozq+RbCi
        3T32lRrJx4rRV1849gEUVzpzd6XTkxIEo+A3krIkt30LVuyZwN1CrpHJ1JLiekYIoTO7Y8
        Rdl2pVPnEFdzKdgoXeuqVj9b84ScU3Q=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-OqLOZcMJMXeBDnIOELGdaw-1; Thu, 24 Jun 2021 11:35:29 -0400
X-MC-Unique: OqLOZcMJMXeBDnIOELGdaw-1
Received: by mail-wr1-f71.google.com with SMTP id d9-20020adffbc90000b029011a3b249b10so2328044wrs.3
        for <kvm-ppc@vger.kernel.org>; Thu, 24 Jun 2021 08:35:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f6k4ykVaPXFxqKCeveqsqgjZTsHJh+2Hx0FU9Hu8Shk=;
        b=Ga9eAH3hgycCh5NP+/gp3E5l8h8p/FKejI/Qkm+hsONFk4vJqcM9mWfxZKuX1YedKF
         CZX3D4xYw3dHpCFiC4gL4uFrvFJvXZ4FzOJ3clWjoLx22w/9d8+nSE/WIWaK+JcknmXR
         U0bxkfPQY5GgRS/t5diQhvxiEIsjb52SqkbtPkSLtidXIXR26kXZQ2ghmEMlOp4uMJg5
         tcAdVdk5no0Bpa0SIC5n6kmsHwLakfmFUWuihaW7mKbBi9hJBKK+ewlN2HeBkFUmleyq
         zgCbk2Xj0Uajdph+cSPW3kpIReuyspZVov11UmPHxky2gOvgm3SCP7arwl1NXi44lYPh
         8bGw==
X-Gm-Message-State: AOAM530wtjorQzhHyeIFZnQ9Mf0uNUsVA+eKLnJbfgpZAeBelH3TerZy
        icbri0PksEcBH0rtTUjPuZkG+OrHQf9IXrnJRRdTDXgNQfYOe9vyGvTqh1ra+qFH1IySR7F7lWl
        UNx9bpd4HXqc9YD1/JQ==
X-Received: by 2002:a05:6000:1251:: with SMTP id j17mr5373908wrx.122.1624548927961;
        Thu, 24 Jun 2021 08:35:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBnDqu4vf3bAIylFJkD7JiEEmgRW9T3VoP4swdNx5pmdzHboAZtCJNJi7bVPTY8V2i+hs/AQ==
X-Received: by 2002:a05:6000:1251:: with SMTP id j17mr5373864wrx.122.1624548927675;
        Thu, 24 Jun 2021 08:35:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v18sm4013288wrv.24.2021.06.24.08.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 08:35:27 -0700 (PDT)
To:     Nicholas Piggin <npiggin@gmail.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        David Stevens <stevensd@chromium.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        James Morse <james.morse@arm.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvmarm@lists.cs.columbia.edu,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Sean Christopherson <seanjc@google.com>,
        David Stevens <stevensd@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Will Deacon <will@kernel.org>
References: <20210624035749.4054934-1-stevensd@google.com>
 <1624530624.8jff1f4u11.astroid@bobo.none>
 <1624534759.nj0ylor2eh.astroid@bobo.none>
 <0d3a699a-15eb-9f1b-0735-79d14736f38c@redhat.com>
 <1624539354.6zggpdrdbw.astroid@bobo.none>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/6] KVM: Remove uses of struct page from x86 and arm64
 MMU
Message-ID: <81d99029-ec40-19c5-5647-20607d78dab0@redhat.com>
Date:   Thu, 24 Jun 2021 17:35:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1624539354.6zggpdrdbw.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 24/06/21 14:57, Nicholas Piggin wrote:
> KVM: Fix page ref underflow for regions with valid but non-refcounted pages

It doesn't really fix the underflow, it disallows mapping them in the 
first place.  Since in principle things can break, I'd rather be 
explicit, so let's go with "KVM: do not allow mapping valid but 
non-reference-counted pages".

> It's possible to create a region which maps valid but non-refcounted
> pages (e.g., tail pages of non-compound higher order allocations). These
> host pages can then be returned by gfn_to_page, gfn_to_pfn, etc., family
> of APIs, which take a reference to the page, which takes it from 0 to 1.
> When the reference is dropped, this will free the page incorrectly.
> 
> Fix this by only taking a reference on the page if it was non-zero,

s/on the page/on valid pages/ (makes clear that invalid pages are fine 
without refcounting).

Thank you *so* much, I'm awful at Linux mm.

Paolo

> which indicates it is participating in normal refcounting (and can be
> released with put_page).
> 
> Signed-off-by: Nicholas Piggin<npiggin@gmail.com>

