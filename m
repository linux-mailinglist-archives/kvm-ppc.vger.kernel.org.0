Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDE318F487
	for <lists+kvm-ppc@lfdr.de>; Mon, 23 Mar 2020 13:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgCWM1m (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 23 Mar 2020 08:27:42 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:44604 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728149AbgCWM1l (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 23 Mar 2020 08:27:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584966460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VAG2Qatyfr9ITMHT/x+i3AqePq75ernJyjHorg/4AHo=;
        b=b8x0ckrZyMCKBUontO6vU79Mlw7Qlm43OLFUQUeG8w/oWZ9K00TYEKwVCWDLHLFzA0un9P
        ew7MEOaLa3Jd11lGl+yxEgV/lKrlh1taEBockkMgiZfyq6MapNFQGn/52xMJRGpekgiJYO
        HlOeqDzghf1mi3UpddZD/KpmEzjJPvA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-T1HGFQULMhapsTg7Es6J9g-1; Mon, 23 Mar 2020 08:27:32 -0400
X-MC-Unique: T1HGFQULMhapsTg7Es6J9g-1
Received: by mail-wr1-f72.google.com with SMTP id m15so2875128wrb.0
        for <kvm-ppc@vger.kernel.org>; Mon, 23 Mar 2020 05:27:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=VAG2Qatyfr9ITMHT/x+i3AqePq75ernJyjHorg/4AHo=;
        b=YGTdXFUyI7spHKik0BK+agoxpOl9HV0sfae9tuqWa28hfRGBWwIwlZmadvd8W6Tp1D
         zEJlu8d9k12BG0ImM4KAxaB8Ui6UI1avvat742HJVt3omr6PpvMuS5elXpx8SA/eOf/F
         agc1G4n5QkgPQY1cWGRdH6NtWWmfMCb3CVIpshsQ4RejkWW6xjKKtD9mWKL/mc9i1+yg
         yFbtmCTMr2aPOy2MS5ySm/IBa9b92WtsPvmDe+FbQamZECQFJOKsO1EpQDJu0VXkRCJy
         JBaxoBYovVxcAymEqz+n5fRD7gpKctwf+/LWycvtxeGG9Gb8evdv/r1zu6M1ovhB9vQg
         2TmA==
X-Gm-Message-State: ANhLgQ2Wcdpxnis7v3bYLhE3WnpYgmdc+pp/Aw0dZI5RH0ekxHIghrsj
        GhcxIncU8ryUhX8mBpel6k0XBFkKKG6vRGEhw3DfZeUDqkrIJD7oFFYB0MaMU9BBy/1cA/MJSUc
        f3LGJpg0YzkZykdTtlA==
X-Received: by 2002:a05:600c:10ce:: with SMTP id l14mr12350628wmd.161.1584966451328;
        Mon, 23 Mar 2020 05:27:31 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtaue9eiNEXDxuxd28wMxP3Ylw+xs1AMMjsgqF/l/irHmVdBHDVD/xrHC24aOu9ZbqdIgz1FQ==
X-Received: by 2002:a05:600c:10ce:: with SMTP id l14mr12350596wmd.161.1584966451052;
        Mon, 23 Mar 2020 05:27:31 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id s15sm22694648wrt.16.2020.03.23.05.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 05:27:30 -0700 (PDT)
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
Subject: Re: [PATCH v3 4/9] KVM: VMX: Configure runtime hooks using vmx_x86_ops
In-Reply-To: <20200321202603.19355-5-sean.j.christopherson@intel.com>
References: <20200321202603.19355-1-sean.j.christopherson@intel.com> <20200321202603.19355-5-sean.j.christopherson@intel.com>
Date:   Mon, 23 Mar 2020 13:27:28 +0100
Message-ID: <87ftdz9ryn.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Configure VMX's runtime hooks by modifying vmx_x86_ops directly instead
> of using the global kvm_x86_ops.  This sets the stage for waiting until
> after ->hardware_setup() to set kvm_x86_ops with the vendor's
> implementation.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 15 ++++++++-------
>  arch/x86/kvm/vmx/nested.h |  3 ++-
>  arch/x86/kvm/vmx/vmx.c    | 27 ++++++++++++++-------------
>  3 files changed, 24 insertions(+), 21 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 4ff859c99946..87fea22c3799 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6241,7 +6241,8 @@ void nested_vmx_hardware_unsetup(void)
>  	}
>  }
>  
> -__init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
> +__init int nested_vmx_hardware_setup(struct kvm_x86_ops *ops,
> +				     int (*exit_handlers[])(struct kvm_vcpu *))
>  {
>  	int i;
>  
> @@ -6277,12 +6278,12 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
>  	exit_handlers[EXIT_REASON_INVVPID]	= handle_invvpid;
>  	exit_handlers[EXIT_REASON_VMFUNC]	= handle_vmfunc;
>  
> -	kvm_x86_ops->check_nested_events = vmx_check_nested_events;
> -	kvm_x86_ops->get_nested_state = vmx_get_nested_state;
> -	kvm_x86_ops->set_nested_state = vmx_set_nested_state;
> -	kvm_x86_ops->get_vmcs12_pages = nested_get_vmcs12_pages;
> -	kvm_x86_ops->nested_enable_evmcs = nested_enable_evmcs;
> -	kvm_x86_ops->nested_get_evmcs_version = nested_get_evmcs_version;
> +	ops->check_nested_events = vmx_check_nested_events;
> +	ops->get_nested_state = vmx_get_nested_state;
> +	ops->set_nested_state = vmx_set_nested_state;
> +	ops->get_vmcs12_pages = nested_get_vmcs12_pages;
> +	ops->nested_enable_evmcs = nested_enable_evmcs;
> +	ops->nested_get_evmcs_version = nested_get_evmcs_version;


A lazy guy like me would appreciate 'ops' -> 'vmx_x86_ops' rename as it
would make 'git grep vmx_x86_ops' output more complete.

>  
>  	return 0;
>  }
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index f70968b76d33..ac56aefa49e3 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -19,7 +19,8 @@ enum nvmx_vmentry_status {
>  void vmx_leave_nested(struct kvm_vcpu *vcpu);
>  void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps);
>  void nested_vmx_hardware_unsetup(void);
> -__init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *));
> +__init int nested_vmx_hardware_setup(struct kvm_x86_ops *ops,
> +				     int (*exit_handlers[])(struct kvm_vcpu *));
>  void nested_vmx_set_vmcs_shadowing_bitmap(void);
>  void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu);
>  enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 82dab775d520..cfa9093bdc06 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7860,16 +7860,16 @@ static __init int hardware_setup(void)
>  	 * using the APIC_ACCESS_ADDR VMCS field.
>  	 */
>  	if (!flexpriority_enabled)
> -		kvm_x86_ops->set_apic_access_page_addr = NULL;
> +		vmx_x86_ops.set_apic_access_page_addr = NULL;
>  
>  	if (!cpu_has_vmx_tpr_shadow())
> -		kvm_x86_ops->update_cr8_intercept = NULL;
> +		vmx_x86_ops.update_cr8_intercept = NULL;
>  
>  #if IS_ENABLED(CONFIG_HYPERV)
>  	if (ms_hyperv.nested_features & HV_X64_NESTED_GUEST_MAPPING_FLUSH
>  	    && enable_ept) {
> -		kvm_x86_ops->tlb_remote_flush = hv_remote_flush_tlb;
> -		kvm_x86_ops->tlb_remote_flush_with_range =
> +		vmx_x86_ops.tlb_remote_flush = hv_remote_flush_tlb;
> +		vmx_x86_ops.tlb_remote_flush_with_range =
>  				hv_remote_flush_tlb_with_range;
>  	}
>  #endif
> @@ -7884,7 +7884,7 @@ static __init int hardware_setup(void)
>  
>  	if (!cpu_has_vmx_apicv()) {
>  		enable_apicv = 0;
> -		kvm_x86_ops->sync_pir_to_irr = NULL;
> +		vmx_x86_ops.sync_pir_to_irr = NULL;
>  	}
>  
>  	if (cpu_has_vmx_tsc_scaling()) {
> @@ -7916,10 +7916,10 @@ static __init int hardware_setup(void)
>  		enable_pml = 0;
>  
>  	if (!enable_pml) {
> -		kvm_x86_ops->slot_enable_log_dirty = NULL;
> -		kvm_x86_ops->slot_disable_log_dirty = NULL;
> -		kvm_x86_ops->flush_log_dirty = NULL;
> -		kvm_x86_ops->enable_log_dirty_pt_masked = NULL;
> +		vmx_x86_ops.slot_enable_log_dirty = NULL;
> +		vmx_x86_ops.slot_disable_log_dirty = NULL;
> +		vmx_x86_ops.flush_log_dirty = NULL;
> +		vmx_x86_ops.enable_log_dirty_pt_masked = NULL;
>  	}
>  
>  	if (!cpu_has_vmx_preemption_timer())
> @@ -7947,9 +7947,9 @@ static __init int hardware_setup(void)
>  	}
>  
>  	if (!enable_preemption_timer) {
> -		kvm_x86_ops->set_hv_timer = NULL;
> -		kvm_x86_ops->cancel_hv_timer = NULL;
> -		kvm_x86_ops->request_immediate_exit = __kvm_request_immediate_exit;
> +		vmx_x86_ops.set_hv_timer = NULL;
> +		vmx_x86_ops.cancel_hv_timer = NULL;
> +		vmx_x86_ops.request_immediate_exit = __kvm_request_immediate_exit;
>  	}
>  
>  	kvm_set_posted_intr_wakeup_handler(wakeup_handler);
> @@ -7965,7 +7965,8 @@ static __init int hardware_setup(void)
>  		nested_vmx_setup_ctls_msrs(&vmcs_config.nested,
>  					   vmx_capability.ept);
>  
> -		r = nested_vmx_hardware_setup(kvm_vmx_exit_handlers);
> +		r = nested_vmx_hardware_setup(&vmx_x86_ops,
> +					      kvm_vmx_exit_handlers);
>  		if (r)
>  			return r;
>  	}

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

