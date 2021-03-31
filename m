Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198CD34FBB9
	for <lists+kvm-ppc@lfdr.de>; Wed, 31 Mar 2021 10:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhCaIgH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 31 Mar 2021 04:36:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52032 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232301AbhCaIfl (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 31 Mar 2021 04:35:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617179740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mgm8G5pUG1KmGb3in7+y2xmYF44JOnlI4lr2O/Z99Vg=;
        b=H8sUHIZGKT09uO2730bAmBZBHmp4NxN8aS6UmkHDK8fLmH0NnKty2Zbi5rbX4VdOdapDAu
        J7roS4DFnLnzGKel+jGmOCs4dVlUxFVSPqnoKWdvSVIRarmotwEFpvjaL5MV4WLFB03Q7/
        2w9O/SbsOwoFAFGOMtYxmwsfVj7jaT4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-EL6VbxY5Psy_MvqGc3hIXA-1; Wed, 31 Mar 2021 04:35:38 -0400
X-MC-Unique: EL6VbxY5Psy_MvqGc3hIXA-1
Received: by mail-wr1-f72.google.com with SMTP id t14so615269wrx.12
        for <kvm-ppc@vger.kernel.org>; Wed, 31 Mar 2021 01:35:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mgm8G5pUG1KmGb3in7+y2xmYF44JOnlI4lr2O/Z99Vg=;
        b=dLvfzd4UMi5kC6CQLtzxKeGJBADpalJuwsZEQZ2bHn8afgxh70pxuVWuXMLEbTcEfx
         QBDEPY3XyVZHixjzgaA/p/54WGkH53EvpIucIcfAx6F/+FclaIxX3XHVgINN25W8YMjU
         vDDRngDPusYSEPHTQHzqA5IldDKChy1rs/j0+Z1JWPe8YPDyd2Rmvb50bwF0wIMptSa2
         Rr1uF7V6kUuZiK2e1r4vloXR9RkrMU90LFs1ZqhXoZgQd9Alz4uVSQtsYovi0IyULnTd
         bvk4iueV5blrdhcvUnt2FMwNjlIrANu745ttO4P/NI4lbtU5jWkKZeTAoDtuQeyatRpF
         UeBw==
X-Gm-Message-State: AOAM530VncRsGaEauwcvogp//C8iAaYQlZh0fK1ObQceo/PT+KTaPxtN
        2r14CmdMRLAipJYlrQN4oOtaBSrTbyXqhxKC9dytI0WjlBaiUB3hmi7e0bTD5unL1V9nXFQl2eN
        XV7BSMhwD3Cu7cHezYQ==
X-Received: by 2002:a1c:7fcd:: with SMTP id a196mr2104262wmd.180.1617179736952;
        Wed, 31 Mar 2021 01:35:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFY4ad6E8SOin2Ll1yPB6Awyjzypf4VdxfkeKjct1tO9FsxKkluxu1V8FPsoliR6ISHwqUjA==
X-Received: by 2002:a1c:7fcd:: with SMTP id a196mr2104245wmd.180.1617179736699;
        Wed, 31 Mar 2021 01:35:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id a17sm2690084wmj.9.2021.03.31.01.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 01:35:35 -0700 (PDT)
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
 <20210326021957.1424875-17-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
Date:   Wed, 31 Mar 2021 10:35:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210326021957.1424875-17-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 26/03/21 03:19, Sean Christopherson wrote:
> +	/*
> +	 * Reset the lock used to prevent memslot updates between MMU notifier
> +	 * range_start and range_end.  At this point no more MMU notifiers will
> +	 * run, but the lock could still be held if KVM's notifier was removed
> +	 * between range_start and range_end.  No threads can be waiting on the
> +	 * lock as the last reference on KVM has been dropped.  If the lock is
> +	 * still held, freeing memslots will deadlock.
> +	 */
> +	init_rwsem(&kvm->mmu_notifier_slots_lock);

I was going to say that this is nasty, then I noticed that 
mmu_notifier_unregister uses SRCU to ensure completion of concurrent 
calls to the MMU notifier.  So I guess it's fine, but it's better to 
point it out:

	/*
	 * At this point no more MMU notifiers will run and pending
	 * calls to range_start have completed, but the lock would
	 * still be held and never released if the MMU notifier was
	 * removed between range_start and range_end.  Since the last
	 * reference to the struct kvm has been dropped, no threads can
	 * be waiting on the lock, but we might still end up taking it
	 * when freeing memslots in kvm_arch_destroy_vm.  Reset the lock
	 * to avoid deadlocks.
	 */

That said, the easiest way to avoid this would be to always update 
mmu_notifier_count.  I don't mind the rwsem, but at least I suggest that 
you split the patch in two---the first one keeping the 
mmu_notifier_count update unconditional, and the second one introducing 
the rwsem and the on_lock function kvm_inc_notifier_count.  Please 
document the new lock in Documentation/virt/kvm/locking.rst too.

Also, related to the first part of the series, perhaps you could 
structure the series in a slightly different way:

1) introduce the HVA walking API in common code, complete with on_lock 
and patch 15, so that you can use on_lock to increase mmu_notifier_seq

2) then migrate all architectures including x86 to the new API

IOW, first half of patch 10 and all of patch 15; then the second half of 
patch 10; then patches 11-14.

> +#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
> +	down_write(&kvm->mmu_notifier_slots_lock);
> +#endif
>  	rcu_assign_pointer(kvm->memslots[as_id], slots);
> +#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
> +	up_write(&kvm->mmu_notifier_slots_lock);
> +#endif

Please do this unconditionally, the cost is minimal if the rwsem is not 
contended (as is the case if the architecture doesn't use MMU notifiers 
at all).

Paolo

