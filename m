Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2FA7154E88
	for <lists+kvm-ppc@lfdr.de>; Thu,  6 Feb 2020 23:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbgBFWEE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 6 Feb 2020 17:04:04 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50444 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727443AbgBFWED (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 6 Feb 2020 17:04:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581026642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dz1uoo006UjtoREFQWYnwIS83IIptUYIWImaDlSbYB4=;
        b=OtZPbKzWNEiYGadDkglDvcdNtFQxrhshx2oc0i0bxXjY8QKGwYnbiHdWWkrrA/T7FbDFu3
        P/KechaVpvoGdoebPJ+OV6BmOWSYh0HgDiZrKYC++m2f4Pi/KLAbmAz3CjjvCIYVAkw4xX
        K2clHPYio2kYsaSvkATq2yu126uf9C0=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-zPNa7TiDPH2kLciI9FCDxw-1; Thu, 06 Feb 2020 17:03:59 -0500
X-MC-Unique: zPNa7TiDPH2kLciI9FCDxw-1
Received: by mail-qt1-f198.google.com with SMTP id b5so221612qtt.10
        for <kvm-ppc@vger.kernel.org>; Thu, 06 Feb 2020 14:03:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dz1uoo006UjtoREFQWYnwIS83IIptUYIWImaDlSbYB4=;
        b=HEdN3xiMGSrpTPoeWQL+Mr9DjxMpwOAqIEbcS4HEYhUMtSNXL+xyxQfHySRthawAjN
         LaFJNnKIYuqa9jQ/utjYL43aYfJWUkboagQTou+Zux+DiHDDRKWK2YtWIrJdzclCCTt8
         imLWH/4YODXyukwDAfSykjhdN1HBhJm+ock8+z+RpLqy/lU5mBbfmIYEuU5WxXtIWgRy
         hwfW35P+XXRnThvwPzrQo+V70uj8Md+mmb3tIs+i2yIJ4ruCxCBgAnNeBC+PEWwZpYuz
         C2Ta7NYc72dMqyvQ9T5aHAog/XSa4ogwTBrC/rGVeX/5IBRHdirK/Qar7VWF6K5Fauh1
         BeuA==
X-Gm-Message-State: APjAAAV5litZo7CoVK4mXZ5zt0SOC25B1TJFw36sO8Ccki/g770vPDIf
        e5/i0tMyXGsr6YcGMUBJNOVbSU12z1+uxN3AYjbsog5MdWrkzT2LK+T2ne6K7iNLy8EUAFK2ixR
        L8eAtf66j683wgEoeIA==
X-Received: by 2002:ac8:7396:: with SMTP id t22mr4707012qtp.269.1581026639168;
        Thu, 06 Feb 2020 14:03:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqwu2LJdikIjEQUWHwIaSDYrGQrBVVncwkTn7Iy+PzbVsPREs+ohxiEeOt5zr/YlX26hX6iftw==
X-Received: by 2002:ac8:7396:: with SMTP id t22mr4706974qtp.269.1581026638877;
        Thu, 06 Feb 2020 14:03:58 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id i7sm312515qki.83.2020.02.06.14.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 14:03:58 -0800 (PST)
Date:   Thu, 6 Feb 2020 17:03:55 -0500
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
Message-ID: <20200206220355.GH700495@xz-x1>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-17-sean.j.christopherson@intel.com>
 <20191224181930.GC17176@xz-x1>
 <20200114182506.GF16784@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200114182506.GF16784@linux.intel.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Jan 14, 2020 at 10:25:07AM -0800, Sean Christopherson wrote:
> On Tue, Dec 24, 2019 at 01:19:30PM -0500, Peter Xu wrote:
> > On Tue, Dec 17, 2019 at 12:40:38PM -0800, Sean Christopherson wrote:
> > > +int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
> > > +		      int *is_dirty, struct kvm_memory_slot **memslot)
> > >  {
> > >  	struct kvm_memslots *slots;
> > > -	struct kvm_memory_slot *memslot;
> > >  	int i, as_id, id;
> > >  	unsigned long n;
> > >  	unsigned long any = 0;
> > >  
> > > +	*memslot = NULL;
> > > +	*is_dirty = 0;
> > > +
> > >  	as_id = log->slot >> 16;
> > >  	id = (u16)log->slot;
> > >  	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
> > >  		return -EINVAL;
> > >  
> > >  	slots = __kvm_memslots(kvm, as_id);
> > > -	memslot = id_to_memslot(slots, id);
> > > -	if (!memslot->dirty_bitmap)
> > > +	*memslot = id_to_memslot(slots, id);
> > > +	if (!(*memslot)->dirty_bitmap)
> > >  		return -ENOENT;
> > >  
> > > -	n = kvm_dirty_bitmap_bytes(memslot);
> > > +	kvm_arch_sync_dirty_log(kvm, *memslot);
> > 
> > Should this line belong to previous patch?
> 
> No.
> 
> The previous patch, "KVM: Provide common implementation for generic dirty
> log functions", is consolidating the implementation of dirty log functions
> for architectures with CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y.
> 
> This code is being moved from s390's kvm_vm_ioctl_get_dirty_log(), as s390
> doesn't select KVM_GENERIC_DIRTYLOG_READ_PROTECT.  It's functionally a nop
> as kvm_arch_sync_dirty_log() is empty for PowerPC, the only other arch that
> doesn't select KVM_GENERIC_DIRTYLOG_READ_PROTECT.
> 
> Arguably, the call to kvm_arch_sync_dirty_log() should be moved in a
> separate prep patch.  It can't be a follow-on patch as that would swap the
> ordering of kvm_arch_sync_dirty_log() and kvm_dirty_bitmap_bytes(), etc...
> 
> My reasoning for not splitting it to a separate patch is that prior to this
> patch, the common code and arch specific code are doing separate memslot
> lookups via id_to_memslot(), i.e. moving the kvm_arch_sync_dirty_log() call
> would operate on a "different" memslot.   It can't actually be a different
> memslot because slots_lock is held, it just felt weird.
> 
> All that being said, I don't have a strong opinion on moving the call to
> kvm_arch_sync_dirty_log() in a separate patch; IIRC, I vascillated between
> the two options when writing the code.  If anyone wants it to be a separate
> patch I'll happily split it out.

(Sorry to respond so late)

I think the confusing part is the subject, where you only mentioned
the memslot change.  IMHO you can split the change to make it clearer,
or at least would you mind mention that kvm_arch_sync_dirty_log() move
in the commit message?  Thanks,

-- 
Peter Xu

