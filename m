Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39DF412A3DF
	for <lists+kvm-ppc@lfdr.de>; Tue, 24 Dec 2019 19:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfLXSTk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 24 Dec 2019 13:19:40 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38396 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726884AbfLXSTj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 24 Dec 2019 13:19:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577211578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=10oE3mcJxbSPeGAikLZZiyP7ObdJq49Q5FPmOfsO/dc=;
        b=aAp8oornNJKCeC365VZGhdHOtsI9KvAvK65jRS7YAtrDwlwHq2glNMTmdhz0qPLGz/kSd0
        x2OB/a2nNzqZPigMjQqnnoOMne6NrcnCnz9mfPwwF/vPmwAmNdFisMmyjQtfe5KoaPOY3o
        a9fun/Tnt91+f4L2PDp4kpyOsUQ60gw=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-85fsRemHMFaMTxA9dGldDA-1; Tue, 24 Dec 2019 13:19:37 -0500
X-MC-Unique: 85fsRemHMFaMTxA9dGldDA-1
Received: by mail-qk1-f198.google.com with SMTP id d1so6324995qkk.15
        for <kvm-ppc@vger.kernel.org>; Tue, 24 Dec 2019 10:19:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=10oE3mcJxbSPeGAikLZZiyP7ObdJq49Q5FPmOfsO/dc=;
        b=DhcIAHo89WWMHZgpWsuJ3hvKnVnX+PU+ZbrDAymm4ifdodvjmyc0SjjS5+4pI6IpM7
         t02ib+pu18hlCqLMCfqZnu6wm4gWLNjgTpoJPrW5iSM5rg5sZxMRf0yZ3JbPcQ9b+vue
         NeqkppSAAXurkd6FZn0J+8DpbdM2dGimIbhP8zzoqKWZl3K+bhvAeh4FtCose+tByq+y
         YBKDOaSF58okXEXGxoGYwa82yBD+nRyvXKnb/8ICG6tKcD072sN1ez4CxncXy7GM6D9H
         AOGAxwCroZLxQl4sVKp3MdNjC59IB/PVtcCHjNdEtIfcvxh4DbCPTZBFflX2eGX5Ed2P
         g3Sw==
X-Gm-Message-State: APjAAAVrXVnGBpKwHe/wh+OBUc9fOMWpANBS7bCfCIEAamwTOSE6tMcA
        SJzUNE5PNzJtRfnWqHAhRi73/ovk+oiNyGYL2i+FsrKRZjXQga6T5nokHUtMVgvOht5Uv8bmox2
        RbdRjtONOfWFvrbVZDw==
X-Received: by 2002:a37:de16:: with SMTP id h22mr32000508qkj.400.1577211573642;
        Tue, 24 Dec 2019 10:19:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqyPlDOvamAwfkQQCQ/yrbEZ/IdA8BxSZxEa3M38XxUFXj9DeSRjaR1EpPHTj42i4TNzDYXwVw==
X-Received: by 2002:a37:de16:: with SMTP id h22mr32000473qkj.400.1577211573294;
        Tue, 24 Dec 2019 10:19:33 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c0:3f::2])
        by smtp.gmail.com with ESMTPSA id 63sm7087025qki.57.2019.12.24.10.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2019 10:19:32 -0800 (PST)
Date:   Tue, 24 Dec 2019 13:19:30 -0500
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
Subject: Re: [PATCH v4 16/19] KVM: Ensure validity of memslot with respect to
 kvm_get_dirty_log()
Message-ID: <20191224181930.GC17176@xz-x1>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-17-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191217204041.10815-17-sean.j.christopherson@intel.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Dec 17, 2019 at 12:40:38PM -0800, Sean Christopherson wrote:
> +int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
> +		      int *is_dirty, struct kvm_memory_slot **memslot)
>  {
>  	struct kvm_memslots *slots;
> -	struct kvm_memory_slot *memslot;
>  	int i, as_id, id;
>  	unsigned long n;
>  	unsigned long any = 0;
>  
> +	*memslot = NULL;
> +	*is_dirty = 0;
> +
>  	as_id = log->slot >> 16;
>  	id = (u16)log->slot;
>  	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
>  		return -EINVAL;
>  
>  	slots = __kvm_memslots(kvm, as_id);
> -	memslot = id_to_memslot(slots, id);
> -	if (!memslot->dirty_bitmap)
> +	*memslot = id_to_memslot(slots, id);
> +	if (!(*memslot)->dirty_bitmap)
>  		return -ENOENT;
>  
> -	n = kvm_dirty_bitmap_bytes(memslot);
> +	kvm_arch_sync_dirty_log(kvm, *memslot);

Should this line belong to previous patch?

> +
> +	n = kvm_dirty_bitmap_bytes(*memslot);
>  
>  	for (i = 0; !any && i < n/sizeof(long); ++i)
> -		any = memslot->dirty_bitmap[i];
> +		any = (*memslot)->dirty_bitmap[i];
>  
> -	if (copy_to_user(log->dirty_bitmap, memslot->dirty_bitmap, n))
> +	if (copy_to_user(log->dirty_bitmap, (*memslot)->dirty_bitmap, n))
>  		return -EFAULT;
>  
>  	if (any)
> -- 
> 2.24.1

-- 
Peter Xu

