Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 290A41239EC
	for <lists+kvm-ppc@lfdr.de>; Tue, 17 Dec 2019 23:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfLQWYv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 17 Dec 2019 17:24:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30374 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725946AbfLQWYv (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 17 Dec 2019 17:24:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576621490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n1zc/BAvLiuzmjBuBeyM8c5OGj4eP3sDEL7oyAZ0h/8=;
        b=X19A+Vjvdkn65pCiqPmgpKJiMdivoequi0ELkOFXT4Yvhn804d+BZlRPPWgKmY+sjtxFag
        HobsGik7ynP/7VV2i4oW2kKE0afZKZQ3VRISes3vySDq4NpmKX5ABLlh9XSURJZg7x6PMY
        UuOkwkXhKpCKYeU0jDn+e2lX6ysomVg=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-05aW5WYFN1y3OfoAnIvEYw-1; Tue, 17 Dec 2019 17:24:49 -0500
X-MC-Unique: 05aW5WYFN1y3OfoAnIvEYw-1
Received: by mail-qk1-f200.google.com with SMTP id 12so4352qkf.20
        for <kvm-ppc@vger.kernel.org>; Tue, 17 Dec 2019 14:24:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=n1zc/BAvLiuzmjBuBeyM8c5OGj4eP3sDEL7oyAZ0h/8=;
        b=flY1+/9KYS2lfXahBrk5mq7Z2CWbjVJ+9OM28tllT27qcbjXppNO08MXrvtyPMJN5B
         DVxdJfb8pQ9bw7X71v938DZClAk+HP3zsBzG/jexbgwVV6iWhNhQroeR+hjK35j8gZ3v
         3vFuWj13s9LdJGSESVim9qli724ooEU2DCphlLtlpHTQFHvKNAMIvGZBvmvxxagAI0Xp
         fp1nfDT5S7Ih0Joqt7lLMogDrAoL34mYlSGN11Y7xlWMSIj0iDx6qX/mAQEmNB/MX+vk
         c0SrHwzvEfyeDnyrN8wHLMMJoREBWe+8Zz6yyjv9bhbbzCYrQYA7iwbcGvFEiiRjICnf
         Vzxw==
X-Gm-Message-State: APjAAAWrPenExeD6ibee4E4f8/NCVfk4CzCHNMC1oajIcmyZMsYZxh8X
        3odFtxg+YYfEN1MphcLDzJC+uhBJwY25Nt5EF8D7sfmX5Mry343Ef/mRoRnoUgRG3FUg/DcBajT
        DIP4IZgJsoXqqYS8G6g==
X-Received: by 2002:ac8:3177:: with SMTP id h52mr248062qtb.264.1576621488939;
        Tue, 17 Dec 2019 14:24:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqxa9aGwr5mHm2Cm0VxXNZlZXqTAo8dq2kd9eCG/gVR+l9nUybMoSUNtPMwlIhbLMlDgqBEiTQ==
X-Received: by 2002:ac8:3177:: with SMTP id h52mr248020qtb.264.1576621488653;
        Tue, 17 Dec 2019 14:24:48 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id c84sm7565689qkg.78.2019.12.17.14.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:24:47 -0800 (PST)
Date:   Tue, 17 Dec 2019 17:24:46 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v4 07/19] KVM: Explicitly free allocated-but-unused dirty
 bitmap
Message-ID: <20191217222446.GK7258@xz-x1>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-8-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191217204041.10815-8-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Dec 17, 2019 at 12:40:29PM -0800, Sean Christopherson wrote:
> Explicitly free an allocated-but-unused dirty bitmap instead of relying
> on kvm_free_memslot() if an error occurs in __kvm_set_memory_region().
> There is no longer a need to abuse kvm_free_memslot() to free arch
> specific resources as arch specific code is now called only after the
> common flow is guaranteed to succeed.  Arch code can still fail, but
> it's responsible for its own cleanup in that case.
> 
> Eliminating the error path's abuse of kvm_free_memslot() paves the way
> for simplifying kvm_free_memslot(), i.e. dropping its @dont param.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  virt/kvm/kvm_main.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d403e93e3028..6b2261a9e139 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1096,7 +1096,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  
>  	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
>  	if (!slots)
> -		goto out_free;
> +		goto out_bitmap;
>  	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots));
>  
>  	if ((change == KVM_MR_DELETE) || (change == KVM_MR_MOVE)) {
> @@ -1144,8 +1144,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
>  		slots = install_new_memslots(kvm, as_id, slots);
>  	kvfree(slots);
> -out_free:
> -	kvm_free_memslot(kvm, &new, &old);
> +out_bitmap:
> +	if (new.dirty_bitmap && !old.dirty_bitmap)
> +		kvm_destroy_dirty_bitmap(&new);

What if both the old and new have KVM_MEM_LOG_DIRTY_PAGES set?
kvm_free_memslot() did cover that but I see that you explicitly
dropped it.  Could I ask why?  Thanks,

-- 
Peter Xu

