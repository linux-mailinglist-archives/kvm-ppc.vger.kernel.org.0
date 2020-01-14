Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A42313B202
	for <lists+kvm-ppc@lfdr.de>; Tue, 14 Jan 2020 19:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgANSZM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 14 Jan 2020 13:25:12 -0500
Received: from mga04.intel.com ([192.55.52.120]:28001 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgANSZM (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 14 Jan 2020 13:25:12 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2020 10:25:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,319,1574150400"; 
   d="scan'208";a="225636474"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 14 Jan 2020 10:25:07 -0800
Date:   Tue, 14 Jan 2020 10:25:07 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v4 16/19] KVM: Ensure validity of memslot with respect to
 kvm_get_dirty_log()
Message-ID: <20200114182506.GF16784@linux.intel.com>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-17-sean.j.christopherson@intel.com>
 <20191224181930.GC17176@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224181930.GC17176@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Dec 24, 2019 at 01:19:30PM -0500, Peter Xu wrote:
> On Tue, Dec 17, 2019 at 12:40:38PM -0800, Sean Christopherson wrote:
> > +int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
> > +		      int *is_dirty, struct kvm_memory_slot **memslot)
> >  {
> >  	struct kvm_memslots *slots;
> > -	struct kvm_memory_slot *memslot;
> >  	int i, as_id, id;
> >  	unsigned long n;
> >  	unsigned long any = 0;
> >  
> > +	*memslot = NULL;
> > +	*is_dirty = 0;
> > +
> >  	as_id = log->slot >> 16;
> >  	id = (u16)log->slot;
> >  	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
> >  		return -EINVAL;
> >  
> >  	slots = __kvm_memslots(kvm, as_id);
> > -	memslot = id_to_memslot(slots, id);
> > -	if (!memslot->dirty_bitmap)
> > +	*memslot = id_to_memslot(slots, id);
> > +	if (!(*memslot)->dirty_bitmap)
> >  		return -ENOENT;
> >  
> > -	n = kvm_dirty_bitmap_bytes(memslot);
> > +	kvm_arch_sync_dirty_log(kvm, *memslot);
> 
> Should this line belong to previous patch?

No.

The previous patch, "KVM: Provide common implementation for generic dirty
log functions", is consolidating the implementation of dirty log functions
for architectures with CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y.

This code is being moved from s390's kvm_vm_ioctl_get_dirty_log(), as s390
doesn't select KVM_GENERIC_DIRTYLOG_READ_PROTECT.  It's functionally a nop
as kvm_arch_sync_dirty_log() is empty for PowerPC, the only other arch that
doesn't select KVM_GENERIC_DIRTYLOG_READ_PROTECT.

Arguably, the call to kvm_arch_sync_dirty_log() should be moved in a
separate prep patch.  It can't be a follow-on patch as that would swap the
ordering of kvm_arch_sync_dirty_log() and kvm_dirty_bitmap_bytes(), etc...

My reasoning for not splitting it to a separate patch is that prior to this
patch, the common code and arch specific code are doing separate memslot
lookups via id_to_memslot(), i.e. moving the kvm_arch_sync_dirty_log() call
would operate on a "different" memslot.   It can't actually be a different
memslot because slots_lock is held, it just felt weird.

All that being said, I don't have a strong opinion on moving the call to
kvm_arch_sync_dirty_log() in a separate patch; IIRC, I vascillated between
the two options when writing the code.  If anyone wants it to be a separate
patch I'll happily split it out.

> 
> > +
> > +	n = kvm_dirty_bitmap_bytes(*memslot);
> >  
> >  	for (i = 0; !any && i < n/sizeof(long); ++i)
> > -		any = memslot->dirty_bitmap[i];
> > +		any = (*memslot)->dirty_bitmap[i];
> >  
> > -	if (copy_to_user(log->dirty_bitmap, memslot->dirty_bitmap, n))
> > +	if (copy_to_user(log->dirty_bitmap, (*memslot)->dirty_bitmap, n))
> >  		return -EFAULT;
> >  
> >  	if (any)
> > -- 
> > 2.24.1
> 
> -- 
> Peter Xu
> 
