Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9595D1F49F0
	for <lists+kvm-ppc@lfdr.de>; Wed, 10 Jun 2020 01:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbgFIXD5 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Jun 2020 19:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbgFIXDx (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 9 Jun 2020 19:03:53 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51437C08C5C4
        for <kvm-ppc@vger.kernel.org>; Tue,  9 Jun 2020 16:03:53 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id e1so122500vkd.1
        for <kvm-ppc@vger.kernel.org>; Tue, 09 Jun 2020 16:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QPEA53MpdF9ON3exFjCberFh9r4WY/+iX04WGFZFtXU=;
        b=rwanDsZdo86Rv+vzZDRG+0C9QrHIbGQgfj2nwO+GiGBNVyLSExN93DGrkptklgs9I1
         AC0cy3+rivR0wtaNSSV9u8U2CqWzAr9cwayr0OtE6O+jC2+BtUr9VjUb8UFNbXJkVAi1
         WfJhopss4dvT37wHibefpDeELAXyANGodPwrJTtsn9yIlJTNlMVMXjXyhR/cP5akWDCP
         mjbboyehlJjrEud3b556BAnXu9H3ea7lZqMAdBWMg65r0d3SNuuwYPZvv8rUlGOJMmVx
         1rAQzDRF0wybOVz5i+mnG2dV7tbBHX6NxTZfN6sP+E0p5F7rIRZGBiMOtY3RefHOaxGa
         MGfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QPEA53MpdF9ON3exFjCberFh9r4WY/+iX04WGFZFtXU=;
        b=SvDpCa/teIuEk+hHUy+/PS4mh9Y0Ta+ShtPT317WVDV59ZkG22JtxP4JQ7sMpJkbgD
         1TdOCzjIHQ1fPkj17teXIcCzQpMjgAX2f4fdIj427XGLTmKsBYPbzVDw3veBfaJEXUTY
         pDsODebwebrnqyRqEgbz58rjcBK8ixJcdWDWMdrq8gvJaYqQ6jBZL2Ld0bfmuwSQ5b/z
         0RMgKl6yU2kPRa3vRF0QODHIBonWz756XItRbCpjcpWKZIbJI5t0UDvZiMt3LGKXwv7G
         TxSKqzZG+lBjO+zUi0X2R5mgUQjdXBEmuajBLVKyc0XvVRDXhWLRNw99PbhuY2mDArjB
         mAFQ==
X-Gm-Message-State: AOAM530TTk6X8xGjQo5nOzdchO9++ZbOKZTbEW8zTlN1hleMOyCsO+tg
        9K1FJDljJzFdtQEU+P9SiGI1BkEjzdVWqJ7Q5d8ciw==
X-Google-Smtp-Source: ABdhPJwvz0K9ugkUS0zUu2sV6SC9xdH2ngcwyFlRhaY+EjhyMbUztSqGBkZnAcJGtcUe/roomwm1IuKpnHfl3gWMyfI=
X-Received: by 2002:a1f:974d:: with SMTP id z74mr401275vkd.40.1591743831579;
 Tue, 09 Jun 2020 16:03:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com> <20200605213853.14959-7-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-7-sean.j.christopherson@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 9 Jun 2020 16:03:40 -0700
Message-ID: <CANgfPd9Y9P+-got9HmtrvChmwZBe-XOA0zSSLMsPCUKcuBv4aQ@mail.gmail.com>
Subject: Re: [PATCH 06/21] KVM: x86/mmu: Move fast_page_fault() call above mmu_topup_memory_caches()
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
> Avoid refilling the memory caches and potentially slow reclaim/swap when
> handling a fast page fault, which does not need to allocate any new
> objects.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5e773564ab20..4b4c3234d623 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4095,6 +4095,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>         if (page_fault_handle_page_track(vcpu, error_code, gfn))
>                 return RET_PF_EMULATE;
>
> +       if (fast_page_fault(vcpu, gpa, error_code))
> +               return RET_PF_RETRY;
> +
>         r = mmu_topup_memory_caches(vcpu);
>         if (r)
>                 return r;
> @@ -4102,9 +4105,6 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>         if (lpage_disallowed)
>                 max_level = PG_LEVEL_4K;
>
> -       if (fast_page_fault(vcpu, gpa, error_code))
> -               return RET_PF_RETRY;
> -
>         mmu_seq = vcpu->kvm->mmu_notifier_seq;
>         smp_rmb();
>
> --
> 2.26.0
>
