Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72C46154E32
	for <lists+kvm-ppc@lfdr.de>; Thu,  6 Feb 2020 22:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgBFVlV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 6 Feb 2020 16:41:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53097 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727456AbgBFVlP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 6 Feb 2020 16:41:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581025273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fv7hocxnCQMQx/Ef0JfmL5g1BsW3yRUgDUYfbGA1aT0=;
        b=ViOeL+1ZjoDrxz13lmTOYScP3ob1/q4GMFHnSr1cZJhxnS68PZdDaXJplEV/J1p4nsf0rK
        uh5/GfL1iPU6pGQXPvyozGc7ShWkOmvPfTXRQXuWlRc39oBv3/df4TvstOPXSma1AZliXj
        rwieuOodHiZelqZZMBw8VtKyzGPmBtw=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-YrA24hWAP_m-5l3CgF8ymA-1; Thu, 06 Feb 2020 16:41:12 -0500
X-MC-Unique: YrA24hWAP_m-5l3CgF8ymA-1
Received: by mail-qt1-f199.google.com with SMTP id c10so159522qtk.18
        for <kvm-ppc@vger.kernel.org>; Thu, 06 Feb 2020 13:41:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fv7hocxnCQMQx/Ef0JfmL5g1BsW3yRUgDUYfbGA1aT0=;
        b=QX2Ul/1R++aLN9Y6a10EML+FRg0EiHztAB/RQXNqgVfzO7+XAHd5Gth1eaCyPJDx4/
         o5+Tzn99M0exKNTB2kgEBDUZISYZjq5pGIqgHBBkef2+y94DEm8Vpx2hxKnJ2+iqlnL2
         24wNaNC+Yz7zyHPXuYJEnPOC0zKCKWOI3cSzttLkRR1aVZkFwb/F/CyEvdpO5vADqECz
         cmClcJSVsAjFWteOvkbZ3+u56uzK8KeRdPGlr7Bdxfr3DXh6EluqBwNIvF0JINtpWulu
         +ydJKcF67Qr3FZnfHwltZix8qWifPJvD8CdyjK85LG6cCcZmrt00IcIi6z9Bv6GB9nLH
         cNXQ==
X-Gm-Message-State: APjAAAUm3dqztaZlBwQRfecvwmf9LLm0mcCUeYpEwsfA+e2RX+cusvsV
        fiwRNwP9r8uybYnwqpAkid+Z8zsd80M3mUQ3VXVwX2YjgbRXRWyrzjGuRQ8keqrfKkirsnOCcZG
        gJaBPQ/sdOXjxUqYGsQ==
X-Received: by 2002:a05:620a:7f2:: with SMTP id k18mr4541146qkk.207.1581025271641;
        Thu, 06 Feb 2020 13:41:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqxJgBpP+Sn/XW78feM1lgNrPZNv0ribzryOvpKTws4jf2FMfbWVePD88+Gb3lvt+IGO4p+aFA==
X-Received: by 2002:a05:620a:7f2:: with SMTP id k18mr4541080qkk.207.1581025270452;
        Thu, 06 Feb 2020 13:41:10 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id w9sm304509qka.71.2020.02.06.13.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 13:41:09 -0800 (PST)
Date:   Thu, 6 Feb 2020 16:41:06 -0500
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
Subject: Re: [PATCH v5 15/19] KVM: Provide common implementation for generic
 dirty log functions
Message-ID: <20200206214106.GG700495@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-16-sean.j.christopherson@intel.com>
 <20200206200200.GC700495@xz-x1>
 <20200206212120.GF13067@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200206212120.GF13067@linux.intel.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Feb 06, 2020 at 01:21:20PM -0800, Sean Christopherson wrote:
> On Thu, Feb 06, 2020 at 03:02:00PM -0500, Peter Xu wrote:
> > On Tue, Jan 21, 2020 at 02:31:53PM -0800, Sean Christopherson wrote:
> > 
> > [...]
> > 
> > > -int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm, struct kvm_clear_dirty_log *log)
> > > +void kvm_arch_dirty_log_tlb_flush(struct kvm *kvm,
> > > +				  struct kvm_memory_slot *memslot)
> > 
> > If it's to flush TLB for a memslot, shall we remove the "dirty_log" in
> > the name of the function, because it has nothing to do with dirty
> > logging any more?  And...
> 
> I kept the "dirty_log" to allow arch code to implement logic specific to a
> TLB flush during dirty logging, e.g. x86's lockdep assert on slots_lock.
> And similar to the issue with MIPS below, to deter usage of the hook for
> anything else, i.e. to nudge people to using kvm_flush_remote_tlbs()
> directly.

The x86's lockdep assert is not that important afaict, since the two
callers of the new tlb_flush() hook will be with slots_lock for sure.

> 
> > >  {
> > > -	struct kvm_memslots *slots;
> > > -	struct kvm_memory_slot *memslot;
> > > -	bool flush = false;
> > > -	int r;
> > > -
> > > -	mutex_lock(&kvm->slots_lock);
> > > -
> > > -	r = kvm_clear_dirty_log_protect(kvm, log, &flush);
> > > -
> > > -	if (flush) {
> > > -		slots = kvm_memslots(kvm);
> > > -		memslot = id_to_memslot(slots, log->slot);
> > > -
> > > -		/* Let implementation handle TLB/GVA invalidation */
> > > -		kvm_mips_callbacks->flush_shadow_memslot(kvm, memslot);
> > > -	}
> > > -
> > > -	mutex_unlock(&kvm->slots_lock);
> > > -	return r;
> > > +	/* Let implementation handle TLB/GVA invalidation */
> > > +	kvm_mips_callbacks->flush_shadow_memslot(kvm, memslot);
> > 
> > ... This may not directly related to the current patch, but I'm
> > confused on why MIPS cannot use kvm_flush_remote_tlbs() to flush TLBs.
> > I know nothing about MIPS code, but IIUC here flush_shadow_memslot()
> > is a heavier operation that will also invalidate the shadow pages.
> > Seems to be an overkill here when we only changed write permission of
> > the PTEs?  I tried to check the first occurance (2a31b9db15353) but I
> > didn't find out any clue of it so far.
> > 
> > But that matters to this patch because if MIPS can use
> > kvm_flush_remote_tlbs(), then we probably don't need this
> > arch-specific hook any more and we can directly call
> > kvm_flush_remote_tlbs() after sync dirty log when flush==true.
> 
> Ya, the asid_flush_mask in kvm_vz_flush_shadow_all() is the only thing
> that prevents calling kvm_flush_remote_tlbs() directly, but I have no
> clue as to the important of that code.

As said above I think the x86 lockdep is really not necessary, then
considering MIPS could be the only one that will use the new hook
introduced in this patch...  Shall we figure that out first?

Thanks,

-- 
Peter Xu

