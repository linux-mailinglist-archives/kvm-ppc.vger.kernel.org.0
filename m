Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5136F18F4EB
	for <lists+kvm-ppc@lfdr.de>; Mon, 23 Mar 2020 13:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgCWMq2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 23 Mar 2020 08:46:28 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:42612 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728061AbgCWMq2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 23 Mar 2020 08:46:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584967587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7ey+1F39M8ByNAstuPtE4DBKq3YafypzQysKAMbXteM=;
        b=J4ST1exSSOIyiByhCcSn+VhGk56MHD9Ep9qjzCSUopWFN4KYmhf94hR4I790NSXUFy4nYA
        l3muuKl7nWjm5nAA5CyRx9uG3atR9ABbo0E5xPOm6mR9Uglf49UESE4BYAA7Gt0aJK6ch5
        m47N/wxo7iIVx5CIH49drJZjFzNa4oY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-oF33DZKzNE2BrTiHK_a1HA-1; Mon, 23 Mar 2020 08:46:25 -0400
X-MC-Unique: oF33DZKzNE2BrTiHK_a1HA-1
Received: by mail-wm1-f71.google.com with SMTP id f207so3515796wme.6
        for <kvm-ppc@vger.kernel.org>; Mon, 23 Mar 2020 05:46:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=7ey+1F39M8ByNAstuPtE4DBKq3YafypzQysKAMbXteM=;
        b=GG4yQbI9V9SpT6Gbf/JSGuvIUJ0Pm5IQwrV1hwxuoqNBGcoBeZzzfRO1NzFl0zc93h
         b1c01zY/eTAMkqxxYDYljRX3Ddzjjs6YnXKyUnhU3LMKNp/8y6pNbJ4lRfRlKw0nC4UW
         QyI0SGZz1Qb4UQyfAOD+yDVxxXxUEkx9PBlJ92lIb41J9PLNMzm8IDRXNMRq8sey4KRH
         XGXcm02zdJJBuV/FdUBk6SlKZ6kuKtuV8fhuA0O+8EjsuES6jnLVglLLlNxpkBEZudpZ
         eGjlWvHfYT7IoxQxFUkTz0NC2zDOa/CNKET0JnajAOIN/OvascO5RDdrt+8muj1ixiL3
         ndlA==
X-Gm-Message-State: ANhLgQ3+Fy6j43iiR4Lf4rx2zJw2ard5seY8D1uLs9w7G7hgN+UCpIQ9
        swxOU7wBlpUIAbT4fnlai88O/Zgta3z3Wpk6uTVTuvPkSU2xZmkWz4gptdUw7m8cfQNQ1KfrgEi
        1moDvmSt4zC93QMuDDg==
X-Received: by 2002:a1c:6745:: with SMTP id b66mr27121455wmc.30.1584967584692;
        Mon, 23 Mar 2020 05:46:24 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vs9yhBZxRUgm+rnsEcxWBh8IaB2Gorhbhsei0xdDIWP+ldbP2TNlbOrXiLaqIWct/my8m4nng==
X-Received: by 2002:a1c:6745:: with SMTP id b66mr27121425wmc.30.1584967584395;
        Mon, 23 Mar 2020 05:46:24 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f15sm23749313wru.83.2020.03.23.05.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 05:46:23 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/9] KVM: x86: Drop __exit from kvm_x86_ops' hardware_unsetup()
In-Reply-To: <20200321202603.19355-8-sean.j.christopherson@intel.com>
References: <20200321202603.19355-1-sean.j.christopherson@intel.com> <20200321202603.19355-8-sean.j.christopherson@intel.com>
Date:   Mon, 23 Mar 2020 13:46:22 +0100
Message-ID: <87a7479r35.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Remove the __exit annotation from VMX hardware_unsetup(), the hook
> can be reached during kvm_init() by way of kvm_arch_hardware_unsetup()
> if failure occurs at various points during initialization.
>
> Note, there is no known functional issue with the __exit annotation, the
> above is merely justification for its removal.  The real motivation is
> to be able to annotate vmx_x86_ops and svm_x86_ops with __initdata,
> which makes objtool complain because objtool doesn't understand that the
> vendor specific __initdata is being copied by value to a non-__initdata
> instance.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  arch/x86/kvm/vmx/vmx.c          | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 54f991244fae..42a2d0d3984a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1056,7 +1056,7 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
>  struct kvm_x86_ops {
>  	int (*hardware_enable)(void);
>  	void (*hardware_disable)(void);
> -	void (*hardware_unsetup)(void);            /* __exit */
> +	void (*hardware_unsetup)(void);
>  	bool (*cpu_has_accelerated_tpr)(void);
>  	bool (*has_emulated_msr)(int index);
>  	void (*cpuid_update)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4bbe0d165a0c..fac22e316417 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7652,7 +7652,7 @@ static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
>  	return to_vmx(vcpu)->nested.vmxon;
>  }
>  
> -static __exit void hardware_unsetup(void)
> +static void hardware_unsetup(void)
>  {
>  	if (nested)
>  		nested_vmx_hardware_unsetup();

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

