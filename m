Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 510CD154913
	for <lists+kvm-ppc@lfdr.de>; Thu,  6 Feb 2020 17:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbgBFQ00 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 6 Feb 2020 11:26:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31122 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727720AbgBFQ0Z (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 6 Feb 2020 11:26:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581006384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QT4Dyzc7mqGctXHju0bs7rAU06NGyt0QOqamAxfKKT8=;
        b=MAXT8hxnWx+KNoHHj25RYQBCRQBIR+hB98dc0G1qPIzOd9WCfqypmMGTJdjmzbimNa7FIP
        z/DCLzOQy6WlSE4zsmNABHVJ0JQPMWg0sr2Z2mORRSMO10kaKINJ59UY8Zhw5wrGmFOifN
        tyeSroZvUSZYoWqww1cWAxOp6iL6ODU=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-xnLipChsNsyxU-iRooazeA-1; Thu, 06 Feb 2020 11:26:21 -0500
X-MC-Unique: xnLipChsNsyxU-iRooazeA-1
Received: by mail-qk1-f198.google.com with SMTP id a132so3948740qkg.5
        for <kvm-ppc@vger.kernel.org>; Thu, 06 Feb 2020 08:26:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=QT4Dyzc7mqGctXHju0bs7rAU06NGyt0QOqamAxfKKT8=;
        b=niCFNWinF8Jy/+ZUODz9P/M/AZGZjd1xpw5+wouwkoHtj6JpCZciNEV530yqBsE2id
         poKLYcnvPkXt8xYkWsPm6GNMpFo9dOFtRn6/NFEKinLTPz9qqSpMiHKAclJor9c/kl+B
         uE7KVa4A+WE0+5Qn+ATRDFrA4AS0AjnR/HfxthllbKHqXtC4oGI9iD9AYn2WeHDd8Yvm
         Ib9IUuDf7jSZHkX8qLMSeaf/k3zTiMNSATCOGRkNoBcKLHNE5a/ghY0/JKmCohcnpKUY
         bqKUaFDInkxOAAbWwwNM+uRxu1v06aBgORGEPY/SQLTqjFKa4UfjUcDM6Updd9yRzgPH
         WG1w==
X-Gm-Message-State: APjAAAURfY5sv4mq5XSGJlxe5vJo01d9gvdo0zz6W/bJLAYg3Q0bowaf
        ThxjGqvEZ/9iNbeZpTyGdWHo8zPxV0Ph9f3V26dmXpswiV5vicQB0jcZAxnGAvRX7OmqNlJCUyE
        o5/pW441/ltghAOwuew==
X-Received: by 2002:a37:7b43:: with SMTP id w64mr3282139qkc.203.1581006381182;
        Thu, 06 Feb 2020 08:26:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqx+9hqm72d72EyKnRwyP/P3+idsr/CwBkH5EeXl92Z4n7jMR0A/IUI51rmKg9nIiuqPw/V2og==
X-Received: by 2002:a37:7b43:: with SMTP id w64mr3282106qkc.203.1581006380845;
        Thu, 06 Feb 2020 08:26:20 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id g77sm1629814qke.129.2020.02.06.08.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 08:26:20 -0800 (PST)
Date:   Thu, 6 Feb 2020 11:26:17 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: Re: [PATCH v5 09/19] KVM: Move setting of memslot into helper routine
Message-ID: <20200206162617.GB695333@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-10-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200121223157.15263-10-sean.j.christopherson@intel.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Jan 21, 2020 at 02:31:47PM -0800, Sean Christopherson wrote:
> Split out the core functionality of setting a memslot into a separate
> helper in preparation for moving memslot deletion into its own routine.
> 
> Tested-by: Christoffer Dall <christoffer.dall@arm.com>
> Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  virt/kvm/kvm_main.c | 106 ++++++++++++++++++++++++++------------------
>  1 file changed, 63 insertions(+), 43 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fdf045a5d240..64f6c5d35260 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -982,6 +982,66 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
>  	return old_memslots;
>  }
>  
> +static int kvm_set_memslot(struct kvm *kvm,
> +			   const struct kvm_userspace_memory_region *mem,
> +			   const struct kvm_memory_slot *old,
> +			   struct kvm_memory_slot *new, int as_id,
> +			   enum kvm_mr_change change)
> +{
> +	struct kvm_memory_slot *slot;
> +	struct kvm_memslots *slots;
> +	int r;
> +
> +	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
> +	if (!slots)
> +		return -ENOMEM;
> +	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots));
> +
> +	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
> +		/*
> +		 * Note, the INVALID flag needs to be in the appropriate entry
> +		 * in the freshly allocated memslots, not in @old or @new.
> +		 */
> +		slot = id_to_memslot(slots, old->id);
> +		slot->flags |= KVM_MEMSLOT_INVALID;
> +
> +		/*
> +		 * We can re-use the old memslots, the only difference from the
> +		 * newly installed memslots is the invalid flag, which will get
> +		 * dropped by update_memslots anyway.  We'll also revert to the
> +		 * old memslots if preparing the new memory region fails.
> +		 */
> +		slots = install_new_memslots(kvm, as_id, slots);
> +
> +		/* From this point no new shadow pages pointing to a deleted,
> +		 * or moved, memslot will be created.
> +		 *
> +		 * validation of sp->gfn happens in:
> +		 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
> +		 *	- kvm_is_visible_gfn (mmu_check_root)
> +		 */
> +		kvm_arch_flush_shadow_memslot(kvm, slot);
> +	}
> +
> +	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
> +	if (r)
> +		goto out_slots;
> +
> +	update_memslots(slots, new, change);
> +	slots = install_new_memslots(kvm, as_id, slots);
> +
> +	kvm_arch_commit_memory_region(kvm, mem, old, new, change);
> +
> +	kvfree(slots);
> +	return 0;
> +
> +out_slots:
> +	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
> +		slots = install_new_memslots(kvm, as_id, slots);
> +	kvfree(slots);
> +	return r;
> +}
> +
>  /*
>   * Allocate some memory and give it an address in the guest physical address
>   * space.
> @@ -998,7 +1058,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  	unsigned long npages;
>  	struct kvm_memory_slot *slot;
>  	struct kvm_memory_slot old, new;
> -	struct kvm_memslots *slots;
>  	int as_id, id;
>  	enum kvm_mr_change change;
>  
> @@ -1085,58 +1144,19 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  			return r;
>  	}
>  
> -	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
> -	if (!slots) {
> -		r = -ENOMEM;
> -		goto out_bitmap;
> -	}
> -	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots));
> -
> -	if ((change == KVM_MR_DELETE) || (change == KVM_MR_MOVE)) {
> -		slot = id_to_memslot(slots, id);
> -		slot->flags |= KVM_MEMSLOT_INVALID;
> -
> -		/*
> -		 * We can re-use the old memslots, the only difference from the
> -		 * newly installed memslots is the invalid flag, which will get
> -		 * dropped by update_memslots anyway.  We'll also revert to the
> -		 * old memslots if preparing the new memory region fails.
> -		 */
> -		slots = install_new_memslots(kvm, as_id, slots);
> -
> -		/* From this point no new shadow pages pointing to a deleted,
> -		 * or moved, memslot will be created.
> -		 *
> -		 * validation of sp->gfn happens in:
> -		 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
> -		 *	- kvm_is_visible_gfn (mmu_check_root)
> -		 */
> -		kvm_arch_flush_shadow_memslot(kvm, slot);
> -	}
> -
> -	r = kvm_arch_prepare_memory_region(kvm, &new, mem, change);
> -	if (r)
> -		goto out_slots;
> -
>  	/* actual memory is freed via old in kvm_free_memslot below */
>  	if (change == KVM_MR_DELETE) {
>  		new.dirty_bitmap = NULL;
>  		memset(&new.arch, 0, sizeof(new.arch));
>  	}

It's not extremely clear to me on why this single block is leftover
here instead of putting into kvm_set_memslot().  I see that after all
it'll be removed in patch 12, so it seems OK:

Reviewed-by: Peter Xu <peterx@redhat.com>

>  
> -	update_memslots(slots, &new, change);
> -	slots = install_new_memslots(kvm, as_id, slots);
> -
> -	kvm_arch_commit_memory_region(kvm, mem, &old, &new, change);
> +	r = kvm_set_memslot(kvm, mem, &old, &new, as_id, change);
> +	if (r)
> +		goto out_bitmap;
>  
>  	kvm_free_memslot(kvm, &old, &new);
> -	kvfree(slots);
>  	return 0;
>  
> -out_slots:
> -	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
> -		slots = install_new_memslots(kvm, as_id, slots);
> -	kvfree(slots);
>  out_bitmap:
>  	if (new.dirty_bitmap && !old.dirty_bitmap)
>  		kvm_destroy_dirty_bitmap(&new);
> -- 
> 2.24.1
> 

-- 
Peter Xu

