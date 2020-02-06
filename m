Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 011DD1549AF
	for <lists+kvm-ppc@lfdr.de>; Thu,  6 Feb 2020 17:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgBFQv2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 6 Feb 2020 11:51:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54965 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727684AbgBFQv1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 6 Feb 2020 11:51:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581007886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6wEZC2xS1ICrNAGJ+8QI1N9zsFW9IzwC/0IJCgjt8nk=;
        b=gaaCIzUwm6c6ZdkYvtuk98nQ1d6ZjmA8g+y4IC2Iq7LXgRtzn4xbYJL/IZexI6wzVeQcn3
        +i3RVY2U8JX+K6BFBYum9bmGzHfWRXbgEOSHfPC2DCDaLUP+whV91vs64p3i8SZ18AI0C6
        /rxUHxAFfVdI3+/6FyvR5Mm3jS7NmrE=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-lgSax7P6PaqfD2_tUJjxFw-1; Thu, 06 Feb 2020 11:51:21 -0500
X-MC-Unique: lgSax7P6PaqfD2_tUJjxFw-1
Received: by mail-qt1-f200.google.com with SMTP id l25so4262700qtu.0
        for <kvm-ppc@vger.kernel.org>; Thu, 06 Feb 2020 08:51:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6wEZC2xS1ICrNAGJ+8QI1N9zsFW9IzwC/0IJCgjt8nk=;
        b=CO6Ra3PKMOwYHuNnN66qKIiWu41slGwBx4l39O2hRlQzk6rLsVAzYZ2X1JjjJzUh0e
         j9yIwZ0wyz0D9rfkKDViU64rWjLhxufIjvalV1msNq/KPtH8wy+kjNSr5hBqMqG3kYl/
         r6RDsjnETwDBi8NZRzJ5xeVklCDOvRTPhEg37UeMPeC5sY+utZrIUbKRNjeX9QVU2pe4
         2hIdhaF78eS+vgHsvtMiY2FIvzjF9hXVU+G30cx99FNrwEbu3z20x3Ul/RJx0WhDjrrk
         8HIfrkwC/ZsaalA+7a/Q8ZUNtsBwmrdE/pbxa16GSs7NUH6Pn4OjPsdoaHd4HH/xroBp
         60IQ==
X-Gm-Message-State: APjAAAXcEifp89o9Ne5usMeEPcu5qgbh5cNjADcz1E48zWLpTpETkK2v
        H+X+3zzwTYpjlr4lNrbGH/B8NnWupx4uInHMDHK41/rpKVsmSLIlocsaAMHXED9kWkz5ttvsdzv
        Jzu9Fd57i1L8wPFq5ww==
X-Received: by 2002:a0c:ed22:: with SMTP id u2mr3142535qvq.13.1581007880666;
        Thu, 06 Feb 2020 08:51:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqx/jX2RKvHGf3JDTGGU+D3o2LP4p21Bk3Kl7+mbxJpFhXmYhA374b5M6RMOGMp7RFtjxv6e0g==
X-Received: by 2002:a0c:ed22:: with SMTP id u2mr3142516qvq.13.1581007880314;
        Thu, 06 Feb 2020 08:51:20 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id v10sm1058913qtj.26.2020.02.06.08.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 08:51:19 -0800 (PST)
Date:   Thu, 6 Feb 2020 11:51:16 -0500
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
Subject: Re: [PATCH v5 12/19] KVM: Move memslot deletion to helper function
Message-ID: <20200206165116.GE695333@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-13-sean.j.christopherson@intel.com>
 <20200206161415.GA695333@xz-x1>
 <20200206162818.GD13067@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200206162818.GD13067@linux.intel.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Feb 06, 2020 at 08:28:18AM -0800, Sean Christopherson wrote:
> On Thu, Feb 06, 2020 at 11:14:15AM -0500, Peter Xu wrote:
> > On Tue, Jan 21, 2020 at 02:31:50PM -0800, Sean Christopherson wrote:
> > > Move memslot deletion into its own routine so that the success path for
> > > other memslot updates does not need to use kvm_free_memslot(), i.e. can
> > > explicitly destroy the dirty bitmap when necessary.  This paves the way
> > > for dropping @dont from kvm_free_memslot(), i.e. all callers now pass
> > > NULL for @dont.
> > > 
> > > Add a comment above the code to make a copy of the existing memslot
> > > prior to deletion, it is not at all obvious that the pointer will become
> > > stale during sorting and/or installation of new memslots.
> > 
> > Could you help explain a bit on this explicit comment?  I can follow
> > up with the patch itself which looks all correct to me, but I failed
> > to catch what this extra comment wants to emphasize...
> 
> It's tempting to write the code like this (I know, because I did it):
> 
> 	if (!mem->memory_size)
> 		return kvm_delete_memslot(kvm, mem, slot, as_id);
> 
> 	new = *slot;
> 
> Where @slot is a pointer to the memslot to be deleted.  At first, second,
> and third glances, this seems perfectly sane.
> 
> The issue is that slot was pulled from struct kvm_memslots.memslots, e.g.
> 
> 	slot = &slots->memslots[index];
> 
> Note that slots->memslots holds actual "struct kvm_memory_slot" objects,
> not pointers to slots.  When update_memslots() sorts the slots, it swaps
> the actual slot objects, not pointers.  I.e. after update_memslots(), even
> though @slot points at the same address, it's could be pointing at a
> different slot.  As a result kvm_free_memslot() in kvm_delete_memslot()
> will free the dirty page info and arch-specific points for some random
> slot, not the intended slot, and will set npages=0 for that random slot.

Ah I see, thanks.  Another alternative is we move the "old = *slot"
copy into kvm_delete_memslot(), which could be even clearer imo.
However I'm not sure whether it's a good idea to drop the test-by for
this.  Considering that comment change should not affect it, would you
mind enrich the comment into something like this (or anything better)?

/*
 * Make a full copy of the old memslot, the pointer will become stale
 * when the memslots are re-sorted by update_memslots() in
 * kvm_delete_memslot(), while to make the kvm_free_memslot() work as
 * expected later on, we still need the cached memory slot.
 */

In all cases:

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

